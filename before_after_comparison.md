# Auto-Detect Radio: Before vs After

## 📋 กรณีทดสอบ: customer_details_page

### Input (Manifest)
```json
{
  "widgets": [
    {
      "widgetType": "Radio<int>",
      "key": "customer_05_age_10_20_radio",
      "meta": {
        "valueExpr": "1",
        "groupValueBinding": "state.ageRange"
      }
    },
    {
      "widgetType": "Radio<int>",
      "key": "customer_05_age_30_40_radio",
      "meta": {
        "valueExpr": "2",
        "groupValueBinding": "state.ageRange"
      }
    },
    {
      "widgetType": "Radio<int>",
      "key": "customer_05_age_40_50_radio",
      "meta": {
        "valueExpr": "3",
        "groupValueBinding": "state.ageRange"
      }
    }
  ]
}
```

---

## ❌ BEFORE: Hardcoded Pattern Matching

### Code (generate_test_data.dart:457-482)
```dart
// Build radio groups by key hints matching the UI structure
List<String> _pickRadioPair(List<String> keys, String a, String b){
  final A = keys.firstWhere((k)=> k.contains('_'+a+'_') || k.endsWith('_'+a), orElse: ()=> '');
  final B = keys.firstWhere((k)=> k.contains('_'+b+'_') || k.endsWith('_'+b), orElse: ()=> '');
  return (A.isNotEmpty && B.isNotEmpty) ? [A,B] : <String>[];
}

final r1 = _pickRadioPair(radioKeys, 'yes', 'no');
final r2 = _pickRadioPair(radioKeys, 'approve', 'reject');  // Radio2 group
final r3 = _pickRadioPair(radioKeys, 'manu', 'che');        // Radio3 group

// Radio4: android/window/ios (3 values)
List<String> _pickRadioTriple(List<String> keys, List<String> values){
  final result = <String>[];
  for (final opt in values) {
    final hit = keys.firstWhere((k)=> k.contains('_'+opt+'_') || k.endsWith('_'+opt), orElse: ()=> '');
    if (hit.isNotEmpty) result.add(hit);
  }
  return result;
}
final r4 = _pickRadioTriple(radioKeys, ['android', 'window', 'ios']);

if (r1.isNotEmpty) factors['Radio1'] = r1;
if (r2.isNotEmpty) factors['Radio2'] = r2;
if (r3.isNotEmpty) factors['Radio3'] = r3;
if (r4.isNotEmpty) factors['Radio4'] = r4;
```

### ผลลัพธ์ที่ได้
```dart
radioKeys = [
  'customer_05_age_10_20_radio',  // ตรวจสอบ pattern: ❌ ไม่ match
  'customer_05_age_30_40_radio',  // ตรวจสอบ pattern: ❌ ไม่ match
  'customer_05_age_40_50_radio'   // ตรวจสอบ pattern: ❌ ไม่ match
]

r1 = []  // ไม่มี 'yes'/'no' ใน key
r2 = []  // ไม่มี 'approve'/'reject' ใน key
r3 = []  // ไม่มี 'manu'/'che' ใน key
r4 = []  // ไม่มี 'android'/'window'/'ios' ใน key

factors = {
  // ❌ ไม่มี Radio factors เลย!
  'TEXT': ['valid', 'invalid'],
  'Dropdown': ['Mr.', 'Mrs.', 'Ms.', 'Dr.'],
  'Checkbox': ['checked', 'unchecked']
}
```

### PICT Model Output
```
❌ ไม่มี Radio1 (ถูกข้ามไป)
TEXT: valid, invalid
Dropdown: "Mr.", "Mrs.", "Ms.", "Dr."
Checkbox: checked, unchecked
```

### ⚠️ ปัญหา
- ❌ Radio ทั้งหมดถูกข้ามไป เพราะ naming pattern ไม่ match
- ❌ Test coverage ไม่ครอบคลุม Radio interactions
- ❌ ต้องเพิ่ม hardcoded pattern ทุกครั้งที่มี Radio ใหม่

---

## ✅ AFTER: Auto-Detect from Metadata

### Code (generate_test_data.dart:457-521)
```dart
// Auto-detect Radio groups from widgets metadata
// Method 1: Group by groupValueBinding (most reliable)
final radioGroups = <String, List<String>>{};
for (final w in widgets) {
  final t = (w['widgetType'] ?? '').toString();
  final k = (w['key'] ?? '').toString();
  if (t.startsWith('Radio') && k.isNotEmpty && radioKeys.contains(k)) {
    try {
      final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? {};
      final groupBinding = (meta['groupValueBinding'] ?? '').toString();
      if (groupBinding.isNotEmpty) {
        radioGroups.putIfAbsent(groupBinding, () => []);
        radioGroups[groupBinding]!.add(k);
      }
    } catch (_) {}
  }
}

// Method 2: Fallback to FormField<int> options (if no groupValueBinding found)
if (radioGroups.isEmpty) {
  // ... (ดู full code ในไฟล์ generate_test_data.dart)
}

// Add radio groups to factors
int radioIndex = 1;
for (final entry in radioGroups.entries) {
  if (entry.value.length > 1) {
    factors['Radio$radioIndex'] = entry.value;
    radioIndex++;
  }
}
```

