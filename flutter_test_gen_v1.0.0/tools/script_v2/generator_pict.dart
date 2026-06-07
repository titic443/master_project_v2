import 'dart:convert';
import 'dart:io';

import 'utils.dart' as utils;

class GeneratorPict {
  final String pictBin;

  GeneratorPict({String? pictBin}) : pictBin = pictBin ?? _defaultBin();

  // Use Linux pict from image when running inside Docker container,
  // macOS project-root binary otherwise.
  static String _defaultBin() =>
      File('/.dockerenv').existsSync() ? '/usr/local/bin/pict' : './pict';

  String generatePictModel(
    Map<String, List<String>> factors, {
    String? constraints,
  }) {
    return _buildPictModel(
      factors,
      constraints: constraints,
      filter: _PictModelFilter.full,
    );
  }

  // Invalid-only model: every TextField factor carries only the `invalid`
  // sentinel, so all PICT combinations are guaranteed to contain at least
  // one invalid field. Non-text factors keep their full value list so
  // pairwise coverage across options is still preserved.
  String generateInvalidOnlyPictModel(
    Map<String, List<String>> factors, {
    String? constraints,
  }) {
    return _buildPictModel(
      factors,
      constraints: constraints,
      filter: _PictModelFilter.invalidOnly,
    );
  }

  // Valid-only model: TextFields keep only `valid`, required checkboxes keep
  // only `checked`, and non-text factors drop the `null` sentinel and past
  // dates so the resulting combinations represent real success-path inputs.
  String generateValidOnlyPictModel(
    Map<String, List<String>> factors, {
    Set<String> requiredCheckboxes = const {},
    Map<String, Set<String>> invalidOnlyValues = const {},
    String? constraints,
  }) {
    return _buildPictModel(
      factors,
      constraints: constraints,
      filter: _PictModelFilter.validOnly,
      requiredCheckboxes: requiredCheckboxes,
      invalidOnlyValues: invalidOnlyValues,
    );
  }

  String _buildPictModel(
    Map<String, List<String>> factors, {
    required _PictModelFilter filter,
    Set<String> requiredCheckboxes = const {},
    Map<String, Set<String>> invalidOnlyValues = const {},
    String? constraints,
  }) {
    final buffer = StringBuffer();
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);

    for (final entry in factors.entries) {
      final values = _filterFactorValues(
        factorName: entry.key,
        values: entry.value,
        filter: filter,
        requiredCheckboxes: requiredCheckboxes,
        invalidOnlyValues: invalidOnlyValues,
        todayOnly: todayOnly,
      );
      if (values.isEmpty) continue;
      buffer.writeln('${entry.key}: ${_formatValuesForModel(entry.key, values)}');
    }

