# บทที่ 2 — เอกสารและงานวิจัยที่เกี่ยวข้อง (Related Work & Theory)
> สรุปจาก: 6770231021_final.pdf หน้า 18–25

---

## 2.1 แนวคิดและทฤษฎีที่เกี่ยวข้อง

### 2.1.1 Flutter Framework

Flutter คือเครื่องมือสร้าง UI แบบ **Cross-Platform** จากโค้ดชุดเดียวด้วยภาษา Dart

โครงสร้างโปรเจกต์ที่เกี่ยวข้องกับงานวิจัยนี้:

| โฟลเดอร์/ไฟล์ | ความหมาย |
|---|---|
| `android/` | ไฟล์เฉพาะสำหรับ Build/Run บน Android |
| `lib/` | โฟลเดอร์หลักของโค้ด Flutter (entry point = `main.dart`) |
| `pubspec.yaml` | กำหนด Package/Library ของ Dart |
| `README.md` | เอกสารวิธีตั้งค่าและใช้งาน |
| `test/` | เก็บไฟล์ทดสอบทั้งหมดของโปรเจกต์ |

---

### 2.1.2 Widget

Widget = ส่วนประกอบพื้นฐานของ Flutter App ทุกส่วนบนหน้าจอล้วนเป็น Widget

**4 ประเภทของ Widget:**

| ประเภท | คำอธิบาย |
|---|---|
| **Stateless Widget** | ไม่มีสถานะภายใน — แสดงข้อมูลอย่างเดียว |
| **Stateful Widget** | มีสถานะภายใน — เปลี่ยนได้ตาม User/Event |
| **Built-in Layout Widget** | แสดงข้อมูล/รูปภาพ ไม่รับ Input (เช่น `Text`, `Image`) |
| **User Interaction Widget** | รับ Input จาก User ได้ |

**User Interaction Widgets ที่สำคัญ (ตารางที่ 2.1):**

| Widget | คำอธิบาย |
|---|---|
| `Buttons` | ปุ่มสำหรับ Click |
| `TextFormField` | รับข้อความจากแป้นพิมพ์ |
| `Checkbox` | เลือกได้หลายรายการพร้อมกัน |
| `Radio` | เลือกได้เพียง 1 รายการจากกลุ่ม |
| `Switch` | สลับระหว่างสถานะ On/Off |
| `Dropdown` | เลือก 1 รายการจาก List ที่แสดงจากบนลงล่าง |

---

### 2.1.3 Key (คีย์)

Key คือ Property ที่ระบุ Widget ให้มีความเป็นเอกลักษณ์ใน Widget Tree

- ถ้าไม่มี Key → Widget Tree ไม่รู้ว่า Widget ไหนต้องอัปเดตสถานะ
- **งานวิจัยนี้ใช้ Key เป็น Locator หลัก** สำหรับค้นหา Widget ใน Test (`find.byKey()`)
- Widget ที่ไม่มี Key จะถูก **Skip** ในกระบวนการ Test Generation

---

### 2.1.4 การจัดการ Input (Handling User Input)

User Interaction Widget มี **Callback Function** เพื่ออัปเดตสถานะเมื่อ User โต้ตอบ

**ตารางที่ 2.2 — Callback Functions:**

| Callback | Widget | เงื่อนไขการเรียก |
|---|---|---|
| `onPressed` | Button | เมื่อ User คลิก |
| `onChanged` | TextFormField, Dropdown, Checkbox, Radio, Switch | เมื่อค่าเปลี่ยนแปลง |
| `onSubmitted` | TextFormField | เมื่อ User ยืนยันการพิมพ์ผ่านแป้นพิมพ์ |
| `onTap` | GestureDetector, InkWell, ListTile | เมื่อ User Tap ที่ Widget |

---

### 2.1.5 Flutter Testing Framework

ไลบรารีทดสอบหลักของ Dart มี 2 ส่วน:

| Library | ใช้สำหรับ |
|---|---|
| `test` | Unit Testing — ไม่เกี่ยวกับ UI |
| `flutter_test` | Widget Testing + Integration Testing |

**`flutter_test` ที่ใช้ในงานวิจัยนี้:**
- คลาสหลัก: **`WidgetTester`** — แสดงหน้าจอและหา Widget ด้วย Finder
- ใช้ **`Expect`** เพื่อตรวจสอบผลลัพธ์บนหน้าจอ

**ตารางที่ 2.3 — ประเภท Finder:**

| Finder | วิธีค้นหา |
|---|---|
| `find.byType` | ค้นหาตามชนิดคลาส Widget |
| **`find.byKey`** | ค้นหาตาม Key ที่ไม่ซ้ำกัน **(ใช้หลักในงานวิจัยนี้)** |
| `find.text` | ค้นหาตามข้อความที่ตรงกันทุกประการ |
| `find.byWidget` | ค้นหาตาม Widget instance ที่ระบุ |
| `find.byIcon` | ค้นหาตาม Icon บนหน้าจอ |
| `find.byTooltip` | ค้นหาตาม Tooltip |
| `find.descendant` | ค้นหา Widget ที่อยู่ภายใต้ Widget อื่น |
| `find.ancestor` | ค้นหา Widget ที่อยู่เหนือ Widget อื่น |

---

