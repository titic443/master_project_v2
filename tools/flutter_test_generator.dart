// Flutter Test Generator - Unified CLI Tool
//
// Combines all test generation pipeline steps into a single command
//
// Usage:
//   # Interactive mode (recommended)
//   dart run tools/flutter_test_generator.dart
//
//   # CLI mode with arguments
//   dart run tools/flutter_test_generator.dart lib/demos/buttons_page.dart
//   dart run tools/flutter_test_generator.dart lib/demos/buttons_page.dart --skip-datasets
//   dart run tools/flutter_test_generator.dart lib/demos/buttons_page.dart --verbose
//   dart run tools/flutter_test_generator.dart --help

import 'dart:convert';
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

  // Interactive mode if no input file provided
  if (options.inputFile == null) {
    try {
      final interactiveOptions = await _runInteractiveMode();
      await _runPipeline(interactiveOptions.inputFile!, interactiveOptions);
      exit(0);
    } catch (e, st) {
      stderr.writeln('');
      stderr.writeln('✗ Interactive mode cancelled or failed: $e');
      if (options.verbose) {
        stderr.writeln('');
        stderr.writeln('Stack trace:');
        stderr.writeln(st);
      }
      exit(1);
    }
  }

  // CLI mode with arguments
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
  bool useConstraints = false;
  String? constraintsContent;
  String? constraintsFile;
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
    } else if (arg == '--with-constraints') {
      options.useConstraints = true;
    } else if (arg.startsWith('--constraints-file=')) {
      options.constraintsFile = arg.substring('--constraints-file='.length);
      options.useConstraints = true;
    } else if (arg.startsWith('--constraints=')) {
      options.constraintsContent = arg.substring('--constraints='.length);
      options.useConstraints = true;
    } else if (!arg.startsWith('--')) {
      options.inputFile = arg;
    } else {
      stderr.writeln('Warning: Unknown option: $arg');
    }
  }

  return options;
}

/// Validate that UI file contains testable widgets with keys
/// Returns (isValid, widgetCount, errorMessage)
Future<(bool, int, String?)> _validateUiFile(String filePath) async {
  try {
    // Call extract_ui_manifest to scan widgets
    final manifestPath = step1.processUiFile(filePath);

    // Read generated manifest
    final manifestContent = File(manifestPath).readAsStringSync();
    final manifest = jsonDecode(manifestContent) as Map<String, dynamic>;
    final widgets = (manifest['widgets'] as List?) ?? [];

    if (widgets.isEmpty) {
      return (false, 0,
        'No testable widgets found in file.\n'
        '  The file must contain widgets with keys:\n'
        '    • TextField/TextFormField with key: Key(\'xxx\')\n'
        '    • Button/Dropdown/Radio with key: Key(\'xxx\')\n'
        '\n'
        '  Example:\n'
        '    TextField(key: Key(\'username_field\'), ...)\n'
        '    ElevatedButton(key: Key(\'submit_button\'), ...)'
      );
    }

    return (true, widgets.length, null);
  } catch (e) {
    return (false, 0, 'Failed to scan widgets: $e');
  }
}

