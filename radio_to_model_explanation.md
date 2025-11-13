# การนำ Radio มาเข้า PICT Model (.full.model.txt)

## กระบวนการทำงาน

### ขั้นตอนที่ 1: รวบรวม Radio Keys จาก Manifest
**ไฟล์**: `tools/script_v2/generate_test_data.dart` (บรรทัด 255-269)

```dart
// รวบรวม Radio keys จาก widgets
for (final w in widgets) {
  final t = (w['widgetType'] ?? '').toString();
  final k = (w['key'] ?? '').toString();

  if (t.startsWith('Radio') && k.isNotEmpty) {
    radioKeys.add(k);  // เก็บ key ทั้งหมด
  }
}

// Fallback: หา Radio options โดยดูจาก naming pattern
for (final w in widgets) {
  final k = (w['key'] ?? '').toString();
  final isOption = (k.endsWith('_radio') ||
                   k.contains('_yes_radio') ||
                   k.contains('_no_radio')) &&
                   !k.contains('_radio_group');
  if (isOption && !radioKeys.contains(k)) radioKeys.add(k);
}
```

**Output**:
```dart
radioKeys = [
  'customer_05_age_10_20_radio',
  'customer_05_age_30_40_radio',
  'customer_05_age_40_50_radio'
]
```

---

### ขั้นตอนที่ 2: จัดกลุ่ม Radio เป็น Factors
**ไฟล์**: `tools/script_v2/generate_test_data.dart` (บรรทัด 458-482)

```dart
// ฟังก์ชันช่วยหา Radio pairs (2 options)
List<String> _pickRadioPair(List<String> keys, String a, String b) {
  final A = keys.firstWhere(
    (k) => k.contains('_'+a+'_') || k.endsWith('_'+a),
    orElse: () => ''
  );
  final B = keys.firstWhere(
    (k) => k.contains('_'+b+'_') || k.endsWith('_'+b),
    orElse: () => ''
  );
  return (A.isNotEmpty && B.isNotEmpty) ? [A,B] : <String>[];
}

// ฟังก์ชันช่วยหา Radio triple (3+ options)
List<String> _pickRadioTriple(List<String> keys, List<String> values) {
  final result = <String>[];
  for (final opt in values) {
    final hit = keys.firstWhere(
      (k) => k.contains('_'+opt+'_') || k.endsWith('_'+opt),
      orElse: () => ''
    );
    if (hit.isNotEmpty) result.add(hit);
  }
  return result;
}

// สร้าง Radio factors
final r1 = _pickRadioPair(radioKeys, 'yes', 'no');
final r2 = _pickRadioPair(radioKeys, 'approve', 'reject');
final r3 = _pickRadioPair(radioKeys, 'manu', 'che');
final r4 = _pickRadioTriple(radioKeys, ['android', 'window', 'ios']);

// เพิ่ม factors ที่พบ
if (r1.isNotEmpty) factors['Radio1'] = r1;
if (r2.isNotEmpty) factors['Radio2'] = r2;
if (r3.isNotEmpty) factors['Radio3'] = r3;
if (r4.isNotEmpty) factors['Radio4'] = r4;
```

**ตัวอย่าง factors ที่สร้างได้:**
```dart
factors = {
  'Radio1': [
    'customer_05_age_10_20_radio',
    'customer_05_age_30_40_radio',
    'customer_05_age_40_50_radio'
  ],
  'TEXT': ['valid', 'invalid'],
  'Dropdown': ['Mr.', 'Mrs.', 'Ms.', 'Dr.'],
  'Checkbox': ['checked', 'unchecked']
}
```

---

### ขั้นตอนที่ 3: เขียน Factors ลงไฟล์ PICT Model
**ไฟล์**: `tools/script_v2/generator_pict.dart` (บรรทัด 37-43)

```dart
String generatePictModel(Map<String, List<String>> factors) {
  final buffer = StringBuffer();
  for (final entry in factors.entries) {
    // เขียนแต่ละ factor เป็นบรรทัด
    buffer.writeln('${entry.key}: ${_formatValuesForModel(entry.key, entry.value)}');
  }
  return buffer.toString();
}
```

