// PICT Pairwise Combinatorial Testing Module
//
// This module provides utilities for generating pairwise test combinations using:
// 1. External PICT binary (Microsoft PICT tool)
// 2. Internal pairwise algorithm (fallback when PICT unavailable)
//
// Key Features:
// - Generate PICT model files from UI manifests
// - Execute PICT binary and parse results
// - Internal pairwise generation algorithm
// - Support for factors: TEXT fields, Radio groups, Dropdowns

import 'dart:convert';
import 'dart:io';

import 'utils.dart' as utils;

// ============================================================================
// GeneratorPict Class
// ============================================================================

class GeneratorPict {
  final String pictBin;

  GeneratorPict({String? pictBin}) : pictBin = pictBin ?? _defaultBin();

  // Use Linux pict from image when running inside Docker container,
  // macOS project-root binary otherwise.
  static String _defaultBin() =>
      File('/.dockerenv').existsSync() ? '/usr/local/bin/pict' : './pict';

  // ==========================================================================
  // PICT Model Generation
  // ==========================================================================

  /// Generate a PICT model from a factors map with optional constraints.
  ///
  /// Example input:
  /// ```dart
  /// {
  ///   'TEXT': ['valid', 'invalid'],
  ///   'Radio1': ['yes', 'no'],
  ///   'Dropdown': ['option1', 'option2', 'option3'],
  /// }
  /// ```
  ///
  /// Output:
  /// ```
  /// TEXT: valid, invalid
  /// Radio1: yes, no
  /// Dropdown: "option1", "option2", "option3"
  ///
  /// IF [Type] = "RAID-5" THEN [Compression] = "Off";
  /// ```
  ///
  /// All three model variants (`full`, `invalid-only`, `valid-only`) share the
  /// same emission code path — see [_buildPictModel] for the deduplicated
  /// implementation. The public methods only differ in their per-factor value
  /// filtering policy.
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

  /// Invalid-only model — every TextField factor carries only the `invalid`
  /// sentinel, so all PICT combinations are guaranteed to contain at least
  /// one invalid field. Non-text factors (Dropdown, Switch, Checkbox, Radio)
  /// keep their full value list so pairwise coverage across options is still
  /// preserved.
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

  /// Valid-only model — TextFields keep only `valid`, required checkboxes keep
  /// only `checked`, and non-text factors drop the `null` sentinel and past
  /// dates so the resulting combinations represent real success-path inputs.
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

  /// Shared model emitter used by [generatePictModel],
  /// [generateInvalidOnlyPictModel], and [generateValidOnlyPictModel].
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

  /// Per-factor value filter mirroring the legacy three-method behavior.
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

  /// Extract Format B (IF/THEN) lines from a constraint string — Format A
  /// lines (dataset overrides) are filtered out. Returns the joined lines or
  /// an empty string if no PICT constraints were found.
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

  /// Format values for PICT model syntax.
  ///
  /// Detection is value-content-based (not factor-name-based):
  /// - "Bucket" factors (text fields, switches, checkboxes) use symbolic sentinel
  ///   values like 'valid'/'invalid'/'on'/'off'/'checked'/'unchecked'.
  ///   These are plain ASCII and do NOT need quoting.
  /// - All other factors (dropdowns, radios) carry actual option values which may
  ///   contain Thai characters, spaces, or special strings like "4+" that PICT
  ///   cannot parse without double-quotes. These MUST be quoted.
  String _formatValuesForModel(String factorName, List<String> values) {
    const bucketValues = {'valid', 'invalid', 'on', 'off', 'checked', 'unchecked'};
    final isBucketFactor = values.any((v) => bucketValues.contains(v));
    if (isBucketFactor) {
      return values.join(', ');
    }
    // Dropdown / radio actual option values — quote for PICT compatibility
    // (handles Thai characters, spaces, "4+", and other special strings)
    final quoted = values.map((v) {
      final escaped = v.replaceAll('"', '\\"');
      return '"$escaped"';
    }).toList();
    return quoted.join(', ');
  }

  // ==========================================================================
  // PICT Execution
  // ==========================================================================

