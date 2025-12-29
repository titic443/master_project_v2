# Flutter Test Generator - Interactive Mode Guide

## ภาพรวม

Flutter Test Generator ตอนนี้รองรับ **Interactive Mode** ที่ช่วยให้การสร้าง test ง่ายขึ้นเหมือนกับการใช้ `npm init`

## วิธีใช้งาน

### 1. Interactive Mode (แนะนำ)

รันโดยไม่ใส่ parameter:

```bash
dart run tools/flutter_test_generator.dart
```

จะแสดง wizard แบบนี้:

```
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║         Flutter Test Generator - Interactive Mode         ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝

This wizard will walk you through test generation setup.
Press ^C at any time to quit.

? UI file to process (e.g., lib/demos/buttons_page.dart): lib/demos/buttons_page.dart
? Skip AI dataset generation? (y/N): n
? Use PICT constraints? (y/N): y
? Load constraints from:
  ❯ 1. file
    2. manual input
  Select (1-2) [1]: 1
? Constraints file path (output/model_pairwise/buttons_page.constraints.txt):
  ⚠ Warning: File does not exist yet: output/model_pairwise/buttons_page.constraints.txt
  You can create it before running the pipeline.
? Enable verbose logging? (y/N): n

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Configuration Summary:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  UI file:        lib/demos/buttons_page.dart
  Skip datasets:  false
  Use constraints: true
  Constraints:    output/model_pairwise/buttons_page.constraints.txt
  Verbose:        false
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

? Proceed with this configuration? (Y/n): y
```

### 2. CLI Mode (สำหรับ Automation)

ใช้ command-line arguments แบบเดิม:

```bash
# Basic usage
dart run tools/flutter_test_generator.dart lib/demos/buttons_page.dart

# With constraints from file
dart run tools/flutter_test_generator.dart lib/demos/buttons_page.dart \
  --constraints-file=output/model_pairwise/buttons_page.constraints.txt

# With inline constraints
dart run tools/flutter_test_generator.dart lib/demos/buttons_page.dart \
  --constraints='IF [Type] = "RAID-5" THEN [Compression] = "Off";'

# Skip datasets + verbose
dart run tools/flutter_test_generator.dart lib/demos/buttons_page.dart \
  --skip-datasets --verbose
```

## PICT Constraints

### ตัวอย่าง Constraints File

สร้างไฟล์ `output/model_pairwise/buttons_page.constraints.txt`:

```
IF [Type] = "RAID-5" THEN [Compression] = "Off";
IF [Size] >= 500 THEN [Format method] = "Quick";
```

### Constraint Syntax (PICT)

```
# เงื่อนไข IF-THEN
IF [Factor1] = "value" THEN [Factor2] = "value";

# เงื่อนไขหลายตัว (AND)
IF [Factor1] = "value" AND [Factor2] = "value" THEN [Factor3] = "value";

# เงื่อนไขเลือก (OR)
IF [Factor1] = "value" OR [Factor2] = "value" THEN [Factor3] = "value";

# เงื่อนไขปฏิเสธ (NOT)
IF [Factor1] <> "value" THEN [Factor2] = "value";

# เงื่อนไขเปรียบเทียบ
IF [Size] >= 500 THEN [Method] = "Quick";
IF [Size] < 100 THEN [Method] = "Slow";

# เงื่อนไข ELSE
IF [Type] = "RAID-5" THEN [Compression] = "Off" ELSE [Compression] = "On";
```

### ตัวอย่างการใช้งานจริง

สมมติคุณมี UI form ที่มี factors เหล่านี้:

```
customer_01_firstname_textfield: valid, invalid
customer_02_age_radio_group: age_10_20_radio, age_21_30_radio, age_31_40_radio
customer_03_title_dropdown: "Mr.", "Mrs.", "Ms."
```

สร้าง constraints:

```
# ถ้า age < 21 ต้องเลือก title = "Ms." หรือ "Mr." (ไม่ใช่ "Mrs.")
IF [customer_02_age_radio_group] = "age_10_20_radio" THEN [customer_03_title_dropdown] <> "Mrs.";

# ถ้า firstname invalid ต้องไม่สามารถเลือก age ได้
IF [customer_01_firstname_textfield] = "invalid" THEN [customer_02_age_radio_group] = "age_10_20_radio";
```

## CLI Options ทั้งหมด

```
Options:
  --skip-datasets             Skip AI-powered dataset generation
  --verbose, -v               Show detailed logs
  --api-key=<KEY>             Gemini API key (overrides .env)
  --pict-bin=<PATH>           Path to PICT binary (default: ./pict)
  --with-constraints          Enable PICT constraints (auto-detect file)
  --constraints-file=<PATH>   Path to constraints file
  --constraints=<CONTENT>     Inline constraints (semicolon-separated)
  --help, -h                  Show help message
```

## Workflow

```
┌─────────────────────────┐
│ 1. Extract UI Manifest  │  (อ่าน Dart file)
└──────────┬──────────────┘
           │
           ▼
┌─────────────────────────┐
│ 2. Generate Datasets    │  (AI สร้าง test data - optional)
└──────────┬──────────────┘
           │
           ▼
┌─────────────────────────┐
│ 3. Generate Test Plan   │  (PICT + Constraints)
└──────────┬──────────────┘
           │
           ▼
┌─────────────────────────┐
│ 4. Generate Test Script │  (สร้าง Flutter test file)
└─────────────────────────┘
```

## ตัวอย่างผลลัพธ์

ไฟล์ที่สร้างขึ้น:

```
output/
├── manifest/
│   └── buttons_page.manifest.json
├── model_pairwise/
│   ├── buttons_page.full.model.txt        (PICT model พร้อม constraints)
│   ├── buttons_page.full.result.txt       (PICT results)
│   ├── buttons_page.valid.model.txt       (Valid-only model)
│   ├── buttons_page.valid.result.txt      (Valid-only results)
│   └── buttons_page.constraints.txt       (ไฟล์ของคุณ - optional)
├── test_data/
│   ├── buttons_page.datasets.json         (AI-generated datasets)
│   └── buttons_page.testdata.json         (Test plan)
└── test/
    └── generated/
        └── buttons_page_flow_test.dart    (Flutter test file)
```

## Tips

1. **ใช้ Interactive Mode** สำหรับการทดลองและ development
2. **ใช้ CLI Mode** สำหรับ CI/CD pipelines
3. **เก็บ constraints file** ไว้ใน version control สำหรับความยืดหยุ่น
4. **ทดสอบ constraints** โดยดูที่ `.full.result.txt` ว่า combinations ถูกต้องหรือไม่

## ข้อจำกัด

- Constraints ใช้ได้เฉพาะเมื่อมี PICT binary
- Factor names ต้องตรงกับชื่อที่ใช้ใน PICT model (ดูที่ `.full.model.txt`)
- PICT syntax ต้องถูกต้อง มิฉะนั้น PICT จะ error

## ตัวอย่างการใช้งานจริง

### ตัวอย่างที่ 1: Form Registration ที่มีกฎ Business Logic

```
# ไฟล์: output/model_pairwise/register_page.constraints.txt

# อายุต่ำกว่า 18 ต้องไม่สามารถลงทะเบียนได้
IF [age_radio] = "age_under_18" THEN [can_register] = "no";

# ถ้าเลือกประเภทบัญชี "Premium" ต้องมีอายุมากกว่า 21
IF [account_type] = "premium" THEN [age_radio] <> "age_under_18";
IF [account_type] = "premium" THEN [age_radio] <> "age_18_21";
```

### ตัวอย่างที่ 2: E-commerce Shipping Options

```
# ไฟล์: output/model_pairwise/checkout_page.constraints.txt

# ถ้าสินค้าหนักเกิน 10kg ไม่สามารถใช้ Express Delivery
IF [weight] = "heavy" THEN [shipping_method] <> "express";

# ถ้าส่งต่างประเทศ ต้องใช้ International Shipping
IF [destination] = "international" THEN [shipping_method] = "international";
```
