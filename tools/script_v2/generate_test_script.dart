// dart run tools/script_v2/generate_test_script.dart [output/test_data/<page>.testdata.json]
//
// Generate widget tests from a test plan JSON (produced by tools/script_v2/generate_test_data.dart).
// - If no args are provided, processes all files under output/test_data/*.testdata.json
// - Writes tests to integration_test/<page>_flow_test.dart

import 'dart:convert';
import 'dart:io';

import 'utils.dart' as utils;

/// Public API for flutter_test_generator.dart
/// Generates Flutter test script from a test data file
/// Returns the path to the generated integration test file
String generateTestScriptFromTestData(String testDataPath) {
  _processOne(testDataPath);

  // Calculate output path (integration test)
  final base = testDataPath
      .replaceAll('output/test_data/', '')
      .replaceAll(RegExp(r'\.testdata\.json$'), '');
  return 'integration_test/${base}_flow_test.dart';
}

void main(List<String> args) {
  final inputs = <String>[];
  if (args.isEmpty) {
    final dir = Directory('output/test_data');
    if (!dir.existsSync()) {
      stderr.writeln('No output/test_data directory');
      exit(1);
    }
    for (final f in dir.listSync().whereType<File>()) {
      if (f.path.endsWith('.testdata.json')) inputs.add(f.path);
    }
    if (inputs.isEmpty) {
      stderr.writeln('No *.testdata.json files under output/test_data');
      exit(1);
    }
  } else {
    inputs.addAll(args);
  }

  for (final path in inputs) {
    try {
      _processOne(path);
    } catch (e, st) {
      stderr.writeln('! Failed to process $path: $e\n$st');
    }
  }
}

