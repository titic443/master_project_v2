# การสร้างสคริปต์ทดสอบสำหรับแอปพลิเคชัน Flutter ด้วยเทคนิคการทดสอบแบบแพร์ไวส์

**Titi Changpoo**
ภาควิชาวิศวกรรมคอมพิวเตอร์ คณะวิศวกรรมศาสตร์ จุฬาลงกรณ์มหาวิทยาลัย กรุงเทพฯ ประเทศไทย

**Taratip Suwannasart**
ภาควิชาวิศวกรรมคอมพิวเตอร์ คณะวิศวกรรมศาสตร์ จุฬาลงกรณ์มหาวิทยาลัย กรุงเทพฯ ประเทศไทย

---

## บทคัดย่อ

ในวงจรชีวิตการพัฒนาซอฟต์แวร์ การทดสอบวิดเจ็ต (widget testing) เป็นกระบวนการที่สำคัญสำหรับการระบุและแก้ไขข้อบกพร่อง เพื่อเพิ่มความน่าเชื่อถือของซอฟต์แวร์ก่อนส่งมอบ สิ่งนี้มีความสำคัญอย่างยิ่งในโดเมนของแอปพลิเคชันมือถือที่พัฒนาด้วย Flutter framework ซึ่งมีการเปลี่ยนแปลงความต้องการบ่อยครั้ง แม้ว่าการทดสอบอัตโนมัติจะช่วยลดเวลาการทดสอบโดยรวม แต่นักพัฒนายังคงต้องมีความรู้เฉพาะทางและทุ่มเทความพยายามเริ่มต้นอย่างมากในการสร้างสคริปต์ทดสอบที่มีประสิทธิภาพด้วยภาษา Dart

บทความนี้นำเสนอเครื่องมืออัตโนมัติที่ช่วยให้การสร้างสคริปต์ทดสอบ Flutter เป็นเรื่องง่ายขึ้น โดยการนำเข้าไฟล์ซอร์สโค้ดฝั่ง front-end ดึง widget metadata (keys, เงื่อนไขการตรวจสอบ และประเภทการจัดการอินพุต) และสร้างข้อมูลทดสอบสังเคราะห์ผ่าน Large Language Model (LLM) กรณีทดสอบถูกสร้างอย่างเป็นระบบโดยใช้เทคนิคการทดสอบแบบ Pairwise ผ่านเครื่องมือ PICT สคริปต์ทดสอบ Dart ที่ได้พร้อมรันภายใน Flutter testing framework ทันที

เครื่องมือนี้ถูกประเมินกับแอปพลิเคชันมือถือในโลกจริงสามแอป ได้แก่ ระบบนัดหมายทางการแพทย์ แอปพลิเคชันประกาศหางาน และแอปพลิเคชันประกาศอสังหาริมทรัพย์ และบรรลุ statement coverage สูงกว่า 91% ในทุก screen ที่ประเมิน แสดงให้เห็นถึงประสิทธิผลเชิงปฏิบัติของวิธีการที่นำเสนอ

**คำสำคัญ:** Flutter, การสร้างการทดสอบอัตโนมัติ, pairwise testing, Dart, large language model, การทดสอบแอปพลิเคชันมือถือ, PICT

---

## I. บทนำ

อุตสาหกรรมซอฟต์แวร์ทั่วโลกยังคงเติบโตอย่างรวดเร็ว ขับเคลื่อนโดยความต้องการแอปพลิเคชันมือถือที่มีความซับซ้อน มีฟีเจอร์หลากหลาย และต้องรองรับการเปลี่ยนแปลงความต้องการบ่อยครั้ง การรับประกันคุณภาพซอฟต์แวร์ผ่านการทดสอบที่ครอบคลุมจึงเป็นสิ่งจำเป็น แต่การออกแบบกรณีทดสอบด้วยตนเองนั้นใช้เวลามากและต้องการความเชี่ยวชาญเฉพาะทางจากนักพัฒนา

ภายใน Flutter framework นักพัฒนาเขียน integration และ widget test scripts ด้วยภาษา Dart เพื่อจำลองการโต้ตอบของผู้ใช้บนส่วนต่อประสานผู้ใช้ (UI) อย่างไรก็ตาม การสร้างสคริปต์เหล่านี้กำหนดให้นักพัฒนาต้อง (1) เข้าใจโครงสร้าง widget และกฎการตรวจสอบใน source code (2) กำหนดข้อมูลอินพุตที่เหมาะสมซึ่งครอบคลุมเงื่อนไขขอบเขตทั้งที่ถูกต้องและไม่ถูกต้อง และ (3) เรียงลำดับ test actions อย่างถูกต้อง เครื่องมืออัตโนมัติที่มีอยู่ เช่น Robot Framework และ Playwright ถูกออกแบบมาสำหรับ web applications และไม่สามารถสร้างสคริปต์ทดสอบเฉพาะสำหรับ Flutter ได้โดยตรง