  /// Execute PICT binary to generate pairwise combinations
  ///
  /// Parameters:
  /// - factors: Map of factor names to their possible values
  /// - constraints: Optional PICT constraints
  ///
  /// Returns: List of test case combinations as Maps
  ///
  /// Example:
  /// ```dart
  /// final combos = await executePict({
  ///   'TEXT': ['valid', 'invalid'],
  ///   'Radio1': ['yes', 'no']
  /// }, constraints: 'IF [TEXT] = "invalid" THEN [Radio1] = "no";');
  /// // Result: [{'TEXT': 'valid', 'Radio1': 'yes'}, {'TEXT': 'invalid', 'Radio1': 'no'}]
  /// ```
  Future<List<Map<String, String>>> executePict(
    Map<String, List<String>> factors, {
    String? constraints,
  }) async {
    if (factors.isEmpty) return const [];

    // Generate PICT model content with constraints
    final modelContent = generatePictModel(factors, constraints: constraints);

    // Write temp model file under .dart_tool
    final tmpDir = Directory('.dart_tool');
    if (!tmpDir.existsSync()) {
      tmpDir.createSync(recursive: true);
    }
    final modelPath = '.dart_tool/pairwise_model.tmp.txt';
    File(modelPath).writeAsStringSync(modelContent);

    // Execute PICT
    final result = await Process.run(pictBin, [modelPath]);
    if (result.exitCode != 0) {
      throw Exception('PICT exit code ${result.exitCode}: ${result.stderr}');
    }

    final output = (result.stdout is String)
        ? (result.stdout as String)
        : String.fromCharCodes((result.stdout as List<int>));

    return parsePictResult(output);
  }

  /// Parse PICT result output (tab-separated format)
  ///
  /// Example input:
  /// ```
  /// TEXT	Radio1
  /// valid	yes
  /// invalid	no
  /// ```
  ///
  /// Returns: `[{'TEXT': 'valid', 'Radio1': 'yes'}, {'TEXT': 'invalid', 'Radio1': 'no'}]`
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

