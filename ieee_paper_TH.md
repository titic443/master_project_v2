# การสร้าง Test Script สำหรับแอปพลิเคชัน Flutter โดยใช้เทคนิค Pairwise Testing

**Titi Changpoo**  
ภาควิชาวิศวกรรมคอมพิวเตอร์ คณะวิศวกรรมศาสตร์ จุฬาลงกรณ์มหาวิทยาลัย  
กรุงเทพมหานคร ประเทศไทย | titi.changpoo@gmail.com

**Taratip Suwannasart**  
ภาควิชาวิศวกรรมคอมพิวเตอร์ คณะวิศวกรรมศาสตร์ จุฬาลงกรณ์มหาวิทยาลัย  
กรุงเทพมหานคร ประเทศไทย | taratip.s@chula.ac.th

---

## บทคัดย่อ

ในวงจรการพัฒนาซอฟต์แวร์ การทดสอบ widget เป็นกระบวนการสำคัญสำหรับการตรวจหาและแก้ไขข้อบกพร่อง เพื่อเพิ่มความน่าเชื่อถือของซอฟต์แวร์ก่อนการส่งมอบ สิ่งนี้มีความสำคัญอย่างยิ่งในโดเมนที่พัฒนาอย่างรวดเร็วของแอปพลิเคชันมือถือที่พัฒนาด้วย Flutter framework ซึ่งมีการเปลี่ยนแปลงความต้องการบ่อยครั้ง แม้ว่าการทดสอบอัตโนมัติจะช่วยลดเวลาทดสอบโดยรวม แต่นักพัฒนายังคงต้องการความรู้เฉพาะทางและความพยายามเริ่มต้นที่สำคัญในการสร้าง test script ที่มีประสิทธิภาพในภาษา Dart

บทความนี้นำเสนอเครื่องมืออัตโนมัติที่ทำให้การสร้าง Flutter test script คล่องตัวขึ้น โดยการนำเข้าไฟล์ source code ฝั่ง front-end, ดึง widget metadata (keys, validation conditions และ input-handling types), และสร้างข้อมูลทดสอบสังเคราะห์ผ่าน Large Language Model (LLM) Test case ถูกสร้างอย่างเป็นระบบโดยใช้เทคนิค Pairwise testing ผ่านเครื่องมือ PICT Dart test script ที่ได้สามารถรันได้ทันทีภายใน Flutter testing framework

เครื่องมือนี้ถูกประเมินกับแอปพลิเคชันมือถือในโลกจริงสามตัว ได้แก่ ระบบนัดหมายแพทย์, แอปรายชื่องาน, และแอปรายชื่ออสังหาริมทรัพย์ และได้รับ statement coverage สูงกว่า 91% ในทุก screen ที่ประเมิน ซึ่งแสดงให้เห็นถึงประสิทธิผลเชิงปฏิบัติของแนวทางที่เสนอ

**คำสำคัญ:** Flutter, automated test generation, pairwise testing, Dart, large language model, mobile application testing, PICT

---

## I. บทนำ

อุตสาหกรรมซอฟต์แวร์ระดับโลกยังคงเติบโตอย่างรวดเร็ว ขับเคลื่อนโดยความต้องการที่เพิ่มขึ้นสำหรับแอปพลิเคชันมือถือที่ซับซ้อน มีฟีเจอร์มาก และต้องเปลี่ยนแปลงความต้องการบ่อยครั้ง การประกันคุณภาพซอฟต์แวร์ผ่านการทดสอบที่ครอบคลุมจึงเป็นสิ่งจำเป็น แต่การออกแบบ test case ด้วยมือนั้นใช้เวลานานและต้องการความเชี่ยวชาญเชิงลึกจากนักพัฒนา

ภายใน Flutter framework นักพัฒนาเขียน integration และ widget test script ใน Dart เพื่อจำลองการโต้ตอบของผู้ใช้บน user interface (UI) อย่างไรก็ตาม การสร้าง script เหล่านี้ต้องการให้นักพัฒนา (1) เข้าใจโครงสร้าง widget และกฎการตรวจสอบใน source code, (2) กำหนดข้อมูล input ที่เหมาะสมซึ่งครอบคลุมเงื่อนไขขอบเขตที่ valid และ invalid, และ (3) จัดลำดับ test action อย่างถูกต้อง เครื่องมืออัตโนมัติที่มีอยู่ เช่น Robot Framework และ Playwright ถูกออกแบบสำหรับ web application และไม่สามารถสร้าง Flutter-specific test script ได้โดยตรง

