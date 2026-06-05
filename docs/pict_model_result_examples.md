# PICT Model & Result File Examples

ตัวอย่างไฟล์ที่ระบบสร้างขึ้นในแต่ละขั้นตอน โดยแสดงเป็นคู่เปรียบเทียบระหว่าง **valid** และ **invalid**

---

## ภาพรวม

```
output/model_pairwise/
├── <page>.valid.model.txt      ← PICT factors: ใช้แค่ค่า valid
├── <page>.valid.result.txt     ← PICT output: combinations ที่ form ผ่าน
├── <page>.invalid.model.txt    ← PICT factors: รวมค่า invalid/null ด้วย
└── <page>.invalid.result.txt   ← PICT output: combinations ที่ form fail
```

| ไฟล์ | จุดประสงค์ | ผลที่คาดหวังใน Integration Test |
|---|---|---|
| `.valid.*` | ทดสอบ happy path — form submit ผ่าน | ✅ submit สำเร็จ |
| `.invalid.*` | ทดสอบ error path — validation reject | ❌ error message แสดง |

---

## ตัวอย่างที่ 1 — Job Search Page (5 factors)

### 1A. `.model.txt` เปรียบเทียบ

```
job_search_page.valid.model.txt          │  job_search_page.invalid.model.txt
─────────────────────────────────────────┼───────────────────────────────────────────────────────
search_01_keyword_textfield: valid       │  search_01_keyword_textfield: invalid
search_02_category_dropdown:             │  search_02_category_dropdown:
    "IT_&_Tech", "Finance",              │      "null", "IT_&_Tech", "Finance",
    "Marketing", "Engineering",          │      "Marketing", "Engineering",
    "Healthcare", "Education"            │      "Healthcare", "Education"
search_03_type_dropdown:                 │  search_03_type_dropdown:
    "Full-time", "Part-time",            │      "null", "Full-time", "Part-time",
    "Contract", "Freelance",             │      "Contract", "Freelance",
    "Internship"                         │      "Internship"
search_04_salary_min_textfield: valid    │  search_04_salary_min_textfield: invalid
search_05_remote_switch: on, off         │  search_05_remote_switch: on, off
```

**ความแตกต่างหลัก:**

| Factor | valid | invalid |
|---|---|---|
| TextField | `valid` (1 ค่า) | `invalid` (1 ค่า) |
| Dropdown | options จริงเท่านั้น | เพิ่ม `"null"` (ไม่เลือก) |
| Switch | `on, off` | `on, off` (เหมือนกัน — switch ไม่มี invalid state) |

---

### 1B. `.result.txt` เปรียบเทียบ (แสดง 5 rows แรก)

```
job_search_page.valid.result.txt
─────────────────────────────────────────────────────────────────────────────────
search_01_keyword_textfield  search_02_category_dropdown  search_03_type_dropdown  search_04_salary_min_textfield  search_05_remote_switch
valid                        "Finance"                    "Contract"               valid                           off
valid                        "Engineering"                "Full-time"              valid                           on
valid                        "Engineering"                "Freelance"              valid                           off
valid                        "Healthcare"                 "Contract"               valid                           on
valid                        "Finance"                    "Full-time"              valid                           off
... (30 rows รวม)
```

```
job_search_page.invalid.result.txt
─────────────────────────────────────────────────────────────────────────────────
search_01_keyword_textfield  search_02_category_dropdown  search_03_type_dropdown  search_04_salary_min_textfield  search_05_remote_switch
invalid                      "IT_&_Tech"                  "null"                   invalid                         off
invalid                      "null"                       "null"                   invalid                         on
invalid                      "Finance"                    "Internship"             invalid                         on
invalid                      "Marketing"                  "null"                   invalid                         off
invalid                      "Healthcare"                 "Freelance"              invalid                         on
... (43 rows รวม)
```

**สังเกต:**
- valid: TextField columns แสดง `valid` ทุก row — PICT ไม่ combinatorially expand เพราะมีแค่ 1 ค่า
- invalid: Dropdown อาจได้ `"null"` → test case นั้นจะไม่เลือก option ใดเลย
- invalid มี rows มากกว่า เพราะ value space ใหญ่กว่า (dropdown มี `"null"` เพิ่ม)

---

## ตัวอย่างที่ 2 — Clinic Appointment Page (9 factors, มี Radio + FormField Validator)

### 2A. `.model.txt` เปรียบเทียบ

```
clinic_appointment_page.valid.model.txt
─────────────────────────────────────────────────────────────────────────────────
state.appointmentType:             "type_radio_opd", "type_radio_tele"
appt_01_patient_name_textfield:    valid
appt_02_id_card_textfield:         valid
appt_03_phone_textfield:           valid
appt_04_department_dropdown:       "internal_medicine", "surgery", "pediatrics",
                                   "obstetrics", "ophthalmology", "ent", "orthopedics"****
appt_06_date_textfield:            valid
appt_07_time_textfield:            valid
appt_08_insurance_switch:          on, off
appt_09_note_textfield:            valid
```

```
clinic_appointment_page.invalid.model.txt
─────────────────────────────────────────────────────────────────────────────────────────────────
state.appointmentType:             "unselected", "type_radio_opd", "type_radio_tele"
appt_01_patient_name_textfield:    invalid
appt_02_id_card_textfield:         invalid
appt_03_phone_textfield:           invalid
appt_04_department_dropdown:       "internal_medicine", "surgery", "pediatrics",
                                   "obstetrics", "ophthalmology", "ent", "orthopedics"
appt_06_date_textfield:            invalid
appt_07_time_textfield:            invalid
appt_08_insurance_switch:          on, off
appt_09_note_textfield:            invalid
```

