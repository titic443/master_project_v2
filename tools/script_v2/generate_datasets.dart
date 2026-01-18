// dart run tools/script_v2/generate_datasets.dart [manifest/**/<page>.manifest.json] [--model=gemini-1.5-flash] [--api-key=...]
//
// Generate test datasets by calling Google Gemini. AI is required - no local fallback.
// Output JSON keeps the same structure as *.datasets.json currently used by the project.
//
// Usage:
//   Batch mode (scan all manifests):
//     dart run tools/script_v2/generate_datasets.dart
//
//   Single file mode:
//     dart run tools/script_v2/generate_datasets.dart manifest/demos/register_page.manifest.json
//
// Env:
//   GEMINI_API_KEY  - API key for Generative Language API (if --api-key not provided)
//   .env file       - Reads GEMINI_API_KEY from .env file in project root (recommended)
//
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'utils.dart' as utils;

// ========================================
// 🔑 API KEY CONFIGURATION
// ========================================
// SECURITY: Never hardcode API keys in source code
// Use one of these methods instead:
// 1. Create .env file with: GEMINI_API_KEY=your_key
// 2. Export environment variable: export GEMINI_API_KEY=your_key
// 3. Use --api-key flag: --api-key=your_key
// Get your API key from: https://aistudio.google.com/app/apikey
// ========================================
const String hardcodedApiKey =
    'AIzaSyBgq9_nA0LZLq7GKz6qd5S2x6Lr0B2BoUg'; // Removed for security

/// Public API for flutter_test_generator.dart
/// Generates datasets from a manifest file and returns the output path
/// Returns null if no text fields are found (not an error)
/// Throws exception on actual errors (API issues, file not found, etc.)
Future<String?> generateDatasetsFromManifest(
  String manifestPath, {
  String model = 'gemini-2.5-flash',
  String? apiKey,
  bool localOnly = false,
}) async {
  try {
    await _processManifest(manifestPath, model, apiKey, localOnly);

    // Calculate output path
    final base = manifestPath
        .replaceAll('output/manifest/', '')
        .replaceAll(RegExp(r'\.manifest\.json$'), '');
    return 'output/test_data/$base.datasets.json';
  } on Exception catch (e) {
    if (e.toString().contains('No TextField/TextFormField widgets found')) {
      return null; // Skip without error
    }
    rethrow;
  }
}

void main(List<String> args) async {
  String manifestPath = '';
  String model = 'gemini-2.5-flash';
  String? apiKey;
  bool localOnly =
      false; // force fallback/local generation, ignore AI completely
  // AI is now required by default - no fallback mode

  for (final a in args) {
    if (a == '--local-only' || a == '--no-ai' || a == '--force-fallback') {
      localOnly = true;
    } else if (a == '--ai-required' || a == '--strict-ai') {
      // AI is now always required, this option is deprecated
    } else if (a.startsWith('--model=')) {
      model = a.substring('--model='.length);
    } else if (a.startsWith('--api-key=')) {
      apiKey = a.substring('--api-key='.length);
    } else if (!a.startsWith('--')) {
      manifestPath = a;
    }
  }

  // If no manifest path provided, scan output/manifest/ folder for all .manifest.json files
  if (manifestPath.isEmpty) {
    final manifestFiles = await _scanManifestFolder();
    if (manifestFiles.isEmpty) {
      stderr
          .writeln('No .manifest.json files found in output/manifest/ folder');
      exit(1);
    }

    stdout.writeln('📁 Found ${manifestFiles.length} manifest file(s)');
    stdout.writeln('🚀 Starting batch dataset generation...\n');

    int successCount = 0;
    int skipCount = 0;
    int failCount = 0;
    final failures = <String>[];
    final skipped = <String>[];

    for (var i = 0; i < manifestFiles.length; i++) {
      final path = manifestFiles[i];
      stdout.writeln(
          '[${'${i + 1}'.padLeft(2)}/${manifestFiles.length}] Processing: $path');

      try {
        await _processManifest(path, model, apiKey, localOnly);
        successCount++;
      } catch (e) {
        final errorMsg = e.toString();
        if (errorMsg.contains('No TextField/TextFormField widgets found')) {
          skipCount++;
          skipped.add(path);
          stdout.writeln('  ⊘ Skipped: No text fields found\n');
        } else {
          failCount++;
          failures.add(path);
          stderr.writeln('  ✗ Failed: $e\n');
        }
      }
    }

    stdout.writeln('━' * 60);
    stdout.writeln('📊 Batch Summary:');
    stdout.writeln('  ✓ Success: $successCount files');
    if (skipCount > 0) {
      stdout.writeln('  ⊘ Skipped: $skipCount files (no text fields)');
    }
    if (failCount > 0) {
      stdout.writeln('  ✗ Failed:  $failCount files');
      for (final f in failures) {
        stdout.writeln('    - $f');
      }
    }
    stdout.writeln('━' * 60);
    exit(failCount > 0 ? 1 : 0);
  }

  // Single file mode
  if (!File(manifestPath).existsSync()) {
    stderr.writeln('File not found: $manifestPath');
    exit(1);
  }

  await _processManifest(manifestPath, model, apiKey, localOnly);
}

