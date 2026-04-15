# คู่มือเขียน Constraints สำหรับแต่ละ Widget Type

> ไฟล์ constraints อยู่ใน `tools/constraints/<page_name>.constraints.txt`  
> ดู key จริงได้จาก `output/model_pairwise/<page_name>.invalid.model.txt` หลัง Scan แล้ว

---

## หลักการสำคัญก่อนเขียน

### 1. Key Naming Convention

Widget key ในโปรเจกต์นี้ใช้รูปแบบ:

```
{page_prefix}_{seq}_{description}_{widget_type}
```

| ตัวอย่าง key | ความหมาย |
|---|---|
| `search_01_keyword_textfield` | หน้า search, ลำดับที่ 1, ช่อง keyword, เป็น TextField |
| `search_02_category_dropdown` | หน้า search, ลำดับที่ 2, dropdown category |
| `search_03_type_dropdown` | หน้า search, ลำดับที่ 3, dropdown type |
| `search_05_remote_switch` | หน้า search, ลำดับที่ 5, switch remote |

> **⚠️ ต้องใช้ key ตรงตัว** — ตรวจสอบจาก `output/model_pairwise/<page>.invalid.model.txt` เสมอ

---

### 2. ค่า (Values) แต่ละ Widget Type ใน PICT Model

| Widget Type | ค่าใน PICT Model | ตัวอย่าง |
|---|---|---|
| `TextField` / `TextFormField` | `valid`, `invalid` | `search_01_keyword_textfield: valid, invalid` |
| `DropdownButtonFormField` | ค่าจริงของ option (space → underscore, quoted) | `"null"`, `"Engineering"`, `"IT_&_Tech"` |
| `Switch` / `SwitchListTile` | `on`, `off` | `search_05_remote_switch: on, off` |
| `Checkbox` / `CheckboxListTile` | `checked`, `unchecked` | `agree_terms_checkbox: checked, unchecked` |
| `Radio` | suffix ของ key จริง | `age_10_20_radio`, `age_30_40_radio` |

---

## Format A — Dataset Override (กำหนดค่าจริงของ TextField)

ใช้เพื่อกำหนดว่า `valid` และ `invalid` ของแต่ละ field คือค่าอะไร

### รูปแบบ

```
key = value               ← override slot 'valid'
key.valid = value         ← override slot 'valid' ชัดเจน
key.invalid = value       ← override slot 'invalid'
key.atMin = value         ← override slot atMin (ค่าต่ำสุด)
key.atMax = value         ← override slot atMax (ค่าสูงสุด)
```

### ใช้ได้กับ: TextField / TextFormField เท่านั้น

```txt
# กำหนดค่า valid/invalid ตรงกับ DB จริง
search_01_keyword_textfield.valid   = วิศวกรซอฟต์แวร์
search_01_keyword_textfield.invalid = Software Engineer

search_04_salary_min_textfield.valid   = 30000
search_04_salary_min_textfield.invalid = 0
```

> **หมายเหตุ:** Format A ไม่ต้องมี `;` ลงท้าย และ **ไม่ถูกส่งไปให้ PICT** — ระบบ Dart จัดการเองก่อน generate

---

## Format B — PICT IF/THEN Constraint (กำหนดเงื่อนไขการจับคู่)

ใช้เพื่อบอกว่า "ถ้า field A มีค่า X แล้ว field B ต้องมีค่า Y"

### รูปแบบ (บรรทัดเดียว ลงท้ายด้วย `;`)

```
IF [key_A] = "value_A" THEN [key_B] = "value_B";
IF [key_A] = "value_A" THEN [key_B] <> "value_B";
```

| Operator | ความหมาย |
|---|---|
| `=` | ต้องเท่ากับ |
| `<>` | ต้องไม่เท่ากับ |

---

## วิธีเขียน Constraint แต่ละ Widget Type

### TextField → TextField

```txt
# ถ้า keyword invalid → salary ต้องมีค่า valid (ไม่ให้ทุก field ว่างพร้อมกัน)
IF [search_01_keyword_textfield] = "invalid" THEN [search_04_salary_min_textfield] = "valid";
```

> ค่าของ TextField ใน IF/THEN คือ `"valid"` หรือ `"invalid"` เท่านั้น

---

### Dropdown → Dropdown

```txt
# ถ้าเลือก category = Engineering → employment type ต้องเป็น Freelance
IF [search_02_category_dropdown] = "Engineering" THEN [search_03_type_dropdown] = "Freelance";

# ถ้าเลือก category = IT_&_Tech → type ต้องไม่เป็น Internship
IF [search_02_category_dropdown] = "IT_&_Tech" THEN [search_03_type_dropdown] <> "Internship";
```

> **⚠️ ค่า Dropdown:** ต้องใช้ค่าหลัง space → underscore เช่น `"IT & Tech"` → `"IT_&_Tech"`  
> ตรวจสอบจาก `output/model_pairwise/<page>.invalid.model.txt` บรรทัดของ dropdown นั้น

---

### Dropdown → TextField

