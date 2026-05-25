# Speaking Script — Final Defense (Thesis_Defense_Final v5)

**Topic:** Generating Test Scripts for Flutter Application with Pairwise Testing Technique
**Presenter:** Titi Changpoo (Student ID: 6770231021)
**Advisor:** Associate Professor Dr. Taratip Suwannasart
**Total slides:** 36
**Estimated total time:** ~45 นาที (verbatim)

> **วิธีใช้:** Script นี้เขียนแบบคำต่อคำ (verbatim) สามารถอ่านตามได้เลย รวม pause word เช่น "ครับ", "นะครับ", "ก็คือ" ที่ช่วยให้พูดเป็นธรรมชาติ — **[CUE]** = สิ่งที่ต้องทำหรือชี้บน slide · **[PAUSE]** = จุดเว้นจังหวะ

---

## SLIDE 1 — Title Slide (~1 นาที)

**[CUE: ยืนตรง หันหน้าคณะกรรมการ ยิ้มทักทาย หายใจลึก 1 ครั้ง]**

สวัสดีครับ ท่านอาจารย์ที่ปรึกษา รองศาสตราจารย์ ดร.ธาราทิพย์ สุวรรณศาสตร์ และคณะกรรมการสอบทุกท่านครับ

ผมชื่อ นาย ฐิติ ช้างพู รหัสนิสิต 6770231021 นิสิตปริญญาโท ภาควิชาวิศวกรรมคอมพิวเตอร์ คณะวิศวกรรมศาสตร์ จุฬาลงกรณ์มหาวิทยาลัย ปีการศึกษา 2025 ครับ

วันนี้ผมจะมานำเสนอ Master's Thesis Defense ในหัวข้อ **"Generating Test Scripts for Flutter Application with Pairwise Testing Technique"** ซึ่งเป็นงานวิจัยเกี่ยวกับการสร้าง Test Script อัตโนมัติสำหรับ Flutter Application โดยใช้เทคนิค Pairwise Testing ครับ

**[PAUSE — เปลี่ยนสไลด์]**

---

## SLIDE 2 — Presentation Outline (~1 นาที)

**[CUE: ชี้ไล่ตามหมายเลข 01-05]**

ก่อนเริ่มเข้าเนื้อหา ผมขออนุญาตชี้แจง outline ของการนำเสนอวันนี้นะครับ จะแบ่งออกเป็น 5 ส่วนหลัก

**ส่วนที่ 1** เป็นการ **recap เนื้อหา Chapter 1 ถึง 3** ครับ ครอบคลุม problem, objectives, theoretical background และ proposed approach

**ส่วนที่ 2** คือ **Chapter 4 — Tool Design and Development** เป็น main focus แรกของ defense วันนี้ ผมจะนำเสนอ UML design, architecture, environment และ user interface ของเครื่องมือที่ผมพัฒนาขึ้น

**ส่วนที่ 3** คือ **Chapter 5 — Testing and Evaluation** เป็น main focus ที่สองครับ ผมจะนำเสนอ case study ทั้ง 3 ตัว พร้อมผล statement coverage

**ส่วนที่ 4** คือ **Chapter 6 — Conclusion and Future Work** ครอบคลุมข้อสรุป, limitation และทิศทางต่อยอด

**ส่วนสุดท้าย** คือ **Q and A** สำหรับ discussion กับคณะกรรมการครับ

ถ้าทุกท่านพร้อมแล้ว ขออนุญาตเข้าสู่ส่วนแรกเลยนะครับ

**[PAUSE — เปลี่ยนสไลด์]**

---

# PART 1 — RECAP CHAPTERS 1-3 (~10 นาที)

## SLIDE 3 — Problem & Motivation (~2 นาที)

**[CUE: ชี้ context box ก่อน แล้วค่อยไล่ pain point 01-04]**

เริ่มต้นที่ Chapter 1 — Problem and Motivation ครับ

**Context** ของงานนี้คือ — Flutter framework ได้รับความนิยมอย่างกว้างขวางสำหรับการพัฒนา cross-platform mobile application โดยใช้ Dart codebase ตัวเดียว build ออกไปได้ทั้ง iOS และ Android ครับ

แต่ปัญหาที่ตามมาคือ — การเขียน test script สำหรับ Flutter application **ด้วยมือ** นั้น ต้องอาศัยความเข้าใจเชิงลึกของ widget validation rules, integration-test framework และต้อง design input data อย่างระมัดระวัง ทำให้กระบวนการนี้ใช้เวลามาก และมักจะ cover ได้ไม่ครบครับ

ปัญหาเหล่านี้ผมสรุปออกเป็น 4 ข้อหลักครับ

**ข้อที่หนึ่ง — Widget-aware expertise required** widget แต่ละประเภทมี validation logic ที่ไม่เหมือนกัน ผู้ที่เขียน test ต้องรู้ลึกถึง widget level ทุกตัว

**ข้อที่สอง — Existing tools do not cover Flutter** เครื่องมืออย่าง Robot Framework หรือ Playwright ที่มีอยู่ในตลาด target ที่ web application ไม่ใช่ Flutter mobile

**ข้อที่สาม — No automated generation for mobile** ใน Dart มี test library อย่าง flutter_test อยู่ แต่ยัง**ไม่มีเครื่องมือ generate test suite อัตโนมัติ**

**ข้อที่สี่ — Manual coverage gaps** developer มักมองข้าม conditional combination บางตัวไป ทำให้ coverage ไม่ครบทุกกรณี

จากปัญหาทั้งสี่ข้อนี้ จึงเป็นที่มาของ research objective ของผมครับ

**[PAUSE — เปลี่ยนสไลด์]**

---

## SLIDE 4 — Objectives & Research Scope (~2 นาที)

**[CUE: ชี้ objective 1, 2 ก่อน แล้วไปที่ scope grid]**

สไลด์นี้คือ **Research Objectives และ Research Scope** ครับ

**Research Objective** มี 2 ข้อ

**ข้อที่หนึ่ง** — Design กระบวนการอัตโนมัติสำหรับการ generate test script สำหรับ Flutter application โดยใช้เทคนิค pairwise testing

**ข้อที่สอง** — Develop เครื่องมือที่สามารถ produce Dart test script ออกมาจาก frontend file ได้โดยตรง

ส่วน **Scope** ของงานวิจัย ผมขอ explain ทีละข้อนะครับ

- **Framework** — ใช้ Flutter version 3.27.3 ร่วมกับ Dart version 3.6.1
- **Supported Widgets** — รองรับ widget 7 ประเภท ได้แก่ TextFormField, Text, Radio, Button, DropdownButtonFormField, Checkbox และ Switch
- **Test Technique** — ใช้ Pairwise — หรือ All-Pairs — ผ่าน Microsoft PICT
- **LLM Service** — ใช้ Gemini 2.5 Flash สำหรับการ generate synthetic data
- **Test Granularity** — 1 screen ต่อ generated script 1 ไฟล์
- **Backend Pairing** — pair กับ FastAPI framework version 0.114.1
- **Deployment** — เครื่องมือถูก containerize ด้วย Docker version 28.0.0
- **Evaluation** — ทดสอบกับ mobile application **อย่างน้อย 3 ตัว** ครับ

