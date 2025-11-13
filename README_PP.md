# 4.1 การสกัดข้อมูลมาจากไฟล์ฟรอนต์เอนด์

## ภาพรวม

ในขั้นตอนนี้จะทำการสกัดข้อมูลมาจากไฟล์ฟรอนต์เอนด์ ซึ่งเป็นไฟล์ที่ใช้แสดงหน้าจอเพื่อนำไปใช้ในการแสดงผลหรือตอบสนองกับผู้ใช้ ไฟล์เหล่านี้ถูกจัดเก็บอยู่ภายใต้ฟิลเดอร์ `lib` โดยมีรูปแบบ:

``` txt
{
    "file": "lib/demos/customer_details_page.dart",
    "datasets": {
      "byKey": {
        "customer_02_firstname_textfield": [
          {
            "valid": "Alice",
            "invalid": "A",
            "invalidRuleMessages": "First name must contain only letters (minimum 2 characters)"
          }
        ]
      }
    }
  }
```

**เครื่องมือที่ใช้**: `tools/script_v2/extract_ui_manifest.dart`

---

## วัตถุประสงค์

สกัดข้อมูล UI widgets จากไฟล์ Flutter page (.dart) และสร้าง **manifest.json** ที่บรรยายโครงสร้าง UI แบบละเอียด เพื่อนำไปใช้ในขั้นตอนถัดไป (การสร้าง PICT model และ test data)

---

## Input และ Output

| ประเภท | รายละเอียด | ตัวอย่าง |
|--------|-----------|---------|
| **Input** | ไฟล์ Flutter page | `lib/demos/customer_details_page.dart` |
| **Output** | ไฟล์ Manifest JSON | `output/manifest/demos/customer_details_page.manifest.json` |

---

## ตัวอย่าง Widgets ที่สกัดข้อมูล

### ตัวอย่างที่ 1: DropdownButtonFormField

```dart
DropdownButtonFormField<String>(
  key: const Key('customer_title_dropdown'),
  value: state.title,
  decoration: const InputDecoration(labelText: 'Title'),
  items: const [
    DropdownMenuItem(value: 'Mr.', child: Text('Mr.')),
    DropdownMenuItem(value: 'Mrs.', child: Text('Mrs.')),
    DropdownMenuItem(value: 'Ms.', child: Text('Ms.')),
    DropdownMenuItem(value: 'Dr.', child: Text('Dr.')),
  ],
  onChanged: (value) {
    context.read<CustomerCubit>().onTitleChanged(value);
  },
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please select a title';
    }
    return null;
  },
),
```

### ตัวอย่างที่ 2: Radio Widget

```dart
Radio<int>(
  key: const Key('customer_age_10_20_radio'),
  value: 1,
  groupValue: state.ageRange,
  onChanged: (value) {
    context.read<CustomerCubit>().onAgeRangeSelected(value);
    formState.didChange(value);
  },
),
```

---

## ส่วนประกอบที่สกัดได้จาก Widgets

จากตัวอย่างข้างต้น สามารถสกัดข้อมูลได้ดังนี้:

### 1. **key**
ตัวระบุเฉพาะ (unique identifier) ที่ใช้สำหรับระบุวิดเจ็ตในโครงสร้างแอปพลิเคชัน เพื่อให้สามารถเข้าถึงและทดสอบวิดเจ็ตได้อย่างถูกต้อง

**ตัวอย่าง**:
- `customer_title_dropdown`
- `customer_age_10_20_radio`

### 2. **value**
ค่าปัจจุบันที่วิดเจ็ตแสดงผล โดยมักจะผูกกับ state ของแอปพลิเคชัน

**ตัวอย่าง**:
- `state.title` (สำหรับ Dropdown - ผูกกับ state)
- `1` (สำหรับ Radio - ค่าคงที่ที่กำหนดให้ Radio นี้)

### 3. **items**
รายการตัวเลือกทั้งหมดที่แสดงให้ผู้ใช้เลือก (ใช้กับวิดเจ็ตแบบ Dropdown)