บทความนี้แก้ไขปัญหาเหล่านี้โดยนำเสนอเครื่องมืออัตโนมัติที่:

- **วิเคราะห์** ไฟล์ Flutter front-end (`.dart`) เพื่อดึง widget metadata
- **ใช้** Large Language Model (LLM) (Google Gemini) เพื่อสร้างข้อมูลทดสอบที่สมจริง
- **ประยุกต์ใช้** เทคนิคการทดสอบแบบ Pairwise ผ่าน PICT (Pairwise Independent Combinatorial Testing) เพื่อลดจำนวนกรณีทดสอบในขณะที่เพิ่ม input-combination coverage ให้สูงสุด
- **ส่งออก** Dart test scripts ที่พร้อมรันใน Flutter testing framework

งานวิจัยนี้มุ่งตอบคำถามวิจัย (RQs) สองข้อที่จะได้รับคำตอบใน Section V:

- **RQ1:** สคริปต์ทดสอบที่สร้างขึ้นอัตโนมัติสามารถบรรลุ statement coverage เท่าใดบน Flutter screens ในโลกจริงโดยไม่ต้องเขียน test cases ด้วยตนเอง?
- **RQ2:** เทคนิค pairwise ต้องการ test cases จำนวนเท่าใดเมื่อเทียบกับการทดสอบแบบ exhaustive combinatorial?

ส่วนที่เหลือของบทความนี้จัดดังนี้: Section II ทบทวนงานวิจัยที่เกี่ยวข้อง Section III อธิบาย methodology ที่นำเสนอ Section IV อภิปรายการออกแบบเครื่องมือ Section V นำเสนอผลการประเมิน และ Section VI สรุปบทความ

---

## II. งานวิจัยที่เกี่ยวข้อง

### A. Flutter Testing

Flutter เป็น UI toolkit แบบ open-source ของ Google สำหรับสร้างแอปพลิเคชัน cross-platform จาก Dart codebase เดียว framework นี้มี library `flutter_test` ซึ่ง expose `WidgetTester` application programming interface (API) และชุด Finders ที่หลากหลาย (`find.byKey`, `find.byType` เป็นต้น) สำหรับการค้นหาและโต้ตอบกับ widgets ระหว่างการทดสอบ

### B. การสร้างสคริปต์ทดสอบจากไฟล์ Front-End

Ekakrachawakitti เสนอวิธีการสร้างสคริปต์ทดสอบสำหรับ Robot Framework จากไฟล์ web front-end โดยดึง HTML elements และ input constraints จาก database schema Srivichayanun ขยายแนวคิดนี้โดยนำเข้า XML Schema Definition (XSD) schemas และประยุกต์ใช้ Boundary Value Analysis เพื่อสร้างข้อมูลทดสอบสำหรับ web applications งานวิจัยเหล่านี้เป็นแรงบันดาลใจในการนำเทคนิคการดึงข้อมูลที่คล้ายกันมาใช้กับโครงสร้าง widget ที่ใช้ Dart ของ Flutter

### C. การสร้างข้อมูลด้วย LLM

Tuan Pham แสดงให้เห็นว่าการจัดโครงสร้าง LLM prompts ด้วย components ที่แตกต่างกัน ได้แก่ **context, objective, style, target, execution และ polish** ช่วยเพิ่มคุณภาพของ output ที่สร้างขึ้นได้อย่างมีนัยสำคัญ กลยุทธ์ prompt engineering นี้ถูกนำมาใช้ในงานปัจจุบันเพื่อขับเคลื่อนการสร้างข้อมูลทดสอบสังเคราะห์

### D. Pairwise Testing

Pairwise (all-pairs) testing เป็นเทคนิคการออกแบบ test แบบ black-box ที่รับประกันว่าทุกคู่ของค่า input-parameter จะถูกทดสอบอย่างน้อยหนึ่ง test case ช่วยลด combinatorial explosion ของ full coverage ได้อย่างมาก PICT เป็นเครื่องมือ open-source ที่ใช้กันอย่างแพร่หลาย ซึ่งรับไฟล์ model ที่อธิบาย parameters และ levels ของ parameters และส่งออก test suite ที่ครอบคลุมและมีขนาดน้อยที่สุด

---

## III. Methodology ที่นำเสนอ

เครื่องมือที่นำเสนอทำให้กระบวนการสร้างสคริปต์ทดสอบแบบ end-to-end เป็นอัตโนมัติผ่านสี่ phase ตามลำดับ ดังแสดงในรูปที่ 1

### Phase 1 — ดึง Manifest

เครื่องมือวิเคราะห์ทุกไฟล์ `.dart` ภายใต้ directory `lib/` ของ Flutter project เป้าหมายแบบ static analysis โดยพิจารณาเฉพาะ widgets ที่มี property `Key` เท่านั้น เนื่องจาก key จำเป็นสำหรับการค้นหา widget ระหว่างการรันทดสอบผ่าน `find.byKey()`

