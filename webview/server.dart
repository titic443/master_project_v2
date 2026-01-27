import 'dart:convert';
import 'dart:io';

/// Simple HTTP server for Flutter Test Generator WebView
void main() async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  print('Server running at http://localhost:8080');
  print('Open webview/index.html in your browser\n');

  await for (final request in server) {
    // CORS headers
    request.response.headers.add('Access-Control-Allow-Origin', '*');
    request.response.headers.add('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    request.response.headers.add('Access-Control-Allow-Headers', 'Content-Type');

    // Handle preflight
    if (request.method == 'OPTIONS') {
      request.response.statusCode = 200;
      await request.response.close();
      continue;
    }

    try {
      await handleRequest(request);
    } catch (e, stackTrace) {
      print('Error: $e');
      print(stackTrace);
      request.response.statusCode = 500;
      request.response.write(jsonEncode({'error': e.toString()}));
      await request.response.close();
    }
  }
}

Future<void> handleRequest(HttpRequest request) async {
  final path = request.uri.path;
  final method = request.method;

  print('[$method] $path');

  request.response.headers.contentType = ContentType.json;

  switch (path) {
    case '/files':
      await handleGetFiles(request);
      break;
    case '/test-scripts':
      await handleGetTestScripts(request);
      break;
    case '/find-file':
      await handleFindFile(request);
      break;
    case '/scan':
      await handleScan(request);
      break;
    case '/extract-manifest':
      await handleExtractManifest(request);
      break;
    case '/generate-datasets':
      await handleGenerateDatasets(request);
      break;
    case '/generate-test-data':
      await handleGenerateTestData(request);
      break;
    case '/generate-test-script':
      await handleGenerateTestScript(request);
      break;
    case '/run-tests':
      await handleRunTests(request);
      break;
    case '/generate-all':
      await handleGenerateAll(request);
      break;
    case '/open-coverage':
      await handleOpenCoverage(request);
      break;
    default:
      // Serve coverage files
      if (path.startsWith('/coverage/')) {
        await serveCoverageFile(request);
        return;
      }
      // Serve static files
      await serveStaticFile(request);
  }
}

/// Get list of available Dart files in lib/demos/
Future<void> handleGetFiles(HttpRequest request) async {
  final demosDir = Directory('lib/demos');
  final files = <String>[];

  if (await demosDir.exists()) {
    await for (final entity in demosDir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        files.add(entity.path);
      }
    }
  }

  request.response.write(jsonEncode({'files': files}));
  await request.response.close();
}

/// Get list of available test scripts in integration_test/
Future<void> handleGetTestScripts(HttpRequest request) async {
  final testDir = Directory('integration_test');
  final files = <String>[];

  if (await testDir.exists()) {
    await for (final entity in testDir.list()) {
      if (entity is File && entity.path.endsWith('_flow_test.dart')) {
        files.add(entity.path);
      }
    }
  }

  request.response.write(jsonEncode({'files': files}));
  await request.response.close();
}

/// Find file path by matching filename and content
Future<void> handleFindFile(HttpRequest request) async {
  final body = await readBody(request);
  final fileName = body['fileName'] as String?;
  final content = body['content'] as String?;

  if (fileName == null) {
    request.response.statusCode = 400;
    request.response.write(jsonEncode({'error': 'fileName required'}));
    await request.response.close();
    return;
  }

  // Search in lib/ directory
  final libDir = Directory('lib');
  String? foundPath;

  if (await libDir.exists()) {
    await for (final entity in libDir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith(fileName)) {
        // If content provided, verify it matches
        if (content != null) {
          final fileContent = await entity.readAsString();
          if (fileContent == content) {
            foundPath = entity.path;
            break;
          }
        } else {
          foundPath = entity.path;
          break;
        }
      }
    }
  }

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

