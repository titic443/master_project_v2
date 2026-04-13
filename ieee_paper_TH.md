# การสร้างสคริปต์ทดสอบสำหรับแอปพลิเคชัน Flutter โดยใช้เทคนิคการทดสอบแบบแพร์ไวส์

**Titi Changpoo** — ภาควิชาวิศวกรรมคอมพิวเตอร์ คณะวิศวกรรมศาสตร์ จุฬาลงกรณ์มหาวิทยาลัย กรุงเทพฯ ประเทศไทย
**Taratip Suwannasart** — ภาควิชาวิศวกรรมคอมพิวเตอร์ คณะวิศวกรรมศาสตร์ จุฬาลงกรณ์มหาวิทยาลัย กรุงเทพฯ ประเทศไทย

---

## บทคัดย่อ

ในวงจรชีวิตการพัฒนาซอฟต์แวร์ การทดสอบหน่วย (unit testing) เป็นกระบวนการที่สำคัญสำหรับการระบุและแก้ไขข้อบกพร่อง เพื่อเพิ่มความน่าเชื่อถือของซอฟต์แวร์ก่อนส่งมอบ สิ่งนี้มีความสำคัญอย่างยิ่งในโดเมนของแอปพลิเคชันมือถือที่พัฒนาด้วยเฟรมเวิร์ค Flutter ซึ่งมีการเปลี่ยนแปลงความต้องการบ่อยครั้ง แม้ว่าการทดสอบอัตโนมัติจะช่วยลดเวลาการทดสอบโดยรวม แต่นักพัฒนายังคงต้องมีความรู้เฉพาะทางและทุ่มเทความพยายามเริ่มต้นอย่างมากในการสร้างสคริปต์ทดสอบที่มีประสิทธิภาพด้วยภาษา Dart

บทความนี้นำเสนอเครื่องมืออัตโนมัติที่ช่วยให้การสร้างสคริปต์ทดสอบ Flutter เป็นเรื่องง่ายขึ้น โดยการนำเข้าไฟล์ซอร์สโค้ดฝั่งหน้าบ้าน (front-end) ดึงข้อมูลเมตาของ widget (keys, เงื่อนไขการตรวจสอบ และประเภทการจัดการอินพุต) และสร้างข้อมูลทดสอบสังเคราะห์ผ่าน Large Language Model (LLM) กรณีทดสอบถูกสร้างอย่างเป็นระบบโดยใช้เทคนิคการทดสอบแบบแพร์ไวส์ผ่านเครื่องมือ PICT สคริปต์ทดสอบ Dart ที่ได้พร้อมสำหรับการรันในเฟรมเวิร์คการทดสอบของ Flutter

เครื่องมือนี้ถูกประเมินกับแอปพลิเคชันมือถือในโลกจริง 3 แอป ได้แก่ ระบบนัดหมายทางการแพทย์ แอปพลิเคชันรายชื่องาน และแอปพลิเคชันรายชื่ออสังหาริมทรัพย์ และได้ผลการครอบคลุม branch และ line ที่น่าพอใจในทุกกรณี ซึ่งแสดงให้เห็นถึงประสิทธิผลเชิงปฏิบัติของแนวทางที่นำเสนอ

**คำสำคัญ:** Flutter, การสร้างการทดสอบอัตโนมัติ, การทดสอบแบบแพร์ไวส์, Dart, large language model, การทดสอบแอปพลิเคชันมือถือ, PICT

---

## I. บทนำ

อุตสาหกรรมซอฟต์แวร์ทั่วโลกยังคงเติบโตอย่างรวดเร็ว ขับเคลื่อนโดยความต้องการแอปพลิเคชันมือถือที่มีความซับซ้อน มีฟีเจอร์หลากหลาย และต้องรองรับการเปลี่ยนแปลงความต้องการบ่อยครั้ง การรับประกันคุณภาพซอฟต์แวร์ผ่านการทดสอบที่ครอบคลุมจึงเป็นสิ่งจำเป็น แต่การออกแบบกรณีทดสอบด้วยตนเองนั้นใช้เวลามากและต้องการความเชี่ยวชาญเฉพาะทางจากนักพัฒนา

ในเฟรมเวิร์ค Flutter นักพัฒนาเขียนสคริปต์ทดสอบ integration และ widget test ด้วยภาษา Dart เพื่อจำลองการโต้ตอบของผู้ใช้บนส่วนต่อประสานผู้ใช้ (UI) อย่างไรก็ตาม การสร้างสคริปต์เหล่านี้กำหนดให้นักพัฒนาต้อง (1) เข้าใจโครงสร้าง widget และกฎการตรวจสอบในซอร์สโค้ด (2) กำหนดข้อมูลอินพุตที่เหมาะสมซึ่งครอบคลุมเงื่อนไขขอบเขตทั้งที่ถูกต้องและไม่ถูกต้อง และ (3) เรียงลำดับการกระทำการทดสอบอย่างถูกต้อง เครื่องมืออัตโนมัติที่มีอยู่ เช่น Robot Framework และ Playwright ถูกออกแบบมาสำหรับแอปพลิเคชันเว็บและไม่สามารถสร้างสคริปต์ทดสอบเฉพาะของ Flutter ได้โดยตรง