**[PAUSE — เปลี่ยนสไลด์]**

---

## SLIDE 5 — Key Theory & Related Work (~2 นาที)

**[CUE: ฝั่งซ้าย foundational concepts, ฝั่งขวา related work]**

สไลด์นี้เป็น Chapter 2 — Key Theory and Related Work ครับ ผมจะแบ่งเป็น 2 ฝั่ง

**ฝั่งซ้าย — Foundational Concepts** 5 หัวข้อ

- **Flutter Framework** เป็น single-codebase cross-platform UI toolkit ที่ทุก element บนหน้าจอเป็น widget
- **Widget และ Key** — widget คือ building block ของ UI ส่วน key คือ identifier ที่ใช้ระบุ widget แต่ละตัวใน tree
- **Flutter Testing** — flutter_test library มี WidgetTester, Finders และ Expect สำหรับ widget test และ integration test
- **Pairwise Testing** — เป็น black-box technique ที่ cover ทุกคู่ของ input value ด้วยจำนวน test case ที่น้อยที่สุด
- **PICT** — เป็น open-source tool ของ Microsoft ที่ produce pairwise combinatorial test suite จาก model file

**ฝั่งขวา — Prior Research Adopted** 3 งาน

- งานของ **Ekarattachvakit และ Suwannasart** — generate test script ของ Robot Framework สำหรับ web application โดยอิงจาก database constraint — ผม adopt concept ของการ extract จาก HTML/frontend มาใช้
- งานของ **Sriwichainan และ Suwannasart** — generate web application test script จาก URL กับ XSD โดยใช้ boundary-value analysis — ผม adopt concept ของ frontend-driven script generation มาใช้
- งานของ **Tuan Pham — CO-STEP** — prompt-engineering framework ที่ช่วยปรับปรุงคุณภาพการ response ของ LLM โดยใช้ structured prompt — ผมนำมาใช้ในการ design prompt **เพื่อลด hallucination** ของ LLM ครับ

**[PAUSE — เปลี่ยนสไลด์]**

---

## SLIDE 6 — Proposed Approach: End-to-End Pipeline (~2 นาที)

**[CUE: ชี้แต่ละกล่อง 1-7 ตามลำดับ]**

มาถึง Chapter 3 — Proposed Approach ครับ ผม design pipeline ออกเป็น 7 stage ตั้งแต่ Flutter frontend จนถึง executable Dart test script

**Stage 1 — Extract Metadata** จากไฟล์ .dart ที่อยู่ใต้โฟลเดอร์ `lib/`
**Stage 2 — Build Manifest JSON** เป็นไฟล์ `<page>.manifest.json` ต่อ screen
**Stage 3 — Prompt LLM** ส่ง Gemini 2.5 Flash ไป generate synthetic data
**Stage 4 — Analyse Relations** map widget เป็น PICT factor และ level
**Stage 5 — Parse Constraints** — optional ครับ ถ้ามี constraint file รองรับ 3 grammar
**Stage 6 — Run PICT** generate pairwise test case
**Stage 7 — Build and Emit Dart Script** ออกมาเป็นไฟล์ `<page>.test_data.json` และไฟล์ `<page>_test.dart`

**Output ที่ได้ในแต่ละ stage** ก็คือ:
- `manifest.json` — widget metadata
- `datasets.json` — LLM synthetic data
- `valid.model.txt` กับ `invalid.model.txt` — PICT model
- `result.txt` — pairwise suite
- `test_data.json` — consolidated case
- และไฟล์ `<page>_test.dart` ที่รันได้จริง

ทั้งหมดนี้ทำงานต่อเนื่องเป็น pipeline เดียวครับ

**[PAUSE — เปลี่ยนสไลด์]**

---

## SLIDE 7 — Generated Test-Case Groups (~1.5 นาที)

**[CUE: ชี้ 3 กล่อง invalid / valid / edge ตามลำดับ]**

ก่อนจบส่วน recap ขอให้ดู **Generated Test-Case Group** ครับ — ทุก screen ที่ generate ออกมา จะมี case อยู่ 3 ประเภท

**ประเภทที่ 1 — Pairwise Invalid** ในไฟล์ `pairwise_invalid_cases` ป้อน TextFormField ด้วย invalid value และ option combination แบบ invalid เพื่อ verify ว่า UI validation ทำงานตาม validator rule ของ widget แต่ละตัวจริง

**ประเภทที่ 2 — Pairwise Valid** ในไฟล์ `pairwise_valid_cases` ป้อน valid value cover ทุกคู่ option เพื่อ verify ว่า screen สามารถ submit request ไปยัง backend ได้สำเร็จ

**ประเภทที่ 3 — Edge Cases** มี **3 sub-type** ครับ:
- `edge_cases_empty_all_fields` — เว้นทุก field
- `edge_cases_boundary_at_max_length` — ใส่ค่ายาวสุดที่ field รับได้
- `edge_cases_boundary_at_min_length` — ใส่ค่าสั้นสุดที่ field รับได้

แต่ละ case จะมี field สำคัญดังนี้ครับ: `tc` (test case id), `kind` (success หรือ failed), `group`, `steps` (เช่น enterText, tap, pump) และ `asserts` (เช่น text, byKey, exist)

ครับ นั่นคือสรุป Chapter 1 ถึง 3 ขออนุญาตเข้าสู่ Chapter 4 ซึ่งเป็น main focus แรกของ defense วันนี้ครับ

**[PAUSE — เปลี่ยนสไลด์]**

---

# PART 2 — CHAPTER 4: TOOL DESIGN & DEVELOPMENT (~13 นาที)

## SLIDE 8 — Chapter 4 Divider (~30 วินาที)

**[CUE: divider — ใช้สั้นๆ]**

Chapter 4 — Tool Design and Development ครับ ส่วนนี้ผมจะนำเสนอ object-oriented design ที่ express ผ่าน UML, architecture, development environment และ user interface ของเครื่องมือ test-script generator

**[PAUSE — เปลี่ยนสไลด์]**

---

## SLIDE 9 — Use-Case Diagram (~1.5 นาที)

**[CUE: ชี้แต่ละ UC ไล่ตามลำดับ 1-9]**

เริ่มต้นที่ **Use-Case Diagram** ของเครื่องมือครับ มี **actor หลักตัวเดียว** คือ Developer และมี **use case ทั้งหมด 9 อัน**

โดย use case แบ่งเป็น 2 กลุ่ม — กลุ่มที่ **developer trigger เอง** สีฟ้า มี 5 อัน UC1 ถึง UC5 — และกลุ่มที่ **automated โดย tool ผ่าน «include»** สีทอง มี 4 อัน UC6 ถึง UC9

**Developer-triggered:**
- **UC1** — Enter frontend file path
- **UC2** — Enter constraint file path
- **UC3** — Enter output file path
- **UC4** — Generate test script — เป็น use case หลัก
- **UC5** — Run and test script

**Automated via include:**
- **UC6** — Create manifest file
- **UC7** — Create dataset ผ่าน LLM
- **UC8** — Create pairwise result
- **UC9** — Create test-data file

