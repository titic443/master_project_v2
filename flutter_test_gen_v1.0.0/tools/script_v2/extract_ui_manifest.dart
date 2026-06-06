import 'dart:convert';
import 'dart:io';

import 'utils.dart' as utils;

void main(List<String> args) {
  if (args.isEmpty) {
    stderr.writeln('Error: No file specified');
    stderr.writeln(
        'Usage: dart run tools/script_v2/extract_ui_manifest.dart <file.dart>');
    stderr.writeln(
        'Example: dart run tools/script_v2/extract_ui_manifest.dart lib/demos/buttons_page.dart');
    exit(1);
  }

  final extractor = UiManifestExtractor();
  for (final p in args) {
    extractor.extractManifest(p);
  }
}

// Backward-compatible wrapper — delegates to [UiManifestExtractor].
String processUiFile(String path) =>
    const UiManifestExtractor().extractManifest(path);

class UiManifestExtractor {
  const UiManifestExtractor();

  String extractManifest(String path) {
    if (!File(path).existsSync()) {
      throw Exception('File not found: $path');
    }

    _processOne(path);

    final normalizedPath = path.replaceAll('\\', '/');
    String subfolderPath = '';

    if (normalizedPath.startsWith('lib/')) {
      final pathAfterLib = normalizedPath.substring(4);
      final lastSlash = pathAfterLib.lastIndexOf('/');
      if (lastSlash > 0) {
        subfolderPath = pathAfterLib.substring(0, lastSlash);
      }
    }

    final outDir = subfolderPath.isNotEmpty
        ? Directory('output/manifest/$subfolderPath')
        : Directory('output/manifest');
    return '${outDir.path}/${utils.basenameWithoutExtension(path)}.manifest.json';
  }

  void _processOne(String path) {
    if (!File(path).existsSync()) {
      stderr.writeln('File not found: $path');
      return;
    }

    final rawSrc = File(path).readAsStringSync();

    // rawSrc (not stripped) is used for picker scanning because _scanDateTimePickers
    // needs method bodies to find containing method names via regex lookbehind.
    final src = _stripComments(rawSrc);

    final consts = _collectStringConsts(src);

    final pageClass =
        _findPageClass(src) ?? utils.basenameWithoutExtension(path);

    final cubitType = _findCubitType(src);
    final stateType = _findStateType(src);

    final cubitFilePath = _findCubitFilePath(src, cubitType);
    final stateFilePath = _findStateFilePath(src, stateType);

    final widgets = _scanWidgets(src, consts: consts, cubitType: cubitType);
    final pickers = _scanDateTimePickers(rawSrc);

    final seen = <String>{};
    final widgetsWithKeys = <Map<String, dynamic>>[];

    for (final w in widgets) {
      final key = w['key'];

      if (key != null && key is String && key.isNotEmpty) {
        if (seen.add(key)) {
          final onTap = w['onTap'];
          if (onTap != null && onTap is String && pickers.containsKey(onTap)) {
            w['pickerMetadata'] = pickers[onTap];
          }
          widgetsWithKeys.add(w);
        }
      }
    }

    // Sort by leading numeric sequence in key first, then by source order.
    widgetsWithKeys.sort((a, b) {
      final keyA = (a['key'] as String?) ?? '';
      final keyB = (b['key'] as String?) ?? '';

      final seqA = _extractSequence(keyA);
      final seqB = _extractSequence(keyB);

      if (seqA != null && seqB != null) {
        return seqA.compareTo(seqB);
      }
      if (seqA != null) return -1;
      if (seqB != null) return 1;

      final orderA = (a['sourceOrder'] as int?) ?? 0;
      final orderB = (b['sourceOrder'] as int?) ?? 0;
      return orderA.compareTo(orderB);
    });

    // sourceOrder is a sort key only — not part of the manifest output.
    for (final w in widgetsWithKeys) {
      w.remove('sourceOrder');
    }

    final ir = {
      'source': {
        'file': path,
        'pageClass': pageClass,
        if (cubitType != null) 'cubitClass': cubitType,
        if (stateType != null) 'stateClass': stateType,
        if (cubitFilePath != null) 'fileCubit': cubitFilePath,
        if (stateFilePath != null) 'fileState': stateFilePath,
      },
      'widgets': widgetsWithKeys,
    };

    final normalizedPath = path.replaceAll('\\', '/');
    String subfolderPath = '';

    if (normalizedPath.startsWith('lib/')) {
      final pathAfterLib = normalizedPath.substring(4);
      final lastSlash = pathAfterLib.lastIndexOf('/');
      if (lastSlash > 0) {
        subfolderPath = pathAfterLib.substring(0, lastSlash);
      }
    }

    final outDir = subfolderPath.isNotEmpty
        ? Directory('output/manifest/$subfolderPath')
        : Directory('output/manifest');
    outDir.createSync(recursive: true);

    final outPath =
        '${outDir.path}/${utils.basenameWithoutExtension(path)}.manifest.json';
    _writeManifestFile(outPath, ir);
  }

  void _writeManifestFile(String outPath, Map<String, dynamic> ir) {
    File(outPath).writeAsStringSync(
        const JsonEncoder.withIndent('  ').convert(ir) + '\n');
    stdout.writeln('✓ Manifest written: $outPath');
  }

