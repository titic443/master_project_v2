# Context: tools/ และ webview/

> เอกสารนี้อธิบาย context และหน้าที่ของแต่ละไฟล์ใน folder `tools/` และ `webview/`  
> อ่านร่วมกับ `ieee_paper.tex` เพื่อเข้าใจ research context

---

## ภาพรวม Pipeline (4 Phases)

ระบบนี้เป็นเครื่องมืออัตโนมัติสำหรับสร้าง Flutter Widget Test (**Dart test scripts**) จาก Flutter UI source code โดยไม่ต้องเขียน test ด้วยมือ ขั้นตอนหลักมี 4 Phase:

```
Phase 1: extract_ui_manifest.dart
  อ่าน lib/demos/<page>.dart → output/manifest/<page>.manifest.json
       ↓
Phase 2: generate_datasets.dart
  ส่ง manifest ไปให้ Google Gemini AI → output/test_data/<page>.datasets.json
       ↓
Phase 3: generate_test_data.dart  (+ generator_pict.dart)
  เรียก PICT binary สร้าง combinations → output/model_pairwise/ + output/test_data/<page>.testdata.json
       ↓
Phase 4: generate_test_script.dart
  แปลง testdata.json เป็น Dart test file → integration_test/<page>_flow_test.dart
```

ทั้ง 4 phase นี้ถูกเรียกผ่าน **Web UI** (`webview/`) และสามารถรันแบบ command line ได้ด้วย

---

## tools/

### tools/script_v2/

---

#### `extract_ui_manifest.dart` — Phase 1: Static Analyzer

**บทบาท:** อ่าน Flutter `.dart` source file แล้วสกัด widget metadata ออกมาเป็น JSON manifest

**วิธีใช้:**
```bash
dart run tools/script_v2/extract_ui_manifest.dart lib/demos/job_search_page.dart
```

**Input:** Flutter UI page file (`.dart`)  
**Output:** `output/manifest/demos/<page>.manifest.json`

**สิ่งที่ extract ได้:**
- **Screen-level metadata:** `pageClass`, `cubitClass`, `stateClass`, `fileCubit`, `fileState` — ใช้สำหรับสร้าง `BlocProvider` wrapper ใน test script
- **Widget-level metadata ต่อแต่ละ widget:** `key`, `widgetType`, `inputFormatters`, `maxLength`, `validatorRules`, `options` (dropdown/radio)

**Widget ที่รองรับ:** `TextFormField`, `DropdownButtonFormField`, `Radio`, `Checkbox`, `Switch`, `ElevatedButton`, `Text`

**กลไกสำคัญ:**
- `_stripComments()` — ลบ `//` และ `/* */` ออกก่อน scan เพื่อไม่จับ widgets ที่ comment ไว้
- `_matchParen()` / `_matchBrace()` — ใช้ parenthesis matching แทน regex เพื่อ parse nested structure ได้ถูกต้อง
- `_extractKey()` — รองรับ `Key('...')`, `ValueKey(...)`, `ObjectKey(...)` และ string interpolation กับ `const` variables
- `_extractSequence()` — อ่าน prefix เลขจาก key (เช่น `1_`, `2_`) เพื่อเรียง widget ตาม UI order
- `_scanDateTimePickers()` — จับ `showDatePicker`/`showTimePicker` calls และ link กลับไปหา TextField ที่เรียกมัน

**Public API:**
```dart
UiManifestExtractor().extractManifest('lib/demos/page.dart');
// → returns path ของ output manifest
```

---

#### `generate_datasets.dart` — Phase 2: AI Test Data Generator

**บทบาท:** ส่ง widget metadata ไปให้ Google Gemini AI เพื่อสร้างข้อมูลทดสอบ `valid`/`invalid` ที่สมจริงสำหรับแต่ละ `TextFormField`

**วิธีใช้:**
```bash
dart run tools/script_v2/generate_datasets.dart output/manifest/demos/job_search_page.manifest.json
```

**Input:** `output/manifest/<page>.manifest.json`  
**Output:** `output/test_data/<page>.datasets.json`

