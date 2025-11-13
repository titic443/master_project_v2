# โครงสร้าง JSON ของ Cases - คำอธิบายรายละเอียด

## ภาพรวมโครงสร้าง

```json
{
  "cases": [
    {
      "id": "pairwise_valid_invalid_cases_1",
      "kind": "failed",
      "group": "pairwise_valid_invalid_cases",
      "steps": [...],
      "asserts": [...]
    }
  ]
}
```

---

## 📌 a. JSON Key: `id` (Test Case Identifier)

### คำอธิบาย
รหัสเฉพาะ (Unique ID) ของแต่ละ test case ใช้สำหรับระบุและอ้างอิงถึง test case นั้นๆ

### รูปแบบการตั้งชื่อ
```
<group_name>_<sequence_number>
```

### ค่าที่เป็นไปได้
| Pattern | ตัวอย่าง | ความหมาย |
|---------|---------|----------|
| `pairwise_valid_invalid_cases_N` | `pairwise_valid_invalid_cases_1` | Test case ที่ N จากกลุ่ม pairwise mixed (valid+invalid) |
| `pairwise_valid_cases_N` | `pairwise_valid_cases_1` | Test case ที่ N จากกลุ่ม pairwise valid-only |
| `edge_cases_<scenario>` | `edge_cases_empty_all_fields` | Edge case สำหรับ scenario เฉพาะ |

### ตัวอย่างจริง
```json
{
  "id": "pairwise_valid_invalid_cases_1"
}
```
- **ความหมาย**: Test case ลำดับที่ 1 ในกลุ่ม pairwise_valid_invalid_cases
- **การใช้งาน**: ใช้ในการ generate test function name: `test_pairwise_valid_invalid_cases_1()`

---

## 📌 b. JSON Key: `kind` (Expected Outcome Type)

### คำอธิบาย
ประเภทของผลลัพธ์ที่คาดหวังจาก test case นี้ บอกว่าการทดสอบควรจะสำเร็จหรือล้มเหลว

### ค่าที่เป็นไปได้

| ค่า | ความหมาย | เงื่อนไข | Assertions ที่คาดหวัง |
|-----|----------|---------|---------------------|
| `"success"` | การทดสอบควรสำเร็จ | ข้อมูลทุก field ถูกต้อง (valid) | `expectedSuccessKeys` ปรากฏ |
| `"failed"` | การทดสอบควรล้มเหลว | มีข้อมูล field ใดๆ ผิด (invalid) หรือ empty | Validation error messages ปรากฏ หรือ `expectedFailKeys` ปรากฏ |

### ตัวอย่างจริง

#### 1. Success Case
```json
{
  "tc": "pairwise_valid_invalid_cases_1",
  "kind": "success",
  "steps": [
    {"enterText": {"byKey": "customer_02_firstname_textfield", "dataset": "byKey.customer_02_firstname_textfield.valid[0]"}},
    {"enterText": {"byKey": "customer_03_lastname_textfield", "dataset": "byKey.customer_03_lastname_textfield.valid[0]"}}
  ],
  "asserts": []  // ไม่มี error messages (ผ่านการ validation)
}
```

#### 2. Failed Case
```json
{
  "tc": "pairwise_valid_invalid_cases_1",
  "steps": [
        {"tap": {"byKey": "customer_01_title_dropdown"}},
        {"pump": true},
        {"tapText": "Ms."},
        {"pump": true},
        {"enterText": {"byKey": "customer_02_firstname_textfield", "dataset": "byKey.customer_02_firstname_textfield.invalid[0]"}},
        {"pump": true},
        {"enterText": {"byKey": "customer_03_lastname_textfield",  "dataset": "byKey.customer_03_lastname_textfield.valid[0]"}},
        {"pump": true},
        {"tap": {"byKey": "customer_04_age_30_40_radio"}},
        {"pump": true},
        {"tap": { "byKey": "customer_07_end_button"}},
        {"pumpAndSettle": true}
  ],
  "asserts": [
    {"text": "First name must contain only letters (minimum 2 characters)", "exists": true}
  ]
}
```