  String _stripComments(String s) {
    final b = StringBuffer();

    bool inS = false;    // inside single-quoted string '...'
    bool inD = false;    // inside double-quoted string "..."
    bool inRawS = false; // inside raw single-quoted string r'...'
    bool inRawD = false; // inside raw double-quoted string r"..."
    bool inLine = false; // inside line comment //
    bool inBlock = false; // inside block comment /* */

    for (int i = 0; i < s.length; i++) {
      final c = s[i];
      final next = i + 1 < s.length ? s[i + 1] : '';

      if (inLine) {
        if (c == '\n') {
          inLine = false;
          b.write(c);
        }
        continue;
      }

      if (inBlock) {
        if (c == '*' && next == '/') {
          inBlock = false;
          i++;
        }
        continue;
      }

      if (!inS && !inD && !inRawS && !inRawD) {
        if (c == '/' && next == '/') {
          inLine = true;
          i++;
          continue;
        }
        if (c == '/' && next == '*') {
          inBlock = true;
          i++;
          continue;
        }
      }

      if (!inS && !inD && !inRawS && !inRawD && (c == 'r' || c == 'R')) {
        final n2 = i + 1 < s.length ? s[i + 1] : '';
        if (n2 == '\'' || n2 == '"') {
          if (n2 == '\'')
            inRawS = true;
          else
            inRawD = true;
          b.write(c);
          i++;
          b.write(n2);
          continue;
        }
      }

      if (!inRawS && !inRawD) {
        if (!inD && c == '\'') {
          inS = !inS;
          b.write(c);
          continue;
        }
        if (!inS && c == '"') {
          inD = !inD;
          b.write(c);
          continue;
        }
        if ((inS || inD) && c == '\\') {
          if (i + 1 < s.length) {
            b.write(c);
            b.write(s[i + 1]);
            i++;
            continue;
          }
        }
      } else {
        // Raw strings have no escape sequences; end at matching quote.
        if (inRawS && c == '\'') {
          inRawS = false;
          b.write(c);
          continue;
        }
        if (inRawD && c == '"') {
          inRawD = false;
          b.write(c);
          continue;
        }
      }

      b.write(c);
    }

    return b.toString();
  }

  String? _findPageClass(String src) {
    final m =
        RegExp(r'class\s+(\w+)\s+extends\s+(?:StatefulWidget|StatelessWidget)')
            .firstMatch(src);
    return m?.group(1);
  }

  List<Map<String, dynamic>> _scanWidgets(String src,
      {Map<String, String> consts = const {}, String? cubitType}) {
    final targets = <String>{
      'TextField',
      'TextFormField',
      'FormField',
      'Radio',
      'ElevatedButton',
      'TextButton',
      'OutlinedButton',
      'IconButton',
      'Text',
      'DropdownButton',
      'DropdownButtonFormField',
      'Checkbox',
      'Switch',
      'SwitchListTile',
      'Slider',
      'ListTile',
      'Visibility',
      'SnackBar',
      'AlertDialog',
      'SimpleDialog',
    };

    final out = <Map<String, dynamic>>[];

    final regexVars = _collectRegexVars(src);

    int i = 0;
    int sourceOrder = 0;

    while (i < src.length) {
      // Group 1: Widget name  Group 2: Generic type parameter (optional)
      final m =
          RegExp(r'([A-Z][A-Za-z0-9_]*)\s*(<[^>]*>)?\s*\(').matchAsPrefix(src, i);

      if (m == null) {
        i++;
        continue;
      }

      final type = m.group(1)!;
      final generics = m.group(2);

      if (!targets.contains(type)) {
        i = m.end;
        continue;
      }

      final startArgs = m.end - 1;
      final endIdx = _matchParen(src, startArgs);

      if (endIdx == -1) {
        i = m.end;
        continue;
      }

      final argsSrc = src.substring(startArgs + 1, endIdx);

      final key = _extractKey(argsSrc, consts: consts);

      final binding =
          type == 'Text' ? _extractTextBinding(argsSrc, consts: consts) : null;

      final onTapMethod = _extractOnTapMethod(argsSrc);

      Map<String, dynamic> meta = {};

      if (type == 'TextField' || type == 'TextFormField') {
        meta.addAll(_extractTextFieldMeta(argsSrc, regexVars: regexVars));
      }

      if (type.startsWith('Radio')) {
        meta.addAll(_extractRadioMeta(argsSrc));
      }

      meta.addAll(_extractValidationMeta(type, argsSrc));

      // FormField's argsSrc contains builder: {...} whose braces confuse
      // _extractValidationMeta; re-extract from the pre-builder section only.
      if (type == 'FormField') {
        final builderIdx = argsSrc.indexOf('builder');
        final preBuilder =
            builderIdx > 0 ? argsSrc.substring(0, builderIdx) : argsSrc;
        final preMeta = _extractValidationMeta('FormField', preBuilder);
        if (preMeta.containsKey('validatorRules')) {
          meta['validatorRules'] = preMeta['validatorRules'];
        }
      }

      out.add({
        'widgetType': type + (generics != null ? generics : ''),
        // FormField key is excluded to prevent stealing keys declared inside the builder closure.
        if (key != null && type != 'FormField') 'key': key,
        if (binding != null) 'displayBinding': binding,
        if (type == 'Text') ..._maybeTextLiteral(argsSrc),
        if (meta.isNotEmpty) 'meta': meta,
        if (onTapMethod != null) 'onTap': onTapMethod,
        'sourceOrder': sourceOrder++,
      });

      final nested = _scanWidgets(argsSrc, consts: consts, cubitType: cubitType);
      if (nested.isNotEmpty) {
        // Radio/Checkbox/Switch/SwitchListTile/Slider don't have their own
        // validator: parameter; propagate it from the enclosing FormField.
        if (type == 'FormField') {
          final rules = meta['validatorRules'];
          if (rules != null) {
            const wrapTargets = {
              'Radio', 'Checkbox', 'Switch', 'SwitchListTile', 'Slider'
            };
            for (final n in nested) {
              final raw = (n['widgetType'] as String? ?? '');
              final base =
                  raw.contains('<') ? raw.substring(0, raw.indexOf('<')) : raw;
              if (wrapTargets.contains(base)) {
                final nMeta = Map<String, dynamic>.from(
                    (n['meta'] as Map<String, dynamic>?) ?? {});
                if (!nMeta.containsKey('validatorRules')) {
                  nMeta['validatorRules'] = rules;
                  n['meta'] = nMeta;
                }
              }
            }
          }
        }
        for (final n in nested) {
          if (!n.containsKey('sourceOrder')) {
            n['sourceOrder'] = sourceOrder++;
          }
        }
        out.addAll(nested);
      }

      i = endIdx + 1;
    }

    return out;
  }

