// =============================================================================
// generate_test_script.dart
// =============================================================================
// Script สำหรับสร้าง Flutter integration test จาก test plan JSON
// ใช้ข้อมูลจาก generate_test_data.dart เพื่อสร้าง test script ที่รันได้จริง
//
// วิธีใช้งาน:
//   Single file mode:
//     dart run tools/script_v2/generate_test_script.dart output/test_data/page.testdata.json
//
//   Batch mode (ประมวลผลทุกไฟล์):
//     dart run tools/script_v2/generate_test_script.dart
//
// Input:
//   - output/test_data/<page>.testdata.json (จาก generate_test_data.dart)
//   - output/test_data/<page>.datasets.json (optional, จาก generate_datasets.dart)
//
// Output:
//   - test/<page>_flow_test.dart
//
// Features:
//   - สร้าง integration tests สำหรับ Flutter
//   - รองรับ BLoC/Cubit pattern
//   - สร้าง stub classes สำหรับ success/failure cases
//   - รองรับ DatePicker และ TimePicker
//   - รองรับ pairwise test cases
// =============================================================================

// -----------------------------------------------------------------------------
// Import Libraries
// -----------------------------------------------------------------------------

// dart:convert - สำหรับ JSON encoding/decoding
// - jsonDecode() : แปลง JSON string เป็น Map/List
import 'dart:convert';

// dart:io - สำหรับ file I/O operations
// - File       : อ่าน/เขียนไฟล์
// - Directory  : จัดการ folders
// - stdout     : เขียน output
// - stderr     : เขียน error
// - exit()     : จบ process
import 'dart:io';

// utils.dart - utility functions ที่ใช้ร่วมกับ scripts อื่น
// - basenameWithoutExtension() : ดึงชื่อไฟล์โดยไม่มี extension
// - basename()                 : ดึงชื่อไฟล์
// - readPackageName()          : อ่านชื่อ package จาก pubspec.yaml
// - pkgImport()                : สร้าง import path แบบ package:
// - findDeclFile()             : หาไฟล์ที่มี class declaration
// - dartEscape()               : escape string สำหรับ Dart code
import 'utils.dart' as utils;

// =============================================================================
// PUBLIC API FUNCTION
// =============================================================================

/// Function สาธารณะสำหรับเรียกใช้จาก script อื่น (เช่น flutter_test_generator.dart)
///
/// สร้าง Flutter test script จาก test data file
///
/// Parameter:
///   [testDataPath] - path ของไฟล์ .testdata.json
///                    เช่น "output/test_data/login_page.testdata.json"
///
/// Returns:
///   String - path ของ integration test file ที่สร้าง
///            เช่น "test/login_page_flow_test.dart"
///
/// Example:
///   final outputPath = generateTestScriptFromTestData(
///     'output/test_data/login_page.testdata.json'
///   );
///   print('Generated: $outputPath');
String generateTestScriptFromTestData(String testDataPath) {
  // เรียก function หลักในการประมวลผล
  _processOne(testDataPath);

  // คำนวณ output path จาก input path
  // Step 1: ลบ prefix 'output/test_data/' ออก
  // Step 2: ลบ suffix '.testdata.json' ออก (ใช้ RegExp)
  // Step 3: เพิ่ม prefix 'integration_test/' และ suffix '_flow_test.dart'
  //
  // ตัวอย่าง:
  //   Input:  output/test_data/login_page.testdata.json
  //   Step 1: login_page.testdata.json
  //   Step 2: login_page
  //   Output: test/login_page_flow_test.dart
  final base = testDataPath
      .replaceAll('output/test_data/', '')
      .replaceAll(RegExp(r'\.testdata\.json$'), '');

  return 'integration_test/${base}_flow_test.dart';
}

// =============================================================================
// MAIN FUNCTION - Entry Point
// =============================================================================

/// Entry point ของ script เมื่อรันจาก command line
///
/// Parameter:
///   [args] - List ของ command line arguments
///            ต้องระบุ testdata file อย่างน้อย 1 ไฟล์
void main(List<String> args) {
  // ---------------------------------------------------------------------------
  // Validate: ต้องระบุ testdata file
  // ---------------------------------------------------------------------------
  if (args.isEmpty) {
    stderr.writeln('Error: No testdata file specified');
    stderr.writeln('Usage: dart run tools/script_v2/generate_test_script.dart <testdata.json>');
    stderr.writeln('Example: dart run tools/script_v2/generate_test_script.dart output/test_data/buttons_page.testdata.json');
    exit(1);
  }

  // ---------------------------------------------------------------------------
  // วนลูปประมวลผลแต่ละไฟล์
  // ---------------------------------------------------------------------------
  for (final path in args) {
    try {
      _processOne(path);
    } catch (e, st) {
      stderr.writeln('! Failed to process $path: $e\n$st');
    }
  }
}

// =============================================================================
// PROCESS ONE FILE - ฟังก์ชันหลักในการประมวลผล
// =============================================================================