**ตัวอย่าง** (สำหรับ Dropdown):
```json
[
  {"value": "Mr.", "text": "Mr."},
  {"value": "Mrs.", "text": "Mrs."},
  {"value": "Ms.", "text": "Ms."},
  {"value": "Dr.", "text": "Dr."}
]
```

### 4. **onChanged**
ฟังก์ชันคอลแบ็ก (callback function) ที่ถูกเรียกใช้งานเมื่อผู้ใช้เปลี่ยนแปลงค่าของวิดเจ็ต เพื่ออัพเดท state หรือดำเนินการตามที่กำหนด

**ตัวอย่าง**:
- `context.read<CustomerCubit>().onTitleChanged(value)`
- `context.read<CustomerCubit>().onAgeRangeSelected(value)`

**สกัดเป็น**:
```json
{
  "target": "CustomerCubit",
  "method": "onTitleChanged"
}
```

### 5. **validator**
ฟังก์ชันที่ตรวจสอบความถูกต้องของข้อมูลที่ผู้ใช้ป้อนเข้ามา (Form validation) โดยจะคืนค่าข้อความแจ้งเตือนหากข้อมูลไม่ถูกต้องตามเงื่อนไขที่กำหนด

**ตัวอย่าง**:
```dart
validator: (value) {
  if (value == null || value.isEmpty) {
    return 'Please select a title';
  }
  return null;
}
```

**สกัดเป็น**:
```json
{
  "validator": true,
  "required": true,
  "validatorRules": [
    {
      "condition": "value == null || value.isEmpty",
      "message": "Please select a title"
    }
  ]
}
```

### 6. **groupValue** (สำหรับ Radio)
ค่าปัจจุบันของกลุ่ม Radio ที่ใช้ระบุว่า Radio ตัวใดในกลุ่มถูกเลือกอยู่ โดย Radio ที่มีค่า `value` ตรงกับ `groupValue` จะแสดงเป็นถูกเลือก

**ตัวอย่าง**:
- `state.ageRange` (ถ้า state.ageRange = 1, Radio ที่มี value = 1 จะถูกเลือก)

---

## ตัวอย่างโค้ดไฟล์ฟรอนต์เอนด์แบบสมบูรณ์

```dart
return Form(
  key: _formKey,
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        // Title - DropdownButtonFormField
        DropdownButtonFormField<String>(
          key: const Key('customer_title_dropdown'),
          value: state.title,
          decoration: const InputDecoration(labelText: 'Title'),
          items: const [
            DropdownMenuItem(value: 'Mr.', child: Text('Mr.')),
            DropdownMenuItem(value: 'Mrs.', child: Text('Mrs.')),
            DropdownMenuItem(value: 'Ms.', child: Text('Ms.')),
            DropdownMenuItem(value: 'Dr.', child: Text('Dr.')),
          ],
          onChanged: (value) => context.read<CustomerCubit>().onTitleChanged(value),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please select a title';
            return null;
          },
        ),

        // First Name - TextFormField
        TextFormField(
          key: const Key('customer_firstname_textfield'),
          // ...
        ),

        // Last Name - TextFormField
        TextFormField(
          key: const Key('customer_lastname_textfield'),
          // ...
        ),

        // Age Range - FormField with Radio buttons
        FormField<int>(
          key: const Key('customer_age_formfield'),
          builder: (formState) => Column(
            children: [
              Radio<int>(
                key: const Key('customer_age_10_20_radio'),
                value: 1,
                groupValue: state.ageRange,
                onChanged: (value) {
                  context.read<CustomerCubit>().onAgeRangeSelected(value);
                  formState.didChange(value);
                },
              ),
              // More Radio buttons...
            ],
          ),
        ),

        // Agree to terms - FormField with Checkbox
        FormField<bool>(
          key: const Key('customer_agree_terms_formfield'),
          // ...
        ),

        // Subscribe newsletter - Checkbox (no FormField, optional)
        CheckboxListTile(
          key: const Key('customer_subscribe_checkbox'),
          // ...
        ),

        // Submit button
        ElevatedButton(
          key: const Key('customer_submit_button'),
          onPressed: () => _handleSubmit(),
          child: const Text('Submit'),
        ),
      ],
    ),
  ),
);
```