  int _matchParen(String s, int openIdx) {
    int depth = 0;
    bool inS = false; // inside single-quoted string '...'
    bool inD = false; // inside double-quoted string "..."

    for (int i = openIdx; i < s.length; i++) {
      final c = s[i];

      if (!inS && !inD) {
        if (c == '(') depth++;
        if (c == ')') {
          depth--;
          if (depth == 0) return i;
        }
        if (c == '\'') inS = true;
        if (c == '"') inD = true;
      } else {
        if (inS && c == '\'') inS = false;
        if (inD && c == '"') inD = false;
      }
    }
    return -1;
  }

  int _matchBrace(String s, int openIdx) {
    int depth = 0;
    bool inS = false; // inside single-quoted string '...'
    bool inD = false; // inside double-quoted string "..."

    for (int i = openIdx; i < s.length; i++) {
      final c = s[i];

      if (!inS && !inD) {
        if (c == '{') depth++;
        if (c == '}') {
          depth--;
          if (depth == 0) return i;
        }
        if (c == '\'') inS = true;
        if (c == '"') inD = true;
      } else {
        if (inS && c == '\'') inS = false;
        if (inD && c == '"') inD = false;
      }
    }
    return -1;
  }

  String? _extractKey(String args, {Map<String, String> consts = const {}}) {
    String resolve(String s) => s.replaceAllMapped(RegExp(r"\$\{(\w+)\}"), (mm) {
          final name = mm.group(1)!;
          return consts[name] ?? mm.group(0)!;
        });

    // Pattern 1: Key('...')
    var m =
        RegExp(r"key\s*:\s*(?:const\s+)?Key\(\s*'([^']+)'\s*\)").firstMatch(args);
    if (m != null) return resolve(m.group(1)!);

    // Pattern 2: Key("...")
    m = RegExp(r'key\s*:\s*(?:const\s+)?Key\(\s*"([^\"]+)"\s*\)')
        .firstMatch(args);
    if (m != null) return resolve(m.group(1)!);

    // Pattern 3: ValueKey<T>('...')
    m = RegExp(r"key\s*:\s*(?:const\s+)?ValueKey(?:<[^>]+>)?\(\s*'([^']+)'\s*\)")
        .firstMatch(args);
    if (m != null) return resolve(m.group(1)!);

    // Pattern 4: ValueKey("...")
    m = RegExp(r'key\s*:\s*(?:const\s+)?ValueKey(?:<[^>]+>)?\(\s*"([^\"]+)"\s*\)')
        .firstMatch(args);
    if (m != null) return resolve(m.group(1)!);

    // Pattern 5: ObjectKey([...]) — extract first string in the list
    m = RegExp(r'key\s*:\s*(?:const\s+)?ObjectKey\(\s*\[([^\]]*)\]\s*\)')
        .firstMatch(args);
    if (m != null) {
      final inside = m.group(1) ?? '';
      final ms = RegExp(r"'([^']+)'").firstMatch(inside) ??
          RegExp(r'"([^\"]+)"').firstMatch(inside);
      if (ms != null) return resolve(ms.group(1)!);
    }

    return null;
  }