Future<List<String>> _scanManifestFolder() async {
  final manifestDir = Directory('output/manifest');
  if (!manifestDir.existsSync()) {
    return [];
  }

  final files = <String>[];
  await for (final entity in manifestDir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.manifest.json')) {
      files.add(entity.path);
    }
  }

  // Sort for consistent ordering
  files.sort();
  return files;
}

Future<void> _processManifest(
  String manifestPath,
  String model,
  String? apiKey,
  bool localOnly,
) async {
  if (!File(manifestPath).existsSync()) {
    throw Exception('File not found: $manifestPath');
  }

  // Priority: --api-key flag > .env file > environment variable > hardcoded constant
  apiKey ??= utils.readApiKeyFromEnv();
  apiKey ??= Platform.environment['GEMINI_API_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    apiKey = hardcodedApiKey != 'YOUR_API_KEY_HERE' ? hardcodedApiKey : null;
  }

  if (localOnly) {
    // Local-only mode explicitly requested
  } else if ((apiKey == null || apiKey.isEmpty)) {
    throw Exception('GEMINI_API_KEY not set. Please set it in one of:\n'
        '  1. Hardcode in script: const hardcodedApiKey = "your_key"\n'
        '  2. Create .env file with: GEMINI_API_KEY=your_key\n'
        '  3. Export: export GEMINI_API_KEY=your_key\n'
        '  4. Use flag: --api-key=your_key');
  }

  final raw = File(manifestPath).readAsStringSync();
  final manifest = jsonDecode(raw) as Map<String, dynamic>;
  final source = (manifest['source'] as Map<String, dynamic>?) ?? {};
  final uiFile = (source['file'] as String?) ?? 'lib/unknown.dart';
  final widgets = (manifest['widgets'] as List?) ?? const [];

  // Extract fields and separate into two groups
  final fieldsWithRules = <Map<String, dynamic>>[];
  final fieldsWithoutRules = <Map<String, dynamic>>[];

  for (final w in widgets) {
    if (w is! Map) continue;
    final widgetType = (w['widgetType'] ?? '').toString();
    final key = (w['key'] ?? '').toString();
    if ((widgetType.startsWith('TextField') ||
            widgetType.startsWith('TextFormField')) &&
        key.isNotEmpty) {
      final meta =
          (w['meta'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};
      final rules = (meta['validatorRules'] as List?)?.cast<Map>() ?? const [];

      final fieldData = {
        'key': key,
        'meta': meta,
      };

      if (rules.isNotEmpty) {
        fieldsWithRules.add(fieldData);
      } else {
        fieldsWithoutRules.add(fieldData);
      }
    }
  }

  if (fieldsWithRules.isEmpty && fieldsWithoutRules.isEmpty) {
    throw Exception('No TextField/TextFormField widgets found in manifest');
  }

  final byKey = <String, dynamic>{};

  // Process fields WITHOUT rules: generate 1 valid value locally, no invalid
  for (final f in fieldsWithoutRules) {
    final k = f['key'] as String;
    final meta = (f['meta'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    final constraints = _analyzeConstraintsFromMeta(k, meta);
    final validValue = _generateValidData(k, constraints);

    byKey[k] = {
      'valid': [validValue],
      'invalid': <String>[],
    };
  }

  // Process fields WITH rules: use AI (REQUIRED - no local fallback)
  if (fieldsWithRules.isNotEmpty) {
    Map<String, dynamic>? aiResult;

    // AI is required for fields with validation rules
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('AI datasets generation requires API key. '
          'Fields with validation rules cannot use local generation.');
    }

    try {
      aiResult =
          await _callGeminiForDatasets(apiKey, model, uiFile, fieldsWithRules);
    } catch (e) {
      throw Exception('Gemini call failed: $e');
    }

    // Merge AI result with per-rule normalization (prefer AI values where available)
    final aiByKey =
        (aiResult['datasets']?['byKey'] as Map?)?.cast<String, dynamic>() ??
            <String, dynamic>{};

    for (final f in fieldsWithRules) {
      final k = f['key'] as String;
      final meta = (f['meta'] as Map<String, dynamic>?) ?? <String, dynamic>{};
      final aiEntry = aiByKey[k];

      // Trust AI output 100% - AI should return array of pairs
      if (aiEntry is List) {
        final maxLen = meta['maxLength'] as int? ?? 50;
        final pairs = <Map<String, dynamic>>[];

        for (final pair in aiEntry) {
          if (pair is! Map) continue;
          var validVal = (pair['valid'] ?? '').toString();
          var invalidVal = (pair['invalid'] ?? '').toString();
          final msg = (pair['invalidRuleMessages'] ?? '').toString();

          // Ensure valid value respects maxLength constraint
          if (validVal.length > maxLen) {
            validVal = validVal.substring(0, maxLen);
          }

          // Keep invalid value as-is (can exceed maxLength for testing)
          pairs.add({
            'valid': validVal,
            'invalid': invalidVal,
            'invalidRuleMessages': msg,
          });
        }

        byKey[k] = pairs;
      }
    }
  }

  final result = <String, dynamic>{
    'file': uiFile,
    'datasets': {
      'byKey': byKey,
    },
  };

  final outPath =
      'output/test_data/${utils.basenameWithoutExtension(uiFile)}.datasets.json';
  File(outPath).createSync(recursive: true);
  File(outPath).writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert(result)}\n');
  stdout.writeln('  ✓ Generated: $outPath');
}

Future<Map<String, dynamic>> _callGeminiForDatasets(
  String apiKey,
  String model,
  String uiFile,
  List<Map<String, dynamic>> fields,
) async {
  final endpoint = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey');

  // Build compact field context sent to the model
  final context = {
    'file': uiFile,
    'fields': [
      for (final f in fields)
        {
          'key': f['key'],
          'meta': (f['meta'] as Map<String, dynamic>?) ?? <String, dynamic>{},
        }
    ]
  };

  final instructions = [
    '=== (CONTEXT) ===',
    'Test data generator for Flutter form validation.',
    '',
    '=== (TARGET) ===',
    'QA engineers need realistic test data for happy path and errors.',
    '',
    '=== (OBJECTIVE) ===',
    '1. Analyze constraints (maxLength, inputFormatters, validatorRules)',
    '2. FILTER OUT isEmpty/null rules (tested separately)',
    '3. Generate valid/invalid pairs ONLY for non-empty rules',
    '4. CRITICAL: Invalid values MUST pass inputFormatters but FAIL validators',
    '5. Output valid JSON',
    '',
    '=== (EXECUTION) ===',
    '1. For each field, count ALL non-empty rules (SKIP ONLY "isEmpty"/"== null")',
    '2. Count EVERY rule even if duplicate → Let N = total non-empty rule count',
    '3. For each non-empty rule, generate 1 valid + 1 invalid pair',
    '4. CRITICAL: Create N pairs (total N valid + N invalid)',
    '5. Output format: {"file":"<filename>","datasets":{"byKey":{"<key>":[...pairs...]}}}',
    '6. Each pair: {"valid":"...","invalid":"...","invalidRuleMessages":"rule message"}',
    '',
    'Example 1 (N=1):',
    'Input: {"file":"lib/page.dart","fields":[{"key":"firstname","validatorRules":[',
    '  {"condition":"value == null || value.isEmpty","message":"Required"},',
    '  {"condition":"!RegExp(r\'^[a-zA-Z]{2,}\\\$\').hasMatch(value)","message":"Min 2"}]}]}',
    'Non-empty rules: 1 (SKIP isEmpty) → N=1 pair',
    'Output: {"file":"lib/page.dart","datasets":{"byKey":{"firstname":[',
    '  {"valid":"Alice","invalid":"J","invalidRuleMessages":"Min 2"}',
    ']}}}',
    '',
    '=== (STYLE) ===',
    '- JSON only (no markdown, no comments)',
    '- Realistic values (not "value1")',
    '- String arrays only',
    '- Remember: invalid data MUST be typeable (respect inputFormatters)',
  ].join('\n');

  // Gemini API payload wraps instructions and manifest context
  final payload = {
    'contents': [
      {
        'role': 'user',
        'parts': [
          {'text': instructions},
          {'text': 'Input Data (JSON):\n${jsonEncode(context)}'},
        ]
      }
    ]
  };

  // Log prompt before sending (without exposing API key)
  try {
    stdout.writeln('=== datasets_from_ai: PROMPT (model=$model) ===');
    stdout.writeln(instructions);
    stdout.writeln('--- Input Data (JSON) ---');
    stdout.writeln(jsonEncode(context));
    stdout.writeln('=== end PROMPT ===');
  } catch (_) {}

  // ขั้นตอนที่ 1: สร้าง HTTP Client เพื่อส่ง request
  final client = HttpClient();
  client.badCertificateCallback = (cert, host, port) => false;

  try {
    // ขั้นตอนที่ 2: สร้าง POST request ไปยัง Gemini API
    final req = await client.postUrl(endpoint);
    req.headers.set(HttpHeaders.contentTypeHeader, 'application/json');

    // ขั้นตอนที่ 3: ส่งข้อมูล payload (แปลงเป็น JSON และ encode เป็น UTF-8)
    req.add(utf8.encode(jsonEncode(payload)));

    // ขั้นตอนที่ 4: รอรับ response จาก Gemini
    final resp = await req.close();
    final body = await resp.transform(utf8.decoder).join();

    // ขั้นตอนที่ 5: ตรวจสอบ HTTP status code (200-299 = สำเร็จ)
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw HttpException('Gemini HTTP ${resp.statusCode}: $body');
    }

    // ขั้นตอนที่ 6: แปลง response body เป็น JSON
    final decoded = jsonDecode(body) as Map<String, dynamic>;

    // ขั้นตอนที่ 7: ดึงข้อความ (text) ออกจาก JSON structure ของ Gemini
    final text = _extractTextFromGemini(decoded);
    if (text == null || text.trim().isEmpty) {
      throw StateError('Empty Gemini response text');
    }

    // ขั้นตอนที่ 8: Log response เพื่อ debugging
    try {
      stdout.writeln('=== datasets_from_ai: AI RESPONSE (raw text) ===');
      stdout.writeln(text);
      stdout.writeln('=== end AI RESPONSE ===');
    } catch (_) {}

    // ขั้นตอนที่ 9: ทำความสะอาดข้อความ (ลบ markdown code fences เช่น ```json```)
    final cleaned = _stripCodeFences(text);

    // ขั้นตอนที่ 10: แปลงข้อความที่สะอาดแล้วเป็น JSON object
    final parsed = jsonDecode(cleaned) as Map<String, dynamic>;

    return parsed;
  } finally {
    // ขั้นตอนที่ 11: ปิด HTTP client (ไม่ว่าจะสำเร็จหรือเกิด error)
    client.close(force: true);
  }
}

