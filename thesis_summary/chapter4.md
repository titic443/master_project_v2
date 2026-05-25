# บทที่ 4 — การออกแบบและพัฒนาเครื่องมือ (Tool Design & Implementation)
> สรุปจาก: 6770231021_final.pdf หน้า 48–80

---

## 4.1 การออกแบบเครื่องมือ

### 4.1.1 Use Case Diagram

ระบบมี 9 Use Cases ที่นักพัฒนาโต้ตอบด้วย:

| # | Use Case | คำอธิบาย |
|---|---|---|
| 1 | ป้อนที่อยู่ไฟล์ Frontend | นักพัฒนาเลือก `.dart` file → สกัด Metadata |
| 2 | ป้อนที่อยู่ Output | นักพัฒนาระบุ path สำหรับเก็บไฟล์ผลลัพธ์ |
| 3 | ป้อนที่อยู่ Constraint File | นักพัฒนาเลือก `.constraints.txt` (optional) |
| 4 | สร้าง Test Script | แปลง test_data.json → Dart test file |
| 5 | ทดสอบ Test Script | รัน test script ผ่าน Mobile Emulator |
| 6 | สร้างไฟล์ Manifest | สกัด Widget Metadata → `manifest.json` |
| 7 | สร้างไฟล์ข้อมูลจำลอง | ส่ง Prompt → LLM → `datasets.json` |
| 8 | สร้างไฟล์ผลลัพธ์ Pairwise | เรียก PICT → `result.txt` |
| 9 | สร้างไฟล์ข้อมูลทดสอบ | Merge ทุกอย่าง → `test_data.json` |

---

### 4.1.2 Activity Diagrams (8 แผนภาพ)

#### 4.1.2.1 นำเข้าและวิเคราะห์ไฟล์ Frontend
- นักพัฒนาป้อน path → ตรวจสอบชนิดไฟล์
- ถ้าถูกต้อง → สกัด Widget ที่รองรับ:
  - **Selection:** Dropdown, Radio, Checkbox, Switch
  - **Input:** TextFormField, DatePicker, TimePicker
  - **Button:** Button
  - **Display:** Text, SnackBar
- ถ้าผิดหรือไม่พบ Widget → แสดง error message

#### 4.1.2.2 นำเข้าและวิเคราะห์ Constraint File
- Optional — ถ้าไม่ป้อน → ข้ามขั้นตอน สร้าง test cases ต่อได้เลย
- ถ้าป้อนและ path ถูก → สร้าง Pairwise test cases พร้อม constraints
- ถ้า path ผิด → แสดง error ให้ป้อนใหม่

#### 4.1.2.3 เลือกที่อยู่ Output
- นักพัฒนาป้อน path → เครื่องมือสร้างไฟล์ output อัตโนมัติ
- ถ้าไม่ระบุ → ใช้ default path

#### 4.1.2.4 สกัด Metadata (Manifest)
- สกัด Widget ที่มี Key เท่านั้น
- Widget ไม่มี Key → ข้าม (ไม่รวมใน manifest)
- ค้นหา Cubit/State files เพื่อใช้สร้าง BlocProvider ในขั้นตอนถัดไป

#### 4.1.2.5 สร้างชุดข้อมูลจำลองด้วย LLM
- อ่าน Metadata จาก manifest → filter เฉพาะ TextFormField
- จัดเตรียม Prompt → ส่ง API → รับ Response → สร้าง `datasets.json`

#### 4.1.2.6 สร้าง Pairwise Test Cases
- อ่าน Metadata จาก manifest → ระบุ Factors และ Levels
- เตรียม invalid model + valid model → เรียก PICT
- สร้างกรณีทดสอบ Pairwise

#### 4.1.2.7 สร้างข้อมูลทดสอบ (test_data.json)
- รวม: Manifest + datasets.json + PICT result
- สร้าง `test_data.json` (source + datasets + cases)