  String? _extractOnTapMethod(String args) {
    // Pattern 1: onTap: () => _methodName(...)
    final arrowPattern =
        RegExp(r'onTap\s*:\s*\(\s*\)\s*=>\s*([A-Za-z_]\w*)\s*\(');
    final arrowMatch = arrowPattern.firstMatch(args);
    if (arrowMatch != null) {
      return arrowMatch.group(1);
    }

    // Pattern 2: onTap: () { _methodName(...); }
    final blockPattern =
        RegExp(r'onTap\s*:\s*\(\s*\)\s*\{\s*([A-Za-z_]\w*)\s*\(');
    final blockMatch = blockPattern.firstMatch(args);
    if (blockMatch != null) {
      return blockMatch.group(1);
    }

    // Pattern 3: onTap: _methodName  (tear-off, must be followed by comma or closing paren)
    final directPattern = RegExp(r'onTap\s*:\s*([A-Za-z_]\w*)(?:\s*[,\)]|$)');
    final directMatch = directPattern.firstMatch(args);
    if (directMatch != null) {
      return directMatch.group(1);
    }

    return null;
  }

  Map<String, String>? _extractTextBinding(String args,
      {Map<String, String> consts = const {}}) {
    final key = _extractKey(args, consts: consts);

    final m = RegExp(r'\bstate\.(\w+)\b').firstMatch(args);

    if (key != null && m != null) {
      return {'key': key, 'stateField': m.group(1)!};
    }
    return null;
  }

  Map<String, dynamic> _maybeTextLiteral(String args) {
    final m1 = RegExp(
            r"(?:^|[,(])\s*(?:const\s+)?(?:Text\s*\()?\s*'([^']+)'\s*(?:\)|,|$)")
        .firstMatch(args);
    if (m1 != null) {
      return {'textLiteral': m1.group(1)};
    }

    final m2 = RegExp(r"\bdata\s*:\s*'([^']+)'").firstMatch(args);
    if (m2 != null) return {'textLiteral': m2.group(1)};

    return const {};
  }

  Map<String, dynamic> _extractTextFieldMeta(String args,
      {Map<String, String> regexVars = const {}}) {
    final meta = <String, dynamic>{};

    final kt =
        RegExp(r'keyboardType\s*:\s*TextInputType\.(\w+)').firstMatch(args);
    if (kt != null) meta['keyboardType'] = kt.group(1);

    final ob = RegExp(r'obscureText\s*:\s*(true|false)').firstMatch(args);
    if (ob != null) meta['obscureText'] = ob.group(1) == 'true';

    final ml = RegExp(r'maxLength\s*:\s*(\d+)').firstMatch(args);
    if (ml != null) meta['maxLength'] = int.tryParse(ml.group(1)!);

    final fm = <Map<String, dynamic>>[];

    if (RegExp(r'FilteringTextInputFormatter\s*\.\s*digitsOnly').hasMatch(args)) {
      fm.add({'type': 'digitsOnly'});
    }

    if (RegExp(r'FilteringTextInputFormatter\s*\.\s*singleLine').hasMatch(args)) {
      fm.add({'type': 'singleLine'});
    }

    for (final m in RegExp(
            r"FilteringTextInputFormatter\s*\.\s*allow\s*\(\s*RegExp\(([^)]*)\)\s*(?:,\s*replacementString\s*:\s*'([^']*)')?\s*,?\s*\)")
        .allMatches(args)) {
      final inside = m.group(1) ?? '';
      final s1 = RegExp(r"r?'([^']*)'").firstMatch(inside);
      final s2 = s1 ?? RegExp(r'r?\"([^\"]*)\"').firstMatch(inside);
      final pat = (s2?.group(1)) ?? '';
      final repl = m.group(2);
      if (pat.isNotEmpty) {
        fm.add({
          'type': 'allow',
          'pattern': pat,
          if (repl != null) 'replacement': repl
        });
      }
    }

    for (final m in RegExp(
            r"FilteringTextInputFormatter\s*\.\s*deny\s*\(\s*RegExp\(([^)]*)\)\s*(?:,\s*replacementString\s*:\s*'([^']*)')?\s*,?\s*\)")
        .allMatches(args)) {
      final inside = m.group(1) ?? '';
      final s1 = RegExp(r"r?'([^']*)'").firstMatch(inside);
      final s2 = s1 ?? RegExp(r'r?\"([^\"]*)\"').firstMatch(inside);
      final pat = (s2?.group(1)) ?? '';
      final repl = m.group(2);
      if (pat.isNotEmpty) {
        fm.add({
          'type': 'deny',
          'pattern': pat,
          if (repl != null) 'replacement': repl
        });
      }
    }

    for (final m in RegExp(
            r"FilteringTextInputFormatter\s*\.\s*(allow|deny)\s*\(\s*([A-Za-z_]\w*)\s*(?:,\s*replacementString\s*:\s*'([^']*)')?\s*\)")
        .allMatches(args)) {
      final kind = m.group(1)!; // 'allow' or 'deny'
      final varName = m.group(2)!;
      final repl = m.group(3);
      final pat = regexVars[varName];
      if (pat != null && pat.isNotEmpty) {
        fm.add({
          'type': kind,
          'pattern': pat,
          if (repl != null) 'replacement': repl
        });
      }
    }

    for (final m
        in RegExp(r"WhitelistingTextInputFormatter\s*\(\s*RegExp\(([^)]*)\)\s*\)")
            .allMatches(args)) {
      final inside = m.group(1) ?? '';
      final s1 = RegExp(r"r?'([^']*)'").firstMatch(inside);
      final s2 = s1 ?? RegExp(r'r?\"([^\"]*)\"').firstMatch(inside);
      final pat = (s2?.group(1)) ?? '';
      if (pat.isNotEmpty) fm.add({'type': 'allowLegacy', 'pattern': pat});
    }

    for (final m
        in RegExp(r"BlacklistingTextInputFormatter\s*\(\s*RegExp\(([^)]*)\)\s*\)")
            .allMatches(args)) {
      final inside = m.group(1) ?? '';
      final s1 = RegExp(r"r?'([^']*)'").firstMatch(inside);
      final s2 = s1 ?? RegExp(r'r?\"([^\"]*)\"').firstMatch(inside);
      final pat = (s2?.group(1)) ?? '';
      if (pat.isNotEmpty) fm.add({'type': 'denyLegacy', 'pattern': pat});
    }

    for (final m in RegExp(r'LengthLimitingTextInputFormatter\s*\(\s*(\d+)\s*\)')
        .allMatches(args)) {
      fm.add({'type': 'lengthLimit', 'max': int.tryParse(m.group(1) ?? '')});
    }

    for (final m
        in RegExp(r'([A-Za-z_]\w*Formatter)\s*\(([^)]*)\)').allMatches(args)) {
      final name = m.group(1)!;
      final a = (m.group(2) ?? '').trim();

      if (name.contains('FilteringTextInputFormatter') ||
          name.contains('LengthLimitingTextInputFormatter')) continue;

      fm.add({'type': 'custom', 'name': name, if (a.isNotEmpty) 'args': a});
    }

    if (fm.isNotEmpty) meta['inputFormatters'] = fm;

    return meta;
  }

