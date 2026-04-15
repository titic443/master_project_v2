# Assertion Logic — How Test Script Builds Assertions

ไฟล์นี้อธิบายว่า `generate_test_data.dart` ตัดสินใจสร้าง assertion อย่างไรในแต่ละกรณีทดสอบ

---

## ภาพรวม — 3 กลุ่ม Test Case

| กลุ่ม | ที่มา | kind | Assertion |
|---|---|---|---|
| `pairwise_valid_invalid_cases` | PICT `.invalid.result.txt` | mixed (success / failed) | ขึ้นอยู่กับว่ามี invalid field หรือไม่ |
| `pairwise_valid_cases` | PICT `.valid.result.txt` | success เสมอ | `buildSuccessAsserts()` เสมอ |
| `edge_cases` | สร้างเอง 3 sub-case | success / failed | แล้วแต่ sub-case |

---

## Key Concepts ก่อนอ่าน Logic

### Expected Keys — ดึงมาจาก Manifest อัตโนมัติ

ระบบ scan widget keys ทั้งหมดใน manifest แล้วแยกเป็น 2 กลุ่ม:

| กลุ่ม | เงื่อนไข (key ต้องมี substring) | ตัวอย่าง |
|---|---|---|
| `expectedSuccessKeys` | `_expected_success` หรือ `_dialog_success` | `search_01_expected_success` |
| `expectedFailKeys` | `_expected_fail` หรือ `_dialog_fail` | `search_01_expected_fail` |

> Widget ที่เป็น `AlertDialog` หรือ `SimpleDialog` จะถูกเพิ่มใน `dialogKeys` ด้วย → ทำให้ assert มี `dismiss: true` (auto-tap TextButton ปิด dialog หลัง assert)

### Fallback Success Key

ถ้า manifest ไม่มี `_expected_success` widget เลย:

```
_fallbackSuccessKey = "${endKey.split('_').first}_expected_success"
ตัวอย่าง: endKey = "search_06_end_button" → fallbackKey = "search_expected_success"
```

### buildSuccessAsserts()

```
ถ้า expectedSuccessKeys ไม่ว่าง → [{byKey: key, exists: true}] สำหรับทุก key
ถ้า expectedSuccessKeys ว่าง แต่มี fallbackKey → [{byKey: fallbackKey, exists: true}]
ถ้าทั้งคู่ว่าง → [] (empty)
```

---

## Group 1: pairwise_valid_invalid_cases

แต่ละแถวจาก PICT `.invalid.result.txt` จะสร้าง 1 test case

### ขั้นตอนตัดสินว่า kind คืออะไร

```
hasInvalidData = มี field ใดใน combination ที่ bucket = "invalid"
                หรือมี required checkbox ที่ = "unchecked"

kind = hasInvalidData ? "failed" : "success"
```

---

### กรณี kind = "failed" — Assertion Priority

```
1. สำหรับแต่ละ invalid TextField:
   a. ดึง invalidRuleMessages จาก datasets.byKey[fieldKey][0]
   b. ถ้าว่างหรือ "general" → fallback: scan validatorRules จาก manifest
      หาเงื่อนไข isEmpty/null (value==null, value.isEmpty, v.trim().isEmpty ฯลฯ)
      แล้วดึง message นั้น

2. สำหรับแต่ละ required checkbox ที่ unchecked:
   ดึง message จาก requiredCheckboxValidation[checkboxKey]

3. ถ้า asserts ยังว่างอยู่ (ไม่มี validator ใน field เลย เช่น search page):
   → ใช้ expectedFailKeys ทั้งหมด: [{byKey: key, exists: true}]
```

**ตัวอย่าง assert ที่ได้:**

```json
[
  { "text": "กรุณากรอกชื่อ", "exists": true },
  { "text": "กรุณาระบุอีเมล", "exists": true }
]
```

หรือถ้า fallback ด้วย expectedFailKeys:

```json
[
  { "byKey": "search_01_expected_fail", "exists": true, "dismiss": true }
]
```

---

### กรณี kind = "success" — Assertion

```
asserts = buildSuccessAsserts()
```

---

### Inject All-Valid Success Case (พิเศษ)

PICT `.invalid.result.txt` มักไม่มีแถวที่ valid ทุก field ครบ  
ระบบจึง inject test case พิเศษเพิ่มเข้าไปเองถ้า:

```
ไม่มี kind==success ใน pairwise_valid_invalid_cases เลย
AND expectedSuccessKeys ไม่ว่าง
```

