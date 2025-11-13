# ตัวอย่างการทำงานของระบบ Generate Datasets

## ภาพรวม
เอกสารนี้แสดง **ตัวอย่างจริง** ของ Prompt ที่ส่งไปยัง Google Gemini API และ Response ที่ได้รับกลับมา

---

## 📤 Prompt ที่ส่งไปยัง Google Gemini API

### โครงสร้าง Prompt (5 ส่วน)

Prompt ประกอบด้วย 5 ส่วนหลัก ตามหลักการ Prompt Engineering:

```
 customer_01_title_dropdown
 <page_prefix>_<sequence>_<description>_<widget_type>
  │                │            │            └─ ประเภท: dropdown
  │                │            └────────────────── ชื่อ: title
  │                └────────────────────── ลำดับ: 01
  └──────────────────────────────── หน้า: customer
```

---

### Context (JSON) - ข้อมูลจาก Manifest

หลังจาก Instructions 5 ส่วนด้านบน ระบบจะส่ง Context เป็น JSON ต่อท้าย:

```
Context (JSON):
{"file":"lib/demos/customer_details_page.dart","fields":[{"key":"customer_firstname_textfield","meta":{"inputFormatters":[{"type":"allow","pattern":"[a-zA-Z]"},{"type":"lengthLimit","max":50}],"validator":true,"required":true,"validatorRules":[{"condition":"value == null || value.isEmpty","message":"First name is required"},{"condition":"!RegExp(r'^[a-zA-Z]{2,}').hasMatch(value)","message":"First name must contain only letters (minimum 2 characters)"}]}},{"key":"customer_lastname_textfield","meta":{"inputFormatters":[{"type":"allow","pattern":"[a-zA-Z]"},{"type":"lengthLimit","max":50}],"validator":true,"required":true,"validatorRules":[{"condition":"value == null || value.isEmpty","message":"Last name is required"},{"condition":"!RegExp(r'^[a-zA-Z]{2,}').hasMatch(value)","message":"Last name must contain only letters (minimum 2 characters)"}]}}]}
```

**Context ในรูปแบบที่อ่านง่าย (Formatted):**

```json
{
  "file": "lib/demos/customer_details_page.dart",
  "fields": [
    {
      "key": "customer_firstname_textfield",
      "meta": {
        "inputFormatters": [
          {"type": "allow", "pattern": "[a-zA-Z]"},
          {"type": "lengthLimit", "max": 50}
        ],
        "validator": true,
        "required": true,
        "validatorRules": [
          {
            "condition": "value == null || value.isEmpty",
            "message": "First name is required"
          },
          {
            "condition": "!RegExp(r'^[a-zA-Z]{2,}').hasMatch(value)",
            "message": "First name must contain only letters (minimum 2 characters)"
          }
        ]
      }
    },
    {
      "key": "customer_lastname_textfield",
      "meta": {
        "inputFormatters": [
          {"type": "allow", "pattern": "[a-zA-Z]"},
          {"type": "lengthLimit", "max": 50}
        ],
        "validator": true,
        "required": true,
        "validatorRules": [
          {
            "condition": "value == null || value.isEmpty",
            "message": "Last name is required"
          },
          {
            "condition": "!RegExp(r'^[a-zA-Z]{2,}').hasMatch(value)",
            "message": "Last name must contain only letters (minimum 2 characters)"
          }
        ]
      }
    }
  ]
}
```

---

## 📥 Response ที่ได้รับจาก Gemini API

### Raw Response (ข้อความที่ AI ส่งกลับมา)

```json
{"file":"lib/demos/customer_details_page.dart","datasets":{"byKey":{"customer_firstname_textfield":{"valid":["John","Alice"],"invalid":["","J"]},"customer_lastname_textfield":{"valid":["Doe","Smith"],"invalid":["","S"]}}}}
```

### Response ในรูปแบบที่อ่านง่าย (Formatted)

```json
{
  "file": "lib/demos/customer_details_page.dart",
  "datasets": {
    "byKey": {
      "customer_firstname_textfield": {
        "valid": ["John", "Alice"],
        "invalid": ["", "J"]
      },
      "customer_lastname_textfield": {
        "valid": ["Doe", "Smith"],
        "invalid": ["", "S"]
      }
    }
  }
}
```

