# extract_ui_manifest.dart

## ภาพรวม
Script สำหรับสกัด (extract) ข้อมูล UI widgets จากไฟล์ Flutter page เพื่อสร้าง manifest JSON ที่บรรยายโครงสร้าง UI และ validation rules

## การทำงาน
1. อ่านไฟล์ `.dart` ที่เป็น Flutter page (StatefulWidget/StatelessWidget)
2. วิเคราะห์และสกัดข้อมูล widgets ต่างๆ เช่น:
   - TextField/TextFormField
   - DropdownButton/DropdownButtonFormField
   - Radio buttons
   - Checkbox
   - ElevatedButton/TextButton/OutlinedButton
   - Text widgets
3. สกัด metadata ของแต่ละ widget:
   - Key values
   - Input formatters (digitsOnly, allow, deny, etc.)
   - Validation rules และ error messages
   - Keyboard types
   - Dropdown options
   - Radio group values
4. สร้างไฟล์ manifest JSON ใน `output/manifest/`

## วิธีใช้งาน

### ประมวลผลไฟล์เดียว
```bash
dart run tools/script_v2/extract_ui_manifest.dart lib/demos/buttons_page.dart
```

### ประมวลผลทุกไฟล์ page ใน lib/
```bash
dart run tools/script_v2/extract_ui_manifest.dart
```

## Input
- ไฟล์ `.dart` ที่มี class extends `StatefulWidget` หรือ `StatelessWidget`
- ต้องมี widgets ที่ระบุ `key` parameter

## Output
- ไฟล์ manifest JSON ใน `output/manifest/<subfolder>/<page_name>.manifest.json`
- โครงสร้างโฟลเดอร์ตาม source file (เช่น `lib/demos/register_page.dart` → `output/manifest/demos/register_page.manifest.json`)

## โครงสร้าง Manifest JSON

### โครงสร้างหลัก

```json
{
  "source": {
    "file": "lib/demos/register_page.dart",
    "pageClass": "RegisterPage",
    "cubitClass": "RegisterCubit",
    "stateClass": "RegisterState",
    "fileCubit": "lib/cubit/register_cubit.dart",
    "fileState": "lib/cubit/register_state.dart"
  },
  "widgets": [ /* รายการ widgets */ ]
}
```

**คำอธิบาย:**
- **source**: ข้อมูลแหล่งที่มาของ UI page
  - `file`: ตำแหน่งไฟล์ source code
  - `pageClass`: ชื่อ class ของ page (StatefulWidget/StatelessWidget)
  - `cubitClass`: ชื่อ Cubit/Bloc ที่ใช้จัดการ state (ถ้ามี)
  - `stateClass`: ชื่อ State class ที่ใช้ร่วมกับ Cubit
  - `fileCubit`: ตำแหน่งไฟล์ Cubit
  - `fileState`: ตำแหน่งไฟล์ State
- **widgets**: array ของ widget objects ที่สกัดได้

### ตัวอย่าง Output แต่ละ Widget Type

#### 1. TextFormField / TextField

```json
{
  "widgetType": "TextFormField",
  "key": "username_textfield",
  "meta": {
    "keyboardType": "text",
    "maxLength": 50,
    "inputFormatters": [
      {"type": "allow", "pattern": "[a-zA-Z0-9]"}
    ],
    "validatorRules": [
      {
        "condition": "value == null || value.isEmpty",
        "message": "Required"
      },
      {
        "condition": "!RegExp(r'^[a-zA-Z0-9]{3,}$').hasMatch(value)",
        "message": "Username must be at least 3 characters"
      }
    ]
  }
}
```

**Output ที่เป็นไปได้:**
- `keyboardType`: `"text"`, `"emailAddress"`, `"number"`, `"phone"`, `"datetime"`, `"url"`
- `maxLength`: integer หรือ null
- `inputFormatters`: array ของ formatter objects
  - `{"type": "digitsOnly"}` - อนุญาตเฉพาะตัวเลข
  - `{"type": "allow", "pattern": "[a-zA-Z]"}` - อนุญาตเฉพาะตัวอักษร
  - `{"type": "deny", "pattern": "[^0-9]"}` - ห้ามอักขระที่ไม่ใช่ตัวเลข
  - `{"type": "lengthLimit", "limit": 20}` - จำกัดความยาว
  - `{"type": "custom", "name": "PhoneFormatter"}` - custom formatter
- `validatorRules`: array ของ validation rules
  - แต่ละ rule มี `condition` (เงื่อนไขที่ทำให้ validation fail) และ `message` (ข้อความแสดงข้อผิดพลาด)

**ตัวอย่างเพิ่มเติม:**

