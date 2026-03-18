// =============================================================================
// coverage_runner.dart
// =============================================================================
// TestRunner class สำหรับรัน Flutter tests และสร้าง Coverage Report
//
// Package: Domain > Runner (sub-package ใหม่)
// เรียกใช้โดย: PipelineController (server.dart)
//
// ความรับผิดชอบ:
//   1. clearCoverage()         - ลบ coverage data เก่าออกก่อนรันใหม่
//   2. findMobileDevice()      - ค้นหา device/emulator สำหรับ integration test
//   3. runFlutterTest()        - รัน flutter test พร้อม/ไม่พร้อม coverage flag
//   4. generateCoverageReport() - รัน lcov + genhtml → สร้าง HTML report
//   5. openCoverageReport()    - เปิด report ใน browser ตาม OS platform
//
// External CLI Tools ที่เรียกใช้:
//   - flutter test             (Step 3: รัน widget/integration tests)
//   - flutter devices          (ค้นหา device ที่รันอยู่)
//   - lcov --remove            (Step 4a: กรอง cubit files ออกจาก coverage)
//   - genhtml                  (Step 4b: แปลง lcov.info → HTML report)
//   - open / start / xdg-open  (Step 5: เปิด browser ตาม platform)
// =============================================================================

import 'dart:convert';
import 'dart:io';

// =============================================================================
// DATA CLASS: TestRunResult
// =============================================================================

/// ผลลัพธ์จากการรัน Flutter test
///
/// ใช้ส่งกลับจาก [CoverageRunner.runFlutterTest] ไปยัง [PipelineController]
/// เพื่อให้ Controller ประมวลผลและส่ง HTTP response กลับไปยัง WebUI
class TestRunResult {
  /// exit code จาก flutter test process (0 = all passed, non-0 = some failed)
  final int exitCode;

  /// stdout ทั้งหมดจาก flutter test (ใช้สำหรับ parse และ log)
  final String stdout;

  /// stderr จาก flutter test (ใช้สำหรับ error reporting)
  final String stderr;

  /// รายการ test cases พร้อม status ('passed' | 'failed')
  final List<Map<String, dynamic>> testCases;

  /// จำนวน tests ที่ผ่าน
  final int passed;

  /// จำนวน tests ที่ไม่ผ่าน
  final int failed;

  const TestRunResult({
    required this.exitCode,
    required this.stdout,
    required this.stderr,
    required this.testCases,
    required this.passed,
    required this.failed,
  });
}

// =============================================================================
// CLASS: CoverageRunner
// =============================================================================

/// Runner class สำหรับจัดการ Test Execution และ Coverage Report Generation
///
/// แยก logic การรัน test ออกจาก [PipelineController] เพื่อ:
/// - ให้ Sequence Diagram แสดง method calls ที่ชัดเจน
/// - แยก responsibility: Controller orchestrate, Runner execute
/// - ง่ายต่อการทดสอบและ mock
///
/// ตาม Package Diagram จัดอยู่ใน:
///   Domain > Runner
///
/// เทียบกับ Reference Architecture:
///   - คล้าย TestDataGenerator แต่ focus ที่ CLI tool execution
///   - เป็น Runner layer ใหม่ระหว่าง Controller กับ External Tools
class CoverageRunner {
  /// Path ของ flutter executable (override ได้สำหรับ testing)
  final String flutterBin;

  const CoverageRunner({this.flutterBin = 'flutter'});

  // ---------------------------------------------------------------------------
  // Step 0: clearCoverage
  // ---------------------------------------------------------------------------

  /// ลบ coverage folder เก่าออกก่อนรันใหม่
  ///
  /// เรียกก่อน [runFlutterTest] เสมอ เพื่อป้องกันการนำ coverage data เก่า
  /// มาปะปนกับผลใหม่
  ///
  /// ไม่ throw exception ถ้า folder ไม่มีอยู่ (idempotent)
  Future<void> clearCoverage() async {
    final coverageDir = Directory('coverage');
    if (await coverageDir.exists()) {
      await coverageDir.delete(recursive: true);
      print('  ✓ Cleared old coverage data');
    }
  }

