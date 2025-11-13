# Widget Test Structure Documentation

## การจัดโครงสร้างการทดสอบวิดเจ็ต

เอกสารนี้อธิบายโครงสร้างการทดสอบแต่ละประเภทวิดเจ็ตใน `generate_test_data.dart`

---

## 📊 ตาราง 1: Widget Classification & Test Strategy

| Widget Type | ตัวแปรในโค้ด | Pattern การตรวจจับ (Code Line) | Test Actions | Test Data Types | PICT Factor |
|-------------|--------------|-------------------------------|--------------|----------------|-------------|
| **TextFormField** | `textKeys` | `t.startsWith('TextField')` หรือ<br>`t.startsWith('TextFormField')`<br>(Line 248) | 1. `enterText` (byKey + dataset)<br>2. `pump` | • `valid` - ข้อมูลถูกต้อง<br>• `invalid` - ข้อมูลผิด | `TEXT`, `TEXT2`, `TEXT3`, ... |
| **Radio Button** | `radioKeys` | `t.startsWith('Radio')` (Line 250)<br>หรือ `k.endsWith('_radio')` (Line 262) | 1. `tap` (byKey)<br>2. `pump` | • หลาย options ตาม UI<br>• เช่น: 10-20, 30-40, 40-50 | `Radio1`, `Radio2`, `Radio3`, `Radio4` |
| **Checkbox** | `checkboxKeys` | `t.startsWith('Checkbox')` หรือ<br>`t == 'CheckboxListTile'`<br>(Line 252) | 1. `tap` (byKey) - เฉพาะเมื่อ checked<br>2. `pump` | • `checked` - ติ๊กถูก<br>• `unchecked` - ไม่ติ๊ก (default) | `Checkbox`, `Checkbox2`, `Checkbox3`, ... |
| **Dropdown** | `dropdownKeys` | `t.contains('DropdownButton')`<br>(Line 272) | 1. `tap` (byKey) - เปิด dropdown<br>2. `pump`<br>3. `tapText` - เลือก option<br>4. `pump` | • Multiple options จาก `meta.options`<br>• แปลง value → text display | `Dropdown`, `Dropdown2`, ... |
| **Primary Button** | `primaryButtons` | `t == 'ElevatedButton'` หรือ<br>`TextButton` หรือ `OutlinedButton`<br>**แต่ ≠ endKey** (Line 254) | 1. `tap` (byKey)<br>2. `pump` | - | - |
| **End Button** | `endKey` | ปุ่มที่มี **sequence สูงสุด**<br>(Line 214, `_findHighestSequenceButton`) | 1. `tap` (byKey)<br>2. `pumpAndSettle` | - | - |
| **Expected Success** | `expectedSuccessKeys` | `k.contains('_expected_success')`<br>(Line 229) | ไม่มี action (assertion only) | - | ใช้ใน assertions<br>(success cases) |
| **Expected Fail** | `expectedFailKeys` | `k.contains('_expected_fail')`<br>(Line 232) | ไม่มี action (assertion only) | - | ใช้ใน assertions<br>(failed cases) |

---

## 📋 ตาราง 2: Test Step Generation Per Widget

| Widget | Step Sequence | Dataset Path | Fallback Value | ตัวอย่าง Step JSON |
|--------|---------------|--------------|----------------|-------------------|
| **TextFormField** | 1. enterText<br>2. pump | `byKey.<key>.valid[0]`<br>หรือ<br>`byKey.<key>.invalid[0]` | `textForBucket()` - สร้างจาก maxLength | ```json<br>{"enterText": {"byKey": "customer_02_firstname_textfield", "dataset": "byKey.customer_02_firstname_textfield.valid[0]"}}<br>{"pump": true}<br>``` |
| **Radio** | 1. tap<br>2. pump | - | - | ```json<br>{"tap": {"byKey": "customer_04_age_30_40_radio"}}<br>{"pump": true}<br>``` |
| **Checkbox** | 1. tap (เฉพาะ checked)<br>2. pump | - | ไม่กดถ้า unchecked | ```json<br>{"tap": {"byKey": "customer_05_terms_checkbox"}}<br>{"pump": true}<br>``` |
| **Dropdown** | 1. tap dropdown<br>2. pump<br>3. tapText option<br>4. pump | value จาก PICT combo แปลงเป็น display text ผ่าน `dropdownValueToTextMaps` | ใช้ value โดยตรง | ```json<br>{"tap": {"byKey": "customer_01_title_dropdown"}}<br>{"pump": true}<br>{"tapText": "Mr."}<br>{"pump": true}<br>``` |
| **Primary Button** | 1. tap<br>2. pump | - | - | ```json<br>{"tap": {"byKey": "customer_06_primary_button"}}<br>{"pump": true}<br>``` |
| **End Button** | 1. tap<br>2. pumpAndSettle | - | - | ```json<br>{"tap": {"byKey": "customer_07_end_button"}}<br>{"pumpAndSettle": true}<br>``` |

