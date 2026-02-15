# Package Diagram - Flutter Test Generator

## Overview

เอกสารนี้อธิบายการจัดกลุ่มไฟล์ในระบบ Flutter Test Generator ตามรูปแบบ Package Diagram
โดยเทียบเคียงกับ reference architecture ที่ประกอบด้วย View, Domain (Controller, Extractor, Generator) และ Connection

---

## Package Structure

```
┌──────────────────────────────────────────────────────────────────┐
│ View                                                             │
│  ┌────────────────────────────────────────┐                      │
│  │ «class» WebUI (main.js)               │                      │
│  │ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─│                      │
│  │  static API_BASE                      │                      │
│  │ - inputFile                           │                      │
│  │ - outputFile                          │                      │
│  │ - constraintsText                     │                      │
│  │ - generatedTestScript                 │                      │
│  │ - #isGenerating                       │                      │
│  │ - #hasValidWidgets                    │                      │
│  │ - #testScriptGenerated                │                      │
│  │ - #el (cached DOM refs)               │                      │
│  │ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─│                      │
│  │ + browseInputFile()                   │                      │
│  │ + browseOutputFile()                  │                      │
│  │ + generateTests()                     │                      │
│  │ + runCoverageTest()                   │                      │
│  │ - #initElements()                     │                      │
│  │ - #setupEventListeners()              │                      │
│  │ - #validateForm()                     │                      │
│  │ - #scanWidgets()                      │                      │
│  │ - #log() / #clearLog()                │                      │
│  └──────────────────┬─────────────────────┘                      │
│                     │ index.html + styles.css                    │
└─────────────────────┼────────────────────────────────────────────┘
                      │ HTTP API
┌─────────────────────┼────────────────────────────────────────────┐
│ Domain              │                                            │
│                     ▼                                            │
│  ┌─Controller────────────────────┐   ┌─Extractor───────────────┐│
│  │ PipelineController            │   │ UiManifestExtractor      ││
│  │  (server.dart)                │   │  (extract_ui_manifest)   ││
│  │ - _extractor                  │   │                          ││
│  │ - _datasetGenerator           │──▶│ + processUiFile()        ││
│  │ - _testDataGenerator          │   │ - _processOne()          ││
│  │ - _testScriptGenerator        │   └─────────────────────────┘│
│  │ + handleRequest()             │                               │
│  │ + handleScan()                │   ┌─Generator────────────────┐│
│  │ + handleExtractManifest()     │   │ DatasetGenerator          ││
│  │ + handleGenerateDatasets()    │──▶│  (generate_datasets)      ││
│  │ + handleGenerateTestData()    │   │ - model / - apiKey        ││
│  │ + handleGenerateTestScript()  │   │ + generateDatasets()      ││
│  │ + handleRunTests()            │   │                           ││
│  │ + handleGenerateAll()         │   │ TestDataGenerator         ││
│  │ + handleFindFile()            │   │  (generate_test_data)     ││
│  │ + handleOpenCoverage()        │   │ + generateTestData()      ││
│  │                               │   │                           ││
│  └───────────────┬───────────────┘   │ GeneratorPict             ││
│                  │                   │  (generator_pict)         ││
│                  │                   │ + executePict()           ││
│                  │                   │ + generatePairwise()      ││
│                  │                   │                           ││
│                  │                   │ TestScriptGenerator       ││
│                  │                   │  (generate_test_script)   ││
│                  │                   │ + generateScript()        ││
│                  │                   │ - _processOne()           ││
│                  │                   └───────────────────────────┘│
└──────────────────┼───────────────────────────────────────────────┘
                   │
┌──────────────────┼───────────────────────────────────────────────┐
│ Connection       │                                               │
│                  ▼                                                │
│  ┌─AiConnection──────────────────┐   ┌─ConnectionConstants─────┐│
│  │ _callGeminiForDatasets()      │   │ hardcodedApiKey          ││
│  │ _extractTextFromGemini()      │──▶│ model (gemini-2.5-flash) ││
│  │ _stripCodeFences()            │   │ Gemini API endpoint      ││
│  └───────────────────────────────┘             │                 │
│       (internal functions ใน                   ▼                 │
│        generate_datasets.dart)           Gemini AI API           │
└──────────────────────────────────────────────────────────────────┘
```

---

## 1. Package View