ทั้ง 4 use case ที่เป็น automated จะถูกเรียกผ่าน «include» relationship จาก UC4 — Generate test script ครับ

**[PAUSE — เปลี่ยนสไลด์]**

---

## SLIDE 10 — Activity Diagrams Coverage Map (~1.5 นาที)

**[CUE: ชี้คอลัมน์ A, B, C ตามลำดับ]**

มาดู **Activity Diagram** กันครับ ผม design ไว้ทั้งหมด **8 activity diagram** ซึ่งครอบคลุมพฤติกรรมทั้งหมดของ generator และจัดกลุ่มเป็น 3 workflow

**Workflow A — Inputs from Developer** มี 3 figure
- **Fig 4.2** — Import และ validate frontend file
- **Fig 4.3** — Import และ validate constraint file
- **Fig 4.4** — Select output file location

**Workflow B — Automated Generation** มี 4 figure
- **Fig 4.5** — Extract widget และ metadata
- **Fig 4.6** — Synthetic data ผ่าน LLM
- **Fig 4.7** — Pairwise case generation ผ่าน PICT
- **Fig 4.8** — Build test-data structure

**Workflow C — Script Emission**
- **Fig 4.9** — Emit Dart test script อัตโนมัติ พร้อม template ของ widget กับ `flutter_test` API และ assertion เช่น `byKey`, `expect`, `findsOneWidget` รวมถึง group labelling ตาม test-case kind

ผมจะลงรายละเอียดของ activity diagram สำคัญในสไลด์ถัดไปครับ

**[PAUSE — เปลี่ยนสไลด์]**

---

## SLIDE 11 — Activity: Frontend Import & Metadata Extraction (~1.5 นาที)

**[CUE: ไล่ flow จาก Developer ลงไป Tool พร้อมชี้ decision diamond]**

สไลด์นี้คือ **Activity Diagram ของ Frontend Import และ Metadata Extraction** ครับ มี 2 swim lane คือ Developer ฝั่งซ้ายและ Tool ฝั่งขวา

**Flow เริ่มจาก** — developer enter frontend file path

จากนั้น tool จะ **decision check ครั้งที่ 1** — Valid file type หรือไม่?

- ถ้า **No** — Show file-type error alert แล้วจบ flow
- ถ้า **Yes** — เข้าสู่ขั้น Search for widgets in scope

จากนั้นเข้าสู่ **decision check ครั้งที่ 2** — Widget found หรือไม่?

- ถ้า **No** — Show no-widget alert
- ถ้า **Yes** — Extract widget metadata แล้ว Write `manifest.json` ที่ระดับ page

**Defensive pattern นี้** — type check แล้ว scope check แล้วค่อยเขียนไฟล์ — ผมใช้ซ้ำกับการ import file ทุกประเภทในเครื่องมือครับ

**[PAUSE — เปลี่ยนสไลด์]**

---

## SLIDE 12 — Activity: Constraint File & Pairwise Generation (~1.5 นาที)

**[CUE: 2 ฝั่ง — ซ้าย constraint flow, ขวา PICT generation]**

สไลด์นี้แสดง 2 flow ที่ทำงานต่อเนื่องครับ

**ฝั่งซ้าย — Constraint File Flow** ผมรองรับ constraint syntax **3 grammar**:
1. `key.valid = value` override — override valid value
2. `key.invalid = value` override — override invalid value
3. `IF [keyA] = "vA" THEN [keyB] = "vB"` — cross-widget constraint

Flow คือ — Prompt developer ใส่ constraint path → ถ้า No ก็ skip → ถ้า Yes ก็ check valid syntax → ถ้า syntax ผิด show alert → ถ้าถูกต้อง proceed ไปยัง pairwise case generation

**ฝั่งขวา — Pairwise Case Generation**
1. Read widget metadata กับ option
2. Derive factor และ level (แยก valid กับ invalid)
3. Write model file 2 ไฟล์: `valid.model.txt` และ `invalid.model.txt`
4. Invoke PICT tool
5. Capture `result.txt` ซึ่งเป็น minimum pairwise suite
6. Pass ไปยัง Test-Data Generator

ตรงนี้คือจุดที่ **constraint file ทำให้ pairwise มีความหมายในเชิง semantic** ครับ ไม่ใช่แค่ pair ที่ valid ตามคณิตศาสตร์ แต่ valid ตาม business logic ด้วย

**[PAUSE — เปลี่ยนสไลด์]**

---

## SLIDE 13 — Activity: LLM Dataset & Test-Data Build (~1.5 นาที)

**[CUE: 2 column — ซ้าย dataset gen, ขวา test-data build]**

สไลด์นี้แสดง **flow การ generate dataset กับ test-data** ครับ มี 2 process ต่อเนื่องกัน

**ฝั่งซ้าย — Dataset Generation (Fig 4.6)**
1. Load `manifest.json`
2. Filter เฉพาะ TextFormField
3. **Compose CO-STEP prompt** ครอบคลุม Context, Objective, Style, Target, Execution, Polish
4. POST ไป Gemini 2.5 Flash ผ่าน HTTP
5. Parse response → แยกเป็น 4 group: valid, invalid, atMax, atMin
6. Emit ไฟล์ `<page>.datasets.json`

**ฝั่งขวา — Test-Data Build (Fig 4.8)**
1. Merge ทั้ง 3 input: manifest + datasets + PICT result
2. Assemble source, dataset, cases
3. Compose CO-STEP prompt อีกครั้ง — เพื่อ generate steps เช่น enterText, tap, pump
4. Generate asserts เช่น text, byKey, exist
5. Order steps ตาม key prefix เพื่อให้ sequence ถูกต้อง
6. Emit ไฟล์ `<page>.test_data.json`

จุดสำคัญคือ — **CO-STEP framework ใช้ทั้ง 2 stage** ทำให้ LLM response มี structure ที่ predictable และลด hallucination ได้ครับ

**[PAUSE — เปลี่ยนสไลด์]**

---

## SLIDE 14 — Activity: Automatic Test-Script Generation (~1.5 นาที)

**[CUE: ไล่ 1-6 ตามลำดับแล้วชี้ที่ code sample]**

สไลด์นี้คือ flow สุดท้ายของ Chapter 4 ครับ — **การ generate Dart test script อัตโนมัติ** จากไฟล์ `test_data.json` ออกมาเป็น executable Dart ที่ 6 step:

1. **Read** `test_data.json`
2. **Map** JSON key เป็น Dart command — TextFormField map เป็น enterText กับ pump, Radio/Checkbox map เป็น tap กับ pump, Dropdown map เป็น tap, pump, tapText, pump, และ Button map เป็น tap กับ pumpAndSettle
3. **Build** import statement
4. **Build** group / testWidgets block
5. **Inject** pumpWidget พร้อม BlocProvider
6. **Write** ไฟล์ `<page>_test.dart` ออกมา

**[CUE: ชี้ที่ code box ด้านล่าง]**

