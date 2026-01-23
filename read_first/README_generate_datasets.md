# generate_datasets.dart

## ภาพรวม
Script สำหรับสร้าง test datasets โดยใช้ Google Gemini AI เพื่อสร้างข้อมูลทดสอบที่สมจริง (realistic test data) สำหรับ form fields ทั้งข้อมูลที่ถูกต้อง (valid) และไม่ถูกต้อง (invalid) ตาม validation rules

## การทำงาน
1. อ่านไฟล์ manifest JSON จาก `output/manifest/`
2. วิเคราะห์ TextField/TextFormField และ validation rules
3. แบ่ง fields เป็น 2 กลุ่ม:
   - **Fields with validation rules** → ใช้ AI สร้างข้อมูล
   - **Fields without validation rules** → สร้างข้อมูลแบบ local
4. เรียก Gemini API เพื่อสร้าง valid/invalid test data pairs
5. บันทึกผลลัพธ์เป็น JSON ใน `output/test_data/`

## วิธีใช้งาน

### ประมวลผลไฟล์เดียว
```bash
dart run tools/script_v2/generate_datasets.dart output/manifest/demos/register_page.manifest.json
```

### ประมวลผลทุกไฟล์ manifest
```bash
dart run tools/script_v2/generate_datasets.dart
```

### กำหนด AI model และ API key
```bash
dart run tools/script_v2/generate_datasets.dart --model=gemini-2.5-flash --api-key=YOUR_API_KEY
```

## การตั้งค่า API Key

มี 3 วิธีในการกำหนด GEMINI_API_KEY:

### 1. ไฟล์ .env (แนะนำ)
สร้างไฟล์ `.env` ที่ root ของ project:
```
GEMINI_API_KEY=your_api_key_here
```

### 2. Environment Variable
```bash
export GEMINI_API_KEY=your_api_key_here
dart run tools/script_v2/generate_datasets.dart
```

### 3. Command Line Flag
```bash
dart run tools/script_v2/generate_datasets.dart --api-key=your_api_key_here
```

## รับ API Key
1. ไปที่ https://aistudio.google.com/app/apikey
2. สร้าง API key ใหม่
3. คัดลอก key มาใช้งาน

## Input
- Manifest JSON files จาก `output/manifest/**/*.manifest.json`
- ต้องมี TextFormField/TextField widgets พร้อม validation rules

## Output
- ไฟล์ datasets JSON ใน `output/test_data/<page_name>.datasets.json`

## โครงสร้าง Output JSON

```json
{
  "file": "lib/demos/register_page.dart",
  "datasets": {
    "byKey": {
      "firstname_textfield": [
        {
          "valid": "Alice",
          "invalid": "J",
          "invalidRuleMessages": "Min 2 characters"
        },
        {
          "valid": "Robert",
          "invalid": "A1",
          "invalidRuleMessages": "Only alphabets allowed"
        }
      ],
      "email_textfield": [
        {
          "valid": "user@example.com",
          "invalid": "invalid.email",
          "invalidRuleMessages": "Invalid email format"
        }
      ],
      "age_textfield": [
        {
          "valid": "25",
          "invalid": "",
          "invalidRuleMessages": "Required"
        }
      ]
    }
  }
}
```

## กลยุทธ์การสร้างข้อมูล

### Fields with Validation Rules (ใช้ AI)
- Gemini AI วิเคราะห์ validation rules
- สร้าง valid/invalid pairs สำหรับแต่ละ rule (ยกเว้น isEmpty/null rules)
- Invalid data ต้องผ่าน inputFormatters แต่ไม่ผ่าน validators
- จำนวน pairs = จำนวน non-empty rules

ตัวอย่าง:
```
Rules:
1. isEmpty → SKIP (tested separately)
2. RegExp(r'^[a-zA-Z]{2,}$') → สร้าง 1 pair

Output: 1 valid + 1 invalid
```

### Fields without Validation Rules (Local Generation)
- สร้าง 1 valid value เท่านั้น
- ไม่สร้าง invalid values
- ใช้ constraints จาก inputFormatters และ maxLength

## AI Prompt Strategy

Gemini ได้รับ instructions:
1. วิเคราะห์ constraints (maxLength, inputFormatters, validatorRules)
2. กรอง isEmpty/null rules ออก
3. สร้าง valid/invalid pairs สำหรับแต่ละ non-empty rule
4. Invalid values ต้องผ่าน inputFormatters แต่ fail validators
5. ใช้ค่าที่สมจริง (ไม่ใช่ "value1", "test123")

## ตัวอย่างการทำงาน

### Input Manifest
```json
{
  "widgets": [
    {
      "key": "firstname",
      "meta": {
        "maxLength": 50,
        "validatorRules": [
          {"condition": "value.isEmpty", "message": "Required"},
          {"condition": "!RegExp(r'^[a-zA-Z]{2,}$').hasMatch(value)", "message": "Min 2 letters"}
        ]
      }
    }
  ]
}
```

### Output Dataset
```json
{
  "byKey": {
    "firstname": [
      {
        "valid": "Alice",
        "invalid": "J",
        "invalidRuleMessages": "Min 2 letters"
      }
    ]
  }
}
```

## Batch Processing Output
```
📁 Found 3 manifest file(s)
🚀 Starting batch dataset generation...

[01/3] Processing: output/manifest/demos/register_page.manifest.json
  ✓ Generated: output/test_data/register_page.datasets.json

[02/3] Processing: output/manifest/demos/login_page.manifest.json
  ⊘ Skipped: No text fields found

[03/3] Processing: output/manifest/demos/profile_page.manifest.json
  ✓ Generated: output/test_data/profile_page.datasets.json

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 Batch Summary:
  ✓ Success: 2 files
  ⊘ Skipped: 1 files (no text fields)
  ✗ Failed:  0 files
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Local Fallback Mode

หาก AI ไม่พร้อมใช้งาน script จะสร้างข้อมูลแบบ local:
- สร้างข้อมูลตาม field type (email, username, password, etc.)
- วิเคราะห์ inputFormatters และ maxLength
- ใช้ random values ที่เป็นไปตาม constraints

## Error Handling
- `GEMINI_API_KEY not set` → ต้องตั้งค่า API key
- `No TextField/TextFormField widgets found` → Skip ไฟล์นั้น
- `Gemini call failed` → แสดง error message
- HTTP errors → แสดง status code และ response

## หมายเหตุ
- AI-generated data มีคุณภาพดีกว่า local generation
- Invalid data ต้องสามารถพิมพ์ได้จริง (respect inputFormatters)
- แต่ละ validation rule จะได้ test data pair ของตัวเอง
- Script จะ log prompt และ response เพื่อ debugging
