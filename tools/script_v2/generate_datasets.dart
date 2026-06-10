import 'dart:convert';
import 'dart:io';
import 'utils.dart' as utils;

// !!! SECURITY WARNING — DEMO/THESIS ONLY !!!
// This key may already be in git history. Before publishing: revoke all keys
// in Google Cloud Console, create a new one stored only in .env, and delete
// the hardcodedApiKey constant below.
// Key priority (high → low): --api-key flag | .env file | GEMINI_API_KEY env var | hardcoded fallback
const String hardcodedApiKey = 'GEMINI_API_KEY';

void main(List<String> args) async {
  String manifestPath = '';
  String model = 'gemini-flash-latest';
  String? apiKey;

  for (final a in args) {
    if (a.startsWith('--model=')) {
      model = a.substring('--model='.length);
    } else if (a.startsWith('--api-key=')) {
      apiKey = a.substring('--api-key='.length);
    } else if (!a.startsWith('--')) {
      manifestPath = a;
    }
  }

  if (manifestPath.isEmpty) {
    stderr.writeln('Error: No manifest file specified');
    stderr.writeln(
        'Usage: dart run tools/script_v2/generate_datasets.dart <manifest.json>');
    stderr.writeln(
        'Example: dart run tools/script_v2/generate_datasets.dart output/manifest/demos/buttons_page.manifest.json');
    exit(1);
  }

  if (!File(manifestPath).existsSync()) {
    stderr.writeln('File not found: $manifestPath');
    exit(1);
  }

  final generator = DatasetGenerator(model: model, apiKey: apiKey);
  await generator.generateDatasets(manifestPath);
}

Future<String?> generateDatasetsFromManifest(
  String manifestPath, {
  String model = 'gemini-2.5-flash',
  String? apiKey,
}) =>
    DatasetGenerator(model: model, apiKey: apiKey)
        .generateDatasets(manifestPath);

class DatasetGenerator {
  final String model;
  final String? apiKey;
  const DatasetGenerator({this.model = 'gemini-2.5-flash', this.apiKey});

  Future<String?> generateDatasets(String manifestPath) async {
    final success = await _processManifest(manifestPath, model, apiKey);

    if (!success) {
      return null;
    }

    final base = manifestPath
        .replaceAll('output/manifest/', '')
        .replaceAll(RegExp(r'\.manifest\.json$'), '');

    return 'output/test_data/$base.datasets.json';
  }

