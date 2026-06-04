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

## ตัวอย่างที่ 2 — Clinic Appointment Page (9 factors, มี Radio + Constraint)

### 2A. `.model.txt` เปรียบเทียบ

```
clinic_appointment_page.valid.model.txt
─────────────────────────────────────────────────────────────────────────────────
state.appointmentType:             "type_radio_opd", "type_radio_tele"
appt_01_patient_name_textfield:    valid
appt_02_id_card_textfield:         valid
appt_03_phone_textfield:           valid
appt_04_department_dropdown:       "internal_medicine", "surgery", "pediatrics",
                                   "obstetrics", "ophthalmology", "ent", "orthopedics"
appt_06_date_textfield:            "02/06/2026", "15/01/2030"
appt_07_time_textfield:            "09:00", "14:30", "18:00"
appt_08_insurance_switch:          on, off
appt_09_note_textfield:            valid
```

```
clinic_appointment_page.invalid.model.txt
─────────────────────────────────────────────────────────────────────────────────────────────────
state.appointmentType:             "unselected", "type_radio_opd", "type_radio_tele"   ← +1 ค่า (ไม่เลือก)
appt_01_patient_name_textfield:    invalid
appt_02_id_card_textfield:         invalid
appt_03_phone_textfield:           invalid
appt_04_department_dropdown:       "internal_medicine", "surgery", "pediatrics",
                                   "obstetrics", "ophthalmology", "ent", "orthopedics"
appt_06_date_textfield:            "null", "15/01/2001", "02/06/2026", "15/01/2030"    ← +2 ค่า (empty, past date)
appt_07_time_textfield:            "09:00", "14:30", "18:00", "null"                   ← +1 ค่า (empty)
appt_08_insurance_switch:          on, off
appt_09_note_textfield:            invalid
```

**ความแตกต่างหลัก:**

| Factor | valid | invalid | เหตุผล |
|---|---|---|---|
| Radio (`state.appointmentType`) | 2 ค่า (opd, tele) | 3 ค่า (+ `"unselected"`) | invalid ต้องครอบคลุมกรณีไม่เลือก |
| Date TextField | 2 ค่า valid dates | 4 ค่า (+ `"null"`, past date) | ทดสอบ empty + date range validation |
| Time TextField | 3 ค่า valid times | 4 ค่า (+ `"null"`) | ทดสอบ empty time |
| Department Dropdown | options เดิม | options เดิม (ไม่มี `"null"`) | department required แต่มี default |

---

### 2B. `.result.txt` เปรียบเทียบ (แสดง 5 rows แรก)

```
clinic_appointment_page.valid.result.txt
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
state.appointmentType  appt_01_patient_name  appt_02_id_card  appt_03_phone  appt_04_department    appt_06_date  appt_07_time  appt_08_insurance  appt_09_note
"type_radio_tele"      valid                 valid            valid          "internal_medicine"   "02/06/2026"  "09:00"       on                 valid
"type_radio_opd"       valid                 valid            valid          "pediatrics"          "15/01/2030"  "09:00"       off                valid
"type_radio_opd"       valid                 valid            valid          "orthopedics"         "02/06/2026"  "09:00"       off                valid
"type_radio_tele"      valid                 valid            valid          "pediatrics"          "15/01/2030"  "18:00"       on                 valid
"type_radio_tele"      valid                 valid            valid          "orthopedics"         "15/01/2030"  "18:00"       off                valid
... (21 rows รวม)
```

```
clinic_appointment_page.invalid.result.txt
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
state.appointmentType  appt_01_patient_name  appt_02_id_card  appt_03_phone  appt_04_department  appt_06_date  appt_07_time  appt_08_insurance  appt_09_note
"type_radio_opd"       invalid               invalid          invalid        "surgery"           "null"        "14:30"       on                 invalid
"unselected"           invalid               invalid          invalid        "internal_medicine" "null"        "18:00"       off                invalid
"type_radio_tele"      invalid               invalid          invalid        "surgery"           "15/01/2001"  "null"        off                invalid
"type_radio_tele"      invalid               invalid          invalid        "ophthalmology"     "15/01/2030"  "18:00"       on                 invalid
"unselected"           invalid               invalid          invalid        "ent"               "02/06/2026"  "null"        on                 invalid
... (30 rows รวม)
```

**สังเกต:**
- valid: ทุก row มีแต่ valid dates และ radio ที่ถูกเลือกเสมอ
- invalid: มีทั้ง `"unselected"` radio, `"null"` date, past date (`"15/01/2001"`)
- invalid แต่ละ row จะมี **อย่างน้อย 1 factor ที่ invalid** — ระบบ guarantee ว่า test case จะ fail validation

---

## สรุปกฎการสร้าง Model

```
┌─────────────────┬──────────────────────────────┬────────────────────────────────────┐
│ Widget Type     │ valid.model.txt               │ invalid.model.txt                  │
├─────────────────┼──────────────────────────────┼────────────────────────────────────┤
│ TextField       │ valid                         │ invalid                            │
│ Dropdown        │ option1, option2, ...         │ "null", option1, option2, ...      │
│ Switch          │ on, off                       │ on, off                            │
│ Checkbox        │ checked, unchecked            │ checked, unchecked                 │
│ Radio (required)│ key_a, key_b                  │ "unselected", key_a, key_b         │
│ Date TextField  │ valid_date1, valid_date2      │ "null", past_date, valid_date1,... │
└─────────────────┴──────────────────────────────┴────────────────────────────────────┘
```

> **หมายเหตุ:** ค่า `"null"` ใน invalid model หมายถึง field นั้นถูกทิ้งว่างหรือไม่ถูก interact