> ส่วนติดต่อผู้ใช้ (Web UI) - เทียบกับ **InputPanel** ใน reference

### ไฟล์ในกลุ่มนี้

| ไฟล์ | หน้าที่ |
|---|---|
| `webview/index.html` | HTML layout - input fields, buttons, progress sections |
| `webview/styles.css` | CSS styling สำหรับ Web UI |
| `webview/main.js` | **class WebUI** — JavaScript UI controller, จัดการ events, เรียก REST API ไปหา server |

### Class: WebUI

หลัง refactor จาก function-based เป็น class-based ตาม Package Diagram

#### Fields

| Visibility | Field | Type | หน้าที่ | เทียบกับ Reference (InputPanel) |
|---|---|---|---|---|
| `static` | `API_BASE` | `string` | Base URL ของ server (`http://localhost:8080`) | - |
| `public` | `inputFile` | `string` | path ของ Dart UI file | `javaScriptPath` |
| `public` | `outputFile` | `string` | output directory / path | `outputDirectory` |
| `public` | `constraintsText` | `string` | PICT constraints text | - (feature เพิ่มเติม) |
| `public` | `generatedTestScript` | `string?` | path ของ generated test script | `robotFileName` |
| `private` | `#isGenerating` | `boolean` | สถานะว่ากำลัง generate อยู่หรือไม่ | - |
| `private` | `#hasValidWidgets` | `boolean` | ไฟล์ที่เลือกมี widgets หรือไม่ | - |
| `private` | `#testScriptGenerated` | `boolean` | test script ถูก generate แล้วหรือยัง | `testDataFileName` |
| `private` | `#el` | `object` | cached DOM element references | - |

#### Methods

| Visibility | Method | หน้าที่ | เทียบกับ Reference (InputPanel) |
|---|---|---|---|
| `public` | `browseInputFile()` | เปิด file picker เลือก Dart file | `showJFileChooser()` |
| `public` | `browseOutputFile()` | เปิด file picker เลือก output location | `showJFileChooser()` |
| `public` | `generateTests()` | trigger 4-step generation pipeline | `getInputVariable()` |
| `public` | `runCoverageTest()` | รัน Flutter test + coverage | - (feature เพิ่มเติม) |
| `private` | `#initElements()` | cache DOM references → `this.#el` | - |
| `private` | `#setupEventListeners()` | bind events ผ่าน arrow functions | - |
| `private` | `#checkFileSystemAccess()` | ตรวจ File System Access API | - |
| `private` | `#validateForm()` | validate form + enable/disable buttons | - |
| `private` | `#toggleConstraintsPanel()` | แสดง/ซ่อน PICT constraints panel | - |
| `private` | `#loadConstraintsFile()` | โหลด constraints จากไฟล์ | - |
| `private` | `#scanWidgets(filePath)` | scan widgets ผ่าน API `/scan` | - |
| `private` | `#showCoverageSection()` | แสดง coverage results | - |
| `private` | `#viewCoverageReport()` | เปิด coverage HTML ใน browser | - |
| `private` | `#openCoverageFolder()` | เปิด folder coverage ใน file explorer | - |
| `private` | `#updateButtonStates()` | อัพเดทสถานะปุ่ม Generate/Run | - |
| `private` | `#runStep(step, params)` | เรียก API endpoint 1 step | - |
| `private` | `#resetProgress()` | reset progress indicators | - |
| `private` | `#updateProgress(step, status, msg)` | อัพเดท progress indicator | - |
| `private` | `#log(message, type)` | เขียน log ลง output panel | - |
| `private` | `#clearLog()` | ล้าง output log | - |
| `private` | `#showTestSummary(summary)` | แสดงตาราง test case summary | - |
| `private` | `#setSummaryRunningState()` | set summary rows เป็น "Running..." | - |
| `private` | `#updateSummaryFromCoverage(testCases)` | อัพเดท summary จากผล coverage | - |
| `private` | `#showResults(results)` | แสดง generated file paths | - |

#### Entry Point

```javascript
document.addEventListener('DOMContentLoaded', () => {
  new WebUI();
});
```

---

## 2. Package Domain

### 2.1 Sub-package Controller

> ตัวควบคุมหลัก / Orchestrator - เทียบกับ **InputPanelAction** ใน reference

#### ไฟล์ในกลุ่มนี้