  // ---------------------------------------------------------------------------
  // Step 1: findMobileDevice
  // ---------------------------------------------------------------------------

  /// ค้นหา device/emulator สำหรับ integration test
  ///
  /// ใช้ `flutter devices --machine` เพื่อดึงรายการ devices แล้ว prefer emulator
  /// ข้าม web และ desktop devices (focus เฉพาะ android/ios)
  ///
  /// Returns: device ID ที่พบ หรือ null ถ้าไม่มี mobile device
  Future<String?> findMobileDevice() async {
    final devicesResult =
        await Process.run(flutterBin, ['devices', '--machine']);

    if (devicesResult.exitCode != 0) {
      print('  ✗ Failed to list devices');
      return null;
    }

    try {
      final devices = jsonDecode(devicesResult.stdout.toString()) as List;
      String? deviceId;

      for (final device in devices) {
        if (device is! Map) continue;

        final isEmulator = device['emulator'] == true;
        final isSupported = device['isSupported'] == true;
        final id = device['id'] as String?;
        final targetPlatform = device['targetPlatform'] as String? ?? '';

        // ข้าม web และ desktop — เลือกเฉพาะ android/ios
        final isMobile = targetPlatform.contains('android') ||
            targetPlatform.contains('ios');

        if (isSupported && isMobile && id != null) {
          deviceId = id;
          if (isEmulator) break; // prefer emulator มากกว่า physical device
        }
      }

      if (deviceId != null) {
        print('  > Using device: $deviceId');
      } else {
        print('  ⚠ No mobile device/emulator found, running on VM');
      }

      return deviceId;
    } catch (e) {
      print('  ✗ Failed to parse devices: $e');
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Step 2: runFlutterTest
  // ---------------------------------------------------------------------------

  /// รัน flutter test แล้วคืน [TestRunResult]
  ///
  /// Parameters:
  ///   [testScript]    - path ของ test file เช่น 'test/buttons_page_flow_test.dart'
  ///   [withCoverage]  - true = เพิ่ม --coverage flag เพื่อสร้าง lcov.info
  ///   [deviceId]      - device ID สำหรับ integration test (จาก [findMobileDevice])
  ///   [timeoutSeconds] - timeout (default: 300s widget test, 600s integration test)
  ///
  /// Returns: [TestRunResult] พร้อม exit code, stdout, stderr, parsed test cases
  Future<TestRunResult> runFlutterTest(
    String testScript,
    bool withCoverage, {
    String? deviceId,
    int? timeoutSeconds,
  }) async {
    // สร้าง arguments สำหรับ flutter test command
    final args = ['test', testScript];
    if (withCoverage) args.add('--coverage');
    if (deviceId != null) args.addAll(['-d', deviceId]);

    // กำหนด timeout: integration test ใช้เวลานานกว่า widget test
    final timeout =
        timeoutSeconds ?? (deviceId != null ? 600 : 300);

    print('  > $flutterBin ${args.join(' ')}');

    final result = await Process.run(
      flutterBin,
      args,
      workingDirectory: Directory.current.path,
    ).timeout(
      Duration(seconds: timeout),
      onTimeout: () =>
          ProcessResult(0, -1, '', 'Test timeout after $timeout seconds'),
    );

    final output = result.stdout.toString();
    final testCases = _parseTestCases(output);

    // นับจำนวน passed / failed จาก summary line
    final passedMatch = RegExp(r'(\d+) tests? passed').firstMatch(output);
    final failedMatch = RegExp(r'(\d+) tests? failed').firstMatch(output);

    return TestRunResult(
      exitCode: result.exitCode,
      stdout: output,
      stderr: result.stderr.toString(),
      testCases: testCases,
      passed: passedMatch != null ? int.parse(passedMatch.group(1)!) : 0,
      failed: failedMatch != null ? int.parse(failedMatch.group(1)!) : 0,
    );
  }

  // ---------------------------------------------------------------------------
  // Step 3: generateCoverageReport
  // ---------------------------------------------------------------------------

  /// สร้าง HTML Coverage Report จาก lcov.info
  ///
  /// ลำดับการทำงาน:
  ///   1. [_waitForLcovFile]      - รอให้ flutter test เขียน coverage/lcov.info เสร็จ
  ///   2. [_filterCubitCoverage]  - ใช้ lcov --remove กรอง */cubit/* ออก (UI-only)
  ///   3. [_runGenHtml]           - ใช้ genhtml แปลง lcov → coverage/html/index.html
  ///
  /// Returns: path ของ HTML report ('coverage/html/index.html') หรือ null ถ้าล้มเหลว
  Future<String?> generateCoverageReport() async {
    print('  > Waiting for coverage/lcov.info...');

    // Step 3a: รอให้ lcov.info ถูกสร้างและมี content
    final lcovReady = await _waitForLcovFile();
    if (!lcovReady) {
      print('  ✗ lcov.info not found or empty after retries');
      return null;
    }

    // Step 3b: กรอง cubit files ออก → ได้ UI-only coverage
    final lcovForHtml = await _filterCubitCoverage();

    // Step 3c: แปลง lcov → HTML
    return await _runGenHtml(lcovForHtml);
  }

  // ---------------------------------------------------------------------------
  // Step 4: openCoverageReport
  // ---------------------------------------------------------------------------

  /// เปิด Coverage HTML Report ใน browser ของ user
  ///
  /// รองรับ macOS (open), Windows (start), Linux (xdg-open)
  ///
  /// Parameter:
  ///   [url] - URL ของ coverage report เช่น 'http://localhost:8080/coverage/index.html'
  Future<void> openCoverageReport(String url) async {
    print('  > open $url');

    if (Platform.isMacOS) {
      await Process.run('open', [url]);
    } else if (Platform.isWindows) {
      await Process.run('start', [url], runInShell: true);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', [url]);
    }

    print('  ✓ Opened coverage report in browser');
  }

  // ===========================================================================
  // PRIVATE HELPERS
  // ===========================================================================

  // ---------------------------------------------------------------------------
  // _parseTestCases: parse test output → List of {name, status}
  // ---------------------------------------------------------------------------

  /// Parse Flutter test output เพื่อดึงรายชื่อ test cases และ status
  ///
  /// Flutter test output format:
  ///   "00:01 +1: Case 1: Submit with valid data"          (passed)
  ///   "00:02 +1 -1: Case 2: Submit with invalid data [E]" (failed)
  ///
  /// ใช้ delta ของ fail count (ไม่ใช่ cumulative) เพื่อตรวจ test ที่ fail
  List<Map<String, dynamic>> _parseTestCases(String output) {
    final testCases = <Map<String, dynamic>>[];

    // Pattern จับ: timestamp + passCount + (failCount)? + testName
    final testCaseRegex = RegExp(
        r'^\d{2}:\d{2}\s+\+(\d+)(?:\s+-(\d+))?:\s+(.+)$',
        multiLine: true);

    int prevFailCount = 0;

    for (final match in testCaseRegex.allMatches(output)) {
      final testName = match.group(3)?.trim() ?? '';

      // กรองบรรทัดที่ไม่ใช่ test case จริง
      if (testName.isEmpty ||
          testName.startsWith('loading') ||
          testName.contains('All tests passed') ||
          testName.contains('Some tests failed')) {
        continue;
      }

      // คำนวณ delta เพื่อตรวจว่า test นี้ fail หรือไม่
      final currFailCount = int.tryParse(match.group(2) ?? '0') ?? 0;
      final thisTestFailed = currFailCount > prevFailCount;

      // Normalize: strip Flutter's " [E]" suffix จาก failed test names
      final normalizedName = testName.endsWith(' [E]')
          ? testName.substring(0, testName.length - 4)
          : testName;

      final idx = testCases.indexWhere((tc) => tc['name'] == normalizedName);
      if (idx == -1) {
        testCases.add({
          'name': normalizedName,
          'status': thisTestFailed ? 'failed' : 'passed',
        });
      } else if (thisTestFailed) {
        testCases[idx]['status'] = 'failed';
      }

      if (currFailCount > prevFailCount) prevFailCount = currFailCount;
    }

    return testCases;
  }

  // ---------------------------------------------------------------------------
  // _waitForLcovFile: retry loop รอ coverage/lcov.info
  // ---------------------------------------------------------------------------

  /// รอให้ Flutter เขียน coverage/lcov.info เสร็จ
  ///
  /// บางครั้ง flutter test process จบแล้วแต่ไฟล์ยังเขียนไม่เสร็จ
  /// จึงต้อง retry ด้วย delay
  ///
  /// Returns: true ถ้า lcov.info พร้อม, false ถ้า timeout
  Future<bool> _waitForLcovFile({
    int maxRetries = 10,
    Duration retryDelay = const Duration(milliseconds: 500),
  }) async {
    final lcovFile = File('coverage/lcov.info');

    for (int retries = 0; retries < maxRetries; retries++) {
      if (await lcovFile.exists()) {
        final content = await lcovFile.readAsString();
        if (content.isNotEmpty) {
          print('  ✓ Found lcov.info');
          return true;
        }
      }
      await Future.delayed(retryDelay);
      print('  ... waiting for lcov.info (${ retries + 1}/$maxRetries)');
    }

    return false;
  }

  // ---------------------------------------------------------------------------
  // _filterCubitCoverage: lcov --remove */cubit/*
  // ---------------------------------------------------------------------------

  /// กรอง cubit/state files ออกจาก coverage data
  ///
  /// เหตุผล: coverage ที่ต้องการ focus เฉพาะ UI layer (lib/demos/)
  /// ไม่รวม business logic layer (lib/cubit/)
  ///
  /// ใช้: `lcov --remove coverage/lcov.info */cubit/* -o coverage/lcov_ui_only.info`
  ///
  /// Returns: path ของ lcov file ที่จะใช้ต่อ
  ///   - 'coverage/lcov_ui_only.info' ถ้า filter สำเร็จ
  ///   - 'coverage/lcov.info' (fallback) ถ้า filter ล้มเหลว
  Future<String> _filterCubitCoverage() async {
    const inputLcov = 'coverage/lcov.info';
    const outputLcov = 'coverage/lcov_ui_only.info';

    print('  > lcov --remove $inputLcov */cubit/* -o $outputLcov');

    final result = await Process.run('lcov', [
      '--remove',
      inputLcov,
      '*/cubit/*',
      '-o',
      outputLcov,
    ]);

    if (result.exitCode == 0) {
      print('  ✓ Filtered cubit files from coverage (UI-only)');
      return outputLcov;
    } else {
      print('  ⚠ lcov filter failed, using unfiltered coverage');
      return inputLcov;
    }
  }

  // ---------------------------------------------------------------------------
  // _runGenHtml: genhtml → coverage/html/index.html
  // ---------------------------------------------------------------------------

  /// แปลง lcov.info เป็น HTML coverage report
  ///
  /// ใช้: `genhtml <lcovFile> -o coverage/html`
  ///
  /// Parameter:
  ///   [lcovFile] - path ของ lcov file (จาก [_filterCubitCoverage])
  ///
  /// Returns: 'coverage/html/index.html' ถ้าสำเร็จ, null ถ้า genhtml ล้มเหลว
  Future<String?> _runGenHtml(String lcovFile) async {
    const outputDir = 'coverage/html';
    const outputIndex = '$outputDir/index.html';

    print('  > genhtml $lcovFile -o $outputDir');

    final result = await Process.run('genhtml', [lcovFile, '-o', outputDir]);

    if (result.exitCode == 0) {
      print('  ✓ Coverage HTML generated: $outputIndex');
      return outputIndex;
    } else {
      print('  ✗ genhtml failed: ${result.stderr}');
      return null;
    }
  }
}