  Map<String, dynamic> _extractValidationMeta(String widgetType, String args) {
    final meta = <String, dynamic>{};

    if (RegExp(r'\bvalidator\s*:').hasMatch(args)) {
      final idx = args.indexOf('validator');
      if (idx >= 0) {
        final tail = args.substring(idx);

        String body;
        final braceOpen = tail.indexOf('{');

        if (braceOpen >= 0) {
          final braceClose = _matchBrace(tail, braceOpen);
          body = tail.substring(braceOpen + 1, braceClose);
        } else {
          final stop =
              RegExp(r",\s*\n\s*[A-Za-z_]\\w*\s*:").firstMatch(tail)?.start ??
                  RegExp(r"\)[,\)]").firstMatch(tail)?.start ??
                  (tail.length > 300 ? 300 : tail.length);
          body = tail.substring(0, stop);
        }

        final msgs = <String>{};
        for (final m in RegExp(r"'([^']+)'").allMatches(body)) {
          msgs.add(m.group(1)!);
        }
        for (final m in RegExp(r'"([^"]+)"').allMatches(body)) {
          msgs.add(m.group(1)!);
        }

        final rules = <Map<String, String>>[];
        int pos = 0;

        while (true) {
          final ifIdx = body.indexOf('if', pos);
          if (ifIdx < 0) break;

          final open = body.indexOf('(', ifIdx);
          if (open < 0) break;
          final close = _matchParen(body, open);
          if (close < 0) break;

          final cond = body.substring(open + 1, close).trim();

          final after = body.substring(close + 1);
          final rm = RegExp("return\\s*(['\"])((?:\\\\.|[^\\\\])*?)\\1\\s*;")
              .firstMatch(after);

          if (rm != null) {
            final msg = (rm.group(2) ?? '').trim();
            if (cond.isNotEmpty && msg.isNotEmpty) {
              rules.add({'condition': cond, 'message': msg});
            }
            pos = close + 1 + rm.end;
          } else {
            pos = close + 1;
          }
        }

        for (final m in RegExp(
                "\\((.*?)\\)\\s*\\?\\s*(['\"])((?:\\\\.|[^\\\\])*?)\\2\\s*:\\s*null",
                dotAll: true)
            .allMatches(body)) {
          final cond = (m.group(1) ?? '').trim();
          final msg = (m.group(3) ?? '').trim();
          if (cond.isNotEmpty && msg.isNotEmpty) {
            rules.add({'condition': cond, 'message': msg});
          }
        }

        if (rules.isEmpty) {
          for (final m in RegExp(
                  "=>\\s*(.*?)\\s*\\?\\s*(['\"])((?:\\\\.|[^\\\\])*?)\\2\\s*:\\s*null",
                  dotAll: true)
              .allMatches(body)) {
            final cond = (m.group(1) ?? '').trim();
            final msg = (m.group(3) ?? '').trim();
            if (cond.isNotEmpty && msg.isNotEmpty) {
              rules.add({'condition': cond, 'message': msg});
            }
          }
        }

        // Fallback: synthesize a rule from a bare RegExp + message when no
        // explicit if/return or ternary pattern was found.
        if (rules.isEmpty) {
          final rxPat = RegExp("RegExp\\(\\s*r?(['\\\"])((?:.|\\n)*?)\\1\\s*\\)")
              .firstMatch(body);
          final patternStr = rxPat?.group(2)?.trim();

          if (patternStr != null && patternStr.isNotEmpty) {
            final candidates =
                msgs.where((m) => m != 'Required' && m != patternStr).toList();
            if (candidates.isNotEmpty) {
              rules.add({
                'condition': "!RegExp(r'$patternStr').hasMatch(value)",
                'message': candidates.first,
              });
            }
          }
        }

        if (rules.isNotEmpty) meta['validatorRules'] = rules;

        try {
          final rxPat2 = RegExp("RegExp\\(\\s*r?(['\\\"])((?:.|\\n)*?)\\1\\s*\\)")
              .firstMatch(body);
          final patternStr2 = rxPat2?.group(2)?.trim();

          if (patternStr2 != null && patternStr2.isNotEmpty) {
            final strMatches = <String>[];
            for (final m in RegExp("'([^']+)'", dotAll: true).allMatches(body)) {
              strMatches.add(m.group(1)!);
            }
            for (final m in RegExp('"([^"]+)"', dotAll: true).allMatches(body)) {
              strMatches.add(m.group(1)!);
            }

            // Exclude 'Required', the raw pattern string, and strings that look
            // like regex patterns (anchored or character-class prefixes).
            final likelyMsgs = strMatches
                .where((s) =>
                        s != 'Required' &&
                        s != patternStr2 &&
                        !s.startsWith('^') &&
                        !s.startsWith('[')
                    )
                .toList();

            if (likelyMsgs.isNotEmpty) {
              final messagesAlready = (meta['validatorRules'] as List?)
                      ?.map((e) => (e as Map)['message'] as String)
                      .toSet() ??
                  <String>{};

              for (final lm in likelyMsgs) {
                if (!messagesAlready.contains(lm)) {
                  (meta['validatorRules'] as List).add({
                    'condition': "!RegExp(r'$patternStr2').hasMatch(value)",
                    'message': lm
                  });
                  break;
                }
              }
            }
          }
        } catch (_) {
          // Ignore errors in secondary synthesis
        }
      }
    }

    final av = RegExp(r'autovalidateMode\s*:\s*AutovalidateMode\.(\w+)')
        .firstMatch(args);
    if (av != null) meta['autovalidateMode'] = av.group(1);

    if (widgetType == 'DropdownButton' ||
        widgetType == 'DropdownButtonFormField') {
      final optionEntries = <Map<String, String>>[];
      final itemRegex = RegExp(r'DropdownMenuItem\s*\(([^)]*)\)', dotAll: true);

      for (final match in itemRegex.allMatches(args)) {
        final inside = match.group(1) ?? '';

        String? value = RegExp(r"value\s*:\s*'([^']+)'\s*")
                .firstMatch(inside)
                ?.group(1) ??
            RegExp(r'value\s*:\s*"([^"]+)"\s*').firstMatch(inside)?.group(1) ??
            RegExp(r'value\s*:\s*([^,\)]+)').firstMatch(inside)?.group(1)?.trim();

        String? label = RegExp(r"child\s*:\s*Text\(\s*'([^']+)'")
                .firstMatch(inside)
                ?.group(1) ??
            RegExp(r'child\s*:\s*Text\(\s*"([^"]+)"')
                .firstMatch(inside)
                ?.group(1);

        final entry = <String, String>{};
        if (value != null && value.isNotEmpty) {
          entry['value'] = value.trim();
        }
        if (label != null && label.isNotEmpty) {
          entry['text'] = label.trim();
        } else if (value != null && value.isNotEmpty) {
          entry['text'] = value.trim();
        }

        if (entry.isNotEmpty) optionEntries.add(entry);
      }

      if (optionEntries.isNotEmpty) meta['options'] = optionEntries;
    }

    if (widgetType == 'Checkbox' || widgetType == 'Switch') {
      final val = RegExp(r'\bvalue\s*:\s*([^,\)]+)').firstMatch(args);
      if (val != null) meta['valueBinding'] = val.group(1)!.trim();
    }

    if (widgetType == 'FormField') {
      final options = _collectRadioOptionMeta(args);
      if (options.isNotEmpty) meta['options'] = options;
    }

    // Note: Hints extraction disabled by request (do not emit meta.hints)
    return meta;
  }

