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
// BACKWARD-COMPATIBLE TOP-LEVEL FUNCTION
// =============================================================================

/// Backward-compatible wrapper — delegates to [TestScriptGenerator].
String generateTestScriptFromTestData(String testDataPath) =>
    TestScriptGenerator().generateTestScript(testDataPath);

// =============================================================================
// TestScriptGenerator CLASS
// =============================================================================

class TestScriptGenerator {
  /// Output path ที่ถูก set ไว้ล่วงหน้าผ่าน setOutputPath()
  String? _outputPath;

  TestScriptGenerator();

  /// เก็บ output path ล่วงหน้าก่อน generate
  ///
  /// Parameter:
  ///   [path] - path ของ output file เช่น "integration_test/page_flow_test.dart"
  void setOutputPath(String path) {
    _outputPath = path.trim().isNotEmpty ? path.trim() : null;
  }

  /// สร้าง Flutter test script จาก test data file
  ///
  /// Parameters:
  ///   [testDataPath] - path ของไฟล์ .testdata.json
  ///                    เช่น "output/test_data/login_page.testdata.json"
  ///   [outputPath]   - (optional) override path ของ output file
  ///                    Priority: outputPath param → _outputPath → default
  ///
  /// Returns:
  ///   String - path ของ integration test file ที่สร้าง
  String generateTestScript(String testDataPath, {String? outputPath}) {
    // Priority: parameter → stored → default
    final String effectivePath;
    if (outputPath != null && outputPath.trim().isNotEmpty) {
      effectivePath = outputPath.trim();
    } else if (_outputPath != null) {
      effectivePath = _outputPath!;
    } else {
      final base = testDataPath
          .replaceAll('output/test_data/', '')
          .replaceAll(RegExp(r'\.testdata\.json$'), '');
      effectivePath = 'integration_test/${base}_flow_test.dart';
    }

    // เรียก function หลักในการประมวลผล
    _processOne(testDataPath, outputPath: effectivePath);

    return effectivePath;
  }

  // =========================================================================
  // PROCESS ONE FILE - ฟังก์ชันหลักในการประมวลผล
  // =========================================================================