/// Scan widgets in a file
Future<void> handleScan(HttpRequest request) async {
  final body = await readBody(request);
  final file = body['file'] as String?;

  if (file == null || file.isEmpty) {
    request.response.statusCode = 400;
    request.response.write(jsonEncode({'error': 'File path required'}));
    await request.response.close();
    return;
  }

  // Run extract_ui_manifest.dart
  final result = await runDartScript(
    'tools/script_v2/extract_ui_manifest.dart',
    [file],
  );

  if (result.exitCode == 0) {
    // Parse manifest to get widget count
    final baseName = file.split('/').last.replaceAll('.dart', '');
    final manifestPath = 'output/manifest/demos/$baseName.manifest.json';
    int widgetCount = 0;

    final manifestFile = File(manifestPath);
    if (await manifestFile.exists()) {
      try {
        final content = jsonDecode(await manifestFile.readAsString());
        widgetCount = (content['widgets'] as List?)?.length ?? 0;
      } catch (e) {
        // Ignore parse errors
      }
    }

    request.response.write(jsonEncode({
      'success': true,
      'widgetCount': widgetCount,
      'manifestPath': manifestPath,
    }));
  } else {
    request.response.write(jsonEncode({
      'success': false,
      'error': result.stderr.isNotEmpty ? result.stderr : result.stdout,
    }));
  }

  await request.response.close();
}

/// Extract UI manifest
Future<void> handleExtractManifest(HttpRequest request) async {
  final body = await readBody(request);
  final file = body['file'] as String?;

  if (file == null) {
    request.response.statusCode = 400;
    request.response.write(jsonEncode({'error': 'File path required'}));
    await request.response.close();
    return;
  }

  final result = await runDartScript(
    'tools/script_v2/extract_ui_manifest.dart',
    [file],
  );

  if (result.exitCode == 0) {
    final baseName = file.split('/').last.replaceAll('.dart', '');
    final manifestPath = 'output/manifest/demos/$baseName.manifest.json';

    request.response.write(jsonEncode({
      'success': true,
      'manifestPath': manifestPath,
      'output': result.stdout,
    }));
  } else {
    request.response.write(jsonEncode({
      'success': false,
      'error': result.stderr.isNotEmpty ? result.stderr : result.stdout,
    }));
  }

  await request.response.close();
}

/// Generate datasets using AI
Future<void> handleGenerateDatasets(HttpRequest request) async {
  final body = await readBody(request);
  final manifest = body['manifest'] as String?;

  if (manifest == null) {
    request.response.statusCode = 400;
    request.response.write(jsonEncode({'error': 'Manifest path required'}));
    await request.response.close();
    return;
  }

  final result = await runDartScript(
    'tools/script_v2/generate_datasets.dart',
    [manifest],
  );

  // Check if skipped due to no text fields
  if (result.stdout.contains('No TextField') || result.stdout.contains('No text')) {
    request.response.write(jsonEncode({
      'success': true,
      'skipped': true,
    }));
    await request.response.close();
    return;
  }

  if (result.exitCode == 0) {
    final baseName = manifest.split('/').last.replaceAll('.manifest.json', '');
    final datasetsPath = 'output/test_data/$baseName.datasets.json';

    request.response.write(jsonEncode({
      'success': true,
      'datasetsPath': datasetsPath,
      'output': result.stdout,
    }));
  } else {
    request.response.write(jsonEncode({
      'success': false,
      'error': result.stderr.isNotEmpty ? result.stderr : result.stdout,
    }));
  }

  await request.response.close();
}

/// Generate test data using PICT
Future<void> handleGenerateTestData(HttpRequest request) async {
  final body = await readBody(request);
  final manifest = body['manifest'] as String?;

  if (manifest == null) {
    request.response.statusCode = 400;
    request.response.write(jsonEncode({'error': 'Manifest path required'}));
    await request.response.close();
    return;
  }

  final result = await runDartScript(
    'tools/script_v2/generate_test_data.dart',
    [manifest],
  );

  if (result.exitCode == 0) {
    final baseName = manifest.split('/').last.replaceAll('.manifest.json', '');
    final testDataPath = 'output/test_data/$baseName.testdata.json';

    request.response.write(jsonEncode({
      'success': true,
      'testDataPath': testDataPath,
      'output': result.stdout,
    }));
  } else {
    request.response.write(jsonEncode({
      'success': false,
      'error': result.stderr.isNotEmpty ? result.stderr : result.stdout,
    }));
  }

  await request.response.close();
}