บทความนี้แก้ไขปัญหาเหล่านี้โดยเสนอเครื่องมืออัตโนมัติที่:

- แยกวิเคราะห์ไฟล์ Flutter front-end (`.dart`) เพื่อดึง widget metadata
- ใช้ Large Language Model (LLM) (Google Gemini) เพื่อสร้างข้อมูลทดสอบที่สมจริง
- ใช้เทคนิค Pairwise testing ผ่าน PICT (Pairwise Independent Combinatorial Testing) เพื่อลดจำนวน test case ให้น้อยที่สุดขณะที่เพิ่ม input-combination coverage ให้สูงสุด
- ส่งออก Dart test script ที่รันได้ พร้อมสำหรับ Flutter testing framework

งานนี้ได้รับการชี้นำโดยคำถามวิจัยสองข้อ (RQ) ที่ตอบในหัวข้อ V:

- **RQ1:** test script ที่สร้างอัตโนมัติสามารถทำ statement coverage ได้เท่าใดบน Flutter screen ในโลกจริง โดยไม่ต้องเขียน test case ด้วยมือ?
- **RQ2:** เทคนิค pairwise ต้องการ test case กี่ตัวเมื่อเทียบกับการทดสอบแบบ exhaustive combinatorial?

โครงสร้างที่เหลือของบทความนี้มีดังนี้ หัวข้อ II ทบทวนงานที่เกี่ยวข้อง หัวข้อ III อธิบายระเบียบวิธีที่เสนอ หัวข้อ IV อภิปรายการออกแบบเครื่องมือ หัวข้อ V นำเสนอผลการประเมิน และหัวข้อ VI สรุปบทความ

---

## II. งานที่เกี่ยวข้อง

### A. Flutter Testing

Flutter เป็น UI toolkit open-source ของ Google สำหรับการสร้างแอปพลิเคชัน cross-platform จาก Dart codebase เดียว framework นี้มี library `flutter_test` ซึ่งเปิดเผย `WidgetTester` application programming interface (API) และชุด Finder ที่สมบูรณ์ (`find.byKey`, `find.byType` เป็นต้น) สำหรับการค้นหาและโต้ตอบกับ widget ระหว่างการทดสอบ

### B. การสร้าง Test Script จากไฟล์ Front-End

Ekakrachawakitti เสนอวิธีการสร้าง Robot Framework test script จากไฟล์ web front-end โดยการดึง HTML element และ input constraint จาก database schema Srivichayanun ขยายแนวคิดนี้โดยการนำเข้า XML Schema Definition (XSD) schema และใช้ Boundary Value Analysis เพื่อสร้างข้อมูลทดสอบสำหรับ web application งานเหล่านี้เป็นแรงบันดาลใจในการนำเทคนิคการดึงข้อมูลที่คล้ายกันมาใช้กับโครงสร้าง widget ที่ใช้ Dart ของ Flutter

### C. การสร้างข้อมูลด้วย LLM

Tuan Pham แสดงให้เห็นว่าการจัดโครงสร้าง LLM prompt ด้วย component ที่แตกต่างกัน ได้แก่ context, objective, style, target, execution และ polish ช่วยปรับปรุงคุณภาพของ output ที่สร้างขึ้นอย่างมีนัยสำคัญ กลยุทธ์ prompt-engineering นี้ถูกนำมาใช้ในงานปัจจุบันเพื่อขับเคลื่อนการสร้างข้อมูลทดสอบสังเคราะห์

### D. Pairwise Testing

Pairwise (all-pairs) testing เป็นเทคนิคการออกแบบ test แบบ black-box ที่รับประกันว่า input-parameter value ทุกคู่จะถูกทดสอบโดย test case อย่างน้อยหนึ่งตัว ช่วยลด combinatorial explosion ของ full coverage อย่างมาก PICT เป็นเครื่องมือ open-source ที่ใช้กันอย่างแพร่หลาย ซึ่งรับไฟล์ model ที่อธิบาย parameter และระดับของมัน และส่งออก test suite ที่ครอบคลุมน้อยที่สุด

---

## III. ระเบียบวิธีที่เสนอ

เครื่องมือที่เสนอทำให้กระบวนการสร้าง test script แบบ end-to-end เป็นอัตโนมัติผ่านสี่ขั้นตอนตามลำดับ ดังแสดงใน Fig. 1