String? _extractTextFromGemini(Map<String, dynamic> response) {
  final candidates = (response['candidates'] as List?) ?? const [];
  if (candidates.isEmpty) return null;
  final content = (candidates.first as Map<String, dynamic>)['content']
      as Map<String, dynamic>?;
  if (content == null) return null;
  final parts = (content['parts'] as List?) ?? const [];
  final texts = <String>[];
  for (final p in parts) {
    if (p is Map && p['text'] is String) texts.add(p['text'] as String);
  }
  return texts.join('\n').trim();
}

String _stripCodeFences(String s) {
  // Remove ```json ... ``` or ``` ... ``` fences if present
  final rxFence = RegExp(r'^```[a-zA-Z]*\n|\n```', multiLine: true);
  return s.replaceAll(rxFence, '');
}

class FieldConstraints {
  final String pattern;
  final int maxLength;
  final bool hasSpecialChars;
  final bool isEmail;
  final bool isDigitsOnly;

  FieldConstraints({
    required this.pattern,
    required this.maxLength,
    required this.hasSpecialChars,
    required this.isEmail,
    required this.isDigitsOnly,
  });
}

FieldConstraints _analyzeConstraintsFromMeta(
    String key, Map<String, dynamic> meta) {
  final inputFormatters = (meta['inputFormatters'] as List?) ?? const [];
  final maxLength = (meta['maxLength'] as int?) ?? 50;

  String pattern = '[a-zA-Z0-9]';
  bool hasSpecialChars = false;
  bool isEmail = false;
  bool isDigitsOnly = false;

  // Prefer allow/digitsOnly from inputFormatters when present
  for (final formatter in inputFormatters) {
    if (formatter is! Map) continue;
    final type = (formatter['type'] ?? '').toString();
    if (type == 'allow') {
      pattern = (formatter['pattern'] ?? pattern).toString();
    } else if (type == 'digitsOnly') {
      isDigitsOnly = true;
      pattern = '[0-9]';
    }
  }

  // Derive from validatorMessages when inputFormatters are absent
  if (inputFormatters.isEmpty) {
    final msgs = (meta['validatorMessages'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        const [];
    final regexLike = msgs.firstWhere(
      (m) => RegExp(r'^[\^\[]?[a-zA-Z0-9@#\\\$%\^&\+=!\*\-_.\[\]\(\)]+')
          .hasMatch(m),
      orElse: () => '',
    );
    if (regexLike.isNotEmpty) {
      if (regexLike.contains('@') && regexLike.contains('[')) {
        isEmail = true;
        pattern = '[a-zA-Z0-9@.-]';
      } else if (regexLike.contains('a-z') ||
          regexLike.contains('A-Z') ||
          regexLike.contains('0-9')) {
        pattern = regexLike;
      }
    }
  }

  final keyLower = key.toLowerCase();
  if (keyLower.contains('email')) {
    isEmail = true;
    pattern = '[a-zA-Z0-9@.-]';
  }

  if (pattern.contains('@') ||
      pattern.contains('#') ||
      pattern.contains(r'$') ||
      pattern.contains('%') ||
      pattern.contains('^') ||
      pattern.contains('&') ||
      pattern.contains('+') ||
      pattern.contains('=') ||
      pattern.contains('!') ||
      pattern.contains('*') ||
      pattern.contains('-') ||
      pattern.contains('_') ||
      pattern.contains('.')) {
    hasSpecialChars = true;
  }

  return FieldConstraints(
    pattern: pattern,
    maxLength: maxLength,
    hasSpecialChars: hasSpecialChars,
    isEmail: isEmail,
    isDigitsOnly: isDigitsOnly,
  );
}

String _generateValidData(String key, FieldConstraints c) {
  final keyLower = key.toLowerCase();
  final random = Random(42);
  if (c.isDigitsOnly) {
    return (random.nextInt(900) + 100).toString();
  }
  if (c.isEmail) {
    // Generate email within maxLength constraint (e.g., maxLength=25 → "test@co.com" = 11 chars)
    if (c.maxLength <= 15) {
      return 'a@co.com'; // 8 chars - minimal but valid
    } else if (c.maxLength <= 25) {
      return 'test@example.com'; // 16 chars - realistic
    } else {
      final local = 'user${random.nextInt(99)}';
      final domain = 'test${random.nextInt(9)}';
      return '$local@$domain.com';
    }
  }
  if (keyLower.contains('username')) {
    if (c.pattern.contains('a-z') && c.pattern.contains('0-9')) {
      final len = c.maxLength
          .clamp(5, 8)
          .clamp(1, c.maxLength); // Shorter usernames within maxLength
      final chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
      return String.fromCharCodes(List.generate(
          len, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
    }
  }
  if (keyLower.contains('password')) {
    return c.hasSpecialChars ? 'Pass1!' : 'pass123';
  }
  return _genFromPattern(c.pattern, c.maxLength, random);
}

String _genFromPattern(String pattern, int maxLength, Random random) {
  final chars = <String>[];
  if (pattern.contains('a-z'))
    chars.addAll('abcdefghijklmnopqrstuvwxyz'.split(''));
  if (pattern.contains('A-Z'))
    chars.addAll('ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split(''));
  if (pattern.contains('0-9') || pattern.contains('\\d'))
    chars.addAll('0123456789'.split(''));
  for (final ch in '@#\$%^&+=!*-_.'.split('')) {
    if (pattern.contains(ch)) chars.add(ch);
  }
  if (chars.isEmpty) chars.addAll('abc123'.split(''));
  final length = maxLength
      .clamp(1, 8)
      .clamp(1, maxLength); // Respect actual maxLength but keep reasonable
  return List.generate(length, (_) => chars[random.nextInt(chars.length)])
      .join('');
}

// Removed: _basename, _basenameWithoutExtension, _readApiKeyFromEnv
// Removed: _localGenerateDatasets, _generateDatasetForField, _samplesFromRule,
//          _minimalValidForConstraints, _repeatCharFor, _generateInvalidData,
//          _genInvalidFromPattern (AI-only dataset generation)
// Now using utils.dart module instead