/// Generate test script
Future<void> handleGenerateTestScript(HttpRequest request) async {
  final body = await readBody(request);
  final testData = body['testData'] as String?;

  if (testData == null) {
    request.response.statusCode = 400;
    request.response.write(jsonEncode({'error': 'Test data path required'}));
    await request.response.close();
    return;
  }

  final result = await runDartScript(
    'tools/script_v2/generate_test_script.dart',
    [testData],
  );

  if (result.exitCode == 0) {
    final baseName = testData.split('/').last.replaceAll('.testdata.json', '');
    final testScriptPath = 'integration_test/${baseName}_flow_test.dart';

    request.response.write(jsonEncode({
      'success': true,
      'testScriptPath': testScriptPath,
      'output': result.stdout,
    }));
  } else {
    request.response.write(jsonEncode({
      'success': false,
      'error': result.stderr.isNotEmpty ? result.stderr : result.stdout,
    }));
  }

  await request.response.close();
}

/// Run Flutter tests
Future<void> handleRunTests(HttpRequest request) async {
  final body = await readBody(request);
  final testScript = body['testScript'] as String?;
  final withCoverage = body['withCoverage'] as bool? ?? false;

  if (testScript == null) {
    request.response.statusCode = 400;
    request.response.write(jsonEncode({'error': 'Test script path required'}));
    await request.response.close();
    return;
  }

  // Step 1: Run flutter test
  final args = ['test', testScript];
  if (withCoverage) {
    args.add('--coverage');
  }

  print('  > flutter ${args.join(' ')}');
  final result = await Process.run('flutter', args);

  // Parse test results
  final output = result.stdout.toString();
  final passedMatch = RegExp(r'(\d+) tests? passed').firstMatch(output);
  final failedMatch = RegExp(r'(\d+) tests? failed').firstMatch(output);

  String? coverageHtmlPath;
  String coverageOutput = '';

  // Step 2: Generate HTML coverage report (if coverage enabled)
  if (withCoverage) {
    print('  > Checking coverage/lcov.info...');
    final lcovFile = File('coverage/lcov.info');

    if (await lcovFile.exists()) {
      print('  ✓ Found lcov.info');

      // Run genhtml to generate HTML report
      print('  > genhtml coverage/lcov.info -o coverage/html');
      final genHtmlResult = await Process.run(
        'genhtml',
        ['coverage/lcov.info', '-o', 'coverage/html'],
      );

      if (genHtmlResult.exitCode == 0) {
        coverageHtmlPath = 'coverage/html/index.html';
        coverageOutput = genHtmlResult.stdout.toString();
        print('  ✓ Coverage HTML generated: $coverageHtmlPath');

        // Step 3: Open coverage report in browser
        print('  > open coverage/html/index.html');
        if (Platform.isMacOS) {
          await Process.run('open', ['coverage/html/index.html']);
        } else if (Platform.isWindows) {
          await Process.run('start', ['coverage/html/index.html'], runInShell: true);
        } else if (Platform.isLinux) {
          await Process.run('xdg-open', ['coverage/html/index.html']);
        }
        print('  ✓ Opened coverage report in browser');
      } else {
        coverageOutput = 'genhtml failed: ${genHtmlResult.stderr}';
        print('  ✗ genhtml failed: ${genHtmlResult.stderr}');
      }
    } else {
      print('  ✗ lcov.info not found - coverage may not have been generated');
    }
  }

  request.response.write(jsonEncode({
    'success': result.exitCode == 0,
    'passed': passedMatch != null ? int.parse(passedMatch.group(1)!) : 0,
    'failed': failedMatch != null ? int.parse(failedMatch.group(1)!) : 0,
    'output': output,
    'error': result.stderr.toString(),
    'coverageHtmlPath': coverageHtmlPath,
    'coverageOutput': coverageOutput,
  }));

  await request.response.close();
}

