// =============================================================================
// generate_datasets.dart
// =============================================================================
// Script สำหรับสร้าง test datasets โดยใช้ Google Gemini AI
// ใช้สำหรับ generate ข้อมูล valid/invalid สำหรับทดสอบ form validation
//
// วิธีใช้งาน:
//   Batch mode (ประมวลผลทุกไฟล์ใน output/manifest/):
//     dart run tools/script_v2/generate_datasets.dart
//
//   Single file mode (ประมวลผลไฟล์เดียว):
//     dart run tools/script_v2/generate_datasets.dart output/manifest/demos/register_page.manifest.json
//
// Options:
//   --model=<model_name>  : เลือก AI model (default: gemini-2.5-flash)
//   --api-key=<key>       : ระบุ API key โดยตรง
//
// Environment Variables:
//   GEMINI_API_KEY  : API key สำหรับ Gemini API
//   .env file       : อ่าน GEMINI_API_KEY จากไฟล์ .env ใน project root
//
// Output:
//   สร้างไฟล์ .datasets.json ใน output/test_data/ folder
// =============================================================================

// -----------------------------------------------------------------------------
// Import Libraries
// -----------------------------------------------------------------------------

// dart:convert - ไลบรารีสำหรับจัดการ encoding/decoding
// - jsonEncode() : แปลง Map/List เป็น JSON string
// - jsonDecode() : แปลง JSON string เป็น Map/List
// - utf8         : encoder/decoder สำหรับ UTF-8 text
import 'dart:convert';

// dart:io - ไลบรารีสำหรับ I/O operations
// - File         : อ่าน/เขียนไฟล์
// - Directory    : จัดการ folder
// - HttpClient   : ส่ง HTTP requests
// - Platform     : เข้าถึง environment variables
// - stderr/stdout: เขียน output ไปยัง console
import 'dart:io';

// utils.dart - utility functions ที่ใช้ร่วมกับ scripts อื่นในโปรเจค
// - readApiKeyFromEnv()      : อ่าน API key จากไฟล์ .env
// - basenameWithoutExtension(): ดึงชื่อไฟล์โดยไม่มี extension
import 'utils.dart' as utils;

// =============================================================================
// API KEY CONFIGURATION
// =============================================================================
// คำเตือนด้านความปลอดภัย: ไม่ควร hardcode API key ใน source code
// วิธีที่แนะนำ:
//   1. สร้างไฟล์ .env และใส่: GEMINI_API_KEY=your_key
//   2. Export environment variable: export GEMINI_API_KEY=your_key
//   3. ใช้ flag: --api-key=your_key
// รับ API key ได้จาก: https://aistudio.google.com/app/apikey
// =============================================================================

// ค่าคงที่สำหรับเก็บ API key แบบ hardcode (ใช้เป็น fallback)
// SECURITY WARNING: ไม่ควรใช้ในโปรดักชัน ควรใช้ environment variable แทน
const String hardcodedApiKey = 'AIzaSyBisSJ5CrkfJFNTIX76h7F93NVBz2XEJcQ';

// =============================================================================
// PUBLIC API FUNCTION
// =============================================================================