---

## ขั้นตอนการทำงานของเครื่องมือ extract_ui_manifest.dart

### ขั้นตอนที่ 1: อ่านและเตรียมข้อมูล

```dart
void _processOne(String path) {
  final rawSrc = File(path).readAsStringSync();
  final src = _stripComments(rawSrc);          // ลบ comments ออก
  final consts = _collectStringConsts(src);    // เก็บ string constants
  final pageClass = _findPageClass(src);       // หาชื่อ Page class
  final cubitType = _findCubitType(src);       // หา Cubit type (เช่น CustomerCubit)
  final stateType = _findStateType(src);       // หา State type (เช่น CustomerState)
  final cubitFilePath = _findCubitFilePath(src, cubitType);
  final stateFilePath = _findStateFilePath(src, stateType);
}
```

### ขั้นตอนที่ 2: สแกนหา Widgets

เครื่องมือจะสแกนหา widgets ต่อไปนี้:

**Form inputs**:
- `TextField`
- `TextFormField`
- `FormField`
- `DropdownButton`
- `DropdownButtonFormField`

**Buttons**:
- `ElevatedButton`
- `TextButton`
- `OutlinedButton`
- `IconButton`

**Selection widgets**:
- `Radio`
- `Checkbox`
- `Switch`

**Display widgets**:
- `Text`
- `SnackBar`
- `Visibility`

### ขั้นตอนที่ 3: สกัดข้อมูลจาก Widgets

สำหรับแต่ละ widget ที่พบ จะสกัดข้อมูลต่อไปนี้:

#### 3.1 **Key** (Widget identifier)
```dart
// รูปแบบที่รองรับ:
key: Key('customer_title_dropdown')
key: const Key('customer_firstname_textfield')
key: ValueKey<String>('submit_button')
```

#### 3.2 **Actions** (User interactions)
```dart
// Events ที่สนใจ:
onPressed, onChanged, onTap, onSubmitted, onFieldSubmitted, onSaved

// ตัวอย่างการสกัด:
onChanged: (value) {
  context.read<CustomerCubit>().onTitleChanged(value);
}

// สกัดได้:
{
  "event": "onChanged",
  "argType": "String",
  "calls": [
    {"target": "CustomerCubit", "method": "onTitleChanged"}
  ]
}
```

#### 3.3 **Metadata**

##### TextField/TextFormField metadata:
```json
{
  "keyboardType": "emailAddress",
  "obscureText": true,
  "maxLength": 50,
  "inputFormatters": [
    {"type": "digitsOnly"},
    {"type": "allow", "pattern": "[a-zA-Z]"}
  ]
}
```

##### Validator metadata:
```json
{
  "validator": true,
  "required": true,
  "validatorRules": [
    {
      "condition": "value == null || value.isEmpty",
      "message": "First name is required"
    },
    {
      "condition": "!RegExp(r'^[a-zA-Z]{2,}$').hasMatch(value)",
      "message": "First name must contain only letters (minimum 2 characters)"
    }
  ]
}
```

##### Dropdown metadata:
```json
{
  "options": [
    {"value": "Mr.", "text": "Mr."},
    {"value": "Mrs.", "text": "Mrs."},
    {"value": "Ms.", "text": "Ms."},
    {"value": "Dr.", "text": "Dr."}
  ]
}
```

##### Radio metadata:
```json
{
  "valueExpr": "1",
  "groupValueBinding": "state.ageRange"
}
```

### ขั้นตอนที่ 4: เรียงลำดับ Widgets

Widgets จะถูกเรียงลำดับตาม **SEQUENCE number** ในชื่อ key:

```
รูปแบบ: {SEQUENCE}_*_{WIDGET}

ตัวอย่าง keys:
  - "1_customer_title_dropdown"         → SEQUENCE = 1
  - "2_customer_firstname_textfield"    → SEQUENCE = 2
  - "3_customer_lastname_textfield"     → SEQUENCE = 3
  - "10_customer_submit_button"         → SEQUENCE = 10
  - "customer_helper_text"               → ไม่มี SEQUENCE (เรียงตาม sourceOrder)

ลำดับที่ได้:
  1. "1_customer_title_dropdown"
  2. "2_customer_firstname_textfield"
  3. "3_customer_lastname_textfield"
  4. "10_customer_submit_button"
  5. "customer_helper_text"
```

