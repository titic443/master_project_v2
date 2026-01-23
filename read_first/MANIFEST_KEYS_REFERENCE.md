# Manifest Keys Reference Guide

คู่มืออธิบายความหมายของแต่ละ key ใน `<page>.manifest.json`

---

## 📁 Root Level

| Key | เก็บจาก | ความหมาย | ใช้ทำอะไร | ตัวอย่าง | ใช้ในไฟล์ |
|-----|---------|----------|-----------|---------|-----------|
| **source** | object | ข้อมูลต้นทางของ UI file | ระบุที่มาของ manifest | `{...}` | - |
| **widgets** | array | รายการ widgets ทั้งหมดที่สแกนได้ | ใช้สร้าง test cases, datasets, event sequences | `[...]` | ทุกไฟล์ |

---

## 📄 source.*

| Key | เก็บจาก (Dart Code) | ความหมาย | ใช้ทำอะไร | ตัวอย่างค่า | ใช้ในไฟล์ |
|-----|---------------------|----------|-----------|-------------|-----------|
| **file** | path argument | ที่อยู่ไฟล์ Dart | ระบุ source file สำหรับ reference | `"lib/register/register_page.dart"` | ❌ ยังไม่ใช้ |
| **pageClass** | `class XxxPage extends StatefulWidget` | ชื่อ class ของ page | ใช้ในการ generate test class name | `"RegisterPage"` | ❌ ยังไม่ใช้ |
| **route** | `static const route = '/xxx'` | route path ของหน้า | ใช้ในการ navigate ใน integration test | `"/register"` | ❌ ยังไม่ใช้ |

**Script ที่ Extract:**
```dart
// extract_ui_manifest.dart
final pageClass = _findPageClass(src);
final route = _findPageRoute(src);
```

---

## 🎨 widgets[i].* - Common Fields

### widgetType

| เก็บจาก | ความหมาย | ใช้ทำอะไร | ตัวอย่างค่า |
|---------|----------|-----------|-------------|
| Constructor name | ประเภท widget (รวม generics) | กำหนด event type, test actions | `"TextFormField"`, `"Radio<int>"`, `"DropdownButtonFormField<String>"` |

**ใช้ในไฟล์:**
- ✅ `extract_event_sequence.dart` - กำหนด event type
- ✅ `generate_datasets.dart` - Filter TextFormField
- ✅ `generate_test_data.dart` - สร้าง factors
- ✅ `visualize_event_graph.dart` - Node colors

**ตัวอย่าง:**
```dart
// Dart Code
TextFormField(...)
Radio<int>(...)
DropdownButtonFormField<String>(...)

// Manifest
{"widgetType": "TextFormField"}
{"widgetType": "Radio<int>"}
{"widgetType": "DropdownButtonFormField<String>"}
```

---

### key

| เก็บจาก | ความหมาย | ใช้ทำอะไร | ตัวอย่างค่า |
|---------|----------|-----------|-------------|
| `key: const Key('xxx')` | Widget key สำหรับ testing | `find.byKey()` ใน test, index ใน datasets | `"register_01_username_textfield"` |

**ใช้ในไฟล์:**
- ✅ `extract_event_sequence.dart` - widgetKey
- ✅ `generate_datasets.dart` - Index datasets
- ✅ `generate_test_data.dart` - Map to factors
- ✅ `generate_test_script.dart` - find.byKey()
- ✅ `visualize_event_graph.dart` - Node IDs

**ตัวอย่าง:**
```dart
// Dart Code
TextFormField(
  key: const Key('register_01_username_textfield'),
)

// Manifest
{"key": "register_01_username_textfield"}

// ใช้ใน Test
await tester.enterText(
  find.byKey(Key('register_01_username_textfield')),
  'test'
);
```

---

### actions

| เก็บจาก | ความหมาย | ใช้ทำอะไร | ตัวอย่างค่า |
|---------|----------|-----------|-------------|
| `onPressed:`, `onChanged:`, etc. | Callbacks ที่ widget มี | กำหนด event type (tap/enterText), วิเคราะห์ business logic | `[{event:"onChanged", calls:[...]}]` |

**ใช้ในไฟล์:**
- ✅ `extract_event_sequence.dart` - กำหนด event type
- ✅ `visualize_event_graph.dart` - Event types