/// Interactive mode - prompts user for all options
Future<CLIOptions> _runInteractiveMode() async {
  final options = CLIOptions();

  _printBanner();
  stdout.writeln('');
  stdout.writeln('This wizard will walk you through test generation setup.');
  stdout.writeln('Press ^C at any time to quit.');
  stdout.writeln('');

  // Question 1: UI file path
  options.inputFile = await _promptQuestion(
    'UI file to process (e.g., lib/demos/buttons_page.dart)',
    required: true,
  );

  // Validate file exists
  if (!File(options.inputFile!).existsSync()) {
    throw Exception('File not found: ${options.inputFile}');
  }

  // Validate file contains testable widgets
  stdout.writeln('');
  stdout.write('  Scanning widgets... ');
  final (isValid, widgetCount, errorMsg) = await _validateUiFile(options.inputFile!);

  if (!isValid) {
    stdout.writeln('✗\n');
    stderr.writeln('⚠ Warning: ${errorMsg ?? "No widgets found"}');
    stderr.writeln('');
    throw Exception('No testable widgets found in ${options.inputFile}');
  }

  stdout.writeln('✓');
  stdout.writeln('  ✓ UI file imported successfully');
  stdout.writeln('  → Found $widgetCount widget(s) with keys');
  stdout.writeln('');

  // Question 2: Skip datasets
  final skipDatasets = await _promptYesNo(
    'Skip AI dataset generation?',
    defaultValue: false,
  );
  options.skipDatasets = skipDatasets;

  // Question 3: Use constraints
  final useConstraints = await _promptYesNo(
    'Use PICT constraints?',
    defaultValue: false,
  );
  options.useConstraints = useConstraints;

  if (useConstraints) {
    // Question 4: Constraints source
    final constraintSource = await _promptChoice(
      'Load constraints from',
      choices: ['file', 'manual input'],
      defaultIndex: 0,
    );

    if (constraintSource == 'file') {
      // Auto-suggest file path based on input file
      final baseName = utils.basenameWithoutExtension(options.inputFile!);
      final suggestedPath = 'output/model_pairwise/$baseName.constraints.txt';

      options.constraintsFile = await _promptQuestion(
        'Constraints file path',
        defaultValue: suggestedPath,
      );

      // Validate file exists
      if (!File(options.constraintsFile!).existsSync()) {
        stdout.writeln('  ⚠ Warning: File does not exist yet: ${options.constraintsFile}');
        stdout.writeln('  You can create it before running the pipeline.');
      }
    } else {
      stdout.writeln('');
      stdout.writeln('Enter constraints (one per line, empty line to finish):');
      stdout.writeln('Example: IF [Type] = "RAID-5" THEN [Compression] = "Off";');
      stdout.writeln('');

      final lines = <String>[];
      while (true) {
        stdout.write('  ');
        final line = stdin.readLineSync();
        if (line == null || line.trim().isEmpty) break;
        lines.add(line);
      }
      options.constraintsContent = lines.join('\n');
    }
  }

  // Question 5: Verbose mode
  final verbose = await _promptYesNo(
    'Enable verbose logging?',
    defaultValue: false,
  );
  options.verbose = verbose;

  // Summary
  stdout.writeln('');
  stdout.writeln('━' * 60);
  stdout.writeln('Configuration Summary:');
  stdout.writeln('━' * 60);
  stdout.writeln('  UI file:        ${options.inputFile}');
  stdout.writeln('  Skip datasets:  ${options.skipDatasets}');
  stdout.writeln('  Use constraints: ${options.useConstraints}');
  if (options.useConstraints) {
    if (options.constraintsFile != null) {
      stdout.writeln('  Constraints:    ${options.constraintsFile}');
    } else {
      stdout.writeln('  Constraints:    (manual input)');
    }
  }
  stdout.writeln('  Verbose:        ${options.verbose}');
  stdout.writeln('━' * 60);
  stdout.writeln('');

  final confirm = await _promptYesNo(
    'Proceed with this configuration?',
    defaultValue: true,
  );

  if (!confirm) {
    throw Exception('User cancelled');
  }

  return options;
}

/// Helper: Prompt for text input
Future<String> _promptQuestion(String question, {String? defaultValue, bool required = false}) async {
  while (true) {
    if (defaultValue != null) {
      stdout.write('? $question ($defaultValue): ');
    } else {
      stdout.write('? $question: ');
    }

    final input = stdin.readLineSync();

    if (input == null || input.trim().isEmpty) {
      if (defaultValue != null) {
        return defaultValue;
      }
      if (required) {
        stdout.writeln('  ✗ This field is required');
        continue;
      }
      return '';
    }

    return input.trim();
  }
}

/// Helper: Prompt for yes/no question
Future<bool> _promptYesNo(String question, {bool defaultValue = false}) async {
  final defaultStr = defaultValue ? 'Y/n' : 'y/N';
  stdout.write('? $question ($defaultStr): ');

  final input = stdin.readLineSync();

  if (input == null || input.trim().isEmpty) {
    return defaultValue;
  }

  final normalized = input.trim().toLowerCase();
  return normalized == 'y' || normalized == 'yes';
}