  // Removed: _basename, _basenameWithoutExtension - now using utils.dart

  Map<String, String> _collectRegexVars(String src) {
    final out = <String, String>{};

    final rx1 = RegExp(
        r"(?:final|const|var)\s+([A-Za-z_]\w*)\s*=\s*RegExp\(\s*r?'([^']*)'\s*\)");
    for (final m in rx1.allMatches(src)) {
      out[m.group(1)!] = m.group(2)!;
    }

    final rx2 = RegExp(
        r'(?:final|const|var)\s+([A-Za-z_]\w*)\s*=\s*RegExp\(\s*r?"([^"]*)"\s*\)');
    for (final m in rx2.allMatches(src)) {
      out[m.group(1)!] = m.group(2)!;
    }

    return out;
  }

  Map<String, String> _collectStringConsts(String src) {
    final out = <String, String>{};

    final rx = RegExp(r"const\s+(\w+)\s*=\s*'([^']*)'\s*;");
    for (final m in rx.allMatches(src)) {
      out[m.group(1)!] = m.group(2)!;
    }

    return out;
  }

  // Removed: _listFiles - now using utils.listFiles

  String? _findCubitType(String src) {
    for (final rx in [
      RegExp(r'BlocBuilder<\s*(\w+Cubit)\s*,'),
      RegExp(r'BlocListener<\s*(\w+Cubit)\s*,'),
      RegExp(r'context\.(?:read|of)<\s*(\w+Cubit)\s*>'),
      RegExp(r'BlocProvider\.of<\s*(\w+Cubit)\s*>'),
    ]) {
      final m = rx.firstMatch(src);
      if (m != null) return m.group(1);
    }
    return null;
  }

