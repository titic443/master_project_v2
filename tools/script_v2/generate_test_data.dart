// dart run tools/script_v2/generate_test_data.dart [manifest.json]
//
// Generate pairwise test plans from UI manifest using combinatorial testing.
// Creates comprehensive test cases that cover all widget interactions efficiently.
//
// Usage:
//   1. Process specific manifest file:
//      dart run tools/script_v2/generate_test_data.dart manifest/login/login_page.manifest.json
//
//   2. Process all manifest files in manifest/ folder:
//      dart run tools/script_v2/generate_test_data.dart
//
// Output: test_data/<page>.testdata.json

import 'dart:convert';
import 'dart:io';

import 'generator_pict.dart' as pict;
import 'utils.dart' as utils;

/// Public API for flutter_test_generator.dart
/// Generates test data from a manifest file using pairwise testing
/// Returns the path to the generated testdata.json file
Future<String> generateTestDataFromManifest(
  String manifestPath, {
  String pictBin = './pict',
  String? constraints,
}) async {
  // DEBUG: Check if constraints are passed (uncomment for debugging)
  // stderr.writeln('[DEBUG] generateTestDataFromManifest - constraints: ${constraints == null ? "NULL" : "\"${constraints.substring(0, constraints.length.clamp(0, 50))}...\""}');

  // Read manifest to get UI file path (same logic as _processOne)
  final raw = File(manifestPath).readAsStringSync();
  final j = jsonDecode(raw) as Map<String, dynamic>;
  final source = (j['source'] as Map<String, dynamic>?) ?? const {};
  final uiFile = (source['file'] as String?) ?? 'lib/unknown.dart';

  await _processOne(
    manifestPath,
    pairwiseMerge: true,
    planSummary: false,
    pairwiseUsePict: true,
    pictBin: pictBin,
    constraints: constraints,
  );

  // Return output path (same logic as _processOne line 1093)
  return 'output/test_data/${utils.basenameWithoutExtension(uiFile)}.testdata.json';
}