### Phase 1 — ดึง Manifest

เครื่องมือวิเคราะห์ไฟล์ `.dart` ทุกไฟล์ภายใต้ไดเรกทอรี `lib/` ของ Flutter project เป้าหมายแบบ static โดยพิจารณาเฉพาะ widget ที่มี property `Key` เท่านั้น เนื่องจาก key เป็นสิ่งจำเป็นสำหรับการค้นหา widget ระหว่างการรัน test ผ่าน `find.byKey()`

ในระดับ **screen** เครื่องมือบันทึก Business Logic Component (BLoC)/Cubit metadata ที่จำเป็นสำหรับการสร้าง test environment ได้แก่ ชื่อ class ของ page widget (`pageClass`), Cubit class (`cubitClass`), State class ที่เกี่ยวข้อง (`stateClass`) และ path ไปยัง Cubit และ State source file (`fileCubit`, `fileState`) field เหล่านี้ช่วยให้ test script ที่สร้างขึ้นสามารถ import ไฟล์ที่ถูกต้องและสร้าง `BlocProvider` wrapper ได้อัตโนมัติ

ในระดับ **widget** เครื่องมือบันทึก: (i) widget key ที่ไม่ซ้ำกัน, (ii) ชื่อ class ของ widget, (iii) รูปแบบอักขระที่อนุญาตจาก `inputFormatters`, (iv) ความยาว input สูงสุด (`maxLength`) สำหรับ `TextFormField` widget, และ (v) กฎการตรวจสอบและข้อความแสดงข้อผิดพลาดที่แยกวิเคราะห์จาก `validator` callback (`validatorRules`)

metadata ที่ดึงมาจะถูก serialize เป็นไฟล์ `manifest.json` จัดกลุ่มตามชื่อ screen ตาราง I แสดง field ที่บันทึกต่อ screen และต่อ widget

**ตาราง I: Metadata Fields ในไฟล์ Manifest**

| Field | คำอธิบาย | จำเป็น |
|---|---|---|
| **ระดับ Screen (source block)** | | |
| `file` | Path ไปยัง UI page source file | Y |
| `pageClass` | ชื่อ class ของ UI page widget | Y |
| `cubitClass` | BLoC Cubit class สำหรับ screen | Y |
| `stateClass` | State class ที่เกี่ยวข้องกับ Cubit | Y |
| `fileCubit` | Path ไปยัง Cubit source file | Y |
| `fileState` | Path ไปยัง State source file | Y |
| **ระดับ Widget (widgets array)** | | |
| `key` | Flutter widget key ที่ไม่ซ้ำกัน | Y |
| `widgetType` | ชื่อ class ของ widget | Y |
| `inputFormatters` | รูปแบบอักขระที่อนุญาตสำหรับ input | N |
| `maxLength` | ความยาวอักขระสูงสุดสำหรับ `TextFormField` | N |
| `validatorRules` | เงื่อนไขการตรวจสอบและข้อความแสดงข้อผิดพลาด | N |

### Phase 2 — สร้าง Datasets

เฉพาะ `TextFormField` widget เท่านั้นที่ถูกดึงจาก manifest สำหรับ phase นี้

metadata ที่กรองแล้วจะถูกรวมเป็น structured prompt ตาม six-component framework ของ Tuan Pham (context, target, objective, execution, style, polish) กฎ objective หลักสั่งให้ model วิเคราะห์ `maxLength`, `inputFormatters` และ `validatorRules`; ข้ามการตรวจสอบ `isEmpty`/`null` (จัดการโดย edge-case generation ใน Phase 3); สร้าง valid/invalid pair หนึ่งคู่ต่อกฎที่ไม่ว่าง; รับประกันว่าค่า invalid ยังคงสอดคล้องกับ `inputFormatters`; และส่งคืน JSON ที่ถูกต้อง ตัวอย่าง few-shot สองตัวอย่างใน execution component กำหนด output schema และป้องกันค่าที่ hallucinate metadata ของ widget จาก Phase 1 ถูกแนบเป็น input payload

prompt ถูกส่งไปยัง **Google Gemini 2.5 Flash** ผ่าน Gemini API (HTTP POST) model ส่งคืนไฟล์ `<page>.datasets.json` ที่มี field ระดับ top-level ดังนี้:

