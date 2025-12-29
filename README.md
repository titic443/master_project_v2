# Flutter Automated Integration Test Generator

ระบบสร้าง Integration Tests อัตโนมัติสำหรับ Flutter Apps ที่ใช้ BLoC/Cubit pattern ผ่านการวิเคราะห์ UI และสร้าง Test Plans แบบ Pairwise Testing

## ภาพรวมระบบ

```ini
UI Component → IR Analysis → Test Plans → Integration Tests → Coverage Reports
```

## โครงสร้างหลัก

### แอปพลิเคชัน

- **Main App**: `lib/main.dart` - Flutter app entry point
- __Demo UI__: `lib/demos/customer_details_register_page.dart` - RegisterPage with various widgets
- __State Management__: `lib/cubit/register_cubit.dart`, `lib/cubit/register_state.dart`

### เครื่องมือสร้าง Tests

- __UI Analysis__: `tools/script_v2/extract_ui_manifest.dart` - สกัด UI interactions
- __Dataset Generation__: `tools/script_v2/generate_datasets.dart` - สร้าง test datasets
- __Test Planning__: `tools/script_v2/generate_test_data.dart` - สร้าง test plans แบบ pairwise
- __Test Generation__: `tools/script_v2/generate_test_script.dart` - สร้าง integration tests

```ini

```

### ข้อมูล Output

```ini
output/
├── manifest/           # UI interaction manifests
├── test_data/          # Test datasets & plans
└── model_pairwise/     # PICT pairwise models
```

- __UI Manifests__: `output/manifest/**/*.manifest.json`
- __Test Datasets__: `output/test_data/*.datasets.json`
- __Test Plans__: `output/test_data/*.testdata.json`
- __Integration Tests__: `integration_test/*_flow_test.dart`

## Quick Start

### วิธีใช้งาน 2 แบบ

ระบบรองรับการทำงาน 2 รูปแบบ:

| Mode | คำสั่ง | ใช้เมื่อ |
|------|--------|----------|
| __Specific File__ | `dart run <script> <file_path>` | ต้องการ process ไฟล์เฉพาะ (เร็วกว่า) |
| __All Files__ | `dart run <script>` | ต้องการ process ทุกไฟล์ในโปรเจค |

### Quick Reference: Commands Summary

| Step | Specific File | All Files |
|------|--------------|-----------|
| 1. Extract Manifest | `dart run tools/script_v2/extract_ui_manifest.dart lib/demos/customer_details_page.dart` | `dart run tools/script_v2/extract_ui_manifest.dart` |
| 2. Generate Datasets | `dart run tools/script_v2/generate_datasets.dart output/manifest/demos/customer_details_page.manifest.json` | `dart run tools/script_v2/generate_datasets.dart` |
| 3. Generate Test Plan | `dart run tools/script_v2/generate_test_data.dart output/manifest/demos/customer_details_page.manifest.json` | `dart run tools/script_v2/generate_test_data.dart` |
| 4. Generate Tests | `dart run tools/script_v2/generate_test_script.dart output/test_data/customer_details_page.testdata.json` | `dart run tools/script_v2/generate_test_script.dart` |
| 5. Run Tests | `flutter test integration_test/page_flow_test.dart` | `flutter test integration_test/` |

---

### 1. สร้าง UI Interaction Manifest

#### Run Specific File

```sh
dart run tools/script_v2/extract_ui_manifest.dart lib/demos/customer_details_register_page.dart
```

Output: `output/manifest/demos/customer_details_register_page.manifest.json`

#### Run All Project Files

```sh
# Scan และสร้าง manifest สำหรับทุกไฟล์ใน lib/
dart run tools/script_v2/extract_ui_manifest.dart
```

---

### 2. สร้าง Test Datasets (AI-powered)

**⚠️ Required**: ตั้งค่า API Key ใน `.env` file ก่อน

```sh
echo "GEMINI_API_KEY=" > .env
```

#### Run Specific File

```sh
dart run tools/script_v2/generate_datasets.dart output/manifest/demos/customer_details_register_page.manifest.json
```

Output: `output/test_data/register_page.datasets.json`

#### Run All Manifest Files

```sh
# สร้าง datasets สำหรับทุกไฟล์ใน output/manifest/ folder
dart run tools/script_v2/generate_datasets.dart
```

---

