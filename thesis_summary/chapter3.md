# บทที่ 3 — Methodology: เครื่องมือสร้าง Test Script ด้วย Pairwise Testing
> สรุปจาก: 6770231021_final.pdf หน้า 26–47

---

## ภาพรวม Pipeline (7 ขั้นตอนหลัก)

```
[3.1] สกัด Metadata จาก .dart file
         ↓
[3.2] สร้าง manifest.json
         ↓
[3.3] ส่ง LLM (Gemini) → สร้าง datasets.json
         ↓
[3.4] วิเคราะห์ Widget ↔ PICT Factor → model.txt (invalid + valid)
         ↓
[3.5] วิเคราะห์ Constraint File (optional)
         ↓
[3.6] เรียก PICT → result.txt (invalid + valid)
         ↓
[3.7] สร้าง test_data.json (source + datasets + cases)
         ↓
[3.8] แปลง JSON → Dart Test Script (.dart)
```

---

## 3.1 สกัดข้อมูล Metadata จากไฟล์ Frontend

- ไฟล์ Target: ต้องอยู่ใต้โฟลเดอร์ `lib/` และตั้งชื่อในรูปแบบ `<page>_page.dart`
- สกัด Metadata ที่จำเป็น 7 รายการ:

| Parameter | คำอธิบาย |
|---|---|
| `key` | ระบุ Widget แบบ Unique |
| `value` | ค่าที่จัดเก็บและแสดงผลขณะนั้น |
| `items` | รายการตัวเลือกทั้งหมดของ Widget (Dropdown, Radio) |
| `validator` | Function ตรวจสอบความถูกต้องของ Input |
| `groupValue` | ค่า State ของ Radio Group |
| `inputFormatters` | เงื่อนไขประเภทอักขระที่อนุญาตให้รับ Input |
| `maxLength` | ความยาวสูงสุดของ Input |

---

## 3.2 สร้างไฟล์ Manifest JSON

- Output: **`<page>.manifest.json`**
- เก็บ Metadata ครบทั้งระดับ Screen และระดับ Widget

**ตารางที่ 3.1 — JSON Keys ใน Manifest:**

| JSON Key | คำอธิบาย | บังคับ |
|---|---|---|
| `file` | Path ของ UI page source file | Y |
| `fileCubit` | Path ของ Cubit (Business Logic) | Y |
| `fileState` | Path ของ State class | Y |
| `pageClass` | ชื่อ Class ของ UI page | Y |
| `cubitClass` | ชื่อ Cubit class | Y |
| `stateClass` | ชื่อ State class | Y |
| `widgetType` | ประเภท Widget (TextFormField/Radio/Checkbox/Dropdown/Button) | Y |
| `key` | Unique Key ของ Widget | Y |
| `inputFormatters` | เงื่อนไขอนุญาต Input (pattern) | N |
| `maxLength` | ความยาวสูงสุด (TextFormField) | N |
| `validatorRules` | เงื่อนไข Validation + Error Message | N |
| `options` | รายการตัวเลือก (Radio/Dropdown) | N |

---

## 3.3 จัดเตรียม Prompt + ส่งคำขอให้ LLM

ขั้นตอนนี้ใช้เฉพาะ Widget ประเภท **TextFormField** เท่านั้น (Dropdown/Radio ใช้ options จาก Manifest โดยตรง)

### โครงสร้าง Prompt (ตาม CO-STEP Framework):

| ส่วน | เนื้อหา |
|---|---|
| **Context** | อธิบายภาพรวม: "เครื่องมือสร้าง Test Data สำหรับ Flutter Form Validation" |
| **Target** | กลุ่มเป้าหมาย: QA Engineer ที่ต้องการ Happy-path + Error-path data |
| **Objective** | กฎ 5 ข้อ: วิเคราะห์ maxLength/inputFormatters/validatorRules, skip isEmpty/null rules, สร้าง valid/invalid pair ต่อ rule, invalid ต้อง conform กับ inputFormatters, output เป็น JSON |
| **Execution** | ขั้นตอน Step-by-step + Few-shot examples เพื่อ fix output schema |
| **Style** | JSON only, ไม่มี markdown, realistic values, string arrays only |
| **Input Data** | Metadata ของ TextFormField widgets จาก manifest |

### ขั้นตอน:
1. วิเคราะห์ Metadata เฉพาะ TextFormField จาก Manifest
2. จัดเตรียม Prompt โครงสร้าง CO-STEP
3. ส่งผ่าน HTTP POST → **Google Gemini 2.5 Flash API**
4. แปลง Response เป็น **`<page>.datasets.json`**

### โครงสร้าง datasets.json (ตารางที่ 3.2):

