# Employee Survey Page - PICT Constraints Guide

## ภาพรวม

ไฟล์นี้อธิบาย PICT constraints สำหรับ `employee_survey_page.dart` พร้อมตัวอย่างการใช้งาน

## Form Fields Summary

| Factor Name | Widget Key | Values | Description |
|-------------|-----------|--------|-------------|
| `employee_02_id_textfield` | Employee ID | valid, invalid | รหัสพนักงาน (EMP-12345) |
| `employee_03_department_dropdown` | Department | Engineering, Sales, HR, Marketing | แผนก |
| `employee_04_email_textfield` | Email | valid, invalid | อีเมล |
| `employee_05_years_textfield` | Years | valid, invalid | จำนวนปีที่ทำงาน (0-50) |
| `employee_06_rating_formfield` | Rating | rating_poor_radio, rating_fair_radio, rating_excellent_radio | ความพึงพอใจ |
| `employee_07_recommend_checkbox` | Recommend | checked, unchecked | แนะนำบริษัท (required) |
| `employee_08_training_checkbox` | Training | checked, unchecked | สนใจ training (optional) |

## Business Logic Rules

### Rule 1: Satisfaction Rating vs Recommend Company

**กฎ:** ถ้าความพึงพอใจต่ำ (Poor) ไม่ควร recommend บริษัท

```pict
IF [employee_06_rating_formfield] = "rating_poor_radio"
   THEN [employee_07_recommend_checkbox] = "unchecked";
```

**ตัวอย่าง Test Cases ที่ถูกสร้าง:**
- ✅ Rating=Poor, Recommend=unchecked → Valid
- ❌ Rating=Poor, Recommend=checked → ถูก filter ออกโดย PICT

---

**กฎ:** ถ้าความพึงพอใจสูง (Excellent) ควร recommend บริษัท

```pict
IF [employee_06_rating_formfield] = "rating_excellent_radio"
   THEN [employee_07_recommend_checkbox] = "checked";
```

**ตัวอย่าง Test Cases ที่ถูกสร้าง:**
- ✅ Rating=Excellent, Recommend=checked → Valid
- ❌ Rating=Excellent, Recommend=unchecked → ถูก filter ออกโดย PICT

### Rule 2: Invalid Data Combinations

**กฎ:** ถ้า Employee ID ไม่ถูกต้อง Email ก็ควรไม่ถูกต้องด้วย

```pict
IF [employee_02_id_textfield] = "invalid"
   THEN [employee_04_email_textfield] = "invalid";
```

**เหตุผล:**
- ป้องกัน test case ที่มี ID ผิดแต่ email ถูก (ซึ่งไม่น่าจะเกิดขึ้นจริง)
- ลดจำนวน test cases ที่ไม่จำเป็น

**ตัวอย่าง Test Cases:**
- ✅ ID=invalid, Email=invalid → Valid combination
- ❌ ID=invalid, Email=valid → ถูก filter ออก

### Rule 3: Department-specific Training Interest

**กฎ 3.1:** Engineering department ต้องสนใจ training

```pict
IF [employee_03_department_dropdown] = "Engineering"
   THEN [employee_08_training_checkbox] <> "unchecked";
```

**กฎ 3.2:** HR department ต้องสนใจ training (เสมอ)

```pict
IF [employee_03_department_dropdown] = "HR"
   THEN [employee_08_training_checkbox] = "checked";
```

**ตัวอย่าง Test Cases:**
- ✅ Department=Engineering, Training=checked → Valid
- ❌ Department=Engineering, Training=unchecked → ถูก filter ออก
- ✅ Department=HR, Training=checked → Valid
- ❌ Department=HR, Training=unchecked → ถูก filter ออก
- ✅ Department=Sales, Training=any → Valid (ไม่มี constraint)

### Rule 4: Valid Data Must Recommend

**กฎ:** ถ้าข้อมูลหลักถูกต้องทั้งหมด ต้อง recommend บริษัท

```pict
IF [employee_02_id_textfield] = "valid"
   AND [employee_04_email_textfield] = "valid"
   THEN [employee_07_recommend_checkbox] = "checked";
```

**เหตุผล:**
- `recommend_checkbox` เป็น required field
- ถ้าข้อมูลถูกต้อง ไม่ควรมี test case ที่ unchecked

### Rule 5: Fair Rating Flexibility

**กฎ:** Rating "Fair" + Recommend ต้องมีข้อมูล valid

```pict
IF [employee_06_rating_formfield] = "rating_fair_radio"
   AND [employee_07_recommend_checkbox] = "checked"
   THEN [employee_02_id_textfield] = "valid";
```

**เหตุผล:**
- Fair rating อยู่กลางๆ อาจ recommend หรือไม่ก็ได้
- แต่ถ้า recommend แล้ว ข้อมูลต้อง valid

## วิธีการใช้งาน

### วิธีที่ 1: Interactive Mode

```bash
dart run tools/flutter_test_generator.dart
```

จากนั้นตอบคำถาม:
```
? UI file to process: lib/demos/employee_survey_page.dart
? Skip AI dataset generation? (y/N): n
? Use PICT constraints? (y/N): y
? Load constraints from:
  ❯ 1. file
    2. manual input
  Select (1-2) [1]: 1
? Constraints file path: output/model_pairwise/employee_survey_page.constraints.txt
? Enable verbose logging? (y/N): n
? Proceed with this configuration? (Y/n): y
```