  String? _findStateType(String src) {
    for (final rx in [
      RegExp(r'BlocBuilder<\s*\w+Cubit\s*,\s*(\w+State)\s*>'),
      RegExp(r'BlocListener<\s*\w+Cubit\s*,\s*(\w+State)\s*>'),
      RegExp(r'BlocConsumer<\s*\w+Cubit\s*,\s*(\w+State)\s*>'),
    ]) {
      final m = rx.firstMatch(src);
      if (m != null) return m.group(1);
    }
    return null;
  }

  Map<String, dynamic> _extractRadioMeta(String args) {
    final meta = <String, dynamic>{};

    final v =
        RegExp(r'\bvalue\s*:\s*([^,\)]+)').firstMatch(args)?.group(1)?.trim();
    if (v != null) meta['valueExpr'] = v;

    final gv = RegExp(r'\bgroupValue\s*:\s*([^,\)]+)')
        .firstMatch(args)
        ?.group(1)
        ?.trim();
    if (gv != null) meta['groupValueBinding'] = gv;

    return meta;
  }

  List<Map<String, String>> _collectRadioOptionMeta(String args) {
    final radios = <Map<String, String>>[];
    int index = 0;

    while (true) {
      final start = args.indexOf('Radio<', index);
      if (start == -1) break;

      final open = args.indexOf('(', start);
      if (open == -1) break;

      final close = _matchParen(args, open);
      if (close == -1) break;

      final segment = args.substring(open + 1, close);

      String? extract(String pattern) {
        final m = RegExp(pattern, dotAll: true).firstMatch(segment);
        return m?.group(1)?.trim();
      }

      final value = extract(r'value\s*:\s*([^,\)]+)');

      final following = args.substring(close);
      final labelMatch =
          RegExp(r"Text\(\s*'([^']+)'\s*\)").firstMatch(following) ??
              RegExp(r'Text\(\s*"([^"]+)"\s*\)').firstMatch(following);
      final label = labelMatch?.group(1)?.trim();

      // Only add entry if we have both value and text (same structure as Dropdown)
      if (value != null &&
          value.trim().isNotEmpty &&
          label != null &&
          label.isNotEmpty) {
        final entry = <String, String>{};
        entry['value'] = value.replaceAll(',', '').trim();
        entry['text'] =
            label; // Use 'text' instead of 'label' to match Dropdown structure
        radios.add(entry);
      }

      index = close + 1;
    }

    return radios;
  }

  int? _extractSequence(String key) {
    // Key naming convention: {SEQUENCE}_{ENTITY}_{FIELD}_{WIDGET}
    final match = RegExp(r'^(\d+)_').firstMatch(key);
    if (match != null) {
      return int.tryParse(match.group(1)!);
    }
    return null;
  }

  String? _findCubitFilePath(String src, String? cubitType) {
    if (cubitType == null) return null;

    final fileName = utils.camelToSnake(cubitType);

    // Match import 'package:PROJECT/path/to/cubit_file.dart'
    final importPattern =
        RegExp("import\\s+['\"]package:[^/]+/(.+?/$fileName\\.dart)['\"]");
    final match = importPattern.firstMatch(src);
    if (match != null) {
      return 'lib/${match.group(1)}';
    }

    return 'lib/cubit/$fileName.dart';
  }

  String? _findStateFilePath(String src, String? stateType) {
    if (stateType == null) return null;

    final fileName = utils.camelToSnake(stateType);

    final importPattern =
        RegExp("import\\s+['\"]package:[^/]+/(.+?/$fileName\\.dart)['\"]");
    final match = importPattern.firstMatch(src);
    if (match != null) {
      return 'lib/${match.group(1)}';
    }

    return 'lib/cubit/$fileName.dart';
  }

  // Removed: _camelToSnake - now using utils.camelToSnake

