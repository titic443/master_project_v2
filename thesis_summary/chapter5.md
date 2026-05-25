# บทที่ 5 — การทดสอบและประเมินผล (Evaluation)
> สรุปจาก: 6770231021_final.pdf หน้า 81–106

---

## 5.1 สภาพแวดล้อมที่ใช้ทดสอบ

เหมือนกับบทที่ 4 (macOS Sequoia 15.4.1, Flutter 3.27.3, Apple M2 Pro)

---

## 5.2 ขั้นตอนการทดสอบเครื่องมือ

1. เตรียมไฟล์ Dart ของ Frontend ที่ต้องการทดสอบ
2. ป้อน path ไฟล์ Frontend ไปยังเครื่องมือ
3. ป้อน path ไฟล์ Constraint (ถ้ามี)
4. ป้อน path สำหรับเก็บไฟล์ Output
5. กดปุ่ม "สร้าง Test Script"

---

## 5.3 กรณีศึกษา 3 กรณี (3 แอปจริง × 2 หน้า = 6 Screen)

---

### 5.3.1 Case Study 1: แอปนัดหมายแพทย์ (Medical Appointment)

#### หน้า 1 — Appointment Booking (POST)

| Key | Widget | Validators |
|---|---|---|
| `appt_01_patient_name_textfield` | TextFormField | required, กรุณากรอกชื่อ-นามสกุล |
| `appt_02_id_card_textfield` | TextFormField | required, number, ต้องมี 13 หลัก |
| `appt_03_phone_textfield` | TextFormField | required, phone, เบอร์ไม่ถูกต้อง |
| `appt_04_department_dropdown` | DropdownButtonFormField | options: อายุรกรรม/ศัลยกรรม/กุมารเวชศาสตร์/สูติ-นรีเวช/จักษุวิทยา/หูคอจมูก/กระดูกและข้อ |
| `appt_05_type_radio_opd` | Radio | value: มาด้วยตนเอง (OPD) |
| `appt_05_type_radio_tele` | Radio | value: พบแพทย์ออนไลน์ |
| `appt_06_date_textfield` | TextFormField | required, date (2000–2031) |
| `appt_07_time_textfield` | TextFormField | required, time slot |
| `appt_08_insurance_switch` | Switch | on/off, not required |
| `appt_09_note_textfield` | TextFormField | not required |
| `appt_10_confirm_button` | ElevatedButton | — |

**ผลลัพธ์:** 52 test cases — 28 invalid / 21 valid / 3 edge

#### หน้า 2 — Appointment Search (GET)

| Key | Widget | Validators |
|---|---|---|
| `search_01_patient_name_textfield` | TextFormField | not required |
| `search_02_end_button` | ElevatedButton | — |

**ผลลัพธ์:** 6 test cases — 2 invalid / 1 valid / 3 edge

---

### 5.3.2 Case Study 2: แอปประกาศหางาน (Job Listing)

#### หน้า 1 — Job Posting (POST)

| Key | Widget | Validators |
|---|---|---|
| `job_01_title_textfield` | TextFormField | required |
| `job_02_company_textfield` | TextFormField | required |
| `job_03_location_textfield` | TextFormField | required |
| `job_04_category_dropdown` | DropdownButtonFormField | options: IT&Tech/Finance/Marketing/Engineering/Healthcare/Education |
| `job_05_type_dropdown` | DropdownButtonFormField | options: Full-time/Part-time/Contract/Freelance/Internship |
| `job_06_exp_dropdown` | DropdownButtonFormField | options: Entry Level/Junior/Mid-Level/Senior |
| `job_07_salary_min_textfield` | TextFormField | required, number only |
| `job_08_salary_max_textfield` | TextFormField | required, number only |
| `job_09_desc_textfield` | TextFormField | required, อย่างน้อย 20 ตัวอักษร |
| `job_10_skill_textfield` | TextFormField | required, อย่างน้อย 20 ตัวอักษร |
| `job_11_remote_switch` | Switch | on/off, not required |
| `appt_12_jobs_button` | ElevatedButton | — |

**ผลลัพธ์:** 64 test cases — 31 invalid / 30 valid / 3 edge

#### หน้า 2 — Job Search (GET)

| Key | Widget | Validators |
|---|---|---|
| `search_01_keyword_textfield` | TextFormField | not required |
| `search_02_category_dropdown` | DropdownButtonFormField | options: IT&Tech/Finance/Marketing/Engineering/Healthcare/Education |
| `search_03_type_dropdown` | DropdownButtonFormField | options: Full-time/Part-time/Contract/Freelance/Internship |
| `search_04_salary_min_textfield` | TextField | number only, not required |
| `search_05_remote_switch` | Switch | on/off, not required |
| `search_06_end_button` | ElevatedButton | — |

**ผลลัพธ์:** 63 test cases — 30 invalid / 30 valid / 3 edge

---

### 5.3.3 Case Study 3: แอปประกาศอสังหาริมทรัพย์ (Real Estate)

#### หน้า 1 — Property Posting (POST)