**โครงสร้าง output:**
```json
{
  "file": "lib/demos/page.dart",
  "datasets": {
    "byKey": {
      "field_key": [
        {
          "valid": "ค่าที่ถูกต้อง",
          "invalid": "ค่าที่ผิด",
          "invalidRuleMessages": "ข้อความ error ที่ควรแสดง",
          "atMin": "ค่าที่ขอบต่ำสุด",
          "atMax": "ค่าที่ขอบสูงสุด"
        }
      ]
    }
  }
}
```

**Prompt Engineering (6 ส่วน ตาม Tuan Pham framework):**
1. `CONTEXT` — บอก AI ว่าเป็นระบบ generate test data
2. `TARGET` — QA engineer ต้องการข้อมูล realistic
3. `OBJECTIVE` — rules 9 ข้อ: วิเคราะห์ validator rules, skip isEmpty rules, generate pairs per rule, respect inputFormatters
4. `EXECUTION` — ขั้นตอนละเอียด + 4 few-shot examples
5. `STYLE` — JSON only, no markdown, Thai values สำหรับ Thai app
6. กำหนด format ของ output schema

**API Key Priority:**
1. `--api-key=` flag
2. ไฟล์ `.env` (`GEMINI_API_KEY=...`)
3. environment variable
4. hardcoded constant (fallback)

**Public API:**
```dart
DatasetGenerator(model: 'gemini-2.5-flash')
    .generateDatasets('output/manifest/demos/page.manifest.json');
```

---

#### `generate_test_data.dart` — Phase 3: PICT Test Plan Builder

**บทบาท:** รับ manifest + datasets แล้วสร้าง PICT model files, เรียก PICT binary, แปลง combinations เป็น test plan JSON

**วิธีใช้:**
```bash
dart run tools/script_v2/generate_test_data.dart output/manifest/demos/job_post_page.manifest.json
```

**Input:**
- `output/manifest/<page>.manifest.json`
- `output/test_data/<page>.datasets.json` (ถ้ามี)
- constraints string (optional, ผ่าน parameter)

**Output:**
- `output/model_pairwise/<page>.invalid.model.txt` — PICT model (VI: valid/invalid combinations)
- `output/model_pairwise/<page>.invalid.result.txt` — PICT output combinations
- `output/model_pairwise/<page>.valid.model.txt` — PICT model (V: valid-only)
- `output/model_pairwise/<page>.valid.result.txt` — valid combinations
- `output/test_data/<page>.testdata.json` — test plan สำหรับ Phase 4

**3 Model Variants:**
1. **VI (Valid/Invalid)** — `TextFormField` factors มีเฉพาะ `invalid` sentinel; produce negative-path test cases
2. **V (Valid-only)** — factors มีเฉพาะ `valid`; produce positive-path test cases  
3. **Edge** — 3 boundary-value cases: empty input, max-length, special characters

**โครงสร้าง testdata.json:**
```json
{
  "source": { "pageClass": "...", "cubitClass": "...", ... },
  "datasets": { "byKey": { ... } },
  "cases": [
    {
      "tc": "pairwise_invalid_cases_1",
      "kind": "failed",
      "group": "pairwise_invalid_cases",
      "steps": [...],
      "asserts": [...]
    }
  ]
}
```

**Public API:**
```dart
TestDataGenerator(pictBin: './pict')
    .generateTestData(manifestPath, constraints: constraintString);
```

---

#### `generator_pict.dart` — PICT Engine

**บทบาท:** Library module สำหรับทุกอย่างที่เกี่ยวกับ PICT — สร้าง model file, เรียก binary, parse result, filter constraints

**ไม่มี `main()` — ใช้เป็น import เท่านั้น**

**Class: `GeneratorPict`**

| Method | หน้าที่ |
|---|---|
| `generatePictModel()` | สร้าง PICT model string จาก factors map + constraints |
| `generateInvalidModel()` | สร้าง VI model (TextFormField = `invalid` only) |
| `generateValidModel()` | สร้าง V model (TextFormField = `valid` only) |
| `executePict()` | เรียก PICT binary เป็น subprocess, return combinations |
| `parsePictResult()` | parse tab-delimited PICT output เป็น `List<Map>` |
| `extractFactorsFromManifest()` | แปลง manifest widgets เป็น PICT factors |
| `writePictModelFiles()` | เขียน `.model.txt` และ `.result.txt` files |
| `filterCombosAgainstConstraints()` | Post-processing filter: enforce IF/THEN rules ใน Dart |