**ไฟล์**: `tools/script_v2/generator_pict.dart` (บรรทัด 65-74)

```dart
String _formatValuesForModel(String factorName, List<String> values) {
  // Dropdown ใช้ quoted values
  if (!factorName.startsWith('Dropdown')) {
    return values.join(', ');  // Radio ใช้ comma-separated
  }
  // Dropdown ต้อง quote
  final quoted = values.map((v) {
    final escaped = v.replaceAll('"', '\\"');
    return '"$escaped"';
  }).toList();
  return quoted.join(', ');
}
```

---

### ขั้นตอนที่ 4: บันทึกไฟล์ Model
**ไฟล์**: `tools/script_v2/generator_pict.dart` (บรรทัด 319-322)

```dart
final outPageModel = 'output/model_pairwise/$pageBaseName.full.model.txt';
File(outPageModel).writeAsStringSync(modelContent);
```

**Output ไฟล์**: `output/model_pairwise/customer_details_page.full.model.txt`
```
Checkbox: checked, unchecked
Radio1: age_10_20_radio, age_30_40_radio, age_40_50_radio
Dropdown: "Mr.", "Mrs.", "Ms.", "Dr."
TEXT: valid, invalid
TEXT2: valid, invalid
TEXT3: valid, invalid
Checkbox2: checked, unchecked
Checkbox3: checked, unchecked
```

---

## สรุปกระบวนการ

```
┌─────────────────────────────────────────────────────────┐
│  1. อ่าน manifest.json                                  │
│     → รวบรวม Radio widgets                              │
│     → radioKeys = [key1, key2, key3]                    │
└─────────────────┬───────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────────┐
│  2. จัดกลุ่ม Radio เป็น factors                         │
│     → _pickRadioPair() / _pickRadioTriple()            │
│     → หา Radio groups ตาม naming patterns               │
│     → factors['Radio1'] = [key1, key2, key3]           │
└─────────────────┬───────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────────┐
│  3. เขียน factors ลงไฟล์ PICT model                     │
│     → generatePictModel(factors)                        │
│     → Format: "Radio1: key1, key2, key3"                │
└─────────────────┬───────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────────┐
│  4. บันทึกเป็น .full.model.txt                          │
│     → File(outPageModel).writeAsStringSync()            │
│     → output/model_pairwise/<page>.full.model.txt       │
└─────────────────────────────────────────────────────────┘
```

---

## วิธีการจับคู่ Radio Keys

### วิธีที่ใช้อยู่ตอนนี้: **Hardcoded Pattern Matching**

**ข้อดี:**
- ✅ รวดเร็ว ไม่ต้องพึ่ง AI
- ✅ Deterministic (ผลลัพธ์เหมือนเดิมทุกครั้ง)
- ✅ เหมาะกับ naming conventions ที่ชัดเจน

**ข้อเสีย:**
- ❌ ต้องเพิ่ม pattern ใหม่ทุกครั้งที่มี Radio group ใหม่
- ❌ ไม่ flexible (เช่น Radio ที่ชื่อ "option_A", "option_B" จะไม่ถูกจับได้)

**Patterns ที่ support:**
```dart
// Pair patterns (2 options)
_pickRadioPair(radioKeys, 'yes', 'no')       // Radio1
_pickRadioPair(radioKeys, 'approve', 'reject') // Radio2
_pickRadioPair(radioKeys, 'manu', 'che')     // Radio3

// Triple pattern (3+ options)
_pickRadioTriple(radioKeys, ['android', 'window', 'ios']) // Radio4
```

**ตัวอย่างการจับคู่:**
```
Input: 'customer_05_age_10_20_radio'
       'customer_05_age_30_40_radio'
       'customer_05_age_40_50_radio'

Pattern matching:
  ✗ ไม่ match 'yes'/'no'
  ✗ ไม่ match 'approve'/'reject'
  ✗ ไม่ match 'manu'/'che'
  ✗ ไม่ match 'android'/'window'/'ios'

Result: ไม่มี Radio factor (ถูกข้ามไป!)
```