/// Function สาธารณะสำหรับเรียกใช้จาก script อื่น (เช่น flutter_test_generator.dart)
///
/// Parameter:
///   [manifestPath] - path ของไฟล์ manifest.json ที่ต้องการประมวลผล
///                    เช่น "output/manifest/demos/login_page.manifest.json"
///
/// Named Parameters:
///   [model]     - ชื่อ AI model ที่จะใช้ (default: gemini-2.5-flash)
///                 ตัวเลือกอื่น: gemini-1.5-pro, gemini-1.0-pro
///   [apiKey]    - API key สำหรับ Gemini (optional)
///                 ถ้าไม่ระบุ จะหาจาก .env หรือ environment variable
///
/// Returns:
///   Future<String?> - path ของ output file ที่สร้าง
///                     หรือ null ถ้าไม่พบ text fields ใน manifest
///
/// Throws:
///   Exception - ถ้าเกิด error (API issues, file not found, parsing error, etc.)
///
/// Example:
///   final outputPath = await generateDatasetsFromManifest(
///     'output/manifest/demos/login.manifest.json',
///     model: 'gemini-2.5-flash',
///   );
///   print('Generated: $outputPath');
Future<String?> generateDatasetsFromManifest(
  String manifestPath, {
  String model = 'gemini-2.5-flash',
  String? apiKey,
}) async {
  // เรียก _processManifest() ซึ่งเป็น function หลักในการประมวลผล
  // function นี้จะ:
  // 1. อ่านไฟล์ manifest
  // 2. วิเคราะห์ fields และ validation rules
  // 3. เรียก AI เพื่อ generate datasets
  // 4. เขียน output file
  //
  // Returns: true = success, false = skipped (no text fields)
  final success = await _processManifest(manifestPath, model, apiKey);

  // ถ้าไม่พบ TextField ในไฟล์ manifest
  // return null เพื่อบอกว่าข้ามไฟล์นี้
  if (!success) {
    return null;
  }

  // คำนวณ output path จาก input path โดยใช้ string manipulation
  // Step 1: ลบ prefix 'output/manifest/' ออก
  // Step 2: ลบ suffix '.manifest.json' ออก (ใช้ RegExp)
  // Step 3: เพิ่ม prefix 'output/test_data/' และ suffix '.datasets.json'
  //
  // ตัวอย่าง:
  //   Input:  output/manifest/demos/page.manifest.json
  //   Step 1: demos/page.manifest.json
  //   Step 2: demos/page
  //   Output: output/test_data/demos/page.datasets.json
  final base = manifestPath
      .replaceAll('output/manifest/', '') // ลบ prefix folder
      .replaceAll(
          RegExp(r'\.manifest\.json$'), ''); // ลบ suffix extension ด้วย regex

  // return path ของไฟล์ที่สร้าง
  return 'output/test_data/$base.datasets.json';
}

// =============================================================================
// MAIN FUNCTION - Entry Point
// =============================================================================

/// Entry point ของ script เมื่อรันจาก command line
///
/// Parameter:
///   [args] - List ของ command line arguments ที่ส่งมาตอนรัน script
///            เช่น ['--model=gemini-pro', 'path/to/file.manifest.json']
///
/// ต้องระบุ manifest file path เป็น argument
void main(List<String> args) async {
  // ---------------------------------------------------------------------------
  // กำหนดค่าเริ่มต้นสำหรับ configuration variables
  // ---------------------------------------------------------------------------

  // path ของ manifest file ที่จะประมวลผล
  String manifestPath = '';

  // ชื่อ AI model ที่จะใช้
  // gemini-2.5-flash เป็น model ที่เร็วและราคาถูก เหมาะกับงาน generation
  String model = 'gemini-2.5-flash';

  // API key สำหรับเรียก Gemini API
  // null = จะหาจาก .env file หรือ environment variable
  String? apiKey;

  // ---------------------------------------------------------------------------
  // Parse Command Line Arguments
  // ---------------------------------------------------------------------------
  for (final a in args) {
    if (a.startsWith('--model=')) {
      model = a.substring('--model='.length);
    } else if (a.startsWith('--api-key=')) {
      apiKey = a.substring('--api-key='.length);
    } else if (!a.startsWith('--')) {
      manifestPath = a;
    }
  }

  // ---------------------------------------------------------------------------
  // Validate: ต้องระบุ manifest file
  // ---------------------------------------------------------------------------
  if (manifestPath.isEmpty) {
    stderr.writeln('Error: No manifest file specified');
    stderr.writeln(
        'Usage: dart run tools/script_v2/generate_datasets.dart <manifest.json>');
    stderr.writeln(
        'Example: dart run tools/script_v2/generate_datasets.dart output/manifest/demos/buttons_page.manifest.json');
    exit(1);
  }

  // ตรวจสอบว่าไฟล์มีอยู่จริงหรือไม่
  if (!File(manifestPath).existsSync()) {
    stderr.writeln('File not found: $manifestPath');
    exit(1);
  }

  // เรียก function หลักในการประมวลผล
  await _processManifest(manifestPath, model, apiKey);
}

// =============================================================================
// SCAN MANIFEST FOLDER
// =============================================================================