| ไฟล์ | Class | หน้าที่ |
|---|---|---|
| `webview/server.dart` | `PipelineController` | HTTP Server + Request Router + Pipeline orchestrator |

#### Class: PipelineController

Orchestrate การทำงานระหว่าง Extractor และ Generator

| Field | Type | หน้าที่ |
|---|---|---|
| `_extractor` | `UiManifestExtractor` | dependency: สกัด UI manifest |
| `_datasetGenerator` | `DatasetGenerator` | dependency: สร้าง datasets ผ่าน AI |
| `_testDataGenerator` | `TestDataGenerator` | dependency: สร้าง test plan |
| `_testScriptGenerator` | `TestScriptGenerator` | dependency: สร้าง test script |

| Method | เทียบกับ Reference (InputPanelAction) |
|---|---|
| `handleRequest()` | main request router |
| `handleScan()` | `getJavaScriptFilePath()` |
| `handleExtractManifest()` | `getJavaScriptFilePath()` |
| `handleGenerateDatasets()` | `setConnectionStatus()` |
| `handleGenerateTestData()` | `createOutputFileName()` |
| `handleGenerateTestScript()` | `updateOutputFileName()` |
| `handleRunTests()` | - (feature เพิ่มเติม) |
| `handleGenerateAll()` | `generateOutput()` |
| `handleFindFile()` | `createJFileChooser()` |
| `handleOpenCoverage()` | - (feature เพิ่มเติม) |

---

### 2.2 Sub-package Extractor

> สกัดข้อมูลจาก Source Code - เทียบกับ **JavaScriptExtractor** ใน reference

#### ไฟล์ในกลุ่มนี้

| ไฟล์ | Class | หน้าที่ |
|---|---|---|
| `tools/script_v2/extract_ui_manifest.dart` | `UiManifestExtractor` | Static Code Analyzer — วิเคราะห์ Flutter source code แล้วสกัด widgets ออกมาเป็น JSON manifest |

#### Class: UiManifestExtractor

| Visibility | Method | หน้าที่ | เทียบกับ Reference |
|---|---|---|---|
| `public` | `extractManifest(path)` | entry point — อ่านไฟล์ + สร้าง manifest JSON | `extractJavaScriptFile()` |
| `private` | `_processOne(path)` | core processing: strip comments → find metadata → scan widgets → write JSON | `extractHtmlElement()` |

#### Internal Functions (เรียกจาก `_processOne`)

| Function | หน้าที่ |
|---|---|
| `_stripComments(src)` | ลบ `//` และ `/* */` comments โดยไม่ลบ strings |
| `_findPageClass(src)` | หาชื่อ Widget class ที่ `extends StatefulWidget/StatelessWidget` |
| `_findCubitType(src)` | หา Cubit class จาก `BlocBuilder<XxxCubit, ...>` |
| `_findStateType(src)` | หา State class จาก generic parameter ตัวที่สอง |
| `_scanWidgets(src)` | scan target widgets ทั้งหมด (TextFormField, Radio, Button, Dropdown, ...) แล้ว extract key + meta |
| `_extractKey(args)` | ดึง key จาก `Key('...')`, `ValueKey(...)`, `ObjectKey(...)` + resolve `${}` interpolation |
| `_extractTextFieldMeta(args)` | extract keyboardType, obscureText, maxLength, inputFormatters |
| `_extractValidationMeta(type, args)` | extract validator rules, dropdown options, checkbox/radio bindings |
| `_scanDateTimePickers(src)` | scan `showDatePicker` / `showTimePicker` calls แล้ว link กับ onTap method |

#### Input / Output

- **Input**: `lib/demos/<page>.dart` (Flutter UI source code)
- **Output**: `output/manifest/demos/<page>.manifest.json` (JSON manifest ของ widgets)

---

### 2.3 Sub-package Generator

> สร้าง Test Data และ Test Script - เทียบกับ **TestDataGenerator** + **RobotGenerator** ใน reference

#### ไฟล์ในกลุ่มนี้