บทความนี้แก้ไขปัญหาเหล่านี้โดยนำเสนอเครื่องมืออัตโนมัติที่:

- **วิเคราะห์** ไฟล์ Flutter front-end (`.dart`) เพื่อดึงข้อมูลเมตาของ widget
- **ใช้** Large Language Model (LLM) (Google Gemini) เพื่อสร้างข้อมูลทดสอบที่สมจริง
- **ประยุกต์ใช้** เทคนิคการทดสอบแบบแพร์ไวส์ผ่าน PICT เพื่อลดจำนวนกรณีทดสอบในขณะที่เพิ่มการครอบคลุมการรวมกันของอินพุตให้สูงสุด
- **ส่งออก** สคริปต์ทดสอบ Dart ที่สามารถรันได้พร้อมสำหรับเฟรมเวิร์คการทดสอบของ Flutter

บทความที่เหลือจัดเรียงดังนี้: ส่วนที่ II ทบทวนงานที่เกี่ยวข้อง ส่วนที่ III อธิบายวิธีการที่นำเสนอ ส่วนที่ IV กล่าวถึงการออกแบบเครื่องมือ ส่วนที่ V นำเสนอผลการประเมิน และส่วนที่ VI สรุปบทความ

---

## II. งานที่เกี่ยวข้อง

### A. การทดสอบ Flutter

Flutter คือ UI toolkit โอเพนซอร์สของ Google สำหรับการสร้างแอปพลิเคชันข้ามแพลตฟอร์มจาก Dart codebase เดียว เฟรมเวิร์คนี้มีไลบรารี `flutter_test` ที่เปิดเผย API ของ `WidgetTester` และชุด Finders ที่หลากหลาย (`find.byKey`, `find.byType` เป็นต้น) สำหรับการค้นหาและโต้ตอบกับ widget ระหว่างการทดสอบ

### B. การสร้างสคริปต์ทดสอบจากไฟล์ Front-End

Ekakrachawakitti เสนอวิธีการสร้างสคริปต์ทดสอบ Robot Framework จากไฟล์ front-end ของเว็บโดยการดึง HTML elements และข้อจำกัดอินพุตจาก database schema Srivichayanun ขยายแนวคิดนี้โดยการนำเข้า XML Schema Definition (XSD) schemas และประยุกต์ใช้ Boundary Value Analysis เพื่อสร้างข้อมูลทดสอบสำหรับแอปพลิเคชันเว็บ งานเหล่านี้กระตุ้นให้มีการปรับใช้เทคนิคการดึงข้อมูลที่คล้ายคลึงกันกับโครงสร้าง widget ที่ใช้ Dart ของ Flutter

### C. การสร้างข้อมูลด้วย LLM

Tuan Pham แสดงให้เห็นว่าการจัดโครงสร้างคำสั่ง (prompt) ของ LLM ด้วยองค์ประกอบที่แตกต่างกัน ได้แก่ context, persona, objective, action, format และ refinement ช่วยเพิ่มคุณภาพของผลลัพธ์ที่สร้างขึ้นอย่างมีนัยสำคัญ กลยุทธ์วิศวกรรม prompt นี้ถูกนำมาใช้ในงานปัจจุบันเพื่อขับเคลื่อนการสร้างข้อมูลทดสอบสังเคราะห์

### D. การทดสอบแบบแพร์ไวส์

การทดสอบแบบแพร์ไวส์ (all-pairs) คือเทคนิคการออกแบบการทดสอบแบบ black-box ที่รับประกันว่าทุกคู่ของค่าพารามิเตอร์อินพุตจะถูกทดสอบโดยอย่างน้อยหนึ่งกรณีทดสอบ ซึ่งช่วยลดการระเบิดแบบ combinatorial ของการครอบคลุมแบบเต็มรูปแบบได้อย่างมาก PICT (Pairwise Independent Combinatorial Testing) คือเครื่องมือโอเพนซอร์สที่ใช้กันอย่างแพร่หลายซึ่งรับไฟล์โมเดลที่อธิบายพารามิเตอร์และระดับ (levels) ของพวกมัน และส่งออกชุดการทดสอบที่ครอบคลุมขั้นต่ำ

---

## III. วิธีการที่นำเสนอ

เครื่องมือที่นำเสนอทำให้กระบวนการสร้างสคริปต์ทดสอบแบบครบวงจรเป็นอัตโนมัติผ่านสี่ขั้นตอนตามลำดับ ดังแสดงในรูปที่ 1

### Phase 1 — ดึงข้อมูล Manifest

เครื่องมือวิเคราะห์แบบ static analysis ทุกไฟล์ `.dart` ภายใต้ไดเรกทอรี `lib/` ของโปรเจกต์ Flutter เป้าหมาย โดยพิจารณาเฉพาะ widget ที่มีคุณสมบัติ `Key` เท่านั้น เนื่องจาก key จำเป็นสำหรับการค้นหา widget ระหว่างการรันทดสอบผ่าน `find.byKey()`