  Future<bool> _processManifest(
    String manifestPath,
    String model,
    String? apiKey,
  ) async {
    if (!File(manifestPath).existsSync()) {
      throw Exception('File not found: $manifestPath');
    }

    apiKey ??= utils.readApiKeyFromEnv();
    apiKey ??= Platform.environment['GEMINI_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      apiKey = hardcodedApiKey != 'YOUR_API_KEY_HERE' ? hardcodedApiKey : null;
    }

    if (apiKey == null || apiKey.isEmpty) {
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

    final allTextFields = <Map<String, dynamic>>[];

    for (final w in widgets) {
      if (w is! Map) continue;

      final widgetType = (w['widgetType'] ?? '').toString();
      final key = (w['key'] ?? '').toString();

      if ((widgetType.startsWith('TextField') ||
              widgetType.startsWith('TextFormField')) &&
          key.isNotEmpty) {
        final meta =
            (w['meta'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};

        // effectiveMaxLength: inputFormatters.lengthLimit takes priority over maxLength, then default 50
        int? effectiveMax = meta['maxLength'] as int?;
        final fmts = (meta['inputFormatters'] as List? ?? const []).cast<Map>();
        for (final fmt in fmts) {
          if ((fmt['type'] ?? '') == 'lengthLimit' && fmt['max'] is int) {
            effectiveMax = fmt['max'] as int;
            break;
          }
        }
        effectiveMax ??= 50;

        allTextFields.add({
          'key': key,
          'meta': {...meta, 'effectiveMaxLength': effectiveMax},
        });
      }
    }

    if (allTextFields.isEmpty) {
      stdout.writeln('  ⊘ Skipped: No TextField/TextFormField widgets found');
      return false;
    }

    Map<String, dynamic>? aiResult;

    try {
      aiResult =
          await _callGeminiForDatasets(apiKey, model, uiFile, allTextFields);
    } catch (e) {
      throw Exception('Gemini call failed: $e');
    }

    final byKey = <String, dynamic>{};

    final aiByKey =
        (aiResult['datasets']?['byKey'] as Map?)?.cast<String, dynamic>() ??
            <String, dynamic>{};

    for (final f in allTextFields) {
      final k = f['key'] as String;
      final meta = (f['meta'] as Map<String, dynamic>?) ?? <String, dynamic>{};

      final aiEntry = aiByKey[k];

      if (aiEntry is List) {
        final maxLen = meta['effectiveMaxLength'] as int? ?? 50;

        final pairs = <Map<String, dynamic>>[];

        bool isFirstPair = true;
        for (final pair in aiEntry) {
          if (pair is! Map) continue;

          var validVal = (pair['valid'] ?? '').toString();
          var invalidVal = (pair['invalid'] ?? '').toString();
          final msg = (pair['invalidRuleMessages'] ?? '').toString();

          if (validVal.length > maxLen) {
            validVal = validVal.substring(0, maxLen);
          }

          // invalid value is not truncated — may intentionally exceed maxLength to test that boundary

          final pairEntry = <String, dynamic>{
            'valid': validVal,
            'invalid': invalidVal,
            'invalidRuleMessages': msg,
          };

          // atMin/atMax are only added to the first pair
          if (isFirstPair) {
            final atMinVal = pair['atMin']?.toString() ?? '';
            pairEntry['atMin'] = atMinVal;

            var atMaxVal = pair['atMax']?.toString() ?? validVal;
            if (atMaxVal.length > maxLen) {
              atMaxVal = atMaxVal.substring(0, maxLen);
            }
            pairEntry['atMax'] = atMaxVal;

            isFirstPair = false;
          }

          pairs.add(pairEntry);
        }

        byKey[k] = pairs;
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
    _writeFileDataset(outPath, result);

    return true;
  }

  void _writeFileDataset(String outPath, Map<String, dynamic> result) {
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

    // Prompt sections are labeled (CONTEXT/TARGET/OBJECTIVE/EXECUTION/STYLE) so
    // the AI can distinguish role, task, reasoning steps, and output format.
    final instructions = [
      '=== (CONTEXT) ===',
      'Test data generator for Flutter form validation.',
      '',
      '=== (TARGET) ===',
      'QA engineers need REALISTIC test data for happy path and errors.',
      '',
      '=== (OBJECTIVE) ===',
      '1. Analyze field key name to understand field purpose (e.g., "firstname" → person name)',
      '2. Analyze constraints (maxLength, inputFormatters, validatorRules)',
      '3. Generate REALISTIC valid/invalid pairs for ALL fields',
      '4. For fields WITH validatorRules: generate pairs based on rules (skip isEmpty/null rules UNLESS they are the ONLY rule)',
      '5. For fields with ONLY isEmpty/null rule: invalid = "" (empty string), invalidRuleMessages = that rule\'s message',
      '6. For fields WITHOUT validatorRules: generate 1 realistic valid + 1 common invalid, invalidRuleMessages = ""',
      '7. CRITICAL: Invalid values MUST pass inputFormatters but represent bad data',
      '8. Also generate boundary values: atMin and atMax for each field',
      '9. Output valid JSON',
      '',
      '''=== (EXECUTION) ===
For fields WITH validatorRules:
  1. List all rules. SKIP rules whose condition contains "isEmpty" or "== null" (those are Required checks).
  2. For each remaining rule, generate exactly 1 pair:
     - Read the rule's "condition" carefully (e.g., "v.trim().length < 5", "n == null || n < 100000")
     - invalid: a value that makes that condition evaluate to TRUE → validator returns the error message
     - valid:   a value that makes that condition evaluate to FALSE → validator returns null (passes)
     - invalidRuleMessages: copy the EXACT "message" string from that rule — never paraphrase
  3. All values MUST still pass inputFormatters (e.g., digitsOnly field → invalid must be digits)
  4. For conditions containing "DateTime": treat the value as a date string in "DD/MM/YYYY" format — use the condition semantics to decide whether invalid/valid should be a past or future date (e.g., "isBefore(today)" → invalid = past date, valid = future date)

For fields with ONLY isEmpty/null rules (all non-empty rules are absent):
  1. invalid MUST be "" (empty string) — the only way to trigger the isEmpty rule
  2. invalidRuleMessages = EXACT message from that isEmpty/null rule
  3. Generate 1 realistic valid value

For fields WITHOUT validatorRules at all:
  1. Infer field type from key name (firstname→name, phone→phone number, email→email)
  2. Generate 1 pair with realistic valid value
  3. Generate common invalid value (e.g., too short, wrong format) that respects inputFormatters
  4. Set invalidRuleMessages to "" (empty string) — no UI-visible error message for this field

For boundary values (add to FIRST pair only):
  atMin: the absolute minimum value that can be physically typed into the field
    - Check inputFormatters to determine allowed input type
    - atMin = the smallest single-unit input: 1 digit for digitsOnly fields, 1 character for text fields
    - Does NOT need to pass validation — just needs to be typeable
    - For date fields (condition contains "DateTime"): use the earliest possible date in "DD/MM/YYYY" format
    - digitsOnly → "0",  text/no-formatter → "ก" or "A"
    - If truly nothing can be inferred: use "" (empty string)
  atMax: value at the maximum length boundary
    - ALWAYS use meta.effectiveMaxLength as the max — it is already computed (explicit or default 50)
    - Generate a realistic value whose character length == effectiveMaxLength exactly
    - MUST respect inputFormatters and be a realistic value (not just repeated chars)
    - For Thai name fields: use a realistic long Thai full name padded to reach the length
    - For free-text note fields: use a realistic sentence padded to reach the length
    - For email fields: pad local-part with chars to reach effectiveMaxLength
    - For digit-only fields: use digits that reach effectiveMaxLength

Output format: {"file":"<filename>","datasets":{"byKey":{"<key>":[...pairs...]}}}
Each pair: {"valid":"...","invalid":"...","invalidRuleMessages":"...","atMin":"...","atMax":"..."}
(atMin and atMax are ONLY in the FIRST pair of each field)''',
      'Example 1 (field with 2 rules, maxLength=100):',
      'Input: {"key":"firstname","meta":{"inputFormatters":[{"type":"lengthLimit","max":100}],"validatorRules":[',
      '  {"condition":"value.isEmpty","message":"Required"},',
      '  {"condition":"value.length < 2","message":"Min 2 chars"}]}}',
      'Reasoning: Skip isEmpty rule. Rule left: condition "value.length < 2" → invalid must have length < 2 → "J" (length 1). Message = exact "Min 2 chars".',
      'Output: {"firstname":[{"valid":"Alice","invalid":"J","invalidRuleMessages":"Min 2 chars","atMin":"A","atMax":"Alice Johnson Wongsuwan Charoenpong Panyanart Srisomboon Boonmee Suk"}]}',
      '',
      'Example 2 (field with numeric rule, digitsOnly):',
      'Input: {"key":"price_textfield","meta":{"inputFormatters":[{"type":"digitsOnly"}],"validatorRules":[',
      '  {"condition":"v == null || v.trim().isEmpty","message":"Required"},',
      '  {"condition":"n == null || n < 100000","message":"Min 100,000 THB"}]}}',
      'Reasoning: Skip isEmpty rule. Rule left: condition "n < 100000" → invalid must be digits < 100000 → "99999". Message = exact "Min 100,000 THB".',
      'Output: {"price_textfield":[{"valid":"150000","invalid":"99999","invalidRuleMessages":"Min 100,000 THB","atMin":"","atMax":"150000"}]}',
      '',
      'Example 3 (field without rules, no maxLength):',
      'Input: {"key":"nickname_textfield","meta":{}}',
      'Reasoning: No validatorRules → invalidRuleMessages = "".',
      'Output: {"nickname_textfield":[{"valid":"Johnny","invalid":"X","invalidRuleMessages":"","atMin":"","atMax":"Johnny"}]}',
      '',
      'Example 4 (field with ONLY isEmpty/null rule):',
      'Input: {"key":"prop_03_location_textfield","meta":{"validatorRules":[',
      '  {"condition":"v == null || v.trim().isEmpty","message":"กรุณากรอกจังหวัด / เมือง"}]}}',
      'Reasoning: Only rule is isEmpty/null → skip it as a non-empty rule, BUT since it is the ONLY rule, invalid must be "" to trigger it. Message = exact "กรุณากรอกจังหวัด / เมือง".',
      'Output: {"prop_03_location_textfield":[{"valid":"กรุงเทพมหานคร","invalid":"","invalidRuleMessages":"กรุณากรอกจังหวัด / เมือง","atMin":"","atMax":"กรุงเทพมหานคร"}]}',
      '',
      '=== (STYLE) ===',
      '- JSON only (no markdown, no comments)',
      '- REALISTIC values based on field purpose (Thai names for Thai app, etc.)',
      '- Valid values should look like real user input',
      '- Invalid values should be common mistakes users make',
      '- String arrays only',
      '- Remember: invalid data MUST be typeable (respect inputFormatters)',
    ].join('\n');

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

    try {
      stdout.writeln('=== datasets_from_ai: PROMPT (model=$model) ===');
      stdout.writeln(instructions);
      stdout.writeln('--- Input Data (JSON) ---');
      stdout.writeln(jsonEncode(context));
      stdout.writeln('=== end PROMPT ===');
    } catch (_) {
      // ignore output errors
    }

    final client = HttpClient();
    client.badCertificateCallback = (cert, host, port) => false;

    try {
      final req = await client.postUrl(endpoint);
      req.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
      req.add(utf8.encode(jsonEncode(payload)));
      final resp = await req.close();
      final body = await resp.transform(utf8.decoder).join();

      if (resp.statusCode < 200 || resp.statusCode >= 300) {
        throw HttpException('Gemini HTTP ${resp.statusCode}: $body');
      }

      final decoded = jsonDecode(body) as Map<String, dynamic>;
      final text = _extractTextFromGemini(decoded);

      if (text == null || text.trim().isEmpty) {
        throw StateError('Empty Gemini response text');
      }

      try {
        stdout.writeln('=== datasets_from_ai: AI RESPONSE (raw text) ===');
        stdout.writeln(text);
        stdout.writeln('=== end AI RESPONSE ===');
      } catch (_) {
        // ignore output errors
      }

      // Strip markdown code fences that the AI may wrap around the JSON response
      final cleaned = _stripCodeFences(text);

      final parsed = jsonDecode(cleaned) as Map<String, dynamic>;

      return parsed;
    } finally {
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
      if (p is Map && p['text'] is String) {
        texts.add(p['text'] as String);
      }
    }

    return texts.join('\n').trim();
  }

  String _stripCodeFences(String s) {
    final rxFence = RegExp(r'^```[a-zA-Z]*\n|\n```', multiLine: true);
    return s.replaceAll(rxFence, '');
  }
}