```json
// Email field
{
  "widgetType": "TextFormField",
  "key": "email_textfield",
  "meta": {
    "keyboardType": "emailAddress",
    "validatorRules": [
      {
        "condition": "value == null || value.isEmpty",
        "message": "Email is required"
      },
      {
        "condition": "!RegExp(r'^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$').hasMatch(value)",
        "message": "Invalid email format"
      }
    ]
  }
}

// Phone number field
{
  "widgetType": "TextFormField",
  "key": "phone_textfield",
  "meta": {
    "keyboardType": "phone",
    "maxLength": 10,
    "inputFormatters": [
      {"type": "digitsOnly"}
    ],
    "validatorRules": [
      {
        "condition": "value == null || value.isEmpty",
        "message": "Phone number is required"
      },
      {
        "condition": "value.length != 10",
        "message": "Phone number must be 10 digits"
      }
    ]
  }
}
```

#### 2. DropdownButtonFormField / DropdownButton

```json
{
  "widgetType": "DropdownButtonFormField",
  "key": "title_dropdown",
  "meta": {
    "options": [
      {"value": "mr", "text": "Mr."},
      {"value": "mrs", "text": "Mrs."},
      {"value": "ms", "text": "Ms."}
    ]
  }
}
```

**Output ที่เป็นไปได้:**
- `options`: array ของตัวเลือก
  - `value`: ค่าจริงที่จะถูกส่งไปประมวลผล (string, number)
  - `text`: ข้อความที่แสดงให้ผู้ใช้เห็น

**ตัวอย่างเพิ่มเติม:**

```json
// Country dropdown
{
  "widgetType": "DropdownButtonFormField",
  "key": "country_dropdown",
  "meta": {
    "options": [
      {"value": "th", "text": "Thailand"},
      {"value": "us", "text": "United States"},
      {"value": "jp", "text": "Japan"},
      {"value": "kr", "text": "South Korea"}
    ],
    "validatorRules": [
      {
        "condition": "value == null",
        "message": "Please select a country"
      }
    ]
  }
}
```

#### 3. Radio Buttons

```json
{
  "widgetType": "Radio",
  "key": "gender_radio_group",
  "meta": {
    "groupValue": "genderValue",
    "options": [
      {"value": 1, "label": "Male"},
      {"value": 2, "label": "Female"},
      {"value": 3, "label": "Other"}
    ]
  }
}
```

**Output ที่เป็นไปได้:**
- `groupValue`: ชื่อตัวแปรที่ใช้ bind กับ radio group
- `options`: array ของตัวเลือก radio
  - `value`: ค่าที่จะถูกเลือก (int, string)
  - `label`: label ที่แสดงข้างๆ radio button

**ตัวอย่างเพิ่มเติม:**

```json
// Payment method radio
{
  "widgetType": "Radio",
  "key": "payment_method_radio_group",
  "meta": {
    "groupValue": "paymentMethod",
    "options": [
      {"value": "credit_card", "label": "Credit Card"},
      {"value": "debit_card", "label": "Debit Card"},
      {"value": "cash", "label": "Cash on Delivery"}
    ]
  }
}
```

#### 4. Checkbox

```json
{
  "widgetType": "Checkbox",
  "key": "terms_checkbox",
  "meta": {
    "label": "I agree to the terms and conditions",
    "initialValue": false
  }
}
```

**Output ที่เป็นไปได้:**
- `label`: ข้อความที่แสดงข้างๆ checkbox
- `initialValue`: ค่าเริ่มต้น (true/false)
- `validatorRules`: (optional) เช่น require ให้ check ก่อน submit

**ตัวอย่างเพิ่มเติม:**

```json
// Newsletter subscription checkbox
{
  "widgetType": "Checkbox",
  "key": "newsletter_checkbox",
  "meta": {
    "label": "Subscribe to newsletter",
    "initialValue": false
  }
}

// Required checkbox
{
  "widgetType": "Checkbox",
  "key": "accept_policy_checkbox",
  "meta": {
    "label": "Accept privacy policy",
    "initialValue": false,
    "validatorRules": [
      {
        "condition": "value != true",
        "message": "You must accept the privacy policy"
      }
    ]
  }
}
```

#### 5. Buttons (ElevatedButton, TextButton, OutlinedButton)

```json
{
  "widgetType": "ElevatedButton",
  "key": "submit_button",
  "meta": {
    "text": "Submit",
    "enabled": true
  }
}
```

**Output ที่เป็นไปได้:**
- `text`: ข้อความบน button
- `enabled`: สถานะเปิด/ปิดการใช้งาน (true/false)

**ตัวอย่างเพิ่มเติม:**

```json
// Text button
{
  "widgetType": "TextButton",
  "key": "cancel_button",
  "meta": {
    "text": "Cancel"
  }
}

// Outlined button
{
  "widgetType": "OutlinedButton",
  "key": "reset_button",
  "meta": {
    "text": "Reset Form"
  }
}
```

#### 6. Text Widgets

```json
{
  "widgetType": "Text",
  "key": "error_message_text",
  "meta": {
    "text": "Error occurred",
    "style": "error"
  }
}
```

**Output ที่เป็นไปได้:**
- `text`: ข้อความที่แสดง (อาจเป็น placeholder ถ้าเป็น dynamic text)
- `style`: style identifier (optional) เช่น "error", "title", "subtitle"

**ตัวอย่างเพิ่มเติม:**

