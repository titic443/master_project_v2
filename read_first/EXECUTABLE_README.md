# Flutter Test Generator - Standalone Executable

เครื่องมือสร้าง integration tests อัตโนมัติสำหรับ Flutter apps โดยไม่ต้องติดตั้ง Dart SDK

## 📦 การติดตั้ง

### วิธีที่ 1: ดาวน์โหลด Binary ที่ Compile แล้ว

1. ดาวน์โหลด binary สำหรับ platform ของคุณ:
   - **macOS (Intel)**: `flutter_test_gen-darwin-x86_64.tar.gz`
   - **macOS (Apple Silicon)**: `flutter_test_gen-darwin-arm64.tar.gz`
   - **Linux**: `flutter_test_gen-linux-x86_64.tar.gz`
   - **Windows**: `flutter_test_gen-windows-x86_64.zip`

2. แตกไฟล์:
   ```bash
   # macOS/Linux
   tar -xzf flutter_test_gen-*.tar.gz
   cd flutter_test_gen-*

   # Windows
   unzip flutter_test_gen-windows-x86_64.zip
   cd flutter_test_gen-windows-x86_64
   ```

3. (Optional) ย้ายไปยัง global path:
   ```bash
   # macOS/Linux
   sudo mv flutter_test_gen /usr/local/bin/

   # หรือเพิ่มใน PATH ของคุณ
   export PATH="$PATH:/path/to/flutter_test_gen"
   ```

### วิธีที่ 2: Build เอง

ต้องการ Dart SDK (Flutter) ติดตั้งอยู่:

```bash
# Clone repository
git clone <your-repo-url>
cd master_project_v2

# Build executable
./build_executable.sh

# Binary จะอยู่ใน bin/flutter_test_gen
```

## 🚀 การใช้งาน

### Quick Start

```bash
# แสดง help
./flutter_test_gen --help

# สร้าง tests แบบ interactive (แนะนำ)
./flutter_test_gen

# สร้าง tests จาก UI file
./flutter_test_gen lib/demos/customer_details_page.dart --skip-datasets

# พร้อม verbose output
./flutter_test_gen lib/demos/buttons_page.dart --skip-datasets --verbose
```

### วิธีการใช้งานใน Flutter Project อื่น

1. **Copy executable ไปยัง project:**
   ```bash
   # สร้าง tools folder ใน Flutter project
   mkdir -p /path/to/your-flutter-project/tools

   # Copy executable
   cp flutter_test_gen /path/to/your-flutter-project/tools/

   # ไปยัง project directory
   cd /path/to/your-flutter-project

   # รัน tool
   ./tools/flutter_test_gen lib/pages/your_page.dart --skip-datasets
   ```

2. **ใช้จาก global path (ถ้าติดตั้งแล้ว):**
   ```bash
   cd /path/to/your-flutter-project
   flutter_test_gen lib/pages/your_page.dart --skip-datasets
   ```

## 📋 Options ทั้งหมด

| Option | คำอธิบาย | Default |
|--------|----------|---------|
| `<UI_FILE>` | Path ไปยัง Flutter UI file | - |
| `--skip-datasets` | ข้าม AI dataset generation | `false` |
| `--verbose`, `-v` | แสดง detailed logs | `false` |
| `--api-key=<KEY>` | Gemini API key (สำหรับ AI generation) | อ่านจาก `.env` |
| `--pict-bin=<PATH>` | Path ไปยัง PICT binary | `./pict` |
| `--with-constraints` | เปิดใช้ PICT constraints | `false` |
| `--constraints-file=<PATH>` | Path ไปยัง constraints file | - |
| `--help`, `-h` | แสดง help message | - |

## 📝 ตัวอย่างการใช้งาน

### ตัวอย่าง 1: สร้าง Tests แบบพื้นฐาน

```bash
./flutter_test_gen lib/pages/login_page.dart --skip-datasets
```

**Output:**
- `output/manifest/pages/login_page.manifest.json` - UI widget manifest
- `output/test_data/login_page.testdata.json` - Test plan
- `integration_test/login_page_flow_test.dart` - Generated test file

### ตัวอย่าง 2: พร้อม AI Dataset Generation

