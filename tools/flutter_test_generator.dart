// Flutter Test Generator - Unified CLI Tool
//
// Combines all test generation pipeline steps into a single command
//
// Usage:
//   dart run tools/flutter_test_generator.dart lib/demos/buttons_page.dart
//   dart run tools/flutter_test_generator.dart lib/demos/buttons_page.dart --skip-datasets
//   dart run tools/flutter_test_generator.dart lib/demos/buttons_page.dart --verbose
//   dart run tools/flutter_test_generator.dart --help

import 'dart:io';

// Import pipeline steps
import 'script_v2/extract_ui_manifest.dart' as step1;
import 'script_v2/generate_datasets.dart' as step2;
import 'script_v2/generate_test_data.dart' as step3;
import 'script_v2/generate_test_script.dart' as step4;
import 'script_v2/utils.dart' as utils;

void main(List<String> args) async {
  final options = _parseArgs(args);

  if (options.showHelp) {
    _printHelp();
    exit(0);
  }

  if (options.inputFile == null) {
    stderr.writeln('Error: Please specify a UI file to process');
    stderr.writeln('');
    _printHelp();
    exit(1);
  }

  try {
    await _runPipeline(options.inputFile!, options);
    exit(0);
  } catch (e, st) {
    stderr.writeln('');
    stderr.writeln('✗ Pipeline failed: $e');
    if (options.verbose) {
      stderr.writeln('');
      stderr.writeln('Stack trace:');
      stderr.writeln(st);
    }
    exit(1);
  }
}

class CLIOptions {
  String? inputFile;
  bool skipDatasets = false;
  bool verbose = false;
  bool showHelp = false;
  String? apiKey;
  String pictBin = './pict';
}

CLIOptions _parseArgs(List<String> args) {
  final options = CLIOptions();

  for (final arg in args) {
    if (arg == '--help' || arg == '-h') {
      options.showHelp = true;
    } else if (arg == '--skip-datasets') {
      options.skipDatasets = true;
    } else if (arg == '--verbose' || arg == '-v') {
      options.verbose = true;
    } else if (arg.startsWith('--api-key=')) {
      options.apiKey = arg.substring('--api-key='.length);
    } else if (arg.startsWith('--pict-bin=')) {
      options.pictBin = arg.substring('--pict-bin='.length);
    } else if (!arg.startsWith('--')) {
      options.inputFile = arg;
    } else {
      stderr.writeln('Warning: Unknown option: $arg');
    }
  }

  return options;
}

Future<void> _runPipeline(String inputFile, CLIOptions options) async {
  _printHeader();

  // Validate input file
  if (!File(inputFile).existsSync()) {
    throw Exception('File not found: $inputFile');
  }

  stdout.writeln('Processing: $inputFile');
  stdout.writeln('');

  // Step 1: Extract manifest
  _logStep(1, 'Extracting UI manifest', options);
  final manifestPath = step1.processUiFile(inputFile);
  _logSuccess('Manifest: $manifestPath', options);

  // Step 2: Generate datasets (optional)
  String? datasetsPath;
  if (!options.skipDatasets) {
    _logStep(2, 'Generating datasets (AI)', options);
    try {
      datasetsPath = await step2.generateDatasetsFromManifest(
        manifestPath,
        apiKey: options.apiKey ?? utils.readApiKeyFromEnv(),
      );
      if (datasetsPath != null) {
        _logSuccess('Datasets: $datasetsPath', options);
      } else {
        _logSkip('No text fields found', options);
      }
    } catch (e) {
      if (e.toString().contains('API key')) {
        _logSkip('API key not found (use --api-key or .env)', options);
      } else {
        rethrow;
      }
    }
  } else {
    _logSkip('Step 2: Datasets generation skipped (--skip-datasets)', options);
  }

  // Step 3: Generate test data
  _logStep(3, 'Generating test plan (PICT)', options);
  final testDataPath = await step3.generateTestDataFromManifest(
    manifestPath,
    pictBin: options.pictBin,
  );
  _logSuccess('Test plan: $testDataPath', options);

  // Step 4: Generate test script
  _logStep(4, 'Generating test script', options);
  final testScriptPath = step4.generateTestScriptFromTestData(testDataPath);
  _logSuccess('Test file: $testScriptPath', options);

  // Final summary
  stdout.writeln('');
  stdout.writeln('━' * 60);
  stdout.writeln('✓ SUCCESS - Test generation complete!');
  stdout.writeln('━' * 60);
  stdout.writeln('');
  stdout.writeln('Next steps:');
  stdout.writeln('  flutter test $testScriptPath');
  stdout.writeln('');
}

void _printHeader() {
  stdout.writeln('');
  stdout.writeln('Flutter Test Generator');
  stdout.writeln('━' * 60);
  stdout.writeln('');
}

void _logStep(int step, String message, CLIOptions options) {
  stdout.write('[$step/4] $message... ');
  if (options.verbose) {
    stdout.writeln('');
  }
}

void _logSuccess(String message, CLIOptions options) {
  if (options.verbose) {
    stdout.writeln('  ✓ $message');
  } else {
    stdout.writeln('✓');
    stdout.writeln('  → $message');
  }
  stdout.writeln('');
}

void _logSkip(String message, CLIOptions options) {
  if (options.verbose) {
    stdout.writeln('  ⊘ $message');
  } else {
    stdout.writeln('⊘');
    stdout.writeln('  → $message');
  }
  stdout.writeln('');
}

void _printHelp() {
  stdout.writeln('Flutter Test Generator - Unified CLI Tool');
  stdout.writeln('');
  stdout.writeln('USAGE:');
  stdout.writeln('  dart run tools/flutter_test_generator.dart <UI_FILE> [OPTIONS]');
  stdout.writeln('');
  stdout.writeln('ARGUMENTS:');
  stdout.writeln('  <UI_FILE>              Path to Flutter UI file (e.g., lib/demos/buttons_page.dart)');
  stdout.writeln('');
  stdout.writeln('OPTIONS:');
  stdout.writeln('  --skip-datasets        Skip AI-powered dataset generation');
  stdout.writeln('  --verbose, -v          Show detailed logs');
  stdout.writeln('  --api-key=<KEY>        Gemini API key (overrides .env)');
  stdout.writeln('  --pict-bin=<PATH>      Path to PICT binary (default: ./pict)');
  stdout.writeln('  --help, -h             Show this help message');
  stdout.writeln('');
  stdout.writeln('EXAMPLES:');
  stdout.writeln('  # Basic usage');
  stdout.writeln('  dart run tools/flutter_test_generator.dart lib/demos/buttons_page.dart');
  stdout.writeln('');
  stdout.writeln('  # Skip AI dataset generation');
  stdout.writeln('  dart run tools/flutter_test_generator.dart lib/demos/buttons_page.dart --skip-datasets');
  stdout.writeln('');
  stdout.writeln('  # With verbose output');
  stdout.writeln('  dart run tools/flutter_test_generator.dart lib/demos/buttons_page.dart --verbose');
  stdout.writeln('');
  stdout.writeln('  # With custom API key');
  stdout.writeln('  dart run tools/flutter_test_generator.dart lib/demos/buttons_page.dart --api-key=YOUR_KEY');
  stdout.writeln('');
  stdout.writeln('PIPELINE STEPS:');
  stdout.writeln('  1. Extract UI manifest from source file');
  stdout.writeln('  2. Generate test datasets using AI (optional)');
  stdout.writeln('  3. Generate test plan using pairwise testing');
  stdout.writeln('  4. Generate Flutter test script');
  stdout.writeln('');
}