**ระดับ screen (หน้าจอ):** เครื่องมือบันทึกข้อมูลเมตา BLoC/Cubit ที่จำเป็นสำหรับการสร้างสภาพแวดล้อมการทดสอบ ได้แก่:
- `pageClass` — ชื่อคลาส widget ของหน้า UI
- `cubitClass` — คลาส BLoC Cubit สำหรับหน้านั้น
- `stateClass` — คลาส State ที่เชื่อมโยงกับ Cubit
- `fileCubit` — เส้นทางไปยังไฟล์ซอร์สของ Cubit
- `fileState` — เส้นทางไปยังไฟล์ซอร์สของ State

ฟิลด์เหล่านี้ทำให้สคริปต์ทดสอบที่สร้างขึ้นสามารถ import ไฟล์ที่ถูกต้องและสร้าง `BlocProvider` wrapper ได้โดยอัตโนมัติ

**ระดับ widget:** เครื่องมือบันทึก: (i) unique widget key, (ii) ชื่อคลาส widget, (iii) จำนวนเต็ม `sequence` ที่เข้ารหัสตำแหน่งบนล่างของ widget ภายในฟอร์ม (ใช้ใน Phase 3 เพื่อเรียงลำดับขั้นตอนการโต้ตอบ WidgetTester), (iv) รูปแบบตัวอักษรหรือความยาวที่อนุญาตจาก `inputFormatters`, (v) กฎการตรวจสอบและข้อความแสดงข้อผิดพลาดที่วิเคราะห์จาก `validator` callbacks (`validatorRules`) และ (vi) รายการตัวเลือกสำหรับ widget `DropdownButtonFormField` และ `Radio`

ข้อมูลเมตาที่ดึงออกมาจะถูก serialize ลงในไฟล์ `manifest.json` จัดกลุ่มตามชื่อ screen ตารางที่ I แสดงรายการฟิลด์ที่บันทึกต่อ screen และต่อ widget

**ตารางที่ I: ฟิลด์ข้อมูลเมตาในไฟล์ Manifest**

| ฟิลด์ | คำอธิบาย |
|-------|----------|
| **ระดับ Screen (ข้อมูลเมตา BLoC)** | |
| `pageClass` | ชื่อคลาส widget ของหน้า UI |
| `cubitClass` | คลาส BLoC Cubit สำหรับ screen นั้น |
| `stateClass` | คลาส State ที่เชื่อมโยงกับ Cubit |
| `fileCubit` | เส้นทางไปยังไฟล์ซอร์สของ Cubit |
| `fileState` | เส้นทางไปยังไฟล์ซอร์สของ State |
| **ระดับ Widget** | |
| `key` | Unique Flutter widget key |
| `widgetType` | ชื่อคลาส widget |
| `sequence` | ตำแหน่งบนล่างในฟอร์ม (ใช้สำหรับเรียงลำดับขั้นตอนทดสอบ) |
| `inputFormatters` | รูปแบบตัวอักษรและขีดจำกัดความยาวที่อนุญาต |
| `validatorRules` | เงื่อนไขการตรวจสอบและข้อความแสดงข้อผิดพลาด |
| `options` | ตัวเลือกที่ระบุไว้สำหรับ Radio / Dropdown |

### Phase 2 — สร้างชุดข้อมูล (Datasets)

ในขั้นตอนนี้ เครื่องมือจะคัดเฉพาะ widget ประเภท `TextFormField` ออกจาก manifest เท่านั้น widget ประเภท `Dropdown` และ `Radio` ถูกยกเว้น เนื่องจากค่าที่เป็นไปได้ถูกดึงมาจากรายการ `options` ใน Phase 1 โดยตรง

ข้อมูลเมตาที่กรองแล้วจะถูกประกอบเป็น prompt ที่มีโครงสร้าง 5 องค์ประกอบตามแนวทางของ Tuan Pham:

- **Context (บริบท):** `"Test data generator for Flutter form validation."`
- **Target (กลุ่มเป้าหมาย):** สั่งให้โมเดลทำหน้าที่เป็น QA engineer ที่สร้างข้อมูลสำหรับ happy-path และ error-path
- **Objective (วัตถุประสงค์):** กำหนด 5 กฎ ได้แก่ วิเคราะห์ `maxLength`, `inputFormatters` และ `validatorRules`; ข้ามกฎ `isEmpty`/`null` (จัดการแยกใน Phase 3 ด้วย edge cases); สร้างคู่ valid/invalid หนึ่งคู่ต่อกฎที่ไม่ว่างเปล่า; ค่า invalid ต้องยังผ่าน `inputFormatters` เพื่อให้พิมพ์ได้จริง; และส่งออกเป็น JSON
- **Execution (การดำเนินการ):** คำแนะนำทีละขั้นตอนพร้อมตัวอย่าง few-shot 2 ตัวอย่าง เพื่อกำหนดรูปแบบผลลัพธ์และป้องกัน hallucination
- **Style (รูปแบบ):** JSON เท่านั้น ไม่มี markdown, ค่าที่สมจริง, string arrays เท่านั้น