// =============================================================================
// PROCESS MANIFEST - ฟังก์ชันหลักในการประมวลผล
// =============================================================================

/// ประมวลผล manifest file เพื่อสร้าง datasets
///
/// Parameters:
///   [manifestPath] - path ของไฟล์ manifest.json ที่จะประมวลผล
///   [model]        - ชื่อ AI model ที่จะใช้ (เช่น gemini-2.5-flash)
///   [apiKey]       - API key สำหรับ Gemini (nullable - จะหาเองถ้าไม่ระบุ)
///
/// การทำงาน:
///   1. ตรวจสอบว่าไฟล์มีอยู่จริง
///   2. หา API key
///   3. อ่านและ parse manifest file
///   4. รวบรวม TextField/TextFormField ทั้งหมด
///   5. เรียก AI เพื่อสร้าง datasets
///   6. เขียน output file
///
/// Returns:
///   Future<bool> - true ถ้าสร้าง datasets สำเร็จ
///                  false ถ้าไม่พบ text fields (skip)
///
/// Throws:
///   Exception - ถ้าไฟล์ไม่พบ, ไม่มี API key, หรือ error อื่นๆ
Future<bool> _processManifest(
  String manifestPath,
  String model,
  String? apiKey,
) async {
  // ---------------------------------------------------------------------------
  // STEP 1: ตรวจสอบว่าไฟล์มีอยู่จริง
  // ---------------------------------------------------------------------------

  // File.existsSync() return true ถ้าไฟล์มีอยู่
  if (!File(manifestPath).existsSync()) {
    // throw Exception เพื่อ report error
    throw Exception('File not found: $manifestPath');
  }

  // ---------------------------------------------------------------------------
  // STEP 2: หา API Key ตามลำดับความสำคัญ
  // Priority (สูงไปต่ำ):
  //   1. --api-key flag (parameter)
  //   2. .env file
  //   3. GEMINI_API_KEY environment variable
  //   4. hardcoded constant (fallback)
  // ---------------------------------------------------------------------------

  // ถ้า apiKey ยังเป็น null ให้พยายามหาจากแหล่งอื่น
  // ??= หมายถึง assign ถ้าค่าปัจจุบันเป็น null

  // ลองอ่านจากไฟล์ .env ก่อน
  apiKey ??= utils.readApiKeyFromEnv();

  // ถ้ายังไม่มี ลองอ่านจาก environment variable
  apiKey ??= Platform.environment['GEMINI_API_KEY'];

  // ถ้ายังไม่มี ใช้ค่า hardcoded (ถ้าไม่ใช่ placeholder)
  if (apiKey == null || apiKey.isEmpty) {
    // ตรวจสอบว่า hardcodedApiKey ไม่ใช่ placeholder
    apiKey = hardcodedApiKey != 'YOUR_API_KEY_HERE' ? hardcodedApiKey : null;
  }

  // ---------------------------------------------------------------------------
  // STEP 3: ตรวจสอบ API key
  // ---------------------------------------------------------------------------

  if (apiKey == null || apiKey.isEmpty) {
    // ไม่มี API key = error
    // throw Exception พร้อมคำแนะนำวิธีตั้งค่า API key
    throw Exception('GEMINI_API_KEY not set. Please set it in one of:\n'
        '  1. Hardcode in script: const hardcodedApiKey = "your_key"\n'
        '  2. Create .env file with: GEMINI_API_KEY=your_key\n'
        '  3. Export: export GEMINI_API_KEY=your_key\n'
        '  4. Use flag: --api-key=your_key');
  }

  // ---------------------------------------------------------------------------
  // STEP 4: อ่านและ parse ไฟล์ manifest
  // ---------------------------------------------------------------------------

  // อ่านเนื้อหาทั้งไฟล์เป็น string
  final raw = File(manifestPath).readAsStringSync();

  // แปลง JSON string เป็น Map
  // jsonDecode return dynamic ต้อง cast เป็น Map<String, dynamic>
  final manifest = jsonDecode(raw) as Map<String, dynamic>;

  // ดึงข้อมูล source file จาก manifest
  // ใช้ ?. และ ?? เพื่อจัดการกรณี null
  final source = (manifest['source'] as Map<String, dynamic>?) ?? {};

  // ดึง path ของ UI file ที่ใช้สร้าง manifest นี้
  final uiFile = (source['file'] as String?) ?? 'lib/unknown.dart';

  // ดึง list ของ widgets จาก manifest
  final widgets = (manifest['widgets'] as List?) ?? const [];

  // ---------------------------------------------------------------------------
  // STEP 5: รวบรวม TextField/TextFormField ทั้งหมด
  // ส่งทุก field ไป AI เพื่อให้ได้ข้อมูลที่ realistic ที่สุด
  // ---------------------------------------------------------------------------

  // สร้าง List สำหรับเก็บ fields ทั้งหมด
  final allTextFields = <Map<String, dynamic>>[];

  // วนลูปตรวจสอบแต่ละ widget ใน manifest
  for (final w in widgets) {
    // ข้าม entry ที่ไม่ใช่ Map (ป้องกัน type error)
    if (w is! Map) continue;

    // ดึงประเภทของ widget (เช่น "TextField", "TextFormField")
    final widgetType = (w['widgetType'] ?? '').toString();

    // ดึง key ของ widget (ใช้เป็น identifier)
    final key = (w['key'] ?? '').toString();

    // กรอง: เอาเฉพาะ TextField/TextFormField ที่มี key
    // startsWith() เพราะอาจมี suffix เช่น "TextField<String>"
    if ((widgetType.startsWith('TextField') ||
            widgetType.startsWith('TextFormField')) &&
        key.isNotEmpty) {
      // ดึง metadata ของ widget
      // metadata มีข้อมูลเช่น maxLength, inputFormatters, validatorRules
      final meta =
          (w['meta'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};

      // เตรียมข้อมูล field สำหรับส่งไป AI
      allTextFields.add({
        'key': key,
        'meta': meta,
      });
    }
  }

  // ---------------------------------------------------------------------------
  // STEP 6: ตรวจสอบว่าพบ text fields หรือไม่
  // ---------------------------------------------------------------------------

  // ถ้าไม่พบ text fields เลย ให้ print และ return false (skip)
  // ไม่ throw exception เพราะไม่ถือเป็น error
  if (allTextFields.isEmpty) {
    stdout.writeln('  ⊘ Skipped: No TextField/TextFormField widgets found');
    return false;
  }

  // ---------------------------------------------------------------------------
  // STEP 7: เรียก AI เพื่อสร้าง datasets สำหรับทุก fields
  // ส่งทุก field ไป AI ไม่ว่าจะมี validation rules หรือไม่
  // เพื่อให้ได้ข้อมูล valid/invalid ที่ realistic ที่สุด
  // ---------------------------------------------------------------------------

  Map<String, dynamic>? aiResult;

  try {
    // ส่ง API key, model name, source file, และ list ของ fields ทั้งหมด
    aiResult =
        await _callGeminiForDatasets(apiKey, model, uiFile, allTextFields);
  } catch (e) {
    // wrap error ด้วย context message
    throw Exception('Gemini call failed: $e');
  }

  // ---------------------------------------------------------------------------
  // STEP 9: ประมวลผลผลลัพธ์จาก AI
  // ---------------------------------------------------------------------------

  // byKey จะเก็บ datasets โดยใช้ field key เป็น key ของ map
  final byKey = <String, dynamic>{};

  // ดึง datasets จาก AI response
  // AI return format: {datasets: {byKey: {...}}}
  final aiByKey =
      (aiResult['datasets']?['byKey'] as Map?)?.cast<String, dynamic>() ??
          <String, dynamic>{};

  // วนลูป fields ที่ส่งไป AI
  for (final f in allTextFields) {
    final k = f['key'] as String;
    final meta = (f['meta'] as Map<String, dynamic>?) ?? <String, dynamic>{};

    // ดึงผลลัพธ์จาก AI สำหรับ field นี้
    final aiEntry = aiByKey[k];

    // AI return array of pairs: [{valid, invalid, invalidRuleMessages}, ...]
    if (aiEntry is List) {
      // ดึง maxLength constraint (default 50)
      final maxLen = meta['maxLength'] as int? ?? 50;

      // สร้าง list เก็บ pairs ที่ processed แล้ว
      final pairs = <Map<String, dynamic>>[];

      // วนลูปแต่ละ pair จาก AI
      for (final pair in aiEntry) {
        // ข้าม entry ที่ไม่ใช่ Map
        if (pair is! Map) continue;

        // ดึงค่า valid และ invalid
        var validVal = (pair['valid'] ?? '').toString();
        var invalidVal = (pair['invalid'] ?? '').toString();

        // ดึง rule message ที่ invalid value จะ trigger
        final msg = (pair['invalidRuleMessages'] ?? '').toString();

        // ตรวจสอบ maxLength constraint สำหรับ valid value
        // valid value ต้องไม่เกิน maxLength
        if (validVal.length > maxLen) {
          validVal = validVal.substring(0, maxLen); // ตัดให้พอดี
        }

        // หมายเหตุ: invalid value ไม่ตัด
        // เพราะอาจต้องการทดสอบกรณี exceed maxLength

        // เพิ่ม pair ลง list
        pairs.add({
          'valid': validVal,
          'invalid': invalidVal,
          'invalidRuleMessages': msg,
        });
      }

      // บันทึกผลลัพธ์
      byKey[k] = pairs;
    }
  }

  // ---------------------------------------------------------------------------
  // STEP 11: สร้าง final result object
  // ---------------------------------------------------------------------------

  // สร้าง Map ที่มีโครงสร้างตามที่ต้องการ
  final result = <String, dynamic>{
    'file': uiFile, // path ของ source UI file
    'datasets': {
      'byKey': byKey, // datasets จัดกลุ่มตาม field key
    },
  };

  // ---------------------------------------------------------------------------
  // STEP 12: เขียน output file
  // ---------------------------------------------------------------------------

  // คำนวณ output path
  // ใช้ utility function เพื่อดึงชื่อไฟล์โดยไม่มี extension
  final outPath =
      'output/test_data/${utils.basenameWithoutExtension(uiFile)}.datasets.json';

  // สร้าง folder ถ้ายังไม่มี (recursive: true)
  File(outPath).createSync(recursive: true);

  // เขียน JSON ลงไฟล์
  // JsonEncoder.withIndent('  ') ทำให้ output อ่านง่าย (pretty print)
  File(outPath).writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert(result)}\n');

  // แสดง success message
  stdout.writeln('  ✓ Generated: $outPath');

  return true; // สำเร็จ
}

