# Flutter Test Generator v1.0.0

เครื่องมือสร้าง **Integration Test อัตโนมัติ** สำหรับ Flutter Application ที่ใช้ BLoC/Cubit pattern โดยใช้เทคนิค **Pairwise Combinatorial Testing (PICT)**

---

## สิ่งที่ต้องมีก่อนใช้งาน

| รายการ | เวอร์ชัน |
|---|---|
| Docker Desktop | 20.10 ขึ้นไป |
| Flutter SDK | 3.5 ขึ้นไป |
| Dart SDK | 3.5 ขึ้นไป |
| Gemini API Key | ขอฟรีได้ที่ [Google AI Studio](https://aistudio.google.com/app/apikey) |

> **ระบบปฏิบัติการที่รองรับ:** macOS (Apple Silicon / Intel) · Windows · Linux

---

## วิธีติดตั้งและใช้งาน

### ขั้นตอนที่ 1 — แตก zip และรันเครื่องมือ

```bash
unzip flutter_test_gen_v1.0.0.zip
cd flutter_test_gen_v1.0.0
./run_tool.sh /path/to/your_flutter_project
```

> `run_tool.sh` จะ build Docker image อัตโนมัติในครั้งแรก (ใช้เวลา 5–15 นาที) และเปิด browser ที่ http://localhost:8080

หากต้องการ build image ก่อน:
```bash
./run_tool.sh --build /path/to/your_flutter_project
```

หยุดการทำงาน:
```bash
./run_tool.sh --stop
```

---

### ขั้นตอนที่ 2 — เตรียม Flutter Project

เพิ่ม dev dependencies ใน `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  analyzer: ^7.0.0
  path: ^1.9.0
```

สร้างไฟล์ `.env` ที่ root ของ Flutter project:

```bash
echo "GEMINI_API_KEY=your_api_key_here" > .env
```

Widget ทุกตัวในหน้าที่ต้องการ scan ต้องมี `Key(...)` กำกับ:

```dart
TextFormField(key: const Key('01_name_textfield'), ...)
DropdownButtonFormField(key: const Key('02_type_dropdown'), ...)
ElevatedButton(key: const Key('03_submit_button'), ...)
```

---

### ขั้นตอนที่ 3 — สร้าง Integration Test ผ่าน Web UI

เปิด **http://localhost:8080** แล้วทำตาม 4 ขั้นตอน:

```
[1] Scan UI        →  วิเคราะห์ widget จาก .dart file ที่เลือก
[2] Gen Datasets   →  สร้างข้อมูลทดสอบด้วย AI (Gemini)
[3] Gen Test Data  →  สร้าง test plan แบบ pairwise ด้วย PICT
[4] Gen Test Script →  สร้าง integration_test/*.dart พร้อมรัน
```

**Output ที่ได้:**

```
your_flutter_project/
├── output/
│   ├── manifest/demos/          ← UI manifest JSON
│   ├── model_pairwise/          ← PICT model + result combinations
│   └── test_data/               ← datasets + test plan JSON
└── integration_test/
    └── your_page_flow_test.dart ← Integration test script
```

---

### ขั้นตอนที่ 4 — รัน Integration Test

```bash
# รัน test เฉพาะไฟล์ (บน emulator/device)
flutter test integration_test/your_page_flow_test.dart -d <device_id>

# รันพร้อม coverage
flutter test integration_test/your_page_flow_test.dart --coverage
```

> รันผ่าน Web UI ได้เลยโดยกดปุ่ม **Run Tests** — เครื่องมือจะหา device อัตโนมัติ

---

## โครงสร้างไฟล์ใน Package

```
flutter_test_gen_v1.0.0/
├── Dockerfile               ← build Docker image
├── docker-entrypoint.sh     ← entrypoint ภายใน container
├── run_tool.sh              ← launcher script
├── pubspec.yaml / pubspec.lock
├── tools/script_v2/         ← Dart pipeline scripts
│   ├── extract_ui_manifest.dart
│   ├── generate_datasets.dart
│   ├── generate_test_data.dart
│   └── generate_test_script.dart
├── webview/                 ← Web UI
│   ├── server.dart          ← HTTP server (port 8080)
│   ├── host_runner.dart     ← ตัวรับ flutter test requests (port 8089)
│   ├── coverage_runner.dart
│   ├── index.html / main.js / styles.css
└── INSTALL.md
```

---