### วิธีที่ 2: CLI Mode

```bash
dart run tools/flutter_test_generator.dart \
  lib/demos/employee_survey_page.dart \
  --constraints-file=output/model_pairwise/employee_survey_page.constraints.txt
```

## ตรวจสอบผลลัพธ์

### 1. ดู PICT Model (พร้อม Constraints)

```bash
cat output/model_pairwise/employee_survey_page.full.model.txt
```

ตัวอย่างผลลัพธ์:
```
employee_02_id_textfield: valid, invalid
employee_03_department_dropdown: "Engineering", "Sales", "HR", "Marketing"
employee_04_email_textfield: valid, invalid
employee_05_years_textfield: valid, invalid
employee_06_rating_formfield: rating_poor_radio, rating_fair_radio, rating_excellent_radio
employee_07_recommend_checkbox: checked, unchecked
employee_08_training_checkbox: checked, unchecked

# PICT Constraints for Employee Survey Page
# Business Logic Rules

IF [employee_06_rating_formfield] = "rating_poor_radio" THEN [employee_07_recommend_checkbox] = "unchecked";
IF [employee_06_rating_formfield] = "rating_excellent_radio" THEN [employee_07_recommend_checkbox] = "checked";
...
```

### 2. ดู PICT Results (Test Combinations)

```bash
cat output/model_pairwise/employee_survey_page.full.result.txt
```

จะเห็น test combinations ที่ผ่านการ filter ด้วย constraints แล้ว

### 3. นับจำนวน Test Cases

```bash
# ไม่มี constraints
./pict output/model_pairwise/employee_survey_page.full.model.txt | wc -l

# มี constraints (จำนวนน้อยกว่า)
cat output/model_pairwise/employee_survey_page.full.result.txt | wc -l
```

**ผลลัพธ์ที่คาดหวัง:**
- **ไม่มี constraints:** ~100-150 test cases
- **มี constraints:** ~50-80 test cases (ลดลง 30-50%)

## การทดสอบ Constraints

### ตัวอย่าง Test Case ที่ควรมี (Valid Combinations)

1. **Happy Path:**
   - ID=valid, Email=valid, Department=Engineering, Rating=Excellent, Recommend=checked, Training=checked

2. **Validation Error:**
   - ID=invalid, Email=invalid, Department=Sales, Rating=Poor, Recommend=unchecked, Training=unchecked

3. **Fair Rating:**
   - ID=valid, Email=valid, Department=HR, Rating=Fair, Recommend=checked, Training=checked

### ตัวอย่าง Test Case ที่ไม่ควรมี (Filtered by Constraints)

1. ❌ ID=invalid, Email=valid (Rule 2)
2. ❌ Rating=Poor, Recommend=checked (Rule 1)
3. ❌ Rating=Excellent, Recommend=unchecked (Rule 1)
4. ❌ Department=Engineering, Training=unchecked (Rule 3)
5. ❌ Department=HR, Training=unchecked (Rule 3)

## Tips & Best Practices

### 1. ทดสอบ Constraints ก่อนใช้งานจริง

```bash
# ดู error messages จาก PICT
./pict output/model_pairwise/employee_survey_page.full.model.txt
```

ถ้ามี syntax error PICT จะบอก

### 2. เริ่มจาก Constraints น้อยๆ

เริ่มจาก 1-2 constraints แล้วค่อยเพิ่มทีละตัว

### 3. ใช้ Comments เพื่ออธิบาย

```pict
# Rule: Junior employees (< 2 years) should not be in senior roles
IF [employee_05_years_textfield] = "invalid" THEN [employee_03_department_dropdown] <> "HR";
```

### 4. ทดสอบทั้ง Full และ Valid-only Models

- **Full model:** ครอบคลุมทั้ง valid และ invalid
- **Valid-only model:** เฉพาะ happy path

```bash
# Full model
cat output/model_pairwise/employee_survey_page.full.result.txt

# Valid-only model
cat output/model_pairwise/employee_survey_page.valid.result.txt
```

## Advanced: เพิ่ม Constraints เพิ่มเติม

### ตัวอย่างที่ 1: Years of Service Constraints

```pict
# พนักงานใหม่ (< 2 years) ควรมี rating ไม่เกิน Fair
IF [employee_05_years_textfield] = "0" OR [employee_05_years_textfield] = "1"
   THEN [employee_06_rating_formfield] <> "rating_excellent_radio";
```

### ตัวอย่างที่ 2: Email Domain Constraints

```pict
# ถ้า department = Engineering ควรใช้ email domain @engineering.company.com
# (ต้องมีการ customize PICT model ให้รองรับ email domains)
```

## สรุป

PICT Constraints ช่วย:
- ✅ **ลดจำนวน test cases** ที่ไม่สมเหตุสมผล
- ✅ **เพิ่มความน่าเชื่อถือ** ของ test data
- ✅ **สะท้อน business logic** ได้ชัดเจน
- ✅ **ประหยัดเวลา** ในการรัน tests

ลองใช้งานดูได้เลยครับ! 🚀