// =============================================================================
// CALL GEMINI API - เรียก AI เพื่อสร้าง datasets
// =============================================================================

/// เรียก Google Gemini API เพื่อสร้าง test datasets
///
/// Parameters:
///   [apiKey] - API key สำหรับ authenticate กับ Gemini API
///   [model]  - ชื่อ model ที่จะใช้ (เช่น gemini-2.5-flash)
///   [uiFile] - path ของ source UI file (ใช้เป็น context)
///   [fields] - List ของ fields ที่ต้องการสร้าง datasets
///              แต่ละ field มี key และ meta (validation rules)
///
/// Returns:
///   Future<Map<String, dynamic>> - ผลลัพธ์จาก AI
///   Format: {file: "...", datasets: {byKey: {...}}}
///
/// Throws:
///   HttpException - ถ้า HTTP request fail
///   StateError    - ถ้า response ว่างเปล่า
///   FormatException - ถ้า parse JSON ไม่ได้
Future<Map<String, dynamic>> _callGeminiForDatasets(
  String apiKey,
  String model,
  String uiFile,
  List<Map<String, dynamic>> fields,
) async {
  // ---------------------------------------------------------------------------
  // STEP 1: สร้าง API endpoint URL
  // ---------------------------------------------------------------------------

  // Gemini API endpoint format:
  // https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent?key={apiKey}
  final endpoint = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey');

  // ---------------------------------------------------------------------------
  // STEP 2: สร้าง context ที่จะส่งไป AI
  // ---------------------------------------------------------------------------

  // รวมข้อมูล file และ fields metadata เป็น Map
  final context = {
    'file': uiFile, // ชื่อ source file
    'fields': [
      // แปลง fields เป็น format ที่ AI เข้าใจ
      for (final f in fields)
        {
          'key': f['key'], // field key
          'meta': (f['meta'] as Map<String, dynamic>?) ?? <String, dynamic>{},
        }
    ]
  };

  // ---------------------------------------------------------------------------
  // STEP 3: สร้าง instructions (prompt) ให้ AI
  // ---------------------------------------------------------------------------

  // Prompt ประกอบด้วยหลายส่วน:
  // - CONTEXT: บอก AI ว่าเป็น system อะไร
  // - TARGET: บอก AI ว่าผู้ใช้คือใคร
  // - OBJECTIVE: บอก AI ว่าต้องทำอะไร
  // - EXECUTION: ขั้นตอนทำงานละเอียด
  // - STYLE: รูปแบบ output ที่ต้องการ
  final instructions = [
    // === CONTEXT: บริบทของระบบ ===
    '=== (CONTEXT) ===',
    'Test data generator for Flutter form validation.',
    '',

    // === TARGET: กลุ่มเป้าหมาย ===
    '=== (TARGET) ===',
    'QA engineers need REALISTIC test data for happy path and errors.',
    '',

    // === OBJECTIVE: วัตถุประสงค์ ===
    '=== (OBJECTIVE) ===',
    '1. Analyze field key name to understand field purpose (e.g., "firstname" → person name)',
    '2. Analyze constraints (maxLength, inputFormatters, validatorRules)',
    '3. Generate REALISTIC valid/invalid pairs for ALL fields',
    '4. For fields WITH validatorRules: generate pairs based on rules (skip isEmpty/null rules)',
    '5. For fields WITHOUT validatorRules: generate 1 realistic valid + 1 common invalid',
    '6. CRITICAL: Invalid values MUST pass inputFormatters but represent bad data',
    '7. Output valid JSON',
    '',

    // === EXECUTION: ขั้นตอนการทำงาน ===
    '=== (EXECUTION) ===',
    'For fields WITH validatorRules:',
    '  1. Count non-empty rules (SKIP "isEmpty"/"== null") → N rules',
    '  2. Generate N pairs (1 per rule)',
    '  3. Each pair: valid value that passes, invalid value that fails that specific rule',
    '',
    'For fields WITHOUT validatorRules:',
    '  1. Infer field type from key name (firstname→name, phone→phone number, email→email)',
    '  2. Generate 1 pair with realistic valid value',
    '  3. Generate common invalid value (e.g., too short, wrong format)',
    '  4. Use "general" as invalidRuleMessages',
    '',
    'Output format: {"file":"<filename>","datasets":{"byKey":{"<key>":[...pairs...]}}}',
    'Each pair: {"valid":"...","invalid":"...","invalidRuleMessages":"..."}',
    '',

    // === EXAMPLE: ตัวอย่าง ===
    'Example 1 (field with rules):',
    'Input: {"key":"firstname","meta":{"validatorRules":[',
    '  {"condition":"value.isEmpty","message":"Required"},',
    '  {"condition":"value.length < 2","message":"Min 2 chars"}]}}',
    'Output: {"firstname":[{"valid":"Alice","invalid":"J","invalidRuleMessages":"Min 2 chars"}]}',
    '',
    'Example 2 (field without rules):',
    'Input: {"key":"phone_textfield","meta":{"inputFormatters":[{"type":"digitsOnly"}]}}',
    'Output: {"phone_textfield":[{"valid":"0812345678","invalid":"081","invalidRuleMessages":"general"}]}',
    '',
    'Example 3 (name field without rules):',
    'Input: {"key":"nickname_textfield","meta":{}}',
    'Output: {"nickname_textfield":[{"valid":"Johnny","invalid":"X","invalidRuleMessages":"general"}]}',
    '',

    // === STYLE: รูปแบบ output ===
    '=== (STYLE) ===',
    '- JSON only (no markdown, no comments)',
    '- REALISTIC values based on field purpose (Thai names for Thai app, etc.)',
    '- Valid values should look like real user input',
    '- Invalid values should be common mistakes users make',
    '- String arrays only',
    '- Remember: invalid data MUST be typeable (respect inputFormatters)',
  ].join('\n'); // รวมทุกบรรทัดด้วย newline

  // ---------------------------------------------------------------------------
  // STEP 4: สร้าง payload ตาม format ของ Gemini API
  // ---------------------------------------------------------------------------

  // Gemini API request format:
  // {
  //   contents: [{
  //     role: "user",
  //     parts: [{text: "..."}, {text: "..."}]
  //   }]
  // }
  final payload = {
    'contents': [
      {
        'role': 'user', // role ของ message
        'parts': [
          {'text': instructions}, // prompt หลัก
          {
            'text': 'Input Data (JSON):\n${jsonEncode(context)}'
          }, // ข้อมูล input
        ]
      }
    ]
  };

  // ---------------------------------------------------------------------------
  // STEP 5: Log prompt (สำหรับ debugging)
  // ---------------------------------------------------------------------------

  // try-catch เพื่อป้องกัน output error ไม่ให้กระทบ main logic
  try {
    stdout.writeln('=== datasets_from_ai: PROMPT (model=$model) ===');
    stdout.writeln(instructions);
    stdout.writeln('--- Input Data (JSON) ---');
    stdout.writeln(jsonEncode(context));
    stdout.writeln('=== end PROMPT ===');
  } catch (_) {
    // ignore output errors
  }

  // ---------------------------------------------------------------------------
  // STEP 6: สร้าง HTTP Client และส่ง request
  // ---------------------------------------------------------------------------

  // สร้าง HTTP Client
  final client = HttpClient();

  // ตั้งค่า SSL certificate validation
  // return false = ไม่อนุญาต bad certificate (security best practice)
  client.badCertificateCallback = (cert, host, port) => false;

  try {
    // ---------------------------------------------------------------------------
    // STEP 6.1: สร้าง POST request
    // ---------------------------------------------------------------------------
    final req = await client.postUrl(endpoint);

    // ตั้ง Content-Type header เป็น application/json
    req.headers.set(HttpHeaders.contentTypeHeader, 'application/json');

    // ---------------------------------------------------------------------------
    // STEP 6.2: ส่ง payload
    // ---------------------------------------------------------------------------

    // แปลง payload เป็น JSON string แล้ว encode เป็น UTF-8 bytes
    req.add(utf8.encode(jsonEncode(payload)));

    // ---------------------------------------------------------------------------
    // STEP 6.3: รอรับ response
    // ---------------------------------------------------------------------------
    final resp = await req.close();

    // อ่าน response body ทั้งหมด
    // transform(utf8.decoder) แปลง bytes เป็น string
    // join() รวมทุก chunks เป็น string เดียว
    final body = await resp.transform(utf8.decoder).join();

    // ---------------------------------------------------------------------------
    // STEP 6.4: ตรวจสอบ HTTP status code
    // ---------------------------------------------------------------------------

    // HTTP 2xx = success
    // อื่นๆ = error
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw HttpException('Gemini HTTP ${resp.statusCode}: $body');
    }

    // ---------------------------------------------------------------------------
    // STEP 6.5: Parse response body
    // ---------------------------------------------------------------------------

    // แปลง JSON string เป็น Map
    final decoded = jsonDecode(body) as Map<String, dynamic>;

    // ---------------------------------------------------------------------------
    // STEP 6.6: ดึง text จาก Gemini response
    // ---------------------------------------------------------------------------

    // Gemini response format:
    // {candidates: [{content: {parts: [{text: "..."}]}}]}
    final text = _extractTextFromGemini(decoded);

    // ตรวจสอบว่าได้ text หรือไม่
    if (text == null || text.trim().isEmpty) {
      throw StateError('Empty Gemini response text');
    }

    // ---------------------------------------------------------------------------
    // STEP 6.7: Log response (สำหรับ debugging)
    // ---------------------------------------------------------------------------
    try {
      stdout.writeln('=== datasets_from_ai: AI RESPONSE (raw text) ===');
      stdout.writeln(text);
      stdout.writeln('=== end AI RESPONSE ===');
    } catch (_) {
      // ignore output errors
    }

    // ---------------------------------------------------------------------------
    // STEP 6.8: ทำความสะอาด text
    // ---------------------------------------------------------------------------

    // AI อาจ return response ในรูปแบบ markdown code block:
    // ```json
    // {"key": "value"}
    // ```
    // ต้องลบ code fences ออก
    final cleaned = _stripCodeFences(text);

    // ---------------------------------------------------------------------------
    // STEP 6.9: Parse cleaned text เป็น JSON
    // ---------------------------------------------------------------------------
    final parsed = jsonDecode(cleaned) as Map<String, dynamic>;

    return parsed;
  } finally {
    // ---------------------------------------------------------------------------
    // STEP 7: ปิด HTTP client
    // ---------------------------------------------------------------------------

    // force: true = ปิดทันทีไม่ว่าจะมี pending requests หรือไม่
    // ใช้ finally เพื่อให้แน่ใจว่า client ถูกปิดเสมอ
    client.close(force: true);
  }
}