  Map<String, Map<String, dynamic>> _scanDateTimePickers(String src) {
    final pickers = <String, Map<String, dynamic>>{};

    int i = 0;
    while (i < src.length) {
      final match = RegExp(r'showDatePicker\s*\(').matchAsPrefix(src, i);
      if (match != null) {
        final openParen = match.end - 1;
        final closeParen = _matchParen(src, openParen);

        if (closeParen > openParen) {
          final args = src.substring(openParen + 1, closeParen);

          final params = _extractDatePickerParams(args);

          final methodName = _findContainingMethod(src, match.start);

          if (methodName != null && params.isNotEmpty) {
            pickers[methodName] = {
              'type': 'DatePicker',
              ...params,
            };
          }
        }
        i = match.end;
      } else {
        i++;
      }
    }

    i = 0;
    while (i < src.length) {
      final match = RegExp(r'showTimePicker\s*\(').matchAsPrefix(src, i);
      if (match != null) {
        final openParen = match.end - 1;
        final closeParen = _matchParen(src, openParen);

        if (closeParen > openParen) {
          final args = src.substring(openParen + 1, closeParen);
          final params = _extractTimePickerParams(args);
          final methodName = _findContainingMethod(src, match.start);

          if (methodName != null && params.isNotEmpty) {
            pickers[methodName] = {
              'type': 'TimePicker',
              ...params,
            };
          }
        }
        i = match.end;
      } else {
        i++;
      }
    }

    return pickers;
  }

  String? _findContainingMethod(String src, int pos) {
    final beforePos = src.substring(0, pos);

    // Group 1: method name — scan backward from pos for the most recent method declaration
    final methodPattern = RegExp(
        r'(?:Future<[^>]+>|void|[A-Z]\w*)\s+([A-Za-z_]\w*)\s*\([^)]*\)\s*(?:async\s*)?\{[^}]*$');
    final match = methodPattern.firstMatch(beforePos);
    if (match != null) {
      return match.group(1);
    }

    return null;
  }

  Map<String, dynamic> _extractDatePickerParams(String args) {
    final params = <String, dynamic>{};

    final firstDateNow =
        RegExp(r'firstDate\s*:\s*DateTime\.now\(\)').firstMatch(args);
    if (firstDateNow != null) {
      params['firstDate'] = 'DateTime.now()';
    } else {
      final firstDateMatch =
          RegExp(r'firstDate\s*:\s*DateTime\(([^)]+)\)').firstMatch(args);
      if (firstDateMatch != null) {
        final dateArgs = firstDateMatch.group(1)!.trim();
        params['firstDate'] = _parseDateTimeArgs(dateArgs);
      }
    }

    final lastDateNow =
        RegExp(r'lastDate\s*:\s*DateTime\.now\(\)(?!\.)').firstMatch(args);
    if (lastDateNow != null) {
      params['lastDate'] = 'DateTime.now()';
    } else {
      final lastDateExpr = RegExp(
              r'lastDate\s*:\s*DateTime\.now\(\)\.add\(const Duration\(days:\s*(\d+)\)\)')
          .firstMatch(args);
      if (lastDateExpr != null) {
        params['lastDate'] =
            'DateTime.now().add(Duration(days: ${lastDateExpr.group(1)}))';
      } else {
        final lastDateLiteral =
            RegExp(r'lastDate\s*:\s*DateTime\(([^)]+)\)').firstMatch(args);
        if (lastDateLiteral != null) {
          final dateArgs = lastDateLiteral.group(1)!.trim();
          params['lastDate'] = _parseDateTimeArgs(dateArgs);
        }
      }
    }

    // Use manual paren-depth traversal to handle nested expressions like
    // state.selectedDate ?? DateTime.now() correctly.
    final initialDateStart = RegExp(r'initialDate\s*:\s*').firstMatch(args);
    if (initialDateStart != null) {
      final startPos = initialDateStart.end;

      int endPos = startPos;
      int parenDepth = 0;
      bool inString = false;

      while (endPos < args.length) {
        final char = args[endPos];

        if (char == "'" || char == '"') {
          inString = !inString;
        } else if (!inString) {
          if (char == '(') {
            parenDepth++;
          } else if (char == ')') {
            parenDepth--;
          } else if (char == ',' && parenDepth == 0) {
            break;
          }
        }

        endPos++;
      }

      params['initialDate'] = args.substring(startPos, endPos).trim();
    }

    return params;
  }

  Map<String, dynamic> _extractTimePickerParams(String args) {
    final params = <String, dynamic>{};

    // Use manual paren-depth traversal to handle nested expressions correctly.
    final initialTimeStart = RegExp(r'initialTime\s*:\s*').firstMatch(args);
    if (initialTimeStart != null) {
      final startPos = initialTimeStart.end;
      int endPos = startPos;
      int parenDepth = 0;
      bool inString = false;

      while (endPos < args.length) {
        final char = args[endPos];

        if (char == "'" || char == '"') {
          inString = !inString;
        } else if (!inString) {
          if (char == '(') {
            parenDepth++;
          } else if (char == ')') {
            parenDepth--;
          } else if (char == ',' && parenDepth == 0) {
            break;
          }
        }

        endPos++;
      }

      params['initialTime'] = args.substring(startPos, endPos).trim();
    }

    return params;
  }

  String _parseDateTimeArgs(String args) {
    final parts = args.split(',').map((e) => e.trim()).toList();

    if (parts.length == 1) {
      return 'DateTime(${parts[0]})';
    } else if (parts.length == 2) {
      return 'DateTime(${parts[0]}, ${parts[1]})';
    } else if (parts.length >= 3) {
      return 'DateTime(${parts[0]}, ${parts[1]}, ${parts[2]})';
    }

    return 'DateTime($args)';
  }
}