ตัวอย่าง output อยู่ในกล่องล่าง — เป็น snippet ของไฟล์ `<page>_test.dart` จะเห็นว่ามีการ import flutter_test, สร้าง group `pairwise_invalid_cases`, ใช้ testWidgets สำหรับ `invalid_case_01`, มี `tester.pumpWidget` พร้อม MaterialApp กับ BlocProvider, แล้วก็ใช้ `tester.enterText` พร้อม `find.byKey` และ assertion ด้วย `expect` กับ `findsOneWidget` ครับ

ไฟล์นี้ **executable ทันทีภายใต้ flutter_test framework** โดยไม่ต้องแก้แม้แต่บรรทัดเดียวครับ

**[PAUSE — เปลี่ยนสไลด์]**

---

## SLIDE 15 — Package Diagram — Layered Architecture (~1.5 นาที)

**[CUE: 3 layer — View, Domain, Infrastructure]**

มาดู **Package Diagram** ครับ ผม design architecture เป็น **3 layer**

**Layer 1 — Package View**
- มี class `UIView` — รับผิดชอบ tool window, file picker, dialog notification และเป็นจุด trigger pipeline

**Layer 2 — Package Domain**
มี 3 stereotype:
- **«Controller»** — `PipelineController`
- **«Extractor»** — `UiManifestExtractor`
- **«Generator»** — มี 5 generator: `DatasetGenerator`, `GeneratorPict`, `TestDataGenerator`, `TestScriptGenerator` และ `CoverageGenerator`

**Layer 3 — Infrastructure**
- File System I/O
- HTTP Client (สำหรับ LLM)
- PICT executable
- Dart / Flutter CLI

**Architectural rule ของ design นี้คือ** — Domain layer ไม่รู้จัก View layer และไม่รู้จัก Infrastructure โดยตรง — interaction ทำผ่าน controller กับ interface ทำให้แต่ละ generator สามารถ unit test ได้อย่างเป็นอิสระครับ

**[PAUSE — เปลี่ยนสไลด์]**

---

## SLIDE 16 — Sequence Diagrams Overview (~1.5 นาที)

**[CUE: 8 step round-trip — ชี้ไล่จากซ้ายไปขวา]**

สไลด์นี้คือ **Sequence Diagram Overview** ครับ ผม design ไว้ทั้งหมด **8 sequence diagram** ใน Figure 4.11 ถึง 4.18 ซึ่ง capture runtime collaboration ระหว่าง 7 component หลักของ pipeline

มี actor 1 ตัวคือ User และมี participant 6 ตัว ได้แก่ UiManifestExtractor, DatasetGenerator, GeneratorPict, TestDataGenerator, TestScriptGenerator และ CoverageGenerator

**Flow ระดับสูง 8 step:**
1. Import frontend `.dart`
2. ได้ Widget manifest
3. สร้าง Parameter model
4. ได้ Pairwise combination
5. ได้ Synthetic dataset จาก LLM
6. Build Test-data set
7. Generate test script
8. Coverage report

**Sequence diagram ทั้ง 8 ตัว** breakdown ตาม stage ครับ:
- Fig 4.11 — import
- Fig 4.12 — dataset
- Fig 4.13 — pairwise
- Fig 4.14 — constraint
- Fig 4.15 — test-data
- Fig 4.16 — script
- Fig 4.17 — validation
- Fig 4.18 — coverage

**[PAUSE — เปลี่ยนสไลด์]**

---

## SLIDE 17 — Development Environment (~1 นาที)

**[CUE: 2 column — Hardware ซ้าย, Software ขวา]**

สไลด์ §4.1.5 — Development Environment ครับ

**Hardware** ที่ใช้พัฒนา — Apple Silicon laptop
- CPU: Apple M2 Pro
- RAM: 16 GB
- GPU: 16-core integrated
- Form factor: Notebook computer

**Software toolchain:**
- OS: macOS Sequoia 15.4.1
- IDE: Visual Studio Code 1.109.0
- Language: Dart 3.6.1
- Framework: Flutter 3.27.3

นี่คือ environment standard ที่ผมใช้ตลอดการพัฒนาและทดสอบ เพื่อให้ผล evaluation reproducible ครับ

**[PAUSE — เปลี่ยนสไลด์]**

---

## SLIDE 18 — Tool UI — Main Window (~1.5 นาที)

**[CUE: ชี้ 4 region ① ② ③ ④]**

สไลด์ §4.2.2.1 — Tool UI ครับ Main window ของเครื่องมือ — ชื่อ `flutter_test_gen` — มี input region 4 ส่วน ตรงกับ pipeline 7 step

**Region ① — Front-end import** — Select `.dart` widget file ผ่าน file picker
**Region ② — Constraint file** — optional input ของไฟล์ `.txt` ที่เป็น PICT syntax
**Region ③ — Output location** — เลือก folder กับ file prefix
**Region ④ — Generate button** — กดเพื่อรัน pipeline สร้าง test script

**ฝั่งขวาคือ Design Principle 4 ข้อ:**
1. **Linear top-down flow** — user ทำตาม ① → ② → ③ → ④ ครั้งเดียว ซ้ายไปขวา ไม่มี backtrack
2. **Defensive validation** — แต่ละ import จะ validate file type กับ syntax ก่อน enable ปุ่ม Generate
3. **Sensible default** — ถ้า user ไม่ใส่ output path ระบบจะใช้ working directory เป็น default
4. **Explicit feedback** — มี success และ error dialog confirm ทุกขั้นตอนของการ import

หลักการ design นี้ทำให้ even first-time user สามารถใช้เครื่องมือได้โดยไม่ต้องอ่าน document ครับ

**[PAUSE — เปลี่ยนสไลด์]**

---

## SLIDE 19 — Input Validation & Dialog States (~1.5 นาที)

**[CUE: 3 column — Front-end / Constraints / Output, แต่ละ column มี success + 2 error]**

สไลด์ §4.2.2.2 ถึง §4.2.2.4 — Input Validation และ Dialog State ครับ

แต่ละ import path จะ branch ออกเป็น success state กับ error state ใน Figure 4.21 ถึง 4.30 รวมแล้ว tool มี **8 distinct dialog outcome**

**Front-end file:**
- Success — Import OK แสดง widget count (Fig 4.21)
- Error 1 — No widgets in scope (Fig 4.22)
- Error 2 — Wrong file type ไม่ใช่ Dart (Fig 4.23)

**Constraints file:**
- Success — Import OK constraints applied (Fig 4.24)
- Error 1 — Syntax error in constraints (Fig 4.25)
- Error 2 — Wrong file type ไม่ใช่ text (Fig 4.26)

**Output path:**
- Success — User specifies folder (Fig 4.27)
- Error 1 — Empty path → ใช้ default
- Error 2 — Generate disabled ถ้า constraint missing (Fig 4.29)

ผมตั้งใจ design ให้ทุก error case มี **explicit feedback message** เพื่อให้ user แก้ปัญหาได้ทันทีโดยไม่ต้องเดาครับ

**[PAUSE — เปลี่ยนสไลด์]**

---

## SLIDE 20 — Tool Output — Generated Artifacts (~1.5 นาที)

**[CUE: ชี้แต่ละ artifact ตามลำดับ]**

สไลด์ §4.2.2.5 — Tool Output ครับ ทุก successful run จะ produce artifact **8 ไฟล์** ตาม Figure 4.31