**ตัวอย่าง:**
```dart
// Dart Code
TextFormField(
  onChanged: (value) => _cubit.onUsernameChanged(value),
)

// Manifest
{
  "actions": [{
    "event": "onChanged",
    "argType": "String",
    "calls": [{
      "target": "RegisterCubit",
      "method": "onUsernameChanged"
    }]
  }]
}
```

---

### meta

| เก็บจาก | ความหมาย | ใช้ทำอะไร | ตัวอย่างค่า |
|---------|----------|-----------|-------------|
| Widget properties | Metadata เพิ่มเติมเฉพาะ widget type | สร้าง test data, validate constraints | `{maxLength:10, validator:true, ...}` |

**ใช้ในไฟล์:**
- ✅ `generate_datasets.dart` - Constraint analysis
- ✅ `generate_test_data.dart` - Factor generation

---

## 🎭 actions[j].*

| Key | เก็บจาก | ความหมาย | ใช้ทำอะไร | ตัวอย่างค่า | ใช้ในไฟล์ |
|-----|---------|----------|-----------|-------------|-----------|
| **event** | Callback name | ชื่อ event handler | กำหนด test action type | `"onPressed"`, `"onChanged"`, `"onTap"` | extract_event_sequence |
| **argType** | Type inference | ประเภท argument ของ callback | Type safety ใน code generation | `"String"`, `"void"`, `"int"` | ❌ |
| **calls** | Method calls inside callback | Methods ที่ถูกเรียกใน callback | วิเคราะห์ business logic flow | `[{target:"RegisterCubit", method:"..."}]` | ❌ |

**Mapping Event → Test Action:**
```
onChanged     → enterText
onPressed     → tap
onTap         → tap
onFieldSubmitted → enterText (with submit)
```

---

## 📝 meta.* (TextField/TextFormField)

### Constraint Fields

| Key | เก็บจาก | ความหมาย | ใช้ทำอะไร | ตัวอย่างค่า | ใช้ในไฟล์ |
|-----|---------|----------|-----------|-------------|-----------|
| **maxLength** | `maxLength: 10` | ความยาวสูงสุด | เช็คว่า valid data ไม่เกิน, truncate ถ้าเกิน | `10`, `25` | generate_datasets, generate_test_data |
| **obscureText** | `obscureText: true` | ซ่อนข้อความ (password field) | ใช้ในการ generate password data | `true`, `false` | generate_datasets |
| **keyboardType** | `keyboardType: TextInputType.emailAddress` | ประเภท keyboard | กำหนด input type hint | `"emailAddress"`, `"number"` | ❌ |

**ตัวอย่าง maxLength Usage:**
```dart
// Dart Code
TextFormField(maxLength: 10)

// Manifest
{"meta": {"maxLength": 10}}

// generate_datasets.dart
if (v.length > maxLen) {
  v = v.substring(0, maxLen);  // Truncate!
}
```

---

### Validation Fields

| Key | เก็บจาก | ความหมาย | ใช้ทำอะไร | ตัวอย่างค่า | ใช้ในไฟล์ |
|-----|---------|----------|-----------|-------------|-----------|
| **validator** | `validator: (value) {...}` มีหรือไม่ | มี validator หรือไม่ | บอกว่า field นี้ต้อง validate | `true` | generate_datasets, generate_test_data |
| **required** | จาก validator logic | Field บังคับกรอก | กำหนดว่าต้องมี valid data | `true` | generate_datasets, generate_test_data |
| **validatorRules** | `if (value.isEmpty) return 'Required'` | Validation rules ทั้งหมด | สร้าง valid/invalid data แบบ 1:1 mapping | `[{condition:"...", message:"..."}]` | generate_datasets, generate_test_data |

**ตัวอย่าง Validator Extraction:**
```dart
// Dart Code
validator: (value) {
  if (value == null || value.isEmpty) return 'Required';
  if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) return 'Invalid username';
  return null;
}

// Manifest
{
  "validator": true,
  "required": true,
  "validatorRules": [
    {"condition": "value == null || value.isEmpty", "message": "Required"},
    {"condition": "!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)", "message": "Invalid username"}
  ]
}

// generate_datasets.dart (1:1 Mapping)
{
  "valid": [
    "user1",      // ผ่าน rule[0] และ rule[1]
    "testUser"    // ผ่าน rule[0] และ rule[1]
  ],
  "invalid": [
    "",           // ละเมิด rule[0] (isEmpty)
    "user!"       // ละเมิด rule[1] (มี special char)
  ]
}
```

