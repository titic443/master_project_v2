# Flutter Test Generator — คู่มือติดตั้งและใช้งาน

เครื่องมือสร้าง Integration Test อัตโนมัติสำหรับ Flutter (BLoC/Cubit) ผ่าน Docker

---

## สิ่งที่ต้องมี

| รายการ | เวอร์ชัน | ดาวน์โหลด |
|---|---|---|
| Docker Desktop | 20.10+ | https://www.docker.com/products/docker-desktop |
| Flutter SDK | 3.5+ | https://flutter.dev/docs/get-started/install |
| Gemini API Key | — | https://aistudio.google.com/app/apikey |

---

## ติดตั้ง (ทำครั้งเดียว)

```bash
unzip flutter_test_gen_v1.0.0.zip
cd flutter_test_gen_v1.0.0
docker build -t flutter_test_gen .
```

---

## เตรียม Flutter Project เป้าหมาย

เพิ่มใน `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  analyzer: ^7.0.0
  path: ^1.9.0
```

```bash
flutter pub get
```

Widget ทุกตัวต้องมี `Key(...)` ในรูปแบบ `<ลำดับ>_<ชื่อ>_<ประเภท>` เช่น:

```dart
TextFormField(key: const Key('01_name_textfield'), ...)
DropdownButtonFormField(key: const Key('02_type_dropdown'), ...)
ElevatedButton(key: const Key('03_submit_button'), ...)
```

---

## รันเครื่องมือ

```bash
cd flutter_test_gen_v1.0.0
./run_tool.sh --build /path/to/your_flutter_project --api-key=YOUR_GEMINI_API_KEY
```

จากนั้นเปิด **http://localhost:8080**

---

## ขั้นตอนใน Browser

```
[1] Extract UI Manifest   →  วิเคราะห์ widget จาก .dart file
[2] Generate Datasets     →  สร้างข้อมูลทดสอบด้วย AI (Gemini)
[3] Generate Test Plan    →  สร้าง test plan แบบ pairwise (PICT)
[4] Generate Test Script  →  สร้าง integration_test/*.dart
```

---

## รัน Test

```bash
flutter test integration_test/your_page_flow_test.dart
```

---

## แก้ปัญหาเบื้องต้น

| ปัญหา | วิธีแก้ |
|---|---|
| `docker: command not found` | ติดตั้ง Docker Desktop ก่อน |
| Port 8080 ถูกใช้งาน | เพิ่ม `--port 9090` แล้วเปิด http://localhost:9090 |
| API key ไม่ถูกต้อง | ตรวจสอบ `--api-key` หรือไฟล์ `.env` |
| ไม่พบ widget | ตรวจสอบว่า widget มี `Key(...)` ครบ |
