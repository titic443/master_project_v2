// =============================================================================
// server.dart
// =============================================================================
// HTTP Server สำหรับ Flutter Test Generator Web UI
//
// Server นี้ให้บริการ:
//   1. Static files (HTML, CSS, JS) สำหรับ Web UI
//   2. REST API endpoints สำหรับ test generation pipeline
//   3. Coverage report serving
//
// วิธีใช้งาน:
//   dart run webview/server.dart
//
// Server จะรันที่:
//   http://localhost:8080
//
// API Endpoints:
//   GET  /files              - รายการ Dart files ใน lib/demos/
//   GET  /test-scripts       - รายการ test scripts ใน test/
//   POST /find-file          - หา file path จาก filename
//   POST /scan               - scan widgets ใน file
//   POST /extract-manifest   - สร้าง UI manifest
//   POST /generate-datasets  - สร้าง datasets ด้วย AI
//   POST /generate-test-data - สร้าง test plan ด้วย PICT
//   POST /generate-test-script - สร้าง Flutter test script
//   POST /run-tests          - รัน Flutter tests
//   POST /generate-all       - รัน full pipeline
//   POST /open-coverage      - เปิด coverage report
//   GET  /coverage/*         - serve coverage HTML files
// =============================================================================

// -----------------------------------------------------------------------------
// Import Libraries
// -----------------------------------------------------------------------------

// dart:convert - สำหรับ JSON encoding/decoding และ UTF-8 conversion
// - jsonEncode() : แปลง Map/List เป็น JSON string
// - jsonDecode() : แปลง JSON string เป็น Map/List
// - utf8         : UTF-8 encoder/decoder
import 'dart:convert';

// dart:io - สำหรับ HTTP server, file I/O, และ process execution
// - HttpServer      : HTTP server class
// - HttpRequest     : HTTP request object
// - InternetAddress : IP address representation
// - ContentType     : HTTP content type
// - File/Directory  : file system operations
// - Process         : run external processes
// - Platform        : detect OS platform
import 'dart:io';

// Domain classes - เรียก method ตรงแทน Process.run
import '../tools/script_v2/extract_ui_manifest.dart' show UiManifestExtractor;
import '../tools/script_v2/generate_datasets.dart' show DatasetGenerator;
import '../tools/script_v2/generate_test_data.dart' show TestDataGenerator;
import '../tools/script_v2/generate_test_script.dart' show TestScriptGenerator;

// =============================================================================
// MAIN FUNCTION - Server Entry Point
// =============================================================================

/// Entry point ของ HTTP server
///
/// สร้าง server และใช้ PipelineController จัดการ requests
void main() async {
  // สร้าง controller ที่มี dependencies ครบ
  final controller = PipelineController();

  // HttpServer.bind() สร้าง server ที่ listen บน IP และ port ที่กำหนด
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);

  print('Server running at http://localhost:8080');
  print('Open webview/index.html in your browser\n');

  // Request handling loop
  await for (final request in server) {
    // CORS Headers
    request.response.headers.add('Access-Control-Allow-Origin', '*');
    request.response.headers
        .add('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    request.response.headers
        .add('Access-Control-Allow-Headers', 'Content-Type');

    // Handle Preflight Request
    if (request.method == 'OPTIONS') {
      request.response.statusCode = 200;
      await request.response.close();
      continue;
    }

    // Handle Request with Error Handling
    try {
      await controller.handleRequest(request);
    } catch (e, stackTrace) {
      print('Error: $e');
      print(stackTrace);
      request.response.statusCode = 500;
      request.response.write(jsonEncode({'error': e.toString()}));
      await request.response.close();
    }
  }
}

// =============================================================================
// PipelineController CLASS
// =============================================================================

/// Controller หลักของระบบ Test Generation Pipeline
///
/// Orchestrate การทำงานระหว่าง Extractor, Generator, และ Connection classes
/// แทนที่การ spawn Process.run ด้วยการเรียก method ตรง
class PipelineController {
  final UiManifestExtractor _extractor;
  final DatasetGenerator _datasetGenerator;
  final TestDataGenerator _testDataGenerator;
  final TestScriptGenerator _testScriptGenerator;

  PipelineController({
    UiManifestExtractor? extractor,
    DatasetGenerator? datasetGenerator,
    TestDataGenerator? testDataGenerator,
    TestScriptGenerator? testScriptGenerator,
  })  : _extractor = extractor ?? const UiManifestExtractor(),
        _datasetGenerator = datasetGenerator ?? const DatasetGenerator(),
        _testDataGenerator = testDataGenerator ?? const TestDataGenerator(),
        _testScriptGenerator =
            testScriptGenerator ?? const TestScriptGenerator();

// =============================================================================
// REQUEST ROUTER - Main Handler
// =============================================================================