### การใช้งาน
- ใช้ในการกำหนด test description: `"should succeed"` vs `"should fail"`
- ใช้ในการตรวจสอบว่า assertions ตรงกับ expected outcome หรือไม่

---

## 📌 c. JSON Key: `group` (Test Case Group)

### คำอธิบาย
กลุ่มการจัดหมวดหมู่ของ test case ใช้สำหรับจัดกลุ่ม test cases ที่มีลักษณะการทดสอบคล้ายกัน

### ค่าที่เป็นไปได้

| Group Name | จำนวน Cases | วัตถุประสงค์ | Test Data Pattern |
|------------|-------------|-------------|------------------|
| `pairwise_valid_invalid_cases` | ขึ้นกับ PICT result (Mixed) | ทดสอบ combinations ของ valid และ invalid data | Mixed valid/invalid ตาม PICT |
| `pairwise_valid_cases` | ขึ้นกับ PICT valid result | ทดสอบเฉพาะ valid data combinations | All valid data |
| `edge_cases` | 1 case (empty fields) | ทดสอบกรณีพิเศษ (ไม่กรอกข้อมูล) | Empty/missing data |

### ตัวอย่างจริง

#### Group 1: pairwise_valid_invalid_cases (12 cases)
```json
{
  "id": "pairwise_valid_invalid_cases_1",
  "kind": "failed",
  "group": "pairwise_valid_invalid_cases"
}
```
- **วัตถุประสงค์**: ทดสอบทุก combination ที่เป็นไปได้ระหว่าง valid และ invalid data
- **PICT Combination**: TEXT=invalid, TEXT2=valid, Radio1=30-40, Dropdown=Ms.

#### Group 2: pairwise_valid_cases (12 cases)
```json
{
  "id": "pairwise_valid_cases_1",
  "kind": "success",
  "group": "pairwise_valid_cases"
}
```
- **วัตถุประสงค์**: ทดสอบทุก combination ของ valid data เท่านั้น
- **PICT Combination**: TEXT=valid, TEXT2=valid, Radio1=30-40, Dropdown=Ms.

#### Group 3: edge_cases (1 case)
```json
{
  "id": "edge_cases_empty_all_fields",
  "kind": "failed",
  "group": "edge_cases"
}
```
- **วัตถุประสงค์**: ทดสอบกรณีไม่กรอกข้อมูลเลย (ทุก field ว่าง)
- **Expected**: แสดง "Required" messages ทุก required field

### สถิติตัวอย่าง (CustomerDetailsPage)
```
Total Cases: 25
├─ pairwise_valid_invalid_cases: 12 cases
├─ pairwise_valid_cases: 12 cases
└─ edge_cases: 1 case
```

---

## 📌 d. JSON Key: `steps` (Test Action Sequence)

### คำอธิบาย
ลำดับขั้นตอนการทดสอบ (Array of Actions) แต่ละ step คือ action ที่จำลองการกระทำของผู้ใช้บนหน้าจอ

### โครงสร้าง Steps
```json
"steps": [
  { "action_type": { "parameters": "..." } },
  { "pump": true },
  ...
]
```

### Action Types ที่รองรับ

| Action Type | Parameters | ความหมาย | ตัวอย่าง |
|-------------|-----------|----------|---------|
| `tap` | `{"byKey": "<widget_key>"}` | แตะที่ widget | `{"tap": {"byKey": "customer_07_end_button"}}` |
| `enterText` | `{"byKey": "<key>", "dataset": "<path>"}` | กรอกข้อความ | `{"enterText": {"byKey": "customer_02_firstname_textfield", "dataset": "byKey.customer_02_firstname_textfield.valid[0]"}}` |
| `enterText` | `{"byKey": "<key>", "text": "<value>"}` | กรอกข้อความ (direct) | `{"enterText": {"byKey": "username_field", "text": "Alice"}}` |
| `tapText` | `"<text>"` | แตะ text บนหน้าจอ (สำหรับ dropdown) | `{"tapText": "Mr."}` |
| `pump` | `true` | รอให้ UI rebuild (1 frame) | `{"pump": true}` |
| `pumpAndSettle` | `true` | รอให้ animation เสร็จสิ้น | `{"pumpAndSettle": true}` |