  /// Parse PICT model file to extract factor names and their values
  ///
  /// Example input:
  /// ```
  /// customer_01_firstname_textfield: valid, invalid
  /// age_radio_group: age_10_20_radio, age_30_40_radio
  /// customer_07_title_dropdown: "Mr.", "Mrs.", "Ms."
  /// ```
  ///
  /// Returns: Map of factor names to their possible values
  Map<String, List<String>> parsePictModel(String content) {
    final factors = <String, List<String>>{};
    final lines = content.trim().split(RegExp(r'\r?\n')).where((l) => l.trim().isNotEmpty).toList();

    for (final line in lines) {
      // Skip comments and empty lines
      if (line.trim().isEmpty || line.trim().startsWith('#')) continue;

      // Parse factor line: "FactorName: value1, value2, value3"
      final colonIdx = line.indexOf(':');
      if (colonIdx == -1) continue;

      final factorName = line.substring(0, colonIdx).trim();
      final valuesStr = line.substring(colonIdx + 1).trim();

      // Parse values (handle quoted strings for dropdowns)
      final values = <String>[];
      final parts = valuesStr.split(',');

      for (final part in parts) {
        var value = part.trim();
        // Remove quotes if present
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

  /// Validate PICT constraint syntax line-by-line.
  ///
  /// Supports two formats:
  ///   Format A (dataset override): `key = value`
  ///   Format B (PICT constraint):  `IF [param] = "value" THEN [param] = "value";`
  ///
  /// Returns null if valid, or an error message string if invalid.
  String? validateConstraintsSyntax(String constraints) {
    final lines = constraints.split('\n');

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      final lineNum = i + 1;

      // Skip empty lines and comments
      if (line.isEmpty || line.startsWith('#')) continue;

      final hasIf = line.contains('IF');
      final hasThen = line.contains('THEN');

      // Format A: Dataset constraint  key = value  OR  key.slot = value
      if (!hasIf && !hasThen) {
        if (!RegExp(r'^[\w.]+\s*=\s*.+$').hasMatch(line)) {
          return 'Line $lineNum: Expected "key = value", "key.slot = value", or PICT "IF [...] = "..." THEN [...] = "...";"\n"$line"';
        }
        continue;
      }

      // Format B: PICT constraint  IF [...] ... THEN [...] ...;
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

  /// Read factor names from .invalid.model.txt file
  ///
  /// Returns: List of factor names in order they appear in the model
  List<String> readFactorNamesFromModel(String modelFilePath) {
    final file = File(modelFilePath);
    if (!file.existsSync()) return [];

    final content = file.readAsStringSync();
    final factors = parsePictModel(content);
    return factors.keys.toList();
  }

  // ==========================================================================
  // Manifest-based PICT Model Generation
  // ==========================================================================

  /// Extract factors from UI manifest widgets
  ///
  /// Detects:
  /// - TextFormField/TextField -> Uses actual widget key as factor name
  /// - Radio groups -> Uses groupValueBinding or extracted group name
  /// - DropdownButtonFormField -> Uses actual widget key as factor name
  /// - Checkbox -> Uses actual widget key as factor name
  ///
  /// Returns: FactorExtractionResult containing factors and required checkboxes
  FactorExtractionResult extractFactorsFromManifest(List<Map<String, dynamic>> widgets) {
    final factors = <String, List<String>>{};
    final requiredCheckboxes = <String>{}; // Track which checkboxes are required
    final invalidOnlyValues = <String, Set<String>>{}; // factorName -> invalid-only values

    // Track radio groups by groupValueBinding
    final radioGroups = <String, String>{}; // groupValueBinding -> factorName
    final radioGroupHasValidator = <String, bool>{}; // factorName -> hasValidator

    for (final w in widgets) {
      final widgetType = (w['widgetType'] ?? '').toString();
      final key = (w['key'] ?? '').toString();

      // Text inputs as factors: use actual widget key as factor name
      final isTextField = widgetType.startsWith('TextFormField') || widgetType.startsWith('TextField');
      if (isTextField && key.isNotEmpty) {
        // Use the actual widget key as factor name
        factors[key] = ['valid', 'invalid'];
      }

      // Individual Radio button - extract suffix and group by groupValueBinding
      if (widgetType.startsWith('Radio<') && key.isNotEmpty) {
        final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? const {};
        final groupValue = meta['groupValueBinding']?.toString() ?? '';

        // Get or create factor name for this radio group
        String factorName;
        if (radioGroups.containsKey(groupValue)) {
          factorName = radioGroups[groupValue]!;
        } else {
          // Extract group name from groupValueBinding or use a descriptive name
          // Example: groupValue='age_radio_group' or use extracted description from first radio key
          factorName = groupValue.isNotEmpty ? groupValue : _extractRadioGroupName(key);
          radioGroups[groupValue] = factorName;
          factors[factorName] = <String>[];
        }

        // Track if any Radio in this group has validatorRules
        final rules = (meta['validatorRules'] as List?) ?? const [];
        if (rules.isNotEmpty) {
          radioGroupHasValidator[factorName] = true;
        }

        // Extract suffix by removing prefix pattern: {page}_{sequence}_
        // Example: customer_05_age_10_20_radio -> age_10_20_radio
        final suffix = _extractRadioKeySuffix(key);
        if (suffix.isNotEmpty) {
          final list = factors[factorName]!..remove(suffix);
          list.add(suffix);
        }
        continue;
      }

      // Dropdown - use actual widget key as factor name
      if (widgetType.startsWith('DropdownButtonFormField') && key.isNotEmpty) {
        final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? const {};
        final items = _extractOptionsFromMeta(meta['options']);
        if (items.isNotEmpty) {
          // Use actual widget key as factor name
          factors[key] = items;
        }
        continue;
      }

      // Checkbox - use actual widget key as factor name
      // Include all checkboxes in PICT model (both required and optional)
      // NOTE: Skip FormField<bool> as it's a wrapper widget, not an interactive element
      //       The actual Checkbox inside should be used as the factor instead
      if (widgetType == 'Checkbox' && key.isNotEmpty) {
        // Use actual widget key as factor name
        factors[key] = ['checked', 'unchecked'];
      }

      // Switch/SwitchListTile - same as Checkbox
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

      // Slider - extract min/mid/max values
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

      // DatePicker/TimePicker detection (check for pickerMetadata)
      final pickerMeta = (w['pickerMetadata'] as Map?)?.cast<String, dynamic>();
      if (pickerMeta != null && key.isNotEmpty) {
        final pickerType = (pickerMeta['type'] ?? '').toString();

        if (pickerType == 'DatePicker') {
          // Generate real dates based on constraints
          final dateValues = _generateDateValues(pickerMeta);
          factors[key] = dateValues;
        } else if (pickerType == 'TimePicker') {
          // Generate real times
          factors[key] = ['09:00', '14:30', '18:00', 'null'];
        }
      }

      // Detect required checkboxes from FormField<bool> validators
      // NOTE: FormField<bool> is NOT added as a factor (it's a wrapper widget)
      //       But we still need to detect if it has a "required" validator
      //       to mark the inner Checkbox as required
      if (widgetType.startsWith('FormField<bool>') && key.isNotEmpty) {
        final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? const {};
        final rules = (meta['validatorRules'] as List?)?.cast<dynamic>() ?? const [];

        for (final rule in rules) {
          if (rule is Map) {
            final condition = rule['condition']?.toString() ?? '';
            // Check if condition requires value to be true
            // Pattern: "value == null || !value" means checkbox must be checked
            final normalized = condition.toLowerCase().replaceAll(' ', '');
            if (normalized.contains('!value') ||
                normalized.contains('value==false') ||
                (normalized.contains('value==null') && normalized.contains('||!value'))) {
              // Find the associated Checkbox key by replacing _formfield with _checkbox
              // Example: customer_06_agree_terms_formfield -> customer_06_agree_terms_checkbox
              final checkboxKey = key.replaceAll('_formfield', '_checkbox');
              requiredCheckboxes.add(checkboxKey);
              break;
            }
          }
        }
        continue; // Skip adding FormField<bool> as a factor
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

  /// Extract radio group name from radio key
  /// Example: customer_05_age_10_20_radio -> age_radio_group
  String _extractRadioGroupName(String radioKey) {
    // Pattern: {page_prefix}_{sequence}_{description}_{value}_radio
    // Extract description part
    final parts = radioKey.split('_');
    if (parts.length > 2) {
      // Find where the description starts (after sequence number)
      int descStartIdx = 2;
      // Skip sequence number if present
      if (parts.length > 1 && int.tryParse(parts[1]) != null) {
        descStartIdx = 2;
      }

      // Find where value starts (usually before last _radio or second-to-last part)
      int descEndIdx = parts.length - 2;
      if (parts.last == 'radio' && parts.length > 3) {
        descEndIdx = parts.length - 2;
      }

      if (descStartIdx < descEndIdx) {
        // Extract description (e.g., "age" from customer_05_age_10_20_radio)
        final description = parts[descStartIdx];
        return '${description}_radio_group';
      }
    }
    return 'radio_group'; // fallback
  }

  /// Extract Radio key suffix by removing prefix pattern
  /// Example: customer_05_age_10_20_radio -> age_10_20_radio
  String _extractRadioKeySuffix(String radioKey) {
    // Pattern: {page_prefix}_{sequence}_{description}_{value}_radio
    // Split by underscore and skip first 2 parts (page prefix and sequence)
    final parts = radioKey.split('_');
    if (parts.length > 2) {
      // Join remaining parts (description + value + radio)
      return parts.skip(2).join('_');
    }
    return radioKey; // fallback to full key if pattern doesn't match
  }

  /// Generate date values based on DatePicker metadata constraints
  List<String> _generateDateValues(Map<String, dynamic> pickerMeta) {
    final values = <String>[];

    // Parse firstDate and lastDate from metadata
    final firstDateStr = (pickerMeta['firstDate'] ?? '').toString();
    final lastDateStr = (pickerMeta['lastDate'] ?? '').toString();

    DateTime? firstDate;
    DateTime? lastDate;
    final now = DateTime.now();

    // Parse firstDate
    if (firstDateStr.contains('DateTime(1900)')) {
      firstDate = DateTime(1900);
    } else if (firstDateStr.contains('DateTime.now()')) {
      firstDate = now;
    } else {
      // Try to extract year from DateTime(year)
      final yearMatch = RegExp(r'DateTime\((\d{4})\)').firstMatch(firstDateStr);
      if (yearMatch != null) {
        firstDate = DateTime(int.parse(yearMatch.group(1)!));
      }
    }

    // Parse lastDate
    if (lastDateStr.contains('DateTime.now()')) {
      if (lastDateStr.contains('add') && lastDateStr.contains('365')) {
        lastDate = now.add(const Duration(days: 365));
      } else {
        lastDate = now;
      }
    } else {
      final yearMatch = RegExp(r'DateTime\((\d{4})\)').firstMatch(lastDateStr);
      if (yearMatch != null) {
        lastDate = DateTime(int.parse(yearMatch.group(1)!));
      }
    }

    // Generate test dates within constraints
    firstDate ??= DateTime(2000);
    lastDate ??= DateTime(2030);

    // null (cancel) - always include
    values.add('null');

    // past_date - close to firstDate
    final pastDate = DateTime(
      firstDate.year + 1,
      firstDate.month,
      15.clamp(1, 28),
    );
    if (pastDate.isAfter(firstDate) && pastDate.isBefore(lastDate)) {
      values.add('${pastDate.day.toString().padLeft(2, '0')}/${pastDate.month.toString().padLeft(2, '0')}/${pastDate.year}');
    }

    // today - if within range
    if (now.isAfter(firstDate) && now.isBefore(lastDate)) {
      values.add('${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}');
    }

    // future_date - close to lastDate
    final futureDate = DateTime(
      lastDate.year - 1,
      lastDate.month,
      15.clamp(1, 28),
    );
    if (futureDate.isAfter(firstDate) && futureDate.isBefore(lastDate) && futureDate.isAfter(now)) {
      values.add('${futureDate.day.toString().padLeft(2, '0')}/${futureDate.month.toString().padLeft(2, '0')}/${futureDate.year}');
    }

    // Ensure we have at least 2 non-null values
    if (values.length < 3) {
      // Add a middle date
      final middleDate = DateTime(
        (firstDate.year + lastDate.year) ~/ 2,
        6,
        15,
      );
      values.add('${middleDate.day.toString().padLeft(2, '0')}/${middleDate.month.toString().padLeft(2, '0')}/${middleDate.year}');
    }

    return values;
  }

  List<String> _extractOptionsFromMeta(dynamic raw) {
    final out = <String>[];
    if (raw is List) {
      for (final entry in raw) {
        if (entry is Map) {
          // Use value field for PICT compatibility (ASCII only)
          final value = entry['value']?.toString();
          final text = entry['text']?.toString();
          final label = entry['label']?.toString();
          final chosen = (value != null && value.isNotEmpty) ? value
                       : (text != null && text.isNotEmpty) ? text
                       : label;
          if (chosen != null && chosen.isNotEmpty) {
            // Replace spaces with underscores for PICT compatibility
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

  // ==========================================================================
  // PICT Model File Management
  // ==========================================================================

  /// Write PICT model files and execute PICT to generate result files
  ///
  /// Generates:
  /// - `model_pairwise/<page>.model.txt` / `<page>.valid.model.txt` (input models)
  /// - `model_pairwise/<page>.result.txt` / `<page>.valid.result.txt` (PICT results)
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

    // Create output/model_pairwise directory
    final outputDir = Directory('output/model_pairwise');
    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
    }

    // Write page-specific model files only (no root-level files)
    final outPageModel = 'output/model_pairwise/$pageBaseName.invalid.model.txt';
    final outPageValidModel = 'output/model_pairwise/$pageBaseName.valid.model.txt';
    File(outPageModel).writeAsStringSync(modelContent);
    File(outPageValidModel).writeAsStringSync(validModelContent);

    // Execute PICT on page-specific models to generate result files
    await _executePictToFile(
      outPageModel,
      'output/model_pairwise/$pageBaseName.invalid.result.txt',
    );
    await _executePictToFile(
      outPageValidModel,
      'output/model_pairwise/$pageBaseName.valid.result.txt',
    );

    // Post-process: enforce IF/THEN constraints by filtering out any violating
    // rows that PICT may have silently left in (observed with quoted values).
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

  // ==========================================================================
  // Internal Pairwise Algorithm (Fallback)
  // ==========================================================================

  /// Generate pairwise combinations using internal algorithm
  /// Used as fallback when PICT binary is unavailable
  ///
  /// Algorithm: Greedy set cover to find minimal test set covering all pairs
  List<Map<String, String>> generatePairwiseInternal(Map<String, List<String>> factors) {
    if (factors.isEmpty) return const [];

    final names = factors.keys.toList();
    if (names.length <= 1) {
      if (names.isEmpty) return const [];
      return factors[names[0]]!.map((v) => {names[0]: v}).toList();
    }

    // Generate all possible pairs that need to be covered
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

    // Generate all possible test cases
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

    // Greedy algorithm to find minimal set covering all pairs
    final selectedCases = <Map<String, String>>[];
    final coveredPairs = <String>{};

    while (coveredPairs.length < requiredPairs.length && allCases.isNotEmpty) {
      Map<String, String>? bestCase;
      int bestScore = -1;

      // Find the case that covers the most uncovered pairs
      for (final testCase in allCases) {
        int score = 0;

        // Calculate how many new pairs this case would cover
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

      // Add the best case and mark its pairs as covered
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

  // ==========================================================================
  // High-level API
  // ==========================================================================

  /// Generate pairwise test combinations from UI manifest
  ///
  /// Automatically:
  /// 1. Extracts factors from manifest widgets
  /// 2. Generates PICT model files
  /// 3. Executes PICT (or uses internal algorithm as fallback)
  /// 4. Returns test combinations
  Future<PairwiseResult> generatePairwiseFromManifest({
    required String manifestPath,
    required String uiFilePath,
    bool usePict = true,
    String? constraints,
  }) async {
    // Read manifest
    final manifestFile = File(manifestPath);
    if (!manifestFile.existsSync()) {
      throw Exception('Manifest not found: $manifestPath');
    }

    final manifestJson = jsonDecode(manifestFile.readAsStringSync()) as Map<String, dynamic>;
    final widgets = (manifestJson['widgets'] as List? ?? const []).cast<Map<String, dynamic>>();

    // Extract factors and required checkboxes
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

    // Generate PICT model files
    final pageBase = utils.basenameWithoutExtension(uiFilePath);
    await writePictModelFiles(
      factors: factors,
      pageBaseName: pageBase,
      requiredCheckboxes: requiredCheckboxes,
      constraints: constraints,
    );

    // Generate combinations
    List<Map<String, String>> combinations;
    List<Map<String, String>> validCombinations;
    String method;

    if (usePict) {
      try {
        combinations = await executePict(factors, constraints: constraints);

        // Generate valid-only combinations
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

  // ==========================================================================
  // Constraint Enforcement (Post-Processing)
  // ==========================================================================

  /// Filter PICT combinations to remove rows that violate Format B IF/THEN
  /// constraints. This is a safety net for cases where PICT silently ignores
  /// constraints (observed with quoted values on some PICT builds).
  ///
  /// Supported operator: = and <>
  /// Example constraint: IF [cat] = "Engineering" THEN [type] = "Freelance";
  List<Map<String, String>> filterCombosAgainstConstraints(
    List<Map<String, String>> combos,
    String constraints,
  ) {
    if (combos.isEmpty || constraints.trim().isEmpty) return combos;

    // Parse Format B (IF/THEN) rules only.
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

      // Match: [factorName] (=|<>) "value"
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

    /// Strip surrounding quotes from a combo cell.
    String unquote(String v) {
      if (v.length >= 2 &&
          ((v.startsWith('"') && v.endsWith('"')) ||
              (v.startsWith("'") && v.endsWith("'")))) {
        return v.substring(1, v.length - 1);
      }
      return v;
    }

    /// Normalize a value for comparison: lowercase + collapse the
    /// underscore↔space substitution that PICT model emission performs on
    /// dropdown options (see _formatValuesForModel) so that a constraint
    /// written as "IT & Tech" matches a PICT cell "IT_&_Tech".
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

      // Evaluate IF condition.
      final ifVal = norm(cellFor(r.ifFactor) ?? '');
      final ifTarget = norm(r.ifValue);
      final ifMet = r.ifOp == '=' ? ifVal == ifTarget : ifVal != ifTarget;
      if (!ifMet) return true; // antecedent false → constraint vacuously holds

      // Evaluate THEN condition.
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

  /// Read a result file, filter it, and overwrite if any rows were removed.
  void _filterResultFile(String resultPath, String constraints) {
    final file = File(resultPath);
    if (!file.existsSync()) return;

    final content = file.readAsStringSync();
    if (content.trim().isEmpty) return;

    final lines = content.trim().split(RegExp(r'\r?\n'));
    if (lines.length < 2) return; // header only — nothing to filter

    final header  = lines.first;
    final headers = header.split('\t').map((s) => s.trim()).toList();

    // Re-parse combinations
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
    if (filtered.length == combos.length) return; // nothing changed

    // Reconstruct and overwrite the file
    final outLines = [
      header,
      ...filtered.map((row) => headers.map((h) => row[h] ?? '').join('\t')),
    ];
    file.writeAsStringSync('${outLines.join('\n')}\n');
    stderr.writeln('[INFO] _filterResultFile: rewrote $resultPath '
        '(${combos.length} → ${filtered.length} rows)');
  }
}

// ==========================================================================
// Internal enums / helpers
// ==========================================================================

enum _PictModelFilter { full, invalidOnly, validOnly }

// ==========================================================================
// Internal helper — constraint rule parsed from Format B text
// ==========================================================================
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

// Removed: _basenameWithoutExtension - now using utils.basenameWithoutExtension

/// Result of factor extraction from manifest
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

/// Result of pairwise generation
class PairwiseResult {
  final List<Map<String, String>> combinations;
  final List<Map<String, String>> validCombinations;
  final Map<String, List<String>> factors;
  final String method; // 'pict' or 'internal'

  PairwiseResult({
    required this.combinations,
    required this.validCombinations,
    required this.factors,
    required this.method,
  });
}