| Key | Widget | Validators |
|---|---|---|
| `prop_01_title_textfield` | TextFormField | required |
| `prop_02_type_dropdown` | DropdownButtonFormField | options: Condo/House/Townhouse/Land/Commercial |
| `prop_03_location_textfield` | TextFormField | required (จังหวัด) |
| `prop_04_district_textfield` | TextFormField | required (เขต) |
| `prop_05_price_textfield` | TextFormField | required, number, ราคาขั้นต่ำ 100,000 บาท |
| `prop_06_bedrooms_dropdown` | DropdownButtonFormField | options: Studio/1/2/3/4+ |
| `prop_07_bathrooms_dropdown` | DropdownButtonFormField | options: Studio/1/2/3/4+ |
| `prop_08_area_textfield` | TextFormField | required, decimal |
| `prop_09_floor_textfield` | TextFormField | required, decimal |
| `prop_10_furnished_switch` | Switch | on/off, not required |
| `prop_11_desc_textfield` | TextFormField | not required |
| `prop_12_contact_textfield` | TextFormField | required |
| `search_13_end_button` | ElevatedButton | — |

**ผลลัพธ์:** 55 test cases — 27 invalid / 25 valid / 3 edge

#### หน้า 2 — Property Search (GET)

| Key | Widget | Validators |
|---|---|---|
| `search_01_location_textfield` | TextFormField | not required |
| `search_02_type_textfield` | DropdownButtonFormField | not required |
| `search_03_bedrooms_textfield` | DropdownButtonFormField | options: Studio/1/2/3/4+ |
| `search_04_min_price_textfield` | TextField | number only, not required |
| `search_05_max_price_textfield` | TextField | number only, not required |
| `search_06_min_area_textfield` | TextField | decimal, not required |
| `search_07_furnished_switch` | Switch | on/off, not required |
| `search_08_end_button` | ElevatedButton | — |

**ผลลัพธ์:** 55 test cases — 27 invalid / 25 valid / 3 edge

---

## 5.4 สรุปผลการทดสอบ

### Test Case Breakdown (ตารางรวม)

| App | Screen | Invalid | Valid | Edge | รวม |
|---|---|---|---|---|---|
| Medical Appt. | Booking | 28 | 21 | 3 | **52** |
| Medical Appt. | Search | 2 | 1 | 3 | **6** |
| Job Listing | Posting | 31 | 30 | 3 | **64** |
| Job Listing | Search | 30 | 30 | 3 | **63** |
| Real Estate | Posting | 27 | 25 | 3 | **55** |
| Real Estate | Search | 27 | 25 | 3 | **55** |

### Statement Coverage (ตาราง 5.1–5.3)

| App | Screen | ไฟล์ | บรรทัดที่ผ่าน / ทั้งหมด | Coverage |
|---|---|---|---|---|
| Medical Appt. | Booking | `clinic_appointment_page.dart` | 166 / 173 | **96.0%** |
| Medical Appt. | Search | `clinic_search_page.dart` | 141 / 154 | **91.6%** |
| Job Listing | Posting | `job_post_page.dart` | 161 / 172 | **93.6%** |
| Job Listing | Search | `job_search_page.dart` | 223 / 239 | **93.3%** |
| Real Estate | Posting | `property_post_page.dart` | 169 / 175 | **96.6%** |
| Real Estate | Search | `property_search_page.dart` | 233 / 250 | **93.2%** |

> **ทุก Screen ได้ Statement Coverage > 91%** โดยไม่ต้องเขียน Test เอง

**สรุปผลรายกรณีศึกษา:**
- **Case 1 (Medical):** สร้าง script ครบทุก input field ในขอบเขต, data ตรงกับ validator conditions
- **Case 2 (Job):** มี cross-field validation (salary range) → Pairwise adapt ได้ถูกต้อง
- **Case 3 (Real Estate):** Screen ที่มี complexity ใกล้เคียงกัน → test case count เสถียร (55 ทั้งคู่)

---

## 5.5 การติดตั้งเครื่องมือ

1. **Download** zip จาก GitHub Releases:
   `flutter_test_gen_v1.0.0.zip`
2. **Extract** ลงใน Directory ของ Flutter Project ที่ต้องการ
3. **Build Docker image:**
   ```bash
   docker build -t flutter_test_gen .
   ```
4. **รัน Docker container** → สร้าง image ของเครื่องมือ

---

## 5.6 การเรียกใช้งานเครื่องมือ

1. รันไฟล์ `run_tool.sh`:
   ```bash
   bash run_tool.sh
   ```
2. ดู log → เครื่องมือพร้อมใช้งานผ่าน Web Browser
3. เปิด Browser → ใช้งาน Tool UI (4 ส่วน: frontend file / constraint / output / generate)

---

## สรุปสั้น ๆ (Key Takeaway)

บทที่ 5 พิสูจน์ว่าเครื่องมือทำงานได้จริงกับ **3 แอป × 2 หน้า = 6 Screen** โดย:

- **Coverage > 91% ทุก Screen** — สูงสุด 96.6% (Real Estate Posting) แม้มี Widget เยอะ
- **Pairwise ปรับตัวได้** กับทั้ง POST form ที่ซับซ้อน (64 cases) และ Search form ที่เรียบง่าย (6 cases)
- **Widget diversity:** TextFormField, Dropdown, Radio, Switch ครอบคลุมใน 3 domains ที่ต่างกัน
- **Key insight:** Screen ที่มี Widget count ใกล้กัน → test case count เสถียร (Real Estate ทั้งสองหน้าได้ 55 เท่ากัน)
- **Deploy:** Docker + `run_tool.sh` + Web Browser — ไม่ต้องติดตั้ง Dependencies เพิ่ม

---

*ไฟล์นี้สร้างเพื่อเป็น context สำหรับเปรียบเทียบกับ ieee_paper.tex*