### ลำดับ Steps ตามประเภท Widget

#### TextFormField Steps
```json
[
  {
    "enterText": {
      "byKey": "customer_02_firstname_textfield",
      "dataset": "byKey.customer_02_firstname_textfield.valid[0]"
    }
  },
  {"pump": true}
]
```

#### Dropdown Steps (4 steps)
```json
[
  {"tap": {"byKey": "customer_01_title_dropdown"}},  // 1. เปิด dropdown
  {"pump": true},                                     // 2. รอ UI
  {"tapText": "Mr."},                                 // 3. เลือก option
  {"pump": true}                                      // 4. รอ UI
]
```

#### Radio Button Steps
```json
[
  {"tap": {"byKey": "customer_04_age_30_40_radio"}},
  {"pump": true}
]
```

#### End Button Steps (สุดท้าย)
```json
[
  {"tap": {"byKey": "customer_07_end_button"}},
  {"pumpAndSettle": true}  // ใช้ pumpAndSettle เพื่อรอ animation/API
]
```

#### Checkbox Steps (ฟิลด์ที่ต้องติ๊ก)
- ใน manifest ถ้าเจอ `FormField<bool>` ที่มี `validatorRules` (เช่น `customer_05_agree_terms_formfield`) จะถือว่าเป็น **checkbox แบบบังคับ** และ `tools/script_v2/generator_pict.dart` จะสร้าง factor ชื่อ `Checkbox`, `Checkbox2`, ... พร้อมค่า `checked` / `unchecked` (`tools/script_v2/generator_pict.dart:239`–`tools/script_v2/generator_pict.dart:255`).
- เมื่อ factor ถูกนำไปสร้าง pairwise model (`output/model_pairwise/*.model.txt`) คุณจะเห็นคอลัมน์ `Checkbox`. ค่า `checked` หมายถึง test case ต้องจำลองการติ๊ก checkbox ที่สัมพันธ์กับ factor นั้น ส่วนค่า `unchecked` ให้ปล่อยไว้ตามค่าเริ่มต้น (ปกติคือ `false`).
- การแมปค่า `Checkbox` → `key` ของ widget ดูได้จากคู่ `FormField<bool>` กับ `Checkbox` ใน manifest (เช่น `customer_05_agree_terms_formfield` ↔ `customer_05_agree_terms_checkbox`). ดังนั้น test steps ที่ต้องติ๊กควรเพิ่มลำดับประมาณนี้:
  ```json
  [
    {"tap": {"byKey": "customer_05_agree_terms_checkbox"}},
    {"pump": true}
  ]
  ```
  สำหรับค่าที่เป็น `unchecked` ไม่ต้องเพิ่ม step ใด ๆ (ถือว่าไม่ได้ติ๊ก)
- ✅ เมื่อ checkbox เป็นฟิลด์บังคับ ควรใช้งานข้อความจาก `validatorRules` (เช่น "You must agree to terms") เป็น assertion สำหรับกรณีที่ยังไม่ติ๊ก
- ⚠️ ปัจจุบันสคริปต์ `tools/script_v2/generate_test_data.dart` ยังไม่ได้สร้าง steps/asserts สำหรับ factor `Checkbox` ให้อัตโนมัติ (สังเกตว่าไม่มีการอ่านค่า `c['Checkbox']`). หากต้องการให้ test plan ครอบคลุม checkbox ให้เพิ่มส่วนนี้ด้วยตนเองจนกว่าจะมีการอัปเดตสคริปต์