ต้องมี Gemini API key (get from https://aistudio.google.com/app/apikey)

```bash
# สร้าง .env file
echo "GEMINI_API_KEY=your_api_key_here" > .env

# รัน tool
./flutter_test_gen lib/pages/registration_page.dart
```

### ตัวอย่าง 3: ใช้ Custom API Key

```bash
./flutter_test_gen lib/pages/profile_page.dart \
  --api-key=AIzaSyXXXXXXXXXXXXXXXXX
```

### ตัวอย่าง 4: พร้อม PICT Constraints

```bash
# สร้าง constraints file
cat > constraints.txt << 'EOF'
IF [Type] = "RAID-5" THEN [Compression] = "Off";
IF [Size] >= 500 THEN [Format method] = "Quick";
EOF

# รัน tool พร้อม constraints
./flutter_test_gen lib/pages/storage_config_page.dart \
  --skip-datasets \
  --constraints-file=constraints.txt
```

## 🎯 Widget Keys Convention

สำหรับผลลัพธ์ที่ดีที่สุด ใช้ naming pattern นี้สำหรับ widget keys:

```
<sequence>_<description>_<widget_type>
```

**ตัวอย่าง:**

```dart
TextFormField(
  key: const Key('1_username_textfield'),
  ...
)

ElevatedButton(
  key: const Key('2_submit_button'),
  ...
)

DropdownButton(
  key: const Key('3_country_dropdown'),
  ...
)
```

## 🔧 Widget ที่รองรับ

- ✅ **TextFormField** - พร้อม validation rules และ formatters
- ✅ **TextField** - basic text input
- ✅ **ElevatedButton** - action buttons
- ✅ **TextButton** - secondary buttons
- ✅ **DropdownButton** - select options
- ✅ **Radio** - radio button groups
- ✅ **Checkbox** - boolean toggles
- ✅ **Text** - display bindings (state.field)
- ✅ **DatePicker** - date selection dialog

## 📂 Output Structure

```
your-flutter-project/
├── lib/
│   └── pages/
│       └── customer_page.dart              # Input file
├── output/
│   ├── manifest/
│   │   └── pages/
│   │       └── customer_page.manifest.json # Step 1: Widget manifest
│   └── test_data/
│       ├── customer_page.datasets.json     # Step 2: AI datasets (optional)
│       └── customer_page.testdata.json     # Step 3: Test plan
└── integration_test/
    └── customer_page_flow_test.dart        # Step 4: Generated tests
```

## 🧪 รัน Generated Tests

```bash
# รัน specific test
flutter test integration_test/customer_page_flow_test.dart

# รัน all integration tests
flutter test integration_test/

# พร้อม verbose output
flutter test integration_test/customer_page_flow_test.dart -v
```

## 🔍 Pipeline Steps

Tool จะทำงาน 4 ขั้นตอนตามลำดับ:

1. **Extract UI Manifest** - วิเคราะห์ UI file เพื่อหา widgets, keys, validation rules
2. **Generate Datasets** (optional) - ใช้ AI สร้าง realistic test data
3. **Generate Test Plan** - สร้าง pairwise test combinations
4. **Generate Test Script** - สร้าง Flutter integration test code

## ⚙️ Advanced Features

### PICT Constraints

ใช้ constraints เพื่อควบคุม test combinations:

```bash
# Inline constraints
./flutter_test_gen lib/pages/config_page.dart \
  --constraints='IF [Type] = "Premium" THEN [Discount] <> "None";'

# จาก file
./flutter_test_gen lib/pages/config_page.dart \
  --constraints-file=my_constraints.txt
```

### Custom PICT Binary

ถ้ามี PICT binary ใน custom location:

```bash
./flutter_test_gen lib/pages/form_page.dart \
  --pict-bin=/usr/local/bin/pict
```

## 🐛 Troubleshooting

### Error: "File not found"
- ตรวจสอบว่า path ถูกต้อง (relative จาก project root)
- ตัวอย่าง: `lib/pages/login_page.dart` ไม่ใช่ `pages/login_page.dart`

### Error: "No widgets found"
- ตรวจสอบว่า widgets มี `key` parameter
- ใช้ `--verbose` เพื่อดู debug info
- ดู widget naming convention ข้างบน

### Error: "API key not found" (เมื่อไม่ใช้ --skip-datasets)
- สร้าง `.env` file: `GEMINI_API_KEY=your_key`
- หรือใช้ `--api-key=your_key`
- หรือข้ามด้วย `--skip-datasets`

### PICT binary not found
- Download PICT: https://github.com/microsoft/pict
- วางใน project root หรือระบุ path: `--pict-bin=/path/to/pict`
- Tool จะใช้ fallback algorithm ถ้าไม่มี PICT

## 📦 Distribution

### แชร์ Binary กับทีม

1. **Upload ไป GitHub Releases:**
   ```bash
   # Build distribution package
   ./build_executable.sh

   # Upload dist/*.tar.gz ไป GitHub Releases
   ```

2. **แชร์ผ่าน Network Share:**
   ```bash
   # Copy binary ไปยัง shared folder
   cp bin/flutter_test_gen /path/to/shared/folder/
   ```

3. **Package Management (Advanced):**
   ```bash
   # สร้าง Homebrew formula (macOS)
   # สร้าง apt package (Linux)
   # สร้าง Chocolatey package (Windows)
   ```

## 🔒 Security Notes

- Binary นี้ปลอดภัยและไม่มี network access (ยกเว้น Gemini API ถ้าใช้)
- Source code สามารถ verify ได้จาก repository
- Recommended: Build เองจาก source แทนการใช้ pre-built binary

## 📄 License

Part of master_project_v2 Flutter application.

## 🆘 Support

ถ้ามีปัญหาหรือคำถาม:
1. ดูที่ Troubleshooting section ข้างบน
2. รัน tool ด้วย `--verbose` flag
3. ตรวจสอบ output files ใน `output/` directory
4. เปิด issue ที่ repository

---

**Generated with ❤️ for Flutter Developers**