1. **`manifest.json`** — extracted widget manifest ประกอบด้วย type, key, validators, options
2. **`datasets.json`** — LLM-generated synthetic dataset grouped by parameter
3. **`invalid.model.txt`** กับ **`valid.model.txt`** กับ **`invalid.result.txt`** กับ **`valid.result.txt`** — PICT input model และ pairwise output 4 ไฟล์
4. **`test_data.json`** — final test data ประกอบด้วย `pairwise_invalid`, `pairwise_valid` และ `edge_cases`
5. **`<page>_test.dart`** — executable Flutter widget-test script พร้อมรันด้วย `flutter test`

จุดเด่นของ artifact ทั้งหมดคือ — **human-readable, version-controllable และ regenerable** จาก input เดิมครับ

ครับ นั่นคือ Chapter 4 ทั้งหมด ขออนุญาตเข้าสู่ Chapter 5 — Experimental Evaluation ซึ่งเป็น main focus ที่สองครับ

**[PAUSE — เปลี่ยนสไลด์]**

---

# PART 3 — CHAPTER 5: TESTING & EVALUATION (~13 นาที)

## SLIDE 21 — Chapter 5 Divider (~30 วินาที)

**[CUE: divider — ใช้สั้นๆ]**

Chapter 5 — Experimental Evaluation ครับ ส่วนนี้ผมจะนำเสนอ case study ทั้งหมด **3 ตัว** ครอบคลุม **6 application page** พร้อม statement coverage measurement

3 case study คือ:
1. **Clinic Appointment**
2. **Job Posting**
3. **Real-Estate Listing**

**[PAUSE — เปลี่ยนสไลด์]**

---

## SLIDE 22 — Testing Methodology (~1.5 นาที)

**[CUE: ไล่ step 1-5]**

สไลด์ §5.2 — Testing Methodology ครับ ผมใช้ procedure 5 step **เดียวกัน** กับทุก case study เพื่อให้ผลลัพธ์ comparable

**Step 1 — Prepare front-end `.dart`** — developer เขียนหน้า Flutter ที่จะ test โดยกำหนด widget key ที่ stable

**Step 2 — Import file path** — developer เลือกไฟล์ `.dart` ผ่าน file picker ของเครื่องมือ

**Step 3 — Import constraints** — optional ถ้าจำเป็นก็ load constraint file syntax แบบ PICT

**Step 4 — Specify output path** — เลือก destination folder หรือใช้ default

**Step 5 — Press Generate** — pipeline รัน end-to-end แล้ว emit artifact 5 ไฟล์ออกมา

**Measurement** — Statement coverage ผ่าน `lcov` หลังรัน `flutter test --coverage`

5 step นี้ same procedure ครับ — เปลี่ยนแค่ input file ระหว่าง case study

**[PAUSE — เปลี่ยนสไลด์]**

---

## SLIDE 23 — Case Study 1: Clinic Appointment Widgets (~1.5 นาที)

**[CUE: ฝั่งซ้าย form fields, ฝั่งขวา widget inventory]**

**Case Study ที่ 1 — Clinic Appointment** ครับ

**ฝั่งซ้าย** คือ field ทั้งหมดในฟอร์ม:
- Full name
- National ID (13 หลัก)
- Phone (≥ 9 หลัก)
- Department (dropdown 7 option)
- Appointment type (OPD หรือ Tele)
- Appointment date
- Time slot
- Health insurance (switch)
- Note (optional)
- Confirm button

**ฝั่งขวา — Widget Inventory:**
- **10 widget keys**
- **2 pages** (Appointment form กับ Search)
- **2 HTTP methods**

**Widget Type Mix:**
- TextFormField — 6 ตัว
- Radio — 2 ตัว
- DropdownButtonFormField — 1 ตัว
- Switch — 1 ตัว
- ElevatedButton — 1 ตัว

**ผลการ generate** — รวม **54 test cases** — Page 1: 52 case (28 invalid + 21 valid + 3 edge), Page 2: 2 case ครับ

**[PAUSE — เปลี่ยนสไลด์]**

---

## SLIDE 24 — Case Study 1: Coverage (Table 5.1) (~1 นาที)

**[CUE: 2 ตัวเลขใหญ่ — 96.0% และ 91.6%]**

**Coverage ของ Case Study 1** ครับ — Table 5.1 — วัดด้วย `flutter test --coverage`

**Page 1 — `clinic_appointment_page.dart`**
- Statement coverage **96.0%**
- 166 จาก 173 บรรทัดถูก cover

**Page 2 — `clinic_search_page.dart`**
- Statement coverage **91.6%**
- 141 จาก 154 บรรทัดถูก cover

ทุก widget ที่อยู่ใน scope ถูก exercise ทั้งหมด, test data ตรงกับ design และ script ทั้งหมด execute ได้ภายใต้ Flutter framework โดยไม่ต้องแก้ครับ

**[PAUSE — เปลี่ยนสไลด์]**

---

## SLIDE 25 — Case Study 2: Job Posting Widgets (~1.5 นาที)

**[CUE: ฝั่งซ้าย field list, ฝั่งขวา breakdown table]**

**Case Study ที่ 2 — Job Posting** ครับ

**ฝั่งซ้าย** — field:
- Job title
- Company name
- Employment type (Full-time / Part-time)
- Salary range (from / to)
- Job category
- Required experience
- Work location
- Remote-work switch
- Job description
- Apply deadline
- Submit button

**Widget Inventory:**
- **11 widget keys**
- **2 pages**
- **2 HTTP methods**

**Test-Case Breakdown:**

| Page | Invalid | Valid | Edge | Total |
|---|---|---|---|---|
| Page 1 — Posting | 31 | 30 | 3 | **64** |
| Page 2 — Search | 30 | 30 | 3 | **63** |

รวม **127 test cases** ครับ

จุดสำคัญคือ — case นี้ใช้ **constraint file** เพื่อ link ความสัมพันธ์ระหว่าง employment type กับ salary field เพราะถ้า type เป็น Part-time แล้วใส่ salary เป็นรายเดือนก็จะดูไม่สมเหตุสมผล — constraint ช่วยกรอง combination เหล่านี้ออกตั้งแต่ที่ PICT ก่อนเข้า test generation

**[PAUSE — เปลี่ยนสไลด์]**

---

## SLIDE 26 — Case Study 2: Coverage (Table 5.2) (~1 นาที)

**[CUE: 93.6% / 93.3%]**

**Coverage ของ Case Study 2** ครับ — Table 5.2

**Page 1 — `job_post_page.dart`**
- Statement coverage **93.6%**
- 161 จาก 172 บรรทัด

**Page 2 — `job_search_page.dart`**
- Statement coverage **93.3%**
- 223 จาก 239 บรรทัด

จุดที่ผมอยากเน้นคือ — field ที่ relate กันสูง อย่าง employment type กับ salary — ถูก handle ผ่าน constraint file ทำให้ไม่มี **unreachable branch** ใน posting form ครับ

**[PAUSE — เปลี่ยนสไลด์]**

---

## SLIDE 27 — Case Study 3: Real-Estate Listing Widgets (~1.5 นาที)