ข้อมูลเมตาของ widget ที่ดึงมาใน Phase 1 จะถูกแนบเป็น input data payload

prompt ถูกส่งไปยัง **Google Gemini 2.5 Flash** ผ่าน Gemini API (HTTP POST) โมเดลส่งคืนไฟล์ `<page>.datasets.json` ที่มีฟิลด์ระดับบนสุดดังนี้:

- **file:** เส้นทางไปยังไฟล์ซอร์ส front-end ที่วิเคราะห์
- **datasets → byKey:** map จาก widget key ของแต่ละ `TextFormField` ไปยัง array ของ object คู่ค่า สร้างหนึ่งคู่ต่อกฎการตรวจสอบที่ไม่ว่างเปล่า แต่ละ object มีห้าฟิลด์:
  - `valid` — ค่าที่ผ่านทุก validation rule และตรงตาม `inputFormatters`
  - `invalid` — ค่าที่ละเมิดกฎเพียงข้อเดียว แต่ยังตรงตาม `inputFormatters` เพื่อให้พิมพ์ได้จริง
  - `invalidRuleMessages` — ข้อความ error ที่ validator จะแสดงเมื่อพบค่า invalid นั้น
  - `atMax` — ค่าที่อยู่ที่ขอบเขตสูงสุดที่อนุญาต (edge-case data)
  - `atMin` — ค่าที่อยู่ที่ขอบเขตต่ำสุดที่อนุญาต (edge-case data)

### Phase 3 — สร้างข้อมูลทดสอบ

โดยใช้ชุดข้อมูล เครื่องมือสร้างไฟล์โมเดล PICT ซึ่งแต่ละ widget ที่ไม่ใช่ปุ่มจะถูก map ไปยัง factor หนึ่งตัว และแต่ละค่าที่แตกต่างกันจะถูก map ไปยัง level หนึ่งระดับ โมเดล 3 รูปแบบถูกสร้างขึ้นอย่างอิสระ:

1. **Valid/Invalid (VI):** factors มีทั้ง valid และ invalid levels; PICT รับประกันว่าทุกคู่ valid-invalid ถูกครอบคลุม
2. **Valid-only (V):** factors มีเฉพาะ valid levels; PICT สร้างกรณีทดสอบ positive-path
3. **Edge:** สาม boundary-value combinations ที่สร้างด้วยตนเอง (อินพุตว่าง, ความยาวสูงสุด, อักขระพิเศษ) ถูกเพิ่มเข้ามา

ก่อนเรียกใช้ PICT หากนักพัฒนาให้ **condition file** ที่เป็นทางเลือก เครื่องมือจะเพิ่มเนื้อหาของมันโดยตรงลงในไฟล์โมเดล PICT เป็นส่วน `[Constraints]` condition file เขียนด้วย PICT constraint syntax (`IF <param> = <value> THEN <param> = <value>;`) และใช้เพื่อเข้ารหัสกฎ business-logic ที่อยู่ใน Cubit layer และมองไม่เห็นจากการ static analysis ของไฟล์ front-end เพียงอย่างเดียว เช่น การจำกัด pairwise engine ให้ factor เดียวมี invalid value ต่อกรณีทดสอบ หรือการแสดง mutual-exclusion dependencies ระหว่างฟิลด์ เครื่องมือตรวจสอบ constraint syntax ก่อนการเพิ่ม หากเกิดข้อผิดพลาดด้าน syntax จะแสดงข้อความ "Invalid Constraint Syntax" และ pipeline จะหยุดทำงาน

จากนั้น PICT จะถูกเรียกใช้เป็น subprocess ครั้งละหนึ่งไฟล์โมเดล (`<page>.full.model.txt` สำหรับ VI และ `<page>.valid.model.txt` สำหรับ V) ผลลัพธ์แบบ tab-delimited (หนึ่งแถวต่อกรณีทดสอบ) จะถูก parse และแต่ละแถวจะถูกประกอบเป็น object กรณีทดสอบพร้อมด้วยขั้นตอนการโต้ตอบ widget และการยืนยัน (assertions) ที่คาดหวัง อาร์เรย์ผลลัพธ์ทั้งสาม (VI, V, Edge) จะถูกรวมเป็นไฟล์ `<page>.test_data.json` ที่มีสาม key ระดับบนสุด:

- **source:** ข้อมูลเมตา BLoC ระดับ screen ที่ถ่ายทอดมาจาก Phase 1 (`pageClass`, `cubitClass`, `stateClass`, `fileCubit`, `fileState`) Phase 4 อ่าน key นี้เพื่อส่งออก `import` statements และสร้าง `BlocProvider` wrapper
- **datasets:** คู่ค่า valid/invalid ที่ผลิตใน Phase 2 เปิดให้เข้าถึงด้วย widget key (`byKey`) Phase 4 อ่าน key นี้เพื่อแปลงค่าจริงเมื่อ render `enterText` calls
- **cases:** รายการของ object กรณีทดสอบที่เรียงลำดับ แต่ละ object มีห้าฟิลด์: `tc` (identifier ที่ unique เช่น `pairwise_valid_invalid_cases_1`), `kind` (`success` หรือ `failed`), `group` (หนึ่งในสาม: `pairwise_valid_invalid_cases`, `pairwise_valid_cases` หรือ `edge_cases`), `steps` และ `asserts`

แต่ละ entry ใน `steps` map ประเภท widget ไปยังคำสั่ง `WidgetTester`: `enterText` (พร้อม `byKey` และ reference ไปยัง dataset) สำหรับ `TextFormField`; `tap` (byKey) แล้ว `tapText` (item label) สำหรับ `DropdownButtonFormField`; `tap` (byKey) สำหรับ `Radio`, `Checkbox` และ `Switch`; และ `pump` หรือ `pumpAndSettle` สำหรับการ refresh UI ขั้นตอน widget จะถูกเรียงลำดับตามค่า `sequence` ที่ดึงมาจากไฟล์ซอร์ส โดย `ElevatedButton` step จะถูกวางเป็นลำดับสุดท้ายเสมอ

แต่ละ entry ใน `asserts` ระบุ string `text` พร้อม flag `exists` (ยืนยันข้อความแสดงข้อผิดพลาดที่มองเห็น) หรือ `byKey` widget identifier พร้อม flag `exists` (ยืนยันการมีอยู่ของ widget ตัวบ่งชี้ความสำเร็จหรือความล้มเหลว)

ตารางที่ II สรุปวิธีที่ประเภท widget แต่ละชนิดถูก map ไปยัง PICT role และคำสั่ง `WidgetTester` ที่สอดคล้องกัน

**ตารางที่ II: Flutter Widget ที่รองรับและการโต้ตอบทดสอบที่สร้างขึ้น**

| Widget | บทบาทใน PICT | คำสั่งทดสอบ |
|--------|-------------|------------|
| `TextFormField` | Factor (N levels) | `enterText` |
| `DropdownButtonFormField` | Factor (enum) | `tap` ×2 |
| `Radio` | Factor (enum) | `tap` |
| `Checkbox` | Factor {on, off} | `tap` |
| `Switch` | Factor {on, off} | `tap` |
| `ElevatedButton` | Trigger (fixed) | `tap` (ลำดับสุดท้าย) |
| `Text` | Assertion target | `find.text` |

### Phase 4 — สร้างสคริปต์ทดสอบ

ไฟล์ `<page>.test_data.json` ที่ผลิตใน Phase 3 จะถูก render เป็นไฟล์ทดสอบ Dart ที่ valid ด้วย syntax ชื่อ `<page>_test.dart` คลาส `TestScriptGenerator` อ่าน key **source** ก่อนเพื่อส่งออก `import` statements สามรายการ (`fileCubit`, `fileState` และไฟล์ซอร์สของหน้า) และประกาศ `BlocProvider<CubitClass>` wrapper ที่ใช้ซ้ำในทุกกรณีทดสอบบน screen เดียวกัน

กรณีทดสอบถูกแบ่งตามฟิลด์ `group` เป็นสาม `group()` blocks ในไฟล์ output: `pairwise_valid_invalid_cases` (VI cases ที่ยืนยันการปฏิเสธฟอร์มเมื่ออินพุตไม่ถูกต้อง), `pairwise_valid_cases` (V cases ที่ยืนยันการส่งข้อมูลสำเร็จเมื่ออินพุตถูกต้อง) และ `edge_cases` (boundary-value cases) แต่ละ entry ใน array `cases` กลายเป็น `testWidgets` block อิสระหนึ่งบล็อกที่ตั้งชื่อตาม identifier `tc` ของมัน block มีโครงสร้างดังนี้:

1. **Setup:** `tester.pumpWidget()` pump `MaterialApp` พร้อมหน้าที่ wrap อยู่ใน `BlocProvider` ที่ประกาศจากข้อมูลเมตา `source`
2. **Interact:** แต่ละ entry ใน `steps` จะถูกแปลงเป็น `WidgetTester` call ตามลำดับ — `enterText` แก้ไขค่าจาก key `datasets`; `tap` และ `tapText` ค้นหา widget ด้วย key หรือข้อความ label; `pump` และ `pumpAndSettle` ซิงค์ UI ระหว่างการโต้ตอบ
3. **Assert:** แต่ละ entry ใน `asserts` จะถูก render เป็น `expect()` call entry แบบ `text` กลายเป็น `expect(find.text('msg'), findsOneWidget)` และ entry แบบ `byKey` กลายเป็น `expect(find.byKey(Key('k')), findsOneWidget)`; matcher สลับระหว่าง `findsOneWidget` และ `findsNothing` ตาม flag `exists`