ในระดับ **screen** เครื่องมือบันทึก Business Logic Component (BLoC)/Cubit metadata ที่จำเป็นสำหรับการสร้าง test environment ได้แก่ ชื่อ widget class ของหน้า (`pageClass`), Cubit class (`cubitClass`), State class ที่เกี่ยวข้อง (`stateClass`), และ paths ไปยัง Cubit และ State source files (`fileCubit`, `fileState`) ข้อมูลเหล่านี้ช่วยให้สคริปต์ทดสอบที่สร้างขึ้นสามารถ import ไฟล์ที่ถูกต้องและสร้าง `BlocProvider` wrapper ได้อัตโนมัติ

ในระดับ **widget** เครื่องมือบันทึก: (i) unique widget key (ii) ชื่อ widget class (iii) รูปแบบตัวอักษรที่อนุญาตจาก `inputFormatters` (iv) ความยาว input สูงสุด (`maxLength`) สำหรับ `TextFormField` widgets และ (v) กฎการตรวจสอบและข้อความ error ที่ parse จาก `validator` callbacks (`validatorRules`)

metadata ที่ดึงได้จะถูก serialize เป็นไฟล์ `manifest.json` จัดกลุ่มตามชื่อ screen

**ตารางที่ I: Metadata Fields ในไฟล์ Manifest**

| Field | คำอธิบาย | จำเป็น |
|---|---|---|
| **ระดับ Screen (source block)** | | |
| `file` | Path ไปยัง UI page source file | Y |
| `pageClass` | ชื่อ UI page widget class | Y |
| `cubitClass` | BLoC Cubit class สำหรับ screen | Y |
| `stateClass` | State class ที่เกี่ยวข้องกับ Cubit | Y |
| `fileCubit` | Path ไปยัง Cubit source file | Y |
| `fileState` | Path ไปยัง State source file | Y |
| **ระดับ Widget (widgets array)** | | |
| `key` | Unique Flutter widget key | Y |
| `widgetType` | ชื่อ widget class | Y |
| `inputFormatters` | รูปแบบตัวอักษรที่อนุญาตสำหรับ input | N |
| `maxLength` | ความยาวตัวอักษรสูงสุดสำหรับ `TextFormField` | N |
| `validatorRules` | เงื่อนไขการตรวจสอบและข้อความ error | N |

### Phase 2 — สร้าง Datasets

เฉพาะ `TextFormField` widgets เท่านั้นที่ถูกดึงจาก manifest ใน phase นี้ โดย `Dropdown` และ `Radio` widgets ถูกยกเว้น เนื่องจาก enumerated levels ของพวกมันถูก resolve โดยตรงจาก `options` list ใน Phase 1

metadata ที่กรองแล้วจะถูกประกอบเป็น structured prompt ที่มี **หกองค์ประกอบ** ตามแนวทางของ Tuan Pham:

- **context (บริบท):** `"Test data generator for Flutter form validation."`
- **objective (วัตถุประสงค์):** ห้ากฎ ได้แก่ วิเคราะห์ `maxLength`, `inputFormatters` และ `validatorRules`; ข้าม `isEmpty`/`null` rules ซึ่งจัดการแยกด้วย edge-case generation ใน Phase 3; สร้างคู่ valid/invalid หนึ่งคู่ต่อกฎที่ไม่ว่างเปล่า; รับประกันว่าค่า invalid ยังคงสอดคล้องกับ `inputFormatters` เพื่อให้ยังพิมพ์ได้; และส่งออก valid JSON
- **style (รูปแบบ):** JSON เท่านั้น ไม่มี markdown ค่าสมจริง string arrays เท่านั้น
- **target (กลุ่มเป้าหมาย):** สั่งให้โมเดลทำหน้าที่เป็น QA engineer ที่สร้างข้อมูลสำหรับ happy-path และ error-path scenarios
- **execution (การดำเนินการ):** ขั้นตอนการนับแบบ step-by-step พร้อมตัวอย่าง few-shot สองตัวอย่างที่กำหนด output schema และป้องกันค่าที่สร้างผิด
- **polish (การขัดเกลา):** เงื่อนไขคุณภาพ output ที่รับประกันความสอดคล้องของ schema และไม่มี fields เกิน

widget metadata ที่ดึงมาใน Phase 1 จะถูกแนบเป็น input data payload

prompt ถูกส่งไปยัง **Google Gemini 2.5 Flash** ผ่าน Gemini API (HTTP POST) โมเดลส่งคืนไฟล์ `<page>.datasets.json` ที่มี top-level fields ดังนี้:

- **file:** path ไปยัง front-end source file ที่วิเคราะห์
- **datasets → byKey:** map จาก `TextFormField` widget key แต่ละตัวไปยัง array ของ value-pair objects โดยสร้างหนึ่งคู่ต่อกฎการตรวจสอบที่ไม่ว่างเปล่า แต่ละ object มีห้า fields:
  - `valid` — ค่าที่ตรงตามกฎการตรวจสอบทุกข้อและสอดคล้องกับ `inputFormatters`
  - `invalid` — ค่าที่ละเมิดกฎหนึ่งข้อในขณะที่ยังสอดคล้องกับ `inputFormatters` เพื่อให้ยังพิมพ์ได้
  - `invalidRuleMessages` — ข้อความ error เฉพาะที่ validator ที่ถูกละเมิดจะแสดง
  - `atMax` — ค่าขอบเขตที่ความยาวหรือขีดจำกัดสูงสุดที่อนุญาต (ข้อมูล edge case)
  - `atMin` — ค่าขอบเขตที่ความยาวหรือขีดจำกัดต่ำสุดที่อนุญาต (ข้อมูล edge case)

### Phase 3 — สร้าง Test Data

โดยใช้ datasets ที่สร้างใน Phase 2 เครื่องมือสร้างไฟล์ PICT model โดยแต่ละ non-button widget map ไปยัง **factor** หนึ่งตัว และแต่ละค่าที่แตกต่างกัน map ไปยัง **level** หนึ่งตัว โดยสร้าง model variants สามแบบอย่างอิสระ:

1. **Valid/Invalid (VI):** `TextFormField` factors มีเฉพาะ `invalid` sentinel level เพียง level เดียว; non-text factors (Dropdown, Switch) enumerate ค่า option ทั้งหมด ทุก PICT combination มี invalid text input อย่างน้อยหนึ่งค่า ผลิต negative-path test cases
2. **Valid-only (V):** factors มีเฉพาะ valid levels; PICT สร้าง positive-path test cases
3. **Edge:** สาม boundary-value combinations ที่สร้างด้วยตนเอง (empty input, maximum-length, special characters) ถูกเพิ่มต่อท้าย

ก่อนเรียก PICT นักพัฒนาอาจระบุ **constraint file** (`<page>.constraints.txt`) แบบ optional ที่ encode กฎ business-logic ที่อยู่ใน Cubit layer และมองไม่เห็นด้วย static analysis ของไฟล์ front-end เพียงอย่างเดียว เครื่องมือรู้จักสาม grammar forms ที่ mutually exclusive:

1. **Valid override (`<key>.valid = <value>`):** กำหนดค่า **valid** เฉพาะสำหรับ widget key หนึ่งตัว เมื่อ import เครื่องมือจะเขียนทับ entry ที่สอดคล้องกันใน `<page>.datasets.json` ก่อนการเรียก PICT ใดๆ
2. **Invalid override (`<key>.invalid = <value>`):** กำหนดค่า **invalid** สำหรับ widget key โดยใช้กลไกการเขียนทับเดียวกัน forms (1) และ (2) ไม่เปลี่ยน PICT model พวกมันเปลี่ยนเฉพาะ strings จริงที่ Phase 4 ส่งออกในท้ายที่สุด
3. **Cross-widget relation (`IF [keyA] = "vA" THEN [keyB] = "vB";`):** แสดง dependency ระหว่าง widgets สองตัว โดยอาจนำหน้าด้วยการนิเสธด้วย `<>` กฎในรูปแบบนี้จะถูกเพิ่มเป็น section `[Constraints]` ทั้งใน `<page>.invalid.model.txt` และ `<page>.valid.model.txt`

เครื่องมือตรวจสอบ grammar ของทุกบรรทัดก่อนทั้งการเขียนทับ datasets หรือการเพิ่มใน model หากมี syntax error จะแสดงข้อความ "Invalid Constraint Syntax" และหยุด pipeline

จากนั้น PICT ถูกเรียกเป็น subprocess หนึ่งครั้งต่อไฟล์ model (`<page>.invalid.model.txt` สำหรับ VI และ `<page>.valid.model.txt` สำหรับ V) output แบบ tab-delimited ของ PICT ซึ่งหนึ่ง row ต่อ test case และหนึ่ง column ต่อ factor จะถูก parse และแต่ละ row ถูกประกอบเป็น **case** object พร้อมด้วย widget interaction steps และ expected assertions ทั้งสาม result arrays (VI, V, Edge) จะถูกรวมเป็นไฟล์ `<page>.test_data.json` เดียวที่มีสาม top-level keys:

- **source:** BLoC metadata ระดับ screen ที่ propagate จาก Phase 1 (`pageClass`, `cubitClass`, `stateClass`, `fileCubit`, `fileState`) Phase 4 อ่าน key นี้เพื่อส่งออก `import` statements และสร้าง `BlocProvider` wrapper
- **datasets:** คู่ค่า valid/invalid ที่สร้างใน Phase 2 จัดโดย widget key (`byKey`) Phase 4 อ่าน key นี้เพื่อ resolve ค่าจริงเมื่อ render `enterText` calls
- **cases:** รายการ test-case objects ตามลำดับ แต่ละ object มีห้า fields: `tc` (identifier เฉพาะเช่น `pairwise_invalid_cases_1`), `kind` (`success` หรือ `failed`), `group` (หนึ่งใน `pairwise_invalid_cases`, `pairwise_valid_cases` หรือ `edge_cases`), `steps` และ `asserts`

แต่ละ `steps` entry map widget type ไปยัง `WidgetTester` command: `enterText` (พร้อม `byKey` และ `dataset` reference) สำหรับ `TextFormField`; `tap` (byKey) แล้ว `tapText` (item label) สำหรับ `DropdownButtonFormField`; `tap` (byKey) สำหรับ `Radio`, `Checkbox` และ `Switch`; และ `pump` หรือ `pumpAndSettle` สำหรับการ refresh UI Widget steps ถูกเรียงลำดับตามค่า `sequence` ที่ดึงจาก source file โดย `ElevatedButton` step จะอยู่ท้ายสุดเสมอ

แต่ละ `asserts` entry ระบุทั้ง `text` string พร้อม `exists` flag (ตรวจสอบข้อความ error ที่มองเห็น) หรือ `byKey` widget identifier พร้อม `exists` flag (ตรวจสอบการมีอยู่ของ widget ที่แสดงผลสำเร็จหรือล้มเหลว)

**ตารางที่ II: Flutter Widgets ที่รองรับและ Test Interactions ที่สร้างขึ้น**

| Widget | บทบาทใน PICT | Test Command |
|---|---|---|
| `TextFormField` | Factor (N levels) | `enterText` |
| `DropdownButtonFormField` | Factor (enum) | `tap` ×2 |
| `Radio` | Factor (enum) | `tap` |
| `Checkbox` | Factor {on, off} | `tap` |
| `Switch` | Factor {on, off} | `tap` |
| `ElevatedButton` | Trigger (fixed) | `tap` (last) |
| `Text` | Assertion target | `find.text` |

### Phase 4 — สร้าง Test Script

ไฟล์ `<page>.test_data.json` ที่สร้างใน Phase 3 จะถูก render เป็นไฟล์ Dart test ที่ถูกต้องตาม syntax ชื่อ `<page>_test.dart` โดย class `TestScriptGenerator` อ่าน **source** key ก่อนเพื่อส่งออก `import` statements สามรายการ (`fileCubit`, `fileState` และไฟล์ page source) และประกาศ `BlocProvider<CubitClass>` wrapper ที่ใช้ร่วมกันใน test cases ทั้งหมดในหน้าเดียวกัน

Test cases ถูกแบ่งตาม `group` field ออกเป็นสาม `group()` blocks ในไฟล์ output: `pairwise_invalid_cases`, `pairwise_valid_cases` และ `edge_cases` แต่ละ entry ใน `cases` array กลายเป็น `testWidgets` block อิสระหนึ่งตัวที่ตั้งชื่อตาม `tc` identifier โดย block มีโครงสร้างดังนี้:

1. **Setup:** `tester.pumpWidget()` pump `MaterialApp` พร้อมหน้าที่ wrap ใน `BlocProvider` ที่ประกาศจาก `source` metadata
2. **Interact:** แต่ละ `steps` entry แปลเป็น `WidgetTester` call ที่สอดคล้องกันตามลำดับ โดย `enterText` resolve ค่าจาก `datasets` key; `tap` และ `tapText` ค้นหา widgets ด้วย key หรือ label text; `pump` และ `pumpAndSettle` synchronize UI ระหว่างการโต้ตอบ
3. **Assert:** แต่ละ `asserts` entry render เป็น `expect()` call โดย `text`-based entry กลายเป็น `expect(find.text('msg'), findsOneWidget)` และ `byKey`-based entry กลายเป็น `expect(find.byKey(Key('k')), findsOneWidget)` โดย matcher สลับระหว่าง `findsOneWidget` และ `findsNothing` ตาม `exists` flag

`ElevatedButton` step จะเป็น interaction สุดท้ายเสมอ ตามด้วย `pumpAndSettle()` เพื่อรับประกันว่า asynchronous UI updates ทั้งหมดสงบก่อนที่ assertions จะรัน

---

## IV. การออกแบบและการ Implement เครื่องมือ

### A. User Interface

รูปที่ 2 แสดง main window ของเครื่องมือ interface มีสาม inputs และหนึ่ง action ที่ครอบคลุม workflow การสร้าง test ทั้งหมด:

1. **Flutter front-end file:** file-picker สำหรับ target `.dart` screen file เครื่องมือตรวจสอบชนิดไฟล์และยืนยันว่ามี widget ที่รองรับและมี key อย่างน้อยหนึ่งตัว หากชนิดไฟล์ไม่รองรับจะแสดงข้อความ "Invalid File Type" และบล็อกการประมวลผลต่อ
2. **Condition file (optional):** file-picker ที่สองสำหรับ PICT constraint file แบบ optional ที่เขียนใน syntax `IF...THEN...` หากระบุ เครื่องมือจะตรวจสอบ constraint syntax ก่อนดำเนินการต่อ หากไฟล์ผิดพลาดจะแสดงข้อความ "Invalid Constraint Syntax"
3. **Output directory:** directory-picker ที่กำหนด destination folder สำหรับ artifacts ที่สร้างทั้งหมด ได้แก่ `manifest.json`, `datasets.json`, `test_data.json` และ `<page>_test.dart`
4. **Generate button:** การคลิก Generate จะ trigger pipeline สี่ phase เต็มรูปแบบ สถานะความคืบหน้าและข้อความ error จะแสดงแบบ inline ใน main window

### B. การติดตั้ง

ต้องมี prerequisites ต่อไปนี้ก่อนใช้เครื่องมือ:

1. **Docker** (v28.0.0 หรือใหม่กว่า): เริ่ม back-end container ที่ host **FastAPI** (v0.114.1) service ที่เปิดเผย REST endpoints สำหรับแต่ละ pipeline phase ด้วยคำสั่ง `docker run -p 8000:8000 <image>`
2. **PICT:** ติดตั้ง Microsoft PICT binary และรับประกันว่าเข้าถึงได้จาก system `PATH` เครื่องมือเรียก PICT เป็น subprocess ระหว่าง Phase 3
3. **Gemini API key:** กำหนด key เป็น environment variable หรือป้อนใน settings panel ของเครื่องมือ key จำเป็นสำหรับการเรียก LLM ใน Phase 2
4. **Web browser:** รัน `bash run_tool.sh` เพื่อเริ่ม web interface server จากนั้นเปิด browser และไปที่ `http://localhost:8080` เพื่อเข้าใช้งานเครื่องมือ

### C. Widgets ที่รองรับ

เวอร์ชันปัจจุบันรองรับ widget types เจ็ดแบบตามที่แสดงในตารางที่ II (Section III) โดยห้า widget types ทำหน้าที่เป็น PICT factors (`TextFormField`, `DropdownButtonFormField`, `Radio`, `Checkbox`, `Switch`) หนึ่งตัวทำหน้าที่เป็น fixed trigger (`ElevatedButton`) และหนึ่งตัวทำหน้าที่เป็น assertion target (`Text`)

### D. การสร้าง PICT Model

สำหรับ screen ที่มี n non-button widgets ไฟล์ PICT model จะมีบรรทัด parameter n บรรทัดในรูปแบบ `<key>: v1, v2, ..., vk` โดยแต่ละ `vi` คือ distinct value level เครื่องมือสร้างไฟล์ model สามไฟล์แยกกัน (VI, V และ Edge) และเรียก PICT หนึ่งครั้งต่อไฟล์ แต่ละการรัน PICT คืน covering array ที่น้อยที่สุด และทั้งสาม arrays ถูก concatenate เพื่อสร้าง test suite ที่สมบูรณ์สำหรับ screen นั้น

สำหรับ `TextFormField` VI model กำหนด factor นี้มีเพียง `invalid` sentinel level เดียว; V model กำหนด `valid` level เดียว แต่ละ model จึงมีหนึ่ง text-field level ต่อ factor เสมอ `DropdownButtonFormField` และ `Radio` factors จะ enumerate ทุก options ที่ดึงจาก source code

### E. ข้อจำกัดในการ Implement

สคริปต์ที่สร้างขึ้นครอบคลุมหน้าแอปพลิเคชัน **หนึ่ง** หน้าต่อการรัน widget เป้าหมายทุกตัวต้องมี property `Key` ที่ไม่ซ้ำกัน widgets ที่ไม่มี key จะถูกข้ามโดยเงียบ การเรียก LLM ต้องการ Gemini API key ที่ valid ในขณะรัน และ PICT ต้องติดตั้งและเข้าถึงได้จาก system `PATH`

---

## V. การประเมินผล

### A. Experimental Setup

เครื่องมือถูกประเมินกับ Flutter applications ในโลกจริงสามแอป ได้แก่ แอป **Medical Appointment**, แอป **Job Listing** และแอป **Real-Estate Listing** โดยเลือก screens สองหน้าต่อแอปพลิเคชัน รวมทั้งหมดหกการประเมินระดับ screen สภาพแวดล้อมทดสอบใช้ Flutter v3.27.3 รันบน macOS Sequoia 15.4.1 Statement coverage วัดโดยใช้ Flutter `--coverage` flag ร่วมกับ `lcov` เพื่อกรองผลลัพธ์เฉพาะ UI page files

### B. Case Studies Overview