  /// Router หลักสำหรับจัดการ requests ตาม path
  ///
  /// Parameter:
  ///   [request] - HttpRequest object ที่ต้องการประมวลผล
  Future<void> handleRequest(HttpRequest request) async {
    // ดึง path และ method จาก request
    final path = request.uri.path; // เช่น '/scan', '/extract-manifest'
    final method = request.method; // เช่น 'GET', 'POST'

    // Log request สำหรับ debugging
    print('[$method] $path');

    // กำหนด default content type เป็น JSON
    request.response.headers.contentType = ContentType.json;

    // ---------------------------------------------------------------------------
    // Route request ไปยัง handler ที่เหมาะสมตาม path
    // ---------------------------------------------------------------------------

    switch (path) {
      // API Endpoints
      case '/files':
        // GET /files - รายการ Dart files
        await handleGetFiles(request);
        break;
      case '/test-scripts':
        // GET /test-scripts - รายการ test scripts
        await handleGetTestScripts(request);
        break;
      case '/find-file':
        // POST /find-file - หา file path
        await handleFindFile(request);
        break;
      case '/find-test-script':
        // POST /find-test-script - หา test script path
        await handleFindTestScript(request);
        break;
      case '/scan':
        // POST /scan - scan widgets
        await handleScan(request);
        break;
      case '/extract-manifest':
        // POST /extract-manifest - สร้าง manifest
        await handleExtractManifest(request);
        break;
      case '/generate-datasets':
        // POST /generate-datasets - สร้าง datasets
        await handleGenerateDatasets(request);
        break;
      case '/generate-test-data':
        // POST /generate-test-data - สร้าง test plan
        await handleGenerateTestData(request);
        break;
      case '/generate-test-script':
        // POST /generate-test-script - สร้าง test script
        await handleGenerateTestScript(request);
        break;
      case '/run-tests':
        // POST /run-tests - รัน tests
        await handleRunTests(request);
        break;
      case '/generate-all':
        // POST /generate-all - รัน full pipeline
        await handleGenerateAll(request);
        break;
      case '/open-coverage':
        // POST /open-coverage - เปิด coverage report
        await handleOpenCoverage(request);
        break;
      default:
        // -------------------------------------------------------------------------
        // Static File Serving
        // -------------------------------------------------------------------------

        // Serve coverage files (path เริ่มด้วย /coverage/)
        if (path.startsWith('/coverage/')) {
          await serveCoverageFile(request);
          return;
        }
        // Serve static files (HTML, CSS, JS)
        await serveStaticFile(request);
    }
  }

// =============================================================================
// API HANDLERS - File Listing
// =============================================================================

  /// GET /files - ดึงรายการ Dart files ใน lib/demos/
  ///
  /// Response:
  ///   { "files": ["lib/demos/file1.dart", "lib/demos/file2.dart", ...] }
  Future<void> handleGetFiles(HttpRequest request) async {
    // กำหนด directory ที่จะ scan
    final demosDir = Directory('lib/demos');
    final files = <String>[];

    // ตรวจสอบว่า directory มีอยู่หรือไม่
    if (await demosDir.exists()) {
      // list(recursive: true) จะหาไฟล์ใน subfolders ด้วย
      await for (final entity in demosDir.list(recursive: true)) {
        // กรองเอาเฉพาะ .dart files
        if (entity is File && entity.path.endsWith('.dart')) {
          files.add(entity.path);
        }
      }
    }

    // ส่ง response เป็น JSON
    request.response.write(jsonEncode({'files': files}));
    await request.response.close();
  }

  /// GET /test-scripts - ดึงรายการ test scripts ใน integration_test/
  ///
  /// Response:
  ///   { "files": ["integration_test/page1_flow_test.dart", ...] }
  Future<void> handleGetTestScripts(HttpRequest request) async {
    // กำหนด directory ที่จะ scan
    final testDir = Directory('integration_test');
    final files = <String>[];

    // ตรวจสอบว่า directory มีอยู่หรือไม่
    if (await testDir.exists()) {
      // list() โดยไม่ recursive (เฉพาะ root level)
      await for (final entity in testDir.list()) {
        // กรองเอาเฉพาะไฟล์ที่ลงท้ายด้วย _flow_test.dart
        if (entity is File && entity.path.endsWith('_flow_test.dart')) {
          files.add(entity.path);
        }
      }
    }

    // ส่ง response
    request.response.write(jsonEncode({'files': files}));
    await request.response.close();
  }

// =============================================================================
// API HANDLERS - File Operations
// =============================================================================

  /// POST /find-file - หา file path จาก filename และ content
  ///
  /// Request body:
  ///   { "fileName": "page.dart", "content": "..." (optional) }
  ///
  /// Response:
  ///   { "success": true, "filePath": "lib/demos/page.dart" }
  ///   หรือ { "success": false, "error": "..." }
  Future<void> handleFindFile(HttpRequest request) async {
    // อ่าน request body
    final body = await _readBody(request);
    final fileName = body['fileName'] as String?; // ชื่อไฟล์ที่ต้องการหา
    final content =
        body['content'] as String?; // content สำหรับ verify (optional)

    // Validate input
    if (fileName == null) {
      request.response.statusCode = 400; // Bad Request
      request.response.write(jsonEncode({'error': 'fileName required'}));
      await request.response.close();
      return;
    }

    // ---------------------------------------------------------------------------
    // ค้นหาไฟล์ใน lib/ directory
    // ---------------------------------------------------------------------------

    final libDir = Directory('lib');
    String? foundPath;

    if (await libDir.exists()) {
      // ค้นหาแบบ recursive ใน lib/
      await for (final entity in libDir.list(recursive: true)) {
        // ตรวจสอบว่าชื่อไฟล์ตรงกัน
        if (entity is File && entity.path.endsWith(fileName)) {
          // ถ้ามี content ให้ verify ว่าตรงกัน
          if (content != null) {
            final fileContent = await entity.readAsString();
            if (fileContent == content) {
              foundPath = entity.path;
              break;
            }
          } else {
            // ไม่มี content verification ใช้ไฟล์แรกที่พบ
            foundPath = entity.path;
            break;
          }
        }
      }
    }

    // ---------------------------------------------------------------------------
    // ส่ง response
    // ---------------------------------------------------------------------------

    if (foundPath != null) {
      request.response.write(jsonEncode({
        'success': true,
        'filePath': foundPath,
      }));
    } else {
      request.response.write(jsonEncode({
        'success': false,
        'error': 'File not found in project',
      }));
    }

    await request.response.close();
  }