ขั้นตอน `ElevatedButton` จะเป็นการโต้ตอบสุดท้ายเสมอ ตามด้วย `pumpAndSettle()` เพื่อให้มั่นใจว่าการอัปเดต UI แบบ asynchronous ทั้งหมดเสร็จสมบูรณ์ก่อนที่การยืนยันจะทำงาน

---

## IV. การออกแบบและการพัฒนาเครื่องมือ

### A. ส่วนต่อประสานผู้ใช้ (User Interface)

รูปที่ 2 แสดงหน้าต่างหลักของเครื่องมือ ส่วนต่อประสานผู้ใช้มีสามช่องอินพุตและหนึ่งการกระทำที่ครอบคลุมขั้นตอนการสร้างการทดสอบทั้งหมด:

1. **ไฟล์ Flutter front-end:** ช่องเลือกไฟล์ (file-picker) สำหรับไฟล์ `.dart` ของ screen เป้าหมาย เครื่องมือตรวจสอบประเภทไฟล์และยืนยันว่ามี widget ที่รองรับพร้อม key อย่างน้อยหนึ่งตัว หากประเภทไฟล์ไม่รองรับจะแสดงข้อความ "Invalid File Type" และบล็อกการดำเนินการต่อ
2. **Condition file (ทางเลือก):** ช่องเลือกไฟล์ที่สองสำหรับไฟล์ PICT constraint ที่เป็นทางเลือก เขียนด้วย syntax `IF...THEN...` หากระบุ เครื่องมือตรวจสอบ constraint syntax ก่อนดำเนินการต่อ ไฟล์ที่ผิดรูปแบบจะแสดงข้อความ "Invalid Constraint Syntax"
3. **ไดเรกทอรีผลลัพธ์:** ช่องเลือกไดเรกทอรีที่กำหนดโฟลเดอร์ปลายทางสำหรับ artefacts ที่สร้างขึ้นทั้งหมด ได้แก่ `manifest.json`, `datasets.json`, `test_data.json` และ `<page>_test.dart`
4. **ปุ่ม Generate:** การคลิก "Generate" เรียกใช้ pipeline สี่ขั้นตอนทั้งหมด สถานะความคืบหน้าและข้อความแสดงข้อผิดพลาดใดๆ จะแสดงแบบ inline ในหน้าต่างหลัก

### B. การติดตั้ง

ต้องมีสิ่งที่จำเป็นต่อไปนี้ก่อนใช้เครื่องมือ:

1. **Docker** (v28.0.0 ขึ้นไป): เริ่มต้น back-end container ซึ่งโฮสต์บริการ FastAPI (v0.114.1) ที่เปิดเผย REST endpoints สำหรับแต่ละ pipeline phase ด้วยคำสั่ง `docker run -p 8000:8000 <image>`
2. **PICT:** ติดตั้ง Microsoft PICT binary และตรวจสอบให้แน่ใจว่าเข้าถึงได้บน system `PATH` เครื่องมือเรียกใช้ PICT เป็น subprocess ระหว่าง Phase 3
3. **Gemini API key:** กำหนดค่า key เป็น environment variable หรือป้อนในแผงการตั้งค่าของเครื่องมือ key จำเป็นสำหรับการเรียกใช้ LLM ใน Phase 2
4. **Desktop application:** เปิดใช้งาน GUI executable ของ front-end เมื่อรันครั้งแรก เครื่องมือจะถามหา back-end service URL (ค่าเริ่มต้น: `http://localhost:8000`)

### C. Widget ที่รองรับ

เวอร์ชันปัจจุบันรองรับ widget เจ็ดประเภท ดังรายละเอียดในตารางที่ II (ส่วนที่ III) widget ห้าประเภททำหน้าที่เป็น PICT factors (`TextFormField`, `DropdownButtonFormField`, `Radio`, `Checkbox`, `Switch`) หนึ่งประเภทเป็น fixed trigger (`ElevatedButton`) และหนึ่งประเภทเป็น assertion target (`Text`)

### D. การสร้างโมเดล PICT

สำหรับ screen ที่มี widget ที่ไม่ใช่ปุ่ม n ตัว ไฟล์โมเดล PICT มี n parameter lines ในรูปแบบ `<key>: v1, v2, …, vk` โดยแต่ละ $v_i$ คือระดับค่าที่แตกต่างกัน เครื่องมือสร้างไฟล์โมเดลแยกกันสาม ไฟล์ (VI, V และ Edge) และเรียกใช้ PICT ครั้งละหนึ่งไฟล์ แต่ละการรัน PICT ส่งคืน covering array ขั้นต่ำ อาร์เรย์ทั้งสามจะถูก concatenate เพื่อสร้างชุดการทดสอบที่สมบูรณ์สำหรับ screen สำหรับ `TextFormField` ที่มีค่าที่ LLM สร้างขึ้นห้าค่า (สาม valid, สอง invalid) PICT factor ที่สอดคล้องกันมีห้า levels `DropdownButtonFormField` และ `Radio` factors ระบุตัวเลือกที่มีทั้งหมดที่ดึงมาจากซอร์สโค้ด