### 3. สร้าง Test Plan (Pairwise)

#### Run Specific File

```sh
dart run tools/script_v2/generate_test_data.dart output/manifest/demos/customer_details_register_page.manifest.json
```

Output: `output/test_data/register_page.testdata.json`

#### Run All Manifest Files

```sh
# สร้าง test plans สำหรับทุกไฟล์ใน output/manifest/ folder
dart run tools/script_v2/generate_test_data.dart
```

---

### 4. สร้าง Integration Tests

#### Run Specific File

```sh
dart run tools/script_v2/generate_test_script.dart output/test_data/register_page.testdata.json
```

Output: `integration_test/register_page_flow_test.dart`

#### Run All Test Data Files

```sh
# สร้าง integration tests สำหรับทุกไฟล์ใน output/test_data/
dart run tools/script_v2/generate_test_script.dart
```

---

### 5. รัน Integration Tests

#### Run All Integration Tests

```sh
flutter test integration_test/
```

#### Run Specific Test File

```sh
flutter test integration_test/register_page_flow_test.dart
```

#### Run on Specific Device

```sh
# ดูรายการอุปกรณ์
flutter devices

# รันบนอุปกรณ์เฉพาะ
flutter test integration_test/ -d <device-id>
```

## Test Coverage

### รันเทสต์พร้อม Coverage

```sh
# Integration tests พร้อม coverage
flutter test integration_test/ --coverage

# สร้าง HTML coverage report
brew install lcov  # ติดตั้ง lcov ก่อน
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### ดู Coverage แบบ CLI

```sh
# Coverage summary
flutter test --coverage && lcov --summary coverage/lcov.info

# Coverage ต่อไฟล์
flutter test --coverage && lcov --list coverage/lcov.info

# กรองเฉพาะ lib/
flutter test --coverage && lcov --list coverage/lcov.info | grep "lib/"
```

## Test Plan Structure

Test plans เป็นไฟล์ JSON ที่มี:

- **Cases**: Test scenarios พร้อม success/failure variations
- **Steps**: UI interaction sequences
- **Asserts**: Expected outcomes
- **Setup**: API response simulation

### Assertion Types

```json
{
  "byKey": "<key>", "exists": true|false,
  "byKey": "<key>", "textEquals": "...",
  "byKey": "<key>", "textContains": "...",
  "text": "...", "exists": true|false
}
```

### API Response Setup

```json
{
  "setup": {
    "response": { "message": "ok", "code": 200 }
  }
}
```

## Dataset System

Datasets ใช้สำหรับ populate ค่าต่างๆ ใน test cases:

- __valid_usernames__: `["user1", "testuser", "admin"]`
- __valid_emails__: `["test@example.com", "user@test.org"]`
- __invalid_passwords__: `["", "123"]`
- __dropdown_options__: `["option1", "option2", "option3"]`

### Dataset Resolution

ใช้ path notation: `"datasets.valid_usernames[0]"` → `"user1"`

## Architecture Overview

### Core Components

- __UI Components__: `lib/demos/customer_details_register_page.dart`
- **State Management**: `lib/cubit/` (BLoC/Cubit pattern)
- __Test Tools__: `tools/script_v2/`
- __Generated Tests__: `integration_test/`

### BLoC/Cubit Pattern

- `RegisterCubit` manages form state and API calls
- `RegisterState` contains response/exception fields
- Integration tests use real BlocProviders with backend calls

## Complete Workflow Examples

### Workflow 1: Process Specific File (register_page.dart)

```sh
#!/bin/bash
set -euo pipefail

# ตั้งค่า API Key (ครั้งเดียว)
echo "GEMINI_API_KEY=your_api_key_here" > .env

# 1. Extract UI interactions
dart run tools/script_v2/extract_ui_manifest.dart lib/demos/customer_details_register_page.dart

# 2. Generate test datasets (AI-powered)
dart run tools/script_v2/generate_datasets.dart output/manifest/demos/customer_details_register_page.manifest.json

# 3. Generate test plan (pairwise testing)
dart run tools/script_v2/generate_test_data.dart output/manifest/demos/customer_details_register_page.manifest.json

# 4. Generate integration tests
dart run tools/script_v2/generate_test_script.dart output/test_data/register_page.testdata.json

# 5. Run specific test
flutter test integration_test/register_page_flow_test.dart