/// ประมวลผลไฟล์ test data หนึ่งไฟล์และสร้าง test script
///
/// Parameter:
///   [planPath] - path ของไฟล์ .testdata.json
///
/// การทำงาน:
///   1. อ่านและ parse test data JSON
///   2. ดึงข้อมูล source (UI file, classes)
///   3. โหลด datasets (embedded หรือ external)
///   4. สร้าง stub classes สำหรับ Cubit
///   5. สร้าง test cases ตาม groups
///   6. เขียน integration test file
void _processOne(String planPath) {
  // ---------------------------------------------------------------------------
  // STEP 1: อ่านและ parse ไฟล์ test data
  // ---------------------------------------------------------------------------

  // อ่านเนื้อหาทั้งไฟล์เป็น string
  final raw = File(planPath).readAsStringSync();

  // แปลง JSON string เป็น Map
  final j = jsonDecode(raw) as Map<String, dynamic>;

  // ---------------------------------------------------------------------------
  // STEP 2: ดึงข้อมูลจาก source section
  // source section มีข้อมูลเกี่ยวกับ UI file ต้นทาง
  // ---------------------------------------------------------------------------

  // ดึง source map (ถ้าไม่มีใช้ empty map)
  final source = (j['source'] as Map<String, dynamic>?) ?? const {};

  // ดึง path ของ UI file
  // ใช้เป็น reference และสำหรับ import
  final uiFile = (source['file'] as String?) ?? 'lib/unknown.dart';

  // ดึงชื่อ page class (widget class หลักของหน้า)
  // ถ้าไม่ระบุ ใช้ชื่อไฟล์แทน
  final pageClass = (source['pageClass'] as String?) ??
      utils.basenameWithoutExtension(uiFile);

  // ดึงชื่อ Cubit class (state management)
  final cubitClass = (source['cubitClass'] as String?);

  // ดึงชื่อ State class (ใช้สำหรับ import)
  final stateClass = (source['stateClass'] as String?);

  // ---------------------------------------------------------------------------
  // STEP 3: สร้าง providers list จาก cubitClass
  // ---------------------------------------------------------------------------

  // ถ้ามี cubitClass ให้สร้าง list ของ providers
  // ใช้สำหรับ wrap widget ด้วย BlocProvider
  final providers = cubitClass != null
      ? [{'type': cubitClass}]
      : <Map<String, dynamic>>[];

  // ดึง list ของ test cases
  final cases = (j['cases'] as List? ?? const []).cast<Map<String, dynamic>>();

  // ---------------------------------------------------------------------------
  // STEP 4: ดึง validation counts จาก test plan
  // ใช้สำหรับกำหนดจำนวน widgets ที่คาดหวังใน assertions
  // ---------------------------------------------------------------------------

  final validationCounts = _extractValidationCountsFromPlan(cases);

  // ---------------------------------------------------------------------------
  // STEP 5: โหลด datasets (external หรือ embedded)
  // ---------------------------------------------------------------------------

  /// Function ภายในสำหรับโหลด datasets จากไฟล์ external
  /// ถ้ามีไฟล์ .datasets.json จะใช้แทน embedded datasets
  Map<String, dynamic> _maybeLoadExternalDatasets(String uiFile) {
    try {
      // สร้าง path ของ datasets file
      final base = utils.basenameWithoutExtension(uiFile);
      final f = File('output/test_data/' + base + '.datasets.json');

      // ตรวจสอบว่าไฟล์มีอยู่หรือไม่
      if (f.existsSync()) {
        // อ่านและ parse JSON
        final ext = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
        final extDs = (ext['datasets'] as Map?)?.cast<String, dynamic>();

        // ตรวจสอบว่ามี datasets หรือไม่
        if (extDs != null && extDs.isNotEmpty) {
          // เก็บ format ใหม่ (array-based) สำหรับ path resolution
          // format: byKey.field[0].invalid
          return extDs;
        }
      }
    } catch (_) {
      // ignore errors - จะ fallback ไปใช้ embedded
    }
    return const {}; // return empty map ถ้าโหลดไม่ได้
  }

  // ตัวแปรเก็บ datasets ที่จะใช้
  Map<String, dynamic> datasets;

  // ลองโหลด external datasets ก่อน
  final extFirst = _maybeLoadExternalDatasets(uiFile);

  if (extFirst.isNotEmpty) {
    // ใช้ external datasets
    datasets = extFirst;
  } else {
    // ใช้ embedded datasets จาก test data file
    // ไม่ convert format - ใช้ original array structure
    datasets = (j['datasets'] as Map? ?? const {}).cast<String, dynamic>();
  }

  // ---------------------------------------------------------------------------
  // STEP 6: อ่านชื่อ package จาก pubspec.yaml
  // ---------------------------------------------------------------------------

  final pkg = utils.readPackageName() ?? 'master_project';

  // ---------------------------------------------------------------------------
  // STEP 7: Normalize UI file path
  // แปลง absolute path เป็น relative path ถ้าจำเป็น
  // ---------------------------------------------------------------------------

  String normalizedUiFile = uiFile;

  // ตรวจสอบว่าเป็น absolute path หรือไม่
  if (uiFile.contains('/lib/')) {
    // แยก path หลัง /lib/
    // /Users/xxx/project/lib/widgets/file.dart -> lib/widgets/file.dart
    normalizedUiFile = 'lib/' + uiFile.split('/lib/').last;
  }

  // สร้าง import statement สำหรับ UI file
  // แปลงเป็น format: package:pkg/path/file.dart
  final uiImport = utils.pkgImport(pkg, normalizedUiFile);

  // ---------------------------------------------------------------------------
  // STEP 8: หา provider type files สำหรับ import
  // ---------------------------------------------------------------------------

  // ดึง list ของ provider types (เช่น RegisterCubit, LoginCubit)
  final providerTypes = <String>[];
  for (final p in providers) {
    final t = (p['type'] ?? '').toString();
    if (t.isNotEmpty) providerTypes.add(t);
  }

  // หาไฟล์ที่มี class declaration ของแต่ละ provider
  // ใช้ RegExp หา pattern: class XxxCubit
  final providerFiles = <String>[];
  for (final t in providerTypes) {
    // หาไฟล์ที่มี class declaration และลงท้ายด้วย _cubit.dart
    final f = utils.findDeclFile(
      RegExp(r'class\s+' + RegExp.escape(t) + r'\b'),
      endsWith: '_cubit.dart',
    );
    if (f != null) providerFiles.add(f);
  }

  // ---------------------------------------------------------------------------
  // STEP 9: กำหนด primary Cubit type
  // ใช้สำหรับสร้าง stub classes
  // ---------------------------------------------------------------------------

  final primaryCubitType = _getPrimaryCubitType(providerTypes);

  // ---------------------------------------------------------------------------
  // STEP 10: สร้าง sample values map
  // ดึงค่า valid ตัวแรกของแต่ละ field สำหรับใช้เป็น fallback
  // ---------------------------------------------------------------------------

  final sampleByKey = <String, String>{};

  // ตรวจสอบว่ามี byKey ใน datasets หรือไม่
  if (datasets.containsKey('byKey') && datasets['byKey'] is Map) {
    final byKey = (datasets['byKey'] as Map).cast<String, dynamic>();

    // วนลูปแต่ละ field
    byKey.forEach((k, v) {
      try {
        // Handle format ใหม่: array of objects [{valid, invalid}, ...]
        if (v is List && v.isNotEmpty && v.first is Map) {
          final first = v.first as Map;
          if (first.containsKey('valid') && first['valid'] is String) {
            sampleByKey[k] = first['valid'] as String;
          }
        }
        // Handle format เก่า: Map {valid: [...], invalid: [...]}
        else if (v is Map) {
          final valid = v['valid'];
          if (valid is List && valid.isNotEmpty && valid.first is String) {
            sampleByKey[k] = valid.first as String;
          } else if (valid is String) {
            sampleByKey[k] = valid;
          }
        }
      } catch (_) {
        // ignore errors
      }
    });
  }

  // ---------------------------------------------------------------------------
  // STEP 11: เริ่มสร้าง test code
  // ใช้ StringBuffer เพื่อ build code efficiently
  // ---------------------------------------------------------------------------

  final b = StringBuffer()
    // Comment header
    ..writeln('// GENERATED — from test plan')
    // Import Flutter framework
    ..writeln("import 'package:flutter/material.dart';")
    // Import Flutter test framework
    ..writeln("import 'package:flutter_test/flutter_test.dart';");

  // Import dart:io สำหรับ network operations ใน tests
  b.writeln("import 'dart:io';");

  // ---------------------------------------------------------------------------
  // STEP 12: เพิ่ม import statements สำหรับ providers
  // ---------------------------------------------------------------------------

  // Import flutter_bloc ถ้ามี providers
  if (providerFiles.isNotEmpty) {
    b.writeln("import 'package:flutter_bloc/flutter_bloc.dart';");
  }

  // Import แต่ละ provider file (cubit files)
  for (final f in providerFiles) {
    b.writeln("import '${utils.pkgImport(pkg, f)}';");
  }

  // Import state file สำหรับ ApiResponse class
  if (primaryCubitType != null) {
    final stateFilePath = _getStateFilePathFromCubit(primaryCubitType);
    b.writeln("import '${utils.pkgImport(pkg, stateFilePath)}';");
  }

  // Import UI file
  b.writeln("import '$uiImport';");

  // ---------------------------------------------------------------------------
  // STEP 13: สร้าง Stub Classes สำหรับ Cubit
  // Stub classes ใช้สำหรับ mock behavior ใน tests
  // ---------------------------------------------------------------------------

  if (primaryCubitType != null) {
    // -------------------------------------------------------------------------
    // Success Stub: emit ApiResponse สำเร็จ
    // -------------------------------------------------------------------------
    b
      ..writeln('')
      // ประกาศ class ที่ extend จาก primary Cubit
      ..writeln('class _Success$primaryCubitType extends $primaryCubitType {')
      // Property เก็บ stub response (optional)
      ..writeln('  final ApiResponse? stubResp;')
      // Constructor รับ stubResp และส่งต่อ shouldSucceed: true ไปยัง parent
      ..writeln(
          '  _Success$primaryCubitType({this.stubResp}) : super(shouldSucceed: true);')
      // Override onEndButton method
      ..writeln('  @override')
      ..writeln('  Future<void> onEndButton() async {')
      // ใช้ stubResp ถ้ามี ไม่งั้นใช้ default response
      ..writeln(
          '    final resp = stubResp ?? const ApiResponse(message: \"ok\", code: 200);')
      // emit state ใหม่ที่มี response และไม่มี exception
      ..writeln('    emit(state.copyWith(response: resp, exception: null));')
      ..writeln('  }')
      // Override callApi method (ทำเหมือน onEndButton)
      ..writeln('  @override')
      ..writeln('  Future<void> callApi() async {')
      ..writeln(
          '    final resp = stubResp ?? const ApiResponse(message: \"ok\", code: 200);')
      ..writeln('    emit(state.copyWith(response: resp, exception: null));')
      ..writeln('  }')
      ..writeln('}');

    // -------------------------------------------------------------------------
    // Failure Stub: emit Exception
    // -------------------------------------------------------------------------
    b
      ..writeln('')
      // ประกาศ class ที่ extend จาก primary Cubit
      ..writeln('class _Fail$primaryCubitType extends $primaryCubitType {')
      // Property เก็บ error code
      ..writeln('  final int code;')
      // Constructor รับ code และส่งต่อ shouldSucceed: false ไปยัง parent
      ..writeln(
          '  _Fail$primaryCubitType(this.code) : super(shouldSucceed: false);')
      // Override callApi method
      ..writeln('  @override')
      ..writeln('  Future<void> callApi() async {')
      // emit state ที่มี exception พร้อม code ที่กำหนด
      ..writeln(
          '    emit(state.copyWith(exception: RegisterException(message: \"api_failed\", code: code)));')
      ..writeln('  }')
      // Override onEndButton method (ทำเหมือน callApi)
      ..writeln('  @override')
      ..writeln('  Future<void> onEndButton() async {')
      ..writeln(
          '    emit(state.copyWith(exception: RegisterException(message: \"api_failed\", code: code)));')
      ..writeln('  }')
      ..writeln('}');
  }

  // ---------------------------------------------------------------------------
  // STEP 14: สร้าง _wrap helper function
  // Function สำหรับ wrap widget ด้วย MaterialApp และ BlocProviders
  // ---------------------------------------------------------------------------

  b
    ..writeln('')
    // ประกาศ function _wrap
    // Parameters:
    //   child    - widget ที่จะ wrap
    //   success  - true = ใช้ success stub, false = ใช้ failure stub
    //   response - custom response สำหรับ success case (optional)
    //   failureCode - error code สำหรับ failure case (optional)
    ..writeln(
        'Widget _wrap(Widget child, {required bool success, Map<String, dynamic>? response, int? failureCode}) {')
    // สร้าง list เก็บ BlocProviders
    ..writeln('  final providers = <BlocProvider>[];');

  // วนลูปสร้าง BlocProvider สำหรับแต่ละ type
  for (final t in providerTypes) {
    if (t == primaryCubitType) {
      // Primary Cubit: ใช้ stub ตาม success flag
      // ถ้า success = true: ใช้ _Success stub พร้อม optional response
      // ถ้า success = false: ใช้ _Fail stub ถ้ามี failureCode, ไม่งั้นใช้ real Cubit
      b.writeln(
          "  providers.add(BlocProvider<$t>(create: (_)=> success ? _Success$t(stubResp: response!=null ? ApiResponse.fromJson(response) : null) : (failureCode!=null ? _Fail$t(failureCode) : $t())));");
    } else {
      // Non-primary Cubits: ใช้ real implementation เสมอ
      b.writeln("  providers.add(BlocProvider<$t>(create: (_)=> $t()));");
    }
  }

  // Return MaterialApp ที่ wrap ด้วย MultiBlocProvider
  b
    ..writeln(
        '  return MaterialApp(home: MultiBlocProvider(providers: providers, child: child));')
    ..writeln('}');

  // ---------------------------------------------------------------------------
  // STEP 15: จัดกลุ่ม test cases ตาม 'group' field
  // ---------------------------------------------------------------------------

  // Map เก็บ cases แยกตาม group name
  Map<String, List<Map<String, dynamic>>> groupsByName = {};

  for (final c in cases) {
    // ดึง group name (default = 'Other')
    final groupName = (c['group'] ?? 'Other').toString();
    // เพิ่ม case ลง group (สร้าง list ใหม่ถ้ายังไม่มี)
    groupsByName.putIfAbsent(groupName, () => []).add(c);
  }

  // สร้าง ordered list ของ groups (เรียงตามลำดับที่ปรากฏใน cases)
  List<(String, List<Map<String, dynamic>>)> orderedGroups = [];
  final seenGroups = <String>{}; // Set เก็บ groups ที่เห็นแล้ว

  for (final c in cases) {
    final groupName = (c['group'] ?? 'Other').toString();
    // ถ้ายังไม่เคยเห็น group นี้
    if (!seenGroups.contains(groupName)) {
      seenGroups.add(groupName);
      // เพิ่ม tuple (groupName, cases) ลง list
      orderedGroups.add((groupName, groupsByName[groupName]!));
    }
  }

  // ---------------------------------------------------------------------------
  // STEP 16: สร้าง test code structure
  // ---------------------------------------------------------------------------

  b.writeln('');
  // void main() function
  b.writeln('void main() {');
  // Group หลักใช้ชื่อ UI file
  b.writeln("  group('${utils.basename(uiFile)} flow', () {");

  // ---------------------------------------------------------------------------
  // STEP 17: วนลูปสร้าง test groups และ test cases
  // ---------------------------------------------------------------------------

  for (final entry in orderedGroups) {
    // ดึง group name และ cases
    final groupName = entry.$1;
    final group = entry.$2;

    // ข้าม groups ว่าง
    if (group.isEmpty) continue;

    // เปิด group
    b.writeln("    group('$groupName', () {");

    // วนลูปแต่ละ test case ใน group
    for (final c in group) {
      // ดึงข้อมูล test case
      final id = (c['tc'] ?? 'case').toString(); // test case ID
      final kind = (c['kind'] ?? '').toString(); // test case type
      final setup = (c['setup'] as Map? ?? const {}); // setup configuration

      // กำหนดว่าใช้ success stub หรือไม่
      // true ถ้า cubitStub == 'success' หรือ kind == 'success'
      bool successStub =
          (setup['cubitStub'] ?? '').toString() == 'success' ||
              kind == 'success';

      // ดึง steps และ asserts
      final steps =
          (c['steps'] as List? ?? const []).cast<Map<String, dynamic>>();
      final asserts =
          (c['asserts'] as List? ?? const []).cast<Map<String, dynamic>>();

      // -------------------------------------------------------------------------
      // ดึง API response สำหรับ inject (optional)
      // -------------------------------------------------------------------------
      Map<String, dynamic>? respJson;
      try {
        final setupMap = setup.cast<String, dynamic>();
        if (setupMap.containsKey('response') && setupMap['response'] is Map) {
          respJson = (setupMap['response'] as Map).cast<String, dynamic>();
        }
      } catch (_) {}

      /// Helper function: แปลง Map เป็น Dart map literal string
      /// ใช้สำหรับ generate code ที่มี response map
      String _dartMapLiteral(Map<String, dynamic> m) {
        // Helper ภายในสำหรับแปลง value เป็น string
        String val(v) {
          if (v is String) return "'${v.replaceAll("'", "\\'")}'";
          if (v is num || v is bool) return v.toString();
          if (v is Map) return _dartMapLiteral(v.cast<String, dynamic>());
          if (v is List) return '[${v.map(val).join(', ')}]';
          return 'null';
        }

        // สร้าง map literal: {'key1': value1, 'key2': value2}
        return '{' +
            m.entries.map((e) => "'${e.key}': ${val(e.value)}").join(', ') +
            '}';
      }

      // สร้าง argument string สำหรับ response (ถ้ามี)
      final responseArg = (successStub && respJson != null)
          ? ", response: ${_dartMapLiteral(respJson)}"
          : '';

      // -------------------------------------------------------------------------
      // Infer failure code จาก asserts
      // ดูว่า asserts มีการตรวจสอบ status_400 หรือ status_500 หรือไม่
      // -------------------------------------------------------------------------

      /// Helper function: หา failure code จาก asserts
      int? _inferFailureCode(List<Map<String, dynamic>> asserts) {
        for (final a in asserts) {
          final byKey = (a['byKey'] ?? '').toString();
          final exists = a['exists'];
          // ถ้ามี assert ที่ exists == true และ byKey มี status code
          if (exists is bool && exists) {
            if (byKey.contains('status_400')) return 400;
            if (byKey.contains('status_500')) return 500;
          }
        }
        return null;
      }

      // หา failure code (ถ้าไม่ใช่ success case)
      final failureCode = (!successStub) ? _inferFailureCode(asserts) : null;
      final failureArg =
          (failureCode != null) ? ", failureCode: $failureCode" : '';

      // -------------------------------------------------------------------------
      // เริ่มสร้าง test case
      // -------------------------------------------------------------------------
      b
        // ประกาศ testWidgets
        ..writeln("    testWidgets('$id', (tester) async {")
        // สร้าง widget ที่ wrap ด้วย _wrap helper
        ..writeln(
            '      final w = _wrap($pageClass(), success: ${successStub ? 'true' : 'false'}$responseArg$failureArg);')
        // pump widget
        ..writeln('      await tester.pumpWidget(w);');

      // -------------------------------------------------------------------------
      // สร้าง steps (actions)
      // -------------------------------------------------------------------------
      for (var i = 0; i < steps.length; i++) {
        final s = steps[i];
        // ตรวจสอบว่า step ถัดไปเป็น pump หรือไม่
        // ถ้าใช่ ไม่ต้องเพิ่ม pump หลัง action นี้
        final nextIsPump =
            (i + 1 < steps.length) && (steps[i + 1].containsKey('pump'));

        // ---------------------------------------------------------------------
        // enterText: กรอกข้อความใน TextField
        // ---------------------------------------------------------------------
        if (s.containsKey('enterText')) {
          final m = (s['enterText'] as Map).cast<String, dynamic>();
          final k = m['byKey']; // key ของ TextField
          String text = m['text'] ?? ''; // ข้อความที่จะกรอก
          final ds = m['dataset']; // dataset path (optional)

          // ถ้าไม่มี text แต่มี dataset path ให้ resolve จาก datasets
          if (text.isEmpty && ds is String) {
            final dsPath = ds.trim();
            final resolved = _resolveDataset(datasets, dsPath);

            if (resolved is String) {
              text = resolved;
            } else if (resolved is num || resolved is bool) {
              text = resolved.toString();
            } else {
              // ถ้า resolve ไม่ได้และเป็น pairwise case ให้ throw error
              if (id.startsWith('pairwise_case_')) {
                throw StateError(
                    '[$id] Dataset not found or not primitive for $dsPath (byKey=$k)');
              }
              // Fallback: ใช้ sample value จาก sampleByKey
              if (k is String && sampleByKey.containsKey(k)) {
                text = sampleByKey[k]!;
              }
            }
          }

          // เพิ่ม comment แสดง dataset source (สำหรับ debugging)
          if (ds is String) {
            b.writeln("      // dataset: ${ds.trim()}");
          }

          // Escape text สำหรับ Dart string
          final escText = utils.dartEscape(text);

          // สร้าง enterText command
          b.writeln(
              "      await tester.enterText(find.byKey(const Key('$k')), '$escText');");

          // เพิ่ม pump ถ้า step ถัดไปไม่ใช่ pump
          if (!nextIsPump) b.writeln('      await tester.pump();');
        }
        // ---------------------------------------------------------------------
        // tap: แตะที่ widget
        // ---------------------------------------------------------------------
        else if (s.containsKey('tap')) {
          final m = (s['tap'] as Map).cast<String, dynamic>();
          final k = m['byKey']; // key ของ widget

          b
            // ให้แน่ใจว่า widget visible ก่อน tap
            ..writeln(
                "      await tester.ensureVisible(find.byKey(const Key('$k')));")
            // tap widget
            ..writeln("      await tester.tap(find.byKey(const Key('$k')));");

          if (!nextIsPump) b.writeln('      await tester.pump();');
        }
        // ---------------------------------------------------------------------
        // tapText: แตะที่ text
        // ---------------------------------------------------------------------
        else if (s.containsKey('tapText')) {
          final txt = (s['tapText']).toString();
          b.writeln(
              "      await tester.tap(find.text('${utils.dartEscape(txt)}'));");
          if (!nextIsPump) b.writeln('      await tester.pump();');
        }
        // ---------------------------------------------------------------------
        // selectDate: เลือกวันที่จาก DatePicker
        // ---------------------------------------------------------------------
        else if (s.containsKey('selectDate')) {
          final action = (s['selectDate']).toString();

          if (action == 'null' || action == 'cancel') {
            // Cancel DatePicker dialog
            b.writeln("      // Cancel DatePicker - try multiple button texts");
            b.writeln("      if (tester.any(find.text('CANCEL'))) {");
            b.writeln("        await tester.tap(find.text('CANCEL'));");
            b.writeln("      } else if (tester.any(find.text('Cancel'))) {");
            b.writeln("        await tester.tap(find.text('Cancel'));");
            b.writeln("      } else if (tester.any(find.text('ยกเลิก'))) {");
            b.writeln("        await tester.tap(find.text('ยกเลิก'));");
            b.writeln("      } else {");
            // Fallback: tap นอก dialog
            b.writeln("        await tester.tapAt(const Offset(10, 10));");
            b.writeln("      }");
          } else {
            // Parse date ในรูปแบบ DD/MM/YYYY
            final parts = action.split('/');
            if (parts.length == 3) {
              final day = parts[0];
              final month = parts[1];
              final year = parts[2];

              b.writeln("      // Select date: $action");

              // 1. เปิด year picker โดยแตะที่ปีใน header
              b.writeln(
                  "      await tester.tap(find.textContaining('$year').first);");
              b.writeln("      await tester.pumpAndSettle();");

              // 2. เลือกปี
              b.writeln("      await tester.tap(find.text('$year'));");
              b.writeln("      await tester.pumpAndSettle();");

              // 3. Navigate ไปยังเดือนที่ต้องการ
              final monthNames = [
                '',
                'Jan',
                'Feb',
                'Mar',
                'Apr',
                'May',
                'Jun',
                'Jul',
                'Aug',
                'Sep',
                'Oct',
                'Nov',
                'Dec'
              ];
              if (int.tryParse(month) != null) {
                final monthIdx = int.parse(month);
                if (monthIdx >= 1 && monthIdx <= 12) {
                  b.writeln("      // Navigate to ${monthNames[monthIdx]}");
                  b.writeln(
                      "      while (!tester.any(find.textContaining('${monthNames[monthIdx]}'))) {");
                  b.writeln(
                      "        await tester.tap(find.byIcon(Icons.chevron_right));");
                  b.writeln("        await tester.pumpAndSettle();");
                  b.writeln("      }");
                }
              }

              // 4. เลือกวัน
              b.writeln("      await tester.tap(find.text('$day').first);");
              b.writeln("      await tester.pumpAndSettle();");

              // 5. ยืนยันการเลือก
              b.writeln("      await tester.tap(find.text('OK'));");
            } else {
              // Format ไม่ถูกต้อง - ใช้ fallback
              b.writeln("      await tester.tap(find.text('OK'));");
            }
          }
          if (!nextIsPump) b.writeln('      await tester.pump();');
        }
        // ---------------------------------------------------------------------
        // selectTime: เลือกเวลาจาก TimePicker
        // ---------------------------------------------------------------------
        else if (s.containsKey('selectTime')) {
          final action = (s['selectTime']).toString();

          if (action == 'null' || action == 'cancel') {
            // Cancel TimePicker dialog
            b.writeln("      // Cancel TimePicker - try multiple button texts");
            b.writeln("      if (tester.any(find.text('CANCEL'))) {");
            b.writeln("        await tester.tap(find.text('CANCEL'));");
            b.writeln("      } else if (tester.any(find.text('Cancel'))) {");
            b.writeln("        await tester.tap(find.text('Cancel'));");
            b.writeln("      } else if (tester.any(find.text('ยกเลิก'))) {");
            b.writeln("        await tester.tap(find.text('ยกเลิก'));");
            b.writeln("      } else {");
            b.writeln("        await tester.tapAt(const Offset(10, 10));");
            b.writeln("      }");
          } else {
            // Parse time ในรูปแบบ HH:MM
            final parts = action.split(':');
            if (parts.length == 2) {
              final hour = parts[0];
              final minute = parts[1];

              b.writeln("      // Select time: $action");

              // 1. เลือกชั่วโมง
              b.writeln("      await tester.tap(find.text('$hour').first);");
              b.writeln("      await tester.pumpAndSettle();");

              // 2. เลือกนาที
              b.writeln("      await tester.tap(find.text('$minute').first);");
              b.writeln("      await tester.pumpAndSettle();");

              // 3. ยืนยัน
              b.writeln("      await tester.tap(find.text('OK'));");
            } else {
              b.writeln("      await tester.tap(find.text('OK'));");
            }
          }
          if (!nextIsPump) b.writeln('      await tester.pump();');
        }
        // ---------------------------------------------------------------------
        // pumpAndSettle: รอ animations เสร็จ
        // ---------------------------------------------------------------------
        else if (s.containsKey('pumpAndSettle')) {
          b.writeln('      await tester.pumpAndSettle();');
        }
        // ---------------------------------------------------------------------
        // pump: pump frame เดียว
        // ---------------------------------------------------------------------
        else if (s.containsKey('pump')) {
          b.writeln('      await tester.pump();');
        }
      }

      // -------------------------------------------------------------------------
      // สร้าง assertions
      // -------------------------------------------------------------------------
      bool _edgeKeysChecked = false;

      for (final a in asserts) {
        final byKey = a['byKey'];
        final exists = a['exists'];
        final textEquals = a['textEquals'];
        final textContains = a['textContains'];
        final textGlobal = a['text'];

        // Assert: widget exists/not exists by key
        if (byKey != null &&
            exists is bool &&
            textEquals == null &&
            textContains == null) {
          b.writeln(
              "      expect(find.byKey(const Key('$byKey')), ${exists ? 'findsOneWidget' : 'findsNothing'});");
          continue;
        }

        // Assert: text equals by key
        if (byKey != null && textEquals is String) {
          final esc = utils.dartEscape(textEquals);
          b.writeln(
              "      final _tw = tester.widget<Text>(find.byKey(const Key('$byKey')));");
          b.writeln("      expect(_tw.data ?? '', '$esc');");
          continue;
        }

        // Assert: text contains by key
        if (byKey != null && textContains is String) {
          final esc = utils.dartEscape(textContains);
          b.writeln(
              "      final _tw = tester.widget<Text>(find.byKey(const Key('$byKey')));");
          b.writeln("      expect((_tw.data ?? '').contains('$esc'), true);");
          continue;
        }

        // Assert: global text exists/not exists
        if (textGlobal is String && exists is bool) {
          final esc = utils.dartEscape(textGlobal);

          // ตรวจสอบ explicit count จาก assert
          final explicitCount = a['count'];

          final finderExpr = () {
            if (exists) {
              // ใช้ explicit count ถ้ามี
              if (explicitCount is int) {
                // เพิ่ม edge case checks สำหรับ edge_cases group
                if (groupName == 'edge_cases' && !_edgeKeysChecked) {
                  try {
                    final byKeyMap =
                        (datasets['byKey'] as Map).cast<String, dynamic>();
                    final keys = byKeyMap.keys
                        .where((k) => k.contains('textfield'))
                        .toList();
                    for (final k in keys) {
                      b.writeln(
                          "      expect(find.byKey(const Key('$k')), findsOneWidget);");
                    }
                    _edgeKeysChecked = true;
                  } catch (_) {}
                }
                return explicitCount > 1
                    ? 'findsNWidgets($explicitCount)'
                    : 'findsOneWidget';
              }

              // Fallback: ใช้ validation counts จาก test plan
              if (validationCounts.containsKey(esc)) {
                final count = validationCounts[esc]!;
                if (groupName == 'edge_cases' && !_edgeKeysChecked) {
                  try {
                    final byKeyMap =
                        (datasets['byKey'] as Map).cast<String, dynamic>();
                    final keys = byKeyMap.keys
                        .where((k) => k.contains('textfield'))
                        .toList();
                    for (final k in keys) {
                      b.writeln(
                          "      expect(find.byKey(const Key('$k')), findsOneWidget);");
                    }
                    _edgeKeysChecked = true;
                  } catch (_) {}
                }
                return count > 1 ? 'findsNWidgets($count)' : 'findsOneWidget';
              }
            }
            return exists ? 'findsOneWidget' : 'findsNothing';
          }();

          b.writeln("      expect(find.text('$esc'), $finderExpr);");
          continue;
        }
      }

      // -------------------------------------------------------------------------
      // ตรวจสอบ ApiResponse ใน state (สำหรับ success cases ที่มี response)
      // -------------------------------------------------------------------------
      if (successStub && respJson != null && primaryCubitType != null) {
        final hasCode = respJson.containsKey('code');
        final hasMessage = respJson.containsKey('message');

        b.writeln("      // Verify ApiResponse mapped into state");
        b.writeln(
            "      final _el = find.byType($pageClass).evaluate().first;");
        b.writeln(
            "      final _cubit = BlocProvider.of<$primaryCubitType>(_el);");

        if (hasCode) {
          final codeVal = respJson['code'];
          if (codeVal is num) {
            b.writeln(
                "      expect(_cubit.state.response?.code, ${codeVal.toInt()});");
          } else {
            final esc = utils.dartEscape((codeVal?.toString() ?? ''));
            b.writeln(
                "      expect(_cubit.state.response?.code.toString(), '$esc');");
          }
        }

        if (hasMessage) {
          final msg = utils.dartEscape((respJson['message']?.toString() ?? ''));
          b.writeln("      expect(_cubit.state.response?.message, '$msg');");
        }
      }

      // ปิด test case
      b
        ..writeln('    });')
        ..writeln('');
    }
    // ปิด group
    b.writeln('    });');
  }

  // ปิด main group และ main function
  b
    ..writeln('  });')
    ..writeln('}');

  // ---------------------------------------------------------------------------
  // STEP 18: สร้าง Integration Tests
  // เรียก function แยกเพื่อสร้าง integration test file
  // ---------------------------------------------------------------------------

  _generateIntegrationTests(
      uiFile,
      pageClass,
      providerFiles,
      primaryCubitType,
      pkg,
      uiImport,
      orderedGroups,
      providerTypes,
      datasets,
      sampleByKey,
      validationCounts);
}