### E. ข้อจำกัดในการพัฒนา

สคริปต์ที่สร้างขึ้นแต่ละชุดครอบคลุม **หนึ่ง** application screen ต่อการรัน ทุก widget เป้าหมายต้องมีคุณสมบัติ `Key` ที่ unique; widget ที่ไม่มี key จะถูกข้ามโดยไม่แจ้งเตือน การเรียกใช้ LLM ต้องการ Gemini API key ที่ valid ขณะรัน และ PICT ต้องถูกติดตั้งและเข้าถึงได้บน system `PATH`

---

## V. การประเมิน

### A. การตั้งค่าการทดลอง

เครื่องมือถูกประเมินกับแอปพลิเคชัน Flutter จากโลกจริงสามแอป ได้แก่ แอป Medical Appointment (นัดหมายทางการแพทย์), แอป Job Listing (รายชื่องาน) และแอป Real-Estate Listing (รายชื่ออสังหาริมทรัพย์) โดยเลือก screen สองหน้าต่อแอปพลิเคชัน ให้การประเมินระดับ screen ทั้งหมดหกครั้ง สภาพแวดล้อมการทดสอบใช้ Flutter v3.27.3 บน macOS Sequoia 15.4.1 วัดการครอบคลุมบรรทัดโดยใช้ flag `--coverage` ของ Flutter รวมกับ `lcov` เพื่อกรองผลลัพธ์เฉพาะไฟล์ UI page

### B. ภาพรวม Case Studies

แอปพลิเคชันทั้งสามแสดงถึงระดับความซับซ้อนของการตรวจสอบฟอร์มที่เพิ่มขึ้น แอป Medical Appointment มี booking screen ที่มีอินพุต widget เจ็ดตัว (TextFormField, Dropdown, DatePicker) และ search screen ที่เบากว่า แอป Job Listing มี posting screen ที่มีกฎการตรวจสอบข้ามฟิลด์ที่ซับซ้อน (เช่น ข้อจำกัดช่วงเงินเดือน) และ search screen ที่มีจำนวน widget สูงกว่า แอป Real-Estate Listing มี screen สองหน้าที่มีความซับซ้อนใกล้เคียงกัน โดยแต่ละหน้าผสมผสาน text, dropdown และ toggle widgets

### C. Case Study 1: แอปพลิเคชันนัดหมายทางการแพทย์

Booking screen มีอินพุต widget เจ็ดตัว เครื่องมือสร้างกรณีทดสอบ 52 กรณี (28 VI, 21 V, 3 Edge) สำหรับ booking screen และ 6 กรณีสำหรับ search screen

**สคริปต์ทดสอบที่สร้างขึ้น**

เครื่องมือส่งออกไฟล์ `<page>_test.dart` ที่มีโครงสร้างเป็นสาม `group()` blocks: `pairwise_valid_invalid_cases` (VI), `pairwise_valid_cases` (V) และ `edge_cases` แต่ละ entry ใน array `cases` กลายเป็น `testWidgets` block อิสระหนึ่งบล็อก

Listing 1 แสดงตัวอย่างย่อของ `pairwise_valid_invalid_cases_1`: สองฟิลด์ได้รับค่าที่ไม่ถูกต้อง — ชื่อผู้ป่วยหนึ่งตัวอักษร (ละเมิดกฎความยาวขั้นต่ำ) และหมายเลขบัตรประชาชน 11 หลัก (คาดหวัง 13 หลัก) — ในขณะที่ฟิลด์ที่เหลือได้รับค่าที่ถูกต้อง ปุ่ม submit ถูกแตะเป็นลำดับสุดท้ายและยืนยัน widget การปฏิเสธฟอร์ม

**ผลการรันทดสอบ**

รูปที่ 3 แสดง execution log ที่ผลิตโดย `flutter test` แต่ละ `testWidgets` block ถูกรายงานแยกกัน กรณีทดสอบทั้ง 52 กรณีผ่าน ยืนยันว่าสคริปต์ขับเคลื่อน UI ผ่านทั้ง valid และ invalid input paths ได้อย่างถูกต้อง รูปที่ 5 แสดงไฟล์ output `pairwise_valid_cases` ที่สมบูรณ์ตามที่เครื่องมือ render ออกมา

**ผลการครอบคลุม**

การรันกรณีทดสอบ 52 กรณีที่สร้างขึ้นกับ booking screen บรรลุการครอบคลุมบรรทัด **96.0%** (166/173 บรรทัด) และ search screen บรรลุ **91.6%** (141/154 บรรทัด) คุณลักษณะสามประการของสคริปต์ที่สร้างขึ้นมีส่วนทำให้ผลลัพธ์นี้: ประการแรก การโต้ตอบ widget ทุกตัวใช้ `find.byKey` ซึ่งเป็น locator ที่เสถียรที่ทนต่อการ refactor UI ประการที่สอง การโต้ตอบ `DatePicker` เป็นอัตโนมัติเต็มรูปแบบ: เครื่องมือ inject ขั้นตอนสลับโหมดก่อนป้อน date string ขจัดแหล่งทั่วไปของ flaky tests ประการที่สาม ทั้งกลุ่มสคริปต์ VI และ V ถูกสร้างขึ้นในการเรียกใช้เดียว ให้ทีมครอบคลุม positive และ negative test paths ทันที

