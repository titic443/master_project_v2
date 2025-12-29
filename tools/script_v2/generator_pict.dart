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
// PICT Model Generation
// ============================================================================

/// Generate PICT model from factors map with optional constraints
///
/// Example input:
/// ```dart
/// {
///   'TEXT': ['valid', 'invalid'],
///   'Radio1': ['yes', 'no'],
///   'Dropdown': ['option1', 'option2', 'option3']
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
String generatePictModel(Map<String, List<String>> factors, {String? constraints}) {
  final buffer = StringBuffer();
  for (final entry in factors.entries) {
    buffer.writeln('${entry.key}: ${_formatValuesForModel(entry.key, entry.value)}');
  }

  // Add constraints if provided
  if (constraints != null && constraints.trim().isNotEmpty) {
    buffer.writeln('');
    buffer.writeln(constraints.trim());
  }

  return buffer.toString();
}

/// Generate valid-only PICT model (excludes 'invalid' from TEXT factors and 'unchecked' from required checkboxes)
String generateValidOnlyPictModel(
  Map<String, List<String>> factors, {
  Set<String> requiredCheckboxes = const {},
  String? constraints,
}) {
  final buffer = StringBuffer();
  for (final entry in factors.entries) {
    // Check if this is a text field factor (contains 'valid' and 'invalid')
    final isTextField = entry.value.contains('valid') && entry.value.contains('invalid');

    if (isTextField) {
      // For TEXT factors, only use 'valid' values
      final validValues = entry.value.where((v) => v != 'invalid').toList();
      if (validValues.isNotEmpty) {
        buffer.writeln('${entry.key}: ${_formatValuesForModel(entry.key, validValues)}');
      }
    } else if (requiredCheckboxes.contains(entry.key)) {
      // For required checkboxes, only use 'checked' value
      final validValues = entry.value.where((v) => v != 'unchecked').toList();
      if (validValues.isNotEmpty) {
        buffer.writeln('${entry.key}: ${_formatValuesForModel(entry.key, validValues)}');
      }
    } else {
      // For non-TEXT factors (Radio, Dropdown, optional Checkbox), keep all values
      buffer.writeln('${entry.key}: ${_formatValuesForModel(entry.key, entry.value)}');
    }
  }

  // Add constraints if provided
  if (constraints != null && constraints.trim().isNotEmpty) {
    buffer.writeln('');
    buffer.writeln(constraints.trim());
  }

  return buffer.toString();
}

/// Format values for PICT model syntax
/// Dropdown values are quoted, others are comma-separated
String _formatValuesForModel(String factorName, List<String> values) {
  if (!factorName.startsWith('Dropdown')) {
    return values.join(', ');
  }
  final quoted = values.map((v) {
    final escaped = v.replaceAll('"', '\\"');
    return '"$escaped"';
  }).toList();
  return quoted.join(', ');
}

// ============================================================================
// PICT Execution
// ============================================================================

/// Execute PICT binary to generate pairwise combinations
///
/// Parameters:
/// - factors: Map of factor names to their possible values
/// - pictBin: Path to PICT binary (default: './pict')
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
  String pictBin = './pict',
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

/// Read factor names from .full.model.txt file
///
/// Returns: List of factor names in order they appear in the model
List<String> readFactorNamesFromModel(String modelFilePath) {
  final file = File(modelFilePath);
  if (!file.existsSync()) return [];

  final content = file.readAsStringSync();
  final factors = parsePictModel(content);
  return factors.keys.toList();
}

// ============================================================================
// Manifest-based PICT Model Generation
// ============================================================================