  /// POST /find-test-script - หา test script path จาก filename
  ///
  /// Request body:
  ///   { "fileName": "page_flow_test.dart" }
  ///
  /// Response:
  ///   { "success": true, "filePath": "integration_test/page_flow_test.dart" }
  Future<void> handleFindTestScript(HttpRequest request) async {
    final body = await _readBody(request);
    final fileName = body['fileName'] as String?;

    if (fileName == null) {
      request.response.statusCode = 400;
      request.response.write(jsonEncode({'error': 'fileName required'}));
      await request.response.close();
      return;
    }

    // ค้นหาใน integration_test/ และ test/
    for (final dirName in ['integration_test', 'test']) {
      final dir = Directory(dirName);
      if (await dir.exists()) {
        await for (final entity in dir.list(recursive: true)) {
          if (entity is File && entity.path.endsWith(fileName)) {
            request.response.write(jsonEncode({
              'success': true,
              'filePath': entity.path,
            }));
            await request.response.close();
            return;
          }
        }
      }
    }

    request.response.write(jsonEncode({
      'success': false,
      'error': 'Test script not found',
    }));
    await request.response.close();
  }

// =============================================================================
// API HANDLERS - Test Generation Pipeline
// =============================================================================

  /// POST /scan - Scan widgets ใน file และสร้าง manifest
  ///
  /// Request body:
  ///   { "file": "lib/demos/page.dart" }
  ///
  /// Response (3 กรณี):
  ///   1. สำเร็จ:       { "success": true,  "resultType": "success",    "widgetCount": 10, ... }
  ///   2. ไม่พบ widgets: { "success": true,  "resultType": "no_widgets", "warning": "..." }
  ///   3. ไม่ใช่ Dart:   { "success": false, "resultType": "not_dart",   "error": "..." }
  Future<void> handleScan(HttpRequest request) async {
    // อ่าน request body
    final body = await _readBody(request);
    final file = body['file'] as String?;

    // Validate input
    if (file == null || file.isEmpty) {
      request.response.statusCode = 400;
      request.response.write(jsonEncode({'error': 'File path required'}));
      await request.response.close();
      return;
    }

    // ---------------------------------------------------------------------------
    // กรณีที่ 3: ตรวจสอบว่าไฟล์เป็นภาษา Dart หรือไม่
    // ---------------------------------------------------------------------------

    if (!file.endsWith('.dart')) {
      request.response.write(jsonEncode({
        'success': false,
        'resultType': 'not_dart',
        'error': 'The imported file is not a Dart file (.dart)',
      }));
      await request.response.close();
      return;
    }

    // ตรวจสอบเนื้อหาว่ามี Dart syntax พื้นฐาน (import/class/Widget)
    final dartFile = File(file);
    if (await dartFile.exists()) {
      final content = await dartFile.readAsString();
      final hasDartSyntax = content.contains('import ') ||
          content.contains('class ') ||
          content.contains('Widget');
      if (!hasDartSyntax) {
        request.response.write(jsonEncode({
          'success': false,
          'resultType': 'not_dart',
          'error': 'No valid Dart syntax found in file',
        }));
        await request.response.close();
        return;
      }
    }

    // ---------------------------------------------------------------------------
    // เรียก UiManifestExtractor โดยตรง (ไม่ spawn process)
    // ---------------------------------------------------------------------------

    try {
      final manifestPath = _extractor.extractManifest(file);
      int widgetCount = 0;

      // อ่าน manifest file เพื่อนับ widgets
      final manifestFile = File(manifestPath);
      if (await manifestFile.exists()) {
        try {
          final content = jsonDecode(await manifestFile.readAsString());
          widgetCount = (content['widgets'] as List?)?.length ?? 0;
        } catch (e) {
          // Ignore parse errors
        }
      }

      final hasWidgets = widgetCount > 0;

      // ---------------------------------------------------------------------------
      // กรณีที่ 1 (สำเร็จ) หรือ กรณีที่ 2 (ไม่พบ widgets)
      // ---------------------------------------------------------------------------

      request.response.write(jsonEncode({
        'success': true,
        'resultType': hasWidgets ? 'success' : 'no_widgets',
        'widgetCount': widgetCount,
        'hasWidgets': hasWidgets,
        'manifestPath': manifestPath,
        if (!hasWidgets)
          'warning': 'No supported widgets found in this file',
      }));
    } catch (e) {
      request.response.write(jsonEncode({
        'success': false,
        'resultType': 'not_dart',
        'error': e.toString(),
      }));
    }

    await request.response.close();
  }

  /// POST /extract-manifest - สร้าง UI manifest จาก Dart file
  ///
  /// Request body:
  ///   { "file": "lib/demos/page.dart" }
  ///
  /// Response:
  ///   { "success": true, "manifestPath": "...", "output": "..." }
  Future<void> handleExtractManifest(HttpRequest request) async {
    final body = await _readBody(request);
    final file = body['file'] as String?;

    // Validate input
    if (file == null) {
      request.response.statusCode = 400;
      request.response.write(jsonEncode({'error': 'File path required'}));
      await request.response.close();
      return;
    }

    // ---------------------------------------------------------------------------
    // เรียก UiManifestExtractor โดยตรง
    // ---------------------------------------------------------------------------

    try {
      final manifestPath = _extractor.extractManifest(file);

      request.response.write(jsonEncode({
        'success': true,
        'manifestPath': manifestPath,
      }));
    } catch (e) {
      request.response.write(jsonEncode({
        'success': false,
        'error': e.toString(),
      }));
    }

    await request.response.close();
  }