---

### inputFormatters

| Key | เก็บจาก | ความหมาย | ใช้ทำอะไร | ตัวอย่างค่า | ใช้ในไฟล์ |
|-----|---------|----------|-----------|-------------|-----------|
| **inputFormatters** | `inputFormatters: [...]` | Format constraints | ใช้สร้าง pattern สำหรับ generate data | `[{type:"allow", pattern:"[a-zA-Z0-9]"}]` | generate_datasets, generate_test_data |

**Formatter Types:**

| Type | เก็บจาก | Pattern | ใช้ทำอะไร |
|------|---------|---------|-----------|
| **allow** | `FilteringTextInputFormatter.allow(RegExp(r'...'))` | `"[a-zA-Z0-9]"` | สร้าง data ที่ match pattern |
| **deny** | `FilteringTextInputFormatter.deny(RegExp(r'...'))` | `"[^a-zA-Z0-9]"` | สร้าง data ที่ไม่ match pattern |
| **digitsOnly** | `FilteringTextInputFormatter.digitsOnly` | `"[0-9]"` | สร้างเฉพาะตัวเลข |
| **lengthLimit** | `LengthLimitingTextInputFormatter(25)` | max: `25` | เหมือน maxLength |

**ตัวอย่าง:**
```dart
// Dart Code
TextFormField(
  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
    LengthLimitingTextInputFormatter(10),
  ]
)

// Manifest
{
  "inputFormatters": [
    {"type": "allow", "pattern": "[a-zA-Z0-9]"},
    {"type": "lengthLimit", "max": 10}
  ]
}

// generate_datasets.dart
if (formatter['type'] == 'allow') {
  pattern = formatter['pattern'];  // "[a-zA-Z0-9]"
  // สร้าง data จาก pattern
}
```

---

## 📝 validatorRules[i].*

| Key | เก็บจาก | ความหมาย | ใช้ทำอะไร | ตัวอย่างค่า | ใช้ในไฟล์ |
|-----|---------|----------|-----------|-------------|-----------|
| **condition** | `if (value.isEmpty)` | เงื่อนไขที่ต้องเป็นจริงเพื่อแสดง error | สร้าง invalid data ที่ละเมิด condition นี้ | `"value == null \|\| value.isEmpty"` | generate_datasets |
| **message** | `return 'Required'` | Error message ที่แสดง | ใช้เป็น documentation, อาจใช้ใน UI test assertions | `"Required"`, `"Please enter a valid username"` | generate_datasets |

**1:1 Mapping Logic:**
```
2 rules → 2 valid values + 2 invalid values

Rule[0]: condition="isEmpty", message="Required"
  → valid[0]: "user1" (not empty, ผ่านทุก rule)
  → invalid[0]: "" (ละเมิด isEmpty)

Rule[1]: condition="!RegExp(...).hasMatch()", message="Invalid"
  → valid[1]: "testUser" (match pattern, ผ่านทุก rule)
  → invalid[1]: "user!" (มี special char, ละเมิด pattern)
```

---

## 🔘 meta.* (Radio/FormField)

| Key | เก็บจาก | ความหมาย | ใช้ทำอะไร | ตัวอย่างค่า | ใช้ในไฟล์ |
|-----|---------|----------|-----------|-------------|-----------|
| **options** | Radio widgets ใน FormField builder | ตัวเลือกทั้งหมดของ RadioGroup | สร้าง event sequence, test steps | `[{key:"...", value:"0", label:"ชาย"}]` | extract_event_sequence, generate_test_data |
| **valueExpr** | `value: 0` | ค่าของ radio button นี้ | ใช้ในการ compare กับ groupValue | `"0"`, `"1"`, `"male"` | ❌ |
| **groupValueBinding** | `groupValue: field.value` | ตัวแปรที่เก็บค่าปัจจุบันของ group | วิเคราะห์ state binding | `"field.value"` | ❌ |