**Known Issue & Fix:**
PICT binary บน macOS arm64 อาจ silently ignore `IF/THEN` constraints — แก้ไขด้วย `filterCombosAgainstConstraints()` ที่ enforce rules ใน Dart หลัง PICT รัน (ดู CLAUDE.md สำหรับรายละเอียด)

**Format ของ PICT Model:**
```
field_key_textfield: valid, invalid
dropdown_key: "option1", "option2"
switch_key: on, off

IF [dropdown_key] = "option1" THEN [switch_key] = "on";
```

---

#### `generate_test_script.dart` — Phase 4: Dart Test Code Generator

**บทบาท:** แปลง `testdata.json` เป็น Flutter integration test file (`.dart`) ที่รันได้จริง

**วิธีใช้:**
```bash
dart run tools/script_v2/generate_test_script.dart output/test_data/job_post_page.testdata.json
```

**Input:** `output/test_data/<page>.testdata.json`  
**Output:** `integration_test/<page>_flow_test.dart`

**โครงสร้าง test file ที่สร้าง:**
```dart
import 'package:myapp/demos/page.dart';
import 'package:myapp/cubit/page_cubit.dart';

void main() {
  group('pairwise_invalid_cases', () {
    testWidgets('pairwise_invalid_cases_1', (tester) async {
      // Setup: pump MaterialApp + BlocProvider
      await tester.pumpWidget(...);
      
      // Interact: enterText, tap, tapText ตาม steps
      await tester.enterText(find.byKey(Key('field_key')), 'invalid_value');
      await tester.tap(find.byKey(Key('submit_btn')));
      await tester.pumpAndSettle();
      
      // Assert: expect error messages
      expect(find.text('Error message'), findsOneWidget);
    });
  });
}
```

**3 Groups ใน output:**
- `pairwise_invalid_cases` — test cases ที่มี invalid input (ตรวจ error messages)
- `pairwise_valid_cases` — test cases ที่ valid ทั้งหมด (ตรวจ success state)
- `edge_cases` — boundary value test cases (empty, max-length, special chars)

**Widget → Test Command mapping:**
| Widget | Test Command |
|---|---|
| `TextFormField` | `tester.enterText(find.byKey(...), value)` |
| `DropdownButtonFormField` | `tester.tap(find.byKey(...))` + `tester.tap(find.text(label))` |
| `Radio` / `Checkbox` / `Switch` | `tester.tap(find.byKey(...))` |
| `ElevatedButton` | `tester.tap(find.byKey(...))` — วางไว้ last step เสมอ |

**Public API:**
```dart
TestScriptGenerator().generateTestScript('output/test_data/page.testdata.json');
```

---

#### `utils.dart` — Shared Utilities

**บทบาท:** รวม utility functions ที่ใช้ร่วมกันทุก script ใน `script_v2/`

**Functions:**
| Function | หน้าที่ |
|---|---|
| `basename(path)` | ดึงชื่อไฟล์จาก path |
| `basenameWithoutExtension(path)` | ดึงชื่อไฟล์โดยไม่มี extension |
| `pkgImport(package, libPath)` | แปลง `lib/demos/page.dart` → `package:myapp/demos/page.dart` |
| `readPackageName()` | อ่านชื่อ package จาก `pubspec.yaml` |
| `camelToSnake(name)` | แปลง `CustomerCubit` → `customer_cubit` (สำหรับหา file path) |
| `readApiKeyFromEnv()` | อ่าน `GEMINI_API_KEY` จากไฟล์ `.env` |
| `findDeclFile(className)` | หา `.dart` file ที่มี class declaration |
| `dartEscape(str)` | escape string สำหรับ emit เป็น Dart string literal |

---

#### `clear_manifest.dart` — Output Cleaner

**บทบาท:** ลบไฟล์ทั้งหมดใน `output/` directory เพื่อ reset pipeline

**วิธีใช้:**
```bash
dart run tools/script_v2/clear_manifest.dart
```

ลบทุกอย่างใน: `output/manifest/`, `output/test_data/`, `output/model_pairwise/`, และ subdirectory อื่นๆ ใน `output/`