  /// POST /generate-datasets - สร้าง datasets ด้วย AI (Gemini)
  ///
  /// Request body:
  ///   { "manifest": "output/manifest/demos/page.manifest.json" }
  ///
  /// Response:
  ///   { "success": true, "datasetsPath": "...", "output": "..." }
  ///   หรือ { "success": true, "skipped": true } ถ้าไม่มี text fields
  Future<void> handleGenerateDatasets(HttpRequest request) async {
    final body = await _readBody(request);
    final manifest = body['manifest'] as String?;

    // Validate input
    if (manifest == null) {
      request.response.statusCode = 400;
      request.response.write(jsonEncode({'error': 'Manifest path required'}));
      await request.response.close();
      return;
    }

    // ---------------------------------------------------------------------------
    // เรียก DatasetGenerator โดยตรง
    // generateDatasets() returns null ถ้าไม่มี text fields (skipped)
    // ---------------------------------------------------------------------------

    try {
      final datasetsPath = await _datasetGenerator.generateDatasets(manifest);

      if (datasetsPath == null) {
        // ไม่มี text fields - skip datasets generation
        request.response.write(jsonEncode({
          'success': true,
          'skipped': true,
        }));
      } else {
        request.response.write(jsonEncode({
          'success': true,
          'datasetsPath': datasetsPath,
        }));
      }
    } catch (e) {
      request.response.write(jsonEncode({
        'success': false,
        'error': e.toString(),
      }));
    }

    await request.response.close();
  }

  /// POST /generate-test-data - สร้าง test plan ด้วย PICT
  ///
  /// Endpoint นี้รับ manifest file และสร้าง pairwise test combinations
  /// โดยใช้ PICT (Pairwise Independent Combinatorial Testing) tool
  ///
  /// สามารถกำหนด constraints เพิ่มเติมเพื่อ:
  /// - ไม่รวม invalid combinations (เช่น IF [A]="x" THEN [B]<>"y")
  /// - กำหนด dependencies ระหว่าง parameters
  /// - ลด test cases ที่ไม่จำเป็น
  ///
  /// Request body:
  ///   {
  ///     "manifest": "output/manifest/demos/page.manifest.json",
  ///     "constraints": "IF [x] = \"a\" THEN [y] <> \"b\";"  // optional - PICT constraints
  ///   }
  ///
  /// Response:
  ///   { "success": true, "testDataPath": "...", "output": "..." }
  ///
  /// PICT Constraint Syntax Examples:
  ///   IF [dropdown] = "option1" THEN [checkbox] <> "unchecked";
  ///   IF [textField] = "empty" THEN [submitButton] = "disabled";
  Future<void> handleGenerateTestData(HttpRequest request) async {
    // ---------------------------------------------------------------------------
    // อ่าน request body และ extract parameters
    // ---------------------------------------------------------------------------

    // อ่าน JSON body จาก request
    final body = await _readBody(request);

    // manifest: path ของ UI manifest file (required)
    final manifest = body['manifest'] as String?;

    // constraints: PICT constraints string (optional)
    // ใช้สำหรับกำหนดเงื่อนไขเพิ่มเติมในการสร้าง test combinations
    final constraints = body['constraints'] as String?;

    // ---------------------------------------------------------------------------
    // Validate input - ตรวจสอบว่ามี manifest path หรือไม่
    // ---------------------------------------------------------------------------

    if (manifest == null) {
      // ส่ง 400 Bad Request ถ้าไม่มี manifest
      request.response.statusCode = 400;
      request.response.write(jsonEncode({'error': 'Manifest path required'}));
      await request.response.close();
      return;
    }

    // ---------------------------------------------------------------------------
    // เรียก TestDataGenerator โดยตรง (ไม่ต้องสร้าง temp file)
    // ส่ง constraints string ตรงผ่าน parameter
    // ---------------------------------------------------------------------------

    try {
      final effectiveConstraints =
          (constraints != null && constraints.trim().isNotEmpty)
              ? constraints
              : null;

      if (effectiveConstraints != null) {
        print('Using custom PICT constraints');
      }

      final testDataPath = await _testDataGenerator.generateTestData(
        manifest,
        constraints: effectiveConstraints,
      );

      request.response.write(jsonEncode({
        'success': true,
        'testDataPath': testDataPath,
      }));
    } catch (e) {
      request.response.write(jsonEncode({
        'success': false,
        'error': e.toString(),
      }));
    }

    await request.response.close();
  }