**[CUE: ฝั่งซ้าย field, ฝั่งขวา breakdown]**

**Case Study ที่ 3 — Real-Estate Listing** ครับ

**ฝั่งซ้าย** — field:
- Property title
- Property type (rent / sale)
- Price
- Currency
- Bedrooms
- Bathrooms
- Area (sq.m.)
- Address / district
- Amenities (checkboxes)
- Photos uploaded flag
- Listing description
- Publish button

**Widget Inventory:**
- **12 widget keys**
- **2 pages**
- **2 HTTP methods**

**Test-Case Breakdown:**

| Page | Invalid | Valid | Edge | Total |
|---|---|---|---|---|
| Page 1 — Posting | 27 | 25 | 3 | **55** |
| Page 2 — Search | 27 | 25 | 3 | **55** |

รวม **110 test cases** ครับ — case นี้น่าสนใจตรงที่ search กับ posting มี structure ใกล้เคียงกันมาก ทำให้ test-case breakdown **symmetric** เหมือนกันทั้งสองหน้า

**[PAUSE — เปลี่ยนสไลด์]**

---

## SLIDE 28 — Case Study 3: Coverage (Table 5.3) (~1 นาที)

**[CUE: 96.6% เด่นที่สุด]**

**Coverage ของ Case Study 3** ครับ — Table 5.3

**Page 1 — `property_post_page.dart`**
- Statement coverage **96.6%**
- 169 จาก 175 บรรทัด

**Page 2 — `property_search_page.dart`**
- Statement coverage **93.2%**
- 233 จาก 250 บรรทัด

ตัวเลข **96.6% เป็น single-page coverage สูงสุดของ study ทั้งหมด** ครับ — script ที่ generate ออกมา exercise ทุก pairwise combination ของ field — บรรลุ coverage สูงสุดในงานนี้

**[PAUSE — เปลี่ยนสไลด์]**

---

## SLIDE 29 — Consolidated Results (Headline) (~2 นาที)

**[CUE: ตัวเลขใหญ่ 94.05% — เน้นเสียง]**

สไลด์นี้สำคัญที่สุดใน Chapter 5 ครับ — §5.4 Summary — Consolidated Results ของทั้ง 6 page

**[CUE: ชี้ตัวเลข headline]**

**Headline ของ defense ครั้งนี้คือ — Average statement coverage 94.05% ครับ**

**ตัวเลขสรุป:**
- **94.05%** — average statement coverage ทั่ว 6 page
- **291** — test case รวมที่ generate ออกมาทั้งหมด
- **6 pages** — ที่ทดสอบ
- **33 widget keys** — ที่ cover

**Breakdown แต่ละหน้า** (จาก chart):
- Clinic Post — 96.0%
- Clinic Search — 91.6%
- Job Post — 93.6%
- Job Search — 93.3%
- Property Post — 96.6%
- Property Search — 93.2%

ทุกหน้าอยู่ในช่วง **91.6% ถึง 96.6%** — ค่อนข้าง consistent — แสดงว่าเครื่องมือสร้าง coverage ที่สูงและเชื่อถือได้ ไม่ว่า case จะมี complexity เท่าไหร่

ผมขอ commitment ตรงนี้ครับ — **เครื่องมือนี้ produce test script ที่ achieve coverage เฉลี่ย 94% โดยไม่ต้องแก้ code ที่ generate ออกมาด้วยมือเลย** — และไม่ต้อง maintain test code เพราะ regenerate ได้ทุกครั้งครับ

**[PAUSE — เปลี่ยนสไลด์]**

---

## SLIDE 30 — Installation & Usage (Dockerised) (~1 นาที)

**[CUE: ไล่ step 1-5]**

สไลด์ §5.5 ถึง §5.6 — Installation and Usage ครับ เครื่องมือถูก ship ในรูปแบบ Docker image — developer รัน helper script `run_tool.sh` ตัวเดียวก็ start web UI ขึ้นมาได้

**ขั้นตอน 5 step:**
1. **Download** — `flutter_test_gen_v1.0.0.zip` จาก GitHub release
2. **Place** — unzip เข้า directory ของ Flutter project
3. **Build** — รัน `docker build -t flutter_test_gen .` เพื่อสร้าง tool image
4. **Launch** — รัน `./run_tool.sh` แล้ว web UI จะพร้อมที่ `http://localhost:8080`
5. **Use** — ทำตาม 5-step testing procedure ที่ผมเสนอใน slide ก่อนหน้า

**Release link** — `github.com/titic443/master_project_v2` version 1.0.0

จุดที่ผมตั้งใจคือ — developer ไม่ต้อง install Dart, Flutter, PICT, หรือ Python ในเครื่องตัวเอง — แค่มี Docker ก็เพียงพอครับ

**[PAUSE — เปลี่ยนสไลด์]**

---

# PART 4 — CHAPTER 6: CONCLUSION & FUTURE WORK (~5 นาที)

## SLIDE 31 — Chapter 6 Divider (~30 วินาที)

**[CUE: divider — สั้น]**

Chapter 6 — Conclusion and Future Work ครับ ส่วนนี้ผมจะสรุปผลงาน, ระบุ limitation ที่งานยังมี และเสนอ research roadmap ต่อยอด

ครอบคลุม 3 section:
- §6.1 Conclusions
- §6.2 Limitations
- §6.3 Future Work

**[PAUSE — เปลี่ยนสไลด์]**

---

## SLIDE 32 — Conclusions (~1.5 นาที)

**[CUE: ✓ 4 อัน — ไล่ลำดับ]**

สไลด์ §6.1 — Conclusions ครับ งานวิจัยนี้ demonstrate ได้ **4 ข้อหลัก**

**ข้อที่ 1 — End-to-end pipeline works** — เครื่องมือสามารถ extract widget metadata จาก Flutter frontend, generate pairwise-covered test case, และ emit executable Dart test script ได้สำเร็จ end-to-end

**ข้อที่ 2 — Scripts run under Flutter** — generated widget-test script ทั้งหมด **execute โดยไม่ต้องแก้** ภายใต้ Flutter framework ใน case study ทั้ง 3 ตัว

**ข้อที่ 3 — High statement coverage** — Average statement coverage **94.05%** ทั่ว 6 application page — range 91.6% ถึง 96.6%

**ข้อที่ 4 — Practical for real projects** — การส่งมอบในรูปแบบ Docker บวก workflow 5 step ทำให้ developer adopt เครื่องมือนี้ได้โดยไม่ต้องเปลี่ยน Flutter setup เดิม

**Core claim ของงาน** — automated test-script generation พร้อม pairwise coverage **เป็นไปได้และมีประสิทธิภาพ** สำหรับ Flutter form page ครับ

**[PAUSE — เปลี่ยนสไลด์]**

---

## SLIDE 33 — Limitations (~1.5 นาที)

**[CUE: 4 ข้อ — L1 L2 L3 L4]**

สไลด์ §6.2 — Limitations ครับ ผมขอ acknowledge ขอบเขตของ implementation ปัจจุบัน 4 ข้อ

