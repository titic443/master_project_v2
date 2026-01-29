// =============================================================================
// generate_test_data.dart
// =============================================================================
// Script สำหรับสร้าง test plan (test data) จาก UI manifest
// ใช้ Pairwise Combinatorial Testing เพื่อสร้าง test cases ที่ครอบคลุม
// แต่ลดจำนวน test cases ให้น้อยลงด้วยเทคนิค pairwise
//
// วิธีใช้งาน:
//   1. ประมวลผลไฟล์ manifest เฉพาะ:
//      dart run tools/script_v2/generate_test_data.dart output/manifest/demos/login_page.manifest.json
//
//   2. ประมวลผลทุกไฟล์ manifest ใน output/manifest/:
//      dart run tools/script_v2/generate_test_data.dart
//
// Input:
//   - output/manifest/<subfolder>/<page>.manifest.json (จาก extract_ui_manifest.dart)
//   - output/test_data/<page>.datasets.json (optional, จาก generate_datasets.dart)
//
// Output:
//   - output/test_data/<page>.testdata.json (test plan สำหรับ generate_test_script.dart)
//   - output/model_pairwise/<page>.full.model.txt (PICT model file)
//   - output/model_pairwise/<page>.full.result.txt (PICT combinations result)
//   - output/model_pairwise/<page>.valid.model.txt (PICT model for valid-only)
//   - output/model_pairwise/<page>.valid.result.txt (PICT valid combinations)
//
// Features:
//   - สร้าง pairwise test combinations ด้วย PICT tool
//   - รองรับ TextFormField, Radio, Checkbox, Dropdown, Switch
//   - รองรับ DatePicker และ TimePicker widgets
//   - สร้าง edge cases (empty fields test)
//   - ตรวจจับ validation rules และ required fields
//   - รองรับ external datasets จาก AI generation
// =============================================================================

// -----------------------------------------------------------------------------
// Import Libraries
// -----------------------------------------------------------------------------

// dart:convert - สำหรับ JSON encoding/decoding
// - jsonDecode()      : แปลง JSON string เป็น Map/List
// - JsonEncoder       : แปลง Map/List เป็น JSON string (with formatting)
import 'dart:convert';

// dart:io - สำหรับ file I/O และ process operations
// - File             : อ่าน/เขียนไฟล์
// - Directory        : จัดการ folders และ scan files
// - stdout/stderr    : เขียน output/error messages
// - exit()           : จบ process พร้อม exit code
import 'dart:io';

// generator_pict.dart - module สำหรับ PICT (Pairwise Independent Combinatorial Testing)
// - executePict()           : รัน PICT binary เพื่อสร้าง combinations
// - generatePairwiseInternal(): สร้าง pairwise combinations แบบ internal (ไม่ใช้ PICT)
// - parsePictModel()        : parse PICT model file เพื่อดึง factors
// - parsePictResult()       : parse PICT result file เพื่อดึง combinations
// - extractFactorsFromManifest(): ดึง factors จาก manifest widgets
// - writePictModelFiles()   : เขียน PICT model และ result files
import 'generator_pict.dart' as pict;

// utils.dart - utility functions ที่ใช้ร่วมกับ scripts อื่น
// - basenameWithoutExtension() : ดึงชื่อไฟล์โดยไม่มี extension
// - basename()                 : ดึงชื่อไฟล์
import 'utils.dart' as utils;

// =============================================================================
// PUBLIC API FUNCTION
// =============================================================================

/// Function สาธารณะสำหรับเรียกใช้จาก script อื่น (เช่น flutter_test_generator.dart)
///
/// สร้าง test data (test plan) จาก manifest file โดยใช้ pairwise testing
///
/// Parameters:
///   [manifestPath] - path ของไฟล์ .manifest.json
///                    เช่น "output/manifest/demos/login_page.manifest.json"
///   [pictBin]      - path ของ PICT binary (default: './pict')
///   [constraints]  - PICT constraints string (optional)
///                    เช่น "IF [field1] = 'invalid' THEN [field2] = 'valid';"
///
/// Returns:
///   Future<String> - path ของ test data file ที่สร้าง
///                    เช่น "output/test_data/login_page.testdata.json"
///
/// Example:
///   final outputPath = await generateTestDataFromManifest(
///     'output/manifest/demos/login_page.manifest.json',
///     pictBin: './pict',
///   );
///   print('Generated: $outputPath');
Future<String> generateTestDataFromManifest(
  String manifestPath, {
  String pictBin = './pict',
  String? constraints,
}) async {
  // DEBUG: ตรวจสอบว่า constraints ถูกส่งมาหรือไม่ (uncomment เพื่อ debug)
  // stderr.writeln('[DEBUG] generateTestDataFromManifest - constraints: ${constraints == null ? "NULL" : "\"${constraints.substring(0, constraints.length.clamp(0, 50))}...\""}');

  // ---------------------------------------------------------------------------
  // อ่าน manifest file เพื่อดึง UI file path
  // ---------------------------------------------------------------------------

  // อ่านเนื้อหา manifest ทั้งไฟล์เป็น string
  final raw = File(manifestPath).readAsStringSync();

  // แปลง JSON string เป็น Map
  final j = jsonDecode(raw) as Map<String, dynamic>;

  // ดึง source section (ถ้าไม่มีใช้ empty map)
  final source = (j['source'] as Map<String, dynamic>?) ?? const {};

  // ดึง path ของ UI file จาก source
  final uiFile = (source['file'] as String?) ?? 'lib/unknown.dart';

  // ---------------------------------------------------------------------------
  // เรียก _processOne เพื่อสร้าง test data
  // ---------------------------------------------------------------------------

  await _processOne(
    manifestPath,
    pairwiseMerge: true,      // ใช้ pairwise mode เสมอ
    planSummary: false,       // ไม่แสดง plan summary
    pairwiseUsePict: true,    // ใช้ PICT tool
    pictBin: pictBin,         // path ของ PICT binary
    constraints: constraints, // PICT constraints
  );

  // ---------------------------------------------------------------------------
  // คำนวณและ return output path
  // ---------------------------------------------------------------------------

  // สร้าง output path จากชื่อ UI file
  // ตัวอย่าง: lib/demos/login_page.dart -> output/test_data/login_page.testdata.json
  return 'output/test_data/${utils.basenameWithoutExtension(uiFile)}.testdata.json';
}

// =============================================================================
// MAIN FUNCTION - Entry Point
// =============================================================================

