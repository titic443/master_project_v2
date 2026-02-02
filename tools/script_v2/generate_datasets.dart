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
//   --local-only          : ใช้ local generation เท่านั้น (ไม่เรียก AI)
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

// dart:math - ไลบรารีสำหรับ mathematical operations
// - Random       : สร้างตัวเลขสุ่ม
import 'dart:math';

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
const String hardcodedApiKey = 'AIzaSyCC2NXlV1ZOfbRRfA_L4VnHh4zu7MNAnbs';

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
///   [localOnly] - ถ้า true จะใช้ local generation แทนการเรียก AI
///                 เหมาะสำหรับ offline testing หรือ CI/CD
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
  bool localOnly = false,
}) async {
  // เรียก _processManifest() ซึ่งเป็น function หลักในการประมวลผล
  // function นี้จะ:
  // 1. อ่านไฟล์ manifest
  // 2. วิเคราะห์ fields และ validation rules
  // 3. เรียก AI หรือ local generation
  // 4. เขียน output file
  //
  // Returns: true = success, false = skipped (no text fields)
  final success = await _processManifest(manifestPath, model, apiKey, localOnly);

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
/// การทำงาน:
///   1. Parse command line arguments
///   2. ถ้าไม่ระบุไฟล์ -> Batch mode (ประมวลผลทุกไฟล์)
///   3. ถ้าระบุไฟล์ -> Single file mode
void main(List<String> args) async {
  // ---------------------------------------------------------------------------
  // กำหนดค่าเริ่มต้นสำหรับ configuration variables
  // ---------------------------------------------------------------------------

  // path ของ manifest file ที่จะประมวลผล
  // ถ้าว่าง = batch mode (ประมวลผลทุกไฟล์ใน folder)
  String manifestPath = '';

  // ชื่อ AI model ที่จะใช้
  // gemini-2.5-flash เป็น model ที่เร็วและราคาถูก เหมาะกับงาน generation
  String model = 'gemini-2.5-flash';

  // API key สำหรับเรียก Gemini API
  // null = จะหาจาก .env file หรือ environment variable
  String? apiKey;

  // flag สำหรับบังคับใช้ local generation (ไม่เรียก AI)
  // ใช้เมื่อต้องการ offline mode หรือ testing
  bool localOnly = false;

  // ---------------------------------------------------------------------------
  // Parse Command Line Arguments
  // วนลูปอ่าน arguments ทีละตัวและจัดการตามประเภท
  // ---------------------------------------------------------------------------
  for (final a in args) {
    // ตรวจสอบ flag --local-only (และ aliases)
    // ถ้าเจอ flag นี้จะบังคับใช้ local generation แทน AI
    if (a == '--local-only' || a == '--no-ai' || a == '--force-fallback') {
      localOnly = true; // set flag เป็น true
    }
    // flags ที่ deprecated แล้ว (เก็บไว้เพื่อ backward compatibility)
    // AI เป็น required by default ไม่จำเป็นต้องใช้ flag เหล่านี้
    else if (a == '--ai-required' || a == '--strict-ai') {
      // ไม่ทำอะไร - deprecated
    }
    // ตรวจสอบ flag --model=xxx
    // ใช้ระบุชื่อ AI model ที่ต้องการใช้
    else if (a.startsWith('--model=')) {
      // ดึงค่าหลัง '=' ออกมา
      // เช่น '--model=gemini-1.5-pro' -> 'gemini-1.5-pro'
      model = a.substring('--model='.length);
    }
    // ตรวจสอบ flag --api-key=xxx
    // ใช้ระบุ API key โดยตรงผ่าน command line
    else if (a.startsWith('--api-key=')) {
      // ดึงค่าหลัง '=' ออกมา
      apiKey = a.substring('--api-key='.length);
    }
    // argument ที่ไม่ขึ้นต้นด้วย '--' ถือเป็น file path
    else if (!a.startsWith('--')) {
      manifestPath = a; // เก็บเป็น path ของไฟล์ที่จะประมวลผล
    }
  }

  // ---------------------------------------------------------------------------
  // BATCH MODE - ประมวลผลทุกไฟล์ใน output/manifest/
  // เข้าสู่ mode นี้เมื่อไม่ได้ระบุ manifest path
  // ---------------------------------------------------------------------------
  if (manifestPath.isEmpty) {
    // เรียก function สแกนหาไฟล์ .manifest.json ทั้งหมด
    final manifestFiles = await _scanManifestFolder();

    // ตรวจสอบว่าพบไฟล์หรือไม่
    if (manifestFiles.isEmpty) {
      // ไม่พบไฟล์ -> แสดง error และ exit
      stderr
          .writeln('No .manifest.json files found in output/manifest/ folder');
      exit(1); // exit code 1 = error
    }

    // แสดงข้อมูลเริ่มต้น
    stdout.writeln('📁 Found ${manifestFiles.length} manifest file(s)');
    stdout.writeln('🚀 Starting batch dataset generation...\n');

    // ---------------------------------------------------------------------------
    // ตัวนับสถิติสำหรับสรุปผล batch processing
    // ---------------------------------------------------------------------------
    int successCount = 0; // จำนวนไฟล์ที่ประมวลผลสำเร็จ
    int skipCount = 0; // จำนวนไฟล์ที่ข้าม (ไม่มี text fields)
    int failCount = 0; // จำนวนไฟล์ที่ล้มเหลว (error)

    // List เก็บรายชื่อไฟล์ที่มีปัญหา (สำหรับแสดงใน summary)
    final failures = <String>[]; // ไฟล์ที่ล้มเหลว
    final skipped = <String>[]; // ไฟล์ที่ข้าม

    // ---------------------------------------------------------------------------
    // วนลูปประมวลผลแต่ละไฟล์
    // ---------------------------------------------------------------------------
    for (var i = 0; i < manifestFiles.length; i++) {
      // ดึง path ของไฟล์ปัจจุบัน
      final path = manifestFiles[i];

      // แสดง progress พร้อมหมายเลขลำดับ
      // Format: [01/10] Processing: path/to/file.manifest.json
      // padLeft(2) ทำให้เลขมี leading zero (01, 02, ... 10)
      stdout.writeln(
          '[${'${i + 1}'.padLeft(2)}/${manifestFiles.length}] Processing: $path');

      // try-catch สำหรับจัดการ error แต่ละไฟล์
      // (ถ้าไฟล์หนึ่ง error ไม่ให้กระทบไฟล์อื่น)
      try {
        // เรียก function หลักในการประมวลผล
        // return true = success, false = skipped (no text fields)
        final success = await _processManifest(path, model, apiKey, localOnly);

        if (success) {
          successCount++; // เพิ่มตัวนับสำเร็จ
        } else {
          // กรณี skip: ไม่มี text fields
          skipCount++;
          skipped.add(path);
        }
      } catch (e) {
        // กรณี fail: error จริงๆ (API error, parsing error, etc.)
        failCount++; // เพิ่มตัวนับ fail
        failures.add(path); // เก็บชื่อไฟล์
        stderr.writeln('  ✗ Failed: $e\n'); // แสดง error message
      }
    }

    // ---------------------------------------------------------------------------
    // แสดงสรุปผลการประมวลผล Batch
    // ---------------------------------------------------------------------------

    // เส้นคั่น (60 ตัวอักษร)
    stdout.writeln('━' * 60);

    // หัวข้อ summary
    stdout.writeln('📊 Batch Summary:');

    // แสดงจำนวนสำเร็จ
    stdout.writeln('  ✓ Success: $successCount files');

    // แสดงจำนวน skip (ถ้ามี)
    if (skipCount > 0) {
      stdout.writeln('  ⊘ Skipped: $skipCount files (no text fields)');
    }

    // แสดงจำนวน fail และรายชื่อไฟล์ (ถ้ามี)
    if (failCount > 0) {
      stdout.writeln('  ✗ Failed:  $failCount files');
      // วนลูปแสดงรายชื่อไฟล์ที่ fail
      for (final f in failures) {
        stdout.writeln('    - $f');
      }
    }

    // เส้นคั่นปิด
    stdout.writeln('━' * 60);

    // exit พร้อม exit code ที่เหมาะสม
    // 0 = สำเร็จทั้งหมด (หรือมีแค่ skip)
    // 1 = มี failure อย่างน้อย 1 ไฟล์
    exit(failCount > 0 ? 1 : 0);
  }

  // ---------------------------------------------------------------------------
  // SINGLE FILE MODE - ประมวลผลไฟล์เดียว
  // เข้าสู่ mode นี้เมื่อระบุ manifest path
  // ---------------------------------------------------------------------------

  // ตรวจสอบว่าไฟล์ที่ระบุมีอยู่จริงหรือไม่
  if (!File(manifestPath).existsSync()) {
    // ไม่พบไฟล์ -> แสดง error และ exit
    stderr.writeln('File not found: $manifestPath');
    exit(1);
  }

  // เรียก function หลักในการประมวลผล
  // ถ้าเกิด error จะ throw และ script จะ exit ด้วย error
  await _processManifest(manifestPath, model, apiKey, localOnly);
}

// =============================================================================
// SCAN MANIFEST FOLDER
// =============================================================================

/// สแกนหาไฟล์ .manifest.json ทั้งหมดใน output/manifest/ folder
///
/// การทำงาน:
///   1. ตรวจสอบว่า folder มีอยู่หรือไม่
///   2. วนลูปหาไฟล์แบบ recursive (รวม subfolders)
///   3. filter เอาเฉพาะไฟล์ที่ลงท้ายด้วย .manifest.json
///   4. sort ตามชื่อเพื่อให้ผลลัพธ์ consistent
///
/// Returns:
///   Future<List<String>> - List ของ file paths ที่พบ (เรียงตามชื่อ)
///                          หรือ empty list ถ้าไม่พบไฟล์
Future<List<String>> _scanManifestFolder() async {
  // สร้าง Directory object ชี้ไปยัง folder ที่ต้องการ scan
  final manifestDir = Directory('output/manifest');

  // ตรวจสอบว่า folder มีอยู่หรือไม่
  // ถ้าไม่มี return empty list ทันที (ไม่ throw error)
  if (!manifestDir.existsSync()) {
    return []; // return empty list
  }

  // สร้าง List สำหรับเก็บ paths ที่พบ
  final files = <String>[];

  // วนลูปหาไฟล์แบบ async
  // list(recursive: true) = รวม subfolders ด้วย
  await for (final entity in manifestDir.list(recursive: true)) {
    // ตรวจสอบว่าเป็น File (ไม่ใช่ Directory) และชื่อลงท้ายด้วย .manifest.json
    if (entity is File && entity.path.endsWith('.manifest.json')) {
      files.add(entity.path); // เพิ่มลง list
    }
  }

  // sort ตามชื่อเพื่อให้ผลลัพธ์ consistent ทุกครั้งที่รัน
  // (file system อาจ return ลำดับไม่เหมือนกันแต่ละครั้ง)
  files.sort();

  return files; // return list ของ paths
}

// =============================================================================
// PROCESS MANIFEST - ฟังก์ชันหลักในการประมวลผล
// =============================================================================

/// ประมวลผล manifest file เพื่อสร้าง datasets
///
/// Parameters:
///   [manifestPath] - path ของไฟล์ manifest.json ที่จะประมวลผล
///   [model]        - ชื่อ AI model ที่จะใช้ (เช่น gemini-2.5-flash)
///   [apiKey]       - API key สำหรับ Gemini (nullable - จะหาเองถ้าไม่ระบุ)
///   [localOnly]    - true = บังคับใช้ local generation, false = ใช้ AI
///
/// การทำงาน:
///   1. ตรวจสอบว่าไฟล์มีอยู่จริง
///   2. หา API key (ถ้าต้องใช้ AI)
///   3. อ่านและ parse manifest file
///   4. แยก fields ตามประเภท (มี/ไม่มี validation rules)
///   5. สร้าง datasets (local หรือ AI)
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
  bool localOnly,
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
  // STEP 3: ตรวจสอบ mode และ API key
  // ---------------------------------------------------------------------------

  if (localOnly) {
    // Local-only mode: ไม่ต้องใช้ API key
    // จะใช้ local generation สำหรับทุก fields
  } else if ((apiKey == null || apiKey.isEmpty)) {
    // AI mode แต่ไม่มี API key = error
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
  // STEP 5: แยก fields เป็น 2 กลุ่ม
  // กลุ่ม 1: fieldsWithRules - มี validation rules (ต้องใช้ AI)
  // กลุ่ม 2: fieldsWithoutRules - ไม่มี rules (generate locally ได้)
  // ---------------------------------------------------------------------------

  // สร้าง Lists สำหรับเก็บ fields แต่ละกลุ่ม
  final fieldsWithRules = <Map<String, dynamic>>[]; // fields ที่มี rules
  final fieldsWithoutRules = <Map<String, dynamic>>[]; // fields ที่ไม่มี rules

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

      // ดึง validation rules จาก metadata
      // rules เป็น list ของ maps ที่มี condition และ message
      final rules = (meta['validatorRules'] as List?)?.cast<Map>() ?? const [];

      // เตรียมข้อมูล field สำหรับส่งไป process
      final fieldData = {
        'key': key,
        'meta': meta,
      };

      // แยก field ตาม rules
      if (rules.isNotEmpty) {
        // มี rules -> ต้องใช้ AI เพื่อวิเคราะห์และสร้าง valid/invalid pairs
        fieldsWithRules.add(fieldData);
      } else {
        // ไม่มี rules -> สามารถ generate locally ได้
        fieldsWithoutRules.add(fieldData);
      }
    }
  }

  // ---------------------------------------------------------------------------
  // STEP 6: ตรวจสอบว่าพบ text fields หรือไม่
  // ---------------------------------------------------------------------------

  // ถ้าไม่พบ text fields เลย ให้ print และ return false (skip)
  // ไม่ throw exception เพราะไม่ถือเป็น error
  if (fieldsWithRules.isEmpty && fieldsWithoutRules.isEmpty) {
    stdout.writeln('  ⊘ Skipped: No TextField/TextFormField widgets found');
    return false;
  }

  // ---------------------------------------------------------------------------
  // STEP 7: สร้าง result map สำหรับเก็บ datasets
  // ---------------------------------------------------------------------------

  // byKey จะเก็บ datasets โดยใช้ field key เป็น key ของ map
  // เช่น { "email": {...}, "password": {...} }
  final byKey = <String, dynamic>{};

  // ---------------------------------------------------------------------------
  // STEP 8: ประมวลผล Fields ที่ไม่มี rules (LOCAL GENERATION)
  // Fields เหล่านี้ไม่มี validation rules จึงสร้าง valid value ได้ง่าย
  // ไม่จำเป็นต้องสร้าง invalid value เพราะไม่มี rules ที่จะ fail
  // ---------------------------------------------------------------------------

  for (final f in fieldsWithoutRules) {
    // ดึง key ของ field
    final k = f['key'] as String;

    // ดึง metadata
    final meta = (f['meta'] as Map<String, dynamic>?) ?? <String, dynamic>{};

    // วิเคราะห์ constraints จาก metadata
    // เช่น maxLength, inputFormatters, etc.
    final constraints = _analyzeConstraintsFromMeta(k, meta);

    // สร้างค่า valid โดยใช้ constraints
    final validValue = _generateValidData(k, constraints);

    // บันทึกผลลัพธ์: มี valid 1 ค่า, invalid เป็น empty list
    byKey[k] = {
      'valid': [validValue],
      'invalid': <String>[],
    };
  }

  // ---------------------------------------------------------------------------
  // STEP 9: ประมวลผล Fields ที่มี rules (AI GENERATION)
  // Fields เหล่านี้มี validation rules ที่ต้องวิเคราะห์
  // ต้องใช้ AI เพื่อสร้าง valid/invalid pairs ที่สมเหตุสมผล
  // ---------------------------------------------------------------------------

  if (fieldsWithRules.isNotEmpty) {
    // ตัวแปรเก็บผลลัพธ์จาก AI
    Map<String, dynamic>? aiResult;

    // ตรวจสอบว่ามี API key หรือไม่
    if (apiKey == null || apiKey.isEmpty) {
      // ไม่มี API key แต่มี fields ที่ต้องใช้ AI = error
      throw Exception('AI datasets generation requires API key. '
          'Fields with validation rules cannot use local generation.');
    }

    // เรียก Gemini API เพื่อสร้าง datasets
    try {
      // ส่ง API key, model name, source file, และ list ของ fields
      aiResult =
          await _callGeminiForDatasets(apiKey, model, uiFile, fieldsWithRules);
    } catch (e) {
      // wrap error ด้วย context message
      throw Exception('Gemini call failed: $e');
    }

    // ---------------------------------------------------------------------------
    // STEP 10: รวมผลลัพธ์จาก AI เข้ากับ byKey
    // ---------------------------------------------------------------------------

    // ดึง datasets จาก AI response
    // AI return format: {datasets: {byKey: {...}}}
    final aiByKey =
        (aiResult['datasets']?['byKey'] as Map?)?.cast<String, dynamic>() ??
            <String, dynamic>{};

    // วนลูป fields ที่ส่งไป AI
    for (final f in fieldsWithRules) {
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
    'QA engineers need realistic test data for happy path and errors.',
    '',

    // === OBJECTIVE: วัตถุประสงค์ ===
    '=== (OBJECTIVE) ===',
    '1. Analyze constraints (maxLength, inputFormatters, validatorRules)',
    '2. FILTER OUT isEmpty/null rules (tested separately)', // ข้าม rules ที่เช็ค empty
    '3. Generate valid/invalid pairs ONLY for non-empty rules',
    '4. CRITICAL: Invalid values MUST pass inputFormatters but FAIL validators',
    '5. Output valid JSON',
    '',

    // === EXECUTION: ขั้นตอนการทำงาน ===
    '=== (EXECUTION) ===',
    '1. For each field, count ALL non-empty rules (SKIP ONLY "isEmpty"/"== null")',
    '2. Count EVERY rule even if duplicate → Let N = total non-empty rule count',
    '3. For each non-empty rule, generate 1 valid + 1 invalid pair',
    '4. CRITICAL: Create N pairs (total N valid + N invalid)',
    '5. Output format: {"file":"<filename>","datasets":{"byKey":{"<key>":[...pairs...]}}}',
    '6. Each pair: {"valid":"...","invalid":"...","invalidRuleMessages":"rule message"}',
    '',

    // === EXAMPLE: ตัวอย่าง ===
    'Example 1 (N=1):',
    'Input: {"file":"lib/page.dart","fields":[{"key":"firstname","validatorRules":[',
    '  {"condition":"value == null || value.isEmpty","message":"Required"},',
    '  {"condition":"!RegExp(r\'^[a-zA-Z]{2,}\\\$\').hasMatch(value)","message":"Min 2"}]}]}',
    'Non-empty rules: 1 (SKIP isEmpty) → N=1 pair',
    'Output: {"file":"lib/page.dart","datasets":{"byKey":{"firstname":[',
    '  {"valid":"Alice","invalid":"J","invalidRuleMessages":"Min 2"}',
    ']}}}',
    '',

    // === STYLE: รูปแบบ output ===
    '=== (STYLE) ===',
    '- JSON only (no markdown, no comments)', // ไม่ใส่ markdown
    '- Realistic values (not "value1")', // ค่าต้อง realistic
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
// FIELD CONSTRAINTS CLASS
// =============================================================================

/// Class เก็บข้อมูล constraints ของ field
/// ใช้สำหรับ local generation เพื่อสร้างค่าที่ถูกต้องตาม constraints
///
/// Fields:
///   [pattern]         - regex pattern ที่อนุญาต (เช่น "[a-zA-Z0-9]")
///   [maxLength]       - ความยาวสูงสุดที่อนุญาต
///   [hasSpecialChars] - true ถ้า pattern อนุญาตอักขระพิเศษ
///   [isEmail]         - true ถ้าเป็น email field
///   [isDigitsOnly]    - true ถ้ารับเฉพาะตัวเลข
class FieldConstraints {
  /// Regex pattern ที่กำหนดว่า characters อะไรที่อนุญาต
  /// เช่น [a-zA-Z0-9] หมายถึงอนุญาต letters และ numbers
  final String pattern;

  /// ความยาวสูงสุดที่ field รับได้
  /// มาจาก maxLength property ของ TextField
  final int maxLength;

  /// true ถ้า pattern อนุญาตอักขระพิเศษ เช่น @, #, $, !, etc.
  final bool hasSpecialChars;

  /// true ถ้า field นี้เป็น email field
  /// (detect จากชื่อ key หรือ pattern)
  final bool isEmail;

  /// true ถ้า field รับเฉพาะตัวเลข
  /// (มาจาก FilteringTextInputFormatter.digitsOnly)
  final bool isDigitsOnly;

  /// Constructor - รับค่าทุก fields
  FieldConstraints({
    required this.pattern,
    required this.maxLength,
    required this.hasSpecialChars,
    required this.isEmail,
    required this.isDigitsOnly,
  });
}

// =============================================================================
// ANALYZE CONSTRAINTS FROM META
// =============================================================================

/// วิเคราะห์ constraints จาก metadata ของ field
///
/// Function นี้จะดูข้อมูลจากหลายแหล่ง:
/// 1. inputFormatters - มี priority สูงสุด (กำหนดว่า user พิมพ์อะไรได้)
/// 2. validatorMessages - ใช้เป็น hint ถ้าไม่มี inputFormatters
/// 3. key name - ใช้เป็น hint (เช่น ชื่อมี "email" = email field)
///
/// Parameters:
///   [key]  - ชื่อ/key ของ field (ใช้เป็น hint)
///   [meta] - metadata จาก manifest
///
/// Returns:
///   FieldConstraints - object ที่เก็บ constraints ทั้งหมด
FieldConstraints _analyzeConstraintsFromMeta(
    String key, Map<String, dynamic> meta) {
  // ---------------------------------------------------------------------------
  // ดึงข้อมูลพื้นฐานจาก metadata
  // ---------------------------------------------------------------------------

  // inputFormatters เป็น list ของ formatter objects
  // แต่ละ formatter มี type และ pattern (ถ้ามี)
  final inputFormatters = (meta['inputFormatters'] as List?) ?? const [];

  // maxLength จาก TextField.maxLength property
  // default = 50 ถ้าไม่ได้กำหนด
  final maxLength = (meta['maxLength'] as int?) ?? 50;

  // ---------------------------------------------------------------------------
  // กำหนดค่าเริ่มต้น
  // ---------------------------------------------------------------------------

  String pattern = '[a-zA-Z0-9]'; // default: alphanumeric only
  bool hasSpecialChars = false; // default: ไม่มีอักขระพิเศษ
  bool isEmail = false; // default: ไม่ใช่ email
  bool isDigitsOnly = false; // default: ไม่ใช่ digits only

  // ---------------------------------------------------------------------------
  // วิเคราะห์จาก inputFormatters (Priority สูงสุด)
  // inputFormatters กำหนดว่า user พิมพ์อะไรได้บ้าง
  // ---------------------------------------------------------------------------

  for (final formatter in inputFormatters) {
    // ข้าม entry ที่ไม่ใช่ Map
    if (formatter is! Map) continue;

    // ดึง type ของ formatter
    final type = (formatter['type'] ?? '').toString();

    if (type == 'allow') {
      // FilteringTextInputFormatter.allow(RegExp(pattern))
      // อนุญาตเฉพาะ characters ที่ match pattern
      pattern = (formatter['pattern'] ?? pattern).toString();
    } else if (type == 'digitsOnly') {
      // FilteringTextInputFormatter.digitsOnly
      // อนุญาตเฉพาะตัวเลข 0-9
      isDigitsOnly = true;
      pattern = '[0-9]';
    }
  }

  // ---------------------------------------------------------------------------
  // วิเคราะห์จาก validatorMessages (ถ้าไม่มี inputFormatters)
  // ใช้เป็น hint เพิ่มเติม
  // ---------------------------------------------------------------------------

  if (inputFormatters.isEmpty) {
    // ดึง validator messages
    final msgs = (meta['validatorMessages'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        const [];

    // หา message ที่มีลักษณะเป็น regex pattern
    // เช่น "^[a-zA-Z0-9]+$" หรือ "[a-z@.-]"
    final regexLike = msgs.firstWhere(
      (m) => RegExp(r'^[\^\[]?[a-zA-Z0-9@#\\\$%\^&\+=!\*\-_.\[\]\(\)]+')
          .hasMatch(m),
      orElse: () => '', // return empty string ถ้าไม่พบ
    );

    if (regexLike.isNotEmpty) {
      // ตรวจสอบว่าเป็น email pattern หรือไม่
      // email pattern มักมี @ และ character class
      if (regexLike.contains('@') && regexLike.contains('[')) {
        isEmail = true;
        pattern = '[a-zA-Z0-9@.-]';
      }
      // ตรวจสอบว่าเป็น standard character class
      else if (regexLike.contains('a-z') ||
          regexLike.contains('A-Z') ||
          regexLike.contains('0-9')) {
        pattern = regexLike;
      }
    }
  }

  // ---------------------------------------------------------------------------
  // วิเคราะห์จากชื่อ key (Hint)
  // ชื่อ field อาจบอกประเภทของข้อมูล
  // ---------------------------------------------------------------------------

  // แปลงเป็น lowercase เพื่อ compare แบบ case-insensitive
  final keyLower = key.toLowerCase();

  // ถ้าชื่อ key มี "email" ถือว่าเป็น email field
  if (keyLower.contains('email')) {
    isEmail = true;
    pattern = '[a-zA-Z0-9@.-]'; // email allowed characters
  }

  // ---------------------------------------------------------------------------
  // ตรวจสอบว่ามีอักขระพิเศษใน pattern หรือไม่
  // ---------------------------------------------------------------------------

  // วนเช็คแต่ละ special character
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

  // ---------------------------------------------------------------------------
  // สร้างและ return FieldConstraints object
  // ---------------------------------------------------------------------------

  return FieldConstraints(
    pattern: pattern,
    maxLength: maxLength,
    hasSpecialChars: hasSpecialChars,
    isEmail: isEmail,
    isDigitsOnly: isDigitsOnly,
  );
}

// =============================================================================
// GENERATE VALID DATA
// =============================================================================

/// สร้างค่า valid data สำหรับ field
/// ใช้สำหรับ local generation (ไม่ต้องเรียก AI)
///
/// Parameters:
///   [key] - ชื่อ/key ของ field (ใช้เป็น hint)
///   [c]   - FieldConstraints ที่วิเคราะห์ได้
///
/// Returns:
///   String - valid value ที่สร้างขึ้น
///
/// Logic:
///   1. ถ้า digits only -> สร้างตัวเลข
///   2. ถ้า email -> สร้าง email address
///   3. ถ้า username -> สร้าง username
///   4. ถ้า password -> สร้าง password
///   5. อื่นๆ -> สร้างจาก pattern
String _generateValidData(String key, FieldConstraints c) {
  // แปลง key เป็น lowercase สำหรับ comparison
  final keyLower = key.toLowerCase();

  // สร้าง Random instance ด้วย seed คงที่
  // seed = 42 ทำให้ได้ค่าเดิมทุกครั้งที่รัน (reproducible)
  final random = Random(42);

  // ---------------------------------------------------------------------------
  // CASE 1: Digits Only (เช่น เบอร์โทร, รหัส, จำนวน)
  // ---------------------------------------------------------------------------
  if (c.isDigitsOnly) {
    // สร้างเลข 3 หลัก (100-999)
    // nextInt(900) = 0-899, + 100 = 100-999
    return (random.nextInt(900) + 100).toString();
  }

  // ---------------------------------------------------------------------------
  // CASE 2: Email Field
  // ---------------------------------------------------------------------------
  if (c.isEmail) {
    // สร้าง email ที่มีความยาวเหมาะสมกับ maxLength
    if (c.maxLength <= 15) {
      // maxLength น้อยมาก -> ใช้ email สั้นๆ
      return 'a@co.com'; // 8 characters
    } else if (c.maxLength <= 25) {
      // maxLength ปานกลาง -> ใช้ email ทั่วไป
      return 'test@example.com'; // 16 characters
    } else {
      // maxLength มาก -> สร้าง email แบบสุ่ม
      final local = 'user${random.nextInt(99)}'; // user0-user98
      final domain = 'test${random.nextInt(9)}'; // test0-test8
      return '$local@$domain.com';
    }
  }

  // ---------------------------------------------------------------------------
  // CASE 3: Username Field
  // ---------------------------------------------------------------------------
  if (keyLower.contains('username')) {
    // ตรวจสอบว่า pattern อนุญาต letters และ numbers
    if (c.pattern.contains('a-z') && c.pattern.contains('0-9')) {
      // กำหนดความยาว: ไม่น้อยกว่า 5, ไม่เกิน 8, และไม่เกิน maxLength
      final len = c.maxLength.clamp(5, 8).clamp(1, c.maxLength);

      // characters ที่ใช้สร้าง username
      final chars = 'abcdefghijklmnopqrstuvwxyz0123456789';

      // สร้าง string โดยสุ่มเลือก characters
      return String.fromCharCodes(List.generate(
          len, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
    }
  }

  // ---------------------------------------------------------------------------
  // CASE 4: Password Field
  // ---------------------------------------------------------------------------
  if (keyLower.contains('password')) {
    // ถ้าอนุญาต special chars -> ใช้ password ที่มี special char
    // ไม่งั้นใช้ password ธรรมดา
    return c.hasSpecialChars ? 'Pass1!' : 'pass123';
  }

  // ---------------------------------------------------------------------------
  // CASE 5: General Case - สร้างจาก pattern
  // ---------------------------------------------------------------------------
  return _genFromPattern(c.pattern, c.maxLength, random);
}

// =============================================================================
// GENERATE FROM PATTERN
// =============================================================================

/// สร้าง string จาก regex pattern
///
/// Parameters:
///   [pattern]   - regex pattern ที่กำหนด allowed characters
///   [maxLength] - ความยาวสูงสุด
///   [random]    - Random instance สำหรับสุ่ม
///
/// Returns:
///   String - random string ที่ match กับ pattern
///
/// ตัวอย่าง:
///   pattern = "[a-zA-Z0-9]", maxLength = 10
///   output อาจเป็น "aBc123XyZ"
String _genFromPattern(String pattern, int maxLength, Random random) {
  // สร้าง list เก็บ characters ที่อนุญาต
  final chars = <String>[];

  // ---------------------------------------------------------------------------
  // เพิ่ม characters ตาม pattern
  // ---------------------------------------------------------------------------

  // ตรวจสอบ a-z (lowercase letters)
  if (pattern.contains('a-z')) {
    // split string เป็น list ของ single characters
    chars.addAll('abcdefghijklmnopqrstuvwxyz'.split(''));
  }

  // ตรวจสอบ A-Z (uppercase letters)
  if (pattern.contains('A-Z')) {
    chars.addAll('ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split(''));
  }

  // ตรวจสอบ 0-9 หรือ \d (digits)
  if (pattern.contains('0-9') || pattern.contains('\\d')) {
    chars.addAll('0123456789'.split(''));
  }

  // เพิ่ม special characters ที่มีใน pattern
  // วนเช็คทีละตัว
  for (final ch in '@#\$%^&+=!*-_.'.split('')) {
    if (pattern.contains(ch)) chars.add(ch);
  }

  // ถ้าไม่มี characters เลย ใช้ default set
  if (chars.isEmpty) chars.addAll('abc123'.split(''));

  // ---------------------------------------------------------------------------
  // กำหนดความยาวของ output
  // ---------------------------------------------------------------------------

  // clamp = จำกัดค่าให้อยู่ในช่วง
  // ความยาว = min(8, maxLength) แต่อย่างน้อย 1
  final length = maxLength.clamp(1, 8).clamp(1, maxLength);

  // ---------------------------------------------------------------------------
  // สุ่มสร้าง string
  // ---------------------------------------------------------------------------

  // List.generate สร้าง list ขนาด length
  // แต่ละ element สุ่มเลือก character จาก chars
  // join('') รวม list เป็น string
  return List.generate(length, (_) => chars[random.nextInt(chars.length)])
      .join('');
}

// =============================================================================
// REMOVED FUNCTIONS (เก็บไว้เป็น reference)
// =============================================================================
// Functions เหล่านี้ถูกลบออกหรือย้ายไป utils.dart:
//
// - _basename, _basenameWithoutExtension, _readApiKeyFromEnv
//   -> ย้ายไป utils.dart เพื่อใช้ร่วมกับ scripts อื่น
//
// - _localGenerateDatasets, _generateDatasetForField, _samplesFromRule,
//   _minimalValidForConstraints, _repeatCharFor, _generateInvalidData,
//   _genInvalidFromPattern
//   -> ลบออก เพราะเปลี่ยนมาใช้ AI-only dataset generation
//      การ generate invalid data ที่ดีต้องเข้าใจ semantic ของ validation rules
//      ซึ่ง AI ทำได้ดีกว่า rule-based approach
// =============================================================================
