# PROJECT_CONTEXT.md
> อ่านไฟล์นี้ก่อนเสมอเมื่อเริ่ม session ใหม่กับ ieee_paper.tex

---

## 1. ภาพรวมโปรเจกต์

| รายการ | รายละเอียด |
|--------|-----------|
| **ผู้แต่ง** | Titi Changpoo (`titi.changpoo@gmail.com`), Taratip Suwannasart |
| **ไฟล์หลัก** | `ieee_paper.tex` — IEEE conference paper (IEEEtran class) |
| **ต้นฉบับอ้างอิง** | `6770231021_final.pdf` — Thai Master's thesis (129 หน้า) ที่ใช้เปรียบเทียบและเติมเนื้อหา |
| **หัวข้อ** | Automated test-script generation for Flutter apps using Pairwise Testing (PICT) + LLM (Gemini) |

---

## 2. โครงสร้าง ieee_paper.tex (ณ ปัจจุบัน)

```
Section I   — Introduction
Section II  — Related Work
Section III — Proposed Methodology  ← แก้เยอะที่สุด
  Phase 1 — Extract Manifest
  Phase 2 — Generate Datasets
  Phase 3 — Generate Test Data      ← Table II อยู่ที่นี่แล้ว
  Phase 4 — Generate Test Script
Section IV  — Tool Design and Implementation
  Architecture / User Interface / Supported Widgets / PICT Model / Constraints
Section V   — Evaluation
Section VI  — Generated Test Script Example
Section VII — Conclusion
```

---

## 3. Tables ในไฟล์

| Label | Caption | อยู่ที่ |
|-------|---------|--------|
| `tab:manifest` | Metadata Fields in the Manifest File | Phase 1 |
| `tab:widgets`  | Supported Flutter Widgets and Generated Test Interactions | **Phase 3** (ย้ายมาจาก Section IV แล้ว) |
| `tab:coverage` | Test Coverage Summary | Section V |
| `tab:reduction`| Pairwise Test-Case Reduction per Screen | Section V |

---

## 4. สิ่งที่แก้ไปแล้ว (session ก่อนหน้า)

### Phase 1 — Extract Manifest
- เพิ่ม screen-level BLoC fields: `pageClass`, `cubitClass`, `stateClass`, `fileCubit`, `fileState`
- เพิ่ม `sequence` field (widget-level) พร้อมอธิบายว่าใช้ใน Phase 3 เพื่อ order steps
- ปรับ Table I (`tab:manifest`) ให้แยก screen-level / widget-level อย่างชัดเจน

### Phase 2 — Generate Datasets
- แก้ CO-STEP ให้ครบ 6 components และชื่อถูกต้อง:
  **Context, Objective, Style, Target, Execution, Polish**
  (เดิมเขียนผิด: Scenario, Task, Example)

### Phase 3 — Generate Test Data
- เพิ่มอธิบาย **Condition File** (JSON ที่ developer ให้เพิ่มเติม Cubit-layer validation rules)
- เพิ่มอธิบาย `testdata.json` structure 3 keys: `source`, `datasets`, `cases`
- แต่ละ case มี: `tc`, `kind`, `group`, `steps`, `asserts`
- **ย้าย Table II** (`tab:widgets`) มาอยู่ท้าย Phase 3 (จากเดิมอยู่ Section IV)

### Phase 4 — Generate Test Script
- เพิ่มอธิบาย 3 `import` statements จาก `source` key
- เพิ่มอธิบาย `BlocProvider<CubitClass>` wrapper
- เพิ่มอธิบาย 3 `group()` blocks

### Section IV — Supported Widgets
- ลบ Table II ออก เปลี่ยนเป็น cross-reference → `Table~\ref{tab:widgets} (Section~III)`

---

## 5. Key Technical Concepts

### Flutter / Dart
- Widget keys → `find.byKey()` ใน tests
- `WidgetTester` commands: `enterText`, `tap`, `tapText`, `pump`, `pumpAndSettle`
- BLoC pattern: `BlocProvider`, `CubitClass`, `StateClass`

### Pipeline JSON Files
| ไฟล์ | สร้างใน | เนื้อหา |
|------|---------|---------|
| `<page>.manifest.json` | Phase 1 | screen-level + widget-level metadata |
| `<page>.datasets.json` | Phase 2 | `file`, `datasets.byKey[]{valid, invalid, invalidRuleMessages}` |
| `<page>.full.model.txt` | Phase 3 | PICT model (VI) |
| `<page>.valid.model.txt` | Phase 3 | PICT model (V) |
| `<page>.test_data.json` | Phase 3 | `source`, `datasets`, `cases[]` |
| `<page>_test.dart` | Phase 4 | executable Flutter widget test |

### PICT Model Variants
- **VI** (Valid/Invalid): ทุก widget เป็น factor มีทั้ง valid+invalid levels
- **V** (Valid-only): ทุก widget เป็น factor มีเฉพาะ valid levels
- **Edge**: 3 boundary cases (empty, max-length, special chars) — crafted manually

### Widget → PICT Role → Test Command
| Widget | PICT Role | Command |
|--------|-----------|---------|
| TextFormField | Factor (N levels) | enterText |
| DropdownButtonFormField | Factor (enum) | tap ×2 |
| Radio | Factor (enum) | tap |
| Checkbox | Factor {on,off} | tap |
| Switch | Factor {on,off} | tap |
| ElevatedButton | Trigger (fixed) | tap (last) |
| Text | Assertion target | find.text |

---

## 6. References ที่สำคัญใน .bib

| Key | ใช้อ้างอิง |
|-----|-----------|
| `b1` | Flutter framework |
| `b2` | Ekakrachawakitti (Robot Framework from HTML) |
| `b3` | Srivichayanun (XSD + BVA for web) |
| `b4` | Tuan Pham — CO-STEP prompt framework |
| `b5` | Google Gemini API |
| `b7` | Pairwise testing technique |
| `b8` | PICT tool |

---

## 7. สิ่งที่ยังไม่ได้แก้ (Gap จาก thesis ที่เหลือ)

จาก gap analysis 12 รายการ ยังเหลือที่ยังไม่ได้ทำ (priority ต่ำ):
1. Figure descriptions อาจยังไม่ตรงกับ thesis figures จริง (figure1–5.png)
2. Evaluation section ยังไม่มีการอ้างอิงถึง inter-rater reliability หรือ threat to validity
3. Related Work section — CO-STEP reference ยังใช้ `b4` (Tuan Pham) แทนที่จะเป็น reference ที่ถูกต้องกว่า

---

## 8. Workspace Files

```
master_project_v2/
├── ieee_paper.tex          ← ไฟล์หลัก
├── references.bib          ← bibliography
├── figure1.png – figure5.png
├── CLAUDE.md               ← Flutter project instructions (ไม่เกี่ยวกับ paper)
└── PROJECT_CONTEXT.md      ← ไฟล์นี้
```

> **หมายเหตุ**: `CLAUDE.md` อธิบาย Flutter codebase structure (ไม่ใช่ paper) — อ่านเฉพาะเมื่อต้องการข้อมูล Dart/Flutter commands