  /// POST /generate-test-script - สร้าง Flutter test script
  ///
  /// Request body:
  ///   { "testData": "output/test_data/page.testdata.json" }
  ///
  /// Response:
  ///   { "success": true, "testScriptPath": "...", "output": "..." }
  Future<void> handleGenerateTestScript(HttpRequest request) async {
    final body = await _readBody(request);
    final testData = body['testData'] as String?;

    // Validate input
    if (testData == null) {
      request.response.statusCode = 400;
      request.response.write(jsonEncode({'error': 'Test data path required'}));
      await request.response.close();
      return;
    }

    // ---------------------------------------------------------------------------
    // เรียก TestScriptGenerator โดยตรง
    // ---------------------------------------------------------------------------

    try {
      final testScriptPath = _testScriptGenerator.generateTestScript(testData);

      // -----------------------------------------------------------------------
      // สร้าง summary จาก testdata.json
      // -----------------------------------------------------------------------
      Map<String, dynamic>? summary;
      try {
        final testDataFile = File(testData);
        if (testDataFile.existsSync()) {
          final testDataJson = jsonDecode(testDataFile.readAsStringSync())
              as Map<String, dynamic>;
          final cases = testDataJson['cases'] as List<dynamic>? ?? [];

          final groupCounts = <String, int>{};
          final caseDetails = <Map<String, dynamic>>[];

          for (final c in cases) {
            final caseMap = c as Map<String, dynamic>;
            final group = caseMap['group'] as String? ?? 'unknown';
            groupCounts[group] = (groupCounts[group] ?? 0) + 1;

            final steps = caseMap['steps'] as List<dynamic>? ?? [];
            final asserts = caseMap['asserts'] as List<dynamic>? ?? [];

            caseDetails.add({
              'tc': caseMap['tc'] ?? '',
              'kind': caseMap['kind'] ?? '',
              'group': group,
              'steps': steps.length,
              'asserts': asserts.length,
            });
          }

          final groups = groupCounts.entries
              .map((e) => {'name': e.key, 'count': e.value})
              .toList();

          summary = {
            'totalCases': cases.length,
            'groups': groups,
            'cases': caseDetails,
          };
        }
      } catch (_) {
        // ถ้า parse ไม่ได้ ก็ไม่ส่ง summary
      }

      request.response.write(jsonEncode({
        'success': true,
        'testScriptPath': testScriptPath,
        if (summary != null) 'summary': summary,
      }));
    } catch (e) {
      request.response.write(jsonEncode({
        'success': false,
        'error': e.toString(),
      }));
    }

    await request.response.close();
  }

// =============================================================================
// API HANDLERS - Test Execution
// =============================================================================