#### 4.1.2.8 สร้าง Dart Test Script
- อ่าน `test_data.json` → Map ข้อมูลทดสอบกับ Flutter test commands
- Output: `<page>_test.dart`

---

### 4.1.3 Package Diagram

โครงสร้างแบ่งออกเป็น **2 Package หลัก:**

```
┌─────────────────────────────────────────────────┐
│                    View Package                 │
│  (หน้าต่าง UI, รับ Input จากนักพัฒนา)           │
└─────────────────────────┬───────────────────────┘
                          │
┌─────────────────────────▼───────────────────────┐
│                   Domain Package                │
│                                                 │
│  ┌──────────────┐  ┌─────────────┐              │
│  │  Controller  │  │  Extractor  │              │
│  │ (Pipeline-   │  │ (UiManifest-│              │
│  │  Controller) │  │  Extractor) │              │
│  └──────────────┘  └─────────────┘              │
│                                                 │
│  ┌──────────────────────────────────────────┐   │
│  │              Generator                   │   │
│  │  - DatasetGenerator (LLM)               │   │
│  │  - GeneratorPict (PICT)                 │   │
│  │  - TestDataGenerator (JSON merge)       │   │
│  │  - CoverageGenerator (run + coverage)   │   │
│  │  - TestScriptGenerator (JSON → Dart)    │   │
│  └──────────────────────────────────────────┘   │
└─────────────────────────────────────────────────┘
```

**รายละเอียดแต่ละ Package:**

| Package | Class | หน้าที่ |
|---|---|---|
| **View** | UIView | แสดงหน้าต่าง, รับ Input ส่งต่อไป Domain |
| **Controller** | PipelineController | รับคำสั่งจาก View, ควบคุม Pipeline ทั้งหมด |
| **Extractor** | UiManifestExtractor | สกัด Metadata จาก `.dart` → `manifest.json` |
| **Generator** | DatasetGenerator | สร้าง `datasets.json` ผ่าน LLM API |
| **Generator** | GeneratorPict | สร้าง PICT model + เรียก PICT subprocess |
| **Generator** | TestDataGenerator | Merge → `test_data.json` |
| **Generator** | CoverageGenerator | รัน test + วัด Statement Coverage |
| **Generator** | TestScriptGenerator | แปลง `test_data.json` → Dart test file |

---

### 4.1.4 Sequence Diagrams (8 แผนภาพ)

**Flow ของแต่ละ Sequence Diagram:**

| แผนภาพ | Actors | สรุป |
|---|---|---|
| 4.1.4.1 | Dev → UIView → PipelineController → UiManifestExtractor | ป้อน Frontend file → ตรวจสอบ → สกัด Widget |
| 4.1.4.2 | Dev → UIView → PipelineController → GeneratorPict | ป้อน Constraint file → ตรวจ syntax |
| 4.1.4.3 | Dev → UIView → PipelineController → TestScriptGenerator | ป้อน Output path → สร้างชื่อไฟล์ |
| 4.1.4.4 | Dev → UIView → PipelineController → UiManifestExtractor | กดสร้าง → สกัด class/key/validator/options → `manifest.json` |
| 4.1.4.5 | Dev → UIView → PipelineController → DatasetGenerator | สกัด TextFormField → Prompt → Gemini API → `datasets.json` |
| 4.1.4.6 | Dev → UIView → PipelineController → TestDataGenerator → GeneratorPict | ดึงข้อมูลจากทุก step → PICT → `test_data.json` |
| 4.1.4.7 | Dev → UIView → PipelineController → TestScriptGenerator | อ่าน test_data → Map commands → Dart script |
| 4.1.4.8 | Dev → UIView → PipelineController → CoverageGenerator | กด Run → รัน test → แสดง Coverage |

---

## 4.2 การพัฒนาเครื่องมือ

### 4.2.1 Development Environment

**Hardware:**
- MacBook Notebook
- CPU: Apple M2 Pro
- RAM: 16 GB
- GPU: 16 Cores

