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

// ============================================================================
// PICT Model Generation
// ============================================================================

/// Generate PICT model from factors map
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
/// ```
String generatePictModel(Map<String, List<String>> factors) {
  final buffer = StringBuffer();
  for (final entry in factors.entries) {
    buffer.writeln('${entry.key}: ${_formatValuesForModel(entry.key, entry.value)}');
  }
  return buffer.toString();
}

/// Generate valid-only PICT model (excludes 'invalid' from TEXT factors)
String generateValidOnlyPictModel(Map<String, List<String>> factors) {
  final buffer = StringBuffer();
  for (final entry in factors.entries) {
    if (entry.key.startsWith('TEXT')) {
      // For TEXT factors, only use 'valid' values
      final validValues = entry.value.where((v) => v != 'invalid').toList();
      if (validValues.isNotEmpty) {
        buffer.writeln('${entry.key}: ${_formatValuesForModel(entry.key, validValues)}');
      }
    } else {
      // For non-TEXT factors (Radio, Dropdown), keep all values
      buffer.writeln('${entry.key}: ${_formatValuesForModel(entry.key, entry.value)}');
    }
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
///
/// Returns: List of test case combinations as Maps
///
/// Example:
/// ```dart
/// final combos = await executePict({
///   'TEXT': ['valid', 'invalid'],
///   'Radio1': ['yes', 'no']
/// });
/// // Result: [{'TEXT': 'valid', 'Radio1': 'yes'}, {'TEXT': 'invalid', 'Radio1': 'no'}]
/// ```
Future<List<Map<String, String>>> executePict(
  Map<String, List<String>> factors, {
  String pictBin = './pict',
}) async {
  if (factors.isEmpty) return const [];

  // Generate PICT model content
  final modelContent = generatePictModel(factors);

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

// ============================================================================
// Manifest-based PICT Model Generation
// ============================================================================

/// Extract factors from UI manifest widgets
///
/// Detects:
/// - TextFormField/TextField → TEXT factors (valid/invalid)
/// - Radio groups → Radio1, Radio2, etc.
/// - DropdownButtonFormField → Dropdown factors
Map<String, List<String>> extractFactorsFromManifest(List<Map<String, dynamic>> widgets) {
  final factors = <String, List<String>>{};

  // Track radio groups by groupValueBinding
  final radioGroups = <String, String>{}; // groupValueBinding -> factorName
  int radioGroupOrdinal = 0;
  int dropdownOrdinal = 0;
  int textOrdinal = 0;
  int checkboxOrdinal = 0;

  for (final w in widgets) {
    final widgetType = (w['widgetType'] ?? '').toString();
    final key = (w['key'] ?? '').toString();

    // Text inputs as factors: include all TextFields with keys
    final isTextField = widgetType.startsWith('TextFormField') || widgetType.startsWith('TextField');
    if (isTextField && key.isNotEmpty) {
      textOrdinal += 1;
      final factorName = textOrdinal == 1 ? 'TEXT' : 'TEXT$textOrdinal';
      factors[factorName] = ['valid', 'invalid'];
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
        radioGroupOrdinal += 1;
        factorName = radioGroupOrdinal == 1 ? 'Radio1' : 'Radio$radioGroupOrdinal';
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

    // Dropdown - check both actions and meta.options
    if (widgetType.startsWith('DropdownButtonFormField') && key.isNotEmpty) {
      dropdownOrdinal += 1;
      final factorName = dropdownOrdinal == 1 ? 'Dropdown' : 'Dropdown$dropdownOrdinal';
      final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? const {};
      final items = _extractOptionsFromMeta(meta['options']);
      if (items.isNotEmpty) factors[factorName] = items;
      continue;
    }

    // Checkbox - both standalone Checkbox and FormField<bool>
    // Include all checkboxes in PICT model (both required and optional)
    if ((widgetType == 'Checkbox' || widgetType.startsWith('FormField<bool>')) && key.isNotEmpty) {
      checkboxOrdinal += 1;
      final factorName = checkboxOrdinal == 1 ? 'Checkbox' : 'Checkbox$checkboxOrdinal';
      factors[factorName] = ['checked', 'unchecked'];
      continue;
    }
  }

  return factors;
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
  String pictBin = './pict',
}) async {
  if (factors.isEmpty) return;

  final modelContent = generatePictModel(factors);
  final validModelContent = generateValidOnlyPictModel(factors);

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
}) async {
  // Read manifest
  final manifestFile = File(manifestPath);
  if (!manifestFile.existsSync()) {
    throw Exception('Manifest not found: $manifestPath');
  }

  final manifestJson = jsonDecode(manifestFile.readAsStringSync()) as Map<String, dynamic>;
  final widgets = (manifestJson['widgets'] as List? ?? const []).cast<Map<String, dynamic>>();

  // Extract factors
  final factors = extractFactorsFromManifest(widgets);
  if (factors.isEmpty) {
    return PairwiseResult(
      combinations: [],
      validCombinations: [],
      factors: {},
      method: 'none',
    );
  }

  // Generate PICT model files
  final pageBase = _basenameWithoutExtension(uiFilePath);
  await writePictModelFiles(
    factors: factors,
    pageBaseName: pageBase,
    pictBin: pictBin,
  );

  // Generate combinations
  List<Map<String, String>> combinations;
  List<Map<String, String>> validCombinations;
  String method;

  if (usePict) {
    try {
      combinations = await executePict(factors, pictBin: pictBin);

      // Generate valid-only combinations
      final validFactors = <String, List<String>>{};
      for (final entry in factors.entries) {
        if (entry.key.startsWith('TEXT')) {
          validFactors[entry.key] = ['valid'];
        } else {
          validFactors[entry.key] = entry.value;
        }
      }
      validCombinations = await executePict(validFactors, pictBin: pictBin);
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

String _basenameWithoutExtension(String path) {
  final basename = path.split('/').last.split('\\').last;
  final dotIndex = basename.lastIndexOf('.');
  return dotIndex > 0 ? basename.substring(0, dotIndex) : basename;
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