/// Generate tests for all files
Future<void> handleGenerateAll(HttpRequest request) async {
  final body = await readBody(request);
  final skipDatasets = body['skipDatasets'] as bool? ?? false;

  int filesProcessed = 0;
  int testsGenerated = 0;

  // Step 1: Extract all manifests
  var result = await runDartScript(
    'tools/script_v2/extract_ui_manifest.dart',
    [],
  );
  if (result.exitCode != 0) {
    request.response.write(jsonEncode({
      'success': false,
      'error': 'Failed to extract manifests',
    }));
    await request.response.close();
    return;
  }

  // Step 2: Generate datasets (if not skipped)
  if (!skipDatasets) {
    result = await runDartScript(
      'tools/script_v2/generate_datasets.dart',
      [],
    );
  }

  // Step 3: Generate test data
  result = await runDartScript(
    'tools/script_v2/generate_test_data.dart',
    [],
  );
  if (result.exitCode != 0) {
    request.response.write(jsonEncode({
      'success': false,
      'error': 'Failed to generate test data',
    }));
    await request.response.close();
    return;
  }

  // Step 4: Generate test scripts
  result = await runDartScript(
    'tools/script_v2/generate_test_script.dart',
    [],
  );

  // Count generated files
  final manifestDir = Directory('output/manifest');
  if (await manifestDir.exists()) {
    await for (final entity in manifestDir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.manifest.json')) {
        filesProcessed++;
      }
    }
  }

  final testDir = Directory('integration_test');
  if (await testDir.exists()) {
    await for (final entity in testDir.list()) {
      if (entity is File && entity.path.endsWith('_flow_test.dart')) {
        testsGenerated++;
      }
    }
  }

  request.response.write(jsonEncode({
    'success': true,
    'filesProcessed': filesProcessed,
    'testsGenerated': testsGenerated,
  }));

  await request.response.close();
}

/// Open coverage report or folder
Future<void> handleOpenCoverage(HttpRequest request) async {
  final body = await readBody(request);
  final action = body['action'] as String? ?? 'view';

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

  if (action == 'folder') {
    // Open coverage folder in file explorer
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
    // Return URL to view coverage
    request.response.write(jsonEncode({
      'success': true,
      'url': 'http://localhost:8080/coverage/index.html',
      'path': coveragePath,
    }));
  }

  await request.response.close();
}

/// Serve coverage HTML files
Future<void> serveCoverageFile(HttpRequest request) async {
  var path = request.uri.path;
  // /coverage/index.html -> coverage/html/index.html
  final filePath = path.replaceFirst('/coverage/', 'coverage/html/');

  final file = File(filePath);
  if (await file.exists()) {
    final ext = path.split('.').last;
    final contentType = switch (ext) {
      'html' => ContentType.html,
      'css' => ContentType('text', 'css'),
      'js' => ContentType('application', 'javascript'),
      'png' => ContentType('image', 'png'),
      'gif' => ContentType('image', 'gif'),
      'svg' => ContentType('image', 'svg+xml'),
      _ => ContentType.binary,
    };

    request.response.headers.contentType = contentType;
    await file.openRead().pipe(request.response);
  } else {
    request.response.statusCode = 404;
    request.response.write('Coverage file not found: $filePath');
    await request.response.close();
  }
}

/// Serve static files (HTML, CSS, JS)
Future<void> serveStaticFile(HttpRequest request) async {
  var path = request.uri.path;
  if (path == '/') path = '/index.html';

  final file = File('webview$path');
  if (await file.exists()) {
    final ext = path.split('.').last;
    final contentType = switch (ext) {
      'html' => ContentType.html,
      'css' => ContentType('text', 'css'),
      'js' => ContentType('application', 'javascript'),
      _ => ContentType.binary,
    };

    request.response.headers.contentType = contentType;
    await file.openRead().pipe(request.response);
  } else {
    request.response.statusCode = 404;
    request.response.write('Not found: $path');
    await request.response.close();
  }
}

/// Read JSON body from request
Future<Map<String, dynamic>> readBody(HttpRequest request) async {
  if (request.method != 'POST') return {};

  try {
    final content = await utf8.decoder.bind(request).join();
    if (content.isEmpty) return {};
    return jsonDecode(content) as Map<String, dynamic>;
  } catch (e) {
    return {};
  }
}

/// Run a Dart script and return result
Future<ProcessResult> runDartScript(String script, List<String> args) async {
  print('  > dart run $script ${args.join(' ')}');
  final result = await Process.run(
    'dart',
    ['run', script, ...args],
    workingDirectory: Directory.current.path,
  );
  return result;
}