// =============================================================================
// EXTRACT TEXT FROM GEMINI RESPONSE
// =============================================================================

/// ดึง text content ออกจาก Gemini API response
///
/// Gemini response format:
/// {
///   "candidates": [{
///     "content": {
///       "parts": [
///         {"text": "...response text..."}
///       ]
///     }
///   }]
/// }
///
/// Parameter:
///   [response] - Map ที่ได้จาก jsonDecode ของ API response
///
/// Returns:
///   String? - text content หรือ null ถ้าไม่พบ
String? _extractTextFromGemini(Map<String, dynamic> response) {
  // ดึง candidates array จาก response
  // ถ้าไม่มี candidates ให้ใช้ empty list
  final candidates = (response['candidates'] as List?) ?? const [];

  // ถ้าไม่มี candidates return null
  if (candidates.isEmpty) return null;

  // ดึง content จาก candidate ตัวแรก
  // candidates[0].content
  final content = (candidates.first as Map<String, dynamic>)['content']
      as Map<String, dynamic>?;

  // ถ้าไม่มี content return null
  if (content == null) return null;

  // ดึง parts array จาก content
  final parts = (content['parts'] as List?) ?? const [];

  // สร้าง list เก็บ text จากทุก parts
  final texts = <String>[];

  // วนลูปแต่ละ part
  for (final p in parts) {
    // ตรวจสอบว่า part เป็น Map และมี text field
    if (p is Map && p['text'] is String) {
      texts.add(p['text'] as String); // เพิ่ม text ลง list
    }
  }

  // รวม texts ทั้งหมดด้วย newline และ trim whitespace
  return texts.join('\n').trim();
}

