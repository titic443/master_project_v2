# Widget Coverage Guide

## 🎯 แนวคิด

**Widget Coverage** วัดว่า **widgets ในหน้า UI ถูก test กี่ตัว** จากทั้งหมด

```
Widget Coverage = (Tested Widgets / Total Widgets) × 100
```

**ตัวอย่าง:**
- หน้ามี 14 widgets (TextFields, Buttons, Checkboxes)
- Tests ครอบคลุม 13 widgets
- **Coverage = 92.9%** ✅

---

## ✅ ข้อดีของ Widget Coverage

### 1. **ง่ายและชัดเจน**
- นับจาก UI elements จริง
- เห็นได้ชัดว่า widget ไหนยังไม่ได้ test

### 2. **Auto-detect ได้**
- อ่านจาก `manifest.json` (auto-generated)
- ไม่ต้องสร้าง CSV manual

### 3. **เป็นรูปธรรม**
- 1 widget = 1 item ที่ต้อง test
- ไม่ซับซ้อนด้วย flows หรือ scenarios

### 4. **ตรงไปตรงมา**
- Widget ถูก test → ✅ นับ
- Widget ไม่ถูก test → ❌ แสดงใน gaps

---

## 🚀 วิธีใช้งาน

### วิธีที่ 1: ใช้ Wrapper Script (แนะนำ)

```bash
# Check widget coverage for customer_details_page
./tools/check_widget_coverage.sh customer_details_page

# หรือไม่ระบุชื่อ (default = customer_details_page)
./tools/check_widget_coverage.sh
```

---

### วิธีที่ 2: ใช้ Dart Script โดยตรง

```bash
dart run tools/widget_coverage.dart \
  output/manifest/demos/customer_details_page.manifest.json \
  integration_test/customer_details_page_flow_test.dart
```

---

## 📊 Output

### ตัวอย่าง Output ที่ได้:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Widget Coverage Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Manifest: customer_details_page.manifest.json
  Test:     customer_details_page_flow_test.dart

  Total Widgets:    14
  Tested Widgets:   13
  Untested Widgets: 1

  Coverage:         92.9% ✓

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Tested Widgets (13)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ✓ customer_01_title_dropdown
      Type: DropdownButton
      Tests: pairwise_valid_invalid_cases_1, ...

  ✓ customer_02_firstname_textfield
      Type: TextFormField
      Tests: pairwise_valid_invalid_cases_1, ...

  ... (11 more widgets)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Untested Widgets (1 gaps)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ┌─ TextFormFields (1)
  │   ✗ customer_05_age_range_formfield
  │      → Test: enterText() with valid/invalid values
  └─

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Next Steps
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  1. Add tests for untested widgets above
  2. Use suggestions to guide test implementation
  3. Re-run this script to verify coverage
```

---

## 📝 วิธีแก้ไข Gaps

### ตัวอย่าง: เพิ่ม test สำหรับ widget ที่ยังไม่ได้ test

จาก output ด้านบน เห็นว่า `customer_05_age_range_formfield` ยังไม่ได้ test

**Solution:**

```dart
// test/manual/age_range_test.dart

testWidgets('age_range_formfield_renders', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider(
        create: (_) => CustomerCubit(),
        child: CustomerDetailsPage(),
      ),
    ),
  );

  // Test: Widget exists
  expect(
    find.byKey(Key('customer_05_age_range_formfield')),
    findsOneWidget
  );

  // Test: Initial state
  expect(find.text('Select Age Range'), findsOneWidget);
});

testWidgets('age_range_formfield_interaction', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider(
        create: (_) => CustomerCubit(),
        child: CustomerDetailsPage(),
      ),
    ),
  );

  // Test: Select age range
  await tester.tap(find.byKey(Key('customer_05_age_10_20_radio')));
  await tester.pump();

  // Verify: State changed
  final cubit = tester
      .element(find.byType(CustomerDetailsPage))
      .read<CustomerCubit>();

  expect(cubit.state.ageRange, equals(1)); // age_10_20 = 1
});
```

**รัน test:**

```bash
flutter test test/manual/age_range_test.dart
```

**Re-check coverage:**

```bash
./tools/check_widget_coverage.sh
```

**Expected:**
```
  Coverage:         100% ✓  (14/14 widgets)
```

---

## 🔄 Workflow

```
1. Generate Tests (Auto)
   └→ ./bin/flutter_test_gen <page>.dart
   └→ สร้าง tests อัตโนมัติ

2. Check Widget Coverage
   └→ ./tools/check_widget_coverage.sh
   └→ ดู coverage % และ gaps

3. Write Manual Tests
   └→ สำหรับ widgets ที่ยังไม่ได้ test

4. Run Manual Tests
   └→ flutter test test/manual/...

5. Verify Coverage
   └→ ./tools/check_widget_coverage.sh
   └→ ควรได้ 100% หรือใกล้เคียง

6. Commit
   └→ git add . && git commit -m "test: achieve 100% widget coverage"
```

---

## 📈 ตัวอย่างการใช้งานจริง

### สถานการณ์: เริ่มต้น (0% coverage)

```bash
# 1. Generate auto tests
$ ./bin/flutter_test_gen lib/demos/customer_details_page.dart
✓ Generated 12 tests

