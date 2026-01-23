# Test Coverage Guide

## Coverage คืออะไร?

**Code Coverage** คือการวัดว่าโค้ดใน `lib/` ถูก "เดินผ่าน" โดย tests มากแค่ไหน

| ประเภท | ความหมาย |
|--------|----------|
| **Line Coverage** | จำนวนบรรทัดโค้ดที่ถูก execute ระหว่างรัน test |
| **Function Coverage** | จำนวน functions/methods ที่ถูกเรียกใช้ |
| **Branch Coverage** | จำนวน branches (if/else/switch) ที่ถูกทดสอบ |

---

## Executable Lines vs Total Lines

Coverage นับเฉพาะ **Executable Lines** ไม่ใช่ทุกบรรทัดในไฟล์

```dart
// ❌ ไม่นับ - import statements
import 'package:flutter/material.dart';

// ❌ ไม่นับ - บรรทัดว่าง

// ❌ ไม่นับ - class/function declarations
class MyPage extends StatelessWidget {

// ❌ ไม่นับ - closing braces
}

// ❌ ไม่นับ - const UI declarations
const Text('Hello', style: TextStyle(fontSize: 16)),

// ✅ นับ - executable code
context.read<MyCubit>().submit();
if (_formKey.currentState!.validate()) {
controller.dispose();
```

**ตัวอย่าง**: ไฟล์ 438 บรรทัด อาจมี executable lines แค่ 138 บรรทัด

---

## ไฟล์ที่ไม่มี Test จะไม่ปรากฏใน Coverage

Coverage จะแสดง **เฉพาะไฟล์ที่ถูก execute โดย tests** เท่านั้น

```
lib/demos/
├── customer_details_page.dart     ✅ มี test → ปรากฏใน coverage
├── employee_survey_page.dart      ❌ ไม่มี test → ไม่ปรากฏ
└── product_registration_page.dart ❌ ไม่มี test → ไม่ปรากฏ
```

ถ้าต้องการให้ทุกไฟล์ปรากฏใน coverage ต้องสร้าง test ให้ครบทุกไฟล์

---

## รันเทสต์พร้อม Coverage

```sh
# Integration tests พร้อม coverage
flutter test integration_test/ --coverage

# รันเฉพาะบาง test file
flutter test integration_test/customer_details_page_flow_test.dart --coverage
```

---

## สร้าง HTML Coverage Report

```sh
# ติดตั้ง lcov (ครั้งเดียว)
brew install lcov

# สร้าง HTML report
genhtml coverage/lcov.info -o coverage/html

# เปิดดูใน browser
open coverage/html/index.html
```

---

## ดู Coverage แบบ CLI

```sh
# Coverage summary รวม
flutter test --coverage && lcov --summary coverage/lcov.info

# Coverage แยกต่อไฟล์
flutter test --coverage && lcov --list coverage/lcov.info

# กรองเฉพาะ lib/
flutter test --coverage && lcov --list coverage/lcov.info | grep "lib/"
```

---

## อ่าน lcov.info

ไฟล์ `coverage/lcov.info` มีรูปแบบดังนี้:

```
SF:lib/demos/customer_details_page.dart   # Source File
DA:10,1                                    # Line 10 ถูกรัน 1 ครั้ง
DA:42,3                                    # Line 42 ถูกรัน 3 ครั้ง
DA:55,0                                    # Line 55 ไม่ถูกรัน (0 ครั้ง)
LF:138                                     # Lines Found (executable lines ทั้งหมด)
LH:132                                     # Lines Hit (lines ที่ถูกรัน)
end_of_record
```

**Coverage % = LH / LF × 100** (เช่น 132/138 = 95.7%)

---

## ตัวอย่างผลลัพธ์ Coverage

```
Overall coverage rate:
  lines......: 85.2% (234 of 275 lines)
  functions..: 90.0% (45 of 50 functions)
```

---

## สร้าง Test ให้ครบทุกไฟล์

ถ้าต้องการให้ coverage ครอบคลุมทุกไฟล์ใน `lib/demos/`:

```sh
# 1. สร้าง manifest
dart run tools/script_v2/extract_ui_manifest.dart lib/demos/<page_name>.dart

# 2. สร้าง datasets (ต้องมี GEMINI_API_KEY ใน .env)
dart run tools/script_v2/generate_datasets.dart output/manifest/demos/<page_name>.manifest.json

# 3. สร้าง test plan
dart run tools/script_v2/generate_test_data.dart output/manifest/demos/<page_name>.manifest.json

# 4. สร้าง test script
dart run tools/script_v2/generate_test_script.dart output/test_data/<page_name>.testdata.json

# 5. รัน coverage ใหม่
flutter test integration_test/ --coverage
```

หรือรันทีเดียวสำหรับทุกไฟล์:

```sh
dart run tools/script_v2/extract_ui_manifest.dart
dart run tools/script_v2/generate_datasets.dart
dart run tools/script_v2/generate_test_data.dart
dart run tools/script_v2/generate_test_script.dart
flutter test integration_test/ --coverage
```
