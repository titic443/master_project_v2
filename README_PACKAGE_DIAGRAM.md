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
│  │ + handleExtractManifest()     │──▶│ TestDataGenerator         ││
│  │ + handleGenerateDatasets()    │   │  (generate_test_data)     ││
│  │ + handleGenerateTestData()    │   │ + generateTestData()      ││
│  │ + handleGenerateTestScript()  │   │                           ││
│  │ + handleRunTests()            │   │ GeneratorPict             ││
│  │ + handleGenerateAll()         │   │  (generator_pict)         ││
│  │ + handleFindFile()            │   │ + executePict()           ││
│  │ + handleOpenCoverage()        │   │ + generatePairwise()      ││
│  │                               │   │                           ││
│  │ DatasetGenerator              │   │ TestScriptGenerator       ││
│  │  (generate_datasets)          │   │  (generate_test_script)   ││
│  │ - model                       │   │ + generateScript()        ││
│  │ - apiKey                      │   │ - _processOne()           ││
│  │ + generateDatasets()          │   └───────────────────────────┘│
│  └───────────────┬───────────────┘                               │
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
| `tools/script_v2/generate_datasets.dart` | `DatasetGenerator` | สร้าง test datasets โดยเรียก Gemini AI API |

#### Class: PipelineController

Orchestrate การทำงานระหว่าง Extractor, Generator, และ DatasetGenerator

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

#### Class: DatasetGenerator

ควบคุมการสร้าง test datasets — เรียก Gemini AI API ภายใน (Connection layer)

| Field | Type | หน้าที่ |
|---|---|---|
| `model` | `String` | ชื่อ AI model (default: `gemini-2.5-flash`) |
| `apiKey` | `String?` | API key สำหรับ Gemini |

| Method | เทียบกับ Reference (InputPanelAction) |
|---|---|
| `generateDatasets(manifestPath)` | `setConnectionStatus()` — เรียก external service |

---

### 2.2 Sub-package Extractor

> สกัดข้อมูลจาก Source Code - เทียบกับ **JavaScriptExtractor** ใน reference

#### ไฟล์ในกลุ่มนี้

| ไฟล์ | Class | หน้าที่ |
|---|---|---|
| `tools/script_v2/extract_ui_manifest.dart` | `UiManifestExtractor` | Static Code Analyzer — วิเคราะห์ Flutter source code แล้วสกัด widgets ออกมาเป็น JSON manifest |

#### Methods

| Method | เทียบกับ Reference (JavaScriptExtractor) |
|---|---|
| `processUiFile(path)` | `extractJavaScriptFile()` |
| `_processOne()` — scan widgets, สกัด key, type, meta | `extractHtmlElement()` |
| อ่าน Dart source → parse widget tree | `setJavaScriptFilePath()` + `verifyJavaScriptFile()` |

#### Input / Output

- **Input**: `lib/demos/<page>.dart` (Flutter UI source code)
- **Output**: `output/manifest/demos/<page>.manifest.json` (JSON manifest ของ widgets)

---

### 2.3 Sub-package Generator

> สร้าง Test Data และ Test Script - เทียบกับ **TestDataGenerator** + **RobotGenerator** ใน reference

#### ไฟล์ในกลุ่มนี้

| ไฟล์ | Class | หน้าที่ | เทียบกับ Reference |
|---|---|---|---|
| `tools/script_v2/generate_test_data.dart` | `TestDataGenerator` | สร้าง test plan ด้วย pairwise combinatorial testing | **TestDataGenerator** |
| `tools/script_v2/generator_pict.dart` | `GeneratorPict` (+ `PairwiseResult`, `FactorExtractionResult`) | PICT algorithm module (สร้าง pairwise combinations) | ส่วนหนึ่งของ TestDataGenerator |
| `tools/script_v2/generate_test_script.dart` | `TestScriptGenerator` | แปลง test plan JSON เป็น Flutter integration test code | **RobotGenerator** |

#### TestDataGenerator

| Method | เทียบกับ Reference |
|---|---|
| `generateTestData(manifestPath)` | `createTestData()` |
| `_processOne()` — สร้าง pairwise combinations, edge cases | `generateTestDataWithRBVT()` |
| เขียน `.testdata.json` | `writeCsvFile()` |

#### GeneratorPict (internal module)

| Method | หน้าที่ |
|---|---|
| `generatePictModel()` | สร้าง PICT model file จาก factors |
| `executePict()` | รัน PICT binary เพื่อสร้าง combinations |
| `generatePairwiseInternal()` | Fallback algorithm เมื่อไม่มี PICT binary |
| `parsePictResult()` | Parse ผลลัพธ์จาก PICT |

#### TestScriptGenerator

| Method | เทียบกับ Reference |
|---|---|
| `generateScript(testDataPath)` | `createTestScript()` |
| `_processOne()` — สร้าง Flutter test code | `createSeleniumKeyword()` |
| เขียน `_flow_test.dart` | `writeRobotFile()` |

#### Input / Output

- **TestDataGenerator**: Input: `.manifest.json` + `.datasets.json` → Output: `.testdata.json`
- **TestScriptGenerator**: Input: `.testdata.json` → Output: `integration_test/<page>_flow_test.dart`

---

## 3. Package Connection

> เชื่อมต่อ External Service - เทียบกับ **DatabaseConnection** + **DatabaseConstants** ใน reference
>
> Logic การเชื่อมต่ออยู่ภายใน `generate_datasets.dart` เป็น private functions ที่ `DatasetGenerator` (Controller) เรียกใช้

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
> `DatasetGenerator` class อยู่ใน Controller เพราะทำหน้าที่ orchestrate การสร้าง datasets
> ส่วน Connection layer คือ private functions ที่จัดการ HTTP call + response parsing ไปยัง Gemini API โดยเฉพาะ

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
| **Domain** | Controller | `tools/script_v2/generate_datasets.dart` | `DatasetGenerator` |
| **Domain** | Extractor | `tools/script_v2/extract_ui_manifest.dart` | `UiManifestExtractor` |
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
  ├──2──▶ [Controller] DatasetGenerator.generateDatasets()
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
