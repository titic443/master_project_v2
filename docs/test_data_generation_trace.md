# Test Data Generation Trace
## Page: `clinic_appointment_page`

เอกสารนี้แสดงว่า **ข้อมูลอะไรมาจากไหน** ในแต่ละขั้นตอนของการสร้าง test data  
โดยเปรียบเทียบระหว่าง `clinic_appointment_page.valid.result.txt` กับ `clinic_appointment_page.test_data.json`

---

## BLOCK 1 — PICT Factors (Input ที่ส่งให้ PICT)

ข้อมูลที่ดึงมาจาก **manifest scan** ของ UI widgets  
แต่ละ factor คือ widget key และ values คือ token หรือ option จริงของ widget

```
Factor                              Values
----------------------------------------------
state.appointmentType               "type_radio_tele", "type_radio_opd"
appt_01_patient_name_textfield      valid
appt_02_id_card_textfield           valid
appt_03_phone_textfield             valid
appt_04_department_dropdown         "ent", "ophthalmology", "surgery",
                                    "internal_medicine", "obstetrics",
                                    "orthopedics", "pediatrics"
appt_06_date_textfield              valid
appt_07_time_textfield              valid
appt_08_insurance_switch            on, off
appt_09_note_textfield              valid
```

> **หมายเหตุ:**  
> - TextFormField / DatePicker / TimePicker ใช้ token `valid` (valid-only model)  
> - Radio ใช้ key suffix จริง (`type_radio_tele`, `type_radio_opd`)  
> - Dropdown ใช้ value จริงจาก DropdownMenuItem  
> - Switch ใช้ token `on` / `off`

---

## BLOCK 2 — PICT Valid Result (`clinic_appointment_page.valid.result.txt`)

ผลลัพธ์จาก PICT binary: **14 rows** ที่ cover ทุก pairwise combination ของ valid values

```
Row  state.appointmentType    appt_01_patient_name  appt_02_id_card  appt_03_phone  appt_04_department      appt_06_date  appt_07_time  appt_08_insurance  appt_09_note
---  -----------------------  --------------------  ---------------  -------------  ----------------------  ------------  ------------  -----------------  ------------
1    "type_radio_tele"        valid                 valid            valid          "ent"                   valid         valid         on                 valid
2    "type_radio_opd"         valid                 valid            valid          "ent"                   valid         valid         off                valid
3    "type_radio_tele"        valid                 valid            valid          "ophthalmology"         valid         valid         off                valid
4    "type_radio_opd"         valid                 valid            valid          "surgery"               valid         valid         off                valid
5    "type_radio_opd"         valid                 valid            valid          "internal_medicine"     valid         valid         on                 valid
6    "type_radio_tele"        valid                 valid            valid          "internal_medicine"     valid         valid         off                valid
7    "type_radio_opd"         valid                 valid            valid          "ophthalmology"         valid         valid         on                 valid
8    "type_radio_opd"         valid                 valid            valid          "obstetrics"            valid         valid         on                 valid
9    "type_radio_opd"         valid                 valid            valid          "orthopedics"           valid         valid         off                valid
10   "type_radio_opd"         valid                 valid            valid          "pediatrics"            valid         valid         off                valid
11   "type_radio_tele"        valid                 valid            valid          "obstetrics"            valid         valid         off                valid
12   "type_radio_tele"        valid                 valid            valid          "pediatrics"            valid         valid         on                 valid
13   "type_radio_tele"        valid                 valid            valid          "orthopedics"           valid         valid         on                 valid
14   "type_radio_tele"        valid                 valid            valid          "surgery"               valid         valid         on                 valid
```

> token `valid` ยังไม่ใช่ค่าจริง — ต้อง resolve จาก datasets (BLOCK 3)

---

## BLOCK 3 — Datasets (`byKey`) ใน `test_data.json`

ค่าจริงที่ AI (Gemini) สร้างขึ้น และ Format A constraints override  
ใช้สำหรับ resolve token `valid` / `invalid` / `atMin` / `atMax`

```
Field                             valid                                     invalid              invalidRuleMessages          atMin         atMax
--------------------------------  ----------------------------------------  -------------------  ---------------------------  ------------  -------------------------------------------------------
appt_01_patient_name_textfield    ฐิติ ช่างภู่                              รชนิศ มงคลศิวะ       อย่างน้อย 2 ตัวอักษร         ส             กมลวรรณ บุญมีศรีสุขเจริญยิ่งใหญ่ไพศาลอุดมสมบูรณ์พู
appt_02_id_card_textfield         1102000123456                             123456789012         ต้องมี 13 หลัก               ""            1234567890123
appt_03_phone_textfield           0812345678                                12345678             เบอร์โทรไม่ถูกต้อง           12345678      0987654321
appt_06_date_textfield            06/06/2026      [Format A override]       04/06/2026           กรุณาเลือกวันที่นัดหมาย      01/01/2000    01/01/2031
appt_07_time_textfield            12:00           [AI + preserved]          16:59   [Format A]   กรุณาเลือกช่วงเวลา           ""            10:00 - 10:30 น. ช่วงเวลาที่ดีที่สุดสำหรับผู้ป่วยส
appt_09_note_textfield            คนไข้มีอาการปวดศีรษะเล็กน้อย             X                    ""                           ""            คนไข้มีอาการปวดศีรษะเล็กน้อยและมีไข้สูงตลอดทั้งวัน
```