- **file:** path ไปยัง front-end source file ที่วิเคราะห์
- **datasets → byKey:** map จาก key ของ `TextFormField` widget แต่ละตัวไปยัง array ของ value-pair object โดยสร้างหนึ่งคู่ต่อกฎการตรวจสอบที่ไม่ว่าง แต่ละ object มีห้า field:
  - `valid` — ค่าที่ตรงตามกฎการตรวจสอบทุกข้อและสอดคล้องกับ `inputFormatters`
  - `invalid` — ค่าที่ละเมิดกฎเพียงข้อเดียวขณะที่ยังสอดคล้องกับ `inputFormatters` เพื่อให้มั่นใจว่าผู้ใช้ยังสามารถพิมพ์ได้
  - `invalidRuleMessages` — ข้อความแสดงข้อผิดพลาดที่ validator ที่ถูกละเมิดจะแสดง
  - `atMax` — ค่าขอบเขตที่ความยาวหรือขีดจำกัดสูงสุดที่อนุญาต (ข้อมูล edge-case)
  - `atMin` — ค่าขอบเขตที่ความยาวหรือขีดจำกัดต่ำสุดที่อนุญาต (ข้อมูล edge-case)

### Phase 3 — สร้าง Test Data

โดยใช้ dataset ที่สร้างใน Phase 2 เครื่องมือสร้างไฟล์ PICT model ซึ่ง widget ที่ไม่ใช่ button แต่ละตัวแมปกับ **factor** หนึ่งตัว และค่าที่แตกต่างกันแต่ละค่าแมปกับ **level** หนึ่งระดับ สร้าง model variant สามแบบอย่างอิสระ:

1. **Valid/Invalid (VI):** `TextFormField` factors มีเฉพาะ `invalid` sentinel level; non-text factors (`Dropdown`, `Radio`, `Checkbox`, `Switch`) ระบุค่า option ทั้งหมด ทุก PICT combination จึงมี text input ที่ invalid อย่างน้อยหนึ่งตัว สร้าง negative-path test case
2. **Valid-only (V):** factors มีเฉพาะ valid level; PICT สร้าง positive-path test case
3. **Edge:** boundary-value combination สามชุดที่สร้างด้วยมือ (empty input, ความยาวสูงสุด, ความยาวต่ำสุด) ถูกเพิ่มเข้ามา

ก่อนเรียก PICT นักพัฒนาอาจจัดหา **constraint file** เสริม (`<page>.constraints.txt`) ที่เข้ารหัสกฎ business-logic ที่มองไม่เห็นจาก static analysis รูปแบบ grammar สามแบบถูกรับรู้: (1) `<key>.valid = <value>` และ (2) `<key>.invalid = <value>` ปักหมุด string ที่เป็นรูปธรรมใน `<page>.datasets.json` ก่อน PICT รัน โดยไม่แตะ model; (3) `IF [key_A] = "v" THEN [key_B] = "v";` เพิ่มกฎ cross-widget ลงในไฟล์ model ทั้งสองเพื่อให้ PICT สร้างเฉพาะ combination ที่เป็นไปตามเงื่อนไข ข้อผิดพลาดทาง syntax จะแสดงข้อความ "Invalid Constraint Syntax" และหยุด pipeline

จากนั้น PICT ถูกเรียกเป็น subprocess หนึ่งครั้งต่อไฟล์ model (`<page>.invalid.model.txt` สำหรับ VI และ `<page>.valid.model.txt` สำหรับ V) output ที่คั่นด้วย tab ของมัน ซึ่งแต่ละแถวเป็น test case หนึ่งแถว และแต่ละคอลัมน์เป็น factor หนึ่งตัว ถูก parse และแต่ละแถวถูกประกอบเป็น case object พร้อมกับ widget interaction step และ expected assertion ที่คาดหวัง

array ผลลัพธ์สามชุด (VI, V, Edge) จะถูกรวมเป็นไฟล์ `<page>.test_data.json` ไฟล์เดียวที่มี top-level key สามตัว:

- **source:** BLoC metadata ระดับ screen ที่ส่งต่อมาจาก Phase 1 (`pageClass`, `cubitClass`, `stateClass`, `fileCubit`, `fileState`) Phase 4 อ่าน key นี้เพื่อส่ง `import` statement และสร้าง `BlocProvider` wrapper
- **datasets:** valid/invalid value pair ที่สร้างใน Phase 2 โดย key ของ widget (`byKey`) Phase 4 อ่าน key นี้เพื่อ resolve ค่าที่เป็นรูปธรรมเมื่อ render `enterText` call
- **cases:** รายการ test-case object ที่เรียงลำดับ แต่ละ object มีห้า field: `tc` (identifier ที่ไม่ซ้ำกัน เช่น `pairwise_invalid_cases_1`), `kind` (`success` หรือ `failed`), `group` (หนึ่งใน `pairwise_invalid_cases`, `pairwise_valid_cases` หรือ `edge_cases`), `steps` และ `asserts`

แต่ละ `steps` entry แมป widget type กับ `WidgetTester` command: `enterText` (กับ `byKey` และ `dataset` reference) สำหรับ `TextFormField`; `tap` (byKey) แล้ว `tapText` (item label) สำหรับ `DropdownButtonFormField`; `tap` (byKey) สำหรับ `Radio`, `Checkbox` และ `Switch`; และ `pump` หรือ `pumpAndSettle` สำหรับ UI refresh Widget step ถูกเรียงลำดับโดยค่า `sequence` ที่ดึงมาจาก source file โดย `ElevatedButton` step อยู่ท้ายเสมอ แต่ละ `asserts` entry ระบุ `text` string กับ `exists` flag (ตรวจสอบข้อความแสดงข้อผิดพลาดที่มองเห็น) หรือ `byKey` widget identifier กับ `exists` flag (ตรวจสอบการมีอยู่ของ success หรือ failure indicator widget)

**ตาราง II: Flutter Widget ที่รองรับและ Test Interaction ที่สร้าง**

| Widget | บทบาทใน PICT | Test Command |
|---|---|---|
| `TextFormField` | Factor (N levels) | `enterText` |
| `DropdownButtonFormField` | Factor (enum) | `tap` ×2 |
| `Radio` | Factor (enum) | `tap` |
| `Checkbox` | Factor {checked, unchecked} | `tap` |
| `Switch` | Factor {on, off} | `tap` |
| `ElevatedButton` | Trigger (fixed) | `tap` (last) |
| `Text` | Assertion target | `find.text` |

### Phase 4 — สร้าง Test Script

ไฟล์ `<page>.test_data.json` ที่สร้างใน Phase 3 ถูก render เป็นไฟล์ Dart test ที่ถูกต้องทาง syntax ชื่อ `<page>_test.dart` class `TestScriptGenerator` อ่าน key **source** ก่อนเพื่อส่ง `import` statement สาม statement (`fileCubit`, `fileState` และ page source file) และประกาศ `BlocProvider<CubitClass>` wrapper ที่ใช้ซ้ำใน test case ทั้งหมดบน screen เดียวกัน

Test case ถูกแบ่งตาม field `group` เป็น `group()` block สามบล็อกในไฟล์ output: `pairwise_invalid_cases` (VI cases ที่ตรวจสอบการปฏิเสธ form บน invalid input), `pairwise_valid_cases` (V cases ที่ตรวจสอบการ submit สำเร็จบน valid input) และ `edge_cases` (boundary-value cases)

แต่ละ entry ใน `cases` array กลายเป็น `testWidgets` block อิสระหนึ่งบล็อก ชื่อตาม `tc` identifier ของมัน มีโครงสร้างสามขั้นตอน:
- **Setup:** `tester.pumpWidget()` pump `MaterialApp` ที่มี page ห่อด้วย `BlocProvider` จาก source metadata
- **Interact:** แต่ละ `steps` entry ถูกแปลงเป็น `WidgetTester` call ที่สอดคล้องกันตามลำดับ sequence โดย `enterText` resolve ค่าจาก `datasets` key และ `pumpAndSettle` synchronize UI; `ElevatedButton` tap อยู่ท้ายเสมอ
- **Assert:** แต่ละ `asserts` entry กลายเป็น `expect()` call โดยใช้ `findsOneWidget` หรือ `findsNothing` ตาม `exists` flag

---

## IV. การออกแบบและการ Implement เครื่องมือ

### A. User Interface

Fig. 4 แสดง main window ของเครื่องมือ interface มี input สามตัวและ action หนึ่งตัวที่ครอบคลุม workflow การสร้าง test ทั้งหมด:

1. **Flutter front-end file:** file-picker สำหรับไฟล์ `.dart` screen เป้าหมาย เครื่องมือตรวจสอบ file type และยืนยันว่ามี widget ที่มี key อย่างน้อยหนึ่งตัว; file type ที่ไม่รองรับจะแสดงข้อความ "Invalid File Type" และบล็อกการดำเนินการต่อไป
2. **Condition file (optional):** file-picker ที่สองสำหรับ PICT constraint file เสริมที่เขียนใน syntax `IF...THEN...` หากจัดหา เครื่องมือจะตรวจสอบ constraint syntax ก่อนดำเนินการต่อ; ไฟล์ที่มีรูปแบบผิดพลาดจะแสดงข้อความ "Invalid Constraint Syntax"
3. **Output directory:** directory-picker ที่กำหนด destination folder สำหรับ artifact ที่สร้างทั้งหมด ได้แก่ `manifest.json`, `datasets.json`, `test_data.json` และ `<page>_test.dart`
4. **Generate button:** การคลิก "Generate" จะเรียก full four-phase pipeline สถานะความคืบหน้าและข้อความแสดงข้อผิดพลาดจะแสดงใน main window

### B. การติดตั้ง

ต้องมี prerequisite ต่อไปนี้ก่อนใช้เครื่องมือ:

1. **Docker** (v28.0.0 ขึ้นไป): เริ่ม back-end container ที่โฮสต์ **FastAPI** (v0.114.1) service ที่เปิดเผย REST endpoint สำหรับแต่ละ pipeline phase ด้วยคำสั่ง `docker run -p 8000:8000 <image>`
2. **PICT:** ติดตั้ง Microsoft PICT binary และตรวจสอบว่า accessible บน system `PATH` เครื่องมือเรียก PICT เป็น subprocess ระหว่าง Phase 3
3. **Gemini API key:** configure key เป็น environment variable หรือป้อนในแผง tool settings key เป็นสิ่งจำเป็นสำหรับ LLM call ใน Phase 2
4. **Web browser:** รัน `bash run_tool.sh` เพื่อเริ่ม web interface server จากนั้นเปิด browser และนำทางไปที่ `http://localhost:8080` เพื่อเข้าถึงเครื่องมือ

### C. Widget ที่รองรับ

version ปัจจุบันรองรับ widget เจ็ดประเภท ดังรายละเอียดใน Table II (Section III) Widget ห้าประเภททำหน้าที่เป็น PICT factor (`TextFormField`, `DropdownButtonFormField`, `Radio`, `Checkbox`, `Switch`) หนึ่งประเภทเป็น fixed trigger (`ElevatedButton`) และหนึ่งประเภทเป็น assertion target (`Text`)

### D. การสร้าง PICT Model

สำหรับ screen ที่มี widget ที่ไม่ใช่ button n ตัว ไฟล์ PICT model มี parameter line n บรรทัดในรูปแบบ `<key>: v1, v2, ..., vk` โดยแต่ละ `vi` เป็น value level ที่แตกต่างกัน เครื่องมือสร้างไฟล์ PICT model สองไฟล์ ได้แก่ VI และ V และเรียก PICT หนึ่งครั้งต่อไฟล์ แต่ละ PICT run ส่งคืน minimal covering array; สอง array ถูก concatenate กับ three hardcoded edge case เพื่อสร้าง test suite ที่สมบูรณ์สำหรับ screen

สำหรับ `TextFormField` VI model กำหนด factor เป็น `invalid` sentinel level เดียว และ V model กำหนด `valid`; แต่ละ model จึงมี text-field level เพียงหนึ่งระดับต่อ factor `DropdownButtonFormField` และ `Radio` factor ระบุ option ทั้งหมดที่ดึงมาจาก source code; `Checkbox` factor ใช้ fixed level {checked, unchecked} และ `Switch` factor ใช้ fixed level {on, off}

### E. ข้อจำกัดในการ Implement

แต่ละ script ที่สร้างขึ้นครอบคลุม **หนึ่ง** application screen ต่อการรัน widget เป้าหมายทุกตัวต้องมี property `Key` ที่ไม่ซ้ำกัน; widget ที่ไม่มี key จะถูกข้ามโดยไม่แสดงข้อผิดพลาด LLM call ต้องการ Gemini API key ที่ valid ขณะ runtime และ PICT ต้องติดตั้งและ accessible บน system `PATH`

---

## V. การประเมิน

### A. การตั้งค่าการทดลอง