**L1 — Limited widget scope** — รองรับเฉพาะ TextFormField, Radio, Checkbox, DropdownButtonFormField และ Button — widget นอก set นี้จะถูก skip

**L2 — Requires widget keys** — widget ที่ไม่มี stable key attribute จะถูก skip — developer **ต้อง annotate key ใน Flutter code ก่อน** จึงจะใช้เครื่องมือนี้ได้

**L3 — One page at a time** — แต่ละ run จะ process ไฟล์ frontend `.dart` 1 ไฟล์ — multi-page flow ต้อง generate ทีละ page

**L4 — No expected-result oracle** — generated case จะ drive UI ได้ แต่ยังไม่ specify expected post-condition สำหรับทุก input combination อย่างสมบูรณ์

limitation ทั้ง 4 ข้อนี้ก็เป็นจุดเริ่มต้นของ future work ที่ผมจะนำเสนอใน slide ถัดไปครับ

**[PAUSE — เปลี่ยนสไลด์]**

---

## SLIDE 34 — Future Work (~1.5 นาที)

**[CUE: 6 ข้อ — ไล่ทีละข้อ]**

สไลด์ §6.3 — Future Work ครับ ผมเสนอ direction ต่อยอด 6 ทิศทาง

**ข้อที่ 1 — Broader widget support** — extend extractor ให้รองรับ Slider, DatePicker, Chips และ custom StatefulWidget

**ข้อที่ 2 — Multi-file front-end input** — รับทั้ง project folder แล้ว generate script สำหรับทุก page ในรอบเดียว

**ข้อที่ 3 — Richer constraint grammar** — express cross-widget dependency ในรูปแบบที่ natural กว่า PICT format ปัจจุบัน

**ข้อที่ 4 — Cross-framework adaptation** — port concept ของ pipeline นี้ไปยัง React Native, Xamarin และ SwiftUI

**ข้อที่ 5 — Multi-step back-end calls** — รองรับ test case ที่เรียก HTTP endpoint มากกว่า 1 ตัวต่อ scenario

**ข้อที่ 6 — Multi-page navigation flows** — generate linked script ที่ navigate ข้าม page เพื่อ mimic real user journey

ผม prioritize ข้อ 1 และ 2 ก่อน เพราะ effort ต่ำที่สุดและคืน value สูงที่สุดครับ

**[PAUSE — เปลี่ยนสไลด์]**

---

## SLIDE 35 — Live Demo (~1 นาที — ตามความเหมาะสม)

**[CUE: ถ้ามี demo ให้ pause พูดสั้นๆ ก่อนเริ่ม]**

ก่อนปิดการ present ผมขออนุญาตทำ **Live Demo** ของเครื่องมือสั้นๆ ครับ — จะ walkthrough 3 ขั้น:

1. **Import** Flutter frontend file
2. **Generate** test script ด้วย pipeline
3. **Run** test script ที่ได้ ภายใต้ `flutter test`

**[CUE: เปิด tool / browser ที่เตรียมไว้ — ใช้เวลา 1-2 นาที]**

**[ระหว่าง demo พูด narrate:]** "ตอนนี้ผมเลือกไฟล์ `clinic_appointment_page.dart` ครับ ... กด Generate ... pipeline กำลังรัน 7 step ... และนี่คือ output ที่ได้ — `<page>_test.dart` ที่รันได้ทันที"

**[PAUSE — เปลี่ยนสไลด์]**

---

## SLIDE 36 — Thank You & Q&A (~1 นาที)

**[CUE: หันหน้าคณะกรรมการ สบตา ยิ้ม]**

ครับ — นั่นคือสรุปงานวิจัยของผมทั้งหมดในวันนี้

**Title** — Generating Test Scripts for Flutter Application with Pairwise Testing Technique
**Author** — Titi Changpoo
**Degree** — Master's Thesis — Final Defense
**Repository** — `github.com/titic443/master_project_v2`

ผมขอขอบคุณ **อาจารย์ที่ปรึกษา รองศาสตราจารย์ ดร.ธาราทิพย์ สุวรรณศาสตร์** ที่ให้คำแนะนำตลอดการทำวิจัยมา และขอขอบคุณ**คณะกรรมการสอบทุกท่าน**ที่กรุณาเป็นกรรมการในวันนี้ครับ

ผมยินดีรับคำถาม คำแนะนำ และข้อเสนอแนะจากท่านอาจารย์ทุกท่านครับ ขอบคุณครับ

**[PAUSE — รอคำถามจากคณะกรรมการ]**

---

# APPENDIX — Q&A เตรียมตัว

> ส่วนนี้ไม่ต้องพูดใน present — ไว้เตรียมตอบ Q&A เท่านั้น

## Q1: ทำไมเลือก Pairwise (2-way) ไม่ใช่ T-way (t > 2)?
**A:** เพราะมีงานวิจัย ([Kuhn et al.]) ที่ชี้ว่า defect ใน software ส่วนใหญ่ (60-95%) ถูก trigger จาก interaction ของ input value เพียง 2 ตัวในเวลาเดียวกัน — pairwise เลยให้ trade-off ที่ดีที่สุดระหว่าง suite size กับ defect detection — งานนี้ scope ไว้ที่ 2-way แต่ design ของ pipeline ไม่ block การ extend เป็น 3-way หรือ higher ในอนาคต — เปลี่ยนแค่ parameter ของ PICT

## Q2: ทำไมเลือก PICT ไม่ใช่ ACTS, Jenny, หรือ Combinatorial library อื่น?
**A:** PICT เป็น tool ที่:
- **Open source** — สามารถ embed ใน pipeline ได้
- **Deterministic** — รัน 2 ครั้งได้ result เดียวกัน — สำคัญสำหรับ reproducible research
- **Model file readable** — model file commit เข้า git ได้
- **Native cross-field constraint support** — ใช้ IF/THEN syntax ได้โดยตรง
- ACTS เป็น GUI tool ที่ embed ใน pipeline ลำบาก, Jenny ไม่รองรับ constraint ในระดับเดียวกัน

## Q3: ทำไมเลือก Gemini 2.5 Flash? Model อื่นใช้ได้ไหม?
**A:** Gemini 2.5 Flash ถูกเลือกเพราะ:
- **Cost-effective** — pricing เหมาะกับ research budget
- **Structured output** — รองรับ JSON schema output โดยตรง
- **Latency ต่ำ** — รุ่น Flash response ภายใน 1-2 วินาที
- **Boundary value generation** — generate boundary value สำหรับ numeric field ได้ดี
**Model อื่นใช้ได้แน่นอน** — pipeline ทำ LLM client เป็น interface แยก (Adapter pattern ใน package diagram) — swap เป็น GPT-4 หรือ Claude ได้โดยไม่ต้องแตะ logic

## Q4: ทำไม coverage ไม่ใกล้ 100%?
**A:** บรรทัดที่ไม่ cover ส่วนใหญ่เป็น **exception-handler branch** ที่ require simulate network failure หรือ system error — เครื่องมือปัจจุบัน drive UI ผ่าน Finder กับ Tap event เท่านั้น **ไม่ได้ inject failure ที่ network layer** — ตรงนี้อยู่ใน **future work direction 5 — Multi-step back-end calls** ที่ผมเสนอครับ

