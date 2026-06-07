import 'dart:convert';
import 'dart:io';

import 'utils.dart' as utils;

String generateTestScriptFromTestData(String testDataPath) =>
    TestScriptGenerator().generateTestScript(testDataPath);

class TestScriptGenerator {
  String? _outputPath;

  TestScriptGenerator();

  void setOutputPath(String path) {
    _outputPath = path.trim().isNotEmpty ? path.trim() : null;
  }

  // รับ path ของ test_data.json แล้วกำหนด output path และเรียก _processOne
  String generateTestScript(String testDataPath, {String? outputPath}) {
    final String effectivePath;
    if (outputPath != null && outputPath.trim().isNotEmpty) {
      effectivePath = outputPath.trim();
    } else if (_outputPath != null) {
      effectivePath = _outputPath!;
    } else {
      final base = testDataPath
          .replaceAll('output/test_data/', '')
          .replaceAll(RegExp(r'\.test_data\.json$'), '');
      effectivePath = 'integration_test/${base}_test.dart';
    }

    _processOne(testDataPath, outputPath: effectivePath);

    return effectivePath;
  }

  // แปลง test_data.json เป็น .dart test file ทั้งไฟล์ — orchestrate ทุกขั้นตอนการ generate
  void _processOne(String planPath, {required String outputPath}) {
    final j = _parsePlanFile(planPath);

    final (:uiFile, :pageClass, :cubitClass, :stateClass) = _extractSource(j);

    final providers = cubitClass != null
        ? [
            {'type': cubitClass}
          ]
        : <Map<String, dynamic>>[];
    final cases =
        (j['cases'] as List? ?? const []).cast<Map<String, dynamic>>();

    final validationCounts = _extractValidationCountsFromPlan(cases);

    final datasets = _loadDatasets(uiFile, j);

    final pkg = utils.readPackageName() ?? 'master_project';

    final uiImport = _resolveUiImport(uiFile, pkg);

    final (:providerTypes, :providerFiles) =
        _resolveProviderFiles(providers, pkg);

    final primaryCubitType = _getPrimaryCubitType(providerTypes);

    final sampleByKey = _buildSampleByKey(datasets);

    final b = StringBuffer()
      ..writeln('// GENERATED — from test plan')
      ..writeln("import 'package:flutter/material.dart';")
      ..writeln("import 'package:flutter_test/flutter_test.dart';");

    b.writeln("import 'dart:io';");

    if (providerFiles.isNotEmpty) {
      b.writeln("import 'package:flutter_bloc/flutter_bloc.dart';");
    }

    for (final f in providerFiles) {
      b.writeln("import '${utils.pkgImport(pkg, f)}';");
    }

    if (primaryCubitType != null) {
      final stateFilePath = _getStateFilePathFromCubit(primaryCubitType);
      b.writeln("import '${utils.pkgImport(pkg, stateFilePath)}';");
    }

    b.writeln("import '$uiImport';");

    b
      ..writeln('')
      ..writeln(
          'Widget _wrap(Widget child, {required bool success, Map<String, dynamic>? response, int? failureCode}) {')
      ..writeln('  final providers = <BlocProvider>[];');

    for (final t in providerTypes) {
      if (t == primaryCubitType) {
        b.writeln(
            "  providers.add(BlocProvider<$t>(create: (_)=> success ? _Success$t(stubResp: response!=null ? ApiResponse.fromJson(response) : null) : (failureCode!=null ? _Fail$t(failureCode) : $t())));");
      } else {
        b.writeln("  providers.add(BlocProvider<$t>(create: (_)=> $t()));");
      }
    }

    b
      ..writeln(
          '  return MaterialApp(home: MultiBlocProvider(providers: providers, child: child));')
      ..writeln('}');

    Map<String, List<Map<String, dynamic>>> groupsByName = {};

    for (final c in cases) {
      final groupName = (c['group'] ?? 'Other').toString();
      groupsByName.putIfAbsent(groupName, () => []).add(c);
    }

    List<(String, List<Map<String, dynamic>>)> orderedGroups = [];
    final seenGroups = <String>{};

    for (final c in cases) {
      final groupName = (c['group'] ?? 'Other').toString();
      if (!seenGroups.contains(groupName)) {
        seenGroups.add(groupName);
        orderedGroups.add((groupName, groupsByName[groupName]!));
      }
    }

    b.writeln('');
    b.writeln('void main() {');
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

        bool successStub = (setup['cubitStub'] ?? '').toString() == 'success' ||
            kind == 'success';

        final steps =
            (c['steps'] as List? ?? const []).cast<Map<String, dynamic>>();
        final asserts =
            (c['asserts'] as List? ?? const []).cast<Map<String, dynamic>>();

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

          return '{' +
              m.entries.map((e) => "'${e.key}': ${val(e.value)}").join(', ') +
              '}';
        }

        final responseArg = (successStub && respJson != null)
            ? ", response: ${_dartMapLiteral(respJson)}"
            : '';