เครื่องมือถูกประเมินกับ Flutter application ในโลกจริงสามตัว: แอป **Medical Appointment**, แอป **Job Listing** และแอป **Real-Estate Listing** สอง screen ต่อ application ถูกเลือก ให้การประเมินระดับ screen รวมหกครั้ง สภาพแวดล้อมการทดสอบใช้ Flutter v3.27.3 รันบน macOS Sequoia 15.4.1 Statement coverage ถูกวัดโดยใช้ Flutter flag `--coverage` ร่วมกับ `lcov` เพื่อกรองผลลัพธ์ให้เฉพาะไฟล์ UI page เท่านั้น

### B. ภาพรวม Case Study

แอปพลิเคชันสามตัวแสดงถึงระดับความซับซ้อนของ form-validation ที่เพิ่มขึ้น:

- **Medical Appointment app** มี booking screen ที่มี input widget เก้าตัว (TextFormField, DropdownButtonFormField, Radio, Switch) และ search screen ที่เบากว่า ให้ 52 test case (28 VI, 21 V, 3 Edge) และ 6 test case (2 VI, 1 V, 3 Edge) ตามลำดับ
- **Job Listing app** มี posting screen ที่มีกฎ cross-field validation ที่ซับซ้อน (เช่น salary-range constraint) สร้าง 64 case (31 VI, 30 V, 3 Edge) สำหรับการโพสต์ และ 63 case (30 VI, 30 V, 3 Edge) สำหรับการค้นหา ซึ่งแสดงให้เห็นว่า pairwise ปรับตัวได้ตามธรรมชาติกับ constraint ที่หนาแน่น
- **Real-Estate Listing app** มีสอง screen ที่มีความซับซ้อนใกล้เคียงกัน แต่ละตัวสร้าง 55 case (27 VI, 25 V, 3 Edge) ยืนยันจำนวน case ที่เสถียรสำหรับ widget inventory ที่เทียบเคียงกัน

### C. ผลการทดสอบ Coverage

ตาราง III สรุป statement coverage และจำนวน test case ในทุก screen ที่ประเมินหกหน้า; ตาราง IV แสดงรายละเอียด VI, V และ Edge breakdown ต่อ screen screen ทั้งหกบรรลุ statement coverage สูงกว่า **91%** และผลสูงสุด (**96.6%**, Real-Estate posting) ได้รับแม้จะมีจำนวน test case ที่ลดลง

สาม property ของ script ที่สร้างขึ้นมีส่วนทำให้เกิดผลลัพธ์นี้: (i) widget interaction ทุกตัวใช้ `find.byKey` ให้ locator ที่เสถียรซึ่งทนต่อการ refactor UI; (ii) ทุก `validatorRule` ที่ไม่ว่างขับเคลื่อน invalid value หนึ่งค่าบวก valid counterpart หนึ่งค่า รับประกันว่าแต่ละ validation branch ใน Cubit ถูกทดสอบอย่างน้อยหนึ่งครั้ง; (iii) ทั้ง VI และ V script group ถูกสร้างในการรันครั้งเดียว ให้ทีมงานได้ coverage ของ positive และ negative test path ทันที

**ตาราง III: สรุป Test Coverage**

| Application | Screen | Cases | Statements | Stmt. Coverage |
|---|---|---|---|---|
| Medical Appt. | Booking | 52 | 166/173 | 96.0% |
| Medical Appt. | Search | 6 | 141/154 | 91.6% |
| Job Listing | Posting | 64 | 161/172 | 93.6% |
| Job Listing | Search | 63 | 223/239 | 93.3% |
| Real Estate | Posting | 55 | 169/175 | 96.6% |
| Real Estate | Search | 55 | 233/250 | 93.2% |

**ตาราง IV: Pairwise Test-Case Breakdown ต่อ Screen**

| App | Screen | VI | V | Edge |
|---|---|---|---|---|
| Medical Appt. | Booking | 28 | 21 | 3 |
| Medical Appt. | Search | 2 | 1 | 3 |
| Job Listing | Posting | 31 | 30 | 3 |
| Job Listing | Search | 30 | 30 | 3 |
| Real Estate | Posting | 27 | 25 | 3 |
| Real Estate | Search | 27 | 25 | 3 |

_VI = pairwise valid/invalid; V = pairwise valid; Edge = edge cases_

### D. คำตอบต่อคำถามวิจัย