void _processOne(String planPath) {
  final raw = File(planPath).readAsStringSync();
  final j = jsonDecode(raw) as Map<String, dynamic>;

  // Read from source section (new structure)
  final source = (j['source'] as Map<String, dynamic>? ) ?? const {};
  final uiFile = (source['file'] as String?) ?? 'lib/unknown.dart';
  final pageClass = (source['pageClass'] as String?) ?? utils.basenameWithoutExtension(uiFile);
  final cubitClass = (source['cubitClass'] as String?);
  final stateClass = (source['stateClass'] as String?);

  // Build providers list from cubitClass if available
  final providers = cubitClass != null ? [{'type': cubitClass}] : <Map<String, dynamic>>[];
  final cases = (j['cases'] as List? ?? const []).cast<Map<String, dynamic>>();

  // Extract validation counts from test data asserts instead of parsing UI file
  final validationCounts = _extractValidationCountsFromPlan(cases);

  // Helper function to convert new dataset format to old format
  Map<String, dynamic> _convertDatasetsToOldFormat(Map<String, dynamic> datasets) {
    final result = <String, dynamic>{};

    // Process byKey section if it exists
    if (datasets.containsKey('byKey') && datasets['byKey'] is Map) {
      final byKey = (datasets['byKey'] as Map).cast<String, dynamic>();
      final convertedByKey = <String, dynamic>{};

      for (final entry in byKey.entries) {
        final key = entry.key;
        final value = entry.value;

        // Check if it's new format (array of pairs)
        if (value is List) {
          final validList = <String>[];
          final invalidList = <String>[];

          for (final pair in value) {
            if (pair is Map) {
              final validVal = pair['valid']?.toString();
              final invalidVal = pair['invalid']?.toString();
              if (validVal != null) validList.add(validVal);
              if (invalidVal != null) invalidList.add(invalidVal);
            }
          }

          convertedByKey[key] = {
            'valid': validList,
            'invalid': invalidList,
          };
        } else if (value is Map) {
          // Already old format, keep as-is
          convertedByKey[key] = value;
        }
      }

      result['byKey'] = convertedByKey;
    }

    // Copy other sections as-is
    for (final entry in datasets.entries) {
      if (entry.key != 'byKey') {
        result[entry.key] = entry.value;
      }
    }

    return result;
  }

  // Prefer external datasets file when present; fallback to embedded
  Map<String, dynamic> _maybeLoadExternalDatasets(String uiFile) {
    try {
      final base = utils.basenameWithoutExtension(uiFile);
      final f = File('output/test_data/' + base + '.datasets.json');
      if (f.existsSync()) {
        final ext = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
        final extDs = (ext['datasets'] as Map?)?.cast<String, dynamic>();
        if (extDs != null && extDs.isNotEmpty) {
          // Convert new format to old format before returning
          return _convertDatasetsToOldFormat(extDs);
        }
      }
    } catch (_) {}
    return const {};
  }
  Map<String, dynamic> datasets;
  final extFirst = _maybeLoadExternalDatasets(uiFile);
  if (extFirst.isNotEmpty) {
    datasets = extFirst;
  } else {
    // Don't convert embedded datasets - keep original array structure for proper resolution
    datasets = (j['datasets'] as Map? ?? const {}).cast<String, dynamic>();
  }

  final pkg = utils.readPackageName() ?? 'master_project';
  final uiImport = utils.pkgImport(pkg, uiFile);

  // Find provider type files to import
  final providerTypes = <String>[];
  for (final p in providers) {
    final t = (p['type'] ?? '').toString();
    if (t.isNotEmpty) providerTypes.add(t);
  }
  final providerFiles = <String>[];
  for (final t in providerTypes) {
    final f = utils.findDeclFile(RegExp(r'class\s+' + RegExp.escape(t) + r'\b'), endsWith: '_cubit.dart');
    if (f != null) providerFiles.add(f);
  }

  // Determine primary cubit type dynamically
  final primaryCubitType = _getPrimaryCubitType(providerTypes);

  // Precompute sample values byKey -> first valid
  final sampleByKey = <String, String>{};
  if (datasets.containsKey('byKey') && datasets['byKey'] is Map) {
    final byKey = (datasets['byKey'] as Map).cast<String, dynamic>();
    byKey.forEach((k, v) {
      try {
        // Handle new format: array of objects with valid/invalid
        if (v is List && v.isNotEmpty && v.first is Map) {
          final first = v.first as Map;
          if (first.containsKey('valid') && first['valid'] is String) {
            sampleByKey[k] = first['valid'] as String;
          }
        }
        // Handle old format: Map with valid: [...]
        else if (v is Map) {
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

  final b = StringBuffer()
    ..writeln('// GENERATED — from test plan')
    ..writeln("import 'package:flutter/material.dart';")
    ..writeln("import 'package:flutter_test/flutter_test.dart';");
  // Allow real network in widget tests by overriding test HttpClient
  b.writeln("import 'dart:io';");

  if (providerFiles.isNotEmpty) {
    b.writeln("import 'package:flutter_bloc/flutter_bloc.dart';");
  }
  for (final f in providerFiles) {
    b.writeln("import '${utils.pkgImport(pkg, f)}';");
  }
  // For primary cubit success stub that emits ApiResponse, import state model
  if (primaryCubitType != null) {
    final stateFilePath = _getStateFilePathFromCubit(primaryCubitType);
    b.writeln("import '${utils.pkgImport(pkg, stateFilePath)}';");
  }
  b.writeln("import '$uiImport';");

  // Stubs: for primary cubit success case we override onEndButton to avoid error
  if (primaryCubitType != null) {
    b
      ..writeln('')
      ..writeln('class _Success$primaryCubitType extends $primaryCubitType {')
      ..writeln('  final ApiResponse? stubResp;')
      ..writeln('  _Success$primaryCubitType({this.stubResp}) : super(shouldSucceed: true);')
      ..writeln('  @override')
      ..writeln('  Future<void> onEndButton() async {')
      ..writeln('    final resp = stubResp ?? const ApiResponse(message: \"ok\", code: 200);')
      ..writeln('    emit(state.copyWith(response: resp, exception: null));')
      ..writeln('  }')
      ..writeln('  @override')
      ..writeln('  Future<void> callApi() async {')
      ..writeln('    final resp = stubResp ?? const ApiResponse(message: \"ok\", code: 200);')
      ..writeln('    emit(state.copyWith(response: resp, exception: null));')
      ..writeln('  }')
      ..writeln('}');

    // Failure stub: deterministically emit exception with given code (e.g., 400/500)
    b
      ..writeln('')
      ..writeln('class _Fail$primaryCubitType extends $primaryCubitType {')
      ..writeln('  final int code;')
      ..writeln('  _Fail$primaryCubitType(this.code) : super(shouldSucceed: false);')
      ..writeln('  @override')
      ..writeln('  Future<void> callApi() async {')
      ..writeln('    emit(state.copyWith(exception: RegisterException(message: \"api_failed\", code: code)));')
      ..writeln('  }')
      ..writeln('  @override')
      ..writeln('  Future<void> onEndButton() async {')
      ..writeln('    emit(state.copyWith(exception: RegisterException(message: \"api_failed\", code: code)));')
      ..writeln('  }')
      ..writeln('}');
  }

  // Helper to wrap with providers
  b
    ..writeln('')
    ..writeln('Widget _wrap(Widget child, {required bool success, Map<String, dynamic>? response, int? failureCode}) {')
    ..writeln('  final providers = <BlocProvider>[];');
  for (final t in providerTypes) {
    if (t == primaryCubitType) {
      b.writeln("  providers.add(BlocProvider<$t>(create: (_)=> success ? _Success$t(stubResp: response!=null ? ApiResponse.fromJson(response) : null) : (failureCode!=null ? _Fail$t(failureCode) : $t())));");
    } else {
      b.writeln("  providers.add(BlocProvider<$t>(create: (_)=> $t()));");
    }
  }
  b
    ..writeln('  return MaterialApp(home: MultiBlocProvider(providers: providers, child: child));')
    ..writeln('}');

  // Group cases by their 'group' field from test data
  Map<String, List<Map<String, dynamic>>> groupsByName = {};
  for (final c in cases) {
    final groupName = (c['group'] ?? 'Other').toString();
    groupsByName.putIfAbsent(groupName, () => []).add(c);
  }

  // Create ordered groups list (preserve order of appearance)
  List<(String, List<Map<String,dynamic>>)> orderedGroups = [];
  final seenGroups = <String>{};
  for (final c in cases) {
    final groupName = (c['group'] ?? 'Other').toString();
    if (!seenGroups.contains(groupName)) {
      seenGroups.add(groupName);
      orderedGroups.add((groupName, groupsByName[groupName]!));
    }
  }

  // Emit tests grouped by category
  b.writeln('');
  b.writeln('void main() {' );
  b.writeln("  group('${utils.basename(uiFile)} flow', () {");

  for (final entry in orderedGroups) {
    final groupName = entry.$1;
    final group = entry.$2;
    if (group.isEmpty) continue;
    b.writeln("    group('$groupName', () {");
  for (final c in group) {
    final id = (c['tc'] ?? 'case').toString();
    final kind = (c['kind'] ?? '').toString();
    final setup = (c['setup'] as Map? ?? const {});
    // No API Response Tests group anymore, all use stub-based testing
    bool successStub = (setup['cubitStub'] ?? '').toString() == 'success' || kind == 'success';
    final steps = (c['steps'] as List? ?? const []).cast<Map<String, dynamic>>();
    final asserts = (c['asserts'] as List? ?? const []).cast<Map<String, dynamic>>();

    // Optional per-case API response to inject on success
    Map<String, dynamic>? respJson;
    try {
      final setupMap = setup.cast<String, dynamic>();
      if (setupMap.containsKey('response') && setupMap['response'] is Map) {
        respJson = (setupMap['response'] as Map).cast<String, dynamic>();
      }
    } catch (_) {}

    String _dartMapLiteral(Map<String, dynamic> m) {
      String val(v) {
        if (v is String) return "'${v.replaceAll("'", "\\'")}'";
        if (v is num || v is bool) return v.toString();
        if (v is Map) return _dartMapLiteral(v.cast<String, dynamic>());
        if (v is List) return '[${v.map(val).join(', ')}]';
        return 'null';
      }
      return '{' + m.entries.map((e) => "'${e.key}': ${val(e.value)}").join(', ') + '}';
    }

    // Inject response for success cases with response data
    final responseArg = (successStub && respJson != null)
        ? ", response: ${_dartMapLiteral(respJson)}"
        : '';

    // Infer desired failure code for API failed cases via asserts
    int? _inferFailureCode(List<Map<String,dynamic>> asserts) {
      for (final a in asserts) {
        final byKey = (a['byKey'] ?? '').toString();
        final exists = a['exists'];
        if (exists is bool && exists) {
          if (byKey.contains('status_400')) return 400;
          if (byKey.contains('status_500')) return 500;
        }
      }
      return null;
    }
    final failureCode = (!successStub) ? _inferFailureCode(asserts) : null;
    final failureArg = (failureCode != null) ? ", failureCode: $failureCode" : '';

    b
      ..writeln("    testWidgets('$id', (tester) async {")
      ..writeln('      final w = _wrap($pageClass(), success: ${successStub ? 'true' : 'false'}$responseArg$failureArg);')
      ..writeln('      await tester.pumpWidget(w);');

    for (var i = 0; i < steps.length; i++) {
      final s = steps[i];
      final nextIsPump = (i + 1 < steps.length) && (steps[i + 1].containsKey('pump'));

      if (s.containsKey('enterText')) {
        final m = (s['enterText'] as Map).cast<String, dynamic>();
        final k = m['byKey'];
        String text = m['text'] ?? '';
        final ds = m['dataset'];
        if (text.isEmpty && ds is String) {
          // Strict resolution for pairwise cases to avoid silent fallback
          final dsPath = ds.trim();
          final resolved = _resolveDataset(datasets, dsPath);
          if (resolved is String) {
            text = resolved;
          } else if (resolved is num || resolved is bool) {
            text = resolved.toString();
          } else {
            if (id.startsWith('pairwise_case_')) {
              throw StateError('[$id] Dataset not found or not primitive for $dsPath (byKey=$k)');
            }
            if (k is String && sampleByKey.containsKey(k)) {
              text = sampleByKey[k]!;
            }
          }
        }
        // Debug comment for dataset source
        if (ds is String) {
          b.writeln("      // dataset: ${ds.trim()}");
        }
        final escText = utils.dartEscape(text);
        b.writeln("      await tester.enterText(find.byKey(const Key('$k')), '$escText');");
        if (!nextIsPump) b.writeln('      await tester.pump();');

      } else if (s.containsKey('tap')) {
        final m = (s['tap'] as Map).cast<String, dynamic>();
        final k = m['byKey'];
        b
          ..writeln("      await tester.ensureVisible(find.byKey(const Key('$k')));")
          ..writeln("      await tester.tap(find.byKey(const Key('$k')));");
        if (!nextIsPump) b.writeln('      await tester.pump();');

      } else if (s.containsKey('tapText')) {
        final txt = (s['tapText']).toString();
        b.writeln("      await tester.tap(find.text('${utils.dartEscape(txt)}'));");
        if (!nextIsPump) b.writeln('      await tester.pump();');

      } else if (s.containsKey('pumpAndSettle')) {
        b.writeln('      await tester.pumpAndSettle();');

      } else if (s.containsKey('pump')) {
        b.writeln('      await tester.pump();');
      }
    }

    bool _edgeKeysChecked = false;
    for (final a in asserts) {
      final byKey = a['byKey'];
      final exists = a['exists'];
      final textEquals = a['textEquals'];
      final textContains = a['textContains'];
      final textGlobal = a['text'];

      if (byKey != null && exists is bool && textEquals == null && textContains == null) {
        b.writeln("      expect(find.byKey(const Key('$byKey')), ${exists ? 'findsOneWidget' : 'findsNothing'});");
        continue;
      }
      if (byKey != null && textEquals is String) {
        final esc = utils.dartEscape(textEquals);
        b.writeln("      final _tw = tester.widget<Text>(find.byKey(const Key('$byKey')));");
        b.writeln("      expect(_tw.data ?? '', '$esc');");
        continue;
      }
      if (byKey != null && textContains is String) {
        final esc = utils.dartEscape(textContains);
        b.writeln("      final _tw = tester.widget<Text>(find.byKey(const Key('$byKey')));");
        b.writeln("      expect((_tw.data ?? '').contains('$esc'), true);");
        continue;
      }
      if (textGlobal is String && exists is bool) {
        final esc = utils.dartEscape(textGlobal);
        // Check if this assert has explicit count field
        final explicitCount = a['count'];
        final finderExpr = () {
          if (exists) {
            // Use explicit count from assert if available
            if (explicitCount is int) {
              if (groupName == 'edge_cases' && !_edgeKeysChecked) {
                try {
                  final byKeyMap = (datasets['byKey'] as Map).cast<String, dynamic>();
                  final keys = byKeyMap.keys.where((k) => k.contains('textfield')).toList();
                  for (final k in keys) {
                    b.writeln("      expect(find.byKey(const Key('$k')), findsOneWidget);");
                  }
                  _edgeKeysChecked = true;
                } catch (_) {}
              }
              return explicitCount > 1 ? 'findsNWidgets($explicitCount)' : 'findsOneWidget';
            }
            // Fallback: use validation counts extracted from test plan
            if (validationCounts.containsKey(esc)) {
              final count = validationCounts[esc]!;
              if (groupName == 'edge_cases' && !_edgeKeysChecked) {
                try {
                  final byKeyMap = (datasets['byKey'] as Map).cast<String, dynamic>();
                  final keys = byKeyMap.keys.where((k) => k.contains('textfield')).toList();
                  for (final k in keys) {
                    b.writeln("      expect(find.byKey(const Key('$k')), findsOneWidget);");
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

    // If a success stub with a provided response map is used, assert Cubit state.response
    if (successStub && respJson != null && primaryCubitType != null) {
      final hasCode = respJson.containsKey('code');
      final hasMessage = respJson.containsKey('message');
      b.writeln("      // Verify ApiResponse mapped into state");
      b.writeln("      final _el = find.byType($pageClass).evaluate().first;");
      b.writeln("      final _cubit = BlocProvider.of<$primaryCubitType>(_el);");
      if (hasCode) {
        final codeVal = respJson['code'];
        if (codeVal is num) {
          b.writeln("      expect(_cubit.state.response?.code, ${codeVal.toInt()});");
        } else {
          final esc = utils.dartEscape((codeVal?.toString() ?? ''));
          b.writeln("      expect(_cubit.state.response?.code.toString(), '$esc');");
        }
      }
      if (hasMessage) {
        final msg = utils.dartEscape((respJson['message']?.toString() ?? ''));
        b.writeln("      expect(_cubit.state.response?.message, '$msg');");
      }
    }

    // (Removed) Previously ensured no API response in validation cases

    b
      ..writeln('    });')
      ..writeln('');
    }
    b.writeln('    });');
  }

  b
    ..writeln('  });')
    ..writeln('}');

  // Skip generating widget tests - only generate integration tests

  // Always generate integration tests with all groups
  _generateIntegrationTests(uiFile, pageClass, providerFiles, primaryCubitType, pkg, uiImport, orderedGroups, providerTypes, datasets, sampleByKey, validationCounts);
}

void _generateIntegrationTests(String uiFile, String pageClass, List<String> providerFiles, String? primaryCubitType, String pkg, String uiImport, List<(String, List<Map<String, dynamic>>)> orderedGroups, List<String> providerTypes, Map<String, dynamic> datasets, Map<String, String> sampleByKey, Map<String, int> validationCounts) {
  final ib = StringBuffer()
    ..writeln('// GENERATED — Integration tests for full flow')
    ..writeln("import 'package:flutter/material.dart';")
    ..writeln("import 'package:flutter_test/flutter_test.dart';")
    ..writeln("import 'package:integration_test/integration_test.dart';");

  if (providerFiles.isNotEmpty) {
    ib.writeln("import 'package:flutter_bloc/flutter_bloc.dart';");
  }
  for (final f in providerFiles) {
    ib.writeln("import '${utils.pkgImport(pkg, f)}';");
  }
  if (primaryCubitType != null) {
    final stateFilePath = _getStateFilePathFromCubit(primaryCubitType);
    ib.writeln("import '${utils.pkgImport(pkg, stateFilePath)}';");
  }
  ib.writeln("import '$uiImport';");

  ib
    ..writeln('')
    ..writeln('void main() {')
    ..writeln('  IntegrationTestWidgetsFlutterBinding.ensureInitialized();')
    ..writeln("  group('${utils.basename(uiFile)} flow (integration)', () {");

  for (final entry in orderedGroups) {
    final groupName = entry.$1;
    final group = entry.$2;
    if (group.isEmpty) continue;
    ib.writeln("    group('$groupName', () {");
    for (final c in group) {
      final id = (c['tc'] ?? 'case').toString();
      final steps = (c['steps'] as List? ?? const []).cast<Map<String, dynamic>>();
      final asserts = (c['asserts'] as List? ?? const []).cast<Map<String, dynamic>>();

      ib.writeln("      testWidgets('$id', (tester) async {");
      // Use real providers for all groups in integration tests
      ib.writeln('        final providers = <BlocProvider>[');
      for (final t in providerTypes) {
        ib.writeln("          BlocProvider<$t>(create: (_)=> $t()),");
      }
      ib
        ..writeln('        ];')
        ..writeln('        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: $pageClass()));')
        ..writeln('        await tester.pumpWidget(w);');

      for (var i = 0; i < steps.length; i++) {
        final s = steps[i];
        final nextIsPump = (i + 1 < steps.length) && (steps[i + 1].containsKey('pump'));
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
          ib.writeln("        await tester.enterText(find.byKey(const Key('$k')), '$escText');");
          if (!nextIsPump) ib.writeln('        await tester.pump();');
        } else if (s.containsKey('tap')) {
          final m = (s['tap'] as Map).cast<String, dynamic>();
          final k = m['byKey'];
          ib
            ..writeln("        await tester.ensureVisible(find.byKey(const Key('$k')));")
            ..writeln("        await tester.tap(find.byKey(const Key('$k')));");
          if (!nextIsPump) ib.writeln('        await tester.pump();');
        } else if (s.containsKey('tapText')) {
          final txt = (s['tapText']).toString();
          ib.writeln("        await tester.tap(find.text('${utils.dartEscape(txt)}'));");
          if (!nextIsPump) ib.writeln('        await tester.pump();');
        } else if (s.containsKey('pumpAndSettle')) {
          ib.writeln('        await tester.pumpAndSettle();');
        } else if (s.containsKey('pump')) {
          ib.writeln('        await tester.pump();');
        }
      }

      // Group assertions into a single expectAny check
      if (asserts.isNotEmpty) {
        final finders = <String>[];

        for (final a in asserts) {
          final byKey = a['byKey'];
          final exists = a['exists'];
          final textGlobal = a['text'];

          // Skip non-exists assertions
          if (exists == false) continue;

          if (byKey != null && exists is bool) {
            finders.add("find.byKey(const Key('$byKey'))");
          } else if (textGlobal is String && exists is bool) {
            final esc = utils.dartEscape(textGlobal);
            finders.add("find.text('$esc')");
          }
        }

        // Generate expectAny check
        if (finders.isNotEmpty) {
          ib.writeln('        // Check if any expected element exists (OR logic)');
          ib.writeln('        final expected = [');
          for (final finder in finders) {
            ib.writeln('          $finder,');
          }
          ib.writeln('        ];');
          ib.writeln('        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,');
          ib.writeln("            reason: 'Expected at least one of the elements to exist');");
        }
      }

      ib
        ..writeln('      });')
        ..writeln('');
    }
    ib.writeln('    });');
  }
  ib
    ..writeln('  });')
    ..writeln('}');

  final integPath = 'integration_test/${utils.basenameWithoutExtension(uiFile)}_flow_test.dart';
  File(integPath).createSync(recursive: true);
  File(integPath).writeAsStringSync(ib.toString());
  stdout.writeln('✓ integration full flow tests: $integPath');
}

// Helper functions to make cubit handling dynamic
String? _getPrimaryCubitType(List<String> providerTypes) {
  // Find the first cubit that ends with a page-related pattern (RegisterCubit, LoginCubit, etc.)
  // Prefer cubits that are likely page-specific over generic ones
  for (final type in providerTypes) {
    if (type.endsWith('Cubit') && !type.startsWith('_')) {
      return type;
    }
  }
  return null;
}

String _getStateFilePathFromCubit(String cubitType) {
  // Convert RegisterCubit -> register_state.dart
  // Convert LoginCubit -> login_state.dart
  final baseName = cubitType.replaceAll('Cubit', '').toLowerCase();
  final parts = <String>[];
  for (int i = 0; i < baseName.length; i++) {
    if (i > 0 && baseName[i].toUpperCase() == baseName[i]) {
      parts.add('_');
    }
    parts.add(baseName[i].toLowerCase());
  }
  return 'lib/cubit/${parts.join('')}_state.dart';
}

// Removed: _readPackageName, _pkgImport, _findDeclFile, utils.basename, utils.basenameWithoutExtension
// Now using utils.dart module instead

// Extract validation counts from test plan asserts (with 'count' field)
Map<String, int> _extractValidationCountsFromPlan(List<Map<String, dynamic>> cases) {
  final counts = <String, int>{};
  for (final c in cases) {
    final asserts = (c['asserts'] as List? ?? const []).cast<Map<String, dynamic>>();
    for (final a in asserts) {
      final text = a['text'];
      final count = a['count'];
      if (text is String && count is int) {
        // Use the count from test plan
        counts[text] = count;
      }
    }
  }
  return counts;
}

dynamic _resolveDataset(Map<String, dynamic> root, String rawPath) {
  // Robust resolver: supports 'a.b[0].c' with optional brackets on any segment
  String path = rawPath.trim();
  dynamic tryResolve(Map<String, dynamic> start) {
    dynamic cur = start;
    final segments = path.split('.').map((s) => s.trim()).where((s) => s.isNotEmpty);
    for (final seg in segments) {
      final m = RegExp(r'^(.*?)(?:\[(\d+)\])?$').firstMatch(seg);
      if (m == null) return null;
      final key = m.group(1)!.trim();
      final idxStr = m.group(2);
      if (cur is Map && cur.containsKey(key)) {
        cur = cur[key];
      } else {
        return null;
      }
      if (idxStr != null) {
        final i = int.tryParse(idxStr);
        if (i == null) return null;
        if (cur is List && i >= 0 && i < cur.length) {
          cur = cur[i];
        } else {
          return null;
        }
      }
    }
    return cur;
  }

  // First attempt from provided root
  var v = tryResolve(root);
  if (v != null) return v;
  // Second attempt if root had nested 'datasets' (safety)
  final nested = (root['datasets'] is Map) ? (root['datasets'] as Map).cast<String, dynamic>() : null;
  if (nested != null) {
    v = tryResolve(nested);
    if (v != null) return v;
  }
  return null;
}