---

## 📊 ตาราง 3: Pairwise Factor Generation

| Widget Category | Factor Name Pattern | Values | Example | จำนวน Combinations |
|-----------------|-------------------|--------|---------|-------------------|
| **TextFormField** | `TEXT`, `TEXT2`, `TEXT3`, ...<br>(ไม่มี TEXT1!) | `['valid', 'invalid']` | TEXT: valid<br>TEXT2: invalid | 2ⁿ (n = จำนวน text fields) |
| **Radio Groups** | `Radio1`, `Radio2`, `Radio3`, `Radio4` | ขึ้นกับ options ใน UI | Radio1: [yes, no]<br>Radio2: [approve, reject] | ขึ้นกับจำนวน options แต่ละ group |
| **Checkbox** | `Checkbox`, `Checkbox2`, `Checkbox3`, ...<br>(ไม่มี Checkbox1!) | `['checked', 'unchecked']` | Checkbox: checked<br>Checkbox2: unchecked | 2ⁿ (n = จำนวน checkboxes) |
| **Dropdown** | `Dropdown`, `Dropdown2`, ... | options จาก `meta.options` | Dropdown: [Mr., Mrs., Ms., Dr.] | จำนวน options ใน dropdown |

### ตัวอย่าง PICT Model:
```
TEXT: valid, invalid
TEXT2: valid, invalid
Radio1: 10-20, 30-40, 40-50
Checkbox: checked, unchecked
Dropdown: Mr., Mrs., Ms., Dr.
```

### ตัวอย่าง PICT Combinations:
```
TEXT    TEXT2   Radio1  Checkbox   Dropdown
valid   invalid 30-40   checked    Ms.
invalid valid   10-20   unchecked  Mr.
valid   valid   10-20   checked    Mrs.
```

---

## 📋 ตาราง 4: Assertion Strategy

| Test Case Type | Condition | Assertions | ตัวอย่าง |
|----------------|-----------|------------|---------|
| **Success Case** | ทุก field ใช้ valid data | ตรวจสอบ `expectedSuccessKeys` ปรากฏ | ```json<br>{"byKey": "customer_08_expected_success_text", "exists": true}<br>``` |
| **Failed Case (Validation)** | มี field ใช้ invalid data | ตรวจสอบ validation messages จาก `validatorRules` | ```json<br>{"text": "First name is required", "exists": true}<br>{"text": "Last name must contain only letters", "exists": true}<br>``` |
| **Failed Case (Expected Fail)** | มี field ใช้ invalid data | ตรวจสอบ `expectedFailKeys` ปรากฏ | ```json<br>{"byKey": "customer_09_expected_fail_text", "exists": true}<br>``` |
| **Edge Case (Empty)** | ไม่กรอกข้อมูลเลย | ตรวจสอบ "Required" messages | ```json<br>{"text": "First name is required", "exists": true, "count": 1}<br>{"text": "Please select a title", "exists": true, "count": 1}<br>``` |

---

## 🔄 ตาราง 5: Test Flow Sequence

| Step Order | Widget Category | Logic | Code Location |
|------------|-----------------|-------|---------------|
| 1 | **Sort Widgets by Key** | จัดเรียง widgets ตาม key ด้วย `compareTo()` | Line 635-640, 722-728, 904-910 |
| 2 | **Text Fields** | วนลูปเติมข้อมูลทุก TextFormField ตามลำดับ | Line 552-565 |
| 3 | **Radio Buttons** | เลือก radio options ตามลำดับ | Line 567-583, 690-705 |
| 4 | **Checkboxes** | Tap checkboxes (เฉพาะ checked) ตามลำดับ | Line 617-632, 707-720, 881-901 |
| 5 | **Dropdowns** | เปิดและเลือก options ทุก dropdown ตามลำดับ | Line 591-615, 850-880 |
| 6 | **Primary Buttons** | กดปุ่มกลางทางทุกปุ่ม (ถ้ามี) | Sorted order in manifest |
| 7 | **End Button** | กดปุ่ม submit/end สุดท้าย | Line 734-735, 918-919 |
| 8 | **Build Assertions** | สร้าง assertions ตาม test case type | Line 740-771 |

---

## 📊 ตาราง 6: Test Case Groups

