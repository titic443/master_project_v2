# CLAUDE.md — Project Brief for AI Assistant

This file provides guidance to Claude when working with code in this repository.

---

## Project Overview

Flutter project สำหรับ **วิทยานิพนธ์** ว่าด้วยการสร้าง Integration Test อัตโนมัติจาก UI widgets โดยใช้เทคนิค **Pairwise Combinatorial Testing (PICT)** ร่วมกับ BLoC/Cubit pattern

**Branch ที่ใช้งานอยู่:** `ieee_paper_v2`

---

## Pipeline Overview

```
lib/demos/<page>.dart                             ← Flutter UI pages (source of truth)
     ↓  [scan → extract_ui_manifest.dart]
output/manifest/demos/<page>.manifest.json        ← Widget inventory (key, type, options)
     ↓  [generate-datasets → generate_datasets.dart via LLM]
output/test_data/<page>.datasets.json             ← Valid/invalid values per field
     ↓  [generate-test-data → generate_test_data.dart + PICT binary]
output/model_pairwise/<page>.invalid.model.txt       ← PICT model (factors + constraints)
output/model_pairwise/<page>.invalid.result.txt      ← PICT combinations
output/test_data/<page>.testdata.json             ← Structured test plan
     ↓  [generate-test-script → generate_test_script.dart]
integration_test/<page>_flow_test.dart            ← Flutter integration tests
     ↓  [run-tests with coverage]
coverage/html/index.html                          ← LCOV HTML coverage report
```

---

## How to Start

```bash
# Start Web UI server — ทำทุก step ผ่านหน้าเว็บนี้
dart run webview/server.dart
# → http://localhost:8080
```

---

## Key Directories

| Path | คำอธิบาย |
|---|---|
| `lib/demos/` | Flutter UI pages ที่ scan ได้ |
| `lib/cubit/` | BLoC/Cubit state management |
| `webview/` | HTTP server + Web UI (server.dart, main.js, index.html) |
| `tools/script_v2/` | Dart pipeline scripts ทั้งหมด |
| `tools/constraints/` | Constraint files แยกต่างหากต่อ page |
| `output/manifest/` | Auto-generated widget manifests |
| `output/model_pairwise/` | PICT model files + result combinations |
| `output/test_data/` | Datasets JSON + testdata JSON |
| `integration_test/` | Generated Flutter integration tests |

---

## Pages ที่มีใน Project

| Page | Demo File | Cubit |
|---|---|---|
| Job Search | `lib/demos/job_search_page.dart` | `job_search_cubit.dart` |
| Job Post | `lib/demos/job_post_page.dart` | `job_post_cubit.dart` |
| Property Search | `lib/demos/property_search_page.dart` | `property_search_cubit.dart` |
| Property Post | `lib/demos/property_post_page.dart` | `property_post_cubit.dart` |
| Clinic Search | `lib/demos/clinic_search_page.dart` | `clinic_search_cubit.dart` |
| Clinic Appointment | `lib/demos/clinic_appointment_page.dart` | `clinic_appointment_cubit.dart` |

---

## Constraint System (tools/constraints/)

Constraint files: `tools/constraints/<page_name>.constraints.txt`
คู่มือเต็ม: `tools/constraints/CONSTRAINTS_GUIDE.md`

### Format A — Dataset Override (TextField เท่านั้น)

```txt
key.valid   = ค่าจริงใน DB
key.invalid = ค่าที่ผิด
```

ไม่มี `;` — ระบบ Dart จัดการก่อนส่งไป PICT

### Format B — PICT IF/THEN (บรรทัดเดียว ลงท้าย `;`)

```txt
IF [key_A] = "value_A" THEN [key_B] = "value_B";
IF [key_A] = "value_A" THEN [key_B] <> "value_B";
```

### Widget → ค่าใน PICT Model

| Widget | ค่า |
|---|---|
| TextField / TextFormField | `valid`, `invalid` |
| DropdownButtonFormField | ค่า option (quoted, space→underscore) เช่น `"Engineering"`, `"IT_&_Tech"` |
| Switch | `on`, `off` |
| Checkbox | `checked`, `unchecked` |
| Radio | suffix key เช่น `education_phd_radio` |

> **ดู key จริง** จาก `output/model_pairwise/<page>.invalid.model.txt` หลัง Scan เสมอ

---

## Known Issues & Fixes

### PICT Silently Ignores IF/THEN Constraints (macOS arm64)

**อาการ:** PICT รัน exit code 0 แต่ result file ยังมี combination ที่ละเมิด constraint

**สาเหตุ:** PICT binary บางเวอร์ชัน silently ignore constraints เมื่อ values ถูก quote

**Fix (commit `33c9595`):** เพิ่ม post-processing filter ใน `generator_pict.dart`:
- `filterCombosAgainstConstraints()` — enforce IF/THEN rules ใน Dart
- `_filterResultFile()` — overwrite result file หลัง PICT รัน
- เรียกอัตโนมัติใน `writePictModelFiles()` เมื่อมี constraints

