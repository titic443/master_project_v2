# Flutter Test Generator — คู่มือติดตั้งและใช้งาน

เครื่องมือสร้างสคริปต์ทดสอบ Integration Test อัตโนมัติสำหรับ Flutter Application ที่ใช้ BLoC/Cubit pattern รองรับการทำงานบนระบบปฏิบัติการ Windows, macOS และ Linux โดยการติดตั้งสภาพแวดล้อมผ่าน Docker

---

## สิ่งที่ต้องมีก่อนติดตั้ง

| รายการ | เวอร์ชันที่รองรับ | ดาวน์โหลด |
|---|---|---|
| Docker Desktop | 20.10 ขึ้นไป | https://www.docker.com/products/docker-desktop |
| Flutter SDK | 3.5 ขึ้นไป | https://flutter.dev/docs/get-started/install |
| Gemini API Key | — | https://aistudio.google.com/app/apikey |

---

## โครงสร้างไฟล์ใน Package

```
flutter_test_gen_v1.0.0/
├── Dockerfile               ← ไฟล์สำหรับ build Docker image
├── docker-entrypoint.sh     ← script เริ่มต้นภายใน container
├── pubspec.yaml             ← dependencies ของเครื่องมือ
├── pubspec.lock
├── run_tool.sh              ← launcher script (copy ไปยัง Flutter project)
├── tools/
│   └── script_v2/           ← Dart scripts หลักของเครื่องมือ
├── webview/                 ← Web UI ของเครื่องมือ
└── INSTALL.md               ← ไฟล์นี้
```

---

## ขั้นตอนการติดตั้ง

### ขั้นตอนที่ 1 — แตก zip และ build Docker image (ทำครั้งเดียว)

```bash
# 1. แตก zip ไปยัง directory ที่ต้องการเก็บเครื่องมือ
unzip flutter_test_gen_v1.0.0.zip
cd flutter_test_gen_v1.0.0

# 2. Build Docker image (ใช้เวลาประมาณ 5-15 นาทีในครั้งแรก)
docker build -t flutter_test_gen .
```

> **หมายเหตุ:** Build ครั้งเดียวบนเครื่องนั้น ๆ สามารถใช้ได้กับทุก Flutter project บนเครื่องเดียวกัน

---

### ขั้นตอนที่ 2 — เตรียม Flutter project เป้าหมาย

เพิ่ม dev dependencies ใน `pubspec.yaml` ของ Flutter project ที่ต้องการสร้าง test:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  analyzer: ^7.0.0
  path: ^1.9.0
```

จากนั้นรัน:

```bash
flutter pub get
```

---

### ขั้นตอนที่ 3 — สร้าง `.env` ใน Flutter project เป้าหมาย

```bash
cd /path/to/your_flutter_project
echo "GEMINI_API_KEY=your_api_key_here" > .env
```

> ขอ API key ฟรีได้ที่ https://aistudio.google.com/app/apikey

---

### ขั้นตอนที่ 4 — รันเครื่องมือ

**วิธี A: รันด้วยคำสั่ง Docker โดยตรง (แนะนำ)**

```bash
cd /path/to/your_flutter_project
docker run -it --rm -p 8080:8080 -v $(pwd):/workspace flutter_test_gen
```

**วิธี B: ใช้ run_tool.sh (สะดวกกว่า)**

Copy `run_tool.sh` จาก package ไปวางที่ root ของ Flutter project แล้วแก้ไข `SCRIPT_DIR` ให้ชี้มายัง directory ของ package นี้:

```bash
# แก้ไขใน run_tool.sh บรรทัดนี้:
# SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# เป็น:
# SCRIPT_DIR="/path/to/flutter_test_gen_v1.0.0"

# จากนั้น copy ไปยัง Flutter project และรัน
cp run_tool.sh /path/to/your_flutter_project/
cd /path/to/your_flutter_project
chmod +x run_tool.sh
./run_tool.sh
```

---

### ขั้นตอนที่ 5 — ใช้งานผ่าน Browser

เปิด browser ไปที่ **http://localhost:8080**

---

## ขั้นตอนการสร้าง Integration Test (ภายใน Browser)

เครื่องมือจะวิเคราะห์ UI และสร้าง test script ผ่าน 4 ขั้นตอน:

```
[1] Extract UI Manifest   →  วิเคราะห์ widget จาก .dart file
[2] Generate Datasets     →  สร้างข้อมูลทดสอบด้วย AI (Gemini)
[3] Generate Test Plan    →  สร้าง test plan แบบ pairwise (PICT)
[4] Generate Test Script  →  สร้าง integration_test/*.dart
```

**Output ที่ได้:**

```
your_flutter_project/
├── output/
│   ├── manifest/               ← UI manifest JSON
│   └── test_data/              ← test datasets + test plans
└── integration_test/
    └── your_page_flow_test.dart ← test script พร้อมรัน
```

---

## การรัน Test Script

```bash
# รัน test เฉพาะไฟล์
flutter test integration_test/your_page_flow_test.dart

# รัน test ทั้งหมด
flutter test integration_test/
```

---

## ข้อกำหนดของ Flutter Project

Widget ใน Flutter page ต้องมี `Key(...)` กำกับทุกตัว โดยใช้รูปแบบ:

```
<ลำดับ>_<ชื่อ>_<ประเภท widget>
```

ตัวอย่าง:

```dart
TextFormField(
  key: const Key('01_name_textfield'),
  ...
)
DropdownButtonFormField(
  key: const Key('02_type_dropdown'),
  ...
)
ElevatedButton(
  key: const Key('03_submit_button'),
  ...
)
```

---

## การหยุดการทำงาน

```bash
# กด Ctrl+C ใน terminal ที่รัน docker
# หรือ
docker stop flutter_test_gen_server
```

---

## แก้ไขปัญหาเบื้องต้น

| ปัญหา | วิธีแก้ไข |
|---|---|
| `docker: command not found` | ติดตั้ง Docker Desktop ก่อน |
| Port 8080 ถูกใช้งานอยู่ | เปลี่ยน `-p 8080:8080` เป็น `-p 9090:8080` แล้วเปิด http://localhost:9090 |
| API key ไม่ถูกต้อง | ตรวจสอบไฟล์ `.env` และค่า `GEMINI_API_KEY` |
| ไม่พบ widget | ตรวจสอบว่า widget มี `Key(...)` ครบทุกตัว |
| Build image ช้า | ปกติในครั้งแรก ครั้งต่อไปจะเร็วกว่าเนื่องจาก Docker cache |