**ความแตกต่างหลัก:**

| Factor | valid | invalid | เหตุผล |
|---|---|---|---|
| Radio (`state.appointmentType`) | 2 ค่า (opd, tele) | 3 ค่า (+ `"unselected"`) | Radio ครอบด้วย FormField → ต้องทดสอบกรณีไม่เลือก |
| TextField ทั้งหมด | `valid` (1 ค่า) | `invalid` (1 ค่า) | ค่าจริงมาจาก datasets.json ผ่าน Format A override |
| DatePicker / TimePicker | `valid` (1 ค่า) | `invalid` (1 ค่า) | ใช้ bucket เหมือน TextField — ค่าจริง override ได้ผ่าน constraints |
| Department Dropdown | 7 options เดิม | 7 options เดิม (ไม่มี `"null"`) | department required แต่มี default — ไม่ทดสอบ empty |
| Switch | `on, off` | `on, off` | switch ไม่มี FormField validator — ทั้งสองค่าถือว่า valid |

> **หมายเหตุ:** DatePicker/TimePicker ใช้ `valid`/`invalid` bucket เพื่อให้ Format A constraint override ทำงานได้
> เช่น `appt_06_date_textfield.invalid = 04/06/2026` ใน `.constraints.txt`
> ค่าจริงจะถูก resolve จาก `datasets.json` ตอนสร้าง test steps

---

### 2B. `.result.txt` เปรียบเทียบ (แสดง 5 rows แรก)

```
clinic_appointment_page.valid.result.txt
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
state.appointmentType  appt_01_patient_name  appt_02_id_card  appt_03_phone  appt_04_department    appt_06_date  appt_07_time  appt_08_insurance  appt_09_note
"type_radio_tele"      valid                 valid            valid          "ent"                 valid         valid         on                 valid
"type_radio_opd"       valid                 valid            valid          "ent"                 valid         valid         off                valid
"type_radio_tele"      valid                 valid            valid          "ophthalmology"       valid         valid         off                valid
"type_radio_opd"       valid                 valid            valid          "surgery"             valid         valid         off                valid
"type_radio_opd"       valid                 valid            valid          "internal_medicine"   valid         valid         on                 valid
... (14 rows รวม)
```

```
clinic_appointment_page.invalid.result.txt
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
state.appointmentType  appt_01_patient_name  appt_02_id_card  appt_03_phone  appt_04_department    appt_06_date  appt_07_time  appt_08_insurance  appt_09_note
"unselected"           invalid               invalid          invalid        "internal_medicine"   invalid       invalid       on                 invalid
"type_radio_opd"       invalid               invalid          invalid        "ent"                 invalid       invalid       off                invalid
"type_radio_tele"      invalid               invalid          invalid        "internal_medicine"   invalid       invalid       off                invalid
"unselected"           invalid               invalid          invalid        "obstetrics"          invalid       invalid       off                invalid
"type_radio_opd"       invalid               invalid          invalid        "ophthalmology"       invalid       invalid       on                 invalid
... (21 rows รวม)
```

**สังเกต:**
- valid: ทุก column ของ TextField/DatePicker/TimePicker แสดง `valid` — PICT ไม่ expand เพราะมีแค่ 1 ค่า, ค่าจริงมาจาก datasets ตอนสร้าง steps
- valid: Department dropdown ถูก pairwise กับ Radio (opd/tele) และ Switch (on/off) → 14 combinations ครอบ 7 × 2 = 14
- invalid: `"unselected"` ปรากฏในหลาย row เพราะ PICT ต้องครอบทุก value ของ Radio
- invalid: แต่ละ row มี **อย่างน้อย 1 factor ที่ invalid** — ระบบ guarantee ว่า test case จะ fail validation
- invalid มี rows มากกว่า (21 vs 14) เพราะ Radio มี 3 ค่า (vs 2 ค่าใน valid)

---

## สรุปกฎการสร้าง Model

```
┌──────────────────────┬──────────────────────────────┬────────────────────────────────────┐
│ Widget Type          │ valid.model.txt               │ invalid.model.txt                  │
├──────────────────────┼──────────────────────────────┼────────────────────────────────────┤
│ TextField            │ valid                         │ invalid                            │
│ Dropdown             │ option1, option2, ...         │ "null", option1, option2, ...      │
│ Switch               │ on, off                       │ on, off                            │
│ Checkbox             │ checked, unchecked            │ checked, unchecked                 │
│ Radio (required)     │ key_a, key_b                  │ "unselected", key_a, key_b         │
│ DatePicker/TimePicker│ valid                         │ invalid                            │
└──────────────────────┴──────────────────────────────┴────────────────────────────────────┘
```

> **DatePicker/TimePicker ใช้ bucket (`valid`/`invalid`) เหมือน TextField**
> เพื่อให้ Format A constraint override ทำงานได้
> เช่น `appt_06_date_textfield.invalid = 04/06/2026` → inject ค่าจริงตอนสร้าง `selectDate` step
>
> **`"null"` ใน Dropdown invalid model** หมายถึงไม่เลือก option ใดเลย
> **`"unselected"` ใน Radio invalid model** หมายถึงไม่กดปุ่ม Radio ใดเลย — trigger FormField validator