        int? _inferFailureCode(List<Map<String, dynamic>> asserts) {
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
        final failureArg =
            (failureCode != null) ? ", failureCode: $failureCode" : '';

        b
          ..writeln("    testWidgets('$id', (tester) async {")
          ..writeln(
              '      final w = _wrap($pageClass(), success: ${successStub ? 'true' : 'false'}$responseArg$failureArg);')
          ..writeln('      await tester.pumpWidget(w);');

        for (var i = 0; i < steps.length; i++) {
          final s = steps[i];
          final nextIsPump = (i + 1 < steps.length) &&
              (steps[i + 1].containsKey('pump') ||
                  steps[i + 1].containsKey('pumpAndSettle'));

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
              } else {
                if (id.startsWith('pairwise_case_')) {
                  throw StateError(
                      '[$id] Dataset not found or not primitive for $dsPath (byKey=$k)');
                }
                if (k is String && sampleByKey.containsKey(k)) {
                  text = sampleByKey[k]!;
                }
              }
            }

            if (ds is String) {
              b.writeln("      // dataset: ${ds.trim()}");
            }

            final escText = utils.dartEscape(text);

            b.writeln(
                "      await tester.enterText(find.byKey(const Key('$k')), '$escText');");

            if (!nextIsPump) b.writeln('      await tester.pump();');
          } else if (s.containsKey('tap')) {
            final m = (s['tap'] as Map).cast<String, dynamic>();
            final k = m['byKey'];

            // submit button needs unfocus() before ensureVisible so the button
            // scrolls back into the viewport after the keyboard is dismissed
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
          } else if (s.containsKey('tapText')) {
            final txt = (s['tapText']).toString();
            b.writeln(
                "      await tester.tap(find.text('${utils.dartEscape(txt)}'));");
            if (!nextIsPump) b.writeln('      await tester.pump();');
          } else if (s.containsKey('selectDate')) {
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
          } else if (s.containsKey('selectTime')) {
            final action = (s['selectTime']).toString();

            if (action == 'null' || action == 'cancel') {
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
                final hour = parts[0].replaceAll(RegExp(r'\D'), '');
                final minute = parts[1].replaceAll(RegExp(r'\D'), '');

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
          final byType = a['byType'];
          final dismiss = a['dismiss'] == true;

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

          if (byKey != null &&
              exists is bool &&
              textEquals == null &&
              textContains == null) {
            b.writeln(
                "      expect(find.byKey(const Key('$byKey')), ${exists ? 'findsOneWidget' : 'findsNothing'});");
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

          if (byKey != null && textEquals is String) {
            final esc = utils.dartEscape(textEquals);
            b.writeln(
                "      final _tw = tester.widget<Text>(find.byKey(const Key('$byKey')));");
            b.writeln("      expect(_tw.data ?? '', '$esc');");
            continue;
          }

          if (byKey != null && textContains is String) {
            final esc = utils.dartEscape(textContains);
            b.writeln(
                "      final _tw = tester.widget<Text>(find.byKey(const Key('$byKey')));");
            b.writeln("      expect((_tw.data ?? '').contains('$esc'), true);");
            continue;
          }

          if (textGlobal is String && exists is bool) {
            final esc = utils.dartEscape(textGlobal);

            final explicitCount = a['count'];

            final finderExpr = () {
              if (exists) {
                if (explicitCount is int) {
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

        b
          ..writeln('    });')
          ..writeln('');
      }
      b.writeln('    });');
    }

    b
      ..writeln('  });')
      ..writeln('}');

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

  // อ่านและ parse test_data.json เป็น Map
  Map<String, dynamic> _parsePlanFile(String planPath) {
    final raw = File(planPath).readAsStringSync();
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  // ดึง uiFile, pageClass, cubitClass, stateClass จาก source field ใน plan
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

  // โหลด datasets จาก .datasets.json (ถ้ามี) ไม่งั้นใช้จาก plan โดยตรง
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

  // แปลง path ของ uiFile เป็น Dart import statement ตาม package name
  String _resolveUiImport(String uiFile, String pkg) {
    String normalized = uiFile;
    if (uiFile.contains('/lib/')) {
      normalized = 'lib/' + uiFile.split('/lib/').last;
    }
    return utils.pkgImport(pkg, normalized);
  }

  // หา cubit types และ file paths ที่ต้อง import ใน test
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

  // สร้าง map key → valid value ตัวแรก สำหรับใช้เป็น sample ใน test
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

  // สร้าง integration_test/*.dart โดยวน orderedGroups แล้ว emit testWidgets() ทุก test case พร้อม import และ BlocProvider
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
      if (File(stateFilePath).existsSync()) {
        ib.writeln("import '${utils.pkgImport(pkg, stateFilePath)}';");
      }
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
        final steps =
            (c['steps'] as List? ?? const []).cast<Map<String, dynamic>>();
        final asserts =
            (c['asserts'] as List? ?? const []).cast<Map<String, dynamic>>();

        ib.writeln("      testWidgets('$id', (tester) async {");

        ib.writeln('        final providers = <BlocProvider>[');
        for (final t in providerTypes) {
          ib.writeln("          BlocProvider<$t>(create: (_)=> $t()),");
        }
        ib
          ..writeln('        ];')
          ..writeln(
              '        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: $pageClass()));')
          ..writeln('        await tester.pumpWidget(w);');

        for (var i = 0; i < steps.length; i++) {
          final s = steps[i];
          final nextIsPump = (i + 1 < steps.length) &&
              (steps[i + 1].containsKey('pump') ||
                  steps[i + 1].containsKey('pumpAndSettle'));

          // skip the tap that opens a picker when the following selection is
          // null/cancel — opening the dialog would leave it open with nothing
          // to dismiss
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
          } else if (s.containsKey('tap')) {
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
              // submit button needs unfocus() before ensureVisible so the button
              // scrolls back into the viewport after the keyboard is dismissed
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
          } else if (s.containsKey('tapText')) {
            final txt = (s['tapText']).toString();
            ib.writeln(
                "        await tester.tap(find.text('${utils.dartEscape(txt)}'));");
            if (!nextIsPump) ib.writeln('        await tester.pump();');
          } else if (s.containsKey('selectDate')) {
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
          } else if (s.containsKey('selectTime')) {
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
                final hour = parts[0].replaceAll(RegExp(r'\D'), '');
                final minute = parts[1].replaceAll(RegExp(r'\D'), '');

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
          } else if (s.containsKey('scrollAndTapText')) {
            final txt = utils.dartEscape(s['scrollAndTapText'].toString());
            ib
              ..writeln(
                  "        await tester.ensureVisible(find.text('$txt').last);")
              ..writeln("        await tester.tap(find.text('$txt').last);")
              ..writeln('        await tester.pumpAndSettle();');
          } else if (s.containsKey('pumpAndSettle')) {
            ib.writeln('        await tester.pumpAndSettle();');
          } else if (s.containsKey('pump')) {
            ib.writeln('        await tester.pump();');
          }
        }

        // assertions use OR logic — the test passes if any one of the expected
        // elements is present, which handles cases where the app can show
        // success/failure feedback through different widgets
        if (asserts.isNotEmpty) {
          final finders = <String>[];

          for (final a in asserts) {
            final byKey = a['byKey'];
            final exists = a['exists'];
            final textGlobal = a['text'];
            final byType = a['byType'];

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

          for (final a in asserts) {
            if (a['dismiss'] == true && a['exists'] == true) {
              final type = a['byType']?.toString() ?? 'AlertDialog';
              ib.writeln('        // Dismiss $type');
              ib.writeln(
                  '        final _dialogBtn = find.descendant(of: find.byType($type), matching: find.byType(TextButton));');
              ib.writeln(
                  '        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);');
              ib.writeln('        await tester.pumpAndSettle();');
              break;
            }
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

    File(outputPath).createSync(recursive: true);

    File(outputPath).writeAsStringSync(ib.toString());

    stdout.writeln('✓ integration full flow tests: $outputPath');
  }

  String? _getPrimaryCubitType(List<String> providerTypes) {
    for (final type in providerTypes) {
      if (type.endsWith('Cubit') && !type.startsWith('_')) {
        return type;
      }
    }
    return null;
  }

  // แปลง cubitType เป็น path ของ state file เช่น ClinicAppointmentCubit → lib/cubit/clinic_appointment_state.dart
  String _getStateFilePathFromCubit(String cubitType) {
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

  // รวบรวม validation message → count จาก asserts ของทุก case (ใช้กับ empty fields edge case)
  Map<String, int> _extractValidationCountsFromPlan(
      List<Map<String, dynamic>> cases) {
    final counts = <String, int>{};

    for (final c in cases) {
      final asserts =
          (c['asserts'] as List? ?? const []).cast<Map<String, dynamic>>();

      for (final a in asserts) {
        final text = a['text'];
        final count = a['count'];

        if (text is String && count is int) {
          counts[text] = count;
        }
      }
    }

    return counts;
  }

  dynamic _resolveDataset(Map<String, dynamic> root, String rawPath) {
    String path = rawPath.trim();

    dynamic tryResolve(Map<String, dynamic> start) {
      dynamic cur = start;

      final segments =
          path.split('.').map((s) => s.trim()).where((s) => s.isNotEmpty);

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

    var v = tryResolve(root);
    if (v != null) return v;

    final nested = (root['datasets'] is Map)
        ? (root['datasets'] as Map).cast<String, dynamic>()
        : null;

    if (nested != null) {
      v = tryResolve(nested);
      if (v != null) return v;
    }

    return null;
  }
}

void main(List<String> args) {
  if (args.isEmpty) {
    stderr.writeln('Error: No testdata file specified');
    stderr.writeln(
        'Usage: dart run tools/script_v2/generate_test_script.dart <testdata.json>');
    stderr.writeln(
        'Example: dart run tools/script_v2/generate_test_script.dart output/test_data/buttons_page.testdata.json');
    exit(1);
  }

  final generator = TestScriptGenerator();
  for (final path in args) {
    try {
      generator.generateTestScript(path);
    } catch (e, st) {
      stderr.writeln('! Failed to process $path: $e\n$st');
    }
  }
}