| ไฟล์ | Class | หน้าที่ | เทียบกับ Reference |
|---|---|---|---|
| `tools/script_v2/generate_datasets.dart` | `DatasetGenerator` | สร้าง test datasets โดยเรียก Gemini AI API | **DatabaseConnection** (เชื่อมต่อ external service) |
| `tools/script_v2/generate_test_data.dart` | `TestDataGenerator` | สร้าง test plan ด้วย pairwise combinatorial testing | **TestDataGenerator** |
| `tools/script_v2/generator_pict.dart` | `GeneratorPict` (+ `PairwiseResult`, `FactorExtractionResult`) | PICT algorithm module (สร้าง pairwise combinations) | ส่วนหนึ่งของ TestDataGenerator |
| `tools/script_v2/generate_test_script.dart` | `TestScriptGenerator` | แปลง test plan JSON เป็น Flutter integration test code | **RobotGenerator** |

#### Class: DatasetGenerator

สร้าง test datasets จาก manifest โดยเรียก Gemini AI API ภายใน (Connection layer)

| Field | Type | หน้าที่ |
|---|---|---|
| `model` | `String` | ชื่อ AI model (default: `gemini-2.5-flash`) |
| `apiKey` | `String?` | API key สำหรับ Gemini |

| Visibility | Method | หน้าที่ | เทียบกับ Reference |
|---|---|---|---|
| `public` | `generateDatasets(manifestPath)` | entry point — สร้าง datasets จาก manifest | `connectToolDatabase()` |

##### Internal Functions (เรียกจาก `generateDatasets`)

