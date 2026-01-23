# Auto-Detect Radio Groups - สรุปการแก้ไข

## 🎯 สิ่งที่แก้ไข

แก้ไขไฟล์: `tools/script_v2/generate_test_data.dart` (บรรทัด 457-521)

**เปลี่ยนจาก**: Hardcoded pattern matching
```dart
// เดิม: ต้อง hardcode patterns
final r1 = _pickRadioPair(radioKeys, 'yes', 'no');
final r2 = _pickRadioPair(radioKeys, 'approve', 'reject');
final r3 = _pickRadioPair(radioKeys, 'manu', 'che');
final r4 = _pickRadioTriple(radioKeys, ['android', 'window', 'ios']);
```

**เป็น**: Auto-detect จาก metadata
```dart
// ใหม่: Auto-detect จาก groupValueBinding และ FormField options
final radioGroups = <String, List<String>>{};
// Method 1: Group by groupValueBinding
// Method 2: Fallback to FormField<int> options
```

---

## 🔍 วิธีการทำงานใหม่

### Method 1: Group by `groupValueBinding` (Primary)

```dart
// วน loop หา Radio ทั้งหมด
for (final w in widgets) {
  if (widgetType.startsWith('Radio')) {
    final groupBinding = meta['groupValueBinding'];  // เช่น "state.ageRange"

    // จัดกลุ่มตาม groupBinding
    radioGroups[groupBinding] = [...radios with same binding...];
  }
}
```

**ตัวอย่าง Input (Manifest)**:
```json
{
  "widgetType": "Radio<int>",
  "key": "customer_05_age_10_20_radio",
  "meta": {
    "valueExpr": "1",
    "groupValueBinding": "state.ageRange"  ← จับกลุ่มด้วยนี้
  }
}
```

**Output**:
```dart
radioGroups = {
  'state.ageRange': [
    'customer_05_age_10_20_radio',
    'customer_05_age_30_40_radio',
    'customer_05_age_40_50_radio'
  ]
}
```

---

### Method 2: FormField Options Matching (Fallback)

ใช้เมื่อ Radio ไม่มี `groupValueBinding`

```dart
// หา FormField<int> ที่มี options
for (final w in widgets) {
  if (widgetType == 'FormField<int>') {
    final options = meta['options'];  // [{"value":"1","text":"10-20"}, ...]

    // หา Radio ที่ valueExpr ตรงกับ options.value
    for (final opt in options) {
      final matchingRadio = findRadioWithValueExpr(opt['value']);
      radioGroup.add(matchingRadio);
    }
  }
}
```

---

## ✅ ผลลัพธ์

### ก่อนแก้ไข (Hardcoded)
```
Radio1: (ไม่มี - เพราะไม่ match pattern 'yes'/'no', 'approve'/'reject')
```

### หลังแก้ไข (Auto-detect)
```
Radio1: age_10_20_radio, age_30_40_radio, age_40_50_radio
```

**ไฟล์ที่เปลี่ยนแปลง**:
- ✅ `output/model_pairwise/customer_details_page.full.model.txt` - มี Radio1 ครบ 3 options
- ✅ `output/model_pairwise/customer_details_page.valid.model.txt` - มี Radio1 ครบ 3 options
- ✅ `output/model_pairwise/customer_details_page.full.result.txt` - PICT combinations ที่ include Radio1
- ✅ `output/test_data/customer_details_page.testdata.json` - Test plans ที่ใช้ Radio1

---

## 📊 เปรียบเทียบ

| | Hardcoded Pattern | Auto-Detect |
|---|---|---|
| **ความยืดหยุ่น** | ❌ ต้องเพิ่ม pattern ใหม่ทุกครั้ง | ✅ ทำงานอัตโนมัติ |
| **รองรับ naming** | ❌ เฉพาะ pattern ที่ hardcode | ✅ ทุก naming conventions |
| **Maintenance** | ❌ ต้องแก้ code บ่อย | ✅ ไม่ต้องแก้ |
| **Reliability** | ⚠️ อาจพลาด Radio บางตัว | ✅ จับได้ทุกตัวที่มี metadata |

---

## 🧪 การทดสอบ

### Test Case: customer_details_page