  /// POST /run-tests - รัน Flutter tests (optional with coverage)
  ///
  /// Request body:
  ///   {
  ///     "testScript": "test/page_flow_test.dart",
  ///     "withCoverage": true,
  ///     "useDevice": true  // true = integration test บน emulator
  ///   }
  ///
  /// Response:
  ///   { "success": true, "passed": 5, "failed": 0, "output": "...", "coverageHtmlPath": "..." }
  Future<void> handleRunTests(HttpRequest request) async {
    final body = await _readBody(request);
    final testScript = body['testScript'] as String?;
    final withCoverage = body['withCoverage'] as bool? ?? false;
    final useDevice = body['useDevice'] as bool? ?? false;

    // Validate input
    if (testScript == null) {
      request.response.statusCode = 400;
      request.response
          .write(jsonEncode({'error': 'Test script path required'}));
      await request.response.close();
      return;
    }

    // ---------------------------------------------------------------------------
    // Step 0: ลบ coverage folder เก่าออกก่อน เพื่อกันสับสนระหว่างผลเก่า/ใหม่
    // ---------------------------------------------------------------------------

    if (withCoverage) {
      final coverageDir = Directory('coverage');
      if (await coverageDir.exists()) {
        await coverageDir.delete(recursive: true);
        print('  ✓ Cleared old coverage data');
      }
    }

    // ---------------------------------------------------------------------------
    // Step 1: รัน flutter test
    // ---------------------------------------------------------------------------

    // สร้าง arguments สำหรับ flutter test command
    final args = ['test', testScript];
    if (withCoverage) {
      args.add('--coverage'); // เพิ่ม flag เพื่อสร้าง coverage data
    }

    // ---------------------------------------------------------------------------
    // Integration test: หา device/emulator ที่รันอยู่
    // ---------------------------------------------------------------------------

    String? deviceId;
    if (useDevice) {
      // รัน flutter devices เพื่อหา emulator
      final devicesResult =
          await Process.run('flutter', ['devices', '--machine']);
      if (devicesResult.exitCode == 0) {
        try {
          final devices = jsonDecode(devicesResult.stdout.toString()) as List;
          // หา emulator ก่อน ถ้าไม่มีค่อยใช้ device อื่น
          for (final device in devices) {
            if (device is Map) {
              final isEmulator = device['emulator'] == true;
              final isSupported = device['isSupported'] == true;
              final id = device['id'] as String?;
              // ข้าม web และ desktop devices
              final targetPlatform = device['targetPlatform'] as String? ?? '';
              final isMobile = targetPlatform.contains('android') ||
                  targetPlatform.contains('ios');

              if (isSupported && isMobile && id != null) {
                deviceId = id;
                if (isEmulator) break; // prefer emulator
              }
            }
          }
        } catch (e) {
          print('  ✗ Failed to parse devices: $e');
        }
      }

      if (deviceId != null) {
        args.addAll(['-d', deviceId]);
        print('  > Using device: $deviceId');
      } else {
        print('  ⚠ No mobile device/emulator found, running on VM');
      }
    }

    // Log command
    print('  > flutter ${args.join(' ')}');

    // รัน flutter test (ใช้ timeout นานขึ้นสำหรับ integration test)
    final timeout =
        useDevice ? 600 : 300; // 10 นาที สำหรับ device, 5 นาที สำหรับ VM
    final result = await Process.run(
      'flutter',
      args,
      workingDirectory: Directory.current.path,
    ).timeout(Duration(seconds: timeout), onTimeout: () {
      return ProcessResult(0, -1, '', 'Test timeout after $timeout seconds');
    });

    // ---------------------------------------------------------------------------
    // Parse test results จาก output
    // ---------------------------------------------------------------------------

    final output = result.stdout.toString();

    // ใช้ RegExp หาจำนวน tests ที่ passed และ failed
    // Pattern: "X tests passed" หรือ "X test passed"
    final passedMatch = RegExp(r'(\d+) tests? passed').firstMatch(output);
    final failedMatch = RegExp(r'(\d+) tests? failed').firstMatch(output);

    // ---------------------------------------------------------------------------
    // Parse test case names จาก output
    // Flutter test output format: "00:00 +N: Test Case Name"
    // หรือ "00:00 +N -M: Test Case Name" (เมื่อมี failures)
    // ---------------------------------------------------------------------------

    final testCases = <Map<String, dynamic>>[];

    // Pattern จับชื่อ test case จาก output
    // ตัวอย่าง: "00:01 +1: Case 1: Submit with valid data"
    // ไม่รวม "loading", "All tests passed" และบรรทัดสรุป
    final testCaseRegex = RegExp(
        r'^\d{2}:\d{2}\s+\+(\d+)(?:\s+-(\d+))?:\s+(.+)$',
        multiLine: true);

    for (final match in testCaseRegex.allMatches(output)) {
      final testName = match.group(3)?.trim() ?? '';

      // กรองออก: loading, All tests passed, Some tests failed, และบรรทัดที่ไม่ใช่ชื่อ test
      if (testName.isNotEmpty &&
          !testName.startsWith('loading') &&
          !testName.contains('All tests passed') &&
          !testName.contains('Some tests failed')) {
        // ตรวจสอบว่าเป็น test ที่ fail หรือไม่
        final failCount = match.group(2);
        final isFailed = failCount != null &&
            int.tryParse(failCount) != null &&
            int.parse(failCount) > 0;

        // หลีกเลี่ยงการเพิ่ม test ซ้ำ (เพราะ output แสดง test name หลายครั้ง)
        final exists = testCases.any((tc) => tc['name'] == testName);
        if (!exists) {
          testCases.add({
            'name': testName,
            'status': isFailed ? 'failed' : 'passed',
          });
        }
      }
    }

    // ---------------------------------------------------------------------------
    // Step 2: Generate HTML coverage report (ถ้า coverage enabled)
    // Generate แม้ test fail เพราะ coverage data ยังมีประโยชน์สำหรับ debug
    // ---------------------------------------------------------------------------

    String? coverageHtmlPath;
    String coverageOutput = '';

    if (withCoverage) {
      print('  > Waiting for coverage/lcov.info...');
      final lcovFile = File('coverage/lcov.info');

      // -------------------------------------------------------------------------
      // Retry loop: รอให้ lcov.info ถูกสร้างและมี content
      // บางครั้ง flutter test เสร็จแล้วแต่ไฟล์ยังเขียนไม่เสร็จ
      // -------------------------------------------------------------------------

      int retries = 0;
      const maxRetries = 10; // ลองสูงสุด 10 ครั้ง
      const retryDelay = Duration(milliseconds: 500); // รอ 500ms ต่อครั้ง
      bool lcovReady = false;

      while (retries < maxRetries) {
        if (await lcovFile.exists()) {
          final content = await lcovFile.readAsString();
          if (content.isNotEmpty) {
            lcovReady = true;
            break; // lcov.info พร้อมแล้ว
          }
        }
        // รอแล้วลองใหม่
        await Future.delayed(retryDelay);
        retries++;
        print('  ... waiting for lcov.info ($retries/$maxRetries)');
      }

      // ตรวจสอบว่า lcov.info พร้อมหรือไม่
      if (lcovReady) {
        print('  ✓ Found lcov.info');

        // -------------------------------------------------------------------------
        // กรอง cubit/state files ออก เพื่อให้ coverage focus เฉพาะ UI layer
        // ใช้ lcov --remove เพื่อตัด files ที่อยู่ใน */cubit/* ออก
        // -------------------------------------------------------------------------

        print(
            '  > lcov --remove coverage/lcov.info */cubit/* -o coverage/lcov_ui_only.info');
        final lcovFilterResult = await Process.run(
          'lcov',
          [
            '--remove',
            'coverage/lcov.info',
            '*/cubit/*',
            '-o',
            'coverage/lcov_ui_only.info'
          ],
        );

        // เลือกใช้ไฟล์ที่กรองแล้ว ถ้า filter สำเร็จ หรือ fallback ใช้ไฟล์เดิม
        final lcovForHtml = lcovFilterResult.exitCode == 0
            ? 'coverage/lcov_ui_only.info'
            : 'coverage/lcov.info';

        if (lcovFilterResult.exitCode == 0) {
          print('  ✓ Filtered cubit files from coverage (UI-only)');
        } else {
          print('  ⚠ lcov filter failed, using unfiltered coverage');
        }

        // -------------------------------------------------------------------------
        // รัน genhtml เพื่อแปลง lcov.info เป็น HTML report
        // genhtml เป็น tool จาก lcov package
        // -------------------------------------------------------------------------

        print('  > genhtml $lcovForHtml -o coverage/html');
        final genHtmlResult = await Process.run(
          'genhtml',
          [lcovForHtml, '-o', 'coverage/html'],
        );

        if (genHtmlResult.exitCode == 0) {
          coverageHtmlPath = 'coverage/html/index.html';
          coverageOutput = genHtmlResult.stdout.toString();

          // แสดง warning ถ้า test failed
          if (result.exitCode != 0) {
            print('  ⚠ Coverage HTML generated (but some tests failed)');
          } else {
            print('  ✓ Coverage HTML generated: $coverageHtmlPath');
          }

          // -----------------------------------------------------------------------
          // Step 3: เปิด coverage report ใน browser ผ่าน server URL
          // ใช้ server URL แทน local file เพื่อให้ CSS/JS ทำงานถูกต้อง
          // -----------------------------------------------------------------------

          const coverageUrl = 'http://localhost:8080/coverage/index.html';
          print('  > open $coverageUrl');
          if (Platform.isMacOS) {
            // macOS: ใช้ 'open' command
            await Process.run('open', [coverageUrl]);
          } else if (Platform.isWindows) {
            // Windows: ใช้ 'start' command (ต้อง runInShell)
            await Process.run('start', [coverageUrl], runInShell: true);
          } else if (Platform.isLinux) {
            // Linux: ใช้ 'xdg-open' command
            await Process.run('xdg-open', [coverageUrl]);
          }
          print('  ✓ Opened coverage report in browser');
        } else {
          // genhtml failed
          coverageOutput = 'genhtml failed: ${genHtmlResult.stderr}';
          print('  ✗ genhtml failed: ${genHtmlResult.stderr}');
        }
      } else {
        print('  ✗ lcov.info not found or empty after $maxRetries retries');
        coverageOutput = 'Coverage file not ready after waiting';
      }
    }

    // ---------------------------------------------------------------------------
    // ส่ง response
    // ---------------------------------------------------------------------------

    request.response.write(jsonEncode({
      'success': result.exitCode == 0,
      'passed': passedMatch != null ? int.parse(passedMatch.group(1)!) : 0,
      'failed': failedMatch != null ? int.parse(failedMatch.group(1)!) : 0,
      'testCases': testCases,
      'totalTests': testCases.length,
      'output': output,
      'error': result.stderr.toString(),
      'coverageHtmlPath': coverageHtmlPath,
      'coverageOutput': coverageOutput,
    }));

    await request.response.close();
  }

