import 'dart:io';

void main() async {
  final outputDir = Directory('output');

  if (!outputDir.existsSync()) {
    print('Output directory not found: ${outputDir.path}');
    exit(0);
  }

  int deletedCount = 0;
  int errorCount = 0;

  await for (final entity in outputDir.list(recursive: true)) {
    if (entity is File) {
      try {
        await entity.delete();
        deletedCount++;
        print('Deleted: ${entity.path}');
      } catch (e) {
        errorCount++;
        print('Error deleting ${entity.path}: $e');
      }
    }
  }

  final dirs = <Directory>[];
  await for (final entity in outputDir.list(recursive: true)) {
    if (entity is Directory) dirs.add(entity);
  }

  // Delete deepest directories first to avoid non-empty-dir errors.
  dirs.sort((a, b) => b.path.split('/').length.compareTo(a.path.split('/').length));

  int deletedDirs = 0;
  for (final dir in dirs) {
    try {
      if (dir.listSync().isEmpty) {
        await dir.delete();
        deletedDirs++;
      }
    } catch (_) {}
  }

  print('Deleted $deletedCount files, $deletedDirs directories.');
  if (errorCount > 0) exit(1);
}