Log ที่จะเห็นเมื่อ filter ทำงาน:
```
[INFO] _filterResultFile: rewrote ...invalid.result.txt (43 → X rows)
```

### Git Lock Files

ถ้า commit ล้มเหลวด้วย `HEAD.lock` หรือ `index.lock` → ต้องลบจาก Mac โดยตรง:
```bash
rm -f .git/HEAD.lock .git/index.lock
```

---

## PICT Binary

- ไฟล์: `./pict` (project root)
- Platform: **macOS arm64** (Mach-O 64-bit)
- รัน relative path จาก project root เท่านั้น
- ถ้า PICT fail → log ไปที่ stderr แต่ไม่ throw — result file ไม่ถูกอัปเดต (ไฟล์เก่าถูกเก็บไว้)

---

## Web UI Constraint Workflow

⚠️ Constraint ไม่ได้อ่านจากไฟล์อัตโนมัติ — ต้อง **import ผ่าน UI ทุกครั้ง** ก่อน Generate Test Data:
1. เปิด Web UI → เช็ค "Use Constraints"
2. Import `.constraints.txt` file
3. กด Generate Test Data

---

## Git Convention

- Branch: `ieee_paper_v2`
- Commit format: `type : description` เช่น `fix :`, `feat :`, `docs :`, `refactor :`

---

## Original CLAUDE.md Notes (Legacy)

## Architecture

- **Main App**: `lib/main.dart` - Flutter app entry point with MultiBlocProvider setup
- __Demo UI__: `lib/demos/buttons_page.dart` - ButtonsDemo page with various widgets (TextFormField, DropdownButton, ElevatedButton)
- **State Management**: BLoC/Cubit pattern
   - `lib/cubit/buttons_cubit.dart` - Business logic with API simulation
   - `lib/cubit/buttons_state.dart` - State classes including ApiResponse and ButtonsException

- **Test Generation Tools**:
   - `tools/ir_action_lister.dart` - Extracts UI actions to IR JSON files
   - `tools/script_v2/generate_test_data.dart` - Generates test plans from IR files
   - `tools/script_v2/generate_test_script.dart` - Generates Flutter widget tests from test plans

## Key Development Commands

### Generate IR from UI

```sh
dart run tools/ir_action_lister.dart lib/demos/buttons_page.dart
```

Output: `test_ir/actions/buttons_page.ir.json`

### Generate Test Plans

```sh
# Pairwise-merge mode (reduced test cases)
dart run tools/script_v2/generate_test_data.dart --pairwise-merge test_ir/actions/buttons_page.ir.json

# Full-flow mode (complete test steps)
dart run tools/script_v2/generate_test_data.dart test_ir/actions/buttons_page.ir.json

# Plan summary (factor analysis)
dart run tools/script_v2/generate_test_data.dart --plan-summary test_ir/actions/buttons_page.ir.json
```

### Generate Flutter Tests

```sh
dart run tools/script_v2/generate_test_script.dart test_data/buttons_page.testdata.json
```

Output: `test/generated/buttons_page_flow_test.dart`

### Run Tests

```sh
flutter test test/generated/buttons_page_flow_test.dart
flutter test  # Run all tests
```

### Build and Lint

```sh
flutter build apk          # Build Android APK
flutter build web          # Build for web
flutter analyze            # Static analysis
dart format .               # Format code
```

## Test Plan Structure

Test plans are JSON files in `test_data/` containing:

- **Cases**: Test scenarios with success/failure variations
- **Steps**: UI interaction sequences
- **Asserts**: Expected outcomes using keys like:
   - `{"byKey": "<key>", "exists": true|false}`
   - `{"byKey": "<key>", "textEquals": "..."}`
   - `{"byKey": "<key>", "textContains": "..."}`
   - `{"text": "...", "exists": true|false}`

- **Setup**: API response simulation via `setup.response` JSON

## Key Directories

- `lib/` - Flutter application code
- `tools/` - Code generation scripts
- `test_ir/actions/` - UI action intermediate representation files
- `test_data/` - Generated test plan JSON files
- `test/generated/` - Generated Flutter widget test files

## Testing Architecture

The project uses a sophisticated test generation system:

1. UI components are analyzed to extract possible actions and states
2. Test plans combine these actions using pairwise or full-flow strategies
3. Generated tests use custom Cubit stubs to simulate API responses
4. Each test case can specify expected API responses in `setup.response`
5. Tests verify UI state through key-based assertions

## BLoC/Cubit Pattern

- `ButtonsCubit` manages form state (username, options, count) and API calls
- `shouldSucceed` parameter controls API simulation behavior
- Test generation creates `_SuccessButtonsCubit` variants for different scenarios
- API responses are modeled as `ApiResponse` with message/code fields
- Errors use `ButtonsException` with HTTP-like status codes