---

### Output ที่ได้รับจาก AI (Gemini 2.5 Flash)

```json
{
  "file": "lib/demos/customer_details_page.dart",
  "datasets": {
    "byKey": {
      "customer_firstname_textfield": {
        "valid": ["Alice"],
        "invalid": ["J"]
      },
      "customer_lastname_textfield": {
        "valid": ["Smith"],
        "invalid": ["S"]
      }
    }
  }
}
```

---

## การวิเคราะห์ผลลัพธ์

### Field: `customer_firstname_textfield`

**กฎการตรวจสอบ (Validation Rules):**
1. ต้องไม่เป็นค่าว่าง (isEmpty)
2. ต้องมีตัวอักษรอย่างน้อย 2 ตัว และเป็นตัวอักษรเท่านั้น (pattern: `[a-zA-Z]{2,}`)

**ผลลัพธ์ที่ AI สร้าง:**
| Index | Valid Value | Invalid Value | เหตุผล |
|-------|-------------|---------------|---------|
| 0 | "John" | "" | "John" ผ่านทุกกฎ / "" ละเมิดกฎที่ 1 (isEmpty) |
| 1 | "Alice" | "J" | "Alice" ผ่านทุกกฎ / "J" ละเมิดกฎที่ 2 (น้อยกว่า 2 ตัว) |

**สังเกต:**
- มี 2 กฎ → สร้าง 2 คู่ (valid/invalid)
- แต่ละ invalid value ละเมิดกฎเฉพาะ (1:1 mapping)

---

### Field: `customer_lastname_textfield`

**กฎการตรวจสอบ (Validation Rules):**
1. ต้องไม่เป็นค่าว่าง (isEmpty)
2. ต้องมีตัวอักษรอย่างน้อย 2 ตัว และเป็นตัวอักษรเท่านั้น (pattern: `[a-zA-Z]{2,}`)

**ผลลัพธ์ที่ AI สร้าง:**
| Index | Valid Value | Invalid Value | เหตุผล |
|-------|-------------|---------------|---------|
| 0 | "Doe" | "" | "Doe" ผ่านทุกกฎ / "" ละเมิดกฎที่ 1 (isEmpty) |
| 1 | "Smith" | "S" | "Smith" ผ่านทุกกฎ / "S" ละเมิดกฎที่ 2 (น้อยกว่า 2 ตัว) |

**สังเกต:**
- โครงสร้างเหมือนกับ firstname
- AI เลือกใช้ชื่อสกุลที่สมจริง (Doe, Smith)

---

## ข้อสังเกตสำคัญ

### ✅ จุดเด่นของ AI
1. **ความสมจริง**: ใช้ชื่อจริง (John, Alice, Doe, Smith) แทนค่าทั่วไป (value1, value2)
2. **1:1 Mapping**: แต่ละ invalid value ตรงกับกฎเฉพาะ
3. **ความครบถ้วน**: จำนวน valid = invalid = จำนวนกฎ (2 = 2 = 2)

### 🎯 การใช้งาน
ผลลัพธ์นี้จะถูกบันทึกเป็นไฟล์:
```
output/test_data/customer_details_page.datasets.json
```

และนำไปใช้ใน:
1. การ generate widget test scripts อัตโนมัติ
2. การทดสอบ form validation ทั้ง happy path และ error cases
3. การตรวจสอบความครบถ้วนของ test coverage

---

## การไหลของข้อมูล (Data Flow)

```
Manifest File
    ↓
[Extract fields with rules]
    ↓
Prompt Structure (5 parts: CONTEXT, TARGET, OBJECTIVE, EXECUTION, STYLE)
    ↓
Google Gemini API (gemini-2.5-flash)
    ↓
JSON Response (raw text)
    ↓
[Clean markdown fences]
    ↓
Parse JSON
    ↓
Save to output/test_data/*.datasets.json
```

---

## สรุป

ระบบสามารถแปลง validation rules จาก manifest เป็น test data ที่สมจริงและครบถ้วนโดยอัตโนมัติ โดย:
- ไม่ต้องเขียน test data ด้วยตนเอง
- รับประกัน 1:1 mapping ระหว่าง invalid value กับ validation rule
- ได้ข้อมูลที่สมจริงและหลากหลายจาก AI