# 6. Run with coverage
flutter test integration_test/register_page_flow_test.dart --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Workflow 2: Process All Project Files

```sh
#!/bin/bash
set -euo pipefail

# ตั้งค่า API Key (ครั้งเดียว)
echo "GEMINI_API_KEY=your_api_key_here" > .env

# 1. Extract UI interactions (all files in lib/)
dart run tools/script_v2/extract_ui_manifest.dart

# 2. Generate test datasets for all manifests
dart run tools/script_v2/generate_datasets.dart

# 3. Generate test plans for all manifests
dart run tools/script_v2/generate_test_data.dart

# 4. Generate integration tests for all test plans
dart run tools/script_v2/generate_test_script.dart

# 5. Run all tests with coverage
flutter test integration_test/ --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Backend API (Python FastAPI)

```sh

```

```sh
# Setup virtual environment
python3 -m venv .venv && source .venv/bin/activate
pip install -r backend/requirements.txt

# Run server
uvicorn backend.main:app --reload --port 8000
```

### API Endpoints

- `GET /health` → `{"status": "ok"}`
- `POST /api/demo/register` → `{"message": "ok|bad_request|server_error", "code": 200|400|500}`

### Test API

```sh
curl http://localhost:8000/health
curl -X POST http://localhost:8000/api/demo/register \
  -H 'Content-Type: application/json' \
  -d '{"username":"user123","password":"Pass1234","email":"test@example.com","option":"approve"}'
```

## Advanced Features

### PICT Integration

Pairwise testing ใช้ `./pict` tool สำหรับ combinatorial testing:

- Input model files: `output/model_pairwise/<page>.model.txt`, `output/model_pairwise/<page>.valid.model.txt`
- PICT result files: `output/model_pairwise/<page>.result.txt`, `output/model_pairwise/<page>.valid.result.txt`

### Inspection Commands

```sh
# Count test cases
jq '.cases | length' output/test_data/register_page.testdata.json

# List test case IDs
jq '.cases[].id' output/test_data/register_page.testdata.json

# Show pairwise cases
jq '.cases[] | select(.id | startswith("pairwise"))' output/test_data/register_page.testdata.json
```

## Key Development Commands

### Extract UI Manifest

#### Specific File

```sh
dart run tools/script_v2/extract_ui_manifest.dart lib/demos/customer_details_register_page.dart
```

Output: `output/manifest/demos/customer_details_register_page.manifest.json`

#### All Files

```sh
dart run tools/script_v2/extract_ui_manifest.dart
```

---

### Generate Test Datasets (AI)

#### Specific File

```sh
dart run tools/script_v2/generate_datasets.dart output/manifest/demos/customer_details_register_page.manifest.json
```

#### All Files

```sh
dart run tools/script_v2/generate_datasets.dart
```

---

### Generate Test Plans (Pairwise)

#### Specific File

```sh
dart run tools/script_v2/generate_test_data.dart output/manifest/login/login_page.manifest.json
```

#### All Files

```sh
dart run tools/script_v2/generate_test_data.dart
```

---

### Generate Integration Tests

#### Specific File

```sh
dart run tools/script_v2/generate_test_script.dart output/test_data/register_page.testdata.json
```

#### All Files

```sh
dart run tools/script_v2/generate_test_script.dart
```

### Build and Lint

```sh
flutter build apk          # Build Android APK
flutter build web          # Build for web
flutter analyze            # Static analysis
dart format .               # Format code
```

## Troubleshooting

### Common Issues

- __Missing Manifest__: ต้องมี `*.manifest.json` ใน `output/manifest/` folder
- **Key Not Found**: ตรวจสอบ `Key('...')` ใน UI ให้ตรงกับ test plan
- **PICT Binary**: ต้องมี `./pict` binary ที่ project root (download จาก https://github.com/microsoft/pict)
- __API Key__: ต้องตั้งค่า `GEMINI_API_KEY` ใน `.env` file สำหรับ AI dataset generation

### Testing Strategy

- **Validation Tests**: ทดสอบ form validation และ error messages
- **API Response Tests**: ทดสอบ backend integration
- **Pairwise Tests**: ทดสอบ combinatorial input scenarios
- **Edge Case Tests**: ทดสอบ boundary conditions

---

**Need help?** สร้าง issue ที่ https://github.com/anthropics/claude-code/issues