  /// POST /generate-all - รัน full test generation pipeline
  ///
  /// Request body:
  ///   { "skipDatasets": false }
  ///
  /// Response:
  ///   { "success": true, "filesProcessed": 5, "testsGenerated": 5 }
  Future<void> handleGenerateAll(HttpRequest request) async {
    final body = await _readBody(request);
    final skipDatasets = body['skipDatasets'] as bool? ?? false;

    int filesProcessed = 0;
    int testsGenerated = 0;

    // ---------------------------------------------------------------------------
    // Step 1: Extract all manifests (วนลูป specific file แทน batch mode)
    // ---------------------------------------------------------------------------

    // หา page files ทั้งหมดใน lib/
    final libDir = Directory('lib');
    final pageFiles = <String>[];
    if (await libDir.exists()) {
      await for (final entity in libDir.list(recursive: true)) {
        if (entity is File &&
            (entity.path.endsWith('_page.dart') ||
                entity.path.endsWith('.page.dart'))) {
          pageFiles.add(entity.path);
        }
      }
    }

    // วนลูป extract manifest ทีละไฟล์
    for (final pageFile in pageFiles) {
      try {
        _extractor.extractManifest(pageFile);
      } catch (e) {
        request.response.write(jsonEncode({
          'success': false,
          'error': 'Failed to extract manifest for: $pageFile — $e',
        }));
        await request.response.close();
        return;
      }
    }

    // ---------------------------------------------------------------------------
    // หา manifest files ทั้งหมด (ใช้ใน Step 2 และ Step 3)
    // ---------------------------------------------------------------------------

    final manifestDir = Directory('output/manifest');
    final manifestFiles = <String>[];
    if (await manifestDir.exists()) {
      await for (final entity in manifestDir.list(recursive: true)) {
        if (entity is File && entity.path.endsWith('.manifest.json')) {
          manifestFiles.add(entity.path);
        }
      }
    }

    // ---------------------------------------------------------------------------
    // Step 2: Generate datasets (วนลูป specific file แทน batch mode)
    // ---------------------------------------------------------------------------

    if (!skipDatasets) {
      for (final manifestPath in manifestFiles) {
        try {
          await _datasetGenerator.generateDatasets(manifestPath);
        } catch (e) {
          // ไม่ fail pipeline เพราะ datasets เป็น optional
          print('  ⚠ Datasets skipped for $manifestPath: $e');
        }
      }
    }

    // ---------------------------------------------------------------------------
    // Step 3: Generate test data (วนลูป specific file แทน batch mode)
    // ---------------------------------------------------------------------------

    for (final manifestPath in manifestFiles) {
      try {
        await _testDataGenerator.generateTestData(manifestPath);
      } catch (e) {
        request.response.write(jsonEncode({
          'success': false,
          'error': 'Failed to generate test data for: $manifestPath — $e',
        }));
        await request.response.close();
        return;
      }
    }

    // ---------------------------------------------------------------------------
    // Step 4: Generate test scripts (วนลูป specific file แทน batch mode)
    // ---------------------------------------------------------------------------

    // หา testdata files ทั้งหมด
    final testDataDir = Directory('output/test_data');
    final testDataFiles = <String>[];
    if (await testDataDir.exists()) {
      await for (final entity in testDataDir.list()) {
        if (entity is File && entity.path.endsWith('.testdata.json')) {
          testDataFiles.add(entity.path);
        }
      }
    }

    // วนลูป generate test script ทีละไฟล์
    for (final testDataPath in testDataFiles) {
      try {
        _testScriptGenerator.generateTestScript(testDataPath);
      } catch (e) {
        // ไม่ fail pipeline เพราะบางไฟล์อาจไม่มี test cases
        print('  ⚠ Test script skipped for $testDataPath: $e');
      }
    }

    // ---------------------------------------------------------------------------
    // นับจำนวนไฟล์ที่ประมวลผล
    // ---------------------------------------------------------------------------

    filesProcessed = manifestFiles.length;

    // นับ test scripts ที่สร้าง
    final testDir = Directory('test');
    if (await testDir.exists()) {
      await for (final entity in testDir.list()) {
        if (entity is File && entity.path.endsWith('_flow_test.dart')) {
          testsGenerated++;
        }
      }
    }

    // ส่ง response
    request.response.write(jsonEncode({
      'success': true,
      'filesProcessed': filesProcessed,
      'testsGenerated': testsGenerated,
    }));

    await request.response.close();
  }

// =============================================================================
// API HANDLERS - Coverage Operations
// =============================================================================