// =============================================================================
// GENERATE INTEGRATION TESTS
// =============================================================================

/// สร้าง integration test file แยกต่างหาก
///
/// Integration tests ใช้ real providers แทน stubs
/// และรันบน device/emulator จริง
///
/// Parameters:
///   [uiFile]           - path ของ UI file
///   [pageClass]        - ชื่อ page class
///   [providerFiles]    - list ของ provider files สำหรับ import
///   [primaryCubitType] - ชื่อ primary Cubit type
///   [pkg]              - package name
///   [uiImport]         - import path ของ UI file
///   [orderedGroups]    - list ของ (groupName, cases) tuples
///   [providerTypes]    - list ของ provider types
///   [datasets]         - datasets map
///   [sampleByKey]      - sample values map
///   [validationCounts] - validation message counts
void _generateIntegrationTests(
    String uiFile,
    String pageClass,
    List<String> providerFiles,
    String? primaryCubitType,
    String pkg,
    String uiImport,
    List<(String, List<Map<String, dynamic>>)> orderedGroups,
    List<String> providerTypes,
    Map<String, dynamic> datasets,
    Map<String, String> sampleByKey,
    Map<String, int> validationCounts) {
  // ---------------------------------------------------------------------------
  // สร้าง StringBuffer สำหรับ integration test code
  // ---------------------------------------------------------------------------
  final ib = StringBuffer()
    ..writeln('// GENERATED — Integration tests for full flow')
    ..writeln("import 'package:flutter/material.dart';")
    ..writeln("import 'package:flutter_test/flutter_test.dart';")
    // Import integration test binding
    ..writeln("import 'package:integration_test/integration_test.dart';");

  // Import flutter_bloc ถ้ามี providers
  if (providerFiles.isNotEmpty) {
    ib.writeln("import 'package:flutter_bloc/flutter_bloc.dart';");
  }

  // Import provider files
  for (final f in providerFiles) {
    ib.writeln("import '${utils.pkgImport(pkg, f)}';");
  }

  // Import state file (ถ้ามีอยู่จริง)
  if (primaryCubitType != null) {
    final stateFilePath = _getStateFilePathFromCubit(primaryCubitType);
    if (File(stateFilePath).existsSync()) {
      ib.writeln("import '${utils.pkgImport(pkg, stateFilePath)}';");
    }
  }

  // Import UI file
  ib.writeln("import '$uiImport';");

  // ---------------------------------------------------------------------------
  // void main()
  // ---------------------------------------------------------------------------
  ib
    ..writeln('')
    ..writeln('void main() {')
    // Initialize integration test binding
    ..writeln('  IntegrationTestWidgetsFlutterBinding.ensureInitialized();')
    ..writeln("  group('${utils.basename(uiFile)} flow (integration)', () {");

  // ---------------------------------------------------------------------------
  // วนลูปสร้าง test groups
  // ---------------------------------------------------------------------------
  for (final entry in orderedGroups) {
    final groupName = entry.$1;
    final group = entry.$2;

    if (group.isEmpty) continue;

    ib.writeln("    group('$groupName', () {");

    // วนลูปสร้าง test cases
    for (final c in group) {
      final id = (c['tc'] ?? 'case').toString();
      final steps =
          (c['steps'] as List? ?? const []).cast<Map<String, dynamic>>();
      final asserts =
          (c['asserts'] as List? ?? const []).cast<Map<String, dynamic>>();

      ib.writeln("      testWidgets('$id', (tester) async {");

      // สร้าง real providers (ไม่ใช่ stubs)
      ib.writeln('        final providers = <BlocProvider>[');
      for (final t in providerTypes) {
        ib.writeln("          BlocProvider<$t>(create: (_)=> $t()),");
      }
      ib
        ..writeln('        ];')
        ..writeln(
            '        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: $pageClass()));')
        ..writeln('        await tester.pumpWidget(w);');

      // -------------------------------------------------------------------------
      // สร้าง steps
      // -------------------------------------------------------------------------
      for (var i = 0; i < steps.length; i++) {
        final s = steps[i];
        final nextIsPump =
            (i + 1 < steps.length) && (steps[i + 1].containsKey('pump'));

        // ตรวจสอบว่า step ถัดไปเป็น null selection หรือไม่
        // ถ้าใช่ ให้ skip tap action
        bool skipTapForNullSelection = false;
        if (s.containsKey('tap')) {
          for (var j = i + 1; j < steps.length; j++) {
            final nextStep = steps[j];
            if (nextStep.containsKey('pump') ||
                nextStep.containsKey('pumpAndSettle')) {
              continue;
            }
            if (nextStep.containsKey('selectDate')) {
              final action = nextStep['selectDate'].toString();
              if (action == 'null' || action == 'cancel') {
                skipTapForNullSelection = true;
              }
            } else if (nextStep.containsKey('selectTime')) {
              final action = nextStep['selectTime'].toString();
              if (action == 'null' || action == 'cancel') {
                skipTapForNullSelection = true;
              }
            }
            break;
          }
        }

        // enterText
        if (s.containsKey('enterText')) {
          final m = (s['enterText'] as Map).cast<String, dynamic>();
          final k = m['byKey'];
          String text = m['text'] ?? '';
          final ds = m['dataset'];

          if (text.isEmpty && ds is String) {
            final dsPath = ds.trim();
            final resolved = _resolveDataset(datasets, dsPath);
            if (resolved is String) {
              text = resolved;
            } else if (resolved is num || resolved is bool) {
              text = resolved.toString();
            } else if (k is String && sampleByKey.containsKey(k)) {
              text = sampleByKey[k]!;
            }
          }

          if (ds is String) ib.writeln("        // dataset: ${ds.trim()}");
          final escText = utils.dartEscape(text);
          ib.writeln(
              "        await tester.enterText(find.byKey(const Key('$k')), '$escText');");
          if (!nextIsPump) ib.writeln('        await tester.pump();');
        }
        // tap
        else if (s.containsKey('tap')) {
          if (skipTapForNullSelection) {
            final m = (s['tap'] as Map).cast<String, dynamic>();
            final k = m['byKey'];
            ib.writeln(
                "        // Skip tap for '$k' (next action is null/cancel)");
            if (i + 1 < steps.length &&
                (steps[i + 1].containsKey('pumpAndSettle') ||
                    steps[i + 1].containsKey('pump'))) {
              i++;
            }
          } else {
            final m = (s['tap'] as Map).cast<String, dynamic>();
            final k = m['byKey'];
            ib
              ..writeln(
                  "        await tester.ensureVisible(find.byKey(const Key('$k')));")
              ..writeln(
                  "        await tester.tap(find.byKey(const Key('$k')));");
            if (!nextIsPump) ib.writeln('        await tester.pump();');
          }
        }
        // tapText
        else if (s.containsKey('tapText')) {
          final txt = (s['tapText']).toString();
          ib.writeln(
              "        await tester.tap(find.text('${utils.dartEscape(txt)}'));");
          if (!nextIsPump) ib.writeln('        await tester.pump();');
        }
        // selectDate
        else if (s.containsKey('selectDate')) {
          final action = (s['selectDate']).toString();

          if (action == 'null' || action == 'cancel') {
            ib.writeln("        // Skip date selection (null/cancel)");
            if (i + 1 < steps.length &&
                (steps[i + 1].containsKey('pumpAndSettle') ||
                    steps[i + 1].containsKey('pump'))) {
              i++;
            }
          } else {
            final parts = action.split('/');
            if (parts.length == 3) {
              final day = parts[0];
              final month = parts[1];
              final year = parts[2];

              ib.writeln("        // Select date: $action");
              ib.writeln("        {");
              ib.writeln("          // Wait for DatePicker to appear");
              ib.writeln(
                  "          await tester.pumpAndSettle(const Duration(milliseconds: 500));");
              ib.writeln(
                  "          // Find and tap the year in header (e.g., '202x') to open year picker");
              ib.writeln("          final yearInHeader = find.byWidgetPredicate(");
              ib.writeln(
                  "            (widget) => widget is Text && (widget.data ?? '').contains('202'),");
              ib.writeln("          );");
              ib.writeln("          if (tester.any(yearInHeader)) {");
              ib.writeln("            await tester.tap(yearInHeader.first);");
              ib.writeln("            await tester.pumpAndSettle();");
              ib.writeln("          }");
              ib.writeln(
                  "          // Wait until year picker is fully loaded (check for year items)");
              ib.writeln("          int waitAttempts = 0;");
              ib.writeln("          while (waitAttempts < 50) {");
              ib.writeln(
                  "            await tester.pump(const Duration(milliseconds: 50));");
              ib.writeln(
                  "            // Check if year picker has loaded by finding any 4-digit year");
              ib.writeln("            final yearItems = find.byWidgetPredicate(");
              ib.writeln(
                  "              (w) => w is Text && RegExp(r'^\\d{4}\$').hasMatch(w.data ?? ''),");
              ib.writeln("            );");
              ib.writeln("            if (tester.any(yearItems)) {");
              ib.writeln("              // Found year items, picker is ready");
              ib.writeln("              await tester.pumpAndSettle();");
              ib.writeln("              break;");
              ib.writeln("            }");
              ib.writeln("            waitAttempts++;");
              ib.writeln("          }");
              ib.writeln("          // Scroll to find year $year");
              ib.writeln("          int scrollAttempts = 0;");
              ib.writeln(
                  "          bool scrollingUp = true; // Start by scrolling up");
              ib.writeln(
                  "          while (!tester.any(find.text('$year')) && scrollAttempts < 30) {");
              ib.writeln("            final scrollable = find.byType(Scrollable);");
              ib.writeln("            if (tester.any(scrollable)) {");
              ib.writeln(
                  "              // Try scrolling up first (for older years), then down");
              ib.writeln(
                  "              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);");
              ib.writeln(
                  "              await tester.drag(scrollable.first, offset);");
              ib.writeln("              await tester.pumpAndSettle();");
              ib.writeln(
                  "              // After 15 attempts scrolling up, try scrolling down");
              ib.writeln(
                  "              if (scrollAttempts == 15) scrollingUp = false;");
              ib.writeln("            }");
              ib.writeln("            scrollAttempts++;");
              ib.writeln("          }");
              ib.writeln("          // Tap the year");
              ib.writeln("          if (tester.any(find.text('$year'))) {");
              ib.writeln(
                  "            await tester.tap(find.text('$year'), warnIfMissed: false);");
              ib.writeln("            await tester.pumpAndSettle();");
              ib.writeln("          }");
              ib.writeln("        }");

              // Navigate to month
              final monthNames = [
                '',
                'Jan',
                'Feb',
                'Mar',
                'Apr',
                'May',
                'Jun',
                'Jul',
                'Aug',
                'Sep',
                'Oct',
                'Nov',
                'Dec'
              ];
              if (int.tryParse(month) != null) {
                final monthIdx = int.parse(month);
                if (monthIdx >= 1 && monthIdx <= 12) {
                  ib.writeln("        // Navigate to ${monthNames[monthIdx]}");
                  ib.writeln("        {");
                  ib.writeln("          int monthNavAttempts = 0;");
                  ib.writeln(
                      "          while (!tester.any(find.textContaining('${monthNames[monthIdx]}')) && monthNavAttempts < 12) {");
                  ib.writeln(
                      "            if (tester.any(find.byIcon(Icons.chevron_right))) {");
                  ib.writeln(
                      "              await tester.tap(find.byIcon(Icons.chevron_right));");
                  ib.writeln("              await tester.pumpAndSettle();");
                  ib.writeln("            }");
                  ib.writeln("            monthNavAttempts++;");
                  ib.writeln("          }");
                  ib.writeln("        }");
                }
              }

              ib.writeln("        await tester.tap(find.text('$day').first);");
              ib.writeln("        await tester.pumpAndSettle();");
              ib.writeln("        await tester.tap(find.text('OK'));");
            } else {
              ib.writeln("        await tester.tap(find.text('OK'));");
            }
          }
          if (!nextIsPump) ib.writeln('        await tester.pump();');
        }
        // selectTime
        else if (s.containsKey('selectTime')) {
          final action = (s['selectTime']).toString();

          if (action == 'null' || action == 'cancel') {
            ib.writeln("        // Skip time selection (null/cancel)");
            if (i + 1 < steps.length &&
                (steps[i + 1].containsKey('pumpAndSettle') ||
                    steps[i + 1].containsKey('pump'))) {
              i++;
            }
          } else {
            final parts = action.split(':');
            if (parts.length == 2) {
              final hour = parts[0];
              final minute = parts[1];

              ib.writeln("        // Select time: $action");
              ib.writeln("        await tester.tap(find.text('$hour').first);");
              ib.writeln("        await tester.pumpAndSettle();");
              ib.writeln(
                  "        await tester.tap(find.text('$minute').first);");
              ib.writeln("        await tester.pumpAndSettle();");
              ib.writeln("        await tester.tap(find.text('OK'));");
            } else {
              ib.writeln("        await tester.tap(find.text('OK'));");
            }
          }
          if (!nextIsPump) ib.writeln('        await tester.pump();');
        }
        // pumpAndSettle
        else if (s.containsKey('pumpAndSettle')) {
          ib.writeln('        await tester.pumpAndSettle();');
        }
        // pump
        else if (s.containsKey('pump')) {
          ib.writeln('        await tester.pump();');
        }
      }

      // -------------------------------------------------------------------------
      // สร้าง assertions (OR logic)
      // ใช้ expectAny pattern - อย่างน้อยหนึ่ง element ต้อง exist
      // -------------------------------------------------------------------------
      if (asserts.isNotEmpty) {
        final finders = <String>[];

        for (final a in asserts) {
          final byKey = a['byKey'];
          final exists = a['exists'];
          final textGlobal = a['text'];

          // ข้าม non-exists assertions
          if (exists == false) continue;

          if (byKey != null && exists is bool) {
            finders.add("find.byKey(const Key('$byKey'))");
          } else if (textGlobal is String && exists is bool) {
            final esc = utils.dartEscape(textGlobal);
            finders.add("find.text('$esc')");
          }
        }

        // สร้าง expectAny check
        if (finders.isNotEmpty) {
          ib.writeln(
              '        // Check if any expected element exists (OR logic)');
          ib.writeln('        final expected = [');
          for (final finder in finders) {
            ib.writeln('          $finder,');
          }
          ib.writeln('        ];');
          ib.writeln(
              '        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,');
          ib.writeln(
              "            reason: 'Expected at least one of the elements to exist');");
        }
      }

      // ปิด test case
      ib
        ..writeln('      });')
        ..writeln('');
    }
    // ปิด group
    ib.writeln('    });');
  }

  // ปิด main group และ main function
  ib
    ..writeln('  });')
    ..writeln('}');

  // ---------------------------------------------------------------------------
  // เขียน integration test file
  // ---------------------------------------------------------------------------

  // กำหนด output path
  final integPath =
      'integration_test/${utils.basenameWithoutExtension(uiFile)}_flow_test.dart';

  // สร้าง directory ถ้ายังไม่มี
  File(integPath).createSync(recursive: true);

  // เขียน code ลงไฟล์
  File(integPath).writeAsStringSync(ib.toString());

  // แสดง success message
  stdout.writeln('✓ integration full flow tests: $integPath');
}