/// Helper: Prompt for multiple choice
Future<String> _promptChoice(String question, {required List<String> choices, int defaultIndex = 0}) async {
  stdout.writeln('? $question:');
  for (int i = 0; i < choices.length; i++) {
    final marker = i == defaultIndex ? '❯' : ' ';
    stdout.writeln('  $marker ${i + 1}. ${choices[i]}');
  }
  stdout.write('  Select (1-${choices.length}) [${defaultIndex + 1}]: ');

  final input = stdin.readLineSync();

  if (input == null || input.trim().isEmpty) {
    return choices[defaultIndex];
  }

  final selection = int.tryParse(input.trim());
  if (selection != null && selection >= 1 && selection <= choices.length) {
    return choices[selection - 1];
  }

  return choices[defaultIndex];
}

/// Print banner
void _printBanner() {
  stdout.writeln('');
  stdout.writeln('╔═══════════════════════════════════════════════════════════╗');
  stdout.writeln('║                                                           ║');
  stdout.writeln('║         Flutter Test Generator - Interactive Mode         ║');
  stdout.writeln('║                                                           ║');
  stdout.writeln('╚═══════════════════════════════════════════════════════════╝');
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

  // Validate manifest contains widgets
  final manifestContent = File(manifestPath).readAsStringSync();
  final manifest = jsonDecode(manifestContent) as Map<String, dynamic>;
  final widgets = (manifest['widgets'] as List?) ?? [];

  if (widgets.isEmpty) {
    stdout.writeln('');
    stderr.writeln('━' * 60);
    stderr.writeln('⚠ ERROR: No testable widgets found');
    stderr.writeln('━' * 60);
    stderr.writeln('');
    stderr.writeln('The file must contain widgets with keys:');
    stderr.writeln('  • TextField/TextFormField with key: Key(\'xxx\')');
    stderr.writeln('  • Button/Dropdown/Radio with key: Key(\'xxx\')');
    stderr.writeln('');
    stderr.writeln('Example:');
    stderr.writeln('  TextField(');
    stderr.writeln('    key: Key(\'username_field\'),');
    stderr.writeln('    // ...');
    stderr.writeln('  )');
    stderr.writeln('');
    stderr.writeln('  ElevatedButton(');
    stderr.writeln('    key: Key(\'submit_button\'),');
    stderr.writeln('    // ...');
    stderr.writeln('  )');
    stderr.writeln('');
    throw Exception('No testable widgets found in $inputFile');
  }

  if (options.verbose) {
    stdout.writeln('  ✓ UI file imported successfully');
    stdout.writeln('  → Found ${widgets.length} widget(s) with keys');
    stdout.writeln('');
  }

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

  // Step 3: Prepare constraints if specified
  String? constraintsContent;
  if (options.useConstraints) {
    if (options.constraintsFile != null) {
      // Load from file
      final file = File(options.constraintsFile!);
      if (!file.existsSync()) {
        stderr.writeln('Warning: Constraints file not found: ${options.constraintsFile}');
        stderr.writeln('         Continuing without constraints...');
      } else {
        constraintsContent = file.readAsStringSync();
        if (options.verbose) {
          stdout.writeln('  → Loaded constraints from: ${options.constraintsFile}');
        }
      }
    } else if (options.constraintsContent != null) {
      // Use inline content
      constraintsContent = options.constraintsContent;
      if (options.verbose) {
        stdout.writeln('  → Using inline constraints');
      }
    }
  }

  // Step 3: Generate test data
  _logStep(3, 'Generating test plan (PICT)', options);
  final testDataPath = await step3.generateTestDataFromManifest(
    manifestPath,
    pictBin: options.pictBin,
    constraints: constraintsContent,
  );
  _logSuccess('Test plan: $testDataPath', options);

  // Step 4: Generate test script
  _logStep(4, 'Generating test script', options);
  final testScriptPath = step4.generateTestScriptFromTestData(testDataPath);
  _logSuccess('Test file: $testScriptPath', options);

  // Widget Coverage Check
  stdout.writeln('');
  stdout.writeln('━' * 60);
  stdout.writeln('  Widget Coverage Analysis');
  stdout.writeln('━' * 60);
  stdout.writeln('');
  await _runWidgetCoverageCheck(manifestPath, testScriptPath, options);

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

/// Run widget coverage check
Future<void> _runWidgetCoverageCheck(
  String manifestPath,
  String testFilePath,
  CLIOptions options,
) async {
  try {
    // Run widget_coverage.dart as subprocess
    final result = await Process.run(
      'dart',
      ['run', 'tools/widget_coverage.dart', manifestPath, testFilePath],
    );

    // Print output (coverage report)
    stdout.write(result.stdout);

    if (result.exitCode != 0 && result.stderr.toString().isNotEmpty) {
      stderr.write(result.stderr);
    }
  } catch (e) {
    stderr.writeln('⚠ Widget coverage check failed: $e');
    if (options.verbose) {
      stderr.writeln('  Skipping coverage analysis...');
    }
  }
}

void _printHelp() {
  stdout.writeln('Flutter Test Generator - Unified CLI Tool');
  stdout.writeln('');
  stdout.writeln('USAGE:');
  stdout.writeln('  # Interactive mode (recommended)');
  stdout.writeln('  dart run tools/flutter_test_generator.dart');
  stdout.writeln('');
  stdout.writeln('  # CLI mode with arguments');
  stdout.writeln('  dart run tools/flutter_test_generator.dart <UI_FILE> [OPTIONS]');
  stdout.writeln('');
  stdout.writeln('ARGUMENTS:');
  stdout.writeln('  <UI_FILE>                   Path to Flutter UI file (e.g., lib/demos/buttons_page.dart)');
  stdout.writeln('');
  stdout.writeln('OPTIONS:');
  stdout.writeln('  --skip-datasets             Skip AI-powered dataset generation');
  stdout.writeln('  --verbose, -v               Show detailed logs');
  stdout.writeln('  --api-key=<KEY>             Gemini API key (overrides .env)');
  stdout.writeln('  --pict-bin=<PATH>           Path to PICT binary (default: ./pict)');
  stdout.writeln('  --with-constraints          Enable PICT constraints (requires constraints file)');
  stdout.writeln('  --constraints-file=<PATH>   Path to constraints file');
  stdout.writeln('  --constraints=<CONTENT>     Inline constraints (semicolon-separated)');
  stdout.writeln('  --help, -h                  Show this help message');
  stdout.writeln('');
  stdout.writeln('EXAMPLES:');
  stdout.writeln('  # Interactive mode');
  stdout.writeln('  dart run tools/flutter_test_generator.dart');
  stdout.writeln('');
  stdout.writeln('  # Basic CLI usage');
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
  stdout.writeln('  # With constraints from file');
  stdout.writeln('  dart run tools/flutter_test_generator.dart lib/demos/buttons_page.dart \\');
  stdout.writeln('    --constraints-file=output/model_pairwise/buttons_page.constraints.txt');
  stdout.writeln('');
  stdout.writeln('  # With inline constraints');
  stdout.writeln('  dart run tools/flutter_test_generator.dart lib/demos/buttons_page.dart \\');
  stdout.writeln('    --constraints=\'IF [Type] = "RAID-5" THEN [Compression] = "Off";\'');
  stdout.writeln('');
  stdout.writeln('PIPELINE STEPS:');
  stdout.writeln('  1. Extract UI manifest from source file');
  stdout.writeln('  2. Generate test datasets using AI (optional)');
  stdout.writeln('  3. Generate test plan using pairwise testing (with optional constraints)');
  stdout.writeln('  4. Generate Flutter test script');
  stdout.writeln('');
  stdout.writeln('CONSTRAINTS:');
  stdout.writeln('  PICT constraints allow you to specify rules for test combinations.');
  stdout.writeln('  Example constraints file (output/model_pairwise/<page>.constraints.txt):');
  stdout.writeln('');
  stdout.writeln('    IF [Type] = "RAID-5" THEN [Compression] = "Off";');
  stdout.writeln('    IF [Size] >= 500 THEN [Format method] = "Quick";');
  stdout.writeln('');
}
