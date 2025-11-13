import 'dart:io';

/// Script to clear all files in the output directory
///
/// Usage:
///   dart run tools/script_v2/clear_manifest.dart
///
/// This will delete all files in:
///   - output/manifest/
///   - output/event_chains/
///   - output/graphs/
///   - output/test_data/
///   - and any other subdirectories under output/
void main() async {
  final outputDir = Directory('output');

  if (!outputDir.existsSync()) {
    print('❌ Output directory not found: ${outputDir.path}');
    print('ℹ️  Nothing to clear.');
    exit(0);
  }

  print('🗑️  Clearing all files in output directory...\n');

  int deletedCount = 0;
  int errorCount = 0;

  // Recursively find all files in output directory
  await for (final entity in outputDir.list(recursive: true)) {
    if (entity is File) {
      try {
        await entity.delete();
        deletedCount++;
        print('✓ Deleted: ${entity.path}');
      } catch (e) {
        errorCount++;
        print('✗ Error deleting ${entity.path}: $e');
      }
    }
  }

  // Optionally remove empty directories
  print('\n🗑️  Removing empty directories...\n');
  int deletedDirs = 0;

  // Get all directories, sorted by depth (deepest first)
  final dirs = <Directory>[];
  await for (final entity in outputDir.list(recursive: true)) {
    if (entity is Directory) {
      dirs.add(entity);
    }
  }

  // Sort by path depth (deepest first) to delete from bottom up
  dirs.sort((a, b) => b.path.split('/').length.compareTo(a.path.split('/').length));

  for (final dir in dirs) {
    try {
      if (dir.listSync().isEmpty) {
        await dir.delete();
        deletedDirs++;
        print('✓ Removed directory: ${dir.path}');
      }
    } catch (e) {
      // Ignore errors for directories
    }
  }

  print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('📊 Summary:');
  print('   ✓ Deleted files: $deletedCount');
  print('   ✓ Removed empty directories: $deletedDirs');
  if (errorCount > 0) {
    print('   ✗ Errors: $errorCount');
  }
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  if (errorCount > 0) {
    exit(1);
  }
}