สามแอปพลิเคชันแสดงระดับความซับซ้อนของ form-validation ที่เพิ่มขึ้น แอป **Medical Appointment** มี booking screen ที่มี input widgets เก้าตัว (TextFormField, DropdownButtonFormField, Radio, Switch) และ search screen ที่เบากว่า แอป **Job Listing** มี posting screen ที่มีกฎ cross-field validation ที่ซับซ้อน (เช่น salary range constraints) และ search screen ที่มี widget count สูงกว่า แอป **Real-Estate Listing** นำเสนอสอง screens ที่มีความซับซ้อนใกล้เคียงกัน โดยแต่ละแบบรวม text, dropdown และ toggle widgets

### C. Case Study 1: แอปพลิเคชัน Medical Appointment

แอปพลิเคชัน Medical Appointment ประกอบด้วย appointment-booking screen ที่มี input widgets เก้าตัวและ search screen ที่เบากว่า เครื่องมือสร้าง 52 test cases (28 VI, 21 V, 3 Edge) สำหรับ booking screen และ 6 test cases (2 VI, 1 V, 3 Edge) สำหรับ search screen

### D. Case Study 2: แอปพลิเคชัน Job Listing

แอปพลิเคชัน Job Listing มี posting screen ที่มีกฎ mutual validation ที่ซับซ้อนระหว่าง fields (เช่น salary-range constraints) และ search screen ที่มี widget count ใกล้เคียงกัน เครื่องมือสร้าง 64 test cases (31 VI, 30 V, 3 Edge) สำหรับ posting screen และ 63 test cases (30 VI, 30 V, 3 Edge) สำหรับ search screen แสดงให้เห็นว่า pairwise coverage ปรับตัวได้อย่างเป็นธรรมชาติกับ screens ที่มี dense cross-field constraints

### E. Case Study 3: แอปพลิเคชัน Real-Estate Listing

แอปพลิเคชัน Real-Estate Listing นำเสนอสอง screens ที่มีความซับซ้อนใกล้เคียงกัน ได้แก่ posting และ search โดยแต่ละแบบรวม text, dropdown และ toggle widgets เครื่องมือสร้าง 55 test cases (27 VI, 25 V, 3 Edge) ต่อ screen ยืนยันว่าเครื่องมือสร้าง case count ที่เสถียรสำหรับ screens ที่มี widget inventories ใกล้เคียงกัน

### F. ผลการ Coverage

**ตารางที่ III: สรุป Test Coverage**

| แอปพลิเคชัน | Screen | Cases | Statements | Stmt. Coverage |
|---|---|---|---|---|
| Medical Appt. | Booking | 52 | 166/173 | 96.0% |
| Medical Appt. | Search | 6 | 141/154 | 91.6% |
| Job Listing | Posting | 64 | 161/172 | 93.6% |
| Job Listing | Search | 63 | 223/239 | 93.3% |
| Real Estate | Posting | 55 | 169/175 | 96.6% |
| Real Estate | Search | 55 | 233/250 | 93.2% |

**ตารางที่ IV: Pairwise Test-Case Breakdown ต่อ Screen**

| App | Screen | VI | V | Edge |
|---|---|---|---|---|
| Medical Appt. | Booking | 28 | 21 | 3 |
| Medical Appt. | Search | 2 | 1 | 3 |
| Job Listing | Posting | 31 | 30 | 3 |
| Job Listing | Search | 30 | 30 | 3 |
| Real Estate | Posting | 27 | 25 | 3 |
| Real Estate | Search | 27 | 25 | 3 |

*VI = pairwise valid/invalid; V = pairwise valid; Edge = edge cases*

ทุกหก screens บรรลุ statement coverage สูงกว่า **91%** โดยผลสูงสุด (**96.6%**, Real-Estate posting) ได้รับแม้จะมี test-case count ที่ลดลง สามลักษณะของสคริปต์ที่สร้างขึ้นมีส่วนทำให้เกิดผลนี้: (i) ทุก widget interaction ใช้ `find.byKey` ซึ่งให้ locator ที่เสถียรและรองรับการ refactor UI; (ii) ทุก `validatorRule` ที่ไม่ว่างเปล่าขับเคลื่อนค่า invalid หนึ่งค่าบวกกับ valid counterpart หนึ่งค่า รับประกันว่า validation branch แต่ละตัวใน Cubit ถูก exercise อย่างน้อยหนึ่งครั้ง; (iii) ทั้ง VI และ V script groups ถูกสร้างในการเรียกครั้งเดียว ให้ทีม coverage ของ positive และ negative test paths ทันที

### G. คำตอบสำหรับคำถามวิจัย

**RQ1 — Coverage ที่บรรลุ:**
ตารางที่ III ยืนยันว่าทุกหก screens เกิน 91% statement coverage โดยไม่ต้องเขียน test cases ด้วยตนเอง โดยมี peak 96.6% สำหรับ Real-Estate posting screen สคริปต์ที่สร้างขึ้นอัตโนมัติจึงบรรลุ code-path coverage สูงในรูปแบบ form ที่หลากหลาย