**RQ1 — Coverage ที่ทำได้:**  
ตาราง III ยืนยันว่า screen ทั้งหกเกิน 91% statement coverage โดยไม่ต้องเขียน test case ด้วยมือ โดยมีจุดสูงสุดที่ 96.6% สำหรับ Real-Estate posting screen ปัจจัยสามประการมีส่วนทำให้เกิดผลลัพธ์นี้: (i) `find.byKey` locator ทนต่อการ refactor UI; (ii) ทุก `validatorRule` ที่ไม่ว่างขับเคลื่อน invalid–valid pair อย่างน้อยหนึ่งคู่ รับประกันว่าแต่ละ validation branch ถูกทดสอบ; และ (iii) ทั้ง VI และ V group ถูกสร้างในการรันครั้งเดียว ครอบคลุม positive และ negative path พร้อมกัน

**RQ2 — Combinatorial reduction:**  
ตาราง V เปรียบเทียบจำนวน exhaustive combinatorial กับจำนวน pairwise VI สำหรับแต่ละ screen (exhaustive count = ผลคูณของ factor level ทั้งหมด โดยถือว่าแต่ละ `TextFormField` มีสองสถานะ: valid และ invalid) การลดขนาดขยายตาม parameter count: screen ที่มี factor เดียวไม่แสดงการลดขนาด ขณะที่ screen ที่มี 11–12 factor บรรลุการลดขนาดสามลำดับความสำคัญ (991× สำหรับ Job-Listing posting; 3,413× สำหรับ Real-Estate posting) ยืนยันว่า pairwise เป็นสิ่งจำเป็นในการรักษา test suite ให้จัดการได้เมื่อความซับซ้อนของ form เติบโตขึ้น

**ตาราง V: Pairwise VI Cases vs. Exhaustive Combinatorial Count**

| App | Screen | Exhaustive | Pairwise VI | Reduction |
|---|---|---|---|---|
| Medical Appt. | Booking | 1,792 | 28 | 64× |
| Medical Appt. | Search | 2 | 2 | 1× |
| Job Listing | Posting | 30,720 | 31 | 991× |
| Job Listing | Search | 240 | 30 | 8× |
| Real Estate | Posting | 92,160 | 27 | 3,413× |
| Real Estate | Search | 960 | 27 | 36× |

_Exhaustive = ผลคูณของ factor level (2 states ต่อ `TextFormField`: valid และ invalid)_

---

## VI. บทสรุป

บทความนี้นำเสนอเครื่องมืออัตโนมัติสำหรับการสร้าง Flutter widget test script โดยใช้การรวมกันของ source-code metadata extraction, LLM-driven synthetic data generation และเทคนิค Pairwise testing เครื่องมือไม่ต้องการการเขียน test case ด้วยมือ: นักพัฒนาจัดหาเพียงไฟล์ Flutter front-end และได้รับ Dart test script ที่พร้อมรันเป็น output

การประเมินกับ mobile application ในโลกจริงสามตัวยืนยันว่าเครื่องมือสร้าง executable test script ได้สำเร็จพร้อม code coverage ที่วัดได้

ข้อจำกัดปัจจุบันรวมถึงชุด widget type ที่รองรับที่คงที่, ขอบเขต single-screen ต่อการรัน และข้อกำหนดที่ทุก target widget ต้องมี `Key` ที่ไม่ซ้ำกัน งานในอนาคตจะขยาย widget support, เปิดใช้งาน multi-screen end-to-end testing และนำ approach นี้ไปใช้กับ mobile framework อื่น เช่น React Native และ SwiftUI

---

## เอกสารอ้างอิง

1. Google, "Flutter – Build apps for any screen."
2. A. Ekakrachawakitti, "Automated Robot Framework Test Script Generation from Web Front-End Files," M.S. thesis, Chulalongkorn University, 2020.
3. S. Srivichayanun, "Test Data Generation for Web Applications Using XSD Schema and Boundary Value Analysis," M.S. thesis, Chulalongkorn University, 2021.
4. T. Pham, "Prompt Engineering for LLM-Based Test Generation," in *Proc. Int. Conf. Software Quality*, 2023.
5. Google, "Gemini API Documentation."
6. Microsoft, "PICT – Pairwise Independent Combinatorial Testing."
7. D. R. Kuhn, R. N. Kacker, and Y. Lei, *Introduction to Combinatorial Testing*. CRC Press, 2013.
8. M. Grindal, J. Offutt, and S. F. Andler, "Combination testing strategies: A survey," *Software Testing, Verification and Reliability*, vol. 15, no. 3, pp. 167–199, 2005.