```txt
# ถ้าไม่เลือก category (null) → keyword ต้อง valid เพื่อให้ search ได้
IF [search_02_category_dropdown] = "null" THEN [search_01_keyword_textfield] = "valid";
```

---

### TextField → Dropdown

```txt
# ถ้า keyword invalid → category ต้องไม่เป็น null (ต้องมี filter อื่น)
IF [search_01_keyword_textfield] = "invalid" THEN [search_02_category_dropdown] <> "null";
```

---

### Switch → TextField

```txt
# ถ้าเปิด remote switch → keyword ไม่ต้อง valid ก็ได้ (remote เป็น filter แทน)
# กรณีนี้ไม่ต้องเขียน constraint เพราะไม่มีข้อจำกัด

# ถ้าปิด remote switch → keyword ต้อง valid
IF [search_05_remote_switch] = "off" THEN [search_01_keyword_textfield] = "valid";
```

> ค่าของ Switch คือ `"on"` หรือ `"off"`

---

### Switch → Dropdown

```txt
IF [search_05_remote_switch] = "on" THEN [search_03_type_dropdown] = "Freelance";
```

---

### Checkbox → Checkbox

```txt
# ถ้า agree_terms ไม่ได้ check → open_to_work ก็ไม่ควร check
IF [linkedin_10_agree_terms_checkbox] = "unchecked" THEN [linkedin_11_open_to_work_checkbox] = "unchecked";
```

> ค่าของ Checkbox คือ `"checked"` หรือ `"unchecked"`

---

### Checkbox → Dropdown

```txt
# ถ้า open_to_work checked → employment type ต้องไม่เป็น Full-time
IF [linkedin_11_open_to_work_checkbox] = "checked" THEN [linkedin_07_employment_dropdown] <> "Full-time";
```

---

### Radio → TextField

> Radio ใช้ชื่อ key ของ radio option นั้นๆ เช่น `education_phd_radio` คือชื่อ key ของปุ่ม radio

```txt
# ถ้าเลือก education = PhD → ต้องกรอก experience (valid)
IF [state.educationLevel] = "education_phd_radio" THEN [linkedin_06_experience_textfield] = "valid";
```

---

## ขั้นตอนหา Key และ Values ที่ถูกต้อง

1. **Scan** page ผ่าน Web UI ก่อน
2. เปิดไฟล์ `output/model_pairwise/<page_name>.invalid.model.txt`
3. อ่าน key และค่าทั้งหมดจากไฟล์นี้ — นี่คือ key/value ที่ใช้ใน constraint ได้

**ตัวอย่าง model file:**
```
search_01_keyword_textfield: valid, invalid
search_02_category_dropdown: "null", "IT_&_Tech", "Finance", "Marketing", "Engineering", "Healthcare", "Education"
search_03_type_dropdown: "null", "Full-time", "Part-time", "Contract", "Freelance", "Internship"
search_04_salary_min_textfield: valid, invalid
search_05_remote_switch: on, off
```

> ค่าที่ใส่ใน `"..."` ใน model → ต้องใส่ `"..."` ใน constraint ด้วย  
> ค่าที่ไม่มีเครื่องหมาย `"..."` เช่น `valid`, `on` → ใส่ `"..."` ใน constraint ด้วยเหมือนกัน

---

## กฎสำคัญที่ต้องจำ

| กฎ | ตัวอย่างที่ถูกต้อง | ตัวอย่างที่ผิด |
|---|---|---|
| ทุก Format B ต้องลงท้ายด้วย `;` | `IF [...] THEN [...];` | `IF [...] THEN [...]` |
| บรรทัดเดียว ห้ามขึ้นบรรทัดใหม่กลาง constraint | ทั้งหมดอยู่บรรทัดเดียว | แยก 2 บรรทัด |
| ค่า Dropdown ต้องใส่ `"..."` | `= "Engineering"` | `= Engineering` |
| Key ต้องตรงกับใน model file | `search_03_type_dropdown` | `search_04_type_dropdown` |
| Spaces ใน option value → underscore | `"IT_&_Tech"` | `"IT & Tech"` |
| comment ใช้ `#` นำหน้า | `# ความคิดเห็น` | `// ความคิดเห็น` |

---

## ตัวอย่าง Constraints File สมบูรณ์

```txt
# PICT Constraints for job_search_page
# ======================================

# ─── Format A: Dataset Overrides ──────────────────────────────────────────────
search_01_keyword_textfield.valid   = วิศวกรซอฟต์แวร์
search_01_keyword_textfield.invalid = Software Engineer
search_04_salary_min_textfield.valid = 30000

# ─── Format B: PICT IF/THEN Constraints ───────────────────────────────────────
# ถ้าเลือก category Engineering → type ต้องเป็น Freelance (ตรงกับ DB)
IF [search_02_category_dropdown] = "Engineering" THEN [search_03_type_dropdown] = "Freelance";

# ถ้าไม่เลือก category → keyword ต้อง valid
IF [search_02_category_dropdown] = "null" THEN [search_01_keyword_textfield] = "valid";
```
