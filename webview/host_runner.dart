// =============================================================================
// host_runner.dart
// =============================================================================
// HTTP server รันบน HOST machine (ไม่ใช่ใน Docker)
// Port 8089 — รับ flutter test requests จาก Docker container
//
// วิธีใช้: เรียกโดย run_tool.sh อัตโนมัติ
//   dart run webview/host_runner.dart /path/to/flutter_project
//
// Endpoints:
//   GET  /health     → { "status": "ok" }
//   POST /run-tests  → รัน flutter test, คืน {exitCode, stdout, stderr,
//                       testCases, passed, failed}
// =============================================================================

import 'dart:convert';
import 'dart:io';

const int _port = 8089;

void main(List<String> args) async {
  if (args.isEmpty) {
    stderr.writeln('Usage: dart run webview/host_runner.dart <project_dir>');
    exit(1);
  }

  final projectDir = args[0];
  if (!Directory(projectDir).existsSync()) {
    stderr.writeln('[host_runner] ERROR: Project directory not found: $projectDir');
    exit(1);
  }

  final server = await HttpServer.bind(InternetAddress.anyIPv4, _port);
  print('[host_runner] Listening on http://0.0.0.0:$_port');
  print('[host_runner] Project dir: $projectDir');

  await for (final request in server) {
    request.response.headers.add('Access-Control-Allow-Origin', '*');
    request.response.headers
        .add('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    request.response.headers
        .add('Access-Control-Allow-Headers', 'Content-Type');

    if (request.method == 'OPTIONS') {
      request.response.statusCode = 200;
      await request.response.close();
      continue;
    }

    request.response.headers.contentType = ContentType.json;

    try {
      switch (request.uri.path) {
        case '/health':
          request.response.write(jsonEncode({'status': 'ok'}));
          await request.response.close();
        case '/run-tests':
          if (request.method == 'POST') {
            await _handleRunTests(request, projectDir);
          } else {
            request.response.statusCode = 405;
            request.response.write(jsonEncode({'error': 'Method not allowed'}));
            await request.response.close();
          }
        default:
          request.response.statusCode = 404;
          request.response.write(jsonEncode({'error': 'Not found'}));
          await request.response.close();
      }
    } catch (e, st) {
      stderr.writeln('[host_runner] Unhandled error: $e\n$st');
      try {
        request.response.statusCode = 500;
        request.response.write(jsonEncode({'error': e.toString()}));
        await request.response.close();
      } catch (_) {}
    }
  }
}

Future<void> _handleRunTests(HttpRequest request, String projectDir) async {
  final content = await utf8.decoder.bind(request).join();
  final body = content.isNotEmpty
      ? jsonDecode(content) as Map<String, dynamic>
      : <String, dynamic>{};

  final testScript = body['testScript'] as String?;
  final withCoverage = body['withCoverage'] as bool? ?? false;

  if (testScript == null || testScript.isEmpty) {
    request.response.statusCode = 400;
    request.response.write(jsonEncode({'error': 'testScript required'}));
    await request.response.close();
    return;
  }

  print('[host_runner] run-tests: $testScript withCoverage=$withCoverage');

  final deviceId = await _findMobileDevice();

  final args = ['test', testScript];
  if (withCoverage) args.add('--coverage');
  if (deviceId != null) args.addAll(['-d', deviceId]);

  print('[host_runner] flutter ${args.join(' ')} (workdir: $projectDir)');

  ProcessResult result;
  try {
    result = await Process.run(
      'flutter',
      args,
      workingDirectory: projectDir,
    ).timeout(
      const Duration(seconds: 1800),
      onTimeout: () => ProcessResult(0, -1, '', 'Test timeout after 1800 seconds'),
    );
  } catch (e) {
    result = ProcessResult(0, -1, '', e.toString());
  }

  final output = result.stdout.toString();
  final errOutput = result.stderr.toString();
  final testCases = _parseTestCases(output);

  final passedMatch = RegExp(r'(\d+) tests? passed').firstMatch(output);
  final failedMatch = RegExp(r'(\d+) tests? failed').firstMatch(output);
  final passed = passedMatch != null ? int.parse(passedMatch.group(1)!) : 0;
  final failed = failedMatch != null ? int.parse(failedMatch.group(1)!) : 0;

  print('[host_runner] done: exitCode=${result.exitCode} '
      'passed=$passed failed=$failed testCases=${testCases.length}');

  request.response.write(jsonEncode({
    'exitCode': result.exitCode,
    'stdout': output,
    'stderr': errOutput,
    'testCases': testCases,
    'passed': passed,
    'failed': failed,
  }));
  await request.response.close();
}

Future<String?> _findMobileDevice() async {
  try {
    final result = await Process.run('flutter', ['devices', '--machine']);
    if (result.exitCode != 0) return null;

    final devices = jsonDecode(result.stdout.toString()) as List;
    String? deviceId;

    for (final device in devices) {
      if (device is! Map) continue;

      final isEmulator = device['emulator'] == true;
      final isSupported = device['isSupported'] == true;
      final id = device['id'] as String?;
      final platform = device['targetPlatform'] as String? ?? '';
      final isMobile =
          platform.contains('android') || platform.contains('ios');

      if (isSupported && isMobile && id != null) {
        deviceId = id;
        if (isEmulator) break;
      }
    }

    if (deviceId != null) {
      print('[host_runner] Using device: $deviceId');
    } else {
      print('[host_runner] No mobile device found, running without -d flag');
    }

    return deviceId;
  } catch (e) {
    stderr.writeln('[host_runner] Failed to list devices: $e');
    return null;
  }
}

List<Map<String, dynamic>> _parseTestCases(String output) {
  final testCases = <Map<String, dynamic>>[];
  final testCaseRegex = RegExp(
    r'^\d{2}:\d{2}\s+\+(\d+)(?:\s+-(\d+))?:\s+(.+)$',
    multiLine: true,
  );

  int prevFailCount = 0;

  for (final match in testCaseRegex.allMatches(output)) {
    final testName = match.group(3)?.trim() ?? '';

    if (testName.isEmpty ||
        testName.startsWith('loading') ||
        testName.contains('All tests passed') ||
        testName.contains('Some tests failed')) {
      continue;
    }

    final currFailCount = int.tryParse(match.group(2) ?? '0') ?? 0;
    final thisTestFailed = currFailCount > prevFailCount;

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
