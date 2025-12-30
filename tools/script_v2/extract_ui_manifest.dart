// dart run tools/ir_action_lister.dart lib/demos/buttons_page.dart
//
// Outputs IR JSON describing widgets from top to bottom:
// - widgetType, key, wrappers (BlocListener/BlocBuilder/BlocSelector)
// - actions (onChanged/onPressed/onTap/...): argument type guess + called functions
// - display binding (for Text using state.<field>)

import 'dart:convert';
import 'dart:io';

import 'utils.dart' as utils;

/// Public API for flutter_test_generator.dart
/// Processes a single UI file and generates manifest JSON
/// Returns the path to the generated manifest file
String processUiFile(String path) {
  if (!File(path).existsSync()) {
    throw Exception('File not found: $path');
  }

  _processOne(path);

  // Calculate and return output path (same logic as _processOne)
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

void main(List<String> args) {
  if (args.isEmpty) {
    // Scan all pages under lib/**
    final pages = utils.listFiles('lib', (p) => p.endsWith('_page.dart') || p.endsWith('.page.dart')).toList();
    if (pages.isEmpty) {
      stderr.writeln('No page files found under lib/**');
      exit(1);
    }
    for (final p in pages) {
      _processOne(p);
    }
    return;
  }
  for (final p in args) {
    _processOne(p);
  }
}

void _processOne(String path) {
  if (!File(path).existsSync()) {
    stderr.writeln('File not found: $path');
    return;
  }
  final rawSrc = File(path).readAsStringSync();
  // Strip Dart comments to avoid matching widgets inside commented code
  final src = _stripComments(rawSrc);
  final consts = _collectStringConsts(src);

  final pageClass = _findPageClass(src) ?? utils.basenameWithoutExtension(path);
  final cubitType = _findCubitType(src);
  final stateType = _findStateType(src);
  final cubitFilePath = _findCubitFilePath(src, cubitType);
  final stateFilePath = _findStateFilePath(src, stateType);
  final widgets = _scanWidgets(src, consts: consts, cubitType: cubitType);

  // Scan for date/time pickers
  final pickers = _scanDateTimePickers(rawSrc);

  // Filter out widgets without keys and deduplicate by key
  final seen = <String>{};
  final widgetsWithKeys = <Map<String, dynamic>>[];
  for (final w in widgets) {
    final key = w['key'];
    if (key != null && key is String && key.isNotEmpty) {
      // Only add if we haven't seen this key before
      if (seen.add(key)) {
        // Link picker metadata if widget has onTap that calls a picker method
        final onTap = w['onTap'];
        if (onTap != null && onTap is String && pickers.containsKey(onTap)) {
          w['pickerMetadata'] = pickers[onTap];
        }
        widgetsWithKeys.add(w);
      }
    }
  }

  // Sort widgets by SEQUENCE first, then by source order
  // Pattern: {SEQUENCE}_*_{WIDGET} (e.g., "1_customer_firstname_textfield")
  widgetsWithKeys.sort((a, b) {
    final keyA = (a['key'] as String?) ?? '';
    final keyB = (b['key'] as String?) ?? '';

    // Extract SEQUENCE from key (leading number before first underscore)
    final seqA = _extractSequence(keyA);
    final seqB = _extractSequence(keyB);

    // Priority 1: Widgets with SEQUENCE come first, sorted by SEQUENCE
    if (seqA != null && seqB != null) {
      return seqA.compareTo(seqB);
    }
    if (seqA != null) return -1; // A has sequence, B doesn't -> A comes first
    if (seqB != null) return 1;  // B has sequence, A doesn't -> B comes first

    // Priority 2: Widgets without SEQUENCE keep their source order
    final orderA = (a['sourceOrder'] as int?) ?? 0;
    final orderB = (b['sourceOrder'] as int?) ?? 0;
    return orderA.compareTo(orderB);
  });

  // Remove sourceOrder from output (used only for sorting)
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

  // Extract subfolder structure from input path
  // e.g., lib/demos/register_page.dart → output/manifest/demos/register_page.manifest.json
  final normalizedPath = path.replaceAll('\\', '/');
  String subfolderPath = '';

  // Remove lib/ prefix if present
  if (normalizedPath.startsWith('lib/')) {
    final pathAfterLib = normalizedPath.substring(4); // Remove 'lib/'
    final lastSlash = pathAfterLib.lastIndexOf('/');
    if (lastSlash > 0) {
      subfolderPath = pathAfterLib.substring(0, lastSlash);
    }
  }

  // Create output directory with subfolder structure
  final outDir = subfolderPath.isNotEmpty
      ? Directory('output/manifest/$subfolderPath')
      : Directory('output/manifest');
  outDir.createSync(recursive: true);

  final outPath = '${outDir.path}/${utils.basenameWithoutExtension(path)}.manifest.json';
  File(outPath).writeAsStringSync(const JsonEncoder.withIndent('  ').convert(ir) + '\n');
  stdout.writeln('✓ Manifest written: $outPath');
}

// Remove // line comments and /* */ block comments while preserving strings
String _stripComments(String s) {
  final b = StringBuffer();
  bool inS = false; // '
  bool inD = false; // "
  bool inRawS = false; // r'...'
  bool inRawD = false; // r"..."
  bool inLine = false;
  bool inBlock = false;
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
        i++; // skip '/'
      }
      continue;
    }

    // Enter line/block comment only when not inside strings
    if (!inS && !inD && !inRawS && !inRawD) {
      if (c == '/' && next == '/') {
        inLine = true; i++; continue;
      }
      if (c == '/' && next == '*') {
        inBlock = true; i++; continue;
      }
    }

    // Handle raw string prefix r' or r"
    if (!inS && !inD && !inRawS && !inRawD && (c == 'r' || c == 'R')) {
      final n2 = i + 1 < s.length ? s[i + 1] : '';
      if (n2 == '\'' || n2 == '"') {
        if (n2 == '\'') inRawS = true; else inRawD = true;
        b.write(c);
        i++;
        b.write(n2);
        continue;
      }
    }

    // Toggle normal strings (respect escapes for non-raw)
    if (!inRawS && !inRawD) {
      if (!inD && c == '\'' ) {
        inS = !inS; b.write(c); continue;
      }
      if (!inS && c == '"') {
        inD = !inD; b.write(c); continue;
      }
      if ((inS || inD) && c == '\\') {
        // escape next char in string
        if (i + 1 < s.length) { b.write(c); b.write(s[i + 1]); i++; continue; }
      }
    } else {
      // raw strings end on matching quote without escapes
      if (inRawS && c == '\'') { inRawS = false; b.write(c); continue; }
      if (inRawD && c == '"') { inRawD = false; b.write(c); continue; }
    }

    b.write(c);
  }
  return b.toString();
}

