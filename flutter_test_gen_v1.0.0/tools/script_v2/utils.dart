import 'dart:io';

String basename(String path) {
  final p = path.replaceAll('\\', '/');
  final i = p.lastIndexOf('/');
  return i >= 0 ? p.substring(i + 1) : p;
}

String basenameWithoutExtension(String path) {
  final b = basename(path);
  final i = b.lastIndexOf('.');
  return i > 0 ? b.substring(0, i) : b;
}

String pkgImport(String package, String libPath) {
  final rel = libPath.replaceAll('\\', '/');
  final p = rel.startsWith('lib/') ? rel.substring(4) : rel;
  return 'package:$package/$p';
}

// Strips optional surrounding quotes from the `name:` value in pubspec.yaml.
String? readPackageName() {
  try {
    final y = File('pubspec.yaml').readAsStringSync();
    final m = RegExp(r'^name:\s*(.+?)\s*$', multiLine: true).firstMatch(y);
    var raw = m?.group(1)?.trim();
    if (raw == null || raw.isEmpty) return null;
    if (raw.length >= 2 &&
        ((raw.startsWith('"') && raw.endsWith('"')) ||
            (raw.startsWith("'") && raw.endsWith("'")))) {
      raw = raw.substring(1, raw.length - 1);
    }
    return raw.isEmpty ? null : raw;
  } catch (_) {
    return null;
  }
}

String camelToSnake(String input) {
  return input
      .replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (m) => '${m.group(1)}_${m.group(2)}')
      .replaceAllMapped(RegExp(r'([A-Z])([A-Z][a-z])'), (m) => '${m.group(1)}_${m.group(2)}')
      .toLowerCase();
}

// Escapes backslash, dollar, and single-quote for Dart single-quoted string literals.
String dartEscape(String s) {
  return s
      .replaceAll('\\', r'\\')
      .replaceAll(r'$', r'\$')
      .replaceAll("'", r"\'");
}

Iterable<String> listFiles(String root, bool Function(String) pred) sync* {
  final dir = Directory(root);
  if (!dir.existsSync()) return;
  for (final e in dir.listSync(recursive: true)) {
    if (e is File) {
      final p = e.path.replaceAll('\\', '/');
      if (pred(p)) yield p;
    }
  }
}

String? findDeclFile(RegExp classRx, {String? endsWith}) {
  final dir = Directory('lib');
  if (!dir.existsSync()) return null;
  for (final e in dir.listSync(recursive: true)) {
    if (e is! File) continue;
    final path = e.path.replaceAll('\\', '/');
    if (endsWith != null && !path.endsWith(endsWith)) continue;
    final s = e.readAsStringSync();
    if (classRx.hasMatch(s)) return path;
  }
  return null;
}

String? readApiKeyFromEnv() {
  try {
    final envFile = File('.env');
    if (!envFile.existsSync()) return null;
    final lines = envFile.readAsLinesSync();
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
      final parts = trimmed.split('=');
      if (parts.length >= 2 && parts[0].trim() == 'GEMINI_API_KEY') {
        final value = parts.sublist(1).join('=').trim();
        if ((value.startsWith('"') && value.endsWith('"')) ||
            (value.startsWith("'") && value.endsWith("'"))) {
          return value.substring(1, value.length - 1);
        }
        return value;
      }
    }
  } catch (_) {}
  return null;
}