// =============================================================================
// STRIP CODE FENCES
// =============================================================================

/// ลบ markdown code fences ออกจาก string
///
/// AI อาจ return response ในรูปแบบ markdown:
/// ```json
/// {"key": "value"}
/// ```
///
/// Function นี้จะลบ ```json (หรือ ``` ธรรมดา) ออก
/// เหลือแค่ JSON content ล้วนๆ
///
/// Parameter:
///   [s] - string ที่อาจมี code fences
///
/// Returns:
///   String - string ที่ไม่มี code fences
String _stripCodeFences(String s) {
  // สร้าง RegExp เพื่อจับ code fence patterns:
  // - ^```[a-zA-Z]*\n : เริ่มต้นด้วย ``` ตามด้วย language name (optional) แล้ว newline
  // - \n``` : newline ตามด้วย ```
  // multiLine: true ทำให้ ^ match ต้นบรรทัด (ไม่ใช่แค่ต้น string)
  final rxFence = RegExp(r'^```[a-zA-Z]*\n|\n```', multiLine: true);

  // ลบ pattern ที่ match ออกทั้งหมด
  return s.replaceAll(rxFence, '');
}

// =============================================================================
// NOTE: Local generation functions removed
// =============================================================================
// Functions เหล่านี้ถูกลบออกเพราะเปลี่ยนมาใช้ AI-only generation:
// - FieldConstraints class
// - _analyzeConstraintsFromMeta()
// - _generateValidData()
// - _genFromPattern()
//
// เหตุผล: AI สามารถ generate ข้อมูลที่ realistic และเหมาะสมกว่า
// โดยเข้าใจ context จากชื่อ field และ validation rules
// =============================================================================