### 2.1.6 Pairwise Testing (การทดสอบแบบแพร์ไวส์)

Pairwise Testing คือเทคนิค Black-Box Test Design ที่กำหนดว่า:

> **ทุก Pair ของค่าจากตัวแปร Input 2 ตัวใดๆ จะต้องถูกครอบคลุมโดย Test Case อย่างน้อย 1 ชุด**

องค์ประกอบหลัก 2 ส่วน:
1. **Factor** = ตัวแปร Input (เช่น Widget แต่ละตัว)
2. **Level** = ชุดของค่าที่เป็นไปได้ของแต่ละ Factor (เช่น valid, invalid, option ต่างๆ)

**ข้อดี:** ลด Combinatorial Explosion — ไม่ต้องทดสอบทุก Combination แต่ยังครอบคลุม Pair ครบ

---

### 2.1.7 PICT (Pairwise Independent Combinatorial Testing)

PICT คือเครื่องมือ Open-Source ของ Microsoft สำหรับสร้าง Pairwise Test Suite

- **Input:** Model File ที่ระบุ Parameter และชุดค่าที่เป็นไปได้
- **Output:** ชุด Combination ที่ครอบคลุมตาม Pairwise Theory (แบบ Tab-delimited)
- ใช้งานได้ทั้งผ่าน Browser และ GitHub
- งานวิจัยนี้ใช้ PICT เป็น Subprocess ใน Phase 3

---

## 2.2 งานวิจัยที่เกี่ยวข้อง

### 2.2.1 Ekakrachawakitti & Suwannasart [2]
**"Generating a Robot Framework Test Script for Web Application Based on Database Constraints"**

**แนวทาง (6 ขั้นตอน):**
1. สกัด HTML Element และ Input Conditions จาก Frontend
2. วิเคราะห์ JSON Object ของ Input และประเภท Operation
3. วิเคราะห์ Entity Class + Database Conditions จาก Backend
4. สร้าง Robot Framework Test Script
5. สร้าง Test Data อ้างอิงจาก Frontend + DB
6. Export Script + Test Data เป็น CSV

**สิ่งที่นำมาต่อยอด:** แนวคิดการ **สกัด Element และ Input Conditions จาก Frontend** นำมาปรับใช้กับ Flutter Widget แทน HTML Element

---

### 2.2.2 Srivichayanun & Suwannasart [3]
**"Generating Test Scripts for Web Based Application"**

**แนวทาง (5 ขั้นตอน):**
1. อ่าน URL แล้วดึง HTML มาวิเคราะห์
2. สร้าง Test Script (ยังไม่มี Test Data)
3. วิเคราะห์ XSD Schema
4. สร้าง Test Data ด้วย **Boundary Value Analysis**
5. เพิ่ม Test Data ลง Test Script

**สิ่งที่นำมาต่อยอด:** แนวคิด **สกัด Input Field และสร้าง Test Data จาก Schema** → ปรับมาใช้กับ Flutter + LLM แทน XSD + BVA

---

### 2.2.3 Tuan Pham [4]
**"CO-STEP: A Prompt Engineering Framework Improving LLM's Response"**

เสนอ Framework สำหรับปรับปรุงคุณภาพ Output จาก LLM โดยใช้ Prompt ที่มีโครงสร้างครบถ้วน 6 องค์ประกอบ:

| องค์ประกอบ | ความหมาย |
|---|---|
| **Context** | ข้อมูลพื้นฐานเพื่อให้ LLM เข้าใจสถานการณ์ |
| **Objective** | เป้าหมาย/ผลลัพธ์ที่ต้องการ |
| **Style** | รูปแบบการเขียน/การนำเสนอที่ต้องการ |
| **Target** | กลุ่มเป้าหมาย เพื่อปรับความซับซ้อนของคำตอบ |
| **Execution** | รูปแบบ Output ที่ต้องการ |
| **Polish** | ประเมิน + แก้ไขผลลัพธ์ตามเกณฑ์คุณภาพ (iterate) |

**สิ่งที่นำมาต่อยอด:** ใช้โครงสร้าง CO-STEP ออกแบบ Prompt สำหรับ Gemini ใน **Phase 2** เพื่อสร้าง Test Data ที่ตรงกับ Validation Rules และป้องกัน Hallucination

---

## สรุปสั้น ๆ (Key Takeaway)

บทที่ 2 วางทฤษฎีพื้นฐาน 3 กลุ่ม:

1. **Flutter Foundation** — Widget 4 ประเภท, Key (Locator หลัก), Callback, WidgetTester + Finder
2. **Pairwise + PICT** — เทคนิคลด Test Case โดยยังครอบ Pair ครบ, ใช้ PICT เป็น Engine
3. **Related Works** — 3 งานที่งานวิจัยนี้ต่อยอด: สกัด Frontend (Ekakrachawakitti), Test Data จาก Schema (Srivichayanun), Prompt Engineering (Tuan Pham)

> **ความแตกต่างจากงานก่อน:** งานวิจัยนี้ไม่ได้สกัดจาก HTML/XSD แต่สกัดจาก **Dart Widget Tree** และใช้ **LLM** สร้าง Test Data แทน DB Constraints หรือ BVA

---

*ไฟล์นี้สร้างเพื่อเป็น context สำหรับเปรียบเทียบกับ ieee_paper.tex*