### D. Case Study 2: แอปพลิเคชันรายชื่องาน

Posting screen มี widget หลายตัวพร้อมกฎการตรวจสอบร่วมกันที่ซับซ้อนระหว่างฟิลด์ (เช่น ข้อจำกัดช่วงเงินเดือน) เครื่องมือสร้างกรณีทดสอบ 64 กรณีสำหรับ posting screen (31 VI, 30 V, 3 Edge) และ 63 กรณีสำหรับ search screen (30, 30 และ 3 ตามลำดับ) แสดงให้เห็นว่าการครอบคลุมแบบแพร์ไวส์ปรับตัวตาม screen ที่มีจำนวน widget สูงกว่าได้อย่างเป็นธรรมชาติ

### E. Case Study 3: แอปพลิเคชันรายชื่ออสังหาริมทรัพย์

ทั้ง screen ของแอปอสังหาริมทรัพย์ให้กรณีทดสอบ 55 กรณีต่อ screen (27 VI, 25 V, 3 Edge) สะท้อนให้เห็นถึงความซับซ้อนของ widget ที่คล้ายคลึงกันในทั้งสอง screen รูปที่ 4 แสดงรายงานการครอบคลุมที่ผลิตหลังจากรันสคริปต์ที่สร้างขึ้น

### F. ผลการครอบคลุม

ตารางที่ III สรุปการครอบคลุมบรรทัดและจำนวนกรณีทดสอบในทั้งหกหน้าจอที่ประเมิน ทุก screen บรรลุการครอบคลุมบรรทัดเกิน **91%** ยืนยันว่าสคริปต์ทดสอบที่สร้างด้วย pairwise ทดสอบส่วนใหญ่ของ UI code paths แม้จะมีจำนวนกรณีทดสอบที่ลดลง ตารางที่ IV รายละเอียดการแบ่ง VI, V และ Edge ต่อ screen

**ตารางที่ III: สรุปการครอบคลุมการทดสอบ**

| แอปพลิเคชัน | Screen | จำนวนกรณี | บรรทัด | การครอบคลุม |
|------------|--------|-----------|--------|------------|
| Medical Appt. | Booking | 52 | 166/173 | 96.0% |
| Medical Appt. | Search | 6 | 141/154 | 91.6% |
| Job Listing | Posting | 64 | 161/172 | 93.6% |
| Job Listing | Search | 63 | 223/239 | 93.3% |
| Real Estate | Posting | 55 | 169/175 | 96.6% |
| Real Estate | Search | 55 | 233/250 | 93.2% |

**ตารางที่ IV: การแจกแจงกรณีทดสอบ Pairwise ต่อ Screen**

| แอป | Screen | VI | V | Edge |
|-----|--------|----|----|------|
| Medical Appt. | Booking | 28 | 21 | 3 |
| Medical Appt. | Search | 2 | 1 | 3 |
| Job Listing | Posting | 31 | 30 | 3 |
| Job Listing | Search | 30 | 30 | 3 |
| Real Estate | Posting | 27 | 25 | 3 |
| Real Estate | Search | 27 | 25 | 3 |

*VI = pairwise valid/invalid cases; V = pairwise valid cases; Edge = edge cases*

---

## VI. บทสรุป

บทความนี้นำเสนอเครื่องมืออัตโนมัติสำหรับการสร้างสคริปต์ทดสอบ Flutter widget โดยใช้การรวมกันของการดึงข้อมูลเมตาจากซอร์สโค้ด การสร้างข้อมูลสังเคราะห์ที่ขับเคลื่อนด้วย LLM และเทคนิคการทดสอบแบบแพร์ไวส์ เครื่องมือนี้ไม่ต้องการการสร้างกรณีทดสอบด้วยตนเอง นักพัฒนาเพียงแค่ให้ไฟล์ Flutter front-end และได้รับสคริปต์ทดสอบ Dart ที่พร้อมรันเป็น output การประเมินกับแอปพลิเคชันมือถือในโลกจริงสามแอปยืนยันว่าเครื่องมือสร้างสคริปต์ทดสอบที่รันได้พร้อม code coverage ที่วัดได้

ข้อจำกัดปัจจุบัน ได้แก่ การรองรับ widget เจ็ดประเภทที่กำหนดไว้, ขอบเขตหนึ่ง screen ต่อการรัน และการพึ่งพา Gemini API สำหรับการสร้างข้อมูล งานในอนาคตจะขยายการรองรับ widget เปิดใช้งานการทดสอบ multi-screen scenario ตรวจสอบ open-source LLMs ทางเลือกสำหรับการใช้งานแบบ offline และรวม feedback loops เพื่อปรับปรุงข้อมูลทดสอบที่สร้างขึ้นจากผลการรัน
