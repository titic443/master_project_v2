#!/usr/bin/env dart

/// Widget Coverage Analyzer
///
/// Usage:
///   dart run tools/widget_coverage.dart <manifest.json> <test_file.dart>
///
/// Example:
///   dart run tools/widget_coverage.dart \
///     output/manifest/demos/customer_details_page.manifest.json \
///     integration_test/customer_details_page_flow_test.dart

import 'dart:io';
import 'dart:convert';

void main(List<String> args) {
  if (args.length < 2) {
    print('Usage: dart run tools/widget_coverage.dart <manifest.json> <test_file.dart>');
    exit(1);
  }

  final manifestPath = args[0];
  final testFilePath = args[1];

  // Read manifest
  final manifestFile = File(manifestPath);
  if (!manifestFile.existsSync()) {
    print('Error: Manifest file not found: $manifestPath');
    exit(1);
  }

  // Read test file
  final testFile = File(testFilePath);
  if (!testFile.existsSync()) {
    print('Error: Test file not found: $testFilePath');
    exit(1);
  }

  final manifestData = jsonDecode(manifestFile.readAsStringSync()) as Map<String, dynamic>;
  final testContent = testFile.readAsStringSync();

  // Extract widgets from manifest
  final widgets = <String, Map<String, dynamic>>{};

  if (manifestData.containsKey('widgets')) {
    final widgetsList = manifestData['widgets'] as List<dynamic>;

    for (final widget in widgetsList) {
      final widgetMap = widget as Map<String, dynamic>;
      final key = widgetMap['key'] as String?;
      final type = widgetMap['type'] as String? ?? 'Unknown';

      if (key != null && key.isNotEmpty) {
        widgets[key] = {
          'type': type,
          'tested': false,
          'testMethods': <String>[],
        };
      }
    }
  }

  // Check which widgets are tested
  for (final key in widgets.keys) {
    // Search for widget key in test file
    final patterns = [
      "Key('$key')",
      'Key("$key")',
      "byKey(const Key('$key'))",
      'byKey(const Key("$key"))',
      "byKey(Key('$key'))",
      'byKey(Key("$key"))',
    ];

    for (final pattern in patterns) {
      if (testContent.contains(pattern)) {
        widgets[key]!['tested'] = true;

        // Find which test method uses this widget
        final lines = testContent.split('\n');
        String? currentTestMethod;

        for (final line in lines) {
          // Detect test method
          if (line.contains("testWidgets('") || line.contains('testWidgets("')) {
            final match = RegExp(r'''testWidgets\(['"]([^'"]+)['"]''').firstMatch(line);
            if (match != null) {
              currentTestMethod = match.group(1);
            }
          }

          // Check if this line contains the widget key
          if (line.contains(pattern) && currentTestMethod != null) {
            final testMethods = widgets[key]!['testMethods'] as List<String>;
            if (!testMethods.contains(currentTestMethod)) {
              testMethods.add(currentTestMethod);
            }
          }
        }

        break;
      }
    }
  }

  // Calculate coverage
  final totalWidgets = widgets.length;
  final testedWidgets = widgets.values.where((w) => w['tested'] as bool).length;
  final coverage = totalWidgets > 0 ? (testedWidgets / totalWidgets * 100).toStringAsFixed(1) : '0.0';

  // Print report
  print('');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('  Widget Coverage Report');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('');
  print('  Manifest: ${manifestPath.split('/').last}');
  print('  Test:     ${testFilePath.split('/').last}');
  print('');
  print('  Total Widgets:    $totalWidgets');
  print('  Tested Widgets:   $testedWidgets');
  print('  Untested Widgets: ${totalWidgets - testedWidgets}');
  print('');

  final coverageNum = double.parse(coverage);
  String coverageColor;
  String coverageSymbol;

  if (coverageNum >= 90) {
    coverageColor = '\x1B[32m'; // Green
    coverageSymbol = '✓';
  } else if (coverageNum >= 70) {
    coverageColor = '\x1B[33m'; // Yellow
    coverageSymbol = '⚠';
  } else {
    coverageColor = '\x1B[31m'; // Red
    coverageSymbol = '✗';
  }

  print('  Coverage:         $coverageColor$coverage%\x1B[0m $coverageSymbol');
  print('');

  // Show tested widgets
  if (testedWidgets > 0) {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('  Tested Widgets ($testedWidgets)');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('');

    final tested = widgets.entries.where((e) => e.value['tested'] as bool).toList();
    tested.sort((a, b) => a.key.compareTo(b.key));

    for (final entry in tested) {
      final key = entry.key;
      final type = entry.value['type'] as String;
      final testMethods = entry.value['testMethods'] as List<String>;

      print('  \x1B[32m✓\x1B[0m $key');
      print('      Type: $type');
      if (testMethods.isNotEmpty) {
        print('      Tests: ${testMethods.join(", ")}');
      }
    }
    print('');
  }

  // Show untested widgets (gaps)
  final untested = widgets.entries.where((e) => !(e.value['tested'] as bool)).toList();

  if (untested.isNotEmpty) {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('  \x1B[31mUntested Widgets (${untested.length} gaps)\x1B[0m');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('');

    // Group by type
    final byType = <String, List<String>>{};
    for (final entry in untested) {
      final type = entry.value['type'] as String;
      byType.putIfAbsent(type, () => []).add(entry.key);
    }

    for (final type in byType.keys.toList()..sort()) {
      final keys = byType[type]!;
      print('  \x1B[33m┌─ ${type}s (${keys.length})\x1B[0m');

      for (final key in keys) {
        print('  \x1B[33m│\x1B[0m   \x1B[31m✗\x1B[0m $key');

        // Suggest how to test based on widget type
        final suggestion = _getTestSuggestion(type, key);
        if (suggestion != null) {
          print('  \x1B[33m│\x1B[0m      \x1B[36m→\x1B[0m $suggestion');
        }
      }

      print('  \x1B[33m└─\x1B[0m');
      print('');
    }

    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('  Next Steps');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('');
    print('  1. Add tests for untested widgets above');
    print('  2. Use suggestions to guide test implementation');
    print('  3. Re-run this script to verify coverage');
    print('');
    print('  Example test template:');
    print('');
    print("  testWidgets('test_widget_name', (tester) async {");
    print('    await tester.pumpWidget(YourPage());');
    print('');
    print("    // Interact with widget");
    print("    await tester.tap(find.byKey(Key('widget_key')));");
    print('    await tester.pump();');
    print('');
    print("    // Assert result");
    print('    expect(find.text("Expected"), findsOneWidget);');
    print('  });');
    print('');
  } else {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('  \x1B[32m✓ Perfect Coverage!\x1B[0m');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('');
    print('  All widgets are covered by tests.');
    print('');
  }

  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('');

  // Exit with error if coverage is below threshold
  if (coverageNum < 70) {
    exit(1);
  }
}

String? _getTestSuggestion(String type, String key) {
  switch (type.toLowerCase()) {
    case 'textformfield':
    case 'textfield':
      return 'Test: enterText() with valid/invalid values';

    case 'elevatedbutton':
    case 'textbutton':
    case 'iconbutton':
    case 'floatingactionbutton':
      return 'Test: tap() and verify action result';

    case 'dropdownbutton':
      return 'Test: tap() to open, select option';

    case 'radio':
      return 'Test: tap() to select, verify state change';

    case 'checkbox':
    case 'checkboxlisttile':
      return 'Test: tap() to check/uncheck';

    case 'switch':
    case 'switchlisttile':
      return 'Test: tap() to toggle on/off';

    case 'slider':
      return 'Test: drag() or setValue()';

    default:
      return 'Test: Verify widget renders correctly';
  }
}