**ตัวอย่าง:**
```dart
// Dart Code
FormField<int>(
  builder: (field) => Column(children: [
    Radio<int>(
      key: const Key('register_05_gender_male_radio'),
      value: 0,
      groupValue: field.value,
    ),
    Text('ชาย'),
    Radio<int>(
      key: const Key('register_05_gender_female_radio'),
      value: 1,
      groupValue: field.value,
    ),
    Text('หญิง'),
  ])
)

// Manifest
{
  "widgetType": "FormField<int>",
  "key": "register_05_gender_group",
  "meta": {
    "options": [
      {"key": "register_05_gender_male_radio", "value": "0", "label": "ชาย"},
      {"key": "register_05_gender_female_radio", "value": "1", "label": "หญิง"}
    ]
  }
}

// extract_event_sequence.dart → Event
{
  "type": "selectRadioGroup",
  "widgetKey": "register_05_gender_group",
  "options": [
    "register_05_gender_male_radio",
    "register_05_gender_female_radio"
  ]
}
```

---

## 📋 options[i].* (Radio)

| Key | เก็บจาก | ความหมาย | ใช้ทำอะไร | ตัวอย่างค่า | ใช้ในไฟล์ |
|-----|---------|----------|-----------|-------------|-----------|
| **key** | `key: const Key('xxx_radio')` | Key ของ Radio widget | ใช้ใน test `find.byKey()` | `"register_05_gender_male_radio"` | extract_event_sequence, generate_test_script |
| **value** | `value: 0` | ค่าที่ส่งไปยัง callback | วิเคราะห์ logic, assert value | `"0"`, `"1"`, `"male"` | extract_event_sequence |
| **label** | Text widget ข้างๆ Radio | Label ที่แสดงผล | ใช้เป็น documentation | `"ชาย"`, `"หญิง"` | extract_event_sequence |

---

## 🔽 meta.* (Dropdown)

| Key | เก็บจาก | ความหมาย | ใช้ทำอะไร | ตัวอย่างค่า | ใช้ในไฟล์ |
|-----|---------|----------|-----------|-------------|-----------|
| **itemsCount** | จำนวน `DropdownMenuItem` | จำนวนตัวเลือก | (ไม่ค่อยใช้) | `4` | ❌ |
| **hasValue** | `value: ...` มีหรือไม่ | มี value property | บอกว่า dropdown มี initial value | `true` | ❌ |
| **options** | `DropdownMenuItem(value:'x', child:Text('y'))` | ตัวเลือกทั้งหมด | สร้าง PICT factors, test steps | `[{value:"18-25", text:"18-25 ปี"}]` | generate_test_data, generate_test_script |

**ตัวอย่าง:**
```dart
// Dart Code
DropdownButtonFormField<String>(
  items: [
    DropdownMenuItem(value: '18-25', child: Text('18 - 25 ปี')),
    DropdownMenuItem(value: '26-35', child: Text('26 - 35 ปี')),
    DropdownMenuItem(value: '36-45', child: Text('36 - 45 ปี')),
    DropdownMenuItem(value: '46+', child: Text('46 ปีขึ้นไป')),
  ]
)

// Manifest
{
  "meta": {
    "options": [
      {"value": "18-25", "text": "18 - 25 ปี"},
      {"value": "26-35", "text": "26 - 35 ปี"},
      {"value": "36-45", "text": "36 - 45 ปี"},
      {"value": "46+", "text": "46 ปีขึ้นไป"}
    ]
  }
}

// generate_test_data.dart → PICT Factor
Dropdown: "18-25", "26-35", "36-45", "46+"

// generate_test_script.dart → Test Step
await tester.tap(find.byKey(Key('register_07_age_dropdown')));
await tester.tap(find.text('26 - 35 ปี'));  // ใช้ text จาก options
```

---

## 📋 options[i].* (Dropdown)

| Key | เก็บจาก | ความหมาย | ใช้ทำอะไร | ตัวอย่างค่า | ใช้ในไฟล์ |
|-----|---------|----------|-----------|-------------|-----------|
| **value** | `DropdownMenuItem(value: 'xxx')` | ค่าที่ส่งไปยัง callback | ใช้ใน PICT model, assert value | `"18-25"`, `"26-35"` | generate_test_data, generate_test_script |
| **text** | `child: Text('xxx')` | ข้อความที่แสดง | ใช้ใน test `find.text()` | `"18 - 25 ปี"`, `"26 - 35 ปี"` | generate_test_script |

**Value vs Text Mapping:**
```
value = "18-25"  →  text = "18 - 25 ปี"
value = "26-35"  →  text = "26 - 35 ปี"
value = "36-45"  →  text = "36 - 45 ปี"
value = "46+"    →  text = "46 ปีขึ้นไป"
```

**Why need both?**
- **value**: ใช้ใน PICT model (short, no spaces)
- **text**: ใช้ใน Flutter test (actual displayed text)