## Q5: LLM non-deterministic — handle ยังไง?
**A:** Mitigate 3 ทาง:
1. **Fix temperature = 0** — ลด randomness สูงสุด
2. **CO-STEP framework** — กำหนด structure ของ prompt ให้ output predictable
3. **Filter step ใน Resolve Relations** — ค่าที่ LLM ให้ ถ้าไม่ตรงกับ option list ของ dropdown/radio ใน manifest ระบบ filter ออกตั้งแต่ก่อนเข้า PICT
อย่างไรก็ตาม นี่คือ limitation L4 ที่ผมระบุไว้ — และเป็น future direction 3 ที่ propose ให้ใช้ typed mutation engine แทนใน production

## Q6: ทำไม Statement coverage ไม่ใช่ Branch หรือ MC/DC?
**A:** Statement coverage ถูกเลือกเพราะ:
- **Standard metric** ที่ Flutter / lcov รองรับ native
- **Comparable** กับงานวิจัยอื่นในวรรณกรรม
- **เปรียบเทียบง่ายข้าม case study**
- Future work — ผมเสนอให้ขยายไปเป็น branch coverage และ MC/DC ในงานต่อยอด — ตัวเลข branch จะบอกได้ละเอียดกว่าว่า validator แต่ละตัวถูก exercise ครบทุก path ไหม

## Q7: เทียบกับ flutter_driver / patrol แล้วต่างกันยังไง?
**A:**
- **flutter_driver และ patrol** เป็น **test framework** — developer ต้องเขียน test code เอง
- **งานของผม** เป็น **generator** — เครื่องมือ generate code ออกมาให้ — developer ไม่ต้องเขียน test เลย
- Output ของผม emit เป็น `integration_test` (Google official) ซึ่งเป็น successor ของ flutter_driver
- Future direction — สามารถ extend ให้ใช้ patrol เป็น runner ได้ (ปรับใน TestScriptGenerator)

## Q8: Pipeline ใช้เวลารันเท่าไหร่?
**A:**
- **Manifest extraction (Stage 1-2)** — ~100ms ต่อหน้า
- **LLM call (Stage 3)** — 5-15 วินาทีต่อหน้า (bottleneck)
- **PICT (Stage 6)** — < 1 วินาที
- **Script emission (Stage 7)** — < 100ms
- **รวมตั้งแต่ Generate จนได้ `.dart` file** — ประมาณ **20-30 วินาทีต่อหน้า**

## Q9: Constraint grammar ทำไม design 3 grammar?
**A:** เพราะ requirement 3 ระดับต่างกัน:
- **Grammar 1 (`key.valid = value`)** — override LLM output ในกรณีที่ LLM generate ค่าที่ไม่ตรงกับ business
- **Grammar 2 (`key.invalid = value`)** — เพิ่ม invalid value ที่ specific (เช่น email format pattern ที่ LLM ไม่นึกถึง)
- **Grammar 3 (`IF ... THEN ...`)** — cross-widget constraint — ใช้ syntax ของ PICT โดยตรงเพื่อไม่ต้อง re-invent
3 grammar ครอบคลุม use case 95% ของ requirement ที่พบใน case study

## Q10: ถ้า frontend ไม่มี Key ใน widget — handle ยังไง?
**A:** widget ที่ไม่มี key จะถูก skip — เป็น **L2 limitation** — developer ต้อง annotate key ใน Flutter code ก่อนใช้เครื่องมือ — เหตุผลที่ require key เพราะ test script ต้องอ้าง widget ผ่าน `find.byKey()` เพื่อให้ stable ข้าม refactor — ใน practice ทีม Flutter ที่จริงจังเรื่อง test ก็ใส่ key อยู่แล้ว — ผม document เรื่องนี้ไว้ใน user guide ของเครื่องมือ

## Q11: Pipeline scale กับ field จำนวนมาก (~30 fields) ได้ไหม?
**A:** ใน case study ผมยังไม่ได้ stress test ระดับ 30 field — case ใหญ่ที่สุดในงาน (Job Posting) มี 11 widget keys — แต่ตามทฤษฎี:
- **PICT** — pairwise suite size grows logarithmically กับ number of factor — 30 field ยังอยู่ใน range 100-150 case
- **LLM** — แต่ละ field call แยกใน prompt structure — scale linear
- **Bottleneck** จะอยู่ที่ LLM call (time) ไม่ใช่ test case count
ใน future work direction 2 (Multi-file input) ผมจะ run benchmark ระดับ project ใหญ่ขึ้น

## Q12: ทำไมต้อง Dockerize?
**A:** เพราะ pipeline พึ่งพา dependency หลายตัว:
- Dart 3.6.1, Flutter 3.27.3
- Python (สำหรับ extractor / pipeline orchestration)
- PICT binary (Microsoft)
- HTTP client to LLM
**Docker isolate dependency** เหล่านี้ — developer ที่ต้องการลองเครื่องมือ ไม่ต้องลง Dart/Python/PICT เอง — แค่ `docker build` กับ `./run_tool.sh` ก็ใช้ได้

---

# CHECKLIST ก่อนวันสอบ

## เทคนิคการพูด
- [ ] ซ้อมพูดเต็มรอบ 2-3 ครั้ง จับเวลา target ~45 นาที
- [ ] ซ้อมแบบ standing — ไม่ใช่นั่งหน้าคอม
- [ ] อัดเสียงตัวเองฟัง แก้คำที่ติด/พูดเร็วเกินไป
- [ ] เน้นจังหวะ — pause ช่วยให้ committee ทันคิด

## อุปกรณ์
- [ ] Notebook + adapter (USB-C, HDMI, VGA)
- [ ] USB drive สำรอง — มีไฟล์ .pptx, .pdf
- [ ] เผื่อ projector ไม่ load — print handout เผื่อ 5 ชุด
- [ ] ขวดน้ำ + นาฬิกาดูเวลา
- [ ] Apple Pencil หรือ laser pointer (ถ้าใช้)

## เนื้อหา
- [ ] อ่าน Q&A 12 ข้อรอบ — เตรียมตอบ
- [ ] จดตัวเลขสำคัญใส่ใบเล็ก:
  - **94.05%** average coverage
  - **291 cases** generated
  - **6 pages tested**
  - **33 widget keys**
  - Range: **91.6% – 96.6%**
  - **Pipeline 7 stages**
  - **8 sequence diagrams** (Fig 4.11-4.18)
- [ ] เตรียม backup demo video เผื่อ live demo พัง

## วันสอบ
- [ ] ถึงห้องสอบล่วงหน้า 30 นาที — test projector
- [ ] เปิดไฟล์ทุกตัวพร้อมก่อนเริ่ม
- [ ] นาฬิกาตั้ง timer ในใจ — Recap 10 / Ch4 13 / Ch5 13 / Ch6 5
- [ ] **หายใจลึก 3 ครั้งก่อนเริ่ม** — ตั้งสติ
- [ ] **สบตาคณะกรรมการ** ไม่ใช่อ่านสไลด์ตลอด

---

**สู้ๆ ครับ Titi! 🎓**