### ตัวอย่าง Complete Steps Flow
```json
{
  "id": "pairwise_valid_invalid_cases_1",
  "steps": [
    // 1. เลือก dropdown (01)
    {"tap": {"byKey": "customer_01_title_dropdown"}},
    {"pump": true},
    {"tapText": "Ms."},
    {"pump": true},

    // 2. กรอก firstname (02) - INVALID
    {
      "enterText": {
        "byKey": "customer_02_firstname_textfield",
        "dataset": "byKey.customer_02_firstname_textfield.invalid[0]"
      }
    },
    {"pump": true},

    // 3. กรอก lastname (03) - VALID
    {
      "enterText": {
        "byKey": "customer_03_lastname_textfield",
        "dataset": "byKey.customer_03_lastname_textfield.valid[0]"
      }
    },
    {"pump": true},

    // 4. เลือก radio (04)
    {"tap": {"byKey": "customer_04_age_30_40_radio"}},
    {"pump": true},

    // 5. กดปุ่ม submit (07)
    {"tap": {"byKey": "customer_07_end_button"}},
    {"pumpAndSettle": true}
  ]
}
```

### ลำดับการจัดเรียง Steps
- **เรียงตาม sequence number ใน key**: 01 → 02 → 03 → 04 → ... → 07
- **End button เสมอสุดท้าย**: customer_07_end_button

---

## 📌 e. JSON Key: `asserts` (Expected Outcome Validation)

### คำอธิบาย
การตรวจสอบผลลัพธ์ที่คาดหวังหลังจากทำ steps เสร็จ (Array of Assertions)

### โครงสร้าง Assertions
```json
"asserts": [
  { "assertion_type": "parameters" },
  ...
]
```

### Assertion Types

| Type | Parameters | ความหมาย | ใช้กับ Case Type |
|------|-----------|----------|-----------------|
| `{"text": "<msg>", "exists": true}` | ตรวจหา text message | หา validation error message | Failed cases |
| `{"text": "<msg>", "exists": true, "count": N}` | ตรวจหา text N ครั้ง | หา "Required" message จำนวน N field | Edge cases |
| `{"byKey": "<key>", "exists": true}` | ตรวจหา widget | หา expectedSuccessKeys | Success cases |
| `{"byKey": "<key>", "exists": false}` | ตรวจว่าไม่มี widget | หา widget ที่ควรหายไป | Negative tests |
| `{"byKey": "<key>", "textEquals": "<value>"}` | ตรวจค่า text ใน widget | ตรวจค่าที่แสดง | Verification tests |

### ตัวอย่างจริง

#### 1. Failed Case Assertions (Validation Errors)
```json
{
  "kind": "failed",
  "asserts": [
    {
      "text": "First name is required",
      "exists": true
    },
    {
      "text": "First name must contain only letters (minimum 2 characters)",
      "exists": true
    }
  ]
}
```
- **ความหมาย**: คาดหวังว่าจะเห็น validation error messages 2 ข้อความ
- **ที่มา**: จาก `validatorRules` ใน manifest.json

#### 2. Success Case Assertions (Empty)
```json
{
  "kind": "success",
  "asserts": []
}
```
- **ความหมาย**: ไม่มี error messages (ผ่านการ validation)
- **การทดสอบ**: ตรวจว่าไม่มี validation errors ปรากฏ

#### 3. Edge Case Assertions (Required Messages)
```json
{
  "id": "edge_cases_empty_all_fields",
  "kind": "failed",
  "asserts": [
    {
      "text": "Required",
      "exists": true,
      "count": 2
    }
  ]
}
```
- **ความหมาย**: คาดหวังเห็น "Required" message จำนวน 2 ครั้ง (2 required fields)
- **ที่มา**: จาก required TextFormFields (firstname, lastname)

#### 4. Expected Success Keys (ถ้ามี)
```json
{
  "kind": "success",
  "asserts": [
    {
      "byKey": "customer_08_expected_success_text",
      "exists": true
    }
  ]
}
```
- **ความหมาย**: ตรวจว่ามี widget ที่ key = `customer_08_expected_success_text` ปรากฏ
- **การใช้งาน**: แสดงข้อความสำเร็จเมื่อ submit สำเร็จ