---

## 📝 meta.* (Text Widget)

| Key | เก็บจาก | ความหมาย | ใช้ทำอะไร | ตัวอย่างค่า | ใช้ในไฟล์ |
|-----|---------|----------|-----------|-------------|-----------|
| **textLiteral** | `Text('xxx')` | ข้อความที่แสดง | ใช้ใน UI assertions, documentation | `"หน้าสมัครสมาชิก"`, `"Register"` | ❌ ยังไม่ใช้ |
| **displayBinding** | `Text(state.fieldName)` | Binding กับ state | วิเคราะห์ state dependencies | `{key:"status_text", stateField:"statusMessage"}` | ❌ ยังไม่ใช้ |

---

## 🎯 Key Usage Matrix

| Key | extract_event_sequence | generate_datasets | generate_test_data | generate_test_script | visualize_event_graph |
|-----|----------------------|-------------------|-------------------|---------------------|---------------------|
| widgetType | ✅ Event type | ✅ Filter fields | ✅ Factors | ❌ | ✅ Colors |
| key | ✅ widgetKey | ✅ Index | ✅ Map factors | ✅ find.byKey() | ✅ Node ID |
| actions[].event | ✅ enterText/tap | ❌ | ❌ | ❌ | ✅ Types |
| actions[].calls | ❌ | ❌ | ❌ | ❌ | ❌ |
| meta.maxLength | ❌ | ✅ Truncate | ✅ Constraints | ❌ | ❌ |
| meta.validatorRules | ❌ | ✅ 1:1 mapping | ✅ Count rules | ❌ | ❌ |
| meta.inputFormatters | ❌ | ✅ Pattern | ✅ Constraints | ❌ | ❌ |
| meta.options (Radio) | ✅ RadioGroup | ❌ | ✅ Factors | ❌ | ❌ |
| meta.options (Dropdown) | ❌ | ❌ | ✅ Factors | ✅ tapText | ❌ |
| textLiteral | ❌ | ❌ | ❌ | ❌ | ❌ |

---

## 💡 Complete Example

### Input: register_page.dart

```dart
TextFormField(
  key: const Key('register_01_username_textfield'),
  maxLength: 10,
  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
  ],
  validator: (value) {
    if (value == null || value.isEmpty) return 'Required';
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) return 'Invalid username';
    return null;
  },
  onChanged: (value) => _cubit.onUsernameChanged(value),
)
```

### Output 1: Manifest

```json
{
  "widgetType": "TextFormField",
  "key": "register_01_username_textfield",
  "actions": [{
    "event": "onChanged",
    "argType": "String",
    "calls": [{"target": "RegisterCubit", "method": "onUsernameChanged"}]
  }],
  "meta": {
    "maxLength": 10,
    "validator": true,
    "required": true,
    "validatorRules": [
      {"condition": "value == null || value.isEmpty", "message": "Required"},
      {"condition": "!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)", "message": "Invalid username"}
    ],
    "inputFormatters": [
      {"type": "allow", "pattern": "[a-zA-Z0-9]"}
    ]
  }
}
```

### Output 2: Event Sequence

```json
{
  "id": "E1",
  "type": "enterText",
  "widgetKey": "register_01_username_textfield",
  "order": 1,
  "required": true
}
```

### Output 3: Datasets

```json
{
  "register_01_username_textfield": {
    "valid": ["user1", "testUser"],
    "invalid": ["", "user!"]
  }
}
```

### Output 4: Test Data (PICT Factor)

```
TEXT: valid, invalid
```

### Output 5: Test Script

```dart
await tester.enterText(
  find.byKey(Key('register_01_username_textfield')),
  'user1'
);
await tester.pump();
```

---

## 📚 Related Files

- **Extract**: `tools/script_v2/extract_ui_manifest.dart`
- **Usage**:
  - `tools/script_v2/extract_event_sequence.dart`
  - `tools/script_v2/generate_datasets.dart`
  - `tools/script_v2/generate_test_data.dart`
  - `tools/script_v2/generate_test_script.dart`
  - `tools/script_v2/visualize_event_graph.dart`

---

## 🔗 See Also

- [Manifest Keys CSV](./manifest_keys_reference.csv) - CSV version
- [Testing Architecture](../CLAUDE.md) - Overall architecture
- [Workflow](../README.md) - Complete workflow

---

Last Updated: 2025-01-12