  /// ประมวลผลไฟล์ test data หนึ่งไฟล์และสร้าง test script
  ///
  /// Parameters:
  ///   [planPath]   - path ของไฟล์ .testdata.json
  ///   [outputPath] - path ของ output file ที่ต้องการเขียน
  ///
  /// การทำงาน:
  ///   1. อ่านและ parse test data JSON
  ///   2. ดึงข้อมูล source (UI file, classes)
  ///   3. โหลด datasets (embedded หรือ external)
  ///   4. สร้าง stub classes สำหรับ Cubit
  ///   5. สร้าง test cases ตาม groups
  ///   6. เขียน integration test file
  void _processOne(String planPath, {required String outputPath}) {
    // STEP 1: อ่านและ parse ไฟล์ test data
    final j = _parsePlanFile(planPath);

    // STEP 2: ดึงข้อมูลจาก source section
    final (:uiFile, :pageClass, :cubitClass, :stateClass) = _extractSource(j);

    // STEP 3: สร้าง providers list จาก cubitClass
    final providers = cubitClass != null
        ? [
            {'type': cubitClass}
          ]
        : <Map<String, dynamic>>[];
    final cases =
        (j['cases'] as List? ?? const []).cast<Map<String, dynamic>>();

    // STEP 4: ดึง validation counts จาก test plan
    final validationCounts = _extractValidationCountsFromPlan(cases);

    // STEP 5: โหลด datasets (external หรือ embedded)
    final datasets = _loadDatasets(uiFile, j);

    // STEP 6: อ่านชื่อ package จาก pubspec.yaml
    final pkg = utils.readPackageName() ?? 'master_project';

    // STEP 7: Normalize UI file path → uiImport
    final uiImport = _resolveUiImport(uiFile, pkg);

    // STEP 8: หา provider type files สำหรับ import
    final (:providerTypes, :providerFiles) =
        _resolveProviderFiles(providers, pkg);

    // STEP 9: กำหนด primary Cubit type
    final primaryCubitType = _getPrimaryCubitType(providerTypes);

    // STEP 10: สร้าง sample values map
    final sampleByKey = _buildSampleByKey(datasets);

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
        bool successStub = (setup['cubitStub'] ?? '').toString() == 'success' ||
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
          // ตรวจสอบว่า step ถัดไปเป็น pump หรือ pumpAndSettle หรือไม่
          // ถ้าใช่ ไม่ต้องเพิ่ม pump หลัง action นี้ (pumpAndSettle ครอบคลุม pump อยู่แล้ว)
          final nextIsPump = (i + 1 < steps.length) &&
              (steps[i + 1].containsKey('pump') ||
                  steps[i + 1].containsKey('pumpAndSettle'));

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

            // สำหรับ submit button (isSubmit:true): dismiss keyboard ก่อน
            // เพื่อให้ button กลับมาอยู่ใน viewport แล้วค่อย ensureVisible
            final isSubmit = m['isSubmit'] == true;
            if (isSubmit) {
              b.writeln(
                  '      FocusManager.instance.primaryFocus?.unfocus();');
              b.writeln('      await tester.pumpAndSettle();');
              b.writeln(
                  "      await tester.ensureVisible(find.byKey(const Key('$k')));");
              b.writeln(
                  "      await tester.tap(find.byKey(const Key('$k')));");
            } else {
              b
                ..writeln(
                    "      await tester.ensureVisible(find.byKey(const Key('$k')));")
                ..writeln(
                    "      await tester.tap(find.byKey(const Key('$k')));");
            }

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
              b.writeln("      // Cancel DatePicker");
              b.writeln("      if (tester.any(find.text('Cancel'))) {");
              b.writeln("        await tester.tap(find.text('Cancel'));");
              b.writeln("      } else {");
              b.writeln("        await tester.tapAt(const Offset(10, 10));");
              b.writeln("      }");
            } else {
              final parts = action.split('/');
              if (parts.length == 3) {
                final month = parts[1];
                final year = parts[2];

                // date stored as dd/mm/yyyy → text input needs MM/DD/YYYY
                final textInputDate =
                    '${month.padLeft(2, '0')}/${parts[0].padLeft(2, '0')}/$year';

                b.writeln("      // Select date: $action (text input mode)");
                b.writeln("      {");
                b.writeln(
                    "        await tester.pumpAndSettle(const Duration(milliseconds: 300));");
                b.writeln(
                    "        // Switch DatePicker to text-input mode via edit icon");
                b.writeln(
                    "        final editIcon = find.byIcon(Icons.edit);");
                b.writeln("        if (tester.any(editIcon)) {");
                b.writeln("          await tester.tap(editIcon.first);");
                b.writeln("          await tester.pumpAndSettle();");
                b.writeln("        }");
                b.writeln(
                    "        // Enter date as MM/DD/YYYY");
                b.writeln(
                    "        final dateTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));");
                b.writeln("        if (tester.any(dateTF)) {");
                b.writeln("          await tester.tap(dateTF.first);");
                b.writeln("          await tester.pumpAndSettle();");
                b.writeln(
                    "          await tester.enterText(dateTF.first, '$textInputDate');");
                b.writeln("          await tester.pumpAndSettle();");
                b.writeln("        }");
                b.writeln("      }");
                b.writeln("      await tester.tap(find.text('OK'));");
              } else {
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
              b.writeln(
                  "      // Cancel TimePicker - try multiple button texts");
              b.writeln("      if (tester.any(find.text('Cancel'))) {");
              b.writeln("        await tester.tap(find.text('Cancel'));");
              b.writeln("      } else {");
              b.writeln("        await tester.tapAt(const Offset(10, 10));");
              b.writeln("      }");
            } else {
              final parts = action.split(':');
              if (parts.length == 2) {
                final hour = parts[0];
                final minute = parts[1];

                b.writeln("      // Select time: $action");
                // Switch to input mode if dial is showing
                b.writeln("      {");
                b.writeln(
                    "        final keyboardBtn = find.byIcon(Icons.keyboard);");
                b.writeln("        if (tester.any(keyboardBtn)) {");
                b.writeln(
                    "          await tester.tap(keyboardBtn.first);");
                b.writeln("          await tester.pumpAndSettle();");
                b.writeln("        }");
                b.writeln("      }");
                // Enter hour and minute via dialog TextFields
                b.writeln("      {");
                b.writeln(
                    "        final dialogTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));");
                b.writeln(
                    "        if (dialogTF.evaluate().length >= 1) {");
                b.writeln("          await tester.tap(dialogTF.first);");
                b.writeln("          await tester.pumpAndSettle();");
                b.writeln(
                    "          await tester.enterText(dialogTF.first, '$hour');");
                b.writeln("          await tester.pumpAndSettle();");
                b.writeln("        }");
                b.writeln(
                    "        if (dialogTF.evaluate().length >= 2) {");
                b.writeln("          await tester.tap(dialogTF.at(1));");
                b.writeln("          await tester.pumpAndSettle();");
                b.writeln(
                    "          await tester.enterText(dialogTF.at(1), '$minute');");
                b.writeln("          await tester.pumpAndSettle();");
                b.writeln("        }");
                b.writeln("      }");
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
          final byType = a['byType'];
          final dismiss = a['dismiss'] == true;

          // Assert: by widget type (e.g. AlertDialog, SimpleDialog)
          if (byType != null && exists is bool) {
            b.writeln(
                "      expect(find.byType($byType), ${exists ? 'findsOneWidget' : 'findsNothing'});");
            if (exists && dismiss) {
              b.writeln("      // Dismiss $byType");
              b.writeln(
                  "      final _dialogBtn = find.descendant(of: find.byType($byType), matching: find.byType(TextButton));");
              b.writeln(
                  "      if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);");
              b.writeln("      await tester.pumpAndSettle();");
            }
            continue;
          }

          // Assert: widget exists/not exists by key
          if (byKey != null &&
              exists is bool &&
              textEquals == null &&
              textContains == null) {
            b.writeln(
                "      expect(find.byKey(const Key('$byKey')), ${exists ? 'findsOneWidget' : 'findsNothing'});");
            // Auto-dismiss dialog after asserting it exists
            if (exists && dismiss) {
              b.writeln("      // Dismiss dialog");
              b.writeln(
                  "      final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));");
              b.writeln(
                  "      if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);");
              b.writeln("      else await tester.tap(find.descendant(of: find.byType(SimpleDialog), matching: find.byType(TextButton)).last);");
              b.writeln("      await tester.pumpAndSettle();");
            }
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
            final msg =
                utils.dartEscape((respJson['message']?.toString() ?? ''));
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
        validationCounts,
        outputPath);
  }

  // =========================================================================
  // PROCESS ONE — HELPER METHODS (STEP 1, 2, 5, 7, 8, 10)
  // =========================================================================

  /// STEP 1: อ่านและ parse ไฟล์ test data JSON
  Map<String, dynamic> _parsePlanFile(String planPath) {
    final raw = File(planPath).readAsStringSync();
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  /// STEP 2: ดึงข้อมูลจาก source section ของ plan
  ({String uiFile, String pageClass, String? cubitClass, String? stateClass})
      _extractSource(Map<String, dynamic> j) {
    final source = (j['source'] as Map<String, dynamic>?) ?? const {};
    final uiFile = (source['file'] as String?) ?? 'lib/unknown.dart';
    final pageClass = (source['pageClass'] as String?) ??
        utils.basenameWithoutExtension(uiFile);
    final cubitClass = source['cubitClass'] as String?;
    final stateClass = source['stateClass'] as String?;
    return (
      uiFile: uiFile,
      pageClass: pageClass,
      cubitClass: cubitClass,
      stateClass: stateClass,
    );
  }

  /// STEP 5: โหลด datasets — external file ก่อน, fallback embedded
  Map<String, dynamic> _loadDatasets(String uiFile, Map<String, dynamic> j) {
    try {
      final base = utils.basenameWithoutExtension(uiFile);
      final f = File('output/test_data/$base.datasets.json');
      if (f.existsSync()) {
        final ext = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
        final extDs = (ext['datasets'] as Map?)?.cast<String, dynamic>();
        if (extDs != null && extDs.isNotEmpty) return extDs;
      }
    } catch (_) {}
    return (j['datasets'] as Map? ?? const {}).cast<String, dynamic>();
  }

  /// STEP 7: Normalize UI file path และสร้าง package import string
  String _resolveUiImport(String uiFile, String pkg) {
    String normalized = uiFile;
    if (uiFile.contains('/lib/')) {
      normalized = 'lib/' + uiFile.split('/lib/').last;
    }
    return utils.pkgImport(pkg, normalized);
  }

  /// STEP 8: หา provider types และ provider files สำหรับ import
  ({List<String> providerTypes, List<String> providerFiles})
      _resolveProviderFiles(List<Map<String, dynamic>> providers, String pkg) {
    final providerTypes = <String>[];
    for (final p in providers) {
      final t = (p['type'] ?? '').toString();
      if (t.isNotEmpty) providerTypes.add(t);
    }
    final providerFiles = <String>[];
    for (final t in providerTypes) {
      final f = utils.findDeclFile(
        RegExp(r'class\s+' + RegExp.escape(t) + r'\b'),
        endsWith: '_cubit.dart',
      );
      if (f != null) providerFiles.add(f);
    }
    return (providerTypes: providerTypes, providerFiles: providerFiles);
  }

  /// STEP 10: สร้าง sample values map จาก datasets
  /// ดึงค่า valid ตัวแรกของแต่ละ field สำหรับใช้เป็น fallback
  Map<String, String> _buildSampleByKey(Map<String, dynamic> datasets) {
    final sampleByKey = <String, String>{};
    if (datasets.containsKey('byKey') && datasets['byKey'] is Map) {
      final byKey = (datasets['byKey'] as Map).cast<String, dynamic>();
      byKey.forEach((k, v) {
        try {
          if (v is List && v.isNotEmpty && v.first is Map) {
            final first = v.first as Map;
            if (first.containsKey('valid') && first['valid'] is String) {
              sampleByKey[k] = first['valid'] as String;
            }
          } else if (v is Map) {
            final valid = v['valid'];
            if (valid is List && valid.isNotEmpty && valid.first is String) {
              sampleByKey[k] = valid.first as String;
            } else if (valid is String) {
              sampleByKey[k] = valid;
            }
          }
        } catch (_) {}
      });
    }
    return sampleByKey;
  }

  // =========================================================================
  // GENERATE INTEGRATION TESTS
  // =========================================================================

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
      Map<String, int> validationCounts,
      String outputPath) {
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
          final nextIsPump = (i + 1 < steps.length) &&
              (steps[i + 1].containsKey('pump') ||
                  steps[i + 1].containsKey('pumpAndSettle'));

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
              // สำหรับ submit button (isSubmit:true): dismiss keyboard ก่อน
              // เพื่อให้ button กลับมาอยู่ใน viewport แล้วค่อย ensureVisible
              final isSubmit = m['isSubmit'] == true;
              if (isSubmit) {
                ib.writeln(
                    '        FocusManager.instance.primaryFocus?.unfocus();');
                ib.writeln('        await tester.pumpAndSettle();');
                ib.writeln(
                    "        await tester.ensureVisible(find.byKey(const Key('$k')));");
                ib.writeln(
                    "        await tester.tap(find.byKey(const Key('$k')));");
              } else {
                ib
                  ..writeln(
                      "        await tester.ensureVisible(find.byKey(const Key('$k')));")
                  ..writeln(
                      "        await tester.tap(find.byKey(const Key('$k')));");
              }
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
                final month = parts[1];
                final year = parts[2];

                // date stored as dd/mm/yyyy → text input needs MM/DD/YYYY
                final textInputDate =
                    '${month.padLeft(2, '0')}/${parts[0].padLeft(2, '0')}/$year';

                ib.writeln("        // Select date: $action (text input mode)");
                ib.writeln("        {");
                ib.writeln(
                    "          await tester.pumpAndSettle(const Duration(milliseconds: 500));");
                ib.writeln(
                    "          // Switch DatePicker to text-input mode via edit icon");
                ib.writeln(
                    "          final editIcon = find.byIcon(Icons.edit);");
                ib.writeln("          if (tester.any(editIcon)) {");
                ib.writeln(
                    "            await tester.tap(editIcon.first);");
                ib.writeln("            await tester.pumpAndSettle();");
                ib.writeln("          }");
                ib.writeln(
                    "          // Enter date as MM/DD/YYYY in the text field");
                ib.writeln(
                    "          final dateTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));");
                ib.writeln("          if (tester.any(dateTF)) {");
                ib.writeln(
                    "            await tester.tap(dateTF.first);");
                ib.writeln("            await tester.pumpAndSettle();");
                ib.writeln(
                    "            await tester.enterText(dateTF.first, '$textInputDate');");
                ib.writeln("            await tester.pumpAndSettle();");
                ib.writeln("          }");
                ib.writeln("        }");
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
                // Switch to input mode if dial mode is showing (safety net)
                ib.writeln("        {");
                ib.writeln(
                    "          final keyboardBtn = find.byIcon(Icons.keyboard);");
                ib.writeln("          if (tester.any(keyboardBtn)) {");
                ib.writeln(
                    "            await tester.tap(keyboardBtn.first);");
                ib.writeln("            await tester.pumpAndSettle();");
                ib.writeln("          }");
                ib.writeln("        }");
                // Enter hour and minute via dialog TextFields
                ib.writeln("        {");
                ib.writeln(
                    "          final dialogTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));");
                ib.writeln(
                    "          if (dialogTF.evaluate().length >= 1) {");
                ib.writeln("            await tester.tap(dialogTF.first);");
                ib.writeln("            await tester.pumpAndSettle();");
                ib.writeln(
                    "            await tester.enterText(dialogTF.first, '$hour');");
                ib.writeln("            await tester.pumpAndSettle();");
                ib.writeln("          }");
                ib.writeln(
                    "          if (dialogTF.evaluate().length >= 2) {");
                ib.writeln("            await tester.tap(dialogTF.at(1));");
                ib.writeln("            await tester.pumpAndSettle();");
                ib.writeln(
                    "            await tester.enterText(dialogTF.at(1), '$minute');");
                ib.writeln("            await tester.pumpAndSettle();");
                ib.writeln("          }");
                ib.writeln("        }");
                ib.writeln("        await tester.tap(find.text('OK'));");
              } else {
                ib.writeln("        await tester.tap(find.text('OK'));");
              }
            }
            if (!nextIsPump) ib.writeln('        await tester.pump();');
          }
          // scrollAndTapText — select dropdown item after dropdown is opened
          else if (s.containsKey('scrollAndTapText')) {
            final txt = utils.dartEscape(s['scrollAndTapText'].toString());
            ib
              ..writeln(
                  "        await tester.ensureVisible(find.text('$txt').last);")
              ..writeln("        await tester.tap(find.text('$txt').last);")
              ..writeln('        await tester.pumpAndSettle();');
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
            final byType = a['byType'];

            // ข้าม non-exists assertions
            if (exists == false) continue;

            if (byType != null && exists is bool) {
              finders.add("find.byType($byType)");
            } else if (byKey != null && exists is bool) {
              finders.add("find.byKey(const Key('$byKey'))");
            } else if (textGlobal is String && exists is bool) {
              final esc = utils.dartEscape(textGlobal);
              finders.add("find.text('$esc')");
            }
            // Note: dismiss is handled after expectAny (see below)
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

          // Dismiss any dialogs after expectAny
          for (final a in asserts) {
            if (a['dismiss'] == true && a['exists'] == true) {
              final type = a['byType']?.toString() ?? 'AlertDialog';
              ib.writeln('        // Dismiss $type');
              ib.writeln(
                  '        final _dialogBtn = find.descendant(of: find.byType($type), matching: find.byType(TextButton));');
              ib.writeln(
                  '        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);');
              ib.writeln('        await tester.pumpAndSettle();');
              break; // dismiss once is enough
            }
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

    // สร้าง directory ถ้ายังไม่มี
    File(outputPath).createSync(recursive: true);

    // เขียน code ลงไฟล์
    File(outputPath).writeAsStringSync(ib.toString());

    // แสดง success message
    stdout.writeln('✓ integration full flow tests: $outputPath');
  }

  // =========================================================================
  // HELPER FUNCTIONS
  // =========================================================================

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

  // =========================================================================
  // EXTRACT VALIDATION COUNTS
  // =========================================================================

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

  // =========================================================================
  // RESOLVE DATASET
  // =========================================================================

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
    stderr.writeln(
        'Usage: dart run tools/script_v2/generate_test_script.dart <testdata.json>');
    stderr.writeln(
        'Example: dart run tools/script_v2/generate_test_script.dart output/test_data/buttons_page.testdata.json');
    exit(1);
  }

  // ---------------------------------------------------------------------------
  // วนลูปประมวลผลแต่ละไฟล์
  // ---------------------------------------------------------------------------
  final generator = TestScriptGenerator();
  for (final path in args) {
    try {
      generator.generateTestScript(path);
    } catch (e, st) {
      stderr.writeln('! Failed to process $path: $e\n$st');
    }
  }
}
