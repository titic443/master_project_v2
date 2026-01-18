# การเพิ่ม Widget Validation ใน Interactive Mode

## ปัญหา
ปัจจุบันถ้าไฟล์ที่ผู้ใช้เลือกไม่มี widgets ที่มี key โปรแกรมจะดำเนินการต่อและสร้าง manifest.json ที่มี `widgets: []` ซึ่งจะทำให้ขั้นตอนถัดไปล้มเหลวหรือสร้าง test ที่ว่างเปล่า

## วิธีแก้ไข

### 1. เพิ่มฟังก์ชัน Validation (เพิ่มใน `flutter_test_generator.dart`)

```dart
import 'dart:convert';

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
        'The file must contain widgets with keys:\n'
        '  • TextField/TextFormField with key: Key(\'xxx\')\n'
        '  • Button/Dropdown/Radio with key: Key(\'xxx\')\n'
        '\n'
        'Example:\n'
        '  TextField(key: Key(\'username_field\'), ...)\n'
        '  ElevatedButton(key: Key(\'submit_button\'), ...)'
      );
    }

    return (true, widgets.length, null);
  } catch (e) {
    return (false, 0, 'Failed to scan widgets: $e');
  }
}
```

### 2. เพิ่ม Validation หลัง File Path Input (แก้ไข `_runInteractiveMode()`)

แก้ไขบรรทัด 126-129 จาก:
```dart
// Validate file exists
if (!File(options.inputFile!).existsSync()) {
  throw Exception('File not found: ${options.inputFile}');
}
```

เป็น:
```dart
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
stdout.writeln('  → Found $widgetCount widget(s) with keys');
stdout.writeln('');
```

### 3. ผลลัพธ์ที่คาดหวัง

**กรณีพบ widgets:**
```
? UI file to process (e.g., lib/demos/buttons_page.dart): lib/demos/buttons_page.dart

  Scanning widgets... ✓
  → Found 8 widget(s) with keys

? Skip AI dataset generation? (y/N):
```

**กรณีไม่พบ widgets:**
```
? UI file to process (e.g., lib/demos/buttons_page.dart): lib/main.dart

  Scanning widgets... ✗

⚠ Warning: No testable widgets found in file.
The file must contain widgets with keys:
  • TextField/TextFormField with key: Key('xxx')
  • Button/Dropdown/Radio with key: Key('xxx')

Example:
  TextField(key: Key('username_field'), ...)
  ElevatedButton(key: Key('submit_button'), ...)

✗ Interactive mode cancelled or failed:
Exception: No testable widgets found in lib/main.dart
```

## ข้อดีของการแก้ไข

1. ✅ **Early Detection**: ตรวจจับปัญหาตั้งแต่ต้น ไม่ต้องรอจนถึง Step 3-4
2. ✅ **Better UX**: แจ้งผู้ใช้ทันทีพร้อมคำแนะนำแก้ไข
3. ✅ **Save Time**: ไม่ต้องรันขั้นตอนที่เหลือที่จะล้มเหลวอยู่ดี
4. ✅ **Clear Error Message**: บอกชัดเจนว่าต้องทำอะไร

## ทางเลือกอื่น (Optional)

### แสดง Warning แต่ดำเนินการต่อ
ถ้าต้องการให้แสดง warning แต่ยังให้ผู้ใช้เลือกว่าจะดำเนินการต่อหรือไม่:

```dart
if (!isValid) {
  stdout.writeln('✗\n');
  stderr.writeln('⚠ Warning: ${errorMsg ?? "No widgets found"}');
  stderr.writeln('');

  final continueAnyway = await _promptYesNo(
    'Continue anyway? (Not recommended)',
    defaultValue: false,
  );

  if (!continueAnyway) {
    throw Exception('User cancelled: No testable widgets found');
  }

  stdout.writeln('  ⚠ Proceeding without widgets (may fail later)...');
}
```

## การทดสอบ

### Test Case 1: ไฟล์ที่มี widgets
```bash
./flutter_test_gen
? UI file to process: lib/demos/buttons_page.dart
# Expected: ✓ Found 8 widget(s)
```

### Test Case 2: ไฟล์ที่ไม่มี widgets
```bash
./flutter_test_gen
? UI file to process: lib/main.dart
# Expected: ✗ Error with helpful message
```

### Test Case 3: ไฟล์ที่มี widgets แต่ไม่มี key
```bash
./flutter_test_gen
? UI file to process: lib/demos/no_keys_page.dart
# Expected: ✗ Error "No testable widgets found"
```