→ สร้าง 1 case: valid ทุก field + `buildSuccessAsserts()`

---

## Group 2: pairwise_valid_cases

ทุก combination จาก `.valid.result.txt`:

```
kind   = "success" เสมอ
asserts = buildSuccessAsserts() เสมอ
```

---

## Group 3: edge_cases

มี 3 sub-case ที่สร้างหรือไม่สร้างตามเงื่อนไข:

---

### edge_cases_empty_all_fields

**เงื่อนไขสร้าง:** มี assert ที่ได้อย่างน้อย 1 ข้อ

**เงื่อนไข field ค่า:**
```
textFields, dropdowns, datePicker, timePicker → "empty" (ไม่กรอก)
switches → "off" (ค่า default)
checkboxes → "unchecked"
radios → ไม่ระบุ (no selection)
```

**Assertion Priority:**
```
1. มี validatorRules ที่ condition เป็น isEmpty/null
   → ใช้ message ของ rule นั้น (พร้อม count ของจำนวนที่คาดว่าปรากฏ)

2. ถ้าไม่มี validatorRules → scan validatorMessages
   หา text ที่มีคำ: "required", "กรุณา", "โปรด", "ต้อง", "please",
   "cannot be empty", "is required"

3. ถ้ายังว่าง → ใช้ expectedFailKeys

4. ถ้าทั้งหมดว่าง → ไม่สร้าง test case นี้ (return null)
```

```
kind = "failed"
```

---

### edge_cases_boundary_at_max_length

**เงื่อนไขสร้าง:**
```
มี textKey ที่มี "atMax" ใน datasets
AND มี endKey (end button)
```

**ค่าที่กรอก:** `atMax` (ถ้ามี) หรือ `valid` (fallback)

**Assertion:**
```
kind    = "success"
asserts = buildSuccessAsserts()
```

> เหตุผล: atMax = ค่าสูงสุดที่ form ยังรับได้ → ควร submit สำเร็จ

---

### edge_cases_boundary_at_min_length

**เงื่อนไขสร้าง:**
```
มี textKeys
AND มี endKey (end button)
```

**ค่าที่กรอก:** `atMin` (ถ้ามี) หรือ `""` (empty string)

**Assertion:**
```
kind    = "success"
asserts = buildSuccessAsserts()
```

---

## สรุป Assertion Types ที่เกิดขึ้นในโค้ด

| assert object | เงื่อนไข | Flutter code ที่ generate ออกมา |
|---|---|---|
| `{byKey, exists: true}` | widget ปรากฏ | `expect(find.byKey(Key('...')), findsOneWidget)` |
| `{byKey, exists: false}` | widget ไม่ปรากฏ | `expect(find.byKey(Key('...')), findsNothing)` |
| `{byKey, exists: true, dismiss: true}` | dialog ปรากฏแล้วปิด | findsOneWidget + tap TextButton ใน AlertDialog |
| `{text, exists: true}` | global text ปรากฏ | `expect(find.text('...'), findsOneWidget)` |
| `{text, exists: true, count: N}` | text ปรากฏ N ครั้ง | `expect(find.text('...'), findsNWidgets(N))` |
| `{byKey, textEquals: "..."}` | widget มี text ตรงๆ | `expect(widget.data, '...')` |
| `{byKey, textContains: "..."}` | widget มี text บางส่วน | `expect(data.contains('...'), true)` |

---

## Decision Tree สรุป

```
test case
├── pairwise_valid_invalid_cases
│   ├── hasInvalidData = true → kind: failed
│   │   ├── invalidRuleMessages จาก datasets → text assert
│   │   ├── fallback: isEmpty rule จาก manifest → text assert
│   │   ├── unchecked required checkbox → text assert
│   │   └── ถ้าทุกอย่างว่าง → expectedFailKeys → byKey assert
│   └── hasInvalidData = false → kind: success → buildSuccessAsserts()
│
├── pairwise_valid_cases → kind: success → buildSuccessAsserts()
│
└── edge_cases
    ├── empty_all_fields → kind: failed
    │   ├── validatorRules (isEmpty) → text assert + count
    │   ├── validatorMessages (keyword) → text assert
    │   └── fallback: expectedFailKeys → byKey assert
    ├── boundary_at_max → kind: success → buildSuccessAsserts()
    └── boundary_at_min → kind: success → buildSuccessAsserts()
```
