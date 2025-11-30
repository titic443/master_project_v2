# generate_test_script.dart

## ภาพรวม
Script สำหรับสร้าง Flutter integration test code จาก test plan JSON โดยแปลง test steps และ assertions เป็น Dart code ที่พร้อมรัน

## การทำงาน
1. อ่าน test plan JSON จาก `output/test_data/`
2. อ่าน datasets JSON (ถ้ามี) เพื่อ resolve dataset paths
3. สร้าง integration test code ด้วย:
   - Provider setup (BlocProvider)
   - Test cases แยกตาม groups
   - Test steps (enterText, tap, pump)
   - Assertions (expect statements)
4. บันทึกเป็น Dart file ใน `integration_test/`

## วิธีใช้งาน

### สร้าง test จากไฟล์เดียว
```bash
dart run tools/script_v2/generate_test_script.dart output/test_data/register_page.testdata.json
```

### สร้าง tests จากทุกไฟล์ในโฟลเดอร์
```bash
dart run tools/script_v2/generate_test_script.dart
```

## Input
- Test plan JSON จาก `output/test_data/**/*.testdata.json`
- Datasets JSON จาก `output/test_data/**/*.datasets.json` (optional)

## Output
- Integration test file: `integration_test/<page_name>_flow_test.dart`

## โครงสร้าง Generated Test

### Integration Test File Structure
```dart
// GENERATED — Integration tests for full flow
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/register_cubit.dart';
import 'package:master_project/cubit/register_state.dart';
import 'package:master_project/demos/register_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('register_page.dart flow (integration)', () {
    group('pairwise_valid_invalid_cases', () {
      testWidgets('pairwise_valid_invalid_cases_1', (tester) async {
        // Test implementation
      });
    });

    group('pairwise_valid_cases', () {
      testWidgets('pairwise_valid_cases_1', (tester) async {
        // Test implementation
      });
    });

    group('edge_cases', () {
      testWidgets('edge_cases_empty_all_fields', (tester) async {
        // Test implementation
      });
    });
  });
}
```

## Test Step Generation

### enterText Step
**Input:**
```json
{"enterText": {"byKey": "firstname", "dataset": "byKey.firstname[0].valid"}}
```

**Generated Code:**
```dart
// dataset: byKey.firstname[0].valid
await tester.enterText(find.byKey(const Key('firstname')), 'Alice');
await tester.pump();
```

### tap Step
**Input:**
```json
{"tap": {"byKey": "submit_button"}}
```

**Generated Code:**
```dart
await tester.ensureVisible(find.byKey(const Key('submit_button')));
await tester.tap(find.byKey(const Key('submit_button')));
await tester.pump();
```

### tapText Step
**Input:**
```json
{"tapText": "Mr."}
```

**Generated Code:**
```dart
await tester.tap(find.text('Mr.'));
await tester.pump();
```

### pump / pumpAndSettle
**Input:**
```json
{"pump": true}
{"pumpAndSettle": true}
```

**Generated Code:**
```dart
await tester.pump();
await tester.pumpAndSettle();
```

## Assertion Generation

### byKey with exists
**Input:**
```json
{"byKey": "success_snackbar", "exists": true}
```

**Generated Code:**
```dart
final expected = [
  find.byKey(const Key('success_snackbar')),
];
expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
    reason: 'Expected at least one of the elements to exist');
```

### text with exists
**Input:**
```json
{"text": "Required", "exists": true, "count": 3}
```

**Generated Code:**
```dart
expect(find.text('Required'), findsNWidgets(3));
```

### byKey with textEquals
**Input:**
```json
{"byKey": "message_text", "textEquals": "Success"}
```

**Generated Code:**
```dart
final _tw = tester.widget<Text>(find.byKey(const Key('message_text')));
expect(_tw.data ?? '', 'Success');
```

### byKey with textContains
**Input:**
```json
{"byKey": "message_text", "textContains": "completed"}
```

**Generated Code:**
```dart
final _tw = tester.widget<Text>(find.byKey(const Key('message_text')));
expect((_tw.data ?? '').contains('completed'), true);
```

## Dataset Resolution

Script รองรับ dataset path formats:
- `byKey.firstname[0].valid` → ดึงจาก datasets.byKey.firstname[0].valid
- `byKey.email.valid[0]` → ดึงจาก datasets.byKey.email.valid[0]

### Dataset Format Support

**New Format (Array of Objects):**
```json
{
  "byKey": {
    "firstname": [
      {"valid": "Alice", "invalid": "J", "invalidRuleMessages": "Min 2"}
    ]
  }
}
```

