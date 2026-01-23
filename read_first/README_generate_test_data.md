# generate_test_data.dart

## ภาพรวม
Script สำหรับสร้าง test plans (testdata.json) จาก UI manifest โดยใช้ **Pairwise Combinatorial Testing** ผ่าน PICT tool เพื่อสร้าง test cases ที่ครอบคลุมการทดสอบทุกคู่ของ inputs อย่างมีประสิทธิภาพ

## การทำงาน
1. อ่าน manifest JSON จาก `output/manifest/`
2. สกัด factors (ตัวแปรทดสอบ) จาก UI widgets:
   - TEXT factors: valid/invalid values
   - Radio factors: radio button options
   - Dropdown factors: dropdown options
   - Checkbox factors: checked/unchecked
3. สร้าง PICT model files และรัน PICT tool
4. สร้าง test cases จาก pairwise combinations:
   - **pairwise_valid_invalid_cases** - รวม valid และ invalid data
   - **pairwise_valid_cases** - เฉพาะ valid data
   - **edge_cases** - empty fields test
5. บันทึก test plan เป็น JSON ใน `output/test_data/`

## วิธีใช้งาน

### ประมวลผลไฟล์เดียว
```bash
dart run tools/script_v2/generate_test_data.dart output/manifest/demos/register_page.manifest.json
```

### ประมวลผลทุกไฟล์ manifest
```bash
dart run tools/script_v2/generate_test_data.dart
```

## Input
- Manifest JSON files จาก `output/manifest/**/*.manifest.json`
- Datasets JSON files จาก `output/test_data/**/*.datasets.json` (optional)

## Output
- Test plan JSON ใน `output/test_data/<page_name>.testdata.json`
- PICT model files ใน `output/model_pairwise/`:
  - `<page>.full.model.txt` - full model (valid + invalid)
  - `<page>.valid.model.txt` - valid-only model
  - `<page>.full.result.txt` - PICT results (full)
  - `<page>.valid.result.txt` - PICT results (valid-only)

## Pairwise Testing คืออะไร?

แทนที่จะทดสอบทุกการผสมกันของ inputs (Cartesian product):
```
3 fields × 2 values each = 2³ = 8 test cases
```

Pairwise testing ครอบคลุม **ทุกคู่** ของ inputs ด้วย test cases น้อยกว่า:
```
3 fields × 2 values each = 4 test cases (pairwise)
```

ผลการวิจัย: Pairwise testing จับ bugs ได้ 70-90% ด้วย test cases เพียง 10-30% ของ exhaustive testing

## PICT Model Structure

### Full Model (valid + invalid)
```
TEXT: valid, invalid
TEXT2: valid, invalid
Radio1: age_10_20_radio, age_21_30_radio, age_31_40_radio
Dropdown: mr, mrs, ms
Checkbox: checked, unchecked
```

### Valid-Only Model
```
TEXT: valid
TEXT2: valid
Radio1: age_10_20_radio, age_21_30_radio, age_31_40_radio
Dropdown: mr, mrs, ms
Checkbox: checked, unchecked
```

## Test Case Groups

### 1. pairwise_valid_invalid_cases
Test cases ที่รวม valid และ invalid data เพื่อทดสอบทั้ง success และ validation failure scenarios

ตัวอย่าง:
```json
{
  "tc": "pairwise_valid_invalid_cases_1",
  "kind": "success",
  "group": "pairwise_valid_invalid_cases",
  "steps": [
    {"enterText": {"byKey": "firstname", "dataset": "byKey.firstname[0].valid"}},
    {"pump": true},
    {"enterText": {"byKey": "lastname", "dataset": "byKey.lastname[0].valid"}},
    {"pump": true},
    {"tap": {"byKey": "submit_button"}},
    {"pumpAndSettle": true}
  ],
  "asserts": [
    {"byKey": "success_snackbar", "exists": true}
  ]
}
```

### 2. pairwise_valid_cases
Test cases ที่ใช้เฉพาะ valid data สำหรับทดสอบ happy path กับ input combinations ต่างๆ

### 3. edge_cases
- **empty_all_fields** - ทดสอบกรณีไม่กรอกข้อมูลเลย
- แสดง validation messages สำหรับ required fields

## โครงสร้าง Test Plan JSON