**Input Manifest**:
- 3 Radio widgets:
  - `customer_05_age_10_20_radio` (valueExpr: "1", groupValueBinding: "state.ageRange")
  - `customer_05_age_30_40_radio` (valueExpr: "2", groupValueBinding: "state.ageRange")
  - `customer_05_age_40_50_radio` (valueExpr: "3", groupValueBinding: "state.ageRange")

**Output PICT Model**:
```
Radio1: age_10_20_radio, age_30_40_radio, age_40_50_radio
```

**Status**: ✅ Pass - จับ Radio ได้ครบทั้ง 3 ตัว

---

## 📝 Code Changes

### ไฟล์: `tools/script_v2/generate_test_data.dart`

**บรรทัด 457-521** (เดิม 457-482):

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
  for (final w in widgets) {
    final t = (w['widgetType'] ?? '').toString();
    if (t == 'FormField<int>') {
      try {
        final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? {};
        final options = meta['options'];
        if (options is List) {
          final radioGroup = <String>[];
          for (final opt in options) {
            if (opt is Map) {
              final optValue = opt['value']?.toString();
              if (optValue != null) {
                // Find Radio with matching valueExpr
                for (final rw in widgets) {
                  final rt = (rw['widgetType'] ?? '').toString();
                  final rk = (rw['key'] ?? '').toString();
                  if (rt.startsWith('Radio') && rk.isNotEmpty) {
                    final rmeta = (rw['meta'] as Map?)?.cast<String, dynamic>() ?? {};
                    final valueExpr = (rmeta['valueExpr'] ?? '').toString();
                    if (valueExpr == optValue) {
                      radioGroup.add(rk);
                    }
                  }
                }
              }
            }
          }
          if (radioGroup.length > 1) {
            final groupKey = (w['key'] ?? 'unknown').toString();
            radioGroups[groupKey] = radioGroup;
          }
        }
      } catch (_) {}
    }
  }
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

---

## 🎉 ข้อดีของการแก้ไข

1. **ไม่ต้อง hardcode patterns อีกต่อไป**
   - เดิม: ต้องเพิ่ม `_pickRadioPair()` ทุกครั้งที่มี Radio group ใหม่
   - ใหม่: Auto-detect จาก metadata

2. **รองรับทุก naming conventions**
   - เดิม: จับได้เฉพาะ 'yes'/'no', 'approve'/'reject', 'manu'/'che', 'android'/'window'/'ios'
   - ใหม่: จับได้ทุกชื่อ (age_10_20, option_A, choice_1, etc.)

3. **Reliable และ Maintainable**
   - ใหม่: จับ Radio ได้ 100% ถ้ามี `groupValueBinding` หรือ FormField options
   - ลด bugs จากการพลาด Radio บางตัว

4. **Flexible**
   - ใหม่: มี 2 methods (groupValueBinding + FormField fallback)
   - รองรับหลายรูปแบบของ UI structure

---

## 🚀 วิธีใช้งาน

### Run generate_test_data.dart
```bash
# Single file
dart run tools/script_v2/generate_test_data.dart output/manifest/demos/customer_details_page.manifest.json

# All files
dart run tools/script_v2/generate_test_data.dart
```

### ตรวจสอบผลลัพธ์
```bash
# ดู PICT model
cat output/model_pairwise/customer_details_page.full.model.txt

# Expected:
# Radio1: age_10_20_radio, age_30_40_radio, age_40_50_radio
```

---

## 📚 สรุป

✅ **สำเร็จ**: แก้ไขให้ใช้ Auto-detect จาก metadata แทน hardcoded patterns
✅ **ทดสอบแล้ว**: customer_details_page จับ Radio ได้ครบทั้ง 3 ตัว
✅ **Maintainable**: ไม่ต้องแก้ code เมื่อมี Radio group ใหม่
✅ **Flexible**: รองรับหลายรูปแบบของ UI structure

---

## 🔗 ไฟล์ที่เกี่ยวข้อง

- `tools/script_v2/generate_test_data.dart` - Script หลักที่แก้ไข
- `output/manifest/demos/customer_details_page.manifest.json` - Input manifest
- `output/model_pairwise/customer_details_page.full.model.txt` - Output PICT model
- `output/test_data/customer_details_page.testdata.json` - Generated test plans