**Old Format (Separate Arrays):**
```json
{
  "byKey": {
    "firstname": {
      "valid": ["Alice", "Robert"],
      "invalid": ["J", "A1"]
    }
  }
}
```

Script จะแปลง new format เป็น old format สำหรับ compatibility

## Provider Setup

### Real Providers (Integration Tests)
```dart
final providers = <BlocProvider>[
  BlocProvider<RegisterCubit>(create: (_) => RegisterCubit()),
];
final w = MaterialApp(
  home: MultiBlocProvider(providers: providers, child: RegisterPage())
);
await tester.pumpWidget(w);
```

Integration tests ใช้ **real providers** เพื่อทดสอบกับ backend จริง

## Imports Generation

Script จะ auto-detect และ generate imports:
- Flutter และ testing packages
- Page class (UI file)
- Cubit class (business logic)
- State class (state models)

ตัวอย่าง:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/register_cubit.dart';
import 'package:master_project/cubit/register_state.dart';
import 'package:master_project/demos/register_page.dart';
```

## Test Grouping

Tests ถูกจัดกลุ่มตาม `group` field ใน test plan:
- `pairwise_valid_invalid_cases`
- `pairwise_valid_cases`
- `edge_cases`

แต่ละ group จะสร้าง `group('...', () {})` block

## Debugging Features

### Dataset Comments
```dart
// dataset: byKey.firstname[0].valid
await tester.enterText(find.byKey(const Key('firstname')), 'Alice');
```

### Backend Response Logging
สำหรับ pairwise tests:
```dart
final element = find.byType(RegisterPage).evaluate().first;
final cubit = BlocProvider.of<RegisterCubit>(element);
if (cubit.state.response != null) {
  print('✓ [pairwise_valid_invalid_cases_1] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
} else if (cubit.state.exception != null) {
  print('✗ [pairwise_valid_invalid_cases_1] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
}
```

## OR Logic Assertions

Integration tests ใช้ **OR logic** สำหรับ assertions:
```dart
// Check if any expected element exists (OR logic)
final expected = [
  find.byKey(const Key('success_snackbar')),
  find.text('Success'),
  find.text('Completed'),
];
expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
    reason: 'Expected at least one of the elements to exist');
```

ทำให้ test ยืดหยุ่นและไม่ fail ง่าย เมื่อ backend response แตกต่างกัน

## Sample Value Extraction

Script จะสกัด valid values จาก datasets เป็น fallback:
```dart
final sampleByKey = {
  'firstname': 'Alice',
  'lastname': 'Smith',
  'email': 'user@example.com',
};
```

ใช้เมื่อ dataset path resolution ล้มเหลว

## ตัวอย่าง Complete Test

```dart
testWidgets('pairwise_valid_invalid_cases_1', (tester) async {
  final providers = <BlocProvider>[
    BlocProvider<RegisterCubit>(create: (_) => RegisterCubit()),
  ];
  final w = MaterialApp(
    home: MultiBlocProvider(providers: providers, child: RegisterPage())
  );
  await tester.pumpWidget(w);

  // dataset: byKey.firstname[0].valid
  await tester.enterText(find.byKey(const Key('firstname')), 'Alice');
  await tester.pump();

  // dataset: byKey.lastname[0].valid
  await tester.enterText(find.byKey(const Key('lastname')), 'Smith');
  await tester.pump();

  await tester.ensureVisible(find.byKey(const Key('submit_button')));
  await tester.tap(find.byKey(const Key('submit_button')));
  await tester.pumpAndSettle();

  // Print actual backend response for debugging
  final element = find.byType(RegisterPage).evaluate().first;
  final cubit = BlocProvider.of<RegisterCubit>(element);
  if (cubit.state.response != null) {
    print('✓ [pairwise_valid_invalid_cases_1] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
  }

  // Check if any expected element exists (OR logic)
  final expected = [
    find.byKey(const Key('success_snackbar')),
  ];
  expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
      reason: 'Expected at least one of the elements to exist');
});
```

## Error Handling

- Dataset path not found → ใช้ sample value fallback
- Invalid dataset format → convert to old format
- Missing provider files → skip import
- Empty test steps → skip test generation

## รันการทดสอบ

```bash
# รัน integration tests
flutter test integration_test/register_page_flow_test.dart

# รันด้วย verbose output
flutter test integration_test/register_page_flow_test.dart -v
```

## หมายเหตุ
- Generated code เป็น **integration tests** ที่ทดสอบกับ real providers
- ใช้ `IntegrationTestWidgetsFlutterBinding.ensureInitialized()` เพื่อรองรับ real async operations
- Backend response logging ช่วยใน debugging
- OR logic assertions ทำให้ tests robust ต่อ response variations
- Script จะ auto-detect cubit และ state types จาก manifest