**Software:**

| Component | Version |
|---|---|
| OS | macOS Sequoia 15.4.1 |
| IDE | Visual Studio Code 1.109.0 |
| Language | Dart 3.6.1 |
| Framework | Flutter 3.27.3 |

---

### 4.2.2 โครงสร้าง UI (4 ส่วนหลัก)

#### ส่วนที่ 1 — นำเข้าไฟล์ Frontend
| สถานการณ์ | ผลลัพธ์ |
|---|---|
| ไฟล์ถูกต้อง + พบ Widget | แสดงข้อความสำเร็จ + จำนวน Widget |
| ไฟล์ถูกต้อง แต่ไม่พบ Widget ที่รองรับ | แสดงแจ้งเตือน "ไม่พบ Widget ในขอบเขต" |
| ไฟล์ไม่ใช่ `.dart` | แสดงแจ้งเตือน "ชนิดไฟล์ไม่ถูกต้อง" |

#### ส่วนที่ 2 — นำเข้า Constraint File (Optional)
| สถานการณ์ | ผลลัพธ์ |
|---|---|
| ไฟล์ถูกต้อง + Syntax ถูก | แสดงข้อความนำเข้าสำเร็จ |
| ไฟล์ถูกต้อง แต่ Syntax ผิด | แสดงแจ้งเตือน "ผิดกฎเกณฑ์การเขียน" |
| ไฟล์ไม่ใช่ `.txt` | แสดงแจ้งเตือน "ชนิดไฟล์ไม่ถูกต้อง" |

#### ส่วนที่ 3 — เลือก Output Path
- ถ้าไม่ระบุ → ใช้ **default path** อัตโนมัติ

#### ส่วนที่ 4 — ปุ่ม Generate
| สถานการณ์ | สถานะปุ่ม |
|---|---|
| นำเข้า Frontend สำเร็จ + ไม่ได้เลือก Constraint option | **พร้อมกด** |
| เลือก Constraint option แต่ยังไม่ได้นำเข้าไฟล์ | **ไม่อนุญาตให้กด** (disabled) |
| กด Generate สำเร็จ | แสดงข้อความ "สร้าง Test Script สำเร็จ" |

---

### 4.2.3 Output Files ที่สร้างขึ้น

เมื่อ Generate สำเร็จ จะได้ไฟล์ทั้งหมด 5 ไฟล์:

```
output/
├── <page>.manifest.json       ← Widget metadata
├── <page>.datasets.json       ← LLM-generated test values
├── <page>.invalid.model.txt   ← PICT invalid model
├── <page>.valid.model.txt     ← PICT valid model
├── <page>.invalid.result.txt  ← PICT pairwise result (invalid)
├── <page>.valid.result.txt    ← PICT pairwise result (valid)
├── <page>.test_data.json      ← Merged test plan
└── <page>_test.dart           ← Flutter test script (ready to run)
```

---

## สรุปสั้น ๆ (Key Takeaway)

บทที่ 4 นำ Methodology จากบทที่ 3 มาสร้างจริงใน 2 มิติ:

1. **Design (UML):** Use Case 9 รายการ, Activity Diagram 8 แผนภาพ, Package Diagram 2 ระดับ (View + Domain), Sequence Diagram 8 แผนภาพ — แสดง Object-Oriented Design ที่ชัดเจน
2. **Implementation:** Dart 3.6.1 + Flutter 3.27.3, บน macOS M2 Pro — UI มี 4 ส่วน: input frontend / input constraints / output path / generate button พร้อม validation และ error messages ทุก edge case

> **Class หลักที่สำคัญ:** `PipelineController` เป็น Orchestrator ที่รับคำสั่งจาก UIView และเรียก Class ใน Domain ตามลำดับ Pipeline

---

*ไฟล์นี้สร้างเพื่อเป็น context สำหรับเปรียบเทียบกับ ieee_paper.tex*