  /// POST /open-coverage - เปิด coverage report หรือ folder
  ///
  /// Request body:
  ///   { "action": "view" } - เปิดใน browser
  ///   { "action": "folder" } - เปิด folder ใน file explorer
  ///
  /// Response:
  ///   { "success": true, "url": "..." }
  Future<void> handleOpenCoverage(HttpRequest request) async {
    final body = await _readBody(request);
    final action = body['action'] as String? ?? 'view';

    // ตรวจสอบว่า coverage report มีอยู่หรือไม่
    final coveragePath = 'coverage/html/index.html';
    final coverageFile = File(coveragePath);

    if (!await coverageFile.exists()) {
      request.response.write(jsonEncode({
        'success': false,
        'error': 'Coverage report not found. Run coverage test first.',
      }));
      await request.response.close();
      return;
    }

    // ---------------------------------------------------------------------------
    // Handle action
    // ---------------------------------------------------------------------------

    if (action == 'folder') {
      // เปิด coverage folder ใน file explorer
      final coverageDir = Directory('coverage/html').absolute.path;

      if (Platform.isMacOS) {
        await Process.run('open', [coverageDir]);
      } else if (Platform.isWindows) {
        await Process.run('explorer', [coverageDir]);
      } else if (Platform.isLinux) {
        await Process.run('xdg-open', [coverageDir]);
      }

      request.response.write(jsonEncode({'success': true}));
    } else {
      // Return URL สำหรับเปิดใน browser
      request.response.write(jsonEncode({
        'success': true,
        'url': 'http://localhost:8080/coverage/index.html',
        'path': coveragePath,
      }));
    }

    await request.response.close();
  }

// =============================================================================
// STATIC FILE SERVING
// =============================================================================

  /// Serve coverage HTML files
  ///
  /// Maps /coverage/* to coverage/html/*
  /// เช่น /coverage/index.html -> coverage/html/index.html
  Future<void> serveCoverageFile(HttpRequest request) async {
    var path = request.uri.path;

    // แปลง URL path เป็น file path
    // /coverage/index.html -> coverage/html/index.html
    final filePath = path.replaceFirst('/coverage/', 'coverage/html/');

    final file = File(filePath);
    if (await file.exists()) {
      // ---------------------------------------------------------------------------
      // กำหนด Content-Type ตาม file extension
      // ---------------------------------------------------------------------------

      final ext = path.split('.').last;
      final contentType = switch (ext) {
        'html' => ContentType.html, // text/html
        'css' => ContentType('text', 'css'), // text/css
        'js' =>
          ContentType('application', 'javascript'), // application/javascript
        'png' => ContentType('image', 'png'), // image/png
        'gif' => ContentType('image', 'gif'), // image/gif
        'svg' => ContentType('image', 'svg+xml'), // image/svg+xml
        _ => ContentType.binary, // application/octet-stream
      };

      request.response.headers.contentType = contentType;

      // Stream file content ไปยัง response
      // pipe() จะอ่าน file และเขียน response efficiently
      await file.openRead().pipe(request.response);
    } else {
      // File not found
      request.response.statusCode = 404;
      request.response.write('Coverage file not found: $filePath');
      await request.response.close();
    }
  }

  /// Serve static files (HTML, CSS, JS) สำหรับ Web UI
  ///
  /// Files ถูก serve จาก webview/ directory
  /// เช่น /index.html -> webview/index.html
  Future<void> serveStaticFile(HttpRequest request) async {
    var path = request.uri.path;

    // Default path '/' ไปยัง '/index.html'
    if (path == '/') path = '/index.html';

    // สร้าง file path (webview/ prefix)
    final file = File('webview$path');

    if (await file.exists()) {
      // ---------------------------------------------------------------------------
      // กำหนด Content-Type ตาม file extension
      // ---------------------------------------------------------------------------

      final ext = path.split('.').last;
      final contentType = switch (ext) {
        'html' => ContentType.html, // text/html
        'css' => ContentType('text', 'css'), // text/css
        'js' =>
          ContentType('application', 'javascript'), // application/javascript
        _ => ContentType.binary, // application/octet-stream
      };

      request.response.headers.contentType = contentType;

      // Stream file content
      await file.openRead().pipe(request.response);
    } else {
      // File not found
      request.response.statusCode = 404;
      request.response.write('Not found: $path');
      await request.response.close();
    }
  }

// =============================================================================
// UTILITY FUNCTIONS
// =============================================================================

  /// อ่าน JSON body จาก POST request
  ///
  /// Parameter:
  ///   [request] - HttpRequest object
  ///
  /// Returns:
  ///   Map<String, dynamic> - parsed JSON body หรือ empty map ถ้า error
  Future<Map<String, dynamic>> _readBody(HttpRequest request) async {
    // เฉพาะ POST requests เท่านั้นที่มี body
    if (request.method != 'POST') return {};

    try {
      // อ่าน request body และ decode เป็น UTF-8
      // utf8.decoder.bind() สร้าง stream transformer
      // join() รวม chunks เป็น single string
      final content = await utf8.decoder.bind(request).join();

      // Return empty map ถ้า content ว่าง
      if (content.isEmpty) return {};

      // Parse JSON string เป็น Map
      return jsonDecode(content) as Map<String, dynamic>;
    } catch (e) {
      // Return empty map ถ้า parse error
      return {};
    }
  }
} // end of PipelineController