| Function | หน้าที่ |
|---|---|
| `_processManifest(path, model, apiKey)` | core processing: อ่าน manifest → หา text fields → เรียก AI → เขียน output |
| `_callGeminiForDatasets(apiKey, model, uiFile, fields)` | ส่ง HTTP request ไปยัง Gemini API พร้อม prompt |
| `_extractTextFromGemini(response)` | ดึง text content จาก Gemini response JSON |
| `_stripCodeFences(s)` | ลบ markdown code fences (` ```json `) จาก AI response |

##### Input / Output

- **Input**: `output/manifest/demos/<page>.manifest.json`
- **Output**: `output/test_data/<page>.datasets.json`
- **External**: Gemini AI API

---

#### Class: TestDataGenerator

สร้าง test plan ด้วย pairwise combinatorial testing

| Field | Type | หน้าที่ |
|---|---|---|
| `pictBin` | `String` | path ของ PICT binary (default: `./pict`) |

| Visibility | Method | หน้าที่ | เทียบกับ Reference |
|---|---|---|---|
| `public` | `generateTestData(manifestPath, {constraints})` | entry point — สร้าง test plan จาก manifest | `createTestData()` |

##### Internal Functions (เรียกจาก `generateTestData`)

| Function | หน้าที่ |
|---|---|
| `_processOne(path, {pairwiseMerge, planSummary, pairwiseUsePict, pictBin, constraints})` | core processing: อ่าน manifest → สร้าง factors → PICT → สร้าง test cases → เขียน JSON |
| `_tryWritePictModelFromManifestForUi(uiFile, widgets, ...)` | สร้าง PICT model files จาก manifest widgets |

> `_processOne` ภายในทำงาน 7 ขั้นตอน: parse manifest → สร้าง PICT model → โหลด datasets → ระบุ widget types → สร้าง pairwise combinations → สร้าง edge cases → เขียน `.testdata.json`

##### Input / Output

- **Input**: `.manifest.json` + `.datasets.json` (optional)
- **Output**: `output/test_data/<page>.testdata.json`

---

#### Class: GeneratorPict

PICT algorithm module — สร้าง pairwise test combinations

| Field | Type | หน้าที่ |
|---|---|---|
| `pictBin` | `String` | path ของ PICT binary (default: `'./pict'`) |

##### Data Classes

| Class | หน้าที่ |
|---|---|
| `FactorExtractionResult` | ผลจาก `extractFactorsFromManifest()`: factors map + widget metadata |
| `PairwiseResult` | ผลจาก `generatePairwiseFromManifest()`: combinations + factor info |

##### Fields ของ FactorExtractionResult

| Field | Type | หน้าที่ |
|---|---|---|
| `factors` | `Map<String, List<String>>` | mapping ระหว่าง factor name กับ list ของ possible values (เช่น `{"username": ["valid","invalid"]}`) |
| `requiredCheckboxes` | `Set<String>` | เซตของ checkbox keys ที่เป็น required (ต้อง checked จึงจะ valid) |

##### Fields ของ PairwiseResult

| Field | Type | หน้าที่ |
|---|---|---|
| `combinations` | `List<Map<String, String>>` | ผลลัพธ์ pairwise combinations ทั้งหมด (รวม valid + invalid cases) |
| `validCombinations` | `List<Map<String, String>>` | เฉพาะ combinations ที่ทุก factor เป็น valid value เท่านั้น |
| `factors` | `Map<String, List<String>>` | factors map ที่ใช้ในการ generate (เหมือน FactorExtractionResult.factors) |
| `method` | `String` | วิธีที่ใช้ generate: `'pict'` (ใช้ PICT binary) หรือ `'internal'` (ใช้ built-in algorithm) |

##### Public Methods

| Visibility | Method | หน้าที่ |
|---|---|---|
| `public` | `generatePictModel(factors, {constraints})` | สร้าง PICT model text จาก factors map |
| `public` | `generateValidOnlyPictModel(factors, ...)` | สร้าง PICT model เฉพาะ valid values (ไม่รวม `invalid`/`unchecked`) |
| `public` | `executePict(factors, {constraints})` | รัน PICT binary เพื่อสร้าง pairwise combinations |
| `public` | `parsePictResult(content)` | parse PICT result (tab-separated) เป็น List ของ Maps |
| `public` | `parsePictModel(content)` | parse PICT model file เพื่อดึง factors |
| `public` | `readFactorNamesFromModel(modelFilePath)` | อ่าน factor names จาก model file |
| `public` | `extractFactorsFromManifest(widgets)` | ดึง factors จาก manifest widgets → `FactorExtractionResult` |
| `public` | `writePictModelFiles({factors, pageBaseName, ...})` | เขียน PICT model files ลง disk |
| `public` | `generatePairwiseInternal(factors)` | สร้าง pairwise combinations ด้วย internal algorithm |
| `public` | `generatePairwiseFromManifest({manifestPath, ...})` | end-to-end: extract factors → run PICT → return `PairwiseResult` |

##### Private Methods

| Method | หน้าที่ |
|---|---|
| `_formatValuesForModel(factorName, values)` | format values สำหรับ PICT syntax (quote dropdown values) |
| `_executePictToFile(modelPath, outputPath)` | รัน PICT binary แล้วเขียน output ลงไฟล์ |
| `_extractRadioGroupName(radioKey)` | สกัดชื่อ radio group จาก key |
| `_factorNameForRadioGroupKey(key)` | แปลง radio key เป็น factor name สำหรับ PICT |
| `_extractRadioKeySuffix(radioKey)` | ดึง suffix ของ radio key โดยตัด prefix ออก |
| `_extractRadioOptionLabel(radioKey)` | ดึง label ของ radio option จาก key |
| `_generateDateValues(pickerMeta)` | สร้าง date values จาก DatePicker metadata |
| `_extractOptionsFromMeta(raw)` | ดึง options จาก dropdown metadata |

---

#### Class: TestScriptGenerator

แปลง test plan JSON เป็น Flutter integration test code

| Visibility | Method | หน้าที่ | เทียบกับ Reference |
|---|---|---|---|
| `public` | `generateTestScript(testDataPath)` | entry point — สร้าง test script จาก test data | `createTestScript()` |

##### Internal Functions (เรียกจาก `generateTestScript`)

| Function | หน้าที่ |
|---|---|
| `_processOne(planPath)` | core processing: parse test data → สร้าง stub classes → สร้าง test cases → เขียน test file |
| `_generateIntegrationTests(uiFile, pageClass, ...)` | สร้าง integration test file แยก (ใช้ real providers แทน stubs) |
| `_extractValidationCountsFromPlan(cases)` | นับจำนวน validation fields ต่อ group จาก test plan |
| `_resolveDataset(root, rawPath)` | resolve dataset path เช่น `byKey.email_textfield[0].valid` → ค่าจริง |
| `_getStateFilePathFromCubit(cubitType)` | แปลง `CustomerCubit` → `lib/cubit/customer_state.dart` |

> `_processOne` ภายในทำงาน 6 ขั้นตอน: parse test data → ดึง source metadata → โหลด datasets → สร้าง stub Cubit classes → สร้าง test cases ตาม groups → เขียน `_flow_test.dart`

##### Input / Output

- **Input**: `output/test_data/<page>.testdata.json`
- **Output**: `integration_test/<page>_flow_test.dart`

---

## 3. Package Connection

> เชื่อมต่อ External Service - เทียบกับ **DatabaseConnection** + **DatabaseConstants** ใน reference
>
> Logic การเชื่อมต่ออยู่ภายใน `generate_datasets.dart` เป็น private functions ที่ `DatasetGenerator` (Generator) เรียกใช้

#### Internal Functions (ใน generate_datasets.dart)

| Function | หน้าที่ | เทียบกับ Reference (DatabaseConnection) |
|---|---|---|
| `_callGeminiForDatasets()` | ส่ง HTTP request ไปยัง Gemini API | `connectToolDatabase()` / `getHttpData()` |
| `_extractTextFromGemini()` | ดึง text content จาก Gemini response | `getMapData()` / `getExampleData()` |
| `_stripCodeFences()` | ลบ markdown code fences จาก AI response | - |

#### Constants (เทียบกับ DatabaseConstants)

| Constant | เทียบกับ Reference |
|---|---|
| `hardcodedApiKey` / `.env` GEMINI_API_KEY | `databaseToolConstant` |
| `model` (default: `gemini-2.5-flash`) | `inputConstant` |
| Gemini API endpoint URL | `databaseUndertestConstant` |

> หมายเหตุ: ระบบ reference ใช้ Database เป็น external service หลัก แต่ระบบของเราใช้ **Gemini AI API** แทน
> `DatasetGenerator` class อยู่ใน Generator เพราะทำหน้าที่ generate test datasets
> ส่วน Connection layer คือ private functions ภายในไฟล์เดียวกันที่จัดการ HTTP call + response parsing ไปยัง Gemini API โดยเฉพาะ

#### External Service

- **Gemini AI API** — `https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent`

---

## 4. Utility (Shared Helpers)

> ไม่มี package ตรงๆ ใน reference - เป็น shared functions ที่ใช้ร่วมกันทุก package

| ไฟล์ | หน้าที่ |
|---|---|
| `tools/script_v2/utils.dart` | Shared utility functions: `basename()`, `camelToSnake()`, `readPackageName()`, `pkgImport()`, `dartEscape()`, `readApiKeyFromEnv()` |
| `tools/script_v2/clear_manifest.dart` | Cleanup utility — ลบ output files ทั้งหมด |

---

## สรุปการ Mapping ไฟล์ → Package

| Package | Sub-package | ไฟล์ | Class |
|---|---|---|---|
| **View** | - | `webview/index.html`, `webview/styles.css`, `webview/main.js` | `WebUI` |
| **Domain** | Controller | `webview/server.dart` | `PipelineController` |
| **Domain** | Extractor | `tools/script_v2/extract_ui_manifest.dart` | `UiManifestExtractor` |
| **Domain** | Generator | `tools/script_v2/generate_datasets.dart` | `DatasetGenerator` |
| **Domain** | Generator | `tools/script_v2/generate_test_data.dart` | `TestDataGenerator` |
| **Domain** | Generator | `tools/script_v2/generator_pict.dart` | `GeneratorPict`, `PairwiseResult`, `FactorExtractionResult` |
| **Domain** | Generator | `tools/script_v2/generate_test_script.dart` | `TestScriptGenerator` |
| **Connection** | - | (private functions ใน `generate_datasets.dart`) | `_callGeminiForDatasets()`, `_extractTextFromGemini()` |
| Utility | - | `tools/script_v2/utils.dart`, `tools/script_v2/clear_manifest.dart` | - |

---

## Data Flow (Pipeline)

```
User (Browser)
  │
  ▼
[View] WebUI class (main.js)
  │  HTTP POST via #runStep()
  ▼
[Controller] PipelineController (server.dart) ─── handleRequest()
  │
  ├──1──▶ [Extractor] UiManifestExtractor.processUiFile()
  │         lib/demos/page.dart → output/manifest/demos/page.manifest.json
  │
  ├──2──▶ [Generator] DatasetGenerator.generateDatasets()
  │         │
  │         └──▶ [Connection] _callGeminiForDatasets() ──▶ Gemini AI API
  │              manifest.json ──▶ page.datasets.json
  │
  ├──3──▶ [Generator] TestDataGenerator.generateTestData()
  │         │            + GeneratorPict.executePict()
  │         manifest.json + datasets.json → page.testdata.json
  │
  └──4──▶ [Generator] TestScriptGenerator.generateScript()
            testdata.json → integration_test/page_flow_test.dart
```