### Assertion Logic ตาม Kind

```
┌─────────────────────────────────────────────────────┐
│              kind = "success"                       │
│  ✓ asserts = [] (empty) หรือ                       │
│  ✓ asserts = [expectedSuccessKeys]                  │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│              kind = "failed"                        │
│  ✓ asserts = [validation error messages]           │
│  ✓ asserts = [expectedFailKeys]                     │
│  ✓ asserts = ["Required" messages with count]      │
└─────────────────────────────────────────────────────┘
```

---

## 📊 ตัวอย่างครบถ้วน 3 แบบ

### ตัวอย่างที่ 1: Failed Case (Validation Error)
```json
{
  "id": "pairwise_valid_invalid_cases_1",
  "kind": "failed",
  "group": "pairwise_valid_invalid_cases",
  "steps": [
    {"tap": {"byKey": "customer_01_title_dropdown"}},
    {"pump": true},
    {"tapText": "Ms."},
    {"pump": true},
    {
      "enterText": {
        "byKey": "customer_02_firstname_textfield",
        "dataset": "byKey.customer_02_firstname_textfield.invalid[0]"
      }
    },
    {"pump": true},
    {
      "enterText": {
        "byKey": "customer_03_lastname_textfield",
        "dataset": "byKey.customer_03_lastname_textfield.valid[0]"
      }
    },
    {"pump": true},
    {"tap": {"byKey": "customer_04_age_30_40_radio"}},
    {"pump": true},
    {"tap": {"byKey": "customer_07_end_button"}},
    {"pumpAndSettle": true}
  ],
  "asserts": [
    {"text": "First name is required", "exists": true},
    {"text": "First name must contain only letters (minimum 2 characters)", "exists": true}
  ]
}
```

**อธิบาย**:
- **id**: กรณีทดสอบที่ 1 จากกลุ่ม pairwise_valid_invalid_cases
- **kind**: "failed" - คาดหวังว่าจะล้มเหลว
- **group**: อยู่ในกลุ่ม pairwise_valid_invalid_cases
- **steps**: 10 ขั้นตอน (เลือก dropdown → กรอก invalid firstname → กรอก valid lastname → เลือก radio → กด submit)
- **asserts**: ตรวจว่ามี 2 error messages สำหรับ firstname

---

### ตัวอย่างที่ 2: Success Case
```json
{
  "id": "pairwise_valid_cases_1",
  "kind": "success",
  "group": "pairwise_valid_cases",
  "steps": [
    {"tap": {"byKey": "customer_01_title_dropdown"}},
    {"pump": true},
    {"tapText": "Ms."},
    {"pump": true},
    {
      "enterText": {
        "byKey": "customer_02_firstname_textfield",
        "dataset": "byKey.customer_02_firstname_textfield.valid[0]"
      }
    },
    {"pump": true},
    {
      "enterText": {
        "byKey": "customer_03_lastname_textfield",
        "dataset": "byKey.customer_03_lastname_textfield.valid[0]"
      }
    },
    {"pump": true},
    {"tap": {"byKey": "customer_04_age_30_40_radio"}},
    {"pump": true},
    {"tap": {"byKey": "customer_07_end_button"}},
    {"pumpAndSettle": true}
  ],
  "asserts": []
}
```

**อธิบาย**:
- **id**: กรณีทดสอบที่ 1 จากกลุ่ม pairwise_valid_cases
- **kind**: "success" - คาดหวังว่าจะสำเร็จ
- **group**: อยู่ในกลุ่ม pairwise_valid_cases (valid-only)
- **steps**: 10 ขั้นตอน (เลือก dropdown → กรอก valid firstname → กรอก valid lastname → เลือก radio → กด submit)
- **asserts**: [] (empty) - ไม่มี error messages

---