/// Extract factors from UI manifest widgets
///
/// Detects:
/// - TextFormField/TextField → Uses actual widget key as factor name
/// - Radio groups → Uses groupValueBinding or extracted group name
/// - DropdownButtonFormField → Uses actual widget key as factor name
/// - Checkbox → Uses actual widget key as factor name
///
/// Returns: FactorExtractionResult containing factors and required checkboxes
FactorExtractionResult extractFactorsFromManifest(List<Map<String, dynamic>> widgets) {
  final factors = <String, List<String>>{};
  final requiredCheckboxes = <String>{}; // Track which checkboxes are required

  // Track radio groups by groupValueBinding
  final radioGroups = <String, String>{}; // groupValueBinding -> factorName

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
    if ((widgetType == 'Checkbox' || widgetType.startsWith('FormField<bool>')) && key.isNotEmpty) {
      // Use actual widget key as factor name
      factors[key] = ['checked', 'unchecked'];

      // Detect if this checkbox is required by checking validatorRules
      if (widgetType.startsWith('FormField<bool>')) {
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
              requiredCheckboxes.add(key);
              break;
            }
          }
        }
      }
      continue;
    }
  }

  return FactorExtractionResult(
    factors: factors,
    requiredCheckboxes: requiredCheckboxes,
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

String _factorNameForRadioGroupKey(String key) {
  final match = RegExp(r'_radio(\d+)_group').firstMatch(key);
  if (match != null) return 'Radio${match.group(1)}';
  return 'Radio1'; // fallback
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

String _extractRadioOptionLabel(String radioKey) {
  // e.g., buttons_approve_radio -> approve
  final match = RegExp(r'^[^_]+_(.+?)_radio$').firstMatch(radioKey);
  if (match != null) return match.group(1)!.toLowerCase();
  return radioKey.toLowerCase();
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

// ============================================================================
// PICT Model File Management
// ============================================================================

/// Write PICT model files and execute PICT to generate result files
///
/// Generates:
/// - model_pairwise/<page>.model.txt / <page>.valid.model.txt (input models)
/// - model_pairwise/<page>.result.txt / <page>.valid.result.txt (PICT results)
Future<void> writePictModelFiles({
  required Map<String, List<String>> factors,
  required String pageBaseName,
  Set<String> requiredCheckboxes = const {},
  String pictBin = './pict',
  String? constraints,
}) async {
  if (factors.isEmpty) return;

  final modelContent = generatePictModel(factors, constraints: constraints);
  final validModelContent = generateValidOnlyPictModel(
    factors,
    requiredCheckboxes: requiredCheckboxes,
    constraints: constraints,
  );

  // Create output/model_pairwise directory
  final outputDir = Directory('output/model_pairwise');
  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }

  // Write page-specific model files only (no root-level files)
  final outPageModel = 'output/model_pairwise/$pageBaseName.full.model.txt';
  final outPageValidModel = 'output/model_pairwise/$pageBaseName.valid.model.txt';
  File(outPageModel).writeAsStringSync(modelContent);
  File(outPageValidModel).writeAsStringSync(validModelContent);

  // Execute PICT on page-specific models to generate result files
  await _executePictToFile(
    pictBin,
    outPageModel,
    'output/model_pairwise/$pageBaseName.full.result.txt',
  );
  await _executePictToFile(
    pictBin,
    outPageValidModel,
    'output/model_pairwise/$pageBaseName.valid.result.txt',
  );
}

Future<void> _executePictToFile(String pictBin, String modelPath, String outputPath) async {
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

// ============================================================================
// Internal Pairwise Algorithm (Fallback)
// ============================================================================

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

// ============================================================================
// High-level API
// ============================================================================

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
  String pictBin = './pict',
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
    pictBin: pictBin,
    constraints: constraints,
  );

  // Generate combinations
  List<Map<String, String>> combinations;
  List<Map<String, String>> validCombinations;
  String method;

  if (usePict) {
    try {
      combinations = await executePict(factors, pictBin: pictBin, constraints: constraints);

      // Generate valid-only combinations
      final validFactors = <String, List<String>>{};
      for (final entry in factors.entries) {
        if (entry.key.startsWith('TEXT')) {
          validFactors[entry.key] = ['valid'];
        } else {
          validFactors[entry.key] = entry.value;
        }
      }
      validCombinations = await executePict(validFactors, pictBin: pictBin, constraints: constraints);
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

// Removed: _basenameWithoutExtension - now using utils.basenameWithoutExtension

/// Result of factor extraction from manifest
class FactorExtractionResult {
  final Map<String, List<String>> factors;
  final Set<String> requiredCheckboxes;

  FactorExtractionResult({
    required this.factors,
    required this.requiredCheckboxes,
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