### ผลลัพธ์ที่ได้
```dart
// Method 1: จัดกลุ่มตาม groupValueBinding
radioGroups = {
  'state.ageRange': [
    'customer_05_age_10_20_radio',   // ✅ grouped by 'state.ageRange'
    'customer_05_age_30_40_radio',   // ✅ grouped by 'state.ageRange'
    'customer_05_age_40_50_radio'    // ✅ grouped by 'state.ageRange'
  ]
}

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

### PICT Model Output
```
✅ Checkbox: checked, unchecked
✅ Radio1: age_10_20_radio, age_30_40_radio, age_40_50_radio
✅ Dropdown: "Mr.", "Mrs.", "Ms.", "Dr."
✅ TEXT: valid, invalid
✅ TEXT2: valid, invalid
✅ TEXT3: valid, invalid
✅ Checkbox2: checked, unchecked
✅ Checkbox3: checked, unchecked
```

### ✅ ผลลัพธ์
- ✅ Radio ทั้ง 3 ตัวถูกจัดกลุ่มเป็น Radio1
- ✅ PICT สร้าง test combinations ที่ครอบคลุม Radio interactions
- ✅ ไม่ต้องแก้ code เมื่อมี Radio group ใหม่

---

## 📊 เปรียบเทียบสรุป

| Feature | BEFORE (Hardcoded) | AFTER (Auto-detect) |
|---------|-------------------|---------------------|
| **Detection Method** | Pattern matching (`'yes'/'no'`) | Metadata (`groupValueBinding`) |
| **Radio Detected** | ❌ 0/3 (0%) | ✅ 3/3 (100%) |
| **Code Maintenance** | ❌ ต้องเพิ่ม pattern ใหม่ทุกครั้ง | ✅ Auto-detect อัตโนมัติ |
| **Naming Flexibility** | ❌ เฉพาะ patterns ที่ hardcode | ✅ ทุก naming conventions |
| **Test Coverage** | ⚠️ ไม่ครอบคลุม Radio | ✅ ครอบคลุม Radio interactions |
| **Error Prone** | ⚠️ ง่ายต่อการพลาด | ✅ Reliable |
| **Lines of Code** | 26 บรรทัด | 65 บรรทัด (แต่ครอบคลุมกว่า) |

---

## 🧪 ตัวอย่างการทำงาน

### BEFORE: Pattern Matching Process
```
Input: ['customer_05_age_10_20_radio', 'customer_05_age_30_40_radio', 'customer_05_age_40_50_radio']

Step 1: Check 'yes'/'no' pattern
  ❌ 'customer_05_age_10_20_radio'.contains('_yes_') → false
  ❌ 'customer_05_age_10_20_radio'.endsWith('_yes') → false

Step 2: Check 'approve'/'reject' pattern
  ❌ 'customer_05_age_10_20_radio'.contains('_approve_') → false

Step 3: Check 'manu'/'che' pattern
  ❌ 'customer_05_age_10_20_radio'.contains('_manu_') → false

Step 4: Check 'android'/'window'/'ios' pattern
  ❌ 'customer_05_age_10_20_radio'.contains('_android_') → false

Result: factors = {} (no Radio factors)
```

### AFTER: Metadata-based Grouping
```
Input: widgets with Radio metadata

Step 1: Extract Radio widgets
  Widget 1:
    key: 'customer_05_age_10_20_radio'
    groupValueBinding: 'state.ageRange'  ✅
  Widget 2:
    key: 'customer_05_age_30_40_radio'
    groupValueBinding: 'state.ageRange'  ✅
  Widget 3:
    key: 'customer_05_age_40_50_radio'
    groupValueBinding: 'state.ageRange'  ✅

Step 2: Group by binding
  radioGroups['state.ageRange'] = [
    'customer_05_age_10_20_radio',
    'customer_05_age_30_40_radio',
    'customer_05_age_40_50_radio'
  ]

Step 3: Create factors
  factors['Radio1'] = radioGroups['state.ageRange']

Result: factors = {
  'Radio1': ['age_10_20_radio', 'age_30_40_radio', 'age_40_50_radio']
}
```

---

## 🎯 สรุป

### ก่อนแก้ไข
```
❌ Radio ถูกข้ามไป (0/3 detected)
❌ ต้อง hardcode patterns
❌ ไม่ flexible
```

### หลังแก้ไข
```
✅ Radio ถูกจับได้ครบ (3/3 detected)
✅ Auto-detect จาก metadata
✅ Flexible และ maintainable
```

---

## 📂 ไฟล์ที่เปลี่ยนแปลง

**Modified:**
- ✏️ `tools/script_v2/generate_test_data.dart` (บรรทัด 457-521)

**Generated (Before):**
```
output/model_pairwise/customer_details_page.full.model.txt:
  TEXT: valid, invalid
  Dropdown: "Mr.", "Mrs.", "Ms.", "Dr."
  Checkbox: checked, unchecked
  (❌ ไม่มี Radio1)
```

**Generated (After):**
```
output/model_pairwise/customer_details_page.full.model.txt:
  Checkbox: checked, unchecked
  Radio1: age_10_20_radio, age_30_40_radio, age_40_50_radio  ← ✅ ครบ!
  Dropdown: "Mr.", "Mrs.", "Ms.", "Dr."
  TEXT: valid, invalid
  TEXT2: valid, invalid
  TEXT3: valid, invalid
  Checkbox2: checked, unchecked
  Checkbox3: checked, unchecked
```
