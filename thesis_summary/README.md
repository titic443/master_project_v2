# Thesis Summary — สารนิพนธ์ฉบับเต็ม
**"การสร้างสคริปต์ทดสอบสำหรับฟลัตเตอร์แอปพลิเคชันด้วยเทคนิคการทดสอบแบบแพร์ไวส์"**
Titi Changpoo — Chulalongkorn University, 2025

> ไฟล์เหล่านี้สร้างเพื่อใช้เป็น context เปรียบเทียบกับ `ieee_paper.tex`

---

## สารบัญ

| บท | หัวข้อ | ไฟล์ | หน้า (PDF) |
|---|---|---|---|
| 1 | บทนำ — ที่มา, วัตถุประสงค์, ขอบเขต | [chapter1.md](chapter1.md) | 14–17 |
| 2 | ทฤษฎีและงานวิจัยที่เกี่ยวข้อง | [chapter2.md](chapter2.md) | 18–25 |
| 3 | Methodology — Pipeline 8 ขั้นตอน | [chapter3.md](chapter3.md) | 26–47 |
| 4 | Tool Design & Implementation | [chapter4.md](chapter4.md) | 48–80 |
| 5 | การทดสอบและประเมินผล (3 Case Studies) | [chapter5.md](chapter5.md) | 81–106 |
| 6 | สรุปผลและข้อเสนอแนะ | [chapter6.md](chapter6.md) | 107–108 |

---

## ภาพรวม Pipeline (บทที่ 3)

```
Flutter .dart file
    ↓ [3.1–3.2] Extract Manifest
manifest.json
    ↓ [3.3] LLM (Gemini 2.5 Flash)
datasets.json  (valid/invalid/atMax/atMin per TextFormField)
    ↓ [3.4–3.5] Widget → PICT Factor + Constraint File
<page>.invalid.model.txt + <page>.valid.model.txt
    ↓ [3.6] PICT subprocess
<page>.invalid.result.txt + <page>.valid.result.txt
    ↓ [3.7] Merge → 3 groups
<page>.test_data.json  (source + datasets + cases)
    ↓ [3.8] Render
<page>_test.dart  ← พร้อมรัน
```

---

## Coverage Results (บทที่ 5)

| App | Screen | Cases | Coverage |
|---|---|---|---|
| Medical Appt. | Booking | 52 | **96.0%** |
| Medical Appt. | Search | 6 | 91.6% |
| Job Listing | Posting | 64 | 93.6% |
| Job Listing | Search | 63 | 93.3% |
| Real Estate | Posting | 55 | **96.6%** |
| Real Estate | Search | 55 | 93.2% |

**ทุก Screen ≥ 91%**

---

## ความสัมพันธ์กับ ieee_paper.tex

| Thesis Chapter | IEEE Section |
|---|---|
| บทที่ 1 (Introduction) | Section I — Introduction |
| บทที่ 2 (Related Work) | Section II — Related Work |
| บทที่ 3 (Methodology) | Section III — Proposed Methodology |
| บทที่ 4 (Implementation) | Section IV — Tool Design and Implementation |
| บทที่ 5 (Evaluation) | Section V — Evaluation |
| บทที่ 6 (Conclusion) | Section VI — Conclusion |