// =============================================================================
// HELPER FUNCTIONS
// =============================================================================

/// หา primary Cubit type จาก list ของ provider types
///
/// ใช้ heuristic: หา Cubit แรกที่ไม่ใช่ private (ไม่ขึ้นต้นด้วย _)
///
/// Parameter:
///   [providerTypes] - list ของ provider type names
///
/// Returns:
///   String? - ชื่อ primary Cubit หรือ null ถ้าไม่พบ
String? _getPrimaryCubitType(List<String> providerTypes) {
  for (final type in providerTypes) {
    // หา type ที่ลงท้ายด้วย Cubit และไม่ใช่ private class
    if (type.endsWith('Cubit') && !type.startsWith('_')) {
      return type;
    }
  }
  return null;
}

/// แปลง Cubit type name เป็น state file path
///
/// ตัวอย่าง:
///   RegisterCubit -> lib/cubit/register_state.dart
///   LoginCubit    -> lib/cubit/login_state.dart
///   CustomerCubit -> lib/cubit/customer_state.dart
///
/// Parameter:
///   [cubitType] - ชื่อ Cubit class
///
/// Returns:
///   String - path ของ state file
String _getStateFilePathFromCubit(String cubitType) {
  // ลบ 'Cubit' suffix และแปลงเป็น lowercase
  final baseName = cubitType.replaceAll('Cubit', '').toLowerCase();

  // แปลง camelCase เป็น snake_case
  final parts = <String>[];
  for (int i = 0; i < baseName.length; i++) {
    // ถ้าเป็น uppercase (ยกเว้นตัวแรก) ให้เพิ่ม underscore ก่อน
    if (i > 0 && baseName[i].toUpperCase() == baseName[i]) {
      parts.add('_');
    }
    parts.add(baseName[i].toLowerCase());
  }

  // Return path ในรูปแบบ lib/cubit/xxx_state.dart
  return 'lib/cubit/${parts.join('')}_state.dart';
}

