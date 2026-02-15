# Package Diagram Review — เทียบกับ Source Code จริง

เทียบจาก `webview/server.dart` และ `tools/script_v2/*.dart`

---

## 1. PipelineController (`webview/server.dart`)

### Fields (ถูกต้องทั้งหมด)
| ในแผนภาพ | ในโค้ด | สถานะ |
|-----------|--------|-------|
| `- extractor` | `_extractor` | OK |
| `- datasetGenerator` | `_datasetGenerator` | OK |
| `- testDataGenerator` | `_testDataGenerator` | OK |
| `- testScriptGenerator` | `_testScriptGenerator` | OK |

### Methods
| ในแผนภาพ | ในโค้ด | สถานะ |
|-----------|--------|-------|
| `+ handleRunTests` | line 767 | OK |
| `+ handleRequest` | line 137 | OK |
| `+ handleGenerateAll` | line 1057 | OK |
| `+ handleExtractManifest` | line 497 | OK |
| `+ handleGenerateDatasets` | line 538 | OK |
| `+ handleGenerateTestData` | line 602 | OK |
| `+ handleGenerateTestScript` | line 672 | OK |
| `+ handleOpenCoverage` | line 1204 | OK |
| `+ handleScan` | line 400 | OK |
| `+ handleFindFile` | line 283 | OK |
| `+ handleGetTestScripts` | line 250 | OK |
| `+ serveCoverageFile` | line 1258 | OK |
| — | `+ handleGetFiles` (line 225) | **ขาด** |
| — | `+ handleFindTestScript` (line 352) | **ขาด** |
| — | `+ serveStaticFile` (line 1300) | **ขาด** |
| — | `- _readBody` (line 1346) | **ขาด** |

---

## 2. UiManifestExtractor (`tools/script_v2/extract_ui_manifest.dart`)

### ข้อผิดพลาดสำคัญ
- `processUiFile` เป็น **top-level function** ไม่ใช่ method ของ class
- public method จริงของ class คือ `extractManifest` (line 87)

### Methods
| ในแผนภาพ | ในโค้ด | สถานะ |
|-----------|--------|-------|
| `+ processUiFile` | top-level function (ไม่ใช่ class method) | **ผิด** — ควรเปลี่ยนเป็น `+ extractManifest` |
| `- _stripComments` | มี | OK |
| `- _findPageClass` | มี | OK |
| `- _findCubitType` | มี | OK |
| `- _findStateType` | มี | OK |
| `- _scanWidgets` | มี | OK |
| `- _extractKey` | มี | OK |
| `- _extractTextFieldMeta` | มี | OK |
| `- _extractValidationMeta` | มี | OK |
| `- _scanDateTimePickers` | มี | OK |
| — | `- _processOne` | **ขาด** |
| — | `- _matchParen` | **ขาด** |
| — | `- _matchBrace` | **ขาด** |
| — | `- _extractOnTapMethod` | **ขาด** |
| — | `- _extractTextBinding` | **ขาด** |
| — | `- _maybeTextLiteral` | **ขาด** |
| — | `- _collectRegexVars` | **ขาด** |
| — | `- _collectStringConsts` | **ขาด** |
| — | `- _extractRadioMeta` | **ขาด** |
| — | `- _collectRadioOptionMeta` | **ขาด** |
| — | `- _extractSequence` | **ขาด** |
| — | `- _findCubitFilePath` | **ขาด** |
| — | `- _findStateFilePath` | **ขาด** |
| — | `- _findContainingMethod` | **ขาด** |
| — | `- _extractDatePickerParams` | **ขาด** |
| — | `- _extractTimePickerParams` | **ขาด** |
| — | `- _parseDateTimeArgs` | **ขาด** |

---

## 3. DatasetGenerator (`tools/script_v2/generate_datasets.dart`)

### Fields
| ในแผนภาพ | ในโค้ด | สถานะ |
|-----------|--------|-------|
| `- model` | `model` (line 85) | OK |
| `- apiKey` | `apiKey` (line 89) | OK |

### Methods
| ในแผนภาพ | ในโค้ด | สถานะ |
|-----------|--------|-------|
| `+ generateDatasets` | line 152 | OK |
| `+ handleGenerateAll` | **ไม่มีใน class นี้** — อยู่ใน PipelineController | **ผิด class — ลบออก** |
| `- _processManifest` | line 195 | OK |
| `- _callGeminiForDatasets` | line 453 | OK |
| `- _extractTextFromGemini` | line 728 | OK |
| `+ handleScan` | **ไม่มีใน class นี้** — อยู่ใน PipelineController | **ผิด class — ลบออก** |
| — | `- _stripCodeFences` (line 781) | **ขาด** |

---

## 4. TestDataGenerator (`tools/script_v2/generate_test_data.dart`)

### Fields
| ในแผนภาพ | ในโค้ด | สถานะ |
|-----------|--------|-------|
| — | `- pictBin` (line 84 in constructor) | **ขาด** |