---

### tools/constraints/

#### `CONSTRAINTS_GUIDE.md` — คู่มือเขียน Constraints

**บทบาท:** คู่มือสำหรับนักพัฒนาในการเขียน constraint file ที่ถูก syntax

**Format ที่รองรับ 2 แบบ:**

**Format A — Dataset Override** (สำหรับ `TextFormField` เท่านั้น, ไม่มี `;`):
```txt
key.valid   = ค่า valid จริงใน DB
key.invalid = ค่า invalid ที่ต้องการทดสอบ
```
ไม่ถูกส่งไป PICT — ระบบ Dart overwrite ค่าใน datasets.json ก่อน generate

**Format B — PICT IF/THEN** (ต้องลงท้ายด้วย `;`):
```txt
IF [key_A] = "value_A" THEN [key_B] = "value_B";
IF [key_A] = "value_A" THEN [key_B] <> "value_B";
```
ถูกส่งไปเป็น `[Constraints]` section ใน PICT model file

#### `<page_name>.constraints.txt` files

Constraint files ปัจจุบัน:
- `job_search_page.constraints.txt`
- `clinic_search_page.constraints.txt`
- `linkedin_profile_page.constraints.txt` (legacy)
- `linkedin_search_page.constraints.txt` (legacy)

แต่ละไฟล์ encode business logic rules ที่อยู่ใน Cubit layer และไม่สามารถสกัดได้จาก static analysis ของ UI file เช่น salary range constraints, cross-field dependencies

---

### tools/ (root)

#### `check_widget_coverage.sh` — Coverage Filter Script

**บทบาท:** Shell script สำหรับตรวจสอบ widget coverage จาก lcov data

#### `verify_tests.sh` — Test Verification Script

**บทบาท:** Shell script สำหรับ verify ว่า generated test files ถูก syntax และรันได้

#### `flutter_test_generator.dart` — Legacy Entry Point

**บทบาท:** Entry point เก่า (legacy) ก่อนแยกเป็น `script_v2/` — ยังคงไว้เพื่อ backward compatibility

#### `widget_coverage.dart` — Coverage Reporter

**บทบาท:** Script สำหรับ parse lcov output และ report coverage statistics แบบ widget-level

---

## webview/

Web UI layer ทำหน้าที่เป็น interface ระหว่างผู้ใช้กับ pipeline scripts ทั้ง 4 phases ใน `tools/script_v2/`

---

#### `server.dart` — HTTP Server + Pipeline Controller

**บทบาท:** HTTP server หลักที่รับ requests จาก browser และเรียก pipeline scripts

**วิธีรัน:**
```bash
dart run webview/server.dart
# → http://localhost:8080
```

**Architecture:** `PipelineController` class รับ HTTP request และ dispatch ไปยัง domain classes โดยตรง (import classes จาก `tools/script_v2/` แทนการเรียก subprocess)

**REST API Endpoints:**

| Method | Endpoint | หน้าที่ |
|---|---|---|
| GET | `/files` | รายการ `.dart` files ใน `lib/demos/` |
| POST | `/find-file` | หา full path จาก filename |
| POST | `/scan` | scan widgets ใน file (preview ก่อน generate) |
| POST | `/extract-manifest` | Phase 1: สร้าง manifest JSON |
| POST | `/generate-datasets` | Phase 2: เรียก Gemini AI สร้าง datasets |
| POST | `/generate-test-data` | Phase 3: เรียก PICT สร้าง test plan |
| POST | `/generate-test-script` | Phase 4: สร้าง Dart test file |
| POST | `/run-tests` | รัน `flutter test` พร้อม coverage |
| POST | `/generate-all` | รัน full pipeline (Phase 1-4) ในครั้งเดียว |
| POST | `/open-coverage` | เปิด coverage HTML report ใน browser |
| GET | `/coverage/*` | serve coverage HTML files |

**Error Handling:** ทุก endpoint ครอบด้วย try-catch และ return JSON `{"error": "..."}` เมื่อ fail

---

#### `coverage_runner.dart` — Test Runner & Coverage Generator

**บทบาท:** รัน Flutter test, สร้าง lcov coverage report, และเปิด browser