```json
// Title text
{
  "widgetType": "Text",
  "key": "page_title_text",
  "meta": {
    "text": "User Registration",
    "style": "headline"
  }
}

// Dynamic text (shows data from state)
{
  "widgetType": "Text",
  "key": "result_message_text",
  "meta": {
    "text": "${state.message}",
    "style": "body"
  }
}
```

### ตัวอย่าง Manifest JSON แบบสมบูรณ์

```json
{
  "source": {
    "file": "lib/demos/register_page.dart",
    "pageClass": "RegisterPage",
    "cubitClass": "RegisterCubit",
    "stateClass": "RegisterState",
    "fileCubit": "lib/cubit/register_cubit.dart",
    "fileState": "lib/cubit/register_state.dart"
  },
  "widgets": [
    {
      "widgetType": "TextFormField",
      "key": "1_username_textfield",
      "meta": {
        "keyboardType": "text",
        "maxLength": 50,
        "inputFormatters": [
          {"type": "allow", "pattern": "[a-zA-Z0-9_]"}
        ],
        "validatorRules": [
          {
            "condition": "value == null || value.isEmpty",
            "message": "Username is required"
          },
          {
            "condition": "value.length < 3",
            "message": "Username must be at least 3 characters"
          }
        ]
      }
    },
    {
      "widgetType": "TextFormField",
      "key": "2_email_textfield",
      "meta": {
        "keyboardType": "emailAddress",
        "validatorRules": [
          {
            "condition": "value == null || value.isEmpty",
            "message": "Email is required"
          },
          {
            "condition": "!RegExp(r'^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$').hasMatch(value)",
            "message": "Invalid email format"
          }
        ]
      }
    },
    {
      "widgetType": "DropdownButtonFormField",
      "key": "3_title_dropdown",
      "meta": {
        "options": [
          {"value": "mr", "text": "Mr."},
          {"value": "mrs", "text": "Mrs."},
          {"value": "ms", "text": "Ms."}
        ]
      }
    },
    {
      "widgetType": "Radio",
      "key": "4_gender_radio_group",
      "meta": {
        "groupValue": "genderValue",
        "options": [
          {"value": 1, "label": "Male"},
          {"value": 2, "label": "Female"}
        ]
      }
    },
    {
      "widgetType": "Checkbox",
      "key": "5_terms_checkbox",
      "meta": {
        "label": "I agree to the terms and conditions",
        "initialValue": false,
        "validatorRules": [
          {
            "condition": "value != true",
            "message": "You must accept the terms"
          }
        ]
      }
    },
    {
      "widgetType": "ElevatedButton",
      "key": "6_submit_button",
      "meta": {
        "text": "Register"
      }
    },
    {
      "widgetType": "Text",
      "key": "7_error_message_text",
      "meta": {
        "text": "${state.errorMessage}",
        "style": "error"
      }
    }
  ]
}
```

## ฟีเจอร์หลัก

### 1. Widget Key Extraction
- สกัด key จาก `Key('...')`, `ValueKey('...')`, `ObjectKey([...])`
- รองรับ string interpolation และ const variables

### 2. Validation Rules Extraction
- สกัด validator conditions และ error messages
- วิเคราะห์ RegExp patterns
- แยก required validation จาก format validation

### 3. Input Formatters Detection
- `FilteringTextInputFormatter.digitsOnly`
- `FilteringTextInputFormatter.allow(RegExp(...))`
- `FilteringTextInputFormatter.deny(RegExp(...))`
- `LengthLimitingTextInputFormatter(n)`
- Custom formatters

### 4. Keyboard Type Detection
- TextInputType.emailAddress
- TextInputType.number
- TextInputType.phone
- TextInputType.text

### 5. Dropdown Options Extraction
- สกัด value และ text จาก DropdownMenuItem
- รองรับทั้งรูปแบบ value และ child: Text(...)

### 6. Radio Group Detection
- จัดกลุ่ม Radio widgets ตาม groupValueBinding
- สกัด value options จาก FormField<int>

### 7. BLoC/Cubit Detection
- ตรวจหา Cubit type จาก BlocBuilder/BlocListener
- ค้นหา State type
- หา import paths สำหรับ cubit และ state files

## Widget Naming Convention
Script รองรับ naming pattern:
```
{SEQUENCE}_{description}_{widget_type}
```

ตัวอย่าง:
- `1_customer_firstname_textfield`
- `2_customer_title_dropdown`
- `10_customer_end_button`

Widgets จะถูกเรียงตาม SEQUENCE number ก่อน จากนั้นจึงเรียงตาม source order

## ตัวอย่าง Output
```
✓ Manifest written: output/manifest/demos/buttons_page.manifest.json
```

## หมายเหตุ
- Script จะข้าม widgets ที่ไม่มี key
- Script จะลบ comments ออกก่อนวิเคราะห์เพื่อหลีกเลี่ยงการจับ widgets ใน commented code
- Widgets ที่มี key ซ้ำจะถูกรวมเป็น entry เดียว (ใช้ entry แรกที่พบ)
- รองรับ nested widgets (เช่น Radio ภายใน FormField builder)