# 2. Check coverage
$ ./tools/check_widget_coverage.sh

Total Widgets:    14
Tested Widgets:   13
Coverage:         92.9% ✓

Untested Widgets (1 gap):
  ✗ customer_05_age_range_formfield
```

---

### สถานการณ์: เพิ่ม Manual Test

```bash
# 3. Write manual test
$ nano test/manual/age_range_test.dart
# ... เขียน test สำหรับ age_range_formfield

# 4. Run test
$ flutter test test/manual/age_range_test.dart
All tests passed! ✓

# 5. Re-check coverage
$ ./tools/check_widget_coverage.sh

Total Widgets:    14
Tested Widgets:   14
Coverage:         100% ✓

✓ Perfect Coverage!
All widgets are covered by tests.
```

---

## 🎯 Quality Gates

| Coverage | Grade | Status |
|----------|-------|--------|
| 0-50% | ❌ Poor | Add basic tests |
| 50-70% | ⚠️ Fair | Add more coverage |
| 70-90% | ✅ Good | Good enough |
| 90-100% | ✅ Excellent | Perfect! |

**Minimum:** ≥ 90% before merge

---

## 💡 Best Practices

### DO ✅

1. **Test all interactive widgets**
   - TextFields, Buttons, Dropdowns, Checkboxes
   - These are critical for user experience

2. **Test widget states**
   - Empty, Valid, Invalid, Disabled
   - Different states = different behaviors

3. **Test widget interactions**
   - tap, enterText, select, drag
   - User actually interacts with these

4. **Use meaningful test names**
   ```dart
   // ✅ Good
   testWidgets('firstname_textfield_accepts_valid_input', ...)

   // ❌ Bad
   testWidgets('test1', ...)
   ```

### DON'T ❌

1. **Don't skip widget tests**
   - Every widget key in manifest should be tested

2. **Don't test only happy path**
   - Test errors, edge cases too

3. **Don't ignore the gaps**
   - Fix untested widgets before merging

---

## 🔍 การ Debug Coverage Issues

### ปัญหา: Widget ถูก test แล้วแต่ยังขึ้น "Untested"

**สาเหตุ:** Widget key ในtest file ไม่ตรงกับ manifest

**แก้ไข:**
```dart
// ✅ Correct - ใช้ const Key
find.byKey(const Key('customer_01_title_dropdown'))

// ❌ Wrong - ใช้แค่ string
find.text('customer_01_title_dropdown')
```

---

### ปัญหา: Manifest ไม่มี widget บางตัว

**สาเหตุ:** Widget ไม่มี key หรือ manifest outdated

**แก้ไข:**
```bash
# Re-generate manifest
dart run tools/script_v2/extract_ui_manifest.dart \
  lib/demos/customer_details_page.dart

# Then re-check coverage
./tools/check_widget_coverage.sh
```

---

### ปัญหา: Coverage 100% แต่ test ไม่ครอบคลุม

**สาเหตุ:** Widget มีอยู่ใน test แต่ไม่ได้ test ดีพอ

**แก้ไข:** เพิ่ม assertions

```dart
// ❌ Weak - แค่ tap ไม่ verify
await tester.tap(find.byKey(Key('button')));

// ✅ Strong - tap และ verify result
await tester.tap(find.byKey(Key('button')));
await tester.pumpAndSettle();
expect(find.text('Success'), findsOneWidget);
```

---

## 🚦 Integration กับ CI/CD

### GitHub Actions Example

```yaml
name: Widget Coverage Check

on: [push, pull_request]

jobs:
  coverage:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - uses: dart-lang/setup-dart@v1

      - name: Install dependencies
        run: flutter pub get

      - name: Check widget coverage
        run: |
          ./tools/check_widget_coverage.sh customer_details_page

      - name: Fail if coverage < 90%
        run: |
          # Script exits with code 1 if coverage < 70%
          # Add custom threshold check if needed
```

---

## 📊 เปรียบเทียบ Metrics

| Metric | What it measures | Best for | Ease of use |
|--------|------------------|----------|-------------|
| **Widget Coverage** | Widgets tested | UI completeness | ⭐⭐⭐⭐⭐ |
| **User Flow Coverage** | Scenarios tested | Behavior coverage | ⭐⭐⭐ |
| **Code Coverage** | Code lines tested | Logic correctness | ⭐⭐⭐⭐ |

**Recommendation:**
- ใช้ **Widget Coverage** เป็นหลัก (ง่ายที่สุด)
- เสริมด้วย **Code Coverage** (flutter test --coverage)
- ใช้ **User Flow** เมื่อต้องการ test scenarios ซับซ้อน

---

## สรุป

**Widget Coverage = วัดจาก Widgets ในหน้า UI**

**ข้อดี:**
- ✅ ง่าย - นับจาก widget keys
- ✅ ชัดเจน - เห็นได้ชัดว่าขาดอะไร
- ✅ Auto-detect - อ่านจาก manifest
- ✅ เป็นรูปธรรม - 1 widget = 1 item

**วิธีใช้:**
```bash
./tools/check_widget_coverage.sh <page_name>
```

**Target:**
- ≥ 90% widget coverage
- Fix all gaps before merge

**แค่นี้คุณก็มีเครื่องมือวัด UI test quality ได้แล้ว!** 🎉
