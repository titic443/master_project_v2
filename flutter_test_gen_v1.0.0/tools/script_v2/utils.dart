// Shared utilities for script_v2 tools
//
// This module provides common helper functions used across all test generation scripts.

import 'dart:io';

// ============================================================================
// File Path Utilities
// ============================================================================

/// Get the basename of a file path (filename with extension)
///
/// Example:
/// ```dart
/// basename('lib/demos/buttons_page.dart') // Returns: 'buttons_page.dart'
/// basename('output/manifest/register.json') // Returns: 'register.json'
/// ```
String basename(String path) {
  final p = path.replaceAll('\\', '/');
  final i = p.lastIndexOf('/');
  return i >= 0 ? p.substring(i + 1) : p;
}

/// Get the basename without file extension
///
/// Example:
/// ```dart
/// basenameWithoutExtension('lib/demos/buttons_page.dart') // Returns: 'buttons_page'
/// basenameWithoutExtension('output/manifest/register.json') // Returns: 'register'
/// ```
String basenameWithoutExtension(String path) {
  final b = basename(path);
  final i = b.lastIndexOf('.');
  return i > 0 ? b.substring(0, i) : b;
}

/// Convert package path to import path
///
/// Example:
/// ```dart
/// pkgImport('master_project', 'lib/demos/buttons_page.dart')
/// // Returns: 'package:master_project/demos/buttons_page.dart'
/// ```
String pkgImport(String package, String libPath) {
  final rel = libPath.replaceAll('\\', '/');
  final p = rel.startsWith('lib/') ? rel.substring(4) : rel;
  return 'package:$package/$p';
}

/// Read package name from pubspec.yaml
String? readPackageName() {
  try {
    final y = File('pubspec.yaml').readAsStringSync();
    final m = RegExp(r'^name:\s*(.+)\s*$', multiLine: true).firstMatch(y);
    return m?.group(1)?.trim();
  } catch (_) {
    return null;
  }
}

// ============================================================================
// String Utilities
// ============================================================================

/// Convert CamelCase to snake_case
///
/// Examples:
/// ```dart
/// camelToSnake('CustomerCubit') // Returns: 'customer_cubit'
/// camelToSnake('ButtonsState') // Returns: 'buttons_state'
/// ```
String camelToSnake(String input) {
  return input
      .replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (m) => '${m.group(1)}_${m.group(2)}')
      .replaceAllMapped(RegExp(r'([A-Z])([A-Z][a-z])'), (m) => '${m.group(1)}_${m.group(2)}')
      .toLowerCase();
}

/// Escape a Dart single-quoted string literal: backslash, dollar, and single-quote
String dartEscape(String s) {
  return s
      .replaceAll('\\', r'\\')
      .replaceAll(r'$', r'\$')
      .replaceAll("'", r"\'");
}

// ============================================================================
// File System Utilities
// ============================================================================

/// List all files matching a predicate recursively
///
/// Example:
/// ```dart
/// final dartFiles = listFiles('lib', (p) => p.endsWith('.dart'));
/// ```
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

/// Find file containing a declaration matching the given regex
///
/// Example:
/// ```dart
/// final cubitFile = findDeclFile(RegExp(r'class\s+CustomerCubit\b'), endsWith: '_cubit.dart');
/// ```
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

// ============================================================================
// Environment & Configuration Utilities
// ============================================================================

/// Read API key from .env file
///
/// Looks for GEMINI_API_KEY=value format in .env file
String? readApiKeyFromEnv() {
  try {
    final envFile = File('.env');
    if (!envFile.existsSync()) return null;

    final lines = envFile.readAsLinesSync();
    for (final line in lines) {
      final trimmed = line.trim();
      // Skip comments and empty lines
      if (trimmed.isEmpty || trimmed.startsWith('#')) continue;

      // Parse KEY=value format
      final parts = trimmed.split('=');
      if (parts.length >= 2 && parts[0].trim() == 'GEMINI_API_KEY') {
        final value = parts.sublist(1).join('=').trim();
        // Remove quotes if present
        if ((value.startsWith('"') && value.endsWith('"')) ||
            (value.startsWith("'") && value.endsWith("'"))) {
          return value.substring(1, value.length - 1);
        }
        return value;
      }
    }
  } catch (e) {
    // Silently ignore errors reading .env file
  }
  return null;
}