**Class: `CoverageGenerator`**

| Method | หน้าที่ |
|---|---|
| `clearCoverage()` | ลบ coverage data เก่าออก |
| `findMobileDevice()` | หา connected device/emulator สำหรับ integration test |
| `runFlutterTest(path)` | รัน `flutter test --coverage` เป็น subprocess |
| `generateCoverageReport()` | รัน `lcov --remove` + `genhtml` สร้าง HTML report |
| `openCoverageReport()` | เปิด `coverage/html/index.html` ใน browser (รองรับ macOS/Linux/Windows) |

**Return type: `TestRunResult`** — เก็บ exit code, stdout, stderr, test case list (parsed), passed/failed counts

**External CLI ที่เรียก:** `flutter test`, `flutter devices`, `lcov`, `genhtml`, `open`/`xdg-open`/`start`

---

#### `index.html` — Web UI HTML

**บทบาท:** Single-page application สำหรับใช้งาน test generation tool

**UI Sections (4 ขั้นตอน):**
1. **Select Input File** — browse `.dart` UI file
2. **PICT Constraints** — optional checkbox + import constraints file
3. **Output Directory** — เลือกที่เก็บ output
4. **Generate** — ปุ่ม Generate (full pipeline) และ Run Coverage

**Key Elements:** `#inputFile`, `#constraintsText`, `#generateBtn`, `#outputLog`, `#testSummarySection`

---

#### `main.js` — Web UI Frontend Logic

**บทบาท:** JavaScript controller class `WebUI` สำหรับจัดการทุก user interaction

**Class: `WebUI`**

| Method | หน้าที่ |
|---|---|
| `browseInputFile()` | เปิด file picker สำหรับ `.dart` UI file |
| `browseOutputDir()` | เปิด directory picker สำหรับ output |
| `generateTests()` | เรียก full pipeline ผ่าน `POST /generate-all` |
| `runCoverageTest()` | เรียก `POST /run-tests` |
| `#showDialog()` | แสดง modal dialog (error/success) |
| `#renderTestSummary()` | render ตาราง test results |
| `#updateOutputFileName()` | update output filename preview |

**API Communication:** ใช้ `fetch()` เรียก REST endpoints ของ `server.dart` ที่ `http://localhost:8080`

---

#### `styles.css` — Web UI Stylesheet

**บทบาท:** CSS styles สำหรับ Web UI — step badges, progress indicators, log area, dialog overlay, summary table

---

#### `flow.ini` — Flow Configuration

**บทบาท:** Configuration file สำหรับ flow control ของ pipeline (เช่น skip บาง steps หรือตั้งค่า timeout)

---

## Dependency Map

```
webview/server.dart
  ├── tools/script_v2/extract_ui_manifest.dart  [Phase 1]
  ├── tools/script_v2/generate_datasets.dart    [Phase 2]
  ├── tools/script_v2/generate_test_data.dart   [Phase 3]
  │     └── tools/script_v2/generator_pict.dart
  ├── tools/script_v2/generate_test_script.dart [Phase 4]
  └── webview/coverage_runner.dart              [Test + Coverage]

(ทุก script ใน script_v2/ import)
  └── tools/script_v2/utils.dart
```

---

## Key Design Decisions

### ทำไมถึงแยก Phase 2 (AI) ออกจาก Phase 3 (PICT)?

Phase 2 ต้องการ network (Gemini API) และอาจ fail ได้ — แยกออกให้ผู้ใช้สามารถ override ค่าที่ AI generate ได้ผ่าน `constraints.txt` Format A ก่อน Phase 3 จะใช้ค่าเหล่านั้น

### ทำไม generator_pict.dart ต้องมี post-processing filter?

PICT binary บน macOS arm64 บางเวอร์ชัน silently ignore `IF/THEN` constraints — จึงต้อง enforce rules ใน Dart หลัง PICT รัน เพื่อให้ผลลัพธ์ถูกต้องเสมอ (ดู CLAUDE.md → Known Issues)

### Widget ที่ไม่มี `Key` จะถูก skip เสมอ

ทั้ง Phase 1 และ Phase 3 ข้าม widgets ที่ไม่มี `key` property — นี่เป็น requirement ของ Flutter `find.byKey()` ใน test