| JSON Key | คำอธิบาย |
|---|---|
| `file` | Frontend file ที่ถูกสกัด |
| `<widget_key>` | ชื่อคีย์ของ TextFormField widget แต่ละตัว |
| `valid` | ค่าที่ผ่าน Validation (LLM สร้าง) |
| `invalid` | ค่าที่ไม่ผ่าน Validation แต่ยัง conform inputFormatters |
| `invalidRuleMessages` | Error message ที่ตรงกับ Rule ที่ invalid ละเมิด |
| `atMax` | ค่า Boundary ที่ maxLength (Edge case) |
| `atMin` | ค่า Boundary ที่ minLength (Edge case) |

---

## 3.4 วิเคราะห์ Widget ↔ PICT Factor

แปลง Widget แต่ละตัวให้เป็น PICT Factor โดยแยกตามประเภท:

| Widget | PICT Factor & Levels |
|---|---|
| **TextFormField** | Factor ที่มี Level: `valid` และ `invalid` |
| **Radio** | Factor ที่ Level คือ Options จาก Metadata |
| **Dropdown** | Factor ที่ Level คือ Options จาก Metadata |
| **Checkbox** | Factor ที่มี Level: `checked` และ `unchecked` |
| **Switch** | Factor ที่มี Level: `true` และ `false` |

สร้าง **2 Model Files**:
- **`<page>.invalid.model.txt`** — `TextFormField` factors มีเฉพาะ `invalid` level; non-text factors enumerate ค่า option ทั้งหมด → ใช้ทดสอบ negative cases
- **`<page>.valid.model.txt`** — เฉพาะ valid levels → ใช้ทดสอบ positive cases

---

## 3.5 วิเคราะห์ไฟล์เงื่อนไข (Constraint File) — Optional

ไฟล์ **`<page>.constraints.txt`** มี Syntax 3 รูปแบบ:

| รูปแบบ | Syntax | ผลกระทบ |
|---|---|---|
| **1 — Valid Override** | `key.valid = value` | เขียนทับ `valid` ใน datasets.json |
| **2 — Invalid Override** | `key.invalid = value` | เขียนทับ `invalid` ใน datasets.json |
| **3 — Cross-widget Relation** | `IF [keyA] = "vA" THEN [keyB] = "vB";` | เพิ่มเป็น `[Constraints]` section ใน model.txt ทั้งคู่ |

- รูปแบบ 1–2: ไม่แตะ PICT model — เปลี่ยนแค่ค่าที่ inject เข้าไปใน test steps
- รูปแบบ 3: PICT จะ generate combinations ที่ satisfy constraints เท่านั้น
- ถ้า Syntax ผิด → แสดงข้อความ "Invalid Constraint Syntax" และ halt

---

## 3.6 เรียกใช้ PICT → สร้าง Pairwise Test Cases

- เรียก PICT เป็น subprocess 2 ครั้ง (invalid model + valid model)
- PICT คำนวณ Combinations ที่ทุก Pair ถูก Cover อย่างน้อยหนึ่งครั้ง
- Output (Tab-delimited, 1 row = 1 test case):
  - **`<page>.invalid.result.txt`** — Combinations จาก invalid model
  - **`<page>.valid.result.txt`** — Combinations จาก valid model

---

## 3.7 สร้าง Test Data ในรูปแบบ JSON

Output: **`<page>.test_data.json`** — มี 3 Top-level Keys:

### Key 1: `source` — BLoC/Screen Metadata
ข้อมูล import paths และ class names สำหรับ Phase ถัดไป:
`file`, `fileCubit`, `fileState`, `pageClass`, `cubitClass`, `stateClass`

### Key 2: `datasets` — Valid/Invalid Values
ค่าจริงจาก datasets.json ที่จะ inject ใน test steps (keyed by widget key)

### Key 3: `cases` — Test Case Objects
แต่ละ case มี 5 fields:

| Field | คำอธิบาย |
|---|---|
| `tc` | Unique ID เช่น `pairwise_invalid_cases_1` |
| `kind` | `success` หรือ `failed` |
| `group` | กลุ่มของ test case (ดูด้านล่าง) |
| `steps` | ลำดับคำสั่ง Widget interaction |
| `asserts` | Expected outcome หลัง test |

**3 กลุ่ม Test Case:**

| Group | วัตถุประสงค์ |
|---|---|
| `pairwise_invalid_cases` | ทดสอบ Validation บน UI — มีค่า invalid อย่างน้อย 1 field |
| `pairwise_valid_cases` | ทดสอบ Happy path — ทุก field valid → ส่ง request Backend ได้ถูกต้อง |
| `edge_cases` | Boundary testing (3 sub-cases ด้านล่าง) |

**3 Edge Case Sub-types:**