**RQ2 — Combinatorial Reduction:**
ตารางที่ V เปรียบเทียบ exhaustive combinatorial count กับ pairwise VI count สำหรับแต่ละ screen โดยคำนวณ exhaustive count จาก product ของ factor levels ทั้งหมด (โดยนับแต่ละ `TextFormField` เป็น 2 states: valid และ invalid) การลดขนาดขึ้นอยู่กับจำนวน parameters: screens ที่มี factor เดียวไม่แสดงการลดขนาด ในขณะที่ screens ที่มี 11-12 factors บรรลุการลดขนาดสามอันดับ (991× สำหรับ Job-Listing posting; 3,413× สำหรับ Real-Estate posting) ยืนยันว่า pairwise เป็นสิ่งจำเป็นสำหรับการรักษา test suites ให้จัดการได้เมื่อความซับซ้อนของ form เติบโตขึ้น

**ตารางที่ V: Pairwise VI Cases vs. Exhaustive Combinatorial Count**

| App | Screen | Exhaustive | Pairwise VI | Reduction |
|---|---|---|---|---|
| Medical Appt. | Booking | 1,792 | 28 | 64× |
| Medical Appt. | Search | 2 | 2 | 1× |
| Job Listing | Posting | 30,720 | 31 | 991× |
| Job Listing | Search | 240 | 30 | 8× |
| Real Estate | Posting | 92,160 | 27 | 3,413× |
| Real Estate | Search | 960 | 27 | 36× |

*Exhaustive = product ของ factor levels (2 states ต่อ `TextFormField`: valid และ invalid)*

---

## VI. สรุป

บทความนี้นำเสนอเครื่องมืออัตโนมัติสำหรับสร้าง Flutter widget test scripts โดยใช้การผสมผสานระหว่าง source-code metadata extraction, LLM-driven synthetic data generation และเทคนิค Pairwise testing เครื่องมือนี้ไม่ต้องการการเขียน test cases ด้วยตนเอง นักพัฒนาเพียงระบุ Flutter front-end files และได้รับ Dart test scripts ที่พร้อมรันเป็น output การประเมินกับ mobile applications ในโลกจริงสามแอปยืนยันว่าเครื่องมือสร้าง executable test scripts ที่มี code coverage ที่วัดได้สำเร็จ

**ข้อจำกัดปัจจุบัน** ได้แก่ การรองรับ widget types เจ็ดชนิดที่ตายตัว ข้อกำหนดว่า widget เป้าหมายทุกตัวต้องมี property `Key` ที่ไม่ซ้ำกัน (widgets ที่ไม่มี key จะถูกข้ามโดยเงียบ) ขอบเขตหนึ่ง screen ต่อการรัน และกรณีที่ expected results อาจไม่ครอบคลุมทุก validation scenarios ได้อย่างสมบูรณ์

**งานในอนาคต** จะขยายการรองรับ widget ไปยังชนิดเพิ่มเติม เปิดใช้งานการสร้างสคริปต์ทดสอบจากหลาย source files พร้อมกัน รองรับ constraint syntax ที่มี expressive มากขึ้นสำหรับ complex cross-field rules นำวิธีการนี้ไปใช้กับ mobile frameworks อื่นเช่น React Native, Xamarin และ SwiftUI รองรับ back-end requests หลายครั้งภายใน test case เดียว และเปิดใช้งาน multi-screen end-to-end testing พร้อม navigation linking ระหว่างหน้า

---

## อ้างอิง

- **[b1]** Flutter — Google's open-source UI toolkit for building natively compiled cross-platform applications from a single Dart codebase
- **[b2]** Ekakrachawakitti — วิธีการสร้างสคริปต์ทดสอบ Robot Framework จากไฟล์ web front-end โดยใช้ HTML elements และ database schema constraints
- **[b3]** Srivichayanun — การสร้างข้อมูลทดสอบสำหรับ web applications โดยใช้ XSD schemas และ Boundary Value Analysis
- **[b4]** Tuan Pham — CO-STEP prompt engineering framework สำหรับการปรับปรุงคุณภาพ output ของ LLM (context, objective, style, target, execution, polish)
- **[b5]** Google Gemini 2.5 Flash — LLM ที่ใช้สำหรับการสร้างข้อมูลทดสอบสังเคราะห์
- **[b7]** Pairwise (all-pairs) testing — เทคนิคการออกแบบ test แบบ black-box ที่รับประกันว่าทุกคู่ของค่า parameter ถูกทดสอบ
- **[b8]** PICT (Pairwise Independent Combinatorial Testing) — เครื่องมือ open-source ของ Microsoft สำหรับสร้าง pairwise test suite