---

## ปัญหาที่พบ

### กรณี: Radio ไม่ถูกจับเข้า factors

**สาเหตุ**: Naming pattern ไม่ตรงกับ hardcoded patterns

**ตัวอย่าง:**
```dart
// Radio keys จาก manifest
radioKeys = [
  'customer_05_age_10_20_radio',  // มี '10_20' ไม่ match pattern ใดๆ
  'customer_05_age_30_40_radio',  // มี '30_40' ไม่ match pattern ใดๆ
  'customer_05_age_40_50_radio'   // มี '40_50' ไม่ match pattern ใดๆ
]

// ผลลัพธ์
factors = {
  'TEXT': ['valid', 'invalid'],
  'Dropdown': ['Mr.', 'Mrs.'],
  // Radio1 ไม่มี! เพราะไม่มี pattern ที่ match
}
```

---

## แนวทางแก้ไข

### แนวทาง 1: เพิ่ม Pattern ใหม่
```dart
// เพิ่มใน generate_test_data.dart บรรทัด 458-482
final r5 = _pickRadioTriple(radioKeys, ['10_20', '30_40', '40_50']);
if (r5.isNotEmpty) factors['Radio5'] = r5;
```

### แนวทาง 2: ใช้ FormField<int> grouping (Auto-detect)
```dart
// อ่าน manifest หา FormField<int> ที่มี options
for (final w in widgets) {
  if (w['widgetType'] == 'FormField<int>') {
    final opts = w['meta']['options']; // [{"value":"1","text":"10-20"}, ...]
    final radioGroup = _findRelatedRadios(radioKeys, opts);
    if (radioGroup.isNotEmpty) {
      factors['Radio${factorCount++}'] = radioGroup;
    }
  }
}
```

### แนวทาง 3: ใช้ AI จัดกลุ่ม
```dart
// ส่ง radioKeys ไปให้ AI จัดกลุ่ม
final radioGroups = await _groupRadiosWithAI(radioKeys);
for (int i = 0; i < radioGroups.length; i++) {
  factors['Radio${i+1}'] = radioGroups[i];
}
```

---

## ตัวอย่างไฟล์ที่เกี่ยวข้อง

### Input: `output/manifest/demos/customer_details_page.manifest.json`
```json
{
  "widgets": [
    {
      "widgetType": "Radio<int>",
      "key": "customer_05_age_10_20_radio",
      "meta": {"valueExpr": "1", "groupValueBinding": "state.ageRange"}
    },
    {
      "widgetType": "Radio<int>",
      "key": "customer_05_age_30_40_radio",
      "meta": {"valueExpr": "2", "groupValueBinding": "state.ageRange"}
    },
    {
      "widgetType": "FormField<int>",
      "key": "customer_05_age_range_formfield",
      "meta": {
        "options": [
          {"value": "1", "text": "10-20"},
          {"value": "2", "text": "30-40"},
          {"value": "3", "text": "50-60"}
        ]
      }
    }
  ]
}
```

### Output: `output/model_pairwise/customer_details_page.full.model.txt`
```
Checkbox: checked, unchecked
Radio1: age_10_20_radio, age_30_40_radio, age_40_50_radio
Dropdown: "Mr.", "Mrs.", "Ms.", "Dr."
TEXT: valid, invalid
```

---

## คำสำคัญที่ควรรู้

- **Factor**: ปัจจัยที่ต้องการทดสอบ (เช่น Radio1, TEXT, Dropdown)
- **Value**: ค่าที่เป็นไปได้ของ factor (เช่น Radio1: [key1, key2, key3])
- **PICT Model**: ไฟล์ที่เก็บ factors และ values สำหรับ pairwise testing
- **Pairwise Testing**: วิธีทดสอบที่ครอบคลุมการจับคู่ทุก 2 factors (ลด test cases)
- **Pattern Matching**: การหา Radio groups โดยดูจากชื่อ key (hardcoded)
