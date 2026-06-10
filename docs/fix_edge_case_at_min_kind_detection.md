# Fix: `buildEdgeCaseBoundaryAtMin()` — Kind Detection Logic

## ไฟล์ที่ต้องแก้

```
tools/script_v2/generate_test_data.dart
ฟังก์ชัน: buildEdgeCaseBoundaryAtMin()  (บรรทัด ~1911)
```

---

## ปัญหา

Logic ตัดสิน `kind` ของ TC `edge_cases_boundary_at_min_length` ใช้ **string equality** เพื่อเช็คว่า atMin เป็น invalid value หรือไม่ ซึ่งให้ผลผิดเมื่อ atMin กับ invalid เป็น string ต่างกันแต่มีความยาวเท่ากัน (ซึ่งเป็นกรณีปกติที่ Gemini generate)

### โค้ดปัจจุบัน (ผิด)

```dart
// บรรทัด ~1925
if (atMinVal == invalidVal && atMinVal.isNotEmpty) {
  minHasInvalidFields = true;
}
```

### กรณีที่ผิด

```
field: firstname_textfield
rule: value.length < 2  →  "Min 2 chars"

Gemini generates:
  atMin   = "A"   (length 1 — at minimum boundary, below min-2)
  invalid = "J"   (length 1 — another value that fails the same rule)

atMinVal == invalidVal  →  "A" == "J"  →  FALSE
→ minHasInvalidFields = false
→ kind = 'success'   ← ผิด! "A" ยังคง fail เพราะ length < 2
```

---

## หลักการที่ถูกต้อง

at_min ควรทำงาน **สมมาตรกับ at_max** — โครงสร้าง Steps เหมือนกันทุกอย่าง แค่เปลี่ยน field ที่ดึงจาก dataset:

```
at_max → byKey.<key>[0].atMax → kind: success เสมอ  (max length = valid)
at_min → byKey.<key>[0].atMin → kind: ดูจาก atMin  (อาจ valid หรือ invalid)
```

### ตาราง kind ที่ถูกต้อง

| atMin value | สาเหตุ | kind ที่ถูกต้อง |
|---|---|---|
| `""` (empty) | trigger required / isEmpty rule | `failed` |
| non-empty, `length == invalid.length` | ขอบล่าง = invalid boundary | `failed` |
| non-empty, `length > invalid.length` | ผ่านทุก rule | `success` |

---

## วิธีแก้

แทนที่ string equality ด้วย **length comparison**:

```dart
// แทน:
if (atMinVal == invalidVal && atMinVal.isNotEmpty) {
  minHasInvalidFields = true;
}

// ใช้:
if (atMinVal.isEmpty) {
  // empty → triggers required rule
  final widget = widgets.firstWhere((w) => (w['key'] ?? '') == key,
      orElse: () => <String, dynamic>{});
  final meta = (widget['meta'] as Map?)?.cast<String, dynamic>() ?? const {};
  final rules = (meta['validatorRules'] as List?) ?? const [];
  for (final rule in rules) {
    if (rule is Map && isEmptyCheckCondition(rule['condition']?.toString() ?? '')) {
      minHasInvalidFields = true;
      break;
    }
  }
} else if (invalidVal.isNotEmpty && atMinVal.length == invalidVal.length) {
  // same length as invalid → same boundary → also fails min-length rule
  minHasInvalidFields = true;
}
```

---

## ผลที่ได้หลังแก้

| กรณี | atMin | invalid | kind เดิม | kind ใหม่ |
|---|---|---|---|---|
| field มี min-length 2, atMin="A", invalid="J" | "A" | "J" | success ❌ | failed ✅ |
| field มี required only, atMin="" | "" | "" | failed ✅ | failed ✅ |
| field ไม่มี rule, atMin="Jo" ยาวพอ | "Jo" | "X" | success ✅ | success ✅ |

---

## Context เพิ่มเติม

- `atMin` และ `atMax` ถูก generate โดย Gemini ใน `generate_datasets.dart`
- Gemini generate `atMin` เป็น "ค่าที่ขอบล่าง" — ถ้ามี min-length rule จะเป็นค่าที่ **ต่ำกว่า min** (invalid)
- `invalid` ใน dataset คือค่าที่ trigger rule เช่นกัน แต่ Gemini อาจใช้ string ต่างกัน (content ต่าง แต่ length เท่ากัน)
- Non-text fields (Radio, Dropdown, Checkbox, DatePicker, TimePicker) ใช้ `buildNonTextDefaultSteps()` เหมือน at_max — ไม่ต้องแก้