/// Entry point ของ script เมื่อรันจาก command line
///
/// รองรับ 2 modes:
///   1. Batch mode (ไม่มี arguments): ประมวลผลทุกไฟล์ใน output/manifest/
///   2. Single/Multiple file mode: ประมวลผลเฉพาะไฟล์ที่ระบุ
///
/// Parameter:
///   [args] - List ของ command line arguments
///            รับเฉพาะ paths ที่ลงท้ายด้วย .manifest.json
void main(List<String> args) async {
  // ---------------------------------------------------------------------------
  // Default Settings - ค่าคงที่สำหรับการประมวลผล
  // ---------------------------------------------------------------------------

  const bool pairwiseMerge = true;   // ใช้ pairwise mode เสมอ (ลดจำนวน test cases)
  const bool planSummary = false;    // ไม่แสดง plan summary
  const bool pairwiseUsePict = true; // ใช้ PICT tool แทน internal algorithm
  const String pictBin = './pict';   // path ของ PICT binary (relative to project root)

  // List เก็บ paths ของไฟล์ที่จะประมวลผล
  final inputs = <String>[];

  // ---------------------------------------------------------------------------
  // PICT Constraints File (Optional)
  // ---------------------------------------------------------------------------
  // ไฟล์ constraints ใช้สำหรับกำหนดเงื่อนไขเพิ่มเติมให้ PICT
  // เช่น:
  //   IF [dropdown] = "option1" THEN [checkbox] <> "unchecked";
  //   IF [textField] = "empty" THEN [submitButton] = "disabled";
  //
  // ส่งผ่าน command line: --constraints-file <path>
  // ---------------------------------------------------------------------------
  String? constraintsFile;

  // ---------------------------------------------------------------------------
  // Parse Command Line Arguments
  // ---------------------------------------------------------------------------
  // รองรับ arguments:
  //   <manifest.json>              - ไฟล์ manifest ที่ต้องการประมวลผล
  //   --constraints-file <path>    - ไฟล์ PICT constraints (optional)
  //   --verbose                    - แสดง stack trace เมื่อเกิด error
  // ---------------------------------------------------------------------------

  // วนลูปตรวจสอบแต่ละ argument (ใช้ index-based loop เพราะต้อง skip argument)
  for (var i = 0; i < args.length; i++) {
    final arg = args[i];

    // ตรวจสอบ --constraints-file argument
    // Format: --constraints-file <path>
    if (arg == '--constraints-file' && i + 1 < args.length) {
      constraintsFile = args[i + 1];  // เก็บ path ของ constraints file
      i++;  // ข้าม argument ถัดไป (เพราะเป็น file path)
    }
    // รับเฉพาะไฟล์ .manifest.json
    else if (arg.endsWith('.manifest.json')) {
      inputs.add(arg);
    } else if (!arg.startsWith('--')) {
      // แจ้งเตือนถ้า argument ไม่ใช่ manifest file (และไม่ใช่ flag)
      stderr.writeln('Warning: Ignoring unrecognized argument: $arg');
    }
  }

  // ---------------------------------------------------------------------------
  // Load Constraints from File
  // ---------------------------------------------------------------------------
  // อ่าน constraints จากไฟล์ถ้ามีการระบุ --constraints-file
  // Constraints จะถูกส่งต่อไปให้ PICT tool เพื่อ:
  //   - กำหนด invalid combinations
  //   - กำหนด dependencies ระหว่าง parameters
  //   - ลด test cases ที่ไม่ต้องการ
  // ---------------------------------------------------------------------------
  String? constraints;
  if (constraintsFile != null) {
    final file = File(constraintsFile);
    if (file.existsSync()) {
      // อ่านเนื้อหาทั้งหมดจากไฟล์
      constraints = file.readAsStringSync();
      stdout.writeln('Loaded constraints from: $constraintsFile');
    } else {
      // แจ้งเตือนถ้าไฟล์ไม่พบ (ไม่ใช่ error เพราะ constraints เป็น optional)
      stderr.writeln('Warning: Constraints file not found: $constraintsFile');
    }
  }

  // ---------------------------------------------------------------------------
  // Batch Mode: Scan output/manifest/ folder ถ้าไม่มี inputs
  // ---------------------------------------------------------------------------

  if (inputs.isEmpty) {
    // สร้าง Directory object ชี้ไปยัง manifest folder
    final manifestDir = Directory('output/manifest');

    // ตรวจสอบว่า folder มีอยู่หรือไม่
    if (!manifestDir.existsSync()) {
      stderr.writeln('Error: No manifest directory found: output/manifest/');
      stderr.writeln('Please create manifest files first using extract_ui_manifest.dart');
      exit(1); // exit code 1 = error
    }

    // ค้นหาไฟล์ .manifest.json แบบ recursive
    // listSync(recursive: true) จะค้นหา subfolders ด้วย
    for (final f in manifestDir.listSync(recursive: true).whereType<File>()) {
      if (f.path.endsWith('.manifest.json')) {
        inputs.add(f.path);
      }
    }

    // ตรวจสอบว่าพบไฟล์หรือไม่
    if (inputs.isEmpty) {
      stderr.writeln('Error: No manifest files found in output/manifest/');
      stderr.writeln('Expected: *.manifest.json files');
      exit(1);
    }

    // แสดงจำนวนไฟล์ที่พบ
    stdout.writeln('Found ${inputs.length} manifest file(s) to process');
  }

  // ---------------------------------------------------------------------------
  // Process Each Manifest File
  // ---------------------------------------------------------------------------

  // ตัวนับสำหรับ summary
  int successCount = 0; // จำนวนที่สำเร็จ
  int errorCount = 0;   // จำนวนที่ล้มเหลว

  // วนลูปประมวลผลแต่ละไฟล์
  for (final path in inputs) {
    try {
      // เรียก _processOne เพื่อประมวลผล manifest
      await _processOne(
        path,
        pairwiseMerge: pairwiseMerge,
        planSummary: planSummary,
        pairwiseUsePict: pairwiseUsePict,
        pictBin: pictBin,
        constraints: constraints,
      );
      successCount++; // เพิ่มตัวนับถ้าสำเร็จ
    } catch (e, st) {
      // จับ error และแสดง message
      stderr.writeln('✗ Failed to process $path: $e');
      // แสดง stack trace ถ้ามี --verbose flag
      if (args.contains('--verbose')) {
        stderr.writeln(st);
      }
      errorCount++; // เพิ่มตัวนับ error
    }
  }

  // ---------------------------------------------------------------------------
  // Print Summary (ถ้าประมวลผลหลายไฟล์)
  // ---------------------------------------------------------------------------

  if (inputs.length > 1) {
    stdout.writeln('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    stdout.writeln('Summary: $successCount succeeded, $errorCount failed');
    stdout.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  // Exit with error code ถ้ามี error
  if (errorCount > 0) {
    exit(1);
  }
}

// =============================================================================
// HELPER FUNCTIONS - Dynamic Key Generation
// =============================================================================

/// ดึง prefix ของ page จากชื่อ class หรือ file path
///
/// ใช้สำหรับสร้าง expected keys เช่น buttons_expected_success
///
/// Parameters:
///   [pageClass] - ชื่อ page class เช่น "ButtonsDemo", "LoginPage"
///   [filePath]  - path ของไฟล์ เช่น "lib/demos/buttons_page.dart"
///
/// Returns:
///   String - prefix ของ page เช่น "buttons", "login"
///
/// Examples:
///   _extractPagePrefix('ButtonsDemo', null)        -> 'buttons'
///   _extractPagePrefix('LoginPage', null)          -> 'login'
///   _extractPagePrefix(null, 'lib/demos/buttons_page.dart') -> 'buttons'
String _extractPagePrefix(String? pageClass, String? filePath) {
  // ---------------------------------------------------------------------------
  // Method 1: ดึงจาก pageClass (preferred)
  // ---------------------------------------------------------------------------
  if (pageClass != null) {
    // แปลงเป็น lowercase และลบ suffixes ที่ไม่ต้องการ
    // ButtonsDemo -> buttons, LoginPage -> login
    String prefix = pageClass.toLowerCase()
      .replaceAll('demo', '')   // ลบ 'demo'
      .replaceAll('page', '')   // ลบ 'page'
      .replaceAll('screen', ''); // ลบ 'screen'

    // ถ้า prefix ว่างหลังจากลบ suffixes (เช่น DemoPage -> '')
    // ให้ลองอีกครั้งโดยลบเฉพาะ page และ screen
    if (prefix.isEmpty) {
      prefix = pageClass.toLowerCase()
        .replaceAll('page', '')
        .replaceAll('screen', '');
      // ถ้ายังว่างอยู่ ใช้ชื่อ class ทั้งหมด
      if (prefix.isEmpty) {
        prefix = pageClass.toLowerCase();
      }
    }
    return prefix;
  }

  // ---------------------------------------------------------------------------
  // Method 2: ดึงจาก filePath (fallback)
  // ---------------------------------------------------------------------------
  if (filePath != null) {
    // ดึงชื่อไฟล์จาก path
    // lib/demos/buttons_page.dart -> buttons_page.dart
    final fileName = filePath.split('/').last;

    // ลบ suffixes และ extension
    // buttons_page.dart -> buttons
    return fileName.replaceAll('_page.dart', '')
                .replaceAll('_demo.dart', '')
                .replaceAll('_screen.dart', '')
                .replaceAll('.dart', '');
  }

  // ---------------------------------------------------------------------------
  // Fallback: return 'page' ถ้าไม่มีข้อมูล
  // ---------------------------------------------------------------------------
  return 'page';
}


// =============================================================================
// PROCESS ONE FILE - ฟังก์ชันหลักในการประมวลผล
// =============================================================================

/// ประมวลผล manifest file หนึ่งไฟล์และสร้าง test data
///
/// Parameters:
///   [path]           - path ของไฟล์ .manifest.json
///   [pairwiseMerge]  - ใช้ pairwise testing (default: false)
///   [planSummary]    - แสดง plan summary (default: false)
///   [pairwiseUsePict]- ใช้ PICT tool (default: false)
///   [pictBin]        - path ของ PICT binary
///   [constraints]    - PICT constraints string (optional)
///
/// การทำงานหลัก:
///   1. อ่านและ parse manifest JSON
///   2. สร้าง PICT model จาก widgets
///   3. โหลด external datasets (ถ้ามี)
///   4. ระบุ widget types (textfield, radio, checkbox, etc.)
///   5. สร้าง pairwise test combinations
///   6. สร้าง edge cases (empty fields)
///   7. เขียน test data file
Future<void> _processOne(String path, {bool pairwiseMerge = false, bool planSummary = false, bool pairwiseUsePict = false, String pictBin = './pict', String? constraints}) async {
  // ---------------------------------------------------------------------------
  // STEP 1: อ่านและ parse manifest file
  // ---------------------------------------------------------------------------

  // อ่านเนื้อหา manifest ทั้งไฟล์เป็น string
  final raw = File(path).readAsStringSync();

  // แปลง JSON string เป็น Map
  final j = jsonDecode(raw) as Map<String, dynamic>;

  // ดึง source section จาก manifest
  final source = (j['source'] as Map<String, dynamic>? ) ?? const {};

  // ดึง path ของ UI file
  final uiFile = (source['file'] as String?) ?? 'lib/unknown.dart';

  // ดึงชื่อ page class (ถ้าไม่ระบุ ใช้ชื่อไฟล์แทน)
  final pageClass = (source['pageClass'] as String?) ?? utils.basenameWithoutExtension(uiFile);

  // ---------------------------------------------------------------------------
  // STEP 2: สร้าง PICT model จาก manifest
  // ---------------------------------------------------------------------------

  // พยายามสร้าง PICT model files เพื่อใช้ในการ generate combinations
  try {
    await _tryWritePictModelFromManifestForUi(uiFile, pictBin: pictBin, constraints: constraints);
  } catch (e) {
    stderr.writeln('! Failed to write PICT model from manifest: $e');
  }

  // ดึง list ของ widgets จาก manifest
  final widgets = (j['widgets'] as List? ?? const []).cast<Map<String, dynamic>>();

  // ดึง page prefix สำหรับสร้าง expected keys
  // เช่น buttons_expected_success, customer_expected_fail
  final pagePrefix = _extractPagePrefix(pageClass, uiFile);

  // NOTE: Providers detection ถูกลบออก - ไม่ต้องใช้ใน output structure แล้ว

  // ---------------------------------------------------------------------------
  // STEP 3: โหลด external datasets (ถ้ามี)
  // ---------------------------------------------------------------------------

  /// Helper function: รักษา format ของ datasets (ไม่ต้อง convert)
  /// Format ใหม่: {"key": [{"valid": "value1", "invalid": "value2", "invalidRuleMessages": "msg"}]}
  Map<String, dynamic> _convertDatasetsToOldFormat(Map<String, dynamic> byKey) {
    // Return as-is เพื่อรักษา array of objects format
    return Map<String, dynamic>.from(byKey);
  }

  // สร้างโครงสร้าง datasets พื้นฐาน
  final datasets = {
    'defaults': <String, dynamic>{},  // ค่า default ของแต่ละ field
    'byKey': <String, dynamic>{},     // ค่าตาม widget key
  };

  // Flag บอกว่าโหลด external datasets สำเร็จหรือไม่
  bool hasExternalDatasets = false;

  // พยายามโหลด external datasets จาก .datasets.json
  // ไฟล์นี้ถูกสร้างโดย generate_datasets.dart (AI-based)
  try {
    // สร้าง path ของ datasets file
    final extPath = 'output/test_data/${utils.basenameWithoutExtension(uiFile)}.datasets.json';
    final f = File(extPath);

    // ตรวจสอบว่าไฟล์มีอยู่หรือไม่
    if (f.existsSync()) {
      // อ่านและ parse JSON
      final ext = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;

      // ดึง datasets.byKey
      final extDatasets = (ext['datasets'] as Map?)?.cast<String, dynamic>();
      final extByKey = (extDatasets?['byKey'] as Map?)?.cast<String, dynamic>();

      // ถ้ามี byKey ให้ merge เข้า datasets
      if (extByKey != null) {
        final converted = _convertDatasetsToOldFormat(extByKey);
        (datasets['byKey'] as Map<String, dynamic>).addAll(converted);
        hasExternalDatasets = (converted.isNotEmpty);
      }
    }
  } catch (_) {
    // ignore errors - จะใช้ datasets เปล่าแทน
  }

  // ---------------------------------------------------------------------------
  // STEP 4: Helper Functions สำหรับวิเคราะห์ widget keys
  // ---------------------------------------------------------------------------

  /// ดึง sequence number จาก widget key
  ///
  /// Pattern: <page_prefix>_<sequence>_<description>_<widget_type>
  /// Example: customer_07_end_button → 07
  ///
  /// Returns: sequence number หรือ -1 ถ้าไม่พบ
  int _extractSequence(String key) {
    // Return -1 ถ้า key ว่าง
    if (key.isEmpty) return -1;

    // แยก key เป็น parts ด้วย underscore
    final parts = key.split('_');
    if (parts.length < 2) return -1;

    // ลองดึง sequence จาก part ที่ 2 ก่อน (pattern ที่พบบ่อยที่สุด)
    // customer_07_end_button → ['customer', '07', 'end', 'button']
    final secondPart = parts[1];
    final seq = int.tryParse(secondPart);
    if (seq != null) return seq;

    // Fallback: scan ทุก parts หา number
    for (final part in parts) {
      final num = int.tryParse(part);
      if (num != null) return num;
    }

    return -1; // ไม่พบ sequence
  }

  /// หา Button widget ที่มี sequence number สูงสุด
  /// Button นี้จะถูกใช้เป็น end/submit button
  ///
  /// Returns: widget key ของ button หรือ null ถ้าไม่พบ
  String? _findHighestSequenceButton(List<Map<String, dynamic>> widgets) {
    String? highestKey;  // key ของ button ที่มี sequence สูงสุด
    int highestSeq = -1; // sequence สูงสุดที่พบ

    // วนลูปทุก widgets
    for (final w in widgets) {
      final t = (w['widgetType'] ?? '').toString(); // widget type
      final k = (w['key'] ?? '').toString();         // widget key

      // พิจารณาเฉพาะ Button types
      if ((t == 'ElevatedButton' || t == 'TextButton' || t == 'OutlinedButton') && k.isNotEmpty) {
        final seq = _extractSequence(k);
        // อัพเดทถ้าพบ sequence ที่สูงกว่า
        if (seq > highestSeq) {
          highestSeq = seq;
          highestKey = k;
        }
      }
    }

    return highestKey;
  }

  // ---------------------------------------------------------------------------
  // STEP 5: หา End Button และ Expected Keys
  // ---------------------------------------------------------------------------

  // หา end key โดยหา button ที่มี sequence สูงสุด
  // End button คือปุ่มสุดท้ายที่ผู้ใช้กดเพื่อ submit form
  String? endKey = _findHighestSequenceButton(widgets);

  // รวบรวม expected keys สำหรับ success และ fail cases
  // ใช้ Set เพื่อป้องกัน duplicates (SnackBar อาจปรากฏหลายครั้งใน manifest)
  final expectedSuccessKeys = <String>{}; // keys สำหรับ success (เช่น snackbar success)
  final expectedFailKeys = <String>{};    // keys สำหรับ fail (เช่น error message)

  // ---------------------------------------------------------------------------
  // STEP 6: ระบุและจัดหมวดหมู่ Widget Keys
  // ---------------------------------------------------------------------------

  // Lists เก็บ keys แยกตาม widget type
  final textKeys = <String>[];       // TextFormField, TextField keys
  final radioKeys = <String>[];      // Radio button keys
  final checkboxKeys = <String>[];   // Checkbox keys
  final primaryButtons = <String>[]; // ปุ่มอื่นๆ ที่ไม่ใช่ end button
  final datePickerKeys = <String>[]; // DatePicker keys
  final timePickerKeys = <String>[]; // TimePicker keys

  // วนลูปครั้งแรก: หา expected keys
  for (final w in widgets) {
    final k = (w['key'] ?? '').toString();

    // เก็บ keys ที่มี _expected_success (เช่น snackbar แสดง success message)
    if (k.contains('_expected_success')) {
      expectedSuccessKeys.add(k);
    }
    // เก็บ keys ที่มี _expected_fail (เช่น error message)
    if (k.contains('_expected_fail')) {
      expectedFailKeys.add(k);
    }
  }

  // ตรวจสอบว่ามี end button หรือไม่
  // ถ้ามี = API flow (form submission)
  // ถ้าไม่มี = widget demo (ไม่มี form submission)
  final hasEndButton = endKey != null;

  // วนลูปครั้งที่สอง: จัดหมวดหมู่ widgets ตาม type
  for (final w in widgets) {
    final t = (w['widgetType'] ?? '').toString(); // widget type
    final k = (w['key'] ?? '').toString();         // widget key
    final pickerMeta = w['pickerMetadata'] as Map?; // metadata สำหรับ picker widgets

    // ---------------------------------------------------------------------
    // TextFormField / TextField - input fields สำหรับกรอกข้อความ
    // ---------------------------------------------------------------------
    if ((t.startsWith('TextField') || t.startsWith('TextFormField')) && k.isNotEmpty) {
      textKeys.add(k);
    }
    // ---------------------------------------------------------------------
    // Radio - radio button options
    // ---------------------------------------------------------------------
    else if (t.startsWith('Radio') && k.isNotEmpty) {
      radioKeys.add(k);
    }
    // ---------------------------------------------------------------------
    // Checkbox / CheckboxListTile - checkbox widgets
    // NOTE: Skip FormField<bool> เพราะเป็น wrapper ไม่ใช่ interactive element
    // ---------------------------------------------------------------------
    else if ((t.startsWith('Checkbox') || t == 'CheckboxListTile') && k.isNotEmpty) {
      checkboxKeys.add(k);
    }
    // ---------------------------------------------------------------------
    // Buttons - ปุ่มต่างๆ (ยกเว้น end button)
    // ---------------------------------------------------------------------
    else if ((t == 'ElevatedButton' || t == 'TextButton' || t == 'OutlinedButton') && k.isNotEmpty && k != endKey) {
      // ไม่รวม end button (จะใช้แยกต่างหากตอน submit)
      primaryButtons.add(k);
    }
    // ---------------------------------------------------------------------
    // DatePicker / TimePicker - date และ time picker widgets
    // ตรวจจับจาก pickerMetadata
    // ---------------------------------------------------------------------
    else if (pickerMeta != null && k.isNotEmpty) {
      final pickerType = (pickerMeta['type'] ?? '').toString();
      if (pickerType == 'DatePicker') {
        datePickerKeys.add(k);
      } else if (pickerType == 'TimePicker') {
        timePickerKeys.add(k);
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Fallback: หา radio options ที่อาจพลาดไป
  // รวมเฉพาะ concrete radio options, ไม่รวม FormField group keys
  // ---------------------------------------------------------------------------
  for (final w in widgets) {
    final k = (w['key'] ?? '').toString();
    // ตรวจสอบว่าเป็น radio option จากชื่อ key
    // Pattern: _radio, _yes_radio, _no_radio แต่ไม่ใช่ _radio_group
    final isOption = (k.endsWith('_radio') || k.contains('_yes_radio') || k.contains('_no_radio')) && !k.contains('_radio_group');
    // เพิ่มถ้ายังไม่มีใน list
    if (isOption && !radioKeys.contains(k)) radioKeys.add(k);
  }

  // ---------------------------------------------------------------------------
  // STEP 7: ตรวจจับ Required Checkboxes
  // ---------------------------------------------------------------------------

  // ตรวจจับ required checkboxes จาก FormField<bool> validators
  // Checkbox ถือว่า required ถ้า FormField wrapper มี validator ที่ต้องการค่า true
  // Map: checkbox key -> validation message
  final requiredCheckboxValidation = <String, String>{};

  for (final w in widgets) {
    final t = (w['widgetType'] ?? '').toString();
    final k = (w['key'] ?? '').toString();

    // ตรวจสอบเฉพาะ FormField<bool> (wrapper ของ Checkbox)
    if (t.startsWith('FormField<bool>') && k.isNotEmpty) {
      // ดึง metadata ของ widget
      final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? const {};
      // ดึง validator rules
      final rules = (meta['validatorRules'] as List?)?.cast<dynamic>() ?? const [];

      // วิเคราะห์แต่ละ rule
      for (final rule in rules) {
        if (rule is Map) {
          final condition = rule['condition']?.toString() ?? '';
          final message = rule['message']?.toString() ?? '';

          // ตรวจสอบว่า condition ต้องการให้ checkbox เป็น true
          // Pattern ที่พบบ่อย: "value == null || !value"
          // แปลว่า: ถ้า value เป็น null หรือ false ให้แสดง error
          final normalized = condition.toLowerCase().replaceAll(' ', '');
          if (normalized.contains('!value') ||               // !value
              normalized.contains('value==false') ||         // value == false
              (normalized.contains('value==null') && normalized.contains('||!value'))) {
            // หา key ของ Checkbox ที่เกี่ยวข้อง
            // โดยเปลี่ยน _formfield เป็น _checkbox
            final checkboxKey = k.replaceAll('_formfield', '_checkbox');
            requiredCheckboxValidation[checkboxKey] = message;
            break; // หยุดหลังพบ rule แรก
          }
        }
      }
    }
  }

  // ---------------------------------------------------------------------------
  // STEP 8: ตรวจจับ Dropdowns และ options
  // ---------------------------------------------------------------------------

  // รองรับหลาย dropdowns ใน form เดียว
  String? dropdownKey;                           // key ของ dropdown แรก (backward compatibility)
  final dropdownValues = <String>[];             // items ของ dropdown แรก
  final dropdownKeys = <String>[];               // keys ของทุก dropdowns
  final dropdownValuesList = <List<String>>[];   // items ของแต่ละ dropdown
  final dropdownValueToTextMaps = <Map<String, String>>[]; // Map value -> text สำหรับแต่ละ dropdown

  // วนลูปหา DropdownButton widgets
  for (final w in widgets) {
    final t = (w['widgetType'] ?? '').toString();

    // ตรวจสอบว่าเป็น DropdownButton หรือไม่
    if (t.contains('DropdownButton')) {
      final k = (w['key'] ?? '').toString();
      if (k.isNotEmpty) {
        dropdownKeys.add(k);
        // เก็บ key แรกสำหรับ backward compatibility
        if (dropdownKey == null) dropdownKey = k;
      }

      try {
        // ดึง options จาก metadata
        final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? const {};
        final list = _optionsFromMeta(meta['options']);
        dropdownValuesList.add(list);

        // เก็บ values ของ dropdown แรก
        if (dropdownValues.isEmpty) {
          dropdownValues.addAll(list);
        }

        // สร้าง value -> text mapping สำหรับ dropdown นี้
        // ใช้ตอน tap เพื่อแปลง value เป็น text ที่แสดงใน UI
        final valueToText = <String, String>{};
        final options = meta['options'];
        if (options is List) {
          for (final opt in options) {
            if (opt is Map) {
              final value = opt['value']?.toString();  // internal value
              final text = opt['text']?.toString();    // display text
              if (value != null && value.isNotEmpty && text != null && text.isNotEmpty) {
                valueToText[value] = text;
              }
            }
          }
        }
        dropdownValueToTextMaps.add(valueToText);
      } catch (_) {
        // ถ้า parse ไม่ได้ ให้เพิ่ม empty map
        dropdownValueToTextMaps.add(<String, String>{});
      }
    }
  }

// ---------------------------------------------------------------------------
// STEP 9: สร้าง buildSteps Function
// ---------------------------------------------------------------------------

/// สร้าง list ของ test steps สำหรับ test case เดียว
///
/// Parameters:
///   [radioPick]    - radio option ที่ต้องการเลือก (optional)
///   [dropdownPick] - dropdown value ที่ต้องการเลือก (optional)
///
/// Returns:
///   List<Map<String,dynamic>> - list ของ steps (enterText, tap, pump, etc.)
List<Map<String,dynamic>> buildSteps({String? radioPick, String? dropdownPick}){
    final st = <Map<String, dynamic>>[];

    // -------------------------------------------------------------------------
    // Step 9.1: กรอก text ใน TextFormFields (ใช้ valid data เสมอ)
    // -------------------------------------------------------------------------
    final byKey = (datasets['byKey'] as Map).cast<String, dynamic>();
    for (final k in textKeys) {
      // เพิ่ม enterText step พร้อม dataset path
      // Format: byKey.<key>.valid[0] (ใช้ valid value ตัวแรก)
      st.add({'enterText': {'byKey': k, 'dataset': 'byKey.' + k + '.valid[0]'}});
      st.add({'pump': true}); // pump หลัง enter text
    }

    // -------------------------------------------------------------------------
    // Step 9.2: เลือก Dropdown (ถ้ามี)
    // -------------------------------------------------------------------------
    if (dropdownKey != null && dropdownPick != null && dropdownPick.isNotEmpty) {
      // Tap เปิด dropdown
      st.add({'tap': {'byKey': dropdownKey}});
      st.add({'pump': true});

      // แปลง value เป็น text ที่แสดงใน UI
      String textToTap = dropdownPick;
      if (dropdownValueToTextMaps.isNotEmpty) {
        final mapping = dropdownValueToTextMaps[0];
        final cleanPick = dropdownPick.replaceAll('"', '');
        textToTap = mapping[cleanPick] ?? dropdownPick;
      }

      // Tap เลือก option
      st.add({'tapText': textToTap});
      st.add({'pump': true});
    }

    // -------------------------------------------------------------------------
    // Step 9.3: เลือก Radio Options
    // -------------------------------------------------------------------------
    if (hasEndButton) {
      // API flow: เลือก radio options ตาม preference

      /// Helper: หา radio key แรกที่มี substring ตาม preferences
      String? _pickFirstContaining(List<String> keys, List<String> prefs){
        for (final p in prefs) {
          // หา key ที่มี pattern _<pref>_ หรือลงท้ายด้วย _<pref>
          final found = keys.firstWhere((k)=> k.contains('_'+p+'_') || k.endsWith('_'+p), orElse: ()=> '');
          if (found.isNotEmpty) return found;
        }
        // Fallback: ใช้ key แรก
        return keys.isNotEmpty ? keys.first : null;
      }

      // เลือก radio group 2 (approval status)
      String? g2;
      if (radioPick != null && radioPick.isNotEmpty && radioKeys.contains(radioPick)) {
        g2 = radioPick; // ใช้ค่าที่ระบุ
      } else {
        g2 = _pickFirstContaining(radioKeys, ['approve','reject','pending']);
      }
      if (g2 != null) { st.add({'tap': {'byKey': g2}}); st.add({'pump': true}); }

      // เลือก radio group 3 (manufacturing type)
      final g3 = _pickFirstContaining(radioKeys, ['manu','che']);
      if (g3 != null) { st.add({'tap': {'byKey': g3}}); st.add({'pump': true}); }

      // เลือก radio group 4 (platform)
      final g4 = _pickFirstContaining(radioKeys, ['android','window','ios']);
      if (g4 != null) { st.add({'tap': {'byKey': g4}}); st.add({'pump': true}); }
    } else if (radioPick != null && radioPick.isNotEmpty) {
      // มี radio pick ที่ระบุ
      st.add({'tap': {'byKey': radioPick}});
      st.add({'pump': true});
    } else if (!hasEndButton && radioKeys.isNotEmpty) {
      // Non-API flow fallback: tap ทุก radios ตามลำดับ
      for (final rk in radioKeys) { st.add({'tap': {'byKey': rk}}); st.add({'pump': true}); }
    }

    // -------------------------------------------------------------------------
    // Step 9.4: เลือก DatePicker (non-API flow)
    // -------------------------------------------------------------------------
    for (final dpk in datePickerKeys) {
      st.add({'tap': {'byKey': dpk}});           // เปิด picker
      st.add({'pumpAndSettle': true});            // รอ animation
      st.add({'selectDate': 'today'});            // เลือกวันนี้
      st.add({'pumpAndSettle': true});            // รอปิด dialog
    }

    // -------------------------------------------------------------------------
    // Step 9.5: เลือก TimePicker (non-API flow)
    // -------------------------------------------------------------------------
    for (final tpk in timePickerKeys) {
      st.add({'tap': {'byKey': tpk}});           // เปิด picker
      st.add({'pumpAndSettle': true});            // รอ animation
      st.add({'selectTime': 'today'});            // เลือกเวลาปัจจุบัน
      st.add({'pumpAndSettle': true});            // รอปิด dialog
    }

    // -------------------------------------------------------------------------
    // Step 9.6: Tap primary buttons (ปุ่มอื่นๆ ที่ไม่ใช่ end button)
    // -------------------------------------------------------------------------
    for (final bk in primaryButtons) {
      st.add({'tap': {'byKey': bk}});
      st.add({'pump': true});
    }

    // -------------------------------------------------------------------------
    // Step 9.7: Final End Action (submit form)
    // -------------------------------------------------------------------------
    if (endKey != null) {
      st.add({'tap': {'byKey': endKey}});
      st.add({'pumpAndSettle': true}); // รอ API call และ animation
    }

    return st;
}

// ---------------------------------------------------------------------------
// STEP 10: เตรียม Test Cases และ Helper Functions
// ---------------------------------------------------------------------------

  // List เก็บ test cases ที่จะสร้าง
  final cases = <Map<String, dynamic>>[];

  // NOTE: ไม่รวม stubbed setup/response
  // Integration tests ใช้ real backend/providers
  final successSetup = <String, dynamic>{};

  // ---------------------------------------------------------------------------
  // Helper Functions สำหรับ Test Case Generation
  // ---------------------------------------------------------------------------

  /// ดึง short version ของ key (ลบ prefix ออก)
  /// Example: customer_01_name_textfield -> 01_name_textfield
  String _shortKey(String k){
    final i = k.indexOf('_');
    return (i>0 && i+1<k.length) ? k.substring(i+1) : k;
  }

  /// ดึง metadata ของ widget จาก key
  /// ค้นหา widget ที่มี key ตรงกันและ return metadata
  Map<String,dynamic> _widgetMetaByKey(String key){
    for (final w in widgets) {
      if ((w['key'] ?? '') == key) {
        return (w['meta'] as Map?)?.cast<String,dynamic>() ?? const {};
      }
    }
    return const {}; // return empty map ถ้าไม่พบ
  }

/// สร้าง date values สำหรับ DatePicker ตาม firstDate/lastDate constraints
///
/// Parameter:
///   [pickerMeta] - metadata ของ DatePicker widget
///
/// Returns:
///   List<String> - list ของ date values ในรูปแบบ DD/MM/YYYY
///                  รวม 'null' สำหรับ cancel case
///
/// Example output: ['null', '15/01/2001', '29/01/2026', '15/12/2029']
List<String> _generateDateValues(Map<String, dynamic> pickerMeta) {
  final values = <String>[];

  // -------------------------------------------------------------------------
  // Parse firstDate และ lastDate จาก metadata
  // -------------------------------------------------------------------------
  final firstDateStr = (pickerMeta['firstDate'] ?? '').toString();
  final lastDateStr = (pickerMeta['lastDate'] ?? '').toString();

  DateTime? firstDate;
  DateTime? lastDate;
  final now = DateTime.now();

  // Parse firstDate
  if (firstDateStr.contains('DateTime(1900)')) {
    // firstDate: DateTime(1900) - วันที่เก่าที่สุด
    firstDate = DateTime(1900);
  } else if (firstDateStr.contains('DateTime.now()')) {
    // firstDate: DateTime.now() - วันนี้
    firstDate = now;
  } else {
    // ลอง extract year จาก pattern DateTime(year)
    final yearMatch = RegExp(r'DateTime\((\d{4})\)').firstMatch(firstDateStr);
    if (yearMatch != null) {
      firstDate = DateTime(int.parse(yearMatch.group(1)!));
    }
  }

  // Parse lastDate
  if (lastDateStr.contains('DateTime.now()')) {
    if (lastDateStr.contains('add') && lastDateStr.contains('365')) {
      // lastDate: DateTime.now().add(Duration(days: 365)) - 1 ปีข้างหน้า
      lastDate = now.add(const Duration(days: 365));
    } else {
      // lastDate: DateTime.now() - วันนี้
      lastDate = now;
    }
  } else {
    // ลอง extract year จาก pattern DateTime(year)
    final yearMatch = RegExp(r'DateTime\((\d{4})\)').firstMatch(lastDateStr);
    if (yearMatch != null) {
      lastDate = DateTime(int.parse(yearMatch.group(1)!));
    }
  }

  // -------------------------------------------------------------------------
  // Default values ถ้า parse ไม่ได้
  // -------------------------------------------------------------------------
  firstDate ??= DateTime(2000);
  lastDate ??= DateTime(2030);

  // -------------------------------------------------------------------------
  // สร้าง test dates ภายใน constraints
  // -------------------------------------------------------------------------

  // 1. null (cancel) - เสมอ include เพื่อ test cancel behavior
  values.add('null');

  // 2. past_date - วันที่ใกล้ firstDate
  final pastDate = DateTime(
    firstDate.year + 1,  // ปีถัดจาก firstDate
    firstDate.month,
    15.clamp(1, 28),     // วันที่ 15 (กลางเดือน, ปลอดภัยสำหรับทุกเดือน)
  );
  if (pastDate.isAfter(firstDate) && pastDate.isBefore(lastDate)) {
    // Format: DD/MM/YYYY
    values.add('${pastDate.day.toString().padLeft(2, '0')}/${pastDate.month.toString().padLeft(2, '0')}/${pastDate.year}');
  }

  // 3. today - วันนี้ (ถ้าอยู่ใน range)
  if (now.isAfter(firstDate) && now.isBefore(lastDate)) {
    values.add('${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}');
  }

  // 4. future_date - วันที่ใกล้ lastDate
  final futureDate = DateTime(
    lastDate.year - 1,   // ปีก่อน lastDate
    lastDate.month,
    15.clamp(1, 28),     // วันที่ 15
  );
  if (futureDate.isAfter(firstDate) && futureDate.isBefore(lastDate) && futureDate.isAfter(now)) {
    values.add('${futureDate.day.toString().padLeft(2, '0')}/${futureDate.month.toString().padLeft(2, '0')}/${futureDate.year}');
  }

  // -------------------------------------------------------------------------
  // Fallback: ถ้ามีน้อยกว่า 3 values ให้เพิ่ม middle date
  // -------------------------------------------------------------------------
  if (values.length < 3) {
    final middleDate = DateTime(
      (firstDate.year + lastDate.year) ~/ 2,  // ปีกลางระหว่าง first และ last
      6,  // เดือน June
      15, // วันที่ 15
    );
    values.add('${middleDate.day.toString().padLeft(2, '0')}/${middleDate.month.toString().padLeft(2, '0')}/${middleDate.year}');
  }

  return values;
}

/// ดึง maxLength จาก widget metadata
///
/// ตรวจสอบจาก 2 sources:
///   1. inputFormatters - LengthLimitingTextInputFormatter
///   2. maxLength property
///
/// Parameter:
///   [meta] - metadata ของ widget
///
/// Returns:
///   int? - maxLength หรือ null ถ้าไม่พบ
int? _maxLenFromMeta(Map<String,dynamic> meta){
  // ตรวจสอบ inputFormatter ก่อน (LengthLimitingTextInputFormatter มี priority สูงกว่า)
  final fmts = (meta['inputFormatters'] as List? ?? const []).cast<Map>();
  // หา formatter ที่เป็น type 'lengthLimit'
  final lenFmt = fmts.firstWhere((f) => (f['type'] ?? '') == 'lengthLimit', orElse: ()=>{});
  // ถ้าพบและมี max ให้ return
  if (lenFmt is Map && lenFmt['max'] is int) return lenFmt['max'] as int;

  // Fallback: ใช้ maxLength property โดยตรง
  if (meta['maxLength'] is int) return meta['maxLength'] as int;

  return null; // ไม่พบ maxLength
}

  // ---------------------------------------------------------------------------
  // NOTE: ส่วนที่ถูกลบออก
  // - Validation test cases - ไม่สร้าง individual field validation tests แยก
  // - API Response cases - ไม่ต้องการแล้วกับ naming convention ใหม่
  // - Full flow mode - รองรับเฉพาะ pairwise testing
  // ---------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  // STEP 11: Pairwise Test Generation
  // ---------------------------------------------------------------------------

  // ตรวจสอบว่ามี PICT model files หรือไม่
  // รองรับทั้ง API forms และ widget demos
  final pageBase = utils.basenameWithoutExtension(uiFile);

  // Paths ของ PICT files
  final pageResultPath = 'output/model_pairwise/$pageBase.full.result.txt';      // Full pairwise result
  final pageValidResultPath = 'output/model_pairwise/$pageBase.valid.result.txt'; // Valid-only result
  final pageModelPath = 'output/model_pairwise/$pageBase.full.model.txt';         // PICT model definition

  // ตรวจสอบว่า PICT model มีอยู่หรือไม่
  final hasPictModel = File(pageModelPath).existsSync();

  // ---------------------------------------------------------------------------
  // STEP 12: โหลดและวิเคราะห์ PICT Model (ถ้ามี)
  // ---------------------------------------------------------------------------

  if (hasPictModel) {
    // โหลด PICT results และ model factors

    List<Map<String,String>>? extCombos;      // Full pairwise combinations
    List<Map<String,String>>? extValidCombos; // Valid-only combinations
    Map<String, List<String>>? modelFactors;  // Factors จาก model file

    // โหลด PICT model เพื่อดึง factor names และ widget mappings
    if (File(pageModelPath).existsSync()) {
      modelFactors = pict.parsePictModel(File(pageModelPath).readAsStringSync());
    }

    // -------------------------------------------------------------------------
    // สร้าง factor type mapping จาก model factors
    // จัดหมวดหมู่ factors เป็น: text, radio, dropdown, checkbox, switch, datepicker, timepicker
    // -------------------------------------------------------------------------

    final factorTypes = <String, String>{};     // factorName -> type
    final textFieldFactors = <String>[];        // List ของ textfield widget keys
    final radioGroupFactors = <String>[];       // List ของ radio group names
    final dropdownFactors = <String>[];         // List ของ dropdown widget keys
    final checkboxFactors = <String>[];         // List ของ checkbox widget keys
    final switchFactors = <String>[];           // List ของ switch widget keys

    if (modelFactors != null) {
      // วนลูปแต่ละ factor ใน model
      for (final entry in modelFactors.entries) {
        final factorName = entry.key;   // ชื่อ factor (เช่น customer_01_name_textfield)
        final values = entry.value;      // ค่าที่เป็นไปได้ (เช่น ['valid', 'invalid'])

        // กำหนด factor type ตาม values
        if (values.contains('valid') && values.contains('invalid')) {
          // Text field: มี 'valid' และ 'invalid' values
          factorTypes[factorName] = 'text';
          textFieldFactors.add(factorName);
        } else if (values.contains('checked') && values.contains('unchecked')) {
          // Checkbox: มี 'checked' และ 'unchecked' values
          factorTypes[factorName] = 'checkbox';
          checkboxFactors.add(factorName);
        } else if (values.contains('on') && values.contains('off')) {
          // Switch widget: มี 'on' และ 'off' values
          factorTypes[factorName] = 'switch';
          switchFactors.add(factorName);
        } else if (values.any((v) => v.endsWith('_radio'))) {
          // Radio group: มี value ที่ลงท้ายด้วย '_radio'
          factorTypes[factorName] = 'radio';
          radioGroupFactors.add(factorName);
        } else if (datePickerKeys.contains(factorName)) {
          // DatePicker: ตรวจจากว่า factor name อยู่ใน datePickerKeys
          factorTypes[factorName] = 'datepicker';
        } else if (timePickerKeys.contains(factorName)) {
          // TimePicker: ตรวจจากว่า factor name อยู่ใน timePickerKeys
          factorTypes[factorName] = 'timepicker';
        } else {
          // Dropdown (default): cases อื่นๆ ถือว่าเป็น dropdown
          factorTypes[factorName] = 'dropdown';
          dropdownFactors.add(factorName);
        }
      }
    }

    // -------------------------------------------------------------------------
    // โหลด PICT result files
    // -------------------------------------------------------------------------

    // โหลด full pairwise combinations (valid + invalid)
    if (File(pageResultPath).existsSync()) {
      extCombos = pict.parsePictResult(File(pageResultPath).readAsStringSync());
    }

    // โหลด valid-only combinations
    if (File(pageValidResultPath).existsSync()) {
      extValidCombos = pict.parsePictResult(File(pageValidResultPath).readAsStringSync());
    }

    // -------------------------------------------------------------------------
    // Helper Function: Map Radio Suffix to Full Key
    // -------------------------------------------------------------------------

    /// แปลง Radio suffix เป็น full Radio key
    /// Example: age_10_20_radio -> customer_04_age_10_20_radio
    ///
    /// Parameters:
    ///   [keys]   - list ของ radio keys ทั้งหมด
    ///   [suffix] - suffix ที่ต้องการหา
    ///
    /// Returns:
    ///   String? - full key หรือ null ถ้าไม่พบ
    String? _radioKeyForSuffix(List<String> keys, String suffix){
      if (suffix.isEmpty) return null;

      // หา key ที่ลงท้ายด้วย suffix
      String hit = keys.firstWhere(
        (k) => k.endsWith('_$suffix') || k.endsWith(suffix),
        orElse: () => ''
      );
      return hit.isEmpty ? null : hit;
    }

    // -------------------------------------------------------------------------
    // เลือก combinations ที่จะใช้
    // -------------------------------------------------------------------------

    List<Map<String,String>> combos;
    bool usingExternalCombos = false;

    // ถ้ามี external combos จาก PICT result ให้ใช้เลย
    if (extCombos != null && extCombos.isNotEmpty) {
      combos = extCombos;
      usingExternalCombos = true;
    }
    // ถ้าไม่มี ต้องสร้าง combinations ใหม่
    else {
      // -----------------------------------------------------------------------
      // Fallback: สร้าง factors ใหม่ (ไม่มี PICT model)
      // -----------------------------------------------------------------------

      final factors = <String,List<String>>{};

      // TextFormField factors: เฉพาะ 'valid' และ 'invalid'
      for (int i = 0; i < textKeys.length; i++) {
        // ใช้ชื่อ TEXT, TEXT2, TEXT3, ... สำหรับหลาย fields
        final factorName = textKeys.length == 1 ? 'TEXT' : 'TEXT${i + 1}';
        factors[factorName] = ['valid', 'invalid'];
      }

      // -----------------------------------------------------------------------
      // Auto-detect Radio groups จาก widgets metadata
      // -----------------------------------------------------------------------

      final radioGroups = <String, List<String>>{};

      // Method 1: Group by groupValueBinding (reliable ที่สุด)
      for (final w in widgets) {
        final t = (w['widgetType'] ?? '').toString();
        final k = (w['key'] ?? '').toString();
        if (t.startsWith('Radio') && k.isNotEmpty && radioKeys.contains(k)) {
          try {
            final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? {};
            // ดึง groupValueBinding (ระบุว่า radio ไหนอยู่ group เดียวกัน)
            final groupBinding = (meta['groupValueBinding'] ?? '').toString();
            if (groupBinding.isNotEmpty) {
              radioGroups.putIfAbsent(groupBinding, () => []);
              radioGroups[groupBinding]!.add(k);
            }
          } catch (_) {}
        }
      }

      // Method 2: Fallback ใช้ FormField<int> options (ถ้าไม่พบ groupValueBinding)
      if (radioGroups.isEmpty) {
        for (final w in widgets) {
          final t = (w['widgetType'] ?? '').toString();
          // FormField<int> มักเป็น wrapper ของ radio group
          if (t == 'FormField<int>') {
            try {
              final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? {};
              final options = meta['options'];
              if (options is List) {
                final radioGroup = <String>[];
                // วนลูปหา Radio ที่ตรงกับแต่ละ option
                for (final opt in options) {
                  if (opt is Map) {
                    final optValue = opt['value']?.toString();
                    if (optValue != null) {
                      // หา Radio ที่มี valueExpr ตรงกัน
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
                // เพิ่ม group ถ้ามีมากกว่า 1 option
                if (radioGroup.length > 1) {
                  final groupKey = (w['key'] ?? 'unknown').toString();
                  radioGroups[groupKey] = radioGroup;
                }
              }
            } catch (_) {}
          }
        }
      }

      // เพิ่ม radio groups เป็น factors
      int radioIndex = 1;
      for (final entry in radioGroups.entries) {
        if (entry.value.length > 1) {
          factors['Radio$radioIndex'] = entry.value;
          radioIndex++;
        }
      }

      // Dropdown factors: ใช้ values จาก dropdown แรก
      if (dropdownValues.isNotEmpty) factors['Dropdown'] = List<String>.from(dropdownValues);

      // Checkbox factors: Checkbox, Checkbox2, Checkbox3, ...
      for (int i = 0; i < checkboxKeys.length; i++) {
        final factorName = (checkboxKeys.length == 1 || i == 0) ? 'Checkbox' : 'Checkbox${i + 1}';
        factors[factorName] = ['checked', 'unchecked'];
      }

      // DatePicker factors: สร้าง dates ตาม constraints
      for (int i = 0; i < datePickerKeys.length; i++) {
        final key = datePickerKeys[i];
        final factorName = key; // ใช้ widget key เป็น factor name

        // หา picker metadata
        final widget = widgets.firstWhere((w) => (w['key'] ?? '') == key, orElse: () => <String, dynamic>{});
        final pickerMeta = (widget['pickerMetadata'] as Map?)?.cast<String, dynamic>() ?? {};

        // สร้าง date values ตาม constraints
        final dateValues = _generateDateValues(pickerMeta);
        factors[factorName] = dateValues;
      }

      // TimePicker factors: สร้าง times
      for (int i = 0; i < timePickerKeys.length; i++) {
        final key = timePickerKeys[i];
        final factorName = timePickerKeys.length == 1 ? key : key;
        // ค่าเวลาตัวอย่าง + null สำหรับ cancel
        factors[factorName] = ['09:00', '14:30', '18:00', 'null'];
      }

      // -----------------------------------------------------------------------
      // Generate pairwise combinations
      // -----------------------------------------------------------------------

      if (pairwiseUsePict) {
        // ลองใช้ PICT tool ก่อน
        try {
          combos = await pict.executePict(factors, pictBin: pictBin);
        } catch (e) {
          // ถ้า PICT ล้มเหลว ใช้ internal algorithm แทน
          stderr.writeln('! PICT failed ($e). Falling back to internal pairwise.');
          combos = pict.generatePairwiseInternal(factors);
        }
      } else {
        // ใช้ internal algorithm
        combos = pict.generatePairwiseInternal(factors);
      }
    }
    
    // -------------------------------------------------------------------------
    // Helper Functions สำหรับสร้าง Test Data
    // -------------------------------------------------------------------------

    /// สร้าง text value สำหรับ boundary value bucket
    ///
    /// รองรับ legacy buckets: min, min+1, nominal, max-1, max
    /// ใช้เมื่อไม่มี dataset สำหรับ field นั้น
    ///
    /// Parameters:
    ///   [tfKey]  - key ของ textfield
    ///   [bucket] - boundary bucket (valid, invalid, min, max, etc.)
    ///
    /// Returns:
    ///   String - text value ที่เหมาะกับ bucket
    String textForBucket(String tfKey, String bucket){
      // ดึง maxLength ของ field
      final maxLen = _maxLenFromMeta(_widgetMetaByKey(tfKey));

      // Legacy boundary buckets
      if (bucket=='min') return '';           // empty string
      if (bucket=='min+1') return 'A';        // 1 character
      if (bucket=='nominal') {
        // ค่ากลาง: ครึ่งหนึ่งของ maxLength หรือ 5
        final n = (maxLen != null && maxLen > 2) ? (maxLen~/2) : 5;
        return 'A' * n;
      }
      if (bucket=='max-1') {
        // maxLength - 1
        if (maxLen != null && maxLen > 1) return 'A' * (maxLen-1);
        return 'A';
      }
      if (bucket=='max') {
        // maxLength เต็ม
        final m = maxLen ?? 10;
        return 'A' * m;
      }

      // Default: 5 characters
      return 'A' * 5;
    }

    /// สร้าง dataset path สำหรับ field และ bucket ที่กำหนด
    ///
    /// Parameters:
    ///   [tfKey]  - key ของ textfield
    ///   [bucket] - 'valid' หรือ 'invalid'
    ///
    /// Returns:
    ///   String? - dataset path หรือ null ถ้าไม่พบ
    ///
    /// Example:
    ///   datasetPathForKeyBucket('name_textfield', 'valid')
    ///   -> 'byKey.name_textfield[0].valid'
    String? datasetPathForKeyBucket(String tfKey, String bucket){
      final ds = (datasets['byKey'] as Map?)?.cast<String, dynamic>() ?? const {};

      // ตรวจสอบว่ามี key นี้ใน datasets หรือไม่
      if (!ds.containsKey(tfKey)) return null;

      // รับเฉพาะ valid และ invalid buckets
      if (bucket != 'valid' && bucket != 'invalid') return null;

      // New format: byKey.<key> เป็น array of objects
      final dataArray = ds[tfKey];
      if (dataArray is List && dataArray.isNotEmpty) {
        // Return path: byKey.<key>[0].valid หรือ byKey.<key>[0].invalid
        return 'byKey.$tfKey[0].$bucket';
      }

      // Fallback: old format (map with valid/invalid lists)
      final sub = (ds[tfKey] as Map?)?.cast<String, dynamic>() ?? const {};
      final list = (sub[bucket] as List?) ?? const [];
      if (list.isEmpty) return null;
      return 'byKey.$tfKey.$bucket[0]';
    }

    // -------------------------------------------------------------------------
    // STEP 13: สร้าง Pairwise Test Cases
    // -------------------------------------------------------------------------

    // วนลูปแต่ละ combination ที่ได้จาก PICT
    for (int i = 0; i < combos.length; i++) {
      final c = combos[i]; // current combination

      // ดึง radio picks (legacy support)
      final r1Pick = (c['Radio1'] ?? '').toString();
      final r2Pick = (c['Radio2'] ?? '').toString();
      final r3Pick = (c['Radio3'] ?? '').toString();
      final r4Pick = (c['Radio4'] ?? '').toString();
      final ddPick = (c['Dropdown'] ?? '').toString();

      // List เก็บ steps สำหรับ test case นี้
      final st = <Map<String,dynamic>>[];

      // -----------------------------------------------------------------------
      // Track Invalid Data
      // ใช้เพื่อกำหนด test case kind (success/failed)
      // -----------------------------------------------------------------------

      bool hasInvalidData = false;                      // มี invalid data หรือไม่
      final invalidFields = <String>[];                  // fields ที่ใช้ invalid data
      final uncheckedRequiredCheckboxes = <String>[];   // required checkboxes ที่ไม่ได้ check

      // -----------------------------------------------------------------------
      // Process Factors ตาม PICT header order (ถ้าใช้ external combos)
      // -----------------------------------------------------------------------
      if (usingExternalCombos) {
        // ดึง header order จาก PICT result file เพื่อเรียง factors
        List<String> headerOrder = [];
        if (File(pageResultPath).existsSync()) {
          final content = File(pageResultPath).readAsStringSync();
          // แยก lines และกรอง empty lines
          final lines = content.trim().split(RegExp(r'\r?\n')).where((l) => l.trim().isNotEmpty).toList();
          if (lines.isNotEmpty) {
            // บรรทัดแรกคือ header (tab-separated)
            headerOrder = lines.first.split('\t').map((s) => s.trim()).toList();
          }
        }

        // สร้าง map เก็บ steps แยกตาม widget key
        // ใช้เพื่อรักษาลำดับตาม manifest
        final stepsByKey = <String, List<Map<String, dynamic>>>{};

        // Process แต่ละ factor ตาม actual factor names จาก model
        for (final factorName in c.keys) {
          final factorType = factorTypes[factorName]; // ดึง type ของ factor
          final pick = (c[factorName] ?? '').toString(); // ค่าที่เลือกสำหรับ factor นี้
          if (pick.isEmpty) continue;

          // -----------------------------------------------------------------
          // Text Field: กรอกข้อความ valid หรือ invalid
          // -----------------------------------------------------------------
          if (factorType == 'text') {
            // กำหนด bucket จากค่าที่เลือก
            final bucket = (pick == 'invalid') ? 'invalid' : 'valid';
            if (bucket == 'invalid') {
              hasInvalidData = true;
              invalidFields.add(factorName); // Track field นี้เป็น invalid
            }
            // สร้าง enterText step พร้อม dataset path
            stepsByKey[factorName] = [
              {'enterText': {'byKey': factorName, 'dataset': 'byKey.$factorName[0].$bucket'}},
              {'pump': true}
            ];
          }
          // -----------------------------------------------------------------
          // Radio Group: เลือก radio option
          // -----------------------------------------------------------------
          else if (factorType == 'radio') {
            // pick คือ radio option suffix (เช่น age_10_20_radio)
            final matchedKey = _radioKeyForSuffix(radioKeys, pick);
            if (matchedKey != null) {
              stepsByKey[matchedKey] = [
                {'tap': {'byKey': matchedKey}},
                {'pump': true}
              ];
            }
          }
          // -----------------------------------------------------------------
          // Dropdown: เลือก dropdown option
          // -----------------------------------------------------------------
          else if (factorType == 'dropdown') {
            // แปลง value เป็น text ที่แสดงใน UI
            String textToTap = pick;
            final dropdownIdx = dropdownKeys.indexOf(factorName);
            if (dropdownIdx >= 0 && dropdownIdx < dropdownValueToTextMaps.length) {
              final mapping = dropdownValueToTextMaps[dropdownIdx];
              final cleanPick = pick.replaceAll('"', '');
              textToTap = mapping[cleanPick] ?? pick;
            }

            stepsByKey[factorName] = [
              {'tap': {'byKey': factorName}},   // เปิด dropdown
              {'pump': true},
              {'tapText': textToTap},            // เลือก option
              {'pump': true}
            ];
          }
          // -----------------------------------------------------------------
          // Checkbox: check หรือ uncheck
          // -----------------------------------------------------------------
          else if (factorType == 'checkbox') {
            if (pick == 'checked') {
              // Tap เพื่อ check
              stepsByKey[factorName] = [
                {'tap': {'byKey': factorName}},
                {'pump': true}
              ];
            } else if (pick == 'unchecked' && requiredCheckboxValidation.containsKey(factorName)) {
              // Required checkbox ที่ unchecked = invalid form state
              hasInvalidData = true;
              uncheckedRequiredCheckboxes.add(factorName);
            }
            // ถ้า unchecked และไม่ required ไม่ต้องทำอะไร (default state)
          }
          // -----------------------------------------------------------------
          // Switch: on หรือ off
          // -----------------------------------------------------------------
          else if (factorType == 'switch') {
            // Tap เฉพาะถ้า 'on' (off คือ default state)
            if (pick == 'on') {
              stepsByKey[factorName] = [
                {'tap': {'byKey': factorName}},
                {'pump': true}
              ];
            }
          }
          // -----------------------------------------------------------------
          // DatePicker: เปิด picker และเลือกวันที่
          // -----------------------------------------------------------------
          else if (datePickerKeys.contains(factorName)) {
            stepsByKey[factorName] = [
              {'tap': {'byKey': factorName}},    // เปิด picker
              {'pumpAndSettle': true},            // รอ dialog
              {'selectDate': pick},               // เลือกวันที่
              {'pumpAndSettle': true}             // รอปิด dialog
            ];
          }
          // -----------------------------------------------------------------
          // TimePicker: เปิด picker และเลือกเวลา
          // -----------------------------------------------------------------
          else if (timePickerKeys.contains(factorName)) {
            stepsByKey[factorName] = [
              {'tap': {'byKey': factorName}},    // เปิด picker
              {'pumpAndSettle': true},            // รอ dialog
              {'selectTime': pick},               // เลือกเวลา
              {'pumpAndSettle': true}             // รอปิด dialog
            ];
          }
        }

        // ---------------------------------------------------------------------
        // เพิ่ม steps ตามลำดับ widget key (sort ก่อน)
        // ---------------------------------------------------------------------
        final sortedWidgets = List<Map<String, dynamic>>.from(widgets);
        sortedWidgets.sort((a, b) {
          final keyA = (a['key'] ?? '').toString();
          final keyB = (b['key'] ?? '').toString();
          return keyA.compareTo(keyB);
        });

        // วนลูปเพิ่ม steps ตามลำดับ sorted widgets
        for (final w in sortedWidgets) {
          final key = (w['key'] ?? '').toString();
          if (stepsByKey.containsKey(key)) {
            st.addAll(stepsByKey[key]!);
          }
        }
      }
      // ---------------------------------------------------------------------
      // Fallback: ไม่ได้ใช้ external combos
      // ---------------------------------------------------------------------
      else {
        // Fallback: ใช้ original logic สำหรับ non-external combos
        // สร้าง map เก็บ steps แยกตาม widget key
        final stepsByKey = <String, List<Map<String, dynamic>>>{};

        // ---------------------------------------------------------------------
        // Process Text Fields
        // ---------------------------------------------------------------------
        for (int j = 0; j < textKeys.length; j++) {
          // กำหนด factor name: TEXT, TEXT2, TEXT3, ...
          final factorName = textKeys.length == 1 ? 'TEXT' : 'TEXT${j + 1}';
          final tfBucket = c[factorName]; // ค่า bucket ที่เลือก (valid/invalid)

          if (tfBucket != null) {
            // Track invalid data
            if (tfBucket.toString() == 'invalid') {
              hasInvalidData = true;
              invalidFields.add(textKeys[j]);
            }

            // หา dataset path
            final dsPath = datasetPathForKeyBucket(textKeys[j], tfBucket.toString());
            if (dsPath != null) {
              // ใช้ dataset path
              stepsByKey[textKeys[j]] = [
                {'enterText': {'byKey': textKeys[j], 'dataset': dsPath}},
                {'pump': true}
              ];
            } else {
              // Fallback: ใช้ generated text
              stepsByKey[textKeys[j]] = [
                {'enterText': {'byKey': textKeys[j], 'text': textForBucket(textKeys[j], tfBucket)}},
                {'pump': true}
              ];
            }
          }
        }

        // ---------------------------------------------------------------------
        // Process Dropdown
        // ---------------------------------------------------------------------
        if (dropdownKey != null && c['Dropdown'] != null) {
          final ddPick = (c['Dropdown'] ?? '').toString();
          if (ddPick.isNotEmpty) {
            stepsByKey[dropdownKey] = [
              {'tap': {'byKey': dropdownKey}}, // เปิด dropdown
              {'pump': true},
              {'tapText': ddPick},              // เลือก option
              {'pump': true}
            ];
          }
        }

        // ---------------------------------------------------------------------
        // Process Radio Groups
        // Match Radio suffix จาก PICT กับ full Radio key
        // ---------------------------------------------------------------------
        for (final factorName in c.keys) {
          if (factorName.startsWith('Radio')) {
            final pick = (c[factorName] ?? '').toString();
            if (pick.isNotEmpty) {
              // pick คือ Radio suffix เช่น "age_10_20_radio"
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

        // ---------------------------------------------------------------------
        // Process Checkboxes
        // ---------------------------------------------------------------------
        for (int idx = 0; idx < checkboxKeys.length; idx++) {
          // กำหนด factor name: Checkbox, Checkbox2, Checkbox3, ...
          final factorName = (checkboxKeys.length == 1 || idx == 0) ? 'Checkbox' : 'Checkbox${idx + 1}';
          final pick = (c[factorName] ?? '').toString();

          // Tap เฉพาะถ้าเลือก 'checked'
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

        // ---------------------------------------------------------------------
        // Process DatePicker Widgets
        // ---------------------------------------------------------------------
        for (int idx = 0; idx < datePickerKeys.length; idx++) {
          final key = datePickerKeys[idx];
          final factorName = datePickerKeys.length == 1 ? key : key;
          final pick = (c[factorName] ?? '').toString();

          if (pick.isNotEmpty && key.isNotEmpty) {
            stepsByKey[key] = [
              {'tap': {'byKey': key}},          // เปิด picker
              {'pumpAndSettle': true},           // รอ dialog ปรากฏ
              {'selectDate': pick},              // เลือกวันที่: DD/MM/YYYY หรือ null
              {'pumpAndSettle': true}            // รอ dialog ปิด
            ];
          }
        }

        // ---------------------------------------------------------------------
        // Process TimePicker Widgets
        // ---------------------------------------------------------------------
        for (int idx = 0; idx < timePickerKeys.length; idx++) {
          final key = timePickerKeys[idx];
          final factorName = timePickerKeys.length == 1 ? key : key;
          final pick = (c[factorName] ?? '').toString();

          if (pick.isNotEmpty && key.isNotEmpty) {
            stepsByKey[key] = [
              {'tap': {'byKey': key}},          // เปิด picker
              {'pumpAndSettle': true},           // รอ dialog ปรากฏ
              {'selectTime': pick},              // เลือกเวลา: HH:MM หรือ null
              {'pumpAndSettle': true}            // รอ dialog ปิด
            ];
          }
        }

        // ---------------------------------------------------------------------
        // เพิ่ม steps ตามลำดับ widget key (sort ก่อน)
        // ---------------------------------------------------------------------
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

      // -----------------------------------------------------------------------
      // Final Action: Submit Form (ถ้ามี end button)
      // -----------------------------------------------------------------------

      if (hasEndButton && endKey != null) {
        // API flow: กดปุ่ม submit
        st.add({'tap': {'byKey': endKey}});
        st.add({'pumpAndSettle': true}); // รอ API call และ animation
      } else {
        // Widget demo: ไม่มีปุ่ม submit, แค่ pump
        st.add({'pump': true});
      }

      // -----------------------------------------------------------------------
      // กำหนด Test Case Kind
      // -----------------------------------------------------------------------

      // กำหนดว่า test case เป็น success หรือ failed
      // ขึ้นอยู่กับว่ามี invalid data หรือไม่
      final caseKind = hasInvalidData ? 'failed' : 'success';

      // สร้าง test case ID
      final id = 'pairwise_valid_invalid_cases_${i + 1}';

      // -----------------------------------------------------------------------
      // สร้าง Assertions
      // -----------------------------------------------------------------------

      final asserts = <Map<String, dynamic>>[];

      if (hasInvalidData) {
        // Case: มี invalid data -> คาดหวัง validation error messages

        final ds = (datasets['byKey'] as Map?)?.cast<String, dynamic>() ?? const {};

        // ดึง invalidRuleMessages จาก datasets สำหรับแต่ละ invalid field
        for (final fieldKey in invalidFields) {
          final dataArray = ds[fieldKey];
          if (dataArray is List && dataArray.isNotEmpty) {
            // ใช้ index [0] ตาม dataset path
            final firstPair = dataArray[0];
            if (firstPair is Map) {
              final invalidRuleMsg = firstPair['invalidRuleMessages']?.toString();
              // รวมเฉพาะ validation messages ที่ไม่ใช่ "Required" หรือ "กรุณา"
              // (empty field messages ถูกจัดการแยกใน edge_cases)
              if (invalidRuleMsg != null &&
                  invalidRuleMsg.isNotEmpty &&
                  !invalidRuleMsg.toLowerCase().contains('required') &&
                  !invalidRuleMsg.toLowerCase().contains('กรุณา')) {
                asserts.add({'text': invalidRuleMsg, 'exists': true});
              }
            }
          }
        }

        // เพิ่ม validation messages สำหรับ unchecked required checkboxes
        for (final checkboxKey in uncheckedRequiredCheckboxes) {
          final validationMsg = requiredCheckboxValidation[checkboxKey];
          if (validationMsg != null && validationMsg.isNotEmpty) {
            asserts.add({'text': validationMsg, 'exists': true});
          }
        }

        // Assert ว่า expected fail keys ต้อง exist
        for (final failKey in expectedFailKeys) {
          asserts.add({'byKey': failKey, 'exists': true});
        }
      } else {
        // Case: valid data -> คาดหวัง success keys

        for (final successKey in expectedSuccessKeys) {
          asserts.add({'byKey': successKey, 'exists': true});
        }
      }

      // -----------------------------------------------------------------------
      // เพิ่ม Test Case ลง List
      // -----------------------------------------------------------------------

      cases.add({
        'tc': id,                              // Test case ID
        'kind': caseKind,                      // success หรือ failed
        'group': 'pairwise_valid_invalid_cases', // Group name
        'steps': st,                           // List ของ steps
        'asserts': asserts,                    // List ของ assertions
      });
    }

    // -------------------------------------------------------------------------
    // STEP 14: สร้าง Pairwise Valid-Only Cases
    // สร้าง test cases เพิ่มเติมที่ใช้เฉพาะ valid data
    // -------------------------------------------------------------------------

    if (extValidCombos != null && extValidCombos.isNotEmpty) {
      // วนลูปแต่ละ valid combination
      for (int i = 0; i < extValidCombos.length; i++) {
        final c = extValidCombos[i];
        final st = <Map<String,dynamic>>[];

        // ดึง header order จาก valid result file
        List<String> headerOrder = [];
        if (File(pageValidResultPath).existsSync()) {
          final content = File(pageValidResultPath).readAsStringSync();
          final lines = content.trim().split(RegExp(r'\r?\n')).where((l) => l.trim().isNotEmpty).toList();
          if (lines.isNotEmpty) {
            // บรรทัดแรกคือ header
            headerOrder = lines.first.split('\t').map((s) => s.trim()).toList();
          }
        }

        // Fallback: ใช้ default order ถ้าไม่พบ header
        if (headerOrder.isEmpty) {
          headerOrder = ['TEXT', 'TEXT2', 'TEXT3', 'Radio2', 'Radio3', 'Radio4', 'Dropdown'];
        }

        // สร้าง map เก็บ steps แยกตาม widget key
        final stepsByKey = <String, List<Map<String, dynamic>>>{};

        // Process แต่ละ factor ตาม header order
        for (final factorName in headerOrder) {
          final pick = (c[factorName] ?? '').toString();
          if (pick.isEmpty) continue;

          final factorType = factorTypes[factorName];

          // Text field: ใช้ valid data เสมอ
          if (factorType == 'text') {
            stepsByKey[factorName] = [
              {'enterText': {'byKey': factorName, 'dataset': 'byKey.$factorName[0].valid'}},
              {'pump': true}
            ];
          }
          // Radio group
          else if (factorType == 'radio') {
            final matchedKey = _radioKeyForSuffix(radioKeys, pick);
            if (matchedKey != null) {
              stepsByKey[matchedKey] = [
                {'tap': {'byKey': matchedKey}},
                {'pump': true}
              ];
            }
          }
          // Dropdown
          else if (factorType == 'dropdown') {
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
          }
          // Checkbox
          else if (factorType == 'checkbox') {
            if (pick == 'checked') {
              stepsByKey[factorName] = [
                {'tap': {'byKey': factorName}},
                {'pump': true}
              ];
            }
          }
          // Switch
          else if (factorType == 'switch') {
            if (pick == 'on') {
              stepsByKey[factorName] = [
                {'tap': {'byKey': factorName}},
                {'pump': true}
              ];
            }
          }
          // DatePicker
          else if (datePickerKeys.contains(factorName)) {
            stepsByKey[factorName] = [
              {'tap': {'byKey': factorName}},
              {'pumpAndSettle': true},
              {'selectDate': pick},
              {'pumpAndSettle': true}
            ];
          }
          // TimePicker
          else if (timePickerKeys.contains(factorName)) {
            stepsByKey[factorName] = [
              {'tap': {'byKey': factorName}},
              {'pumpAndSettle': true},
              {'selectTime': pick},
              {'pumpAndSettle': true}
            ];
          }
        }

        // เพิ่ม steps ตามลำดับ sorted widgets
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

        // Final action
        if (hasEndButton && endKey != null) {
          st.add({'tap': {'byKey': endKey}});
          st.add({'pumpAndSettle': true});
        } else {
          st.add({'pump': true});
        }

        // Valid-only cases: คาดหวัง success เสมอ
        final id = 'pairwise_valid_cases_${i + 1}';
        final asserts = <Map<String, dynamic>>[];
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
  } // End of hasPictModel block

  // ---------------------------------------------------------------------------
  // NOTE: Radio-only state cases ถูกลบออกตาม requirement ล่าสุด
  // ---------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  // STEP 15: สร้าง Edge Cases - Empty All Fields Test
  // ---------------------------------------------------------------------------

  // Test case: กดปุ่ม submit โดยไม่กรอกข้อมูลใดๆ
  // คาดหวังว่าจะเห็น validation messages สำหรับทุก required fields

  // Map เก็บ validation messages และจำนวนครั้งที่คาดหวังจะเห็น
  final expectedMsgsCount = <String, int>{};

  /// Helper: ตรวจสอบว่า condition เป็นการ validate empty/null หรือไม่
  bool _isEmptyCheckCondition(String condition) {
    final normalized = condition.toLowerCase().replaceAll(' ', '');
    // Patterns ที่บ่งบอกว่าเป็น empty validation
    return normalized.contains('value==null') ||
           normalized.contains('value.isempty') ||
           normalized.contains('valuenull') ||
           normalized.contains('valueisempty');
  }

  // วนลูปหา validation messages จากทุก widgets
  for (final w in widgets) {
    try {
      final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? const {};

      // -------------------------------------------------------------------------
      // Method 1: ตรวจสอบ validatorRules (reliable กว่า - ใช้ condition logic)
      // -------------------------------------------------------------------------
      final rules = (meta['validatorRules'] as List?)?.cast<dynamic>() ?? const [];
      for (final rule in rules) {
        if (rule is Map) {
          final condition = rule['condition']?.toString() ?? '';
          final msg = rule['message']?.toString() ?? '';

          // วิเคราะห์ condition เพื่อดูว่าเป็น empty validation หรือไม่
          if (msg.isNotEmpty && _isEmptyCheckCondition(condition)) {
            // นับจำนวนครั้งที่คาดหวังจะเห็น message นี้
            expectedMsgsCount[msg] = (expectedMsgsCount[msg] ?? 0) + 1;
          }
        }
      }

      // -------------------------------------------------------------------------
      // Method 2: Fallback - ใช้ validatorMessages (สำหรับ TextFormField ที่ไม่มี explicit rules)
      // -------------------------------------------------------------------------
      if (rules.isEmpty) {
        final v = (meta['validatorMessages'] as List?)?.cast<dynamic>() ?? const [];
        for (final m in v) {
          final s = m?.toString() ?? '';
          // Pattern matching สำหรับ empty field validation messages
          // รองรับทั้งภาษาอังกฤษและภาษาไทย
          if (s.isNotEmpty && (
              s.toLowerCase().contains('required') ||
              s.contains('กรุณา') ||        // Thai: "please"
              s.contains('โปรด') ||          // Thai: "please"
              s.contains('ต้อง') ||          // Thai: "must"
              s.toLowerCase().contains('please') ||
              s.toLowerCase().contains('cannot be empty') ||
              s.toLowerCase().contains('is required'))) {
            expectedMsgsCount[s] = (expectedMsgsCount[s] ?? 0) + 1;
            break; // เก็บแค่ message แรกของ field นี้
          }
        }
      }
    } catch (_) {
      // ignore errors
    }
  }

  // Fallback: ถ้าไม่พบ specific messages ให้ใช้ "Required" default
  if (expectedMsgsCount.isEmpty && textKeys.isNotEmpty) {
    for (final tfKey in textKeys) {
      expectedMsgsCount['Required'] = (expectedMsgsCount['Required'] ?? 0) + 1;
    }
  }

  // สร้าง assertions สำหรับ empty fields test
  // รวม 'count' เพื่อบอกว่าคาดหวังจะเห็น message นี้กี่ครั้ง
  final emptyAsserts = [
    for (final entry in expectedMsgsCount.entries)
      {'text': entry.key, 'exists': true, 'count': entry.value}
  ];

  // สร้าง steps สำหรับ empty fields test
  final emptySteps = <Map<String,dynamic>>[];
  // กดปุ่ม end/submit เพื่อ trigger validation
  if (endKey != null) {
    emptySteps.add({'tap': {'byKey': endKey}});
    emptySteps.add({'pumpAndSettle': true});
  }

  // เพิ่ม edge case ลง test cases
  cases.add({
    'tc': 'edge_cases_empty_all_fields',  // Test case ID
    'kind': 'failed',                       // คาดหวังว่าจะ fail
    'group': 'edge_cases',                  // Group name
    'steps': emptySteps,                    // Steps (แค่กดปุ่ม submit)
    'asserts': emptyAsserts,                // คาดหวังเห็น validation messages
  });

  // ---------------------------------------------------------------------------
  // STEP 16: เขียน Output File
  // ---------------------------------------------------------------------------

  // สร้างโครงสร้าง output JSON
  // มี 3 sections หลัก: source, datasets, cases
  final plan = <String, dynamic>{
    'source': source,      // ข้อมูล source (UI file, page class, cubit class)
    'datasets': datasets,  // datasets สำหรับ test data
    'cases': cases,        // list ของ test cases
  };

  // กำหนด output path
  // ตัวอย่าง: lib/demos/customer_page.dart -> output/test_data/customer_page.testdata.json
  final outPath = 'output/test_data/${utils.basenameWithoutExtension(uiFile)}.testdata.json';

  // สร้าง directory ถ้ายังไม่มี (recursive)
  File(outPath).createSync(recursive: true);

  // เขียน JSON ไฟล์ (pretty print with 2-space indent)
  File(outPath).writeAsStringSync(const JsonEncoder.withIndent('  ').convert(plan) + '\n');

  // แสดง success message
  stdout.writeln('✓ fullpage plan: $outPath');
}

// =============================================================================
// NOTE: _basename, _basenameWithoutExtension ถูกย้ายไปใช้จาก utils.dart
// =============================================================================

// =============================================================================
// PICT MODEL GENERATION
// =============================================================================

/// พยายามสร้าง PICT model จาก manifest file
///
/// อ่าน manifest file และสร้าง PICT model files สำหรับ pairwise testing
///
/// Parameters:
///   [uiFile]      - path ของ UI file (เช่น lib/demos/register_page.dart)
///   [pictBin]     - path ของ PICT binary
///   [constraints] - PICT constraints string (optional)
///
/// Output files:
///   - output/model_pairwise/<page>.full.model.txt
///   - output/model_pairwise/<page>.full.result.txt
///   - output/model_pairwise/<page>.valid.model.txt
///   - output/model_pairwise/<page>.valid.result.txt
Future<void> _tryWritePictModelFromManifestForUi(String uiFile, {String pictBin = './pict', String? constraints}) async {
  // ดึงชื่อไฟล์โดยไม่มี extension
  final base = utils.basenameWithoutExtension(uiFile);

  // ---------------------------------------------------------------------------
  // คำนวณ subfolder path จาก uiFile
  // ตัวอย่าง: lib/demos/register_page.dart → demos
  // ---------------------------------------------------------------------------

  final normalizedPath = uiFile.replaceAll('\\', '/'); // normalize path separators
  String subfolderPath = '';

  if (normalizedPath.startsWith('lib/')) {
    // ดึง path หลัง 'lib/'
    final pathAfterLib = normalizedPath.substring(4);
    // หา last slash เพื่อแยก folder และ filename
    final lastSlash = pathAfterLib.lastIndexOf('/');
    if (lastSlash > 0) {
      subfolderPath = pathAfterLib.substring(0, lastSlash);
    }
  }

  // ---------------------------------------------------------------------------
  // กำหนด manifest path
  // ---------------------------------------------------------------------------

  final manifestPath = subfolderPath.isNotEmpty
      ? 'output/manifest/$subfolderPath/$base.manifest.json'  // มี subfolder
      : 'output/manifest/$base.manifest.json';                 // ไม่มี subfolder

  final f = File(manifestPath);

  // ถ้าไม่มี manifest ให้ข้ามไป (silently)
  if (!f.existsSync()) return;

  // ---------------------------------------------------------------------------
  // อ่านและ parse manifest
  // ---------------------------------------------------------------------------

  final j = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
  final widgets = (j['widgets'] as List? ?? const []).cast<Map<String, dynamic>>();

  // ---------------------------------------------------------------------------
  // ดึง factors และ required checkboxes จาก manifest
  // ใช้ pict_generator module
  // ---------------------------------------------------------------------------

  final extractionResult = pict.extractFactorsFromManifest(widgets);
  final factors = extractionResult.factors;
  final requiredCheckboxes = extractionResult.requiredCheckboxes;

  // ถ้าไม่มี factors ให้ข้ามไป
  if (factors.isEmpty) return;

  // ---------------------------------------------------------------------------
  // สร้างและเขียน PICT model files
  // ---------------------------------------------------------------------------

  await pict.writePictModelFiles(
    factors: factors,
    pageBaseName: base,
    requiredCheckboxes: requiredCheckboxes,
    pictBin: pictBin,
    constraints: constraints,
  );
}

// =============================================================================
// HELPER FUNCTIONS - Dropdown Options
// =============================================================================

/// ดึง options จาก dropdown metadata
///
/// รองรับหลาย formats:
///   - List ของ Maps: [{value: "v1", text: "Text 1"}, ...]
///   - List ของ strings: ["opt1", "opt2", ...]
///
/// Parameter:
///   [raw] - raw options data จาก metadata
///
/// Returns:
///   List<String> - list ของ option values (cleaned for PICT compatibility)
List<String> _optionsFromMeta(dynamic raw) {
  final out = <String>[];

  if (raw is List) {
    // วนลูปแต่ละ entry
    for (final entry in raw) {
      if (entry is Map) {
        // Format: {value: "...", text: "...", label: "..."}
        // ใช้ value field ก่อน (PICT compatible - ASCII only)
        final value = entry['value']?.toString();
        final text = entry['text']?.toString();
        final label = entry['label']?.toString();

        // เลือก field ที่มีค่า
        final chosen = (value != null && value.isNotEmpty) ? value
                     : (text != null && text.isNotEmpty) ? text
                     : label;

        if (chosen != null && chosen.isNotEmpty) {
          // แทนที่ spaces ด้วย underscores สำหรับ PICT compatibility
          final cleaned = chosen.replaceAll(' ', '_');
          out.add(cleaned);
        }
      } else if (entry != null) {
        // Format: string โดยตรง
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