### ตัวอย่างที่ 3: Edge Case (Empty Fields)
```json
{
  "id": "edge_cases_empty_all_fields",
  "kind": "failed",
  "group": "edge_cases",
  "steps": [
    {"tap": {"byKey": "customer_07_end_button"}},
    {"pumpAndSettle": true}
  ],
  "asserts": [
    {
      "text": "Required",
      "exists": true,
      "count": 2
    }
  ]
}
```

**อธิบาย**:
- **id**: edge_cases_empty_all_fields - กรณีพิเศษไม่กรอกข้อมูล
- **kind**: "failed" - คาดหวังว่าจะล้มเหลว
- **group**: อยู่ในกลุ่ม edge_cases
- **steps**: 2 ขั้นตอนเท่านั้น (กด submit ทันทีโดยไม่กรอกอะไร)
- **asserts**: ตรวจว่ามี "Required" message 2 ครั้ง (2 required fields)

---

## 🔍 สรุปความสัมพันธ์ระหว่าง 5 Keys

```
┌─────────────────────────────────────────────────────────────┐
│  id: "pairwise_valid_invalid_cases_1"                      │
│  ↓                                                          │
│  Unique identifier for this test case                      │
└─────────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────────┐
│  kind: "failed"                                             │
│  ↓                                                          │
│  Expected outcome: Should show validation errors            │
└─────────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────────┐
│  group: "pairwise_valid_invalid_cases"                      │
│  ↓                                                          │
│  Category: Mixed valid/invalid pairwise testing             │
└─────────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────────┐
│  steps: [...]                                               │
│  ↓                                                          │
│  Test actions: Select dropdown → Enter invalid data → ...  │
└─────────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────────┐
│  asserts: [...]                                             │
│  ↓                                                          │
│  Verify: Validation error messages should appear            │
└─────────────────────────────────────────────────────────────┘
```

---

## 📈 สถิติโครงสร้าง Cases (CustomerDetailsPage)

| Property | Value |
|----------|-------|
| **จำนวน cases ทั้งหมด** | 25 cases |
| **pairwise_valid_invalid_cases** | 12 cases (mixed) |
| **pairwise_valid_cases** | 12 cases (valid-only) |
| **edge_cases** | 1 case (empty fields) |
| **kind="success"** | 13 cases (52%) |
| **kind="failed"** | 12 cases (48%) |
| **Average steps per case** | ~10 steps |
| **Max assertions per case** | 4 assertions (case 5, 8, 12) |
| **Min assertions per case** | 0 assertions (success cases) |

---

## 🎯 การใช้งานโครงสร้างนี้

### 1. Generate Test Code
```dart
// จาก id
void test_pairwise_valid_invalid_cases_1() {
  // จาก steps
  await tester.tap(find.byKey(Key('customer_01_title_dropdown')));
  await tester.pump();
  // ...

  // จาก asserts + kind
  if (kind == 'failed') {
    expect(find.text('First name is required'), findsOneWidget);
  }
}
```

### 2. Test Report
```
Group: pairwise_valid_invalid_cases
├─ Case 1: FAILED ✓ (validation errors detected)
├─ Case 2: FAILED ✓ (validation errors detected)
└─ Case 3: SUCCESS ✓ (no errors)

Group: pairwise_valid_cases
├─ Case 1: SUCCESS ✓
└─ ...

Group: edge_cases
└─ empty_all_fields: FAILED ✓ (required messages shown)
```

### 3. Test Coverage Matrix
```
Dropdown | Text1   | Text2   | Radio   | Result
---------|---------|---------|---------|--------
Ms.      | invalid | valid   | 30-40   | FAILED ✓
Mr.      | valid   | invalid | 10-20   | FAILED ✓
Mrs.     | valid   | valid   | 10-20   | SUCCESS ✓
...
```

---

**สร้างจาก**: `output/test_data/customer_details_page.testdata.json`
**อ้างอิงโค้ด**: `tools/script_v2/generate_test_data.dart`
**Last Updated**: 2025-10-16