void main(List<String> args) async {
  // Default settings
  const bool pairwiseMerge = true;  // Always use pairwise mode
  const bool planSummary = false;   // Never show plan summary
  const bool pairwiseUsePict = true; // Always use PICT for pairwise
  const String pictBin = './pict';   // Fixed PICT binary path

  final inputs = <String>[];

  // Parse command line arguments - only accept manifest file paths
  for (final arg in args) {
    if (arg.endsWith('.manifest.json')) {
      inputs.add(arg);
    } else {
      stderr.writeln('Warning: Ignoring unrecognized argument: $arg');
    }
  }

  // If no inputs provided, scan entire output/manifest/ folder
  if (inputs.isEmpty) {
    final manifestDir = Directory('output/manifest');
    if (!manifestDir.existsSync()) {
      stderr.writeln('Error: No manifest directory found: output/manifest/');
      stderr.writeln('Please create manifest files first using extract_ui_manifest.dart');
      exit(1);
    }

    // Recursively find all .manifest.json files
    for (final f in manifestDir.listSync(recursive: true).whereType<File>()) {
      if (f.path.endsWith('.manifest.json')) {
        inputs.add(f.path);
      }
    }

    if (inputs.isEmpty) {
      stderr.writeln('Error: No manifest files found in output/manifest/');
      stderr.writeln('Expected: *.manifest.json files');
      exit(1);
    }

    stdout.writeln('Found ${inputs.length} manifest file(s) to process');
  }

  // Process each manifest file
  int successCount = 0;
  int errorCount = 0;

  for (final path in inputs) {
    try {
      await _processOne(
        path,
        pairwiseMerge: pairwiseMerge,
        planSummary: planSummary,
        pairwiseUsePict: pairwiseUsePict,
        pictBin: pictBin,
      );
      successCount++;
    } catch (e, st) {
      stderr.writeln('✗ Failed to process $path: $e');
      if (args.contains('--verbose')) {
        stderr.writeln(st);
      }
      errorCount++;
    }
  }

  // Print summary if processing multiple files
  if (inputs.length > 1) {
    stdout.writeln('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    stdout.writeln('Summary: $successCount succeeded, $errorCount failed');
    stdout.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  if (errorCount > 0) {
    exit(1);
  }
}

// Helper functions for dynamic key generation
String _extractPagePrefix(String? pageClass, String? filePath) {
  if (pageClass != null) {
    // ButtonsDemo -> buttons, LoginPage -> login, ProfileDemo -> profile, DemoPage -> demo
    String prefix = pageClass.toLowerCase()
      .replaceAll('demo', '')
      .replaceAll('page', '')
      .replaceAll('screen', '');
    
    // If empty after removing suffixes, use original class name without suffixes
    if (prefix.isEmpty) {
      prefix = pageClass.toLowerCase()
        .replaceAll('page', '')
        .replaceAll('screen', '');
      if (prefix.isEmpty) {
        prefix = pageClass.toLowerCase();
      }
    }
    return prefix;
  }
  if (filePath != null) {
    // lib/demos/buttons_page.dart -> buttons
    final fileName = filePath.split('/').last;
    return fileName.replaceAll('_page.dart', '')
                .replaceAll('_demo.dart', '')
                .replaceAll('_screen.dart', '')
                .replaceAll('.dart', '');
  }
  return 'page'; // fallback
}


Future<void> _processOne(String path, {bool pairwiseMerge = false, bool planSummary = false, bool pairwiseUsePict = false, String pictBin = './pict', String? constraints}) async {
  final raw = File(path).readAsStringSync();
  final j = jsonDecode(raw) as Map<String, dynamic>;
  final source = (j['source'] as Map<String, dynamic>? ) ?? const {};
  final uiFile = (source['file'] as String?) ?? 'lib/unknown.dart';
  final pageClass = (source['pageClass'] as String?) ?? utils.basenameWithoutExtension(uiFile);
  // Try to emit a PICT model from manifest first for verification
  try {
    await _tryWritePictModelFromManifestForUi(uiFile, pictBin: pictBin, constraints: constraints);
  } catch (e) {
    stderr.writeln('! Failed to write PICT model from manifest: $e');
  }
  final widgets = (j['widgets'] as List? ?? const []).cast<Map<String, dynamic>>();

  // Extract page prefix for expected keys
  final pagePrefix = _extractPagePrefix(pageClass, uiFile);

  // Providers detection removed - no longer included in output structure

  // Helper function to preserve datasets format (no conversion needed)
  // Keep the new format: {"key": [{"valid": "value1", "invalid": "value2", "invalidRuleMessages": "msg"}]}
  Map<String, dynamic> _convertDatasetsToOldFormat(Map<String, dynamic> byKey) {
    // Simply return as-is to preserve the array of objects format
    return Map<String, dynamic>.from(byKey);
  }

  // Attempt to load external datasets produced by datasets_from_ai/datasets_from_ir
  final datasets = {
    'defaults': <String, dynamic>{},
    'byKey': <String, dynamic>{},
  };
  bool hasExternalDatasets = false;
  try {
    final extPath = 'output/test_data/${utils.basenameWithoutExtension(uiFile)}.datasets.json';
    final f = File(extPath);
    if (f.existsSync()) {
      final ext = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
      final extDatasets = (ext['datasets'] as Map?)?.cast<String, dynamic>();
      final extByKey = (extDatasets?['byKey'] as Map?)?.cast<String, dynamic>();
      if (extByKey != null) {
        // Convert new format (array of pairs) to old format ({valid: [], invalid: []})
        final converted = _convertDatasetsToOldFormat(extByKey);
        (datasets['byKey'] as Map<String, dynamic>).addAll(converted);
        hasExternalDatasets = (converted.isNotEmpty);
      }
    }
  } catch (_) {}

  // Helper function to extract sequence number from key
  // Pattern: <page_prefix>_<sequence>_<description>_<widget_type>
  // Example: customer_07_end_button → 07
  int _extractSequence(String key) {
    if (key.isEmpty) return -1;
    final parts = key.split('_');
    if (parts.length < 2) return -1;

    // Try second part first (most common pattern)
    final secondPart = parts[1];
    final seq = int.tryParse(secondPart);
    if (seq != null) return seq;

    // Fallback: scan all parts for a number
    for (final part in parts) {
      final num = int.tryParse(part);
      if (num != null) return num;
    }
    return -1;
  }

  // Find Button widget with highest sequence number
  // This will be used as the end/submit button
  String? _findHighestSequenceButton(List<Map<String, dynamic>> widgets) {
    String? highestKey;
    int highestSeq = -1;

    for (final w in widgets) {
      final t = (w['widgetType'] ?? '').toString();
      final k = (w['key'] ?? '').toString();

      // Only consider Button types
      if ((t == 'ElevatedButton' || t == 'TextButton' || t == 'OutlinedButton') && k.isNotEmpty) {
        final seq = _extractSequence(k);
        if (seq > highestSeq) {
          highestSeq = seq;
          highestKey = k;
        }
      }
    }

    return highestKey;
  }

  // Discover end key by finding button with highest sequence
  String? endKey = _findHighestSequenceButton(widgets);

  // Collect expected keys (_expected_success and _expected_fail)
  // Use Set to ensure unique keys (SnackBar can appear multiple times in manifest)
  final expectedSuccessKeys = <String>{};
  final expectedFailKeys = <String>{};

  // Identify keys
  final textKeys = <String>[];
  final radioKeys = <String>[];
  final checkboxKeys = <String>[];
  final primaryButtons = <String>[];
  final datePickerKeys = <String>[];
  final timePickerKeys = <String>[];

  for (final w in widgets) {
    final k = (w['key'] ?? '').toString();

    if (k.contains('_expected_success')) {
      expectedSuccessKeys.add(k);
    }
    if (k.contains('_expected_fail')) {
      expectedFailKeys.add(k);
    }
  }

  // Check if we have end button (determines if this is an API flow)
  final hasEndButton = endKey != null;

  // Build a single full-page steps sequence (previous version behavior)
  for (final w in widgets) {
    final t = (w['widgetType'] ?? '').toString();
    final k = (w['key'] ?? '').toString();
    final pickerMeta = w['pickerMetadata'] as Map?;

    if ((t.startsWith('TextField') || t.startsWith('TextFormField')) && k.isNotEmpty) {
      textKeys.add(k);
    } else if (t.startsWith('Radio') && k.isNotEmpty) {
      radioKeys.add(k);
    } else if ((t.startsWith('Checkbox') || t == 'CheckboxListTile') && k.isNotEmpty) {
      // NOTE: Skip FormField<bool> as it's a wrapper widget, not an interactive element
      checkboxKeys.add(k);
    } else if ((t == 'ElevatedButton' || t == 'TextButton' || t == 'OutlinedButton') && k.isNotEmpty && k != endKey) {
      // Exclude the end button (highest sequence button) from primary buttons
      primaryButtons.add(k);
    } else if (pickerMeta != null && k.isNotEmpty) {
      // Detect DatePicker and TimePicker widgets
      final pickerType = (pickerMeta['type'] ?? '').toString();
      if (pickerType == 'DatePicker') {
        datePickerKeys.add(k);
      } else if (pickerType == 'TimePicker') {
        timePickerKeys.add(k);
      }
    }
  }

  // Fallback: include only concrete radio options, ignore FormField group keys
  for (final w in widgets) {
    final k = (w['key'] ?? '').toString();
    final isOption = (k.endsWith('_radio') || k.contains('_yes_radio') || k.contains('_no_radio')) && !k.contains('_radio_group');
    if (isOption && !radioKeys.contains(k)) radioKeys.add(k);
  }

  // Detect required checkboxes from FormField<bool> validators
  // A checkbox is required if its FormField wrapper has a validator that checks for true
  // Map: checkbox key -> validation message
  final requiredCheckboxValidation = <String, String>{};
  for (final w in widgets) {
    final t = (w['widgetType'] ?? '').toString();
    final k = (w['key'] ?? '').toString();

    if (t.startsWith('FormField<bool>') && k.isNotEmpty) {
      final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? const {};
      final rules = (meta['validatorRules'] as List?)?.cast<dynamic>() ?? const [];

      for (final rule in rules) {
        if (rule is Map) {
          final condition = rule['condition']?.toString() ?? '';
          final message = rule['message']?.toString() ?? '';
          // Check if condition requires value to be true
          // Pattern: "value == null || !value" means checkbox must be checked
          final normalized = condition.toLowerCase().replaceAll(' ', '');
          if (normalized.contains('!value') ||
              normalized.contains('value==false') ||
              (normalized.contains('value==null') && normalized.contains('||!value'))) {
            // Find the associated Checkbox key by replacing _formfield with _checkbox
            final checkboxKey = k.replaceAll('_formfield', '_checkbox');
            requiredCheckboxValidation[checkboxKey] = message;
            break;
          }
        }
      }
    }
  }

  // Detect dropdowns and their display items (support multiple dropdowns)
  String? dropdownKey; // keep first for backward compatibility
  final dropdownValues = <String>[]; // items of the first dropdown
  final dropdownKeys = <String>[];
  final dropdownValuesList = <List<String>>[];
  final dropdownValueToTextMaps = <Map<String, String>>[]; // Map value -> text for each dropdown

  for (final w in widgets) {
    final t = (w['widgetType'] ?? '').toString();
    if (t.contains('DropdownButton')) {
      final k = (w['key'] ?? '').toString();
      if (k.isNotEmpty) {
        dropdownKeys.add(k);
        if (dropdownKey == null) dropdownKey = k;
      }
      try {
        final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? const {};
        final list = _optionsFromMeta(meta['options']);
        dropdownValuesList.add(list);
        if (dropdownValues.isEmpty) {
          dropdownValues.addAll(list);
        }

        // Build value -> text mapping for this dropdown
        final valueToText = <String, String>{};
        final options = meta['options'];
        if (options is List) {
          for (final opt in options) {
            if (opt is Map) {
              final value = opt['value']?.toString();
              final text = opt['text']?.toString();
              if (value != null && value.isNotEmpty && text != null && text.isNotEmpty) {
                valueToText[value] = text;
              }
            }
          }
        }
        dropdownValueToTextMaps.add(valueToText);
      } catch (_) {
        dropdownValueToTextMaps.add(<String, String>{});
      }
    }
  }

List<Map<String,dynamic>> buildSteps({String? radioPick, String? dropdownPick}){
    final st = <Map<String, dynamic>>[];
    // enter text (always use valid[0]) for each text field
    final byKey = (datasets['byKey'] as Map).cast<String, dynamic>();
    for (final k in textKeys) {
      st.add({'enterText': {'byKey': k, 'dataset': 'byKey.' + k + '.valid[0]'}});
      st.add({'pump': true});
    }
    // dropdown selection if requested
    if (dropdownKey != null && dropdownPick != null && dropdownPick.isNotEmpty) {
      st.add({'tap': {'byKey': dropdownKey}});
      st.add({'pump': true});

      // Map value -> text for tapText (use first dropdown mapping)
      String textToTap = dropdownPick;
      if (dropdownValueToTextMaps.isNotEmpty) {
        final mapping = dropdownValueToTextMaps[0];
        final cleanPick = dropdownPick.replaceAll('"', '');
        textToTap = mapping[cleanPick] ?? dropdownPick;
      }

      st.add({'tapText': textToTap});
      st.add({'pump': true});
    }
    // radio options
    if (hasEndButton) {
      String? _pickFirstContaining(List<String> keys, List<String> prefs){
        for (final p in prefs) {
          final found = keys.firstWhere((k)=> k.contains('_'+p+'_') || k.endsWith('_'+p), orElse: ()=> '');
          if (found.isNotEmpty) return found;
        }
        return keys.isNotEmpty ? keys.first : null;
      }
      String? g2;
      if (radioPick != null && radioPick.isNotEmpty && radioKeys.contains(radioPick)) {
        g2 = radioPick;
      } else {
        g2 = _pickFirstContaining(radioKeys, ['approve','reject','pending']);
      }
      if (g2 != null) { st.add({'tap': {'byKey': g2}}); st.add({'pump': true}); }
      final g3 = _pickFirstContaining(radioKeys, ['manu','che']);
      if (g3 != null) { st.add({'tap': {'byKey': g3}}); st.add({'pump': true}); }
      final g4 = _pickFirstContaining(radioKeys, ['android','window','ios']);
      if (g4 != null) { st.add({'tap': {'byKey': g4}}); st.add({'pump': true}); }
    } else if (radioPick != null && radioPick.isNotEmpty) {
      st.add({'tap': {'byKey': radioPick}});
      st.add({'pump': true});
    } else if (!hasEndButton && radioKeys.isNotEmpty) {
      // non-API flow fallback: tap all radios in order
      for (final rk in radioKeys) { st.add({'tap': {'byKey': rk}}); st.add({'pump': true}); }
    }
    // DatePicker widgets (non-API flow): select 'today' for all date pickers
    for (final dpk in datePickerKeys) {
      st.add({'tap': {'byKey': dpk}});
      st.add({'pumpAndSettle': true});
      st.add({'selectDate': 'today'});
      st.add({'pumpAndSettle': true});
    }
    // TimePicker widgets (non-API flow): select 'today' (current time) for all time pickers
    for (final tpk in timePickerKeys) {
      st.add({'tap': {'byKey': tpk}});
      st.add({'pumpAndSettle': true});
      st.add({'selectTime': 'today'});
      st.add({'pumpAndSettle': true});
    }
    // tap all primary (non-end) buttons
    for (final bk in primaryButtons) { st.add({'tap': {'byKey': bk}}); st.add({'pump': true}); }
    // final end action
    if (endKey != null) { st.add({'tap': {'byKey': endKey}}); st.add({'pumpAndSettle': true}); }
    return st;
}

// Build test cases
  final cases = <Map<String, dynamic>>[];
  // Do not include stubbed setup/response; integration tests use real backend/providers
  final successSetup = <String, dynamic>{};

  // Helper functions (moved up for early declaration)
  String _shortKey(String k){
    final i = k.indexOf('_');
    return (i>0 && i+1<k.length) ? k.substring(i+1) : k;
  }
  
Map<String,dynamic> _widgetMetaByKey(String key){
  for (final w in widgets) {
    if ((w['key'] ?? '') == key) {
      return (w['meta'] as Map?)?.cast<String,dynamic>() ?? const {};
    }
  }
  return const {};
}

/// Generate date values for DatePicker based on firstDate/lastDate constraints
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

int? _maxLenFromMeta(Map<String,dynamic> meta){
  // Check inputFormatter first (LengthLimitingTextInputFormatter takes priority)
  final fmts = (meta['inputFormatters'] as List? ?? const []).cast<Map>();
  final lenFmt = fmts.firstWhere((f) => (f['type'] ?? '') == 'lengthLimit', orElse: ()=>{});
  if (lenFmt is Map && lenFmt['max'] is int) return lenFmt['max'] as int;
  
  // Fallback to maxLength property
  if (meta['maxLength'] is int) return meta['maxLength'] as int;
  return null;
}



  // Validation test cases removed - no longer generating individual field validation tests
  // API Response cases removed - no longer needed with new naming convention

  // Functions already declared above

  // Full flow mode removed - only pairwise testing supported

  // --- Pairwise generation (enabled when PICT model exists) ---
  // Check if PICT model exists (supports both API forms and widget demos)
  final pageBase = utils.basenameWithoutExtension(uiFile);
  final pageResultPath = 'output/model_pairwise/$pageBase.full.result.txt';
  final pageValidResultPath = 'output/model_pairwise/$pageBase.valid.result.txt';
  final pageModelPath = 'output/model_pairwise/$pageBase.full.model.txt';

  final hasPictModel = File(pageModelPath).existsSync();

  if (hasPictModel) {
    // Load page-specific PICT results

    List<Map<String,String>>? extCombos;
    List<Map<String,String>>? extValidCombos;
    Map<String, List<String>>? modelFactors; // Factors from model file

    // Load PICT model to get actual factor names and widget mappings
    if (File(pageModelPath).existsSync()) {
      modelFactors = pict.parsePictModel(File(pageModelPath).readAsStringSync());
    }

    // Build factor type mapping from model factors
    // Categorize factors as: text, radio, dropdown, checkbox, switch based on their values
    final factorTypes = <String, String>{}; // factorName -> type (text/radio/dropdown/checkbox/switch)
    final textFieldFactors = <String>[]; // List of textfield widget keys
    final radioGroupFactors = <String>[]; // List of radio group names
    final dropdownFactors = <String>[]; // List of dropdown widget keys
    final checkboxFactors = <String>[]; // List of checkbox widget keys
    final switchFactors = <String>[]; // List of switch widget keys

    if (modelFactors != null) {
      for (final entry in modelFactors.entries) {
        final factorName = entry.key;
        final values = entry.value;

        // Determine factor type based on values
        if (values.contains('valid') && values.contains('invalid')) {
          // Text field
          factorTypes[factorName] = 'text';
          textFieldFactors.add(factorName);
        } else if (values.contains('checked') && values.contains('unchecked')) {
          // Checkbox
          factorTypes[factorName] = 'checkbox';
          checkboxFactors.add(factorName);
        } else if (values.contains('on') && values.contains('off')) {
          // Switch widget
          factorTypes[factorName] = 'switch';
          switchFactors.add(factorName);
        } else if (values.any((v) => v.endsWith('_radio'))) {
          // Radio group
          factorTypes[factorName] = 'radio';
          radioGroupFactors.add(factorName);
        } else if (datePickerKeys.contains(factorName)) {
          // DatePicker - detected by checking if factor name is a datepicker key
          factorTypes[factorName] = 'datepicker';
        } else if (timePickerKeys.contains(factorName)) {
          // TimePicker - detected by checking if factor name is a timepicker key
          factorTypes[factorName] = 'timepicker';
        } else {
          // Dropdown (default for other cases)
          factorTypes[factorName] = 'dropdown';
          dropdownFactors.add(factorName);
        }
      }
    }

    if (File(pageResultPath).existsSync()) {
      extCombos = pict.parsePictResult(File(pageResultPath).readAsStringSync());
    }

    // Load valid-only combinations
    if (File(pageValidResultPath).existsSync()) {
      extValidCombos = pict.parsePictResult(File(pageValidResultPath).readAsStringSync());
    }

    // Helper to map Radio suffix to full Radio key
    // Example: age_10_20_radio -> customer_04_age_10_20_radio
    String? _radioKeyForSuffix(List<String> keys, String suffix){
      if (suffix.isEmpty) return null;
      // Find key that ends with the suffix
      String hit = keys.firstWhere(
        (k) => k.endsWith('_$suffix') || k.endsWith(suffix),
        orElse: () => ''
      );
      return hit.isEmpty ? null : hit;
    }

    // If we have external combos from PICT result, use them directly
    List<Map<String,String>> combos;
    bool usingExternalCombos = false;
    if (extCombos != null && extCombos.isNotEmpty) {
      combos = extCombos;
      usingExternalCombos = true;
    } else {
      // Build factors (excluding API outcome as per requirement)
      final factors = <String,List<String>>{};
      // TextFormField factors: only 'valid' and 'invalid' per requirement
      for (int i = 0; i < textKeys.length; i++) {
        final factorName = textKeys.length == 1 ? 'TEXT' : 'TEXT${i + 1}';
        factors[factorName] = ['valid', 'invalid'];
      }

      // Auto-detect Radio groups from widgets metadata
      // Method 1: Group by groupValueBinding (most reliable)
      final radioGroups = <String, List<String>>{};
      for (final w in widgets) {
        final t = (w['widgetType'] ?? '').toString();
        final k = (w['key'] ?? '').toString();
        if (t.startsWith('Radio') && k.isNotEmpty && radioKeys.contains(k)) {
          try {
            final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? {};
            final groupBinding = (meta['groupValueBinding'] ?? '').toString();
            if (groupBinding.isNotEmpty) {
              radioGroups.putIfAbsent(groupBinding, () => []);
              radioGroups[groupBinding]!.add(k);
            }
          } catch (_) {}
        }
      }

      // Method 2: Fallback to FormField<int> options (if no groupValueBinding found)
      if (radioGroups.isEmpty) {
        for (final w in widgets) {
          final t = (w['widgetType'] ?? '').toString();
          if (t == 'FormField<int>') {
            try {
              final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? {};
              final options = meta['options'];
              if (options is List) {
                final radioGroup = <String>[];
                for (final opt in options) {
                  if (opt is Map) {
                    final optValue = opt['value']?.toString();
                    if (optValue != null) {
                      // Find Radio with matching valueExpr
                      for (final rw in widgets) {
                        final rt = (rw['widgetType'] ?? '').toString();
                        final rk = (rw['key'] ?? '').toString();
                        if (rt.startsWith('Radio') && rk.isNotEmpty) {
                          final rmeta = (rw['meta'] as Map?)?.cast<String, dynamic>() ?? {};
                          final valueExpr = (rmeta['valueExpr'] ?? '').toString();
                          if (valueExpr == optValue) {
                            radioGroup.add(rk);
                          }
                        }
                      }
                    }
                  }
                }
                if (radioGroup.length > 1) {
                  final groupKey = (w['key'] ?? 'unknown').toString();
                  radioGroups[groupKey] = radioGroup;
                }
              }
            } catch (_) {}
          }
        }
      }

      // Add radio groups to factors
      int radioIndex = 1;
      for (final entry in radioGroups.entries) {
        if (entry.value.length > 1) {
          factors['Radio$radioIndex'] = entry.value;
          radioIndex++;
        }
      }

      if (dropdownValues.isNotEmpty) factors['Dropdown'] = List<String>.from(dropdownValues);

      // Checkbox factors: Checkbox, Checkbox2, Checkbox3, ...
      for (int i = 0; i < checkboxKeys.length; i++) {
        final factorName = (checkboxKeys.length == 1 || i == 0) ? 'Checkbox' : 'Checkbox${i + 1}';
        factors[factorName] = ['checked', 'unchecked'];
      }

      // DatePicker factors: Generate real dates based on firstDate/lastDate constraints
      for (int i = 0; i < datePickerKeys.length; i++) {
        final key = datePickerKeys[i];
        final factorName = key; // Use the widget key as factor name

        // Find picker metadata for this widget
        final widget = widgets.firstWhere((w) => (w['key'] ?? '') == key, orElse: () => <String, dynamic>{});
        final pickerMeta = (widget['pickerMetadata'] as Map?)?.cast<String, dynamic>() ?? {};

        // Generate date values based on constraints
        final dateValues = _generateDateValues(pickerMeta);
        factors[factorName] = dateValues;
      }

      // TimePicker factors: Generate real times
      for (int i = 0; i < timePickerKeys.length; i++) {
        final key = timePickerKeys[i];
        final factorName = timePickerKeys.length == 1 ? key : key;
        factors[factorName] = ['09:00', '14:30', '18:00', 'null'];
      }

      // Generate optimal pairwise combinations (prefer PICT if requested)
      if (pairwiseUsePict) {
        try {
          combos = await pict.executePict(factors, pictBin: pictBin);
        } catch (e) {
          stderr.writeln('! PICT failed ($e). Falling back to internal pairwise.');
          combos = pict.generatePairwiseInternal(factors);
        }
      } else {
        combos = pict.generatePairwiseInternal(factors);
      }
    }
    
    String textForBucket(String tfKey, String bucket){
      // Legacy buckets fallback if encountered
      final maxLen = _maxLenFromMeta(_widgetMetaByKey(tfKey));
      if (bucket=='min') return '';
      if (bucket=='min+1') return 'A';
      if (bucket=='nominal') {
        final n = (maxLen != null && maxLen > 2) ? (maxLen~/2) : 5;
        return 'A' * n;
      }
      if (bucket=='max-1') {
        if (maxLen != null && maxLen > 1) return 'A' * (maxLen-1);
        return 'A';
      }
      if (bucket=='max') {
        final m = maxLen ?? 10;
        return 'A' * m;
      }
      return 'A' * 5;
    }
    String? datasetPathForKeyBucket(String tfKey, String bucket){
      final ds = (datasets['byKey'] as Map?)?.cast<String, dynamic>() ?? const {};
      if (!ds.containsKey(tfKey)) return null;
      if (bucket != 'valid' && bucket != 'invalid') return null;

      // New format: byKey.<key> is an array of objects
      final dataArray = ds[tfKey];
      if (dataArray is List && dataArray.isNotEmpty) {
        // Return path: byKey.<key>[0].valid or byKey.<key>[0].invalid
        return 'byKey.$tfKey[0].$bucket';
      }

      // Fallback for old format (if exists)
      final sub = (ds[tfKey] as Map?)?.cast<String, dynamic>() ?? const {};
      final list = (sub[bucket] as List?) ?? const [];
      if (list.isEmpty) return null;
      return 'byKey.$tfKey.$bucket[0]';
    }

    for (int i = 0; i < combos.length; i++) {
      final c = combos[i];
      final r1Pick = (c['Radio1'] ?? '').toString();
      final r2Pick = (c['Radio2'] ?? '').toString();
      final r3Pick = (c['Radio3'] ?? '').toString();
      final r4Pick = (c['Radio4'] ?? '').toString();
      final ddPick = (c['Dropdown'] ?? '').toString();

      final st = <Map<String,dynamic>>[];

      // Track if any field uses invalid data to determine test case kind
      bool hasInvalidData = false;
      final invalidFields = <String>[]; // Track which fields have invalid data
      final uncheckedRequiredCheckboxes = <String>[]; // Track unchecked required checkboxes

      // Process factors in PICT header order (if using external combos)
      if (usingExternalCombos) {
        // Get the header order from the first PICT result to follow factor sequence
        List<String> headerOrder = [];
        if (File(pageResultPath).existsSync()) {
          final content = File(pageResultPath).readAsStringSync();
          final lines = content.trim().split(RegExp(r'\r?\n')).where((l) => l.trim().isNotEmpty).toList();
          if (lines.isNotEmpty) {
            headerOrder = lines.first.split('\t').map((s) => s.trim()).toList();
          }
        }

        // Build a map of all steps keyed by widget key to maintain manifest order
        final stepsByKey = <String, List<Map<String, dynamic>>>{};

        // Process factors using actual factor names from model
        for (final factorName in c.keys) {
          final factorType = factorTypes[factorName];
          final pick = (c[factorName] ?? '').toString();
          if (pick.isEmpty) continue;

          if (factorType == 'text') {
            // Text field - use factor name as widget key directly
            final bucket = (pick == 'invalid') ? 'invalid' : 'valid';
            if (bucket == 'invalid') {
              hasInvalidData = true;
              invalidFields.add(factorName); // Track this field as invalid
            }
            stepsByKey[factorName] = [
              {'enterText': {'byKey': factorName, 'dataset': 'byKey.$factorName[0].$bucket'}},
              {'pump': true}
            ];
          } else if (factorType == 'radio') {
            // Radio group - pick is the radio option suffix
            final matchedKey = _radioKeyForSuffix(radioKeys, pick);
            if (matchedKey != null) {
              stepsByKey[matchedKey] = [
                {'tap': {'byKey': matchedKey}},
                {'pump': true}
              ];
            }
          } else if (factorType == 'dropdown') {
            // Dropdown - use factor name as widget key directly
            // Map value -> text for tapText
            String textToTap = pick;
            final dropdownIdx = dropdownKeys.indexOf(factorName);
            if (dropdownIdx >= 0 && dropdownIdx < dropdownValueToTextMaps.length) {
              final mapping = dropdownValueToTextMaps[dropdownIdx];
              final cleanPick = pick.replaceAll('"', '');
              textToTap = mapping[cleanPick] ?? pick;
            }

            stepsByKey[factorName] = [
              {'tap': {'byKey': factorName}},
              {'pump': true},
              {'tapText': textToTap},
              {'pump': true}
            ];
          } else if (factorType == 'checkbox') {
            // Checkbox - use factor name as widget key directly
            if (pick == 'checked') {
              stepsByKey[factorName] = [
                {'tap': {'byKey': factorName}},
                {'pump': true}
              ];
            } else if (pick == 'unchecked' && requiredCheckboxValidation.containsKey(factorName)) {
              // Required checkbox is unchecked = invalid form state
              hasInvalidData = true;
              uncheckedRequiredCheckboxes.add(factorName);
            }
          } else if (factorType == 'switch') {
            // Switch widget - tap only if 'on', skip if 'off' (default state)
            if (pick == 'on') {
              stepsByKey[factorName] = [
                {'tap': {'byKey': factorName}},
                {'pump': true}
              ];
            }
          } else if (datePickerKeys.contains(factorName)) {
            // DatePicker widget - open picker and select date
            stepsByKey[factorName] = [
              {'tap': {'byKey': factorName}},
              {'pumpAndSettle': true},
              {'selectDate': pick},
              {'pumpAndSettle': true}
            ];
          } else if (timePickerKeys.contains(factorName)) {
            // TimePicker widget - open picker and select time
            stepsByKey[factorName] = [
              {'tap': {'byKey': factorName}},
              {'pumpAndSettle': true},
              {'selectTime': pick},
              {'pumpAndSettle': true}
            ];
          }
        }

        // Add steps in key sequence order (sort widgets by key before iterating)
        final sortedWidgets = List<Map<String, dynamic>>.from(widgets);
        sortedWidgets.sort((a, b) {
          final keyA = (a['key'] ?? '').toString();
          final keyB = (b['key'] ?? '').toString();
          return keyA.compareTo(keyB);
        });

        for (final w in sortedWidgets) {
          final key = (w['key'] ?? '').toString();
          if (stepsByKey.containsKey(key)) {
            st.addAll(stepsByKey[key]!);
          }
        }
      } else {
        // Fallback to original logic for non-external combos
        // Build a map of all steps keyed by widget key to maintain manifest order
        final stepsByKey = <String, List<Map<String, dynamic>>>{};

        // Process text fields and collect their steps
        for (int j = 0; j < textKeys.length; j++) {
          final factorName = textKeys.length == 1 ? 'TEXT' : 'TEXT${j + 1}';
          final tfBucket = c[factorName];
          if (tfBucket != null) {
            if (tfBucket.toString() == 'invalid') {
              hasInvalidData = true;
              invalidFields.add(textKeys[j]); // Track this field as invalid
            }
            final dsPath = datasetPathForKeyBucket(textKeys[j], tfBucket.toString());
            if (dsPath != null) {
              stepsByKey[textKeys[j]] = [
                {'enterText': {'byKey': textKeys[j], 'dataset': dsPath}},
                {'pump': true}
              ];
            } else {
              stepsByKey[textKeys[j]] = [
                {'enterText': {'byKey': textKeys[j], 'text': textForBucket(textKeys[j], tfBucket)}},
                {'pump': true}
              ];
            }
          }
        }

        // Process dropdown and collect steps
        if (dropdownKey != null && c['Dropdown'] != null) {
          final ddPick = (c['Dropdown'] ?? '').toString();
          if (ddPick.isNotEmpty) {
            stepsByKey[dropdownKey] = [
              {'tap': {'byKey': dropdownKey}},
              {'pump': true},
              {'tapText': ddPick},
              {'pump': true}
            ];
          }
        }

        // Process radios and collect their steps
        // Match Radio suffix from PICT with full Radio key
        for (final factorName in c.keys) {
          if (factorName.startsWith('Radio')) {
            final pick = (c[factorName] ?? '').toString();
            if (pick.isNotEmpty) {
              // pick is Radio suffix like "age_10_20_radio"
              final matchedKey = _radioKeyForSuffix(radioKeys, pick);
              if (matchedKey != null) {
                stepsByKey[matchedKey] = [
                  {'tap': {'byKey': matchedKey}},
                  {'pump': true}
                ];
              }
            }
          }
        }

        // Process checkboxes and collect their steps
        for (int idx = 0; idx < checkboxKeys.length; idx++) {
          final factorName = (checkboxKeys.length == 1 || idx == 0) ? 'Checkbox' : 'Checkbox${idx + 1}';
          final pick = (c[factorName] ?? '').toString();
          if (pick == 'checked') {
            final key = checkboxKeys[idx];
            if (key.isNotEmpty) {
              stepsByKey[key] = [
                {'tap': {'byKey': key}},
                {'pump': true}
              ];
            }
          }
        }

        // Process DatePicker widgets
        for (int idx = 0; idx < datePickerKeys.length; idx++) {
          final key = datePickerKeys[idx];
          final factorName = datePickerKeys.length == 1 ? key : key;
          final pick = (c[factorName] ?? '').toString();
          if (pick.isNotEmpty && key.isNotEmpty) {
            stepsByKey[key] = [
              {'tap': {'byKey': key}},
              {'pumpAndSettle': true},  // Wait for dialog to appear
              {'selectDate': pick},      // Select date: today, past_date, future_date, null
              {'pumpAndSettle': true}    // Wait for dialog to close
            ];
          }
        }

        // Process TimePicker widgets
        for (int idx = 0; idx < timePickerKeys.length; idx++) {
          final key = timePickerKeys[idx];
          final factorName = timePickerKeys.length == 1 ? key : key;
          final pick = (c[factorName] ?? '').toString();
          if (pick.isNotEmpty && key.isNotEmpty) {
            stepsByKey[key] = [
              {'tap': {'byKey': key}},
              {'pumpAndSettle': true},  // Wait for dialog to appear
              {'selectTime': pick},      // Select time: today, future_date, null
              {'pumpAndSettle': true}    // Wait for dialog to close
            ];
          }
        }

        // Add steps in key sequence order (sort widgets by key before iterating)
        final sortedWidgets = List<Map<String, dynamic>>.from(widgets);
        sortedWidgets.sort((a, b) {
          final keyA = (a['key'] ?? '').toString();
          final keyB = (b['key'] ?? '').toString();
          return keyA.compareTo(keyB);
        });

        for (final w in sortedWidgets) {
          final key = (w['key'] ?? '').toString();
          if (stepsByKey.containsKey(key)) {
            st.addAll(stepsByKey[key]!);
          }
        }
      }

      // Final API call (if end button exists)
      if (hasEndButton && endKey != null) {
        st.add({'tap': {'byKey': endKey}});
        st.add({'pumpAndSettle': true});
      } else {
        // For widget demos without submit button, just pump
        st.add({'pump': true});
      }

      // Determine test case kind based on whether invalid data is used
      final caseKind = hasInvalidData ? 'failed' : 'success';
      final id = 'pairwise_valid_invalid_cases_${i + 1}';

      // Build assertions - include validation error messages for invalid fields
      final asserts = <Map<String, dynamic>>[];

      if (hasInvalidData) {
        // For cases with invalid data, expect invalidRuleMessages from datasets (not empty/required messages)
        final ds = (datasets['byKey'] as Map?)?.cast<String, dynamic>() ?? const {};

        for (final fieldKey in invalidFields) {
          // Get invalidRuleMessages from datasets for this field
          final dataArray = ds[fieldKey];
          if (dataArray is List && dataArray.isNotEmpty) {
            // Use index [0] since dataset path uses [0]
            final firstPair = dataArray[0];
            if (firstPair is Map) {
              final invalidRuleMsg = firstPair['invalidRuleMessages']?.toString();
              // Only include non-empty validation messages (exclude "Required"/"กรุณา" messages)
              if (invalidRuleMsg != null &&
                  invalidRuleMsg.isNotEmpty &&
                  !invalidRuleMsg.toLowerCase().contains('required') &&
                  !invalidRuleMsg.toLowerCase().contains('กรุณา')) {
                asserts.add({'text': invalidRuleMsg, 'exists': true});
              }
            }
          }
        }

        // Add validation messages for unchecked required checkboxes
        for (final checkboxKey in uncheckedRequiredCheckboxes) {
          final validationMsg = requiredCheckboxValidation[checkboxKey];
          if (validationMsg != null && validationMsg.isNotEmpty) {
            asserts.add({'text': validationMsg, 'exists': true});
          }
        }

        // Assert that expected fail keys exist (if any)
        for (final failKey in expectedFailKeys) {
          asserts.add({'byKey': failKey, 'exists': true});
        }
      } else {
        // For valid data cases, expect success keys
        for (final successKey in expectedSuccessKeys) {
          asserts.add({'byKey': successKey, 'exists': true});
        }
      }

      cases.add({
        'tc': id,
        'kind': caseKind,
        'group': 'pairwise_valid_invalid_cases',
        'steps': st,
        'asserts': asserts,
      });
    }

    // --- Generate pairwise valid-only cases ---
    // Generate additional valid-only test cases if we have valid combinations
    if (extValidCombos != null && extValidCombos.isNotEmpty) {
      for (int i = 0; i < extValidCombos.length; i++) {
        final c = extValidCombos[i];
        final st = <Map<String,dynamic>>[];

        // Get the header order for valid combos (similar to regular pairwise)
        List<String> headerOrder = [];
        if (File(pageValidResultPath).existsSync()) {
          final content = File(pageValidResultPath).readAsStringSync();
          final lines = content.trim().split(RegExp(r'\r?\n')).where((l) => l.trim().isNotEmpty).toList();
          if (lines.isNotEmpty) {
            headerOrder = lines.first.split('\t').map((s) => s.trim()).toList();
          }
        }

        // If no header order found, fall back to default order
        if (headerOrder.isEmpty) {
          headerOrder = ['TEXT', 'TEXT2', 'TEXT3', 'Radio2', 'Radio3', 'Radio4', 'Dropdown'];
        }

        // Build a map of all steps keyed by widget key to maintain manifest order
        final stepsByKey = <String, List<Map<String, dynamic>>>{};

        // Process each factor and collect steps using actual factor names
        for (final factorName in headerOrder) {
          final pick = (c[factorName] ?? '').toString();
          if (pick.isEmpty) continue;

          final factorType = factorTypes[factorName];

          if (factorType == 'text') {
            // Text field - always use valid for valid-only cases
            stepsByKey[factorName] = [
              {'enterText': {'byKey': factorName, 'dataset': 'byKey.$factorName[0].valid'}},
              {'pump': true}
            ];
          } else if (factorType == 'radio') {
            // Radio group - pick is the radio option suffix
            final matchedKey = _radioKeyForSuffix(radioKeys, pick);
            if (matchedKey != null) {
              stepsByKey[matchedKey] = [
                {'tap': {'byKey': matchedKey}},
                {'pump': true}
              ];
            }
          } else if (factorType == 'dropdown') {
            // Dropdown - use factor name as widget key directly
            // Map value -> text for tapText
            String textToTap = pick;
            final dropdownIdx = dropdownKeys.indexOf(factorName);
            if (dropdownIdx >= 0 && dropdownIdx < dropdownValueToTextMaps.length) {
              final mapping = dropdownValueToTextMaps[dropdownIdx];
              final cleanPick = pick.replaceAll('"', '');
              textToTap = mapping[cleanPick] ?? pick;
            }

            stepsByKey[factorName] = [
              {'tap': {'byKey': factorName}},
              {'pump': true},
              {'tapText': textToTap},
              {'pump': true}
            ];
          } else if (factorType == 'checkbox') {
            // Checkbox - use factor name as widget key directly
            if (pick == 'checked') {
              stepsByKey[factorName] = [
                {'tap': {'byKey': factorName}},
                {'pump': true}
              ];
            }
          } else if (factorType == 'switch') {
            // Switch widget - tap only if 'on', skip if 'off' (default state)
            if (pick == 'on') {
              stepsByKey[factorName] = [
                {'tap': {'byKey': factorName}},
                {'pump': true}
              ];
            }
          } else if (datePickerKeys.contains(factorName)) {
            // DatePicker widget - open picker and select date
            stepsByKey[factorName] = [
              {'tap': {'byKey': factorName}},
              {'pumpAndSettle': true},
              {'selectDate': pick},
              {'pumpAndSettle': true}
            ];
          } else if (timePickerKeys.contains(factorName)) {
            // TimePicker widget - open picker and select time
            stepsByKey[factorName] = [
              {'tap': {'byKey': factorName}},
              {'pumpAndSettle': true},
              {'selectTime': pick},
              {'pumpAndSettle': true}
            ];
          }
        }

        // Add steps in key sequence order (sort widgets by key before iterating)
        final sortedWidgets = List<Map<String, dynamic>>.from(widgets);
        sortedWidgets.sort((a, b) {
          final keyA = (a['key'] ?? '').toString();
          final keyB = (b['key'] ?? '').toString();
          return keyA.compareTo(keyB);
        });

        for (final w in sortedWidgets) {
          final key = (w['key'] ?? '').toString();
          if (stepsByKey.containsKey(key)) {
            st.addAll(stepsByKey[key]!);
          }
        }

        // Final API call (if end button exists)
        if (hasEndButton && endKey != null) {
          st.add({'tap': {'byKey': endKey}});
          st.add({'pumpAndSettle': true});
        } else {
          // For widget demos without submit button, just pump
          st.add({'pump': true});
        }

        // Valid-only cases should always expect success
        final id = 'pairwise_valid_cases_${i + 1}';
        final asserts = <Map<String, dynamic>>[];
        // Expect success keys for valid cases
        for (final successKey in expectedSuccessKeys) {
          asserts.add({'byKey': successKey, 'exists': true});
        }

        cases.add({
          'tc': id,
          'kind': 'success',
          'group': 'pairwise_valid_cases',
          'steps': st,
          'asserts': asserts,
        });
      }
    }
  }

  // --- Radio-only state cases removed as per latest requirement ---

  // --- Single empty-all-fields case (no API) ---
  // No typing steps; if there is *_validate_button, tap it to trigger validate.
  // Ifไม่มี validate button แยก แต่มี *_endapi_* หรือ *_end_* ให้กดปุ่มนั้นแทนเพื่อ trigger validate
  // For empty fields test, detect required fields by checking validator conditions (not just message text)
  final expectedMsgsCount = <String, int>{};

  // Helper to check if a condition indicates empty/null validation
  bool _isEmptyCheckCondition(String condition) {
    final normalized = condition.toLowerCase().replaceAll(' ', '');
    return normalized.contains('value==null') ||
           normalized.contains('value.isempty') ||
           normalized.contains('valuenull') ||
           normalized.contains('valueisempty');
  }

  for (final w in widgets) {
    try {
      final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? const {};

      // Check validatorRules (more reliable - uses condition logic)
      final rules = (meta['validatorRules'] as List?)?.cast<dynamic>() ?? const [];
      for (final rule in rules) {
        if (rule is Map) {
          final condition = rule['condition']?.toString() ?? '';
          final msg = rule['message']?.toString() ?? '';

          // Check if this rule validates empty/null values by analyzing the condition
          if (msg.isNotEmpty && _isEmptyCheckCondition(condition)) {
            expectedMsgsCount[msg] = (expectedMsgsCount[msg] ?? 0) + 1;
          }
        }
      }

      // Fallback: Check validatorMessages (for TextFormField without explicit rules)
      // Use pattern matching for common empty-field messages
      if (rules.isEmpty) {
        final v = (meta['validatorMessages'] as List?)?.cast<dynamic>() ?? const [];
        for (final m in v) {
          final s = m?.toString() ?? '';
          // Match common patterns for empty field validation (multilingual support)
          if (s.isNotEmpty && (
              s.toLowerCase().contains('required') ||
              s.contains('กรุณา') ||
              s.contains('โปรด') ||
              s.contains('ต้อง') ||
              s.toLowerCase().contains('please') ||
              s.toLowerCase().contains('cannot be empty') ||
              s.toLowerCase().contains('is required'))) {
            expectedMsgsCount[s] = (expectedMsgsCount[s] ?? 0) + 1;
            break; // Only take the first empty-validation message
          }
        }
      }
    } catch (_) {}
  }

  // If no specific "Required" messages found, add default "Required" for each TextFormField
  if (expectedMsgsCount.isEmpty && textKeys.isNotEmpty) {
    for (final tfKey in textKeys) {
      expectedMsgsCount['Required'] = (expectedMsgsCount['Required'] ?? 0) + 1;
    }
  }

  final emptyAsserts = [
    for (final entry in expectedMsgsCount.entries)
      {'text': entry.key, 'exists': true, 'count': entry.value}
  ];
  final emptySteps = <Map<String,dynamic>>[];
  // Use endKey (end button) to trigger validation
  if (endKey != null) {
    emptySteps.add({'tap': {'byKey': endKey}});
    emptySteps.add({'pumpAndSettle': true});
  }
  cases.add({
    'tc': 'edge_cases_empty_all_fields',
    'kind': 'failed',
    'group': 'edge_cases',
    'steps': emptySteps,
    'asserts': emptyAsserts,
  });

  // Output structure: only 3 main sections (source, datasets, cases)
  final plan = <String, dynamic>{
    'source': source,
    'datasets': datasets,
    'cases': cases,
  };

  final outPath = 'output/test_data/${utils.basenameWithoutExtension(uiFile)}.testdata.json';
  File(outPath).createSync(recursive: true);
  File(outPath).writeAsStringSync(const JsonEncoder.withIndent('  ').convert(plan) + '\n');
  stdout.writeln('✓ fullpage plan: $outPath');
}


// Removed: _basename, _basenameWithoutExtension - now using utils.dart

// Attempt to read output/manifest/**/<page>.manifest.json and emit a PICT model
Future<void> _tryWritePictModelFromManifestForUi(String uiFile, {String pictBin = './pict', String? constraints}) async {
  final base = utils.basenameWithoutExtension(uiFile);

  // Extract subfolder structure from uiFile (e.g., lib/demos/register_page.dart → demos)
  final normalizedPath = uiFile.replaceAll('\\', '/');
  String subfolderPath = '';
  if (normalizedPath.startsWith('lib/')) {
    final pathAfterLib = normalizedPath.substring(4);
    final lastSlash = pathAfterLib.lastIndexOf('/');
    if (lastSlash > 0) {
      subfolderPath = pathAfterLib.substring(0, lastSlash);
    }
  }

  final manifestPath = subfolderPath.isNotEmpty
      ? 'output/manifest/$subfolderPath/$base.manifest.json'
      : 'output/manifest/$base.manifest.json';
  final f = File(manifestPath);
  if (!f.existsSync()) return; // silently skip when no manifest

  final j = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
  final widgets = (j['widgets'] as List? ?? const []).cast<Map<String, dynamic>>();

  // Extract factors and required checkboxes using pict_generator module
  final extractionResult = pict.extractFactorsFromManifest(widgets);
  final factors = extractionResult.factors;
  final requiredCheckboxes = extractionResult.requiredCheckboxes;
  if (factors.isEmpty) return; // nothing to write

  // Generate and write PICT model files using pict_generator module
  await pict.writePictModelFiles(
    factors: factors,
    pageBaseName: base,
    requiredCheckboxes: requiredCheckboxes,
    pictBin: pictBin,
    constraints: constraints,
  );
}

// Helper functions for dropdown options
List<String> _optionsFromMeta(dynamic raw) {
  final out = <String>[];
  if (raw is List) {
    for (final entry in raw) {
      if (entry is Map) {
        // Use value field for PICT compatibility (ASCII only, no Thai characters)
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