**กฎการเรียงลำดับ**:
- **Priority 1**: Widgets ที่มี SEQUENCE (เรียงตามตัวเลข)
- **Priority 2**: Widgets ที่ไม่มี SEQUENCE (เรียงตามลำดับในไฟล์ต้นฉบับ)

### ขั้นตอนที่ 5: สร้าง Manifest JSON

```json
{
  "source": {
    "file": "lib/demos/customer_details_page.dart",
    "pageClass": "CustomerDetailsPage",
    "cubitClass": "CustomerCubit",
    "stateClass": "CustomerState",
    "fileCubit": "lib/cubit/customer_cubit.dart",
    "fileState": "lib/cubit/customer_state.dart"
  },
  "widgets": [
    {
      "widgetType": "DropdownButtonFormField<String>",
      "key": "1_customer_title_dropdown",
      "actions": [
        {
          "event": "onChanged",
          "argType": "String",
          "calls": [
            {
              "target": "CustomerCubit",
              "method": "onTitleChanged"
            }
          ]
        }
      ],
      "meta": {
        "validator": true,
        "required": true,
        "validatorRules": [
          {
            "condition": "value == null || value.isEmpty",
            "message": "Please select a title"
          }
        ],
        "options": [
          {"value": "Mr.", "text": "Mr."},
          {"value": "Mrs.", "text": "Mrs."},
          {"value": "Ms.", "text": "Ms."},
          {"value": "Dr.", "text": "Dr."}
        ]
      }
    },
    {
      "widgetType": "TextFormField",
      "key": "2_customer_firstname_textfield",
      "actions": [
        {
          "event": "onChanged",
          "argType": "String",
          "calls": [
            {
              "target": "CustomerCubit",
              "method": "updateFirstName"
            }
          ]
        }
      ],
      "meta": {
        "keyboardType": "text",
        "validator": true,
        "required": true,
        "validatorRules": [
          {
            "condition": "value == null || value.isEmpty",
            "message": "First name is required"
          },
          {
            "condition": "!RegExp(r'^[a-zA-Z]{2,}$').hasMatch(value)",
            "message": "First name must contain only letters (minimum 2 characters)"
          }
        ]
      }
    },
    {
      "widgetType": "Radio<int>",
      "key": "4_customer_age_10_20_radio",
      "actions": [
        {
          "event": "onChanged",
          "argType": "int",
          "calls": [
            {
              "target": "CustomerCubit",
              "method": "onAgeRangeSelected"
            }
          ]
        }
      ],
      "meta": {
        "valueExpr": "1",
        "groupValueBinding": "state.ageRange"
      }
    }
  ]
}
```

---

## ฟีเจอร์พิเศษ

### 1. ตรวจจับ BLoC Wrappers

เครื่องมือสามารถตรวจจับว่า widget อยู่ภายใต้ BLoC wrappers ใดบ้าง:

```dart
BlocBuilder<CustomerCubit, CustomerState>(
  builder: (context, state) {
    return TextFormField(
      key: const Key('customer_firstname_textfield'),
      // ...
    );
  },
)

// สกัดได้:
"wrappers": ["BlocBuilder"]
```

### 2. สกัด Method Calls จาก Actions

รองรับรูปแบบต่างๆ:

```dart
// รูปแบบที่ 1: context.read<T>().method()
onChanged: (value) => context.read<CustomerCubit>().updateFirstName(value)

// รูปแบบที่ 2: _cubit.method()
onPressed: () => _cubit.submitForm()

// รูปแบบที่ 3: Navigator
onPressed: () => Navigator.of(context).pop()

// รูปแบบที่ 4: Ternary expression
onPressed: isValid ? _handleSubmit : null

// รูปแบบที่ 5: Method reference
onPressed: _handleSubmit
```

### 3. หา Method Body

ถ้า action เป็นชื่อ method เช่น `_handleSubmit` เครื่องมือจะไปหา method body ใน source code:

```dart
void _handleSubmit() {
  if (_formKey.currentState!.validate()) {
    context.read<CustomerCubit>().submitForm();
    Navigator.of(context).pop();
  }
}

// สกัดได้:
"calls": [
  {"target": "CustomerCubit", "method": "submitForm"},
  {"target": "Navigator", "method": "pop"}
]
```

### 4. Nested Widgets

สแกน widgets ภายใน widgets อื่นๆ:

```dart
FormField<int>(
  key: const Key('customer_age_formfield'),
  builder: (formState) => Column(
    children: [
      Radio<int>(
        key: const Key('customer_age_10_20_radio'),
        value: 1,
        // ...
      ),
      Radio<int>(
        key: const Key('customer_age_30_40_radio'),
        value: 2,
        // ...
      ),
    ],
  ),
)

// สกัดได้ทั้ง FormField และ Radio ทุกตัวที่อยู่ภายใน
```

### 5. ค้นหา Cubit/State Files

เครื่องมือจะค้นหาตำแหน่งไฟล์ Cubit และ State จาก import statements:

```dart
import 'package:master_project/cubit/customer_cubit.dart';
import 'package:master_project/cubit/customer_state.dart';

// สกัดได้:
"fileCubit": "lib/cubit/customer_cubit.dart"
"fileState": "lib/cubit/customer_state.dart"
```

---

## การใช้งาน

### รันกับไฟล์เดียว

```bash
dart run tools/script_v2/extract_ui_manifest.dart lib/demos/customer_details_page.dart
```

**ผลลัพธ์**:
```
✓ Manifest written: output/manifest/demos/customer_details_page.manifest.json
```

### รันกับทุกไฟล์ page

```bash
dart run tools/script_v2/extract_ui_manifest.dart
```

เครื่องมือจะสแกนหาไฟล์ทั้งหมดที่:
- ลงท้ายด้วย `_page.dart`
- ลงท้ายด้วย `.page.dart`
- อยู่ภายใต้โฟลเดอร์ `lib/`

**ตัวอย่างผลลัพธ์**:
```
✓ Manifest written: output/manifest/demos/customer_details_page.manifest.json
✓ Manifest written: output/manifest/demos/register_page.manifest.json
✓ Manifest written: output/manifest/demos/login_page.manifest.json
```

---

## สรุปขั้นตอนการทำงาน

```
Flutter Page File (*.dart)
        ↓
[1] Remove Comments
        ↓
[2] Scan Widgets
    (TextField, Button, Dropdown, Radio, Checkbox, etc.)
        ↓
[3] Extract Data
    • key (widget identifier)
    • actions (onChanged, onPressed, etc.)
    • validators (validation rules)
    • metadata (options, keyboardType, etc.)
        ↓
[4] Sort Widgets
    Priority 1: By SEQUENCE number in key
    Priority 2: By source order
        ↓
[5] Generate Manifest JSON
        ↓
output/manifest/{subfolder}/{page}.manifest.json
```

---

## ผลลัพธ์ที่ได้

Manifest JSON file ที่บรรยาย UI structure พร้อม metadata ครบถ้วน ประกอบด้วย:

1. **Source information**:
   - ไฟล์ต้นฉบับ (page file)
   - Page class name
   - Cubit และ State class names
   - ตำแหน่งไฟล์ Cubit และ State

2. **Widget information** (สำหรับแต่ละ widget):
   - Widget type และ generics
   - Key (identifier)
   - Actions และ method calls
   - Metadata (validation rules, options, keyboard type, etc.)
   - Wrappers (BlocBuilder, BlocListener, etc.)

3. **เรียงลำดับตาม SEQUENCE number** เพื่อให้สอดคล้องกับลำดับการโต้ตอบของผู้ใช้

Manifest นี้จะถูกนำไปใช้ในขั้นตอนถัดไป:
- **ขั้นตอนที่ 4.2**: สร้าง PICT model จาก manifest
- **ขั้นตอนที่ 4.3**: สร้าง Test data จาก PICT results และ manifest
- **ขั้นตอนที่ 4.4**: สร้าง Flutter widget tests จาก test data