| Sub-type | คำอธิบาย |
|---|---|
| `edge_cases_empty_all_fields` | ทุก field ว่าง → ทดสอบ required validation |
| `edge_cases_boundary_at_max_length` | TextFormField มีค่า maxLength → ทดสอบส่ง request ได้ |
| `edge_cases_boundary_at_min_length` | TextFormField มีค่า minLength → ทดสอบส่ง request ได้ |

**Widget → Test Command Mapping (ตารางที่ 3.5):**

| Widget | คำสั่งทดสอบ |
|---|---|
| TextFormField | `enterText(byKey)` → `pump()` |
| Radio | `tap(byKey)` → `pump()` |
| Dropdown | `tap(byKey)` → `pump()` → `tapText(label)` → `pump()` |
| Checkbox | `tap(byKey)` → `pump()` |
| **Button** | `tap(byKey)` → **`pumpAndSettle()`** (รอ async ให้จบก่อน assert) |

**Assert Structure (ตารางที่ 3.6):**

| JSON Key | คำอธิบาย |
|---|---|
| `text` | ข้อความที่คาดหวังบนหน้าจอ (Error message) |
| `byKey` | Key ของ Widget ที่คาดหวัง (Success/Fail indicator) |
| `exist` | `true` = ต้องเจอ, `false` = ต้องไม่เจอ |

**Assert logic ตาม Group:**

| Group | Assertion |
|---|---|
| `pairwise_invalid_cases` | ใช้ `invalidRuleMessages` เป็น `text` assert |
| `pairwise_valid_cases` | ใช้ `<prefix>_expect_success` key |
| `edge_cases_empty_all_fields` | ใช้ `invalidRuleMessages` หรือ fail key |
| `edge_cases_boundary_at_max/min` | ใช้ success key (ค่าขอบ = valid) |

### ขั้นตอนที่ 4: จัดลำดับคำสั่ง (Key Naming Convention)

เครื่องมืออ่านชื่อ Key เพื่อจัดลำดับ steps อัตโนมัติ โครงสร้างชื่อ Key:

```
<prefix>_<sequence>_<description>_<widget_type>
```

| ส่วน | ความหมาย |
|---|---|
| `prefix` | ชื่อ class ของ Frontend file |
| `sequence` | ลำดับการทำงานใน Test Script (จัดลำดับ steps) |
| `description` | คำอธิบาย Widget |
| `widget_type` | ประเภท Widget |

---

## 3.8 แปลง JSON → Dart Test Script

- Output: **`<page>_test.dart`**
- อ่าน `source` key → สร้าง `import` statements + `BlocProvider` wrapper
- แต่ละ case → `testWidgets()` block
- Structure ของแต่ละ test:
  1. **Setup:** `tester.pumpWidget(MaterialApp(home: BlocProvider(..., child: PageClass())))`
  2. **Interact:** แปลง `steps` → `WidgetTester` calls ตามลำดับ sequence
  3. **Assert:** แปลง `asserts` → `expect(find.text()/find.byKey(), findsOneWidget/findsNothing)`

**Mapping JSON → Dart (ตารางที่ 3.8):**

| JSON (test_data) | Dart Command |
|---|---|
| `file` | `import 'package:.../page.dart'` |
| `fileCubit` | `import 'package:.../cubit.dart'` |
| `fileState` | `import 'package:.../state.dart'` |
| `group` | `group('pairwise_invalid_cases', () {...})` |
| `tc` | `testWidgets('pairwise_invalid_cases_1', ...)` |
| `pageClass` | `tester.pumpWidget(MaterialApp(home: PageClass()))` |
| `cubitClass` | `BlocProvider<CubitClass>(create: (_) => CubitClass())` |

---

## สรุปสั้น ๆ (Key Takeaway)

บทที่ 3 คือหัวใจของงานวิจัย — อธิบาย **Pipeline 7 ขั้นตอน** อย่างละเอียด:

1. **สกัด** Widget Metadata จาก `.dart` file
2. **บันทึก** เป็น `manifest.json`
3. **ใช้ LLM** สร้าง valid/invalid/edge values → `datasets.json`
4. **แปลง** Widget → PICT Factor → `model.txt` (2 แบบ: invalid + valid)
5. **Constraint File** (optional) → override datasets หรือ เพิ่ม PICT constraints
6. **PICT** สร้าง Pairwise combinations → `result.txt` (2 แบบ)
7. **Merge** ทุกอย่างเป็น `test_data.json` (3 groups: VI, V, Edge)
8. **Render** JSON → Dart Test Script พร้อม run

> **จุดสำคัญ:** Key naming convention (`prefix_sequence_description_type`) เป็น mechanism หลักที่ทำให้ Tool จัดลำดับ test steps ได้อัตโนมัติ โดยไม่ต้องให้นักพัฒนา hardcode ลำดับเอง

---

*ไฟล์นี้สร้างเพื่อเป็น context สำหรับเปรียบเทียบกับ ieee_paper.tex*