// =============================================================================
// EXTRACT VALIDATION COUNTS
// =============================================================================

/// ดึง validation message counts จาก test plan
///
/// ใช้สำหรับกำหนดจำนวน widgets ที่คาดหวังใน assertions
/// เช่น ถ้ามี 2 fields ที่ใช้ validation message เดียวกัน
/// ต้องใช้ findsNWidgets(2) แทน findsOneWidget
///
/// Parameter:
///   [cases] - list ของ test cases
///
/// Returns:
///   Map<String, int> - mapping จาก text -> count
Map<String, int> _extractValidationCountsFromPlan(
    List<Map<String, dynamic>> cases) {
  final counts = <String, int>{};

  // วนลูปแต่ละ test case
  for (final c in cases) {
    final asserts =
        (c['asserts'] as List? ?? const []).cast<Map<String, dynamic>>();

    // วนลูปแต่ละ assert
    for (final a in asserts) {
      final text = a['text'];
      final count = a['count'];

      // ถ้ามี text และ count ให้เก็บลง map
      if (text is String && count is int) {
        counts[text] = count;
      }
    }
  }

  return counts;
}

// =============================================================================
// RESOLVE DATASET
// =============================================================================

/// Resolve dataset path เพื่อดึงค่าจาก datasets map
///
/// รองรับ path formats:
///   - byKey.fieldName[0].valid
///   - byKey.fieldName[0].invalid
///   - nested.path.to.value
///
/// Parameters:
///   [root]    - datasets map
///   [rawPath] - path string ที่จะ resolve
///
/// Returns:
///   dynamic - ค่าที่ resolve ได้ หรือ null ถ้าไม่พบ
dynamic _resolveDataset(Map<String, dynamic> root, String rawPath) {
  // Trim whitespace จาก path
  String path = rawPath.trim();

  /// Helper function สำหรับ resolve path จาก map
  dynamic tryResolve(Map<String, dynamic> start) {
    dynamic cur = start;

    // แยก path เป็น segments ด้วย '.'
    final segments =
        path.split('.').map((s) => s.trim()).where((s) => s.isNotEmpty);

    // วนลูปแต่ละ segment
    for (final seg in segments) {
      // Parse segment: อาจมีรูปแบบ 'key' หรือ 'key[0]'
      // RegExp จับ: key name และ optional index
      final m = RegExp(r'^(.*?)(?:\[(\d+)\])?$').firstMatch(seg);
      if (m == null) return null;

      final key = m.group(1)!.trim(); // key name
      final idxStr = m.group(2); // index string (optional)

      // ดึงค่าด้วย key
      if (cur is Map && cur.containsKey(key)) {
        cur = cur[key];
      } else {
        return null; // key ไม่พบ
      }

      // ถ้ามี index ให้ดึงจาก array
      if (idxStr != null) {
        final i = int.tryParse(idxStr);
        if (i == null) return null;

        // ตรวจสอบว่าเป็น List และ index valid
        if (cur is List && i >= 0 && i < cur.length) {
          cur = cur[i];
        } else {
          return null; // index out of bounds
        }
      }
    }

    return cur;
  }

  // ลอง resolve จาก root ก่อน
  var v = tryResolve(root);
  if (v != null) return v;

  // ถ้าไม่สำเร็จ ลองหา nested 'datasets' key
  final nested = (root['datasets'] is Map)
      ? (root['datasets'] as Map).cast<String, dynamic>()
      : null;

  if (nested != null) {
    v = tryResolve(nested);
    if (v != null) return v;
  }

  return null; // ไม่พบค่า
}