String? _findPageClass(String src) {
  final m = RegExp(r'class\s+(\w+)\s+extends\s+(?:StatefulWidget|StatelessWidget)').firstMatch(src);
  return m?.group(1);
}

List<Map<String, dynamic>> _scanWidgets(String src, {Map<String, String> consts = const {}, String? cubitType}) {
  final targets = <String>{
    'TextField', 'TextFormField', 'FormField', 'Radio', 'ElevatedButton', 'TextButton', 'OutlinedButton', 'IconButton', 'Text',
    'DropdownButton', 'DropdownButtonFormField', 'Checkbox', 'Switch', 'SwitchListTile', 'Slider', 'ListTile', 'Visibility', 'SnackBar',
  };
  final out = <Map<String, dynamic>>[];
  final regexVars = _collectRegexVars(src);
  int i = 0;
  int sourceOrder = 0; // Track order of widgets in source file
  while (i < src.length) {
    final m = RegExp(r'([A-Z][A-Za-z0-9_]*)\s*(<[^>]*>)?\s*\(').matchAsPrefix(src, i);
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
    final startArgs = m.end - 1; // position of '('
    final endIdx = _matchParen(src, startArgs);
    if (endIdx == -1) {
      i = m.end;
      continue;
    }
    final argsSrc = src.substring(startArgs + 1, endIdx);
    final key = _extractKey(argsSrc, consts: consts);
    final binding = type == 'Text' ? _extractTextBinding(argsSrc, consts: consts) : null;
    final onTapMethod = _extractOnTapMethod(argsSrc);
    Map<String, dynamic> meta = {};
    if (type == 'TextField' || type == 'TextFormField') {
      meta.addAll(_extractTextFieldMeta(argsSrc, regexVars: regexVars));
    }
    if (type.startsWith('Radio')) {
      meta.addAll(_extractRadioMeta(argsSrc));
    }
    // Generic validation/meta for other form-like widgets
    meta.addAll(_extractValidationMeta(type, argsSrc));

    out.add({
      'widgetType': type + (generics != null ? generics : ''),
      if (key != null) 'key': key,
      if (binding != null) 'displayBinding': binding,
      if (type == 'Text') ..._maybeTextLiteral(argsSrc),
      if (meta.isNotEmpty) 'meta': meta,
      if (onTapMethod != null) 'onTap': onTapMethod,
      'sourceOrder': sourceOrder++, // Track source order for sorting
    });

    // Also scan nested widgets inside the argument source to capture children
    // like Radio within FormField builder, etc.
    final nested = _scanWidgets(argsSrc, consts: consts, cubitType: cubitType);
    if (nested.isNotEmpty) {
      // Preserve sourceOrder for nested widgets
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
  bool inS = false; bool inD = false; bool inRawStr = false;
  for (int i = openIdx; i < s.length; i++) {
    final c = s[i];
    if (!inS && !inD) {
      if (c == '(') depth++;
      if (c == ')') {
        depth--;
        if (depth == 0) return i;
      }
      if (c == '\'' ) inS = true;
      if (c == '"') inD = true;
    } else {
      if (inS && c == '\'' ) inS = false;
      if (inD && c == '"') inD = false;
    }
  }
  return -1;
}

int _matchBrace(String s, int openIdx) {
  int depth = 0;
  bool inS = false; bool inD = false; bool inRawStr = false;
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
  String resolve(String s) => s.replaceAllMapped(RegExp(r"\$\{(\w+)\}"), (mm){
    final name = mm.group(1)!; return consts[name] ?? mm.group(0)!; });

  // Key('...')
  var m = RegExp(r"key\s*:\s*(?:const\s+)?Key\(\s*'([^']+)'\s*\)").firstMatch(args);
  if (m != null) return resolve(m.group(1)!);
  // Key("...")
  m = RegExp(r'key\s*:\s*(?:const\s+)?Key\(\s*"([^\"]+)"\s*\)').firstMatch(args);
  if (m != null) return resolve(m.group(1)!);
  // ValueKey<T>('...') / ValueKey("...")
  m = RegExp(r"key\s*:\s*(?:const\s+)?ValueKey(?:<[^>]+>)?\(\s*'([^']+)'\s*\)").firstMatch(args);
  if (m != null) return resolve(m.group(1)!);
  m = RegExp(r'key\s*:\s*(?:const\s+)?ValueKey(?:<[^>]+>)?\(\s*"([^\"]+)"\s*\)').firstMatch(args);
  if (m != null) return resolve(m.group(1)!);
  // ObjectKey([...]) -> take the first string literal if present
  m = RegExp(r'key\s*:\s*(?:const\s+)?ObjectKey\(\s*\[([^\]]*)\]\s*\)').firstMatch(args);
  if (m != null) {
    final inside = m.group(1) ?? '';
    final ms = RegExp(r"'([^']+)'").firstMatch(inside) ?? RegExp(r'"([^\"]+)"').firstMatch(inside);
    if (ms != null) return resolve(ms.group(1)!);
  }
  return null;
}

/// Extract method name from onTap callback
/// Patterns:
///   onTap: () => methodName(context)
///   onTap: () { methodName(context); }
///   onTap: methodName
String? _extractOnTapMethod(String args) {
  // Pattern 1: onTap: () => _methodName(...)
  final arrowPattern = RegExp(r'onTap\s*:\s*\(\s*\)\s*=>\s*([A-Za-z_]\w*)\s*\(');
  final arrowMatch = arrowPattern.firstMatch(args);
  if (arrowMatch != null) {
    return arrowMatch.group(1);
  }

  // Pattern 2: onTap: () { _methodName(...); }
  final blockPattern = RegExp(r'onTap\s*:\s*\(\s*\)\s*\{\s*([A-Za-z_]\w*)\s*\(');
  final blockMatch = blockPattern.firstMatch(args);
  if (blockMatch != null) {
    return blockMatch.group(1);
  }

  // Pattern 3: onTap: _methodName
  final directPattern = RegExp(r'onTap\s*:\s*([A-Za-z_]\w*)(?:\s*[,\)]|$)');
  final directMatch = directPattern.firstMatch(args);
  if (directMatch != null) {
    return directMatch.group(1);
  }

  return null;
}

List<String> _detectWrappers(String src, int pos) {
  final start = (pos - 500).clamp(0, src.length);
  final ctx = src.substring(start, pos);
  final w = <String>[];
  if (ctx.contains('BlocListener<')) w.add('BlocListener');
  if (ctx.contains('BlocBuilder<')) w.add('BlocBuilder');
  if (ctx.contains('BlocSelector<')) w.add('BlocSelector');
  return w;
}

List<Map<String, dynamic>> _extractActions(String type, String? generics, String args, {String? cubitType, String? fullSource}) {
  final events = <String>['onPressed','onChanged','onTap','onSubmitted','onFieldSubmitted','onSaved'];
  final out = <Map<String, dynamic>>[];
  for (final e in events) {
    final m = RegExp('\\b$e\\s*:\\s*([^,]+)').firstMatch(args);
    if (m == null) continue;
    final expr = m.group(1)!.trim();
    final calls = _extractCalls(expr, cubitType: cubitType, fullSource: fullSource);
    final argType = _guessArgType(type, generics, e);

    // Filter out internal FormField calls (formState.didChange)
    final meaningfulCalls = calls.where((call) =>
      call['target'] != 'formState' || call['method'] != 'didChange'
    ).toList();

    // Only include actions that have meaningful calls or are important user interactions
    // Skip actions with empty calls for FormField widgets
    if (meaningfulCalls.isEmpty && type == 'FormField') continue;

    out.add({
      'event': e,
      if (argType != null) 'argType': argType,
      'calls': meaningfulCalls,
    });
  }
  return out;
}

List<Map<String,String>> _extractCalls(String expr, {String? cubitType, String? fullSource}) {
  final out = <Map<String,String>>[];
  final seen = <String>{};
  void addCall(String target, String method) {
    final k = '$target::$method';
    if (seen.add(k)) out.add({'target': target, 'method': method});
  }

  // Handle ternary expression: condition ? methodA : methodB
  final ternaryMatch = RegExp(r'([^?]+)\?([^:]+):(.+)').firstMatch(expr.trim());
  if (ternaryMatch != null && fullSource != null) {
    final trueBranch = ternaryMatch.group(2)!.trim();
    final falseBranch = ternaryMatch.group(3)!.trim();
    // Process the non-null branch (usually the false branch has the method)
    if (falseBranch != 'null') {
      final nestedCalls = _extractCalls(falseBranch, cubitType: cubitType, fullSource: fullSource);
      for (final call in nestedCalls) {
        addCall(call['target']!, call['method']!);
      }
    }
    if (trueBranch != 'null' && trueBranch != falseBranch) {
      final nestedCalls = _extractCalls(trueBranch, cubitType: cubitType, fullSource: fullSource);
      for (final call in nestedCalls) {
        addCall(call['target']!, call['method']!);
      }
    }
    if (out.isNotEmpty) return out;
  }

  // If expression is just a method name like _handleSubmit, try to find its body in fullSource
  if (fullSource != null && RegExp(r'^[A-Za-z_]\w*$').hasMatch(expr.trim())) {
    final methodName = expr.trim();
    final methodBody = _findMethodBody(fullSource, methodName);
    if (methodBody != null) {
      // Recursively extract calls from the method body
      final nestedCalls = _extractCalls(methodBody, cubitType: cubitType, fullSource: null);
      for (final call in nestedCalls) {
        addCall(call['target']!, call['method']!);
      }
      return out;
    }
  }

  // Special-case: Navigator.of(context).pop()/push()/pushNamed...
  final navChain = RegExp(r'Navigator\.of\([^)]*\)\.(pop|maybePop|push(?:Named|Replacement|ReplacementNamed)?|pushAndRemoveUntil)\s*\(');
  final navM = navChain.firstMatch(expr);
  if (navM != null) {
    addCall('Navigator', navM.group(1)!);
  }
  // property access: _cubit.onX or this._cubit.onX / generic calls
  final m1 = RegExp(r'([A-Za-z_]\w*(?:\.[A-Za-z_]\w*)*)\.([A-Za-z_]\w*)\s*\(').allMatches(expr);
  for (final m in m1) {
    var target = m.group(1)!;
    final method = m.group(2)!;
    // Skip Navigator.of if final action already captured
    if (target.startsWith('Navigator') && method == 'of') continue;
    if (cubitType != null) {
      if (target == '_cubit' || target == 'this._cubit') target = cubitType;
    }
    addCall(target, method);
  }
  // context.read<T>().method(
  final m2 = RegExp(r'context\.(?:read|of)<\s*(\w+)\s*>\(\)\.([A-Za-z_]\w*)\s*\(').allMatches(expr);
  for (final m in m2) {
    final t = m.group(1)!;
    addCall(cubitType ?? t, m.group(2)!);
  }
  return out;
}

String? _findMethodBody(String src, String methodName) {
  // Look for: void methodName() { ... }
  final methodPattern = RegExp(r'\b' + methodName + r'\s*\([^)]*\)\s*\{');
  final match = methodPattern.firstMatch(src);
  if (match == null) return null;

  final openBrace = src.indexOf('{', match.start);
  if (openBrace == -1) return null;

  final closeBrace = _matchBrace(src, openBrace);
  if (closeBrace == -1 || closeBrace <= openBrace) return null;

  return src.substring(openBrace + 1, closeBrace);
}

Map<String, String>? _extractTextBinding(String args, {Map<String, String> consts = const {}}) {
  final key = _extractKey(args, consts: consts);
  final m = RegExp(r'\bstate\.(\w+)\b').firstMatch(args);
  if (key != null && m != null) {
    return {'key': key, 'stateField': m.group(1)!};
  }
  return null;
}

Map<String, dynamic> _maybeTextLiteral(String args) {
  // Capture Text('literal') as textLiteral. Ignore interpolations/variables.
  // Match first string literal in argument list not preceded by label (very permissive).
  final m1 = RegExp(r"(?:^|[,(])\s*(?:const\s+)?(?:Text\s*\()?\s*'([^']+)'\s*(?:\)|,|$)")
      .firstMatch(args);
  if (m1 != null) {
    return {'textLiteral': m1.group(1)};
  }
  final m2 = RegExp(r"\bdata\s*:\s*'([^']+)'").firstMatch(args);
  if (m2 != null) return {'textLiteral': m2.group(1)};
  return const {};
}

String? _guessArgType(String type, String? generics, String event){
  if (type == 'TextField' || type == 'TextFormField') {
    if (event == 'onChanged' || event == 'onSubmitted' || event == 'onFieldSubmitted') return 'String';
  }
  if (type == 'Radio') {
    final g = generics ?? '';
    final m = RegExp(r'<\s*([\w\.]+)\s*>').firstMatch(g);
    return m?.group(1) ?? 'dynamic';
  }
  if (event == 'onPressed' || event == 'onTap') return 'void';
  return null;
}

Map<String, dynamic> _extractTextFieldMeta(String args, {Map<String,String> regexVars = const {}}) {
  final meta = <String, dynamic>{};
  // keyboardType: TextInputType.emailAddress / number / phone / text
  final kt = RegExp(r'keyboardType\s*:\s*TextInputType\.(\w+)').firstMatch(args);
  if (kt != null) meta['keyboardType'] = kt.group(1);

  // obscureText: true/false
  final ob = RegExp(r'obscureText\s*:\s*(true|false)').firstMatch(args);
  if (ob != null) meta['obscureText'] = ob.group(1) == 'true';

  // maxLength property on TextField
  final ml = RegExp(r'maxLength\s*:\s*(\d+)').firstMatch(args);
  if (ml != null) meta['maxLength'] = int.tryParse(ml.group(1)!);

  // inputFormatters: capture common ones
  final fm = <Map<String, dynamic>>[];
  // digitsOnly
  if (RegExp(r'FilteringTextInputFormatter\s*\.\s*digitsOnly').hasMatch(args)) {
    fm.add({'type': 'digitsOnly'});
  }
  // singleLine
  if (RegExp(r'FilteringTextInputFormatter\s*\.\s*singleLine').hasMatch(args)) {
    fm.add({'type': 'singleLine'});
  }
  // allow(RegExp(...)[, replacementString: 'x']) capture (accept trailing comma)
  for (final m in RegExp(r"FilteringTextInputFormatter\s*\.\s*allow\s*\(\s*RegExp\(([^)]*)\)\s*(?:,\s*replacementString\s*:\s*'([^']*)')?\s*,?\s*\)").allMatches(args)) {
    final inside = m.group(1) ?? '';
    final s1 = RegExp(r"r?'([^']*)'").firstMatch(inside);
    final s2 = s1 ?? RegExp(r'r?\"([^\"]*)\"').firstMatch(inside);
    final pat = (s2?.group(1)) ?? '';
    final repl = m.group(2);
    if (pat.isNotEmpty) fm.add({'type': 'allow', 'pattern': pat, if (repl != null) 'replacement': repl});
  }
  // deny(RegExp(...)[, replacementString: 'x']) capture (accept trailing comma)
  for (final m in RegExp(r"FilteringTextInputFormatter\s*\.\s*deny\s*\(\s*RegExp\(([^)]*)\)\s*(?:,\s*replacementString\s*:\s*'([^']*)')?\s*,?\s*\)").allMatches(args)) {
    final inside = m.group(1) ?? '';
    final s1 = RegExp(r"r?'([^']*)'").firstMatch(inside);
    final s2 = s1 ?? RegExp(r'r?\"([^\"]*)\"').firstMatch(inside);
    final pat = (s2?.group(1)) ?? '';
    final repl = m.group(2);
    if (pat.isNotEmpty) fm.add({'type': 'deny', 'pattern': pat, if (repl != null) 'replacement': repl});
  }
  // allow(variable) / deny(variable)
  for (final m in RegExp(r"FilteringTextInputFormatter\s*\.\s*(allow|deny)\s*\(\s*([A-Za-z_]\w*)\s*(?:,\s*replacementString\s*:\s*'([^']*)')?\s*\)").allMatches(args)) {
    final kind = m.group(1)!;
    final varName = m.group(2)!;
    final repl = m.group(3);
    final pat = regexVars[varName];
    if (pat != null && pat.isNotEmpty) fm.add({'type': kind, 'pattern': pat, if (repl != null) 'replacement': repl});
  }
  // Legacy Whitelisting/Blacklisting
  for (final m in RegExp(r"WhitelistingTextInputFormatter\s*\(\s*RegExp\(([^)]*)\)\s*\)").allMatches(args)) {
    final inside = m.group(1) ?? '';
    final s1 = RegExp(r"r?'([^']*)'").firstMatch(inside);
    final s2 = s1 ?? RegExp(r'r?\"([^\"]*)\"').firstMatch(inside);
    final pat = (s2?.group(1)) ?? '';
    if (pat.isNotEmpty) fm.add({'type': 'allowLegacy', 'pattern': pat});
  }
  for (final m in RegExp(r"BlacklistingTextInputFormatter\s*\(\s*RegExp\(([^)]*)\)\s*\)").allMatches(args)) {
    final inside = m.group(1) ?? '';
    final s1 = RegExp(r"r?'([^']*)'").firstMatch(inside);
    final s2 = s1 ?? RegExp(r'r?\"([^\"]*)\"').firstMatch(inside);
    final pat = (s2?.group(1)) ?? '';
    if (pat.isNotEmpty) fm.add({'type': 'denyLegacy', 'pattern': pat});
  }
  // LengthLimitingTextInputFormatter(n)
  for (final m in RegExp(r'LengthLimitingTextInputFormatter\s*\(\s*(\d+)\s*\)').allMatches(args)) {
    fm.add({'type': 'lengthLimit', 'max': int.tryParse(m.group(1) ?? '')});
  }
  // Custom formatters e.g., ThousandsFormatter(), XxxFormatter(args)
  for (final m in RegExp(r'([A-Za-z_]\w*Formatter)\s*\(([^)]*)\)').allMatches(args)) {
    final name = m.group(1)!;
    final a = (m.group(2) ?? '').trim();
    // Skip ones we already handle (FilteringTextInputFormatter, LengthLimitingTextInputFormatter)
    if (name.contains('FilteringTextInputFormatter') || name.contains('LengthLimitingTextInputFormatter')) continue;
    fm.add({'type': 'custom', 'name': name, if (a.isNotEmpty) 'args': a});
  }
  if (fm.isNotEmpty) meta['inputFormatters'] = fm;

  return meta;
}

Map<String, dynamic> _extractValidationMeta(String widgetType, String args) {
  final meta = <String, dynamic>{};
  // Common validator presence (for TextFormField/DropdownButtonFormField)
  if (RegExp(r'\bvalidator\s*:').hasMatch(args)) {
    // Try to extract literal messages inside the validator closure/expression
    final idx = args.indexOf('validator');
    if (idx >= 0) {
      final tail = args.substring(idx);
      // Prefer capturing full validator block between matching braces { ... }
      String body;
      final braceOpen = tail.indexOf('{');
      if (braceOpen >= 0) {
        final braceClose = _matchBrace(tail, braceOpen);
        if (braceClose > braceOpen) {
          body = tail.substring(braceOpen + 1, braceClose);
        } else {
          // Fallback to legacy stop heuristic
          final stop = RegExp(r",\s*\n\s*[A-Za-z_]\\w*\s*:").firstMatch(tail)?.start ??
              RegExp(r"\)[,\)]").firstMatch(tail)?.start ??
              (tail.length > 300 ? 300 : tail.length);
          body = tail.substring(0, stop);
        }
      } else {
        // Arrow or short form: fallback to legacy stop heuristic
        final stop = RegExp(r",\s*\n\s*[A-Za-z_]\\w*\s*:").firstMatch(tail)?.start ??
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

      // Extract condition → message mapping by scanning 'if (<cond>) return "msg";'
      final rules = <Map<String, String>>[];
      int pos = 0;
      while (true) {
        final ifIdx = body.indexOf('if', pos);
        if (ifIdx < 0) break;
        // Find the opening parenthesis after 'if'
        final open = body.indexOf('(', ifIdx);
        if (open < 0) break;
        final close = _matchParen(body, open);
        if (close < 0) break;
        final cond = body.substring(open + 1, close).trim();
        // After ')', look for return '...';
        final after = body.substring(close + 1);
        final rm = RegExp("return\\s*(['\"])((?:\\\\.|[^\\\\])*?)\\1\\s*;").firstMatch(after);
        if (rm != null) {
          final msg = (rm.group(2) ?? '').trim();
          if (cond.isNotEmpty && msg.isNotEmpty) {
            rules.add({'condition': cond, 'message': msg});
          }
          pos = close + 1 + rm.end; // advance past this return
        } else {
          pos = close + 1;
        }
      }

      // Basic ternary form within validator expression: (<cond>) ? 'Message' : null
      for (final m in RegExp("\\((.*?)\\)\\s*\\?\\s*(['\"])((?:\\\\.|[^\\\\])*?)\\2\\s*:\\s*null", dotAll: true).allMatches(body)) {
        final cond = (m.group(1) ?? '').trim();
        final msg = (m.group(3) ?? '').trim();
        if (cond.isNotEmpty && msg.isNotEmpty) rules.add({'condition': cond, 'message': msg});
      }

      // Fallback: if we found a regex pattern and a user message but missed pairing via 'if (...) return', synthesize a rule.
      if (rules.isEmpty) {
        // Find inline RegExp pattern
        final rxPat = RegExp("RegExp\\(\\s*r?(['\\\"])((?:.|\\n)*?)\\1\\s*\\)").firstMatch(body);
        final patternStr = rxPat?.group(2)?.trim();
        if (patternStr != null && patternStr.isNotEmpty) {
          // Choose a likely user-facing message (exclude 'Required' and the pattern itself)
          final candidates = msgs.where((m) => m != 'Required' && m != patternStr).toList();
          if (candidates.isNotEmpty) {
            rules.add({
              'condition': "!RegExp(r'$patternStr').hasMatch(value)",
              'message': candidates.first,
            });
          }
        }
      }

      if (rules.isNotEmpty) meta['validatorRules'] = rules;

      // Secondary synthesis: ensure user-facing message paired with regex condition exists
      try {
        final rxPat2 = RegExp("RegExp\\(\\s*r?(['\\\"])((?:.|\\n)*?)\\1\\s*\\)").firstMatch(body);
        final patternStr2 = rxPat2?.group(2)?.trim();
        if (patternStr2 != null && patternStr2.isNotEmpty) {
          // Collect all quoted strings in body
          final strMatches = <String>[];
          for (final m in RegExp("'([^']+)'", dotAll: true).allMatches(body)) {
            strMatches.add(m.group(1)!);
          }
          for (final m in RegExp('"([^\"]+)"', dotAll: true).allMatches(body)) {
            strMatches.add(m.group(1)!);
          }
          // Filter to likely messages
          final likelyMsgs = strMatches.where((s) => s != 'Required' && s != patternStr2 && !s.startsWith('^') && !s.startsWith('[')).toList();
          if (likelyMsgs.isNotEmpty) {
            final messagesAlready = (meta['validatorRules'] as List?)?.map((e) => (e as Map)['message'] as String).toSet() ?? <String>{};
            for (final lm in likelyMsgs) {
              if (!messagesAlready.contains(lm)) {
                (meta['validatorRules'] as List).add({'condition': "!RegExp(r'$patternStr2').hasMatch(value)", 'message': lm});
                break;
              }
            }
          }
        }
      } catch (_) {}
    }
  }
  final av = RegExp(r'autovalidateMode\s*:\s*AutovalidateMode\.(\w+)').firstMatch(args);
  if (av != null) meta['autovalidateMode'] = av.group(1);

  if (widgetType == 'DropdownButton' || widgetType == 'DropdownButtonFormField') {
    final optionEntries = <Map<String, String>>[];
    final itemRegex = RegExp(r'DropdownMenuItem\s*\(([^)]*)\)', dotAll: true);
    for (final match in itemRegex.allMatches(args)) {
      final inside = match.group(1) ?? '';
      String? value = RegExp(r"value\s*:\s*'([^']+)'\s*").firstMatch(inside)?.group(1) ??
          RegExp(r'value\s*:\s*"([^"]+)"\s*').firstMatch(inside)?.group(1) ??
          RegExp(r'value\s*:\s*([^,\)]+)').firstMatch(inside)?.group(1)?.trim();

      String? label = RegExp(r"child\s*:\s*Text\(\s*'([^']+)'")
              .firstMatch(inside)
              ?.group(1) ??
          RegExp(r'child\s*:\s*Text\(\s*"([^"]+)"').firstMatch(inside)?.group(1);

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

  // Hints extraction disabled by request (do not emit meta.hints)
  return meta;
}

// Removed: _basename, _basenameWithoutExtension - now using utils.dart

// Collect simple RegExp variable declarations: final rx = RegExp(r'...');
Map<String,String> _collectRegexVars(String src){
  final out = <String,String>{};
  // Matches: final rx = RegExp(r'...');
  final rx1 = RegExp(r"(?:final|const|var)\s+([A-Za-z_]\w*)\s*=\s*RegExp\(\s*r?'([^']*)'\s*\)");
  for(final m in rx1.allMatches(src)){
    out[m.group(1)!] = m.group(2)!;
  }
  // Matches: final rx = RegExp(r"...");
  final rx2 = RegExp(r'(?:final|const|var)\s+([A-Za-z_]\w*)\s*=\s*RegExp\(\s*r?"([^"]*)"\s*\)');
  for(final m in rx2.allMatches(src)){
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
  // Try to find State class from BlocBuilder/BlocListener second generic parameter
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

String? _findPageRoute(String src) {
  // Look for: static const route = '/path'; inside widget class
  final m = RegExp(r"static\s+const\s+route\s*=\s*'([^']+)'\s*;").firstMatch(src);
  return m?.group(1);
}

Map<String, dynamic> _extractRadioMeta(String args) {
  final meta = <String, dynamic>{};
  final v = RegExp(r'\bvalue\s*:\s*([^,\)]+)').firstMatch(args)?.group(1)?.trim();
  if (v != null) meta['valueExpr'] = v;
  final gv = RegExp(r'\bgroupValue\s*:\s*([^,\)]+)').firstMatch(args)?.group(1)?.trim();
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

    // Extract value from Radio widget
    final value = extract(r'value\s*:\s*([^,\)]+)');

    // Extract label/text from following Text widget
    final following = args.substring(close);
    final labelMatch = RegExp(r"Text\(\s*'([^']+)'\s*\)").firstMatch(following) ??
        RegExp(r'Text\(\s*"([^"]+)"\s*\)').firstMatch(following);
    final label = labelMatch?.group(1)?.trim();

    // Only add entry if we have both value and text (same structure as Dropdown)
    if (value != null && value.trim().isNotEmpty && label != null && label.isNotEmpty) {
      final entry = <String, String>{};
      entry['value'] = value.replaceAll(',', '').trim();
      entry['text'] = label; // Use 'text' instead of 'label' to match Dropdown structure
      radios.add(entry);
    }

    index = close + 1;
  }

  return radios;
}

/// Extract SEQUENCE number from key name
/// Pattern: {SEQUENCE}_*_{WIDGET}
/// Examples:
///   "1_customer_firstname_textfield" -> 1
///   "10_customer_title_dropdown" -> 10
///   "customer_age_radio" -> null
int? _extractSequence(String key) {
  final match = RegExp(r'^(\d+)_').firstMatch(key);
  if (match != null) {
    return int.tryParse(match.group(1)!);
  }
  return null;
}

/// Find Cubit file path from import statements
/// Example: import 'package:master_project/cubit/customer_cubit.dart';
/// Returns: lib/cubit/customer_cubit.dart
String? _findCubitFilePath(String src, String? cubitType) {
  if (cubitType == null) return null;

  // Convert CubitClass name to snake_case file name
  // e.g., CustomerCubit -> customer_cubit
  final fileName = utils.camelToSnake(cubitType);

  // Look for import statements with the cubit file
  // Pattern: import 'package:PROJECT_NAME/path/to/cubit_file.dart';
  final importPattern = RegExp("import\\s+['\"]package:[^/]+/(.+?/$fileName\\.dart)['\"]");
  final match = importPattern.firstMatch(src);
  if (match != null) {
    return 'lib/${match.group(1)}';
  }

  // Fallback: assume standard structure lib/cubit/{filename}.dart
  return 'lib/cubit/$fileName.dart';
}

/// Find State file path from import statements
/// Example: import 'package:master_project/cubit/customer_state.dart';
/// Returns: lib/cubit/customer_state.dart
String? _findStateFilePath(String src, String? stateType) {
  if (stateType == null) return null;

  // Convert StateClass name to snake_case file name
  // e.g., CustomerState -> customer_state
  final fileName = utils.camelToSnake(stateType);

  // Look for import statements with the state file
  // Pattern: import 'package:PROJECT_NAME/path/to/state_file.dart';
  final importPattern = RegExp("import\\s+['\"]package:[^/]+/(.+?/$fileName\\.dart)['\"]");
  final match = importPattern.firstMatch(src);
  if (match != null) {
    return 'lib/${match.group(1)}';
  }

  // Fallback: assume standard structure lib/cubit/{filename}.dart
  return 'lib/cubit/$fileName.dart';
}

// Removed: _camelToSnake - now using utils.camelToSnake

/// Scan for showDatePicker and showTimePicker calls
/// Returns map of method name -> picker metadata
Map<String, Map<String, dynamic>> _scanDateTimePickers(String src) {
  final pickers = <String, Map<String, dynamic>>{};

  // Scan for showDatePicker calls using proper parenthesis matching
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

  // Scan for showTimePicker calls using proper parenthesis matching
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

/// Find the method name that contains a given position in source
String? _findContainingMethod(String src, int pos) {
  // Look backwards from pos to find the method declaration
  final beforePos = src.substring(0, pos);

  // Pattern: Future<void> methodName(...) async {
  // or: void methodName(...) {
  final methodPattern = RegExp(r'(?:Future<[^>]+>|void|[A-Z]\w*)\s+([A-Za-z_]\w*)\s*\([^)]*\)\s*(?:async\s*)?\{[^}]*$');
  final match = methodPattern.firstMatch(beforePos);
  if (match != null) {
    return match.group(1);
  }

  return null;
}

/// Extract parameters from showDatePicker arguments
Map<String, dynamic> _extractDatePickerParams(String args) {
  final params = <String, dynamic>{};

  // Extract firstDate - handle both DateTime(year) and DateTime.now()
  final firstDateNow = RegExp(r'firstDate\s*:\s*DateTime\.now\(\)').firstMatch(args);
  if (firstDateNow != null) {
    params['firstDate'] = 'DateTime.now()';
  } else {
    final firstDateMatch = RegExp(r'firstDate\s*:\s*DateTime\(([^)]+)\)').firstMatch(args);
    if (firstDateMatch != null) {
      final dateArgs = firstDateMatch.group(1)!.trim();
      params['firstDate'] = _parseDateTimeArgs(dateArgs);
    }
  }

  // Extract lastDate - handle DateTime.now(), DateTime.now().add(...), and DateTime(...)
  final lastDateNow = RegExp(r'lastDate\s*:\s*DateTime\.now\(\)(?!\.)').firstMatch(args);
  if (lastDateNow != null) {
    params['lastDate'] = 'DateTime.now()';
  } else {
    final lastDateExpr = RegExp(r'lastDate\s*:\s*DateTime\.now\(\)\.add\(const Duration\(days:\s*(\d+)\)\)').firstMatch(args);
    if (lastDateExpr != null) {
      params['lastDate'] = 'DateTime.now().add(Duration(days: ${lastDateExpr.group(1)}))';
    } else {
      final lastDateLiteral = RegExp(r'lastDate\s*:\s*DateTime\(([^)]+)\)').firstMatch(args);
      if (lastDateLiteral != null) {
        final dateArgs = lastDateLiteral.group(1)!.trim();
        params['lastDate'] = _parseDateTimeArgs(dateArgs);
      }
    }
  }

  // Extract initialDate - handle expressions with proper parenthesis matching
  final initialDateStart = RegExp(r'initialDate\s*:\s*').firstMatch(args);
  if (initialDateStart != null) {
    final startPos = initialDateStart.end;
    // Find the end of the expression (either comma or end of args)
    int endPos = startPos;
    int parenDepth = 0;
    bool inString = false;

    while (endPos < args.length) {
      final char = args[endPos];

      if (char == "'" || char == '"') {
        inString = !inString;
      } else if (!inString) {
        if (char == '(') parenDepth++;
        else if (char == ')') parenDepth--;
        else if (char == ',' && parenDepth == 0) break;
      }

      endPos++;
    }

    params['initialDate'] = args.substring(startPos, endPos).trim();
  }

  return params;
}

/// Extract parameters from showTimePicker arguments
Map<String, dynamic> _extractTimePickerParams(String args) {
  final params = <String, dynamic>{};

  // Extract initialTime - handle expressions with proper parenthesis matching
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
        if (char == '(') parenDepth++;
        else if (char == ')') parenDepth--;
        else if (char == ',' && parenDepth == 0) break;
      }

      endPos++;
    }

    params['initialTime'] = args.substring(startPos, endPos).trim();
  }

  return params;
}

/// Parse DateTime constructor arguments to readable format
String _parseDateTimeArgs(String args) {
  final parts = args.split(',').map((e) => e.trim()).toList();
  if (parts.length == 1) {
    // DateTime(1900) -> year only
    return 'DateTime(${parts[0]})';
  } else if (parts.length == 2) {
    // DateTime(2024, 1) -> year, month
    return 'DateTime(${parts[0]}, ${parts[1]})';
  } else if (parts.length >= 3) {
    // DateTime(2024, 1, 15) -> year, month, day
    return 'DateTime(${parts[0]}, ${parts[1]}, ${parts[2]})';
  }
  return 'DateTime($args)';
}