### Methods
| ในแผนภาพ | ในโค้ด | สถานะ |
|-----------|--------|-------|
| `+ generateTestData` | line 90 | OK |
| `- _tryWritePictModelFromManifestForUi` | line 1900 | OK |
| `- _processOne` | line 133 | OK |
| `- _findHighestSequenceButton` | line 259 (local function inside _processOne) | OK (แต่เป็น local function) |
| — | `- _optionsFromMeta` (line 1990) | **ขาด** |

---

## 5. TestScriptGenerator (`tools/script_v2/generate_test_script.dart`)

### Methods
| ในแผนภาพ | ในโค้ด | สถานะ |
|-----------|--------|-------|
| `+ generateTestScript` | line 78 | OK |
| `- _generateIntegrationTests` | line 982 | OK |
| `- _extractValidationCountsFromPlan` | line 1464 | OK |
| `- _resolveDataset` | line 1505 | OK |
| `- _getStateFilePathFromCubit` | line 1431 | OK |
| `- _dartMapLiteral` | line 523 (local function) | OK |
| `- _inferFailureCode` | line 550 (local function) | OK |
| — | `- _processOne` (line 106) | **ขาด** |
| — | `- _maybeLoadExternalDatasets` (line 168) | **ขาด** |
| — | `- _getPrimaryCubitType` (line 1409) | **ขาด** |

---

## 6. GeneratorPict (`tools/script_v2/generator_pict.dart`)

### Fields
| ในแผนภาพ | ในโค้ด | สถานะ |
|-----------|--------|-------|
| — | `- pictBin` (in constructor) | **ขาด** |

### Methods
| ในแผนภาพ | ในโค้ด | สถานะ |
|-----------|--------|-------|
| `+ generatePictModel` | line 49 | OK |
| `+ generateValidOnlyPictModel` | line 68 | OK |
| `+ executePict` | line 138 | OK |
| `+ extractFactorsFromManifest` | line 296 area | OK |
| `+ generatePairwiseFromManifest` | line 748 | OK |
| `+ writePictModelFiles` | line 584 | OK |
| `+ parsePictResult` | line 178 | OK |
| `+` (บรรทัดว่าง) | — | **ลบออก** |
| — | `+ generatePairwiseInternal` (line 649) | **ขาด** |
| — | `+ parsePictModel` (line 209) | **ขาด** |
| — | `+ readFactorNamesFromModel` (line 250) | **ขาด** |
| — | `- _formatValuesForModel` (line 107) | **ขาด** |
| — | `- _executePictToFile` (line 625) | **ขาด** |
| — | `- _extractRadioGroupName` (line 408) | **ขาด** |
| — | `- _factorNameForRadioGroupKey` (line 435) | **ขาด** |
| — | `- _extractRadioKeySuffix` (line 443) | **ขาด** |
| — | `- _extractRadioOptionLabel` (line 454) | **ขาด** |
| — | `- _generateDateValues` (line 462) | **ขาด** |
| — | `- _extractOptionsFromMeta` (line 546) | **ขาด** |

---

## สรุปสิ่งที่ต้องแก้ไข (เฉพาะจุดสำคัญ)

### ผิด class (ต้องแก้แน่นอน)
1. **DatasetGenerator** → ลบ `handleGenerateAll` และ `handleScan` ออก (อยู่ใน PipelineController)

### ผิดชื่อ/ประเภท
2. **UiManifestExtractor** → เปลี่ยน `+ processUiFile` เป็น `+ extractManifest` (processUiFile เป็น top-level function)

### ขาดใน PipelineController
3. เพิ่ม `+ handleGetFiles`
4. เพิ่ม `+ handleFindTestScript`
5. เพิ่ม `+ serveStaticFile`

### ขาดใน UiManifestExtractor (เลือกเฉพาะที่สำคัญ)
6. เพิ่ม `- _processOne`
7. เพิ่ม `- _collectStringConsts`
8. เพิ่ม `- _collectRegexVars`
9. เพิ่ม `- _extractRadioMeta`
10. เพิ่ม `- _extractDatePickerParams`
11. เพิ่ม `- _extractTimePickerParams`

### ขาดใน DatasetGenerator
12. เพิ่ม `- _stripCodeFences`

### ขาดใน TestDataGenerator
13. เพิ่ม field `- pictBin`
14. เพิ่ม `- _optionsFromMeta`

### ขาดใน TestScriptGenerator
15. เพิ่ม `- _processOne`
16. เพิ่ม `- _maybeLoadExternalDatasets`
17. เพิ่ม `- _getPrimaryCubitType`

### ขาดใน GeneratorPict
18. เพิ่ม field `- pictBin`
19. เพิ่ม `+ generatePairwiseInternal`
20. เพิ่ม `+ parsePictModel`
21. เพิ่ม `+ readFactorNamesFromModel`
22. ลบบรรทัด `+` ที่ว่างอยู่ออก

> **หมายเหตุ**: สำหรับ package diagram ในวิทยานิพนธ์ ไม่จำเป็นต้องใส่ private method ทุกตัว
> แต่ **public methods** และ **fields** ควรครบถ้วน และ method ต้อง**อยู่ถูก class**