```json
{
  "source": {
    "file": "lib/demos/register_page.dart",
    "pageClass": "RegisterPage",
    "cubitClass": "RegisterCubit",
    "stateClass": "RegisterState"
  },
  "datasets": {
    "byKey": {
      "firstname": [
        {"valid": "Alice", "invalid": "J", "invalidRuleMessages": "Min 2"}
      ]
    }
  },
  "cases": [
    {
      "tc": "pairwise_valid_invalid_cases_1",
      "kind": "success",
      "group": "pairwise_valid_invalid_cases",
      "steps": [...],
      "asserts": [...]
    },
    {
      "tc": "pairwise_valid_cases_1",
      "kind": "success",
      "group": "pairwise_valid_cases",
      "steps": [...],
      "asserts": [...]
    },
    {
      "tc": "edge_cases_empty_all_fields",
      "kind": "failed",
      "group": "edge_cases",
      "steps": [...],
      "asserts": [...]
    }
  ]
}
```

## Test Step Types

### enterText
```json
{"enterText": {"byKey": "firstname", "dataset": "byKey.firstname[0].valid"}}
```

### tap
```json
{"tap": {"byKey": "submit_button"}}
```

### tapText
```json
{"tapText": "Mr."}
```

### pump / pumpAndSettle
```json
{"pump": true}
{"pumpAndSettle": true}
```

## Assert Types

### byKey with exists
```json
{"byKey": "success_snackbar", "exists": true}
```

### text with exists และ count
```json
{"text": "Required", "exists": true, "count": 3}
```

### byKey with textEquals
```json
{"byKey": "message_text", "textEquals": "Success"}
```

## Widget Naming Convention

Script ใช้ SEQUENCE pattern เพื่อกำหนดลำดับการ tap:
```
{page_prefix}_{SEQUENCE}_{description}_{widget_type}
```

ตัวอย่าง:
- `customer_01_firstname_textfield` → sequence 1
- `customer_05_age_radio_group` → sequence 5
- `customer_10_end_button` → sequence 10 (end button)

**End button** = ปุ่มที่มี sequence สูงสุด (ใช้สำหรับ submit form)

## Factor Detection

### TEXT Factors
- TextField/TextFormField ที่มี key
- Naming: `TEXT`, `TEXT2`, `TEXT3`, ...
- Values: `valid`, `invalid`

### Radio Factors
- จัดกลุ่มตาม `groupValueBinding` ใน meta
- Naming: `Radio1`, `Radio2`, `Radio3`, ...
- Values: radio key suffixes (เช่น `age_10_20_radio`)

### Dropdown Factors
- DropdownButtonFormField ที่มี options
- Naming: `Dropdown`, `Dropdown2`, `Dropdown3`, ...
- Values: option values จาก meta.options

### Checkbox Factors
- Checkbox/FormField<bool>
- Naming: `Checkbox`, `Checkbox2`, `Checkbox3`, ...
- Values: `checked`, `unchecked`

## Expected Keys Detection

Script จะตรวจหา widgets พิเศษ:
- **`*_expected_success`** - แสดงเมื่อ API สำเร็จ
- **`*_expected_fail`** - แสดงเมื่อ API ล้มเหลว หรือ validation fail

## Validation Message Counting

Script วิเคราะห์ validator rules เพื่อนับจำนวน validation messages ที่คาดหวัง:
```json
{
  "text": "Required",
  "exists": true,
  "count": 3  // 3 required fields
}
```

## ตัวอย่าง Output
```
✓ fullpage plan: output/test_data/register_page.testdata.json
```

## การทำงานกับ PICT

1. สกัด factors จาก manifest
2. เขียน PICT model files
3. รัน PICT binary:
   ```bash
   ./pict output/model_pairwise/register_page.full.model.txt
   ```
4. อ่านผลลัพธ์ tab-separated format
5. สร้าง test steps จาก combinations

## Integration กับ Datasets

- อ่าน datasets จาก `output/test_data/<page>.datasets.json`
- ใช้ dataset paths ใน enterText steps:
  ```
  byKey.firstname[0].valid
  byKey.firstname[0].invalid
  ```
- แสดง `invalidRuleMessages` ใน asserts สำหรับ failed cases

## Fallback Behavior

หาก PICT ไม่สามารถรันได้:
- ใช้ internal pairwise algorithm (จาก generator_pict.dart)
- ผลลัพธ์จะคล้ายกัน แต่อาจมี test cases มากกว่า PICT เล็กน้อย

## หมายเหตุ
- Test cases จะเรียงตาม widget key sequence
- Invalid data cases จะ assert validation error messages
- Valid data cases จะ assert expected success keys
- Empty fields test จะใช้ end button เพื่อ trigger validation