| Group | ID Pattern | Purpose | จำนวน Cases | Assertions |
|-------|-----------|---------|-------------|------------|
| **pairwise_valid_invalid_cases** | `pairwise_valid_invalid_cases_1`<br>`pairwise_valid_invalid_cases_2`<br>... | ทดสอบ combinations ของ valid และ invalid data | จำนวนตาม PICT result | Success: `expectedSuccessKeys`<br>Failed: validation messages + `expectedFailKeys` |
| **pairwise_valid_cases** | `pairwise_valid_cases_1`<br>`pairwise_valid_cases_2`<br>... | ทดสอบเฉพาะ valid data combinations | จำนวนตาม PICT valid result | `expectedSuccessKeys` เท่านั้น |
| **edge_cases** | `edge_cases_empty_all_fields` | ทดสอบกรณีไม่กรอกข้อมูลเลย | 1 case | "Required" messages ทั้งหมด |

---

## 🎯 ตัวอย่างการทำงานจริง: CustomerDetailsPage

### Input Widgets:
```json
{
  "widgets": [
    {"widgetType": "DropdownButtonFormField<String>", "key": "customer_01_title_dropdown"},
    {"widgetType": "TextFormField", "key": "customer_02_firstname_textfield"},
    {"widgetType": "TextFormField", "key": "customer_03_lastname_textfield"},
    {"widgetType": "Radio<int>", "key": "customer_04_age_10_20_radio"},
    {"widgetType": "Radio<int>", "key": "customer_04_age_30_40_radio"},
    {"widgetType": "Radio<int>", "key": "customer_04_age_40_50_radio"},
    {"widgetType": "ElevatedButton", "key": "customer_07_end_button"}
  ]
}
```

### Detected Collections:
```dart
textKeys = ["customer_02_firstname_textfield", "customer_03_lastname_textfield"]
radioKeys = ["customer_04_age_10_20_radio", "customer_04_age_30_40_radio", "customer_04_age_40_50_radio"]
dropdownKeys = ["customer_01_title_dropdown"]
endKey = "customer_07_end_button"  // highest sequence = 07
```

### PICT Factors:
```
TEXT: valid, invalid
TEXT2: valid, invalid
Radio1: 10-20, 30-40, 40-50
Dropdown: Mr., Mrs., Ms., Dr.
```

### Generated Test Case Example (pairwise_valid_invalid_cases_1):
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
    {"enterText": {"byKey": "customer_02_firstname_textfield", "dataset": "byKey.customer_02_firstname_textfield.valid[0]"}},
    {"pump": true},
    {"enterText": {"byKey": "customer_03_lastname_textfield", "dataset": "byKey.customer_03_lastname_textfield.invalid[0]"}},
    {"pump": true},
    {"tap": {"byKey": "customer_04_age_30_40_radio"}},
    {"pump": true},
    {"tap": {"byKey": "customer_07_end_button"}},
    {"pumpAndSettle": true}
  ],
  "asserts": [
    {"text": "Last name must contain only letters (minimum 2 characters)", "exists": true}
  ]
}
```

### Test Flow Visualization:
```
1. [Sort by key] → 01, 02, 03, 04, 07
2. [Dropdown 01] → Select "Ms."
3. [Text 02] → Enter valid firstname
4. [Text 03] → Enter invalid lastname (INVALID!)
5. [Radio 04] → Select 30-40
6. [Button 07] → Tap end button
7. [Assert] → Expect validation error message
```

---

## 🔍 Key Insights

### 1. Sequence-Based Ordering
- ทุก widget จัดเรียงตาม key sequence (01, 02, 03, ...) ก่อนสร้าง steps
- End button = ปุ่มที่มี sequence สูงสุด (ไม่ต้องมี `_end_` ในชื่อ)

### 2. Pairwise Testing Strategy
- ใช้ PICT เพื่อลดจำนวน test cases แต่ครอบคลุม combinations สำคัญ
- แยกเป็น 2 ชุด:
  - **mixed**: valid + invalid combinations
  - **valid-only**: เฉพาะ valid combinations

### 3. Test Data Sources
- **Primary**: อ่านจาก `<page>.datasets.json` → `byKey.<key>.valid[0]` หรือ `invalid[0]`
- **Fallback**: ใช้ `textForBucket()` สร้างจาก maxLength

### 4. Assertion Logic
- **Success**: มี expectedSuccessKeys
- **Failed**: มี validation messages หรือ expectedFailKeys
- **Empty**: มีเฉพาะ "Required" messages

---

## 📌 Code References

| Feature | Line Numbers |
|---------|-------------|
| Widget Classification | 221-258 (includes Checkbox detection) |
| Sequence Extraction | 172-188 |
| End Button Detection | 192-214 |
| PICT Factor Building | 438-481 (includes Checkbox factors) |
| Test Step Generation | 522-732 (includes Checkbox steps) |
| Assertion Building | 740-771 |
| Key Sorting | 635-640, 722-728, 904-910 |

---

**Generated from**: `tools/script_v2/generate_test_data.dart`
**Last Updated**: 2025-10-17