    // Forward Format B (IF/THEN) constraints to PICT. Format A lines
    // (`key = value` / `key.slot = value`) are dataset overrides consumed by
    // generate_test_data.dart and MUST NOT reach PICT.
    final pictLines = _extractPictConstraintLines(constraints);
    if (pictLines.isNotEmpty) {
      buffer.writeln('');
      buffer.writeln(pictLines);
    }
    return buffer.toString();
  }

  List<String> _filterFactorValues({
    required String factorName,
    required List<String> values,
    required _PictModelFilter filter,
    required Set<String> requiredCheckboxes,
    Map<String, Set<String>> invalidOnlyValues = const {},
    required DateTime todayOnly,
  }) {
    // A "TextField factor" is one whose value list contains both 'valid' and
    // 'invalid' sentinels. We use this content-based detection rather than
    // factor-name suffixes to stay in sync with how factors are emitted.
    final isTextField = values.contains('valid') && values.contains('invalid');

    switch (filter) {
      case _PictModelFilter.full:
        return List.of(values);

      case _PictModelFilter.invalidOnly:
        if (isTextField) {
          return values.where((v) => v != 'valid').toList();
        }
        return List.of(values);

      case _PictModelFilter.validOnly:
        final invalidOnly = invalidOnlyValues[factorName] ?? const <String>{};
        if (isTextField) {
          return values.where((v) => v != 'invalid' && !invalidOnly.contains(v)).toList();
        }
        if (requiredCheckboxes.contains(factorName)) {
          return values.where((v) => v != 'unchecked' && !invalidOnly.contains(v)).toList();
        }
        // Non-text factors (Radio, Dropdown, DatePicker, TimePicker, optional
        // Checkbox, Switch, Slider): exclude 'null', past dates, and any
        // factor-specific invalid-only values (e.g. 'unselected', 'off' for
        // required switch, min value for required slider).
        return values.where((v) {
          if (v == 'null') return false;
          if (invalidOnly.contains(v)) return false;
          final parts = v.split('/');
          if (parts.length == 3) {
            final d = int.tryParse(parts[0]);
            final m = int.tryParse(parts[1]);
            final y = int.tryParse(parts[2]);
            if (d != null && m != null && y != null) {
              return !DateTime(y, m, d).isBefore(todayOnly);
            }
          }
          return true;
        }).toList();
    }
  }

  // Filters out Format A lines (dataset overrides) and returns only
  // Format B (IF/THEN) lines that PICT can consume.
  String _extractPictConstraintLines(String? constraints) {
    if (constraints == null || constraints.trim().isEmpty) return '';
    return constraints
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty && !l.startsWith('#'))
        .where((l) {
          final up = l.toUpperCase();
          return up.contains('IF') && up.contains('THEN');
        })
        .join('\n');
  }

  // Detection is value-content-based (not factor-name-based):
  // "Bucket" factors (text fields, switches, checkboxes) use symbolic sentinel
  // values like 'valid'/'invalid'/'on'/'off'/'checked'/'unchecked' — plain
  // ASCII that PICT can parse unquoted. All other factors (dropdowns, radios)
  // carry actual option values that may contain Thai characters, spaces, or
  // special strings like "4+" and MUST be quoted for PICT compatibility.
  String _formatValuesForModel(String factorName, List<String> values) {
    const bucketValues = {'valid', 'invalid', 'on', 'off', 'checked', 'unchecked'};
    final isBucketFactor = values.any((v) => bucketValues.contains(v));
    if (isBucketFactor) {
      return values.join(', ');
    }
    final quoted = values.map((v) {
      final escaped = v.replaceAll('"', '\\"');
      return '"$escaped"';
    }).toList();
    return quoted.join(', ');
  }

  Future<List<Map<String, String>>> executePict(
    Map<String, List<String>> factors, {
    String? constraints,
  }) async {
    if (factors.isEmpty) return const [];

    final modelContent = generatePictModel(factors, constraints: constraints);

    final tmpDir = Directory('.dart_tool');
    if (!tmpDir.existsSync()) {
      tmpDir.createSync(recursive: true);
    }
    final modelPath = '.dart_tool/pairwise_model.tmp.txt';
    File(modelPath).writeAsStringSync(modelContent);

    final result = await Process.run(pictBin, [modelPath]);
    if (result.exitCode != 0) {
      throw Exception('PICT exit code ${result.exitCode}: ${result.stderr}');
    }

    final output = (result.stdout is String)
        ? (result.stdout as String)
        : String.fromCharCodes((result.stdout as List<int>));

    return parsePictResult(output);
  }

  List<Map<String, String>> parsePictResult(String content) {
    final lines = content.trim().split(RegExp(r'\r?\n')).where((l) => l.trim().isNotEmpty).toList();
    if (lines.isEmpty) return const [];

    final header = lines.first.split('\t').map((s) => s.trim()).toList();
    final combos = <Map<String, String>>[];

    for (int i = 1; i < lines.length; i++) {
      final cols = lines[i].split('\t');
      if (cols.length != header.length) continue;

      final combination = <String, String>{};
      for (int c = 0; c < header.length; c++) {
        combination[header[c]] = cols[c].trim();
      }
      combos.add(combination);
    }

    return combos;
  }

  Map<String, List<String>> parsePictModel(String content) {
    final factors = <String, List<String>>{};
    final lines = content.trim().split(RegExp(r'\r?\n')).where((l) => l.trim().isNotEmpty).toList();

    for (final line in lines) {
      if (line.trim().isEmpty || line.trim().startsWith('#')) continue;

      final colonIdx = line.indexOf(':');
      if (colonIdx == -1) continue;

      final factorName = line.substring(0, colonIdx).trim();
      final valuesStr = line.substring(colonIdx + 1).trim();

      final values = <String>[];
      final parts = valuesStr.split(',');

      for (final part in parts) {
        var value = part.trim();
        if (value.startsWith('"') && value.endsWith('"')) {
          value = value.substring(1, value.length - 1);
        }
        if (value.isNotEmpty) {
          values.add(value);
        }
      }

      if (factorName.isNotEmpty && values.isNotEmpty) {
        factors[factorName] = values;
      }
    }

    return factors;
  }

  // Returns null if valid, or an error message string if invalid.
  String? validateConstraintsSyntax(String constraints) {
    final lines = constraints.split('\n');

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      final lineNum = i + 1;

      if (line.isEmpty || line.startsWith('#')) continue;

      final hasIf = line.contains('IF');
      final hasThen = line.contains('THEN');

      if (!hasIf && !hasThen) {
        if (!RegExp(r'^[\w.]+\s*=\s*.+$').hasMatch(line)) {
          return 'Line $lineNum: Expected "key = value", "key.slot = value", or PICT "IF [...] = "..." THEN [...] = "...";"\n"$line"';
        }
        continue;
      }

      final thenIndex = line.indexOf('THEN');
      final ifPart = line.substring(0, thenIndex);
      final thenPart = line.substring(thenIndex);

      if (!RegExp(r'\[.+?\]').hasMatch(ifPart)) {
        return 'Line $lineNum: IF parameter must be in [brackets]\n"$line"';
      }
      if (!RegExp(r'\[.+?\]').hasMatch(thenPart)) {
        return 'Line $lineNum: THEN parameter must be in [brackets]\n"$line"';
      }
      if (!RegExp(r'".+?"').hasMatch(ifPart)) {
        return 'Line $lineNum: IF value must be in "quotes"\n"$line"';
      }
      if (!RegExp(r'".+?"').hasMatch(thenPart)) {
        return 'Line $lineNum: THEN value must be in "quotes"\n"$line"';
      }
      if (!line.endsWith(';')) {
        return 'Line $lineNum: Constraint must end with ;\n"$line"';
      }
    }

    return null;
  }

  List<String> readFactorNamesFromModel(String modelFilePath) {
    final file = File(modelFilePath);
    if (!file.existsSync()) return [];

    final content = file.readAsStringSync();
    final factors = parsePictModel(content);
    return factors.keys.toList();
  }

  FactorExtractionResult extractFactorsFromManifest(List<Map<String, dynamic>> widgets) {
    final factors = <String, List<String>>{};
    final requiredCheckboxes = <String>{};
    final invalidOnlyValues = <String, Set<String>>{};

    final radioGroups = <String, String>{};
    final radioGroupHasValidator = <String, bool>{};

    for (final w in widgets) {
      final widgetType = (w['widgetType'] ?? '').toString();
      final key = (w['key'] ?? '').toString();

      final isTextField = widgetType.startsWith('TextFormField') || widgetType.startsWith('TextField');
      if (isTextField && key.isNotEmpty) {
        factors[key] = ['valid', 'invalid'];
      }

      if (widgetType.startsWith('Radio<') && key.isNotEmpty) {
        final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? const {};
        final groupValue = meta['groupValueBinding']?.toString() ?? '';

        String factorName;
        if (radioGroups.containsKey(groupValue)) {
          factorName = radioGroups[groupValue]!;
        } else {
          factorName = groupValue.isNotEmpty ? groupValue : _extractRadioGroupName(key);
          radioGroups[groupValue] = factorName;
          factors[factorName] = <String>[];
        }

        final rules = (meta['validatorRules'] as List?) ?? const [];
        if (rules.isNotEmpty) {
          radioGroupHasValidator[factorName] = true;
        }

        final suffix = _extractRadioKeySuffix(key);
        if (suffix.isNotEmpty) {
          final list = factors[factorName]!..remove(suffix);
          list.add(suffix);
        }
        continue;
      }

      if (widgetType.startsWith('DropdownButtonFormField') && key.isNotEmpty) {
        final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? const {};
        final items = _extractOptionsFromMeta(meta['options']);
        if (items.isNotEmpty) {
          factors[key] = items;
        }
        continue;
      }

      // FormField<bool> is a wrapper widget — skip it as a factor, but inspect
      // its validator to determine if the inner Checkbox is required.
      if (widgetType == 'Checkbox' && key.isNotEmpty) {
        factors[key] = ['checked', 'unchecked'];
      }

      if ((widgetType == 'Switch' || widgetType == 'SwitchListTile') && key.isNotEmpty) {
        factors[key] = ['on', 'off'];
        final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? const {};
        final rules = (meta['validatorRules'] as List?) ?? const [];
        for (final rule in rules) {
          if (rule is Map) {
            final norm = (rule['condition']?.toString() ?? '')
                .toLowerCase()
                .replaceAll(' ', '');
            if (norm.contains('!value') ||
                norm.contains('value==false') ||
                norm.contains('value==null') ||
                norm.contains('value!=true')) {
              invalidOnlyValues.putIfAbsent(key, () => {}).add('off');
              break;
            }
          }
        }
      }

      if (widgetType == 'Slider' && key.isNotEmpty) {
        final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? const {};
        final min = (meta['min'] as num?)?.toDouble() ?? 0.0;
        final max = (meta['max'] as num?)?.toDouble() ?? 100.0;
        final mid = (min + max) / 2;
        final minStr = min.round().toString();

        factors[key] = [
          minStr,
          mid.round().toString(),
          max.round().toString(),
        ];

        final rules = (meta['validatorRules'] as List?) ?? const [];
        if (rules.isNotEmpty) {
          invalidOnlyValues.putIfAbsent(key, () => {}).add(minStr);
        }
      }

      final pickerMeta = (w['pickerMetadata'] as Map?)?.cast<String, dynamic>();
      if (pickerMeta != null && key.isNotEmpty) {
        final pickerType = (pickerMeta['type'] ?? '').toString();

        if (pickerType == 'DatePicker') {
          factors[key] = ['valid', 'invalid'];
        } else if (pickerType == 'TimePicker') {
          factors[key] = ['valid', 'invalid'];
        }
      }

      if (widgetType.startsWith('FormField<bool>') && key.isNotEmpty) {
        final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? const {};
        final rules = (meta['validatorRules'] as List?)?.cast<dynamic>() ?? const [];

        for (final rule in rules) {
          if (rule is Map) {
            final condition = rule['condition']?.toString() ?? '';
            final normalized = condition.toLowerCase().replaceAll(' ', '');
            if (normalized.contains('!value') ||
                normalized.contains('value==false') ||
                (normalized.contains('value==null') && normalized.contains('||!value'))) {
              // Derive the associated Checkbox key from the FormField<bool> key.
              // Convention: `..._formfield` → `..._checkbox`.
              final checkboxKey = key.replaceAll('_formfield', '_checkbox');
              requiredCheckboxes.add(checkboxKey);
              break;
            }
          }
        }
        continue;
      }
    }

    // Add 'unselected' sentinel to Radio groups that have validatorRules
    for (final entry in radioGroupHasValidator.entries) {
      if (entry.value) {
        final list = factors[entry.key];
        if (list != null && !list.contains('unselected')) {
          list.insert(0, 'unselected');
          invalidOnlyValues.putIfAbsent(entry.key, () => {}).add('unselected');
        }
      }
    }

    return FactorExtractionResult(
      factors: factors,
      requiredCheckboxes: requiredCheckboxes,
      invalidOnlyValues: invalidOnlyValues,
    );
  }

  String _extractRadioGroupName(String radioKey) {
    final parts = radioKey.split('_');
    if (parts.length > 2) {
      int descStartIdx = 2;
      if (parts.length > 1 && int.tryParse(parts[1]) != null) {
        descStartIdx = 2;
      }

      int descEndIdx = parts.length - 2;
      if (parts.last == 'radio' && parts.length > 3) {
        descEndIdx = parts.length - 2;
      }

      if (descStartIdx < descEndIdx) {
        final description = parts[descStartIdx];
        return '${description}_radio_group';
      }
    }
    return 'radio_group';
  }

  String _extractRadioKeySuffix(String radioKey) {
    final parts = radioKey.split('_');
    if (parts.length > 2) {
      return parts.skip(2).join('_');
    }
    return radioKey;
  }

  List<String> _extractOptionsFromMeta(dynamic raw) {
    final out = <String>[];
    if (raw is List) {
      for (final entry in raw) {
        if (entry is Map) {
          final value = entry['value']?.toString();
          final text = entry['text']?.toString();
          final label = entry['label']?.toString();
          final chosen = (value != null && value.isNotEmpty) ? value
                       : (text != null && text.isNotEmpty) ? text
                       : label;
          if (chosen != null && chosen.isNotEmpty) {
            final cleaned = chosen.replaceAll(' ', '_');
            out.add(cleaned);
          }
        } else if (entry != null) {
          final s = entry.toString();
          if (s.isNotEmpty) {
            final cleaned = s.replaceAll(' ', '_');
            out.add(cleaned);
          }
        }
      }
    }
    return out;
  }

  Future<void> writePictModelFiles({
    required Map<String, List<String>> factors,
    required String pageBaseName,
    Set<String> requiredCheckboxes = const {},
    Map<String, Set<String>> invalidOnlyValues = const {},
    String? constraints,
  }) async {
    if (factors.isEmpty) return;

    stderr.writeln('[DEBUG] writePictModelFiles - constraints: '
        '${constraints == null ? "NULL" : "present (${constraints.length} chars)"}');

    final modelContent = generateInvalidOnlyPictModel(factors, constraints: constraints);
    final validModelContent = generateValidOnlyPictModel(
      factors,
      requiredCheckboxes: requiredCheckboxes,
      invalidOnlyValues: invalidOnlyValues,
      constraints: constraints,
    );

    final outputDir = Directory('output/model_pairwise');
    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
    }

    final outPageModel = 'output/model_pairwise/$pageBaseName.invalid.model.txt';
    final outPageValidModel = 'output/model_pairwise/$pageBaseName.valid.model.txt';
    File(outPageModel).writeAsStringSync(modelContent);
    File(outPageValidModel).writeAsStringSync(validModelContent);

    await _executePictToFile(
      outPageModel,
      'output/model_pairwise/$pageBaseName.invalid.result.txt',
    );
    await _executePictToFile(
      outPageValidModel,
      'output/model_pairwise/$pageBaseName.valid.result.txt',
    );

    // Post-process: enforce IF/THEN constraints by filtering out any violating
    // rows that PICT may have silently left in (observed with quoted values on
    // some PICT builds on macOS arm64).
    if (constraints != null && constraints.trim().isNotEmpty) {
      _filterResultFile(
        'output/model_pairwise/$pageBaseName.invalid.result.txt',
        constraints,
      );
      _filterResultFile(
        'output/model_pairwise/$pageBaseName.valid.result.txt',
        constraints,
      );
    }
  }

  Future<void> _executePictToFile(String modelPath, String outputPath) async {
    try {
      final result = await Process.run(pictBin, [modelPath]);
      if (result.exitCode == 0) {
        final output = (result.stdout is String)
            ? (result.stdout as String)
            : String.fromCharCodes((result.stdout as List<int>));
        File(outputPath).writeAsStringSync(output);
      } else {
        stderr.writeln('! PICT failed for $modelPath: ${result.stderr}');
      }
    } catch (e) {
      stderr.writeln('! PICT execution error for $modelPath: $e');
    }
  }

  // Greedy set-cover fallback used when the PICT binary is unavailable.
  List<Map<String, String>> generatePairwiseInternal(Map<String, List<String>> factors) {
    if (factors.isEmpty) return const [];

    final names = factors.keys.toList();
    if (names.length <= 1) {
      if (names.isEmpty) return const [];
      return factors[names[0]]!.map((v) => {names[0]: v}).toList();
    }

    final requiredPairs = <String>{};
    for (int i = 0; i < names.length; i++) {
      for (int j = i + 1; j < names.length; j++) {
        final factor1 = names[i];
        final factor2 = names[j];
        for (final val1 in factors[factor1]!) {
          for (final val2 in factors[factor2]!) {
            requiredPairs.add('$factor1=$val1|$factor2=$val2');
          }
        }
      }
    }

    final allCases = <Map<String, String>>[];
    void generateAllCombinations(int factorIndex, Map<String, String> current) {
      if (factorIndex == names.length) {
        allCases.add(Map.from(current));
        return;
      }

      final factorName = names[factorIndex];
      for (final value in factors[factorName]!) {
        current[factorName] = value;
        generateAllCombinations(factorIndex + 1, current);
      }
    }
    generateAllCombinations(0, {});

    final selectedCases = <Map<String, String>>[];
    final coveredPairs = <String>{};

    while (coveredPairs.length < requiredPairs.length && allCases.isNotEmpty) {
      Map<String, String>? bestCase;
      int bestScore = -1;

      for (final testCase in allCases) {
        int score = 0;

        for (int i = 0; i < names.length; i++) {
          for (int j = i + 1; j < names.length; j++) {
            final factor1 = names[i];
            final factor2 = names[j];
            final pairKey = '$factor1=${testCase[factor1]}|$factor2=${testCase[factor2]}';
            if (!coveredPairs.contains(pairKey)) {
              score++;
            }
          }
        }

        if (score > bestScore) {
          bestScore = score;
          bestCase = testCase;
        }
      }

      if (bestCase == null) break;

      selectedCases.add(bestCase);
      allCases.remove(bestCase);

      for (int i = 0; i < names.length; i++) {
        for (int j = i + 1; j < names.length; j++) {
          final factor1 = names[i];
          final factor2 = names[j];
          final pairKey = '$factor1=${bestCase[factor1]}|$factor2=${bestCase[factor2]}';
          coveredPairs.add(pairKey);
        }
      }
    }

    return selectedCases;
  }

  Future<PairwiseResult> generatePairwiseFromManifest({
    required String manifestPath,
    required String uiFilePath,
    bool usePict = true,
    String? constraints,
  }) async {
    final manifestFile = File(manifestPath);
    if (!manifestFile.existsSync()) {
      throw Exception('Manifest not found: $manifestPath');
    }

    final manifestJson = jsonDecode(manifestFile.readAsStringSync()) as Map<String, dynamic>;
    final widgets = (manifestJson['widgets'] as List? ?? const []).cast<Map<String, dynamic>>();

    final extractionResult = extractFactorsFromManifest(widgets);
    final factors = extractionResult.factors;
    final requiredCheckboxes = extractionResult.requiredCheckboxes;

    if (factors.isEmpty) {
      return PairwiseResult(
        combinations: [],
        validCombinations: [],
        factors: {},
        method: 'none',
      );
    }

    final pageBase = utils.basenameWithoutExtension(uiFilePath);
    await writePictModelFiles(
      factors: factors,
      pageBaseName: pageBase,
      requiredCheckboxes: requiredCheckboxes,
      constraints: constraints,
    );

    List<Map<String, String>> combinations;
    List<Map<String, String>> validCombinations;
    String method;

    if (usePict) {
      try {
        combinations = await executePict(factors, constraints: constraints);

        final validFactors = <String, List<String>>{};
        for (final entry in factors.entries) {
          if (entry.key.startsWith('TEXT')) {
            validFactors[entry.key] = ['valid'];
          } else {
            validFactors[entry.key] = entry.value;
          }
        }
        validCombinations = await executePict(validFactors, constraints: constraints);
        method = 'pict';
      } catch (e) {
        stderr.writeln('! PICT failed: $e. Using internal algorithm.');
        combinations = generatePairwiseInternal(factors);
        validCombinations = [];
        method = 'internal';
      }
    } else {
      combinations = generatePairwiseInternal(factors);
      validCombinations = [];
      method = 'internal';
    }

    return PairwiseResult(
      combinations: combinations,
      validCombinations: validCombinations,
      factors: factors,
      method: method,
    );
  }

  // Safety net for PICT builds that silently ignore IF/THEN constraints when
  // values are quoted (observed on macOS arm64). Supported operators: = and <>.
  List<Map<String, String>> filterCombosAgainstConstraints(
    List<Map<String, String>> combos,
    String constraints,
  ) {
    if (combos.isEmpty || constraints.trim().isEmpty) return combos;

    final rules = <_ConstraintRule>[];
    int skippedComplex = 0;
    int skippedUnparsed = 0;

    for (final rawLine in constraints.split('\n')) {
      final line = rawLine.trim();
      if (line.isEmpty || line.startsWith('#')) continue;

      final up = line.toUpperCase();
      if (!up.contains('IF') || !up.contains('THEN')) continue;

      // Multi-clause constraints (AND/OR, multiple THENs) are NOT supported by
      // this Dart-side filter. We deliberately surface them so the user
      // doesn't think a complex constraint is being enforced silently — PICT
      // itself may still apply them when it doesn't have the macOS bug.
      final thenCount = 'THEN'.allMatches(up).length;
      if (thenCount > 1 ||
          up.contains(' AND ') ||
          up.contains(' OR ') ||
          up.contains('&&') ||
          up.contains('||')) {
        skippedComplex++;
        stderr.writeln('[WARN] filterCombosAgainstConstraints: '
            'skipping complex constraint (multi-clause not supported by '
            'post-processing filter): $line');
        continue;
      }

      final thenIdx = up.indexOf('THEN');
      final ifPart = line.substring(0, thenIdx).trim();
      final thenPart = line.substring(thenIdx + 4).trim();

      final re = RegExp(r'\[(.+?)\]\s*(<>|=)\s*"(.+?)"', caseSensitive: false);
      final ifM = re.firstMatch(ifPart);
      final thenM = re.firstMatch(thenPart);
      if (ifM == null || thenM == null) {
        skippedUnparsed++;
        stderr.writeln('[WARN] filterCombosAgainstConstraints: '
            'could not parse constraint (expected `IF [k] (=|<>) "v" THEN '
            '[k] (=|<>) "v";`): $line');
        continue;
      }

      rules.add(_ConstraintRule(
        ifFactor: ifM.group(1)!,
        ifOp: ifM.group(2)!,
        ifValue: ifM.group(3)!,
        thenFactor: thenM.group(1)!,
        thenOp: thenM.group(2)!,
        thenValue: thenM.group(3)!,
      ));
    }

    if (rules.isEmpty) {
      if (skippedComplex + skippedUnparsed > 0) {
        stderr.writeln('[INFO] filterCombosAgainstConstraints: no rules '
            'enforceable (complex=$skippedComplex, unparsed=$skippedUnparsed)');
      }
      return combos;
    }

    // Strip surrounding quotes from a combo cell.
    String unquote(String v) {
      if (v.length >= 2 &&
          ((v.startsWith('"') && v.endsWith('"')) ||
              (v.startsWith("'") && v.endsWith("'")))) {
        return v.substring(1, v.length - 1);
      }
      return v;
    }

    // Normalize for comparison: lowercase + collapse the underscore↔space
    // substitution that PICT model emission performs on dropdown options
    // (see _formatValuesForModel) so that a constraint written as "IT & Tech"
    // matches a PICT cell "IT_&_Tech".
    String norm(String v) =>
        unquote(v).toLowerCase().replaceAll('_', ' ').trim();

    bool satisfies(Map<String, String> combo, _ConstraintRule r) {
      // Compare factor keys case-insensitively (PICT preserves whatever case
      // we wrote in the model; we control both sides but be defensive).
      String? cellFor(String factor) {
        if (combo.containsKey(factor)) return combo[factor];
        for (final entry in combo.entries) {
          if (entry.key.toLowerCase() == factor.toLowerCase()) {
            return entry.value;
          }
        }
        return null;
      }

      final ifVal = norm(cellFor(r.ifFactor) ?? '');
      final ifTarget = norm(r.ifValue);
      final ifMet = r.ifOp == '=' ? ifVal == ifTarget : ifVal != ifTarget;
      if (!ifMet) return true; // antecedent false → constraint vacuously holds

      final thenVal = norm(cellFor(r.thenFactor) ?? '');
      final thenTarget = norm(r.thenValue);
      return r.thenOp == '='
          ? thenVal == thenTarget
          : thenVal != thenTarget;
    }

    final filtered =
        combos.where((c) => rules.every((r) => satisfies(c, r))).toList();

    if (filtered.length < combos.length) {
      stderr.writeln('[INFO] filterCombosAgainstConstraints: removed '
          '${combos.length - filtered.length} constraint-violating row(s) '
          '(applied ${rules.length} rule(s))');
    }

    return filtered;
  }

  void _filterResultFile(String resultPath, String constraints) {
    final file = File(resultPath);
    if (!file.existsSync()) return;

    final content = file.readAsStringSync();
    if (content.trim().isEmpty) return;

    final lines = content.trim().split(RegExp(r'\r?\n'));
    if (lines.length < 2) return;

    final header  = lines.first;
    final headers = header.split('\t').map((s) => s.trim()).toList();

    final combos = <Map<String, String>>[];
    for (int i = 1; i < lines.length; i++) {
      if (lines[i].trim().isEmpty) continue;
      final cols = lines[i].split('\t');
      if (cols.length != headers.length) continue;
      final m = <String, String>{};
      for (int c = 0; c < headers.length; c++) {
        m[headers[c]] = cols[c].trim();
      }
      combos.add(m);
    }

    final filtered = filterCombosAgainstConstraints(combos, constraints);
    if (filtered.length == combos.length) return;

    final outLines = [
      header,
      ...filtered.map((row) => headers.map((h) => row[h] ?? '').join('\t')),
    ];
    file.writeAsStringSync('${outLines.join('\n')}\n');
    stderr.writeln('[INFO] _filterResultFile: rewrote $resultPath '
        '(${combos.length} → ${filtered.length} rows)');
  }
}

enum _PictModelFilter { full, invalidOnly, validOnly }

class _ConstraintRule {
  final String ifFactor, ifOp, ifValue, thenFactor, thenOp, thenValue;
  const _ConstraintRule({
    required this.ifFactor,
    required this.ifOp,
    required this.ifValue,
    required this.thenFactor,
    required this.thenOp,
    required this.thenValue,
  });
}

class FactorExtractionResult {
  final Map<String, List<String>> factors;
  final Set<String> requiredCheckboxes;
  // factorName → values that are invalid-only (must be excluded from valid model)
  final Map<String, Set<String>> invalidOnlyValues;

  FactorExtractionResult({
    required this.factors,
    required this.requiredCheckboxes,
    this.invalidOnlyValues = const {},
  });
}

class PairwiseResult {
  final List<Map<String, String>> combinations;
  final List<Map<String, String>> validCombinations;
  final Map<String, List<String>> factors;
  final String method;

  PairwiseResult({
    required this.combinations,
    required this.validCombinations,
    required this.factors,
    required this.method,
  });
}