> **[Format A override]** = ค่าที่กำหนดใน `clinic_appointment_page.constraints.txt`  
> **[AI + preserved]** = AI สร้าง valid value, แต่ invalid ถูก override ด้วย Format A

---

## BLOCK 4 — การ Resolve Token → ค่าจริง (Row 1 เป็นตัวอย่าง)

แสดงขั้นตอนที่ **PICT Row 1** ถูกแปลงเป็น test case `pairwise_valid_cases_1`

```
{
  "source": {
    "file": "lib/demos/clinic_appointment_page.dart",
    "pageClass": "ClinicAppointmentPage",
    "cubitClass": "ClinicAppointmentCubit",
    "stateClass": "ClinicAppointmentState",
    "fileCubit": "lib/cubit/clinic_appointment_cubit.dart",
    "fileState": "lib/cubit/clinic_appointment_state.dart"
  },
  "datasets": {
    "defaults": {},
    "byKey": {
  },
  "cases": [
    {
      "tc": "pairwise_invalid_cases_1",
      "kind": "failed",
      "group": "pairwise_invalid_cases",
      "description": "appointmentType: \"unselected\", patient_name: นายทดสอบ ไม่ถูกต้อง, id_card: 123456789012, phone: 08123456, department: medicine\", date: 04/06/2026, time: 16:59, insurance_switch: on, note: A",
      "steps": [
        {
          "enterText": {
            "byKey": "appt_01_patient_name_textfield",
            "dataset": "byKey.appt_01_patient_name_textfield[0].invalid"
          }
        },
        {
          "pump": true
        },
        {
          "enterText": {
            "byKey": "appt_02_id_card_textfield",
            "dataset": "byKey.appt_02_id_card_textfield[0].invalid"
          }
        },
```

---

## BLOCK 5 — Test Case Groups Summary

ใน `test_data.json` มี **38 test cases** แบ่งเป็น 3 กลุ่ม

```
Group                    Kind     Count  Source
-----------------------  -------  -----  -------------------------------------------------------
pairwise_invalid_cases   failed   21     จาก clinic_appointment_page.invalid.result.txt
                                         token invalid → ค่า invalid จาก datasets byKey
pairwise_valid_cases     success  14     จาก clinic_appointment_page.valid.result.txt  (BLOCK 2)
                                         token valid → ค่า valid จาก datasets byKey
edge_cases               mixed    3      สร้างจาก datasets boundary values (atMin / atMax / empty)
-----------------------  -------  -----  -------------------------------------------------------
TOTAL                             38
```

### Edge Cases Detail

```
TC ID                              Kind     Description
---------------------------------  -------  ------------------------------------------
edge_cases_empty_all_fields        failed   ทุก field ว่าง → trigger required validators
edge_cases_boundary_at_max_length  success  ทุก text field ใช้ค่า atMax
edge_cases_boundary_at_min_length  failed   ทุก text field ใช้ค่า atMin (บางตัว invalid)
```

---

## BLOCK 6 — สรุป Data Flow

```
lib/demos/clinic_appointment_page.dart
    │
    ▼ [extract_ui_manifest.dart]
output/manifest/demos/clinic_appointment_page.manifest.json
    │   (widget keys, types, options, validator rules, pickerMetadata)
    │
    ├──▶ [generate_datasets.dart + Gemini AI]
    │        output/test_data/clinic_appointment_page.datasets.json
    │        (valid, invalid, atMin, atMax ต่อ field)
    │
    │    [Format A constraints override — clinic_appointment_page.constraints.txt]
    │        appt_06_date_textfield.valid  = 06/06/2026
    │        appt_06_date_textfield.invalid = 04/06/2026
    │        appt_07_time_textfield.invalid = 16:59
    │
    ├──▶ [generate_test_data.dart + PICT binary]
    │        output/model_pairwise/clinic_appointment_page.invalid.model.txt
    │        output/model_pairwise/clinic_appointment_page.invalid.result.txt  (21 rows)
    │        output/model_pairwise/clinic_appointment_page.valid.model.txt
    │        output/model_pairwise/clinic_appointment_page.valid.result.txt    (14 rows)
    │
    ▼ [generate_test_data.dart — resolve tokens]
output/test_data/clinic_appointment_page.test_data.json
    (38 test cases: 21 invalid + 14 valid + 3 edge)
    │
    ▼ [generate_test_script.dart]
integration_test/clinic_appointment_page_flow_test.dart
```
