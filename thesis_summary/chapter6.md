# บทที่ 6 — สรุปผลและข้อเสนอแนะ (Conclusion & Future Work)
> สรุปจาก: 6770231021_final.pdf หน้า 107–108

---

## 6.1 สรุปผลการวิจัย

งานวิจัยนี้นำเสนอเครื่องมือสร้าง Test Script อัตโนมัติสำหรับ Flutter Application โดย:

1. **สกัด Metadata** จากไฟล์ Frontend (Widget key, validation conditions, input types)
2. **ใช้ LLM (Gemini)** สร้าง Synthetic Test Data ที่สอดคล้องกับ Validation Rules
3. **ใช้ Pairwise Technique (PICT)** สร้าง Test Cases อย่างเป็นระบบ
4. **Output เป็น Dart Test Script** ที่รันได้ทันทีบน Flutter Framework

**ผลการทดสอบ (3 กรณีศึกษา):**
- เครื่องมือสามารถสร้าง Test Script ได้ครบทุก Input Field ในขอบเขตที่กำหนด
- Test Script ที่สร้างสามารถนำไปรันจริงผ่าน Flutter Framework ได้
- ได้ **Statement Coverage > 91% ทุก Screen** จาก 6 Screen ที่ทดสอบ

---

## 6.2 ข้อจำกัดของงานวิจัย

| # | ข้อจำกัด |
|---|---|
| 1 | รองรับเฉพาะ Widget ในขอบเขต: **TextFormField, Radio, Checkbox, DropdownButtonFormField, Button** — Widget นอกขอบเขตถูก skip |
| 2 | Widget ที่ไม่มี **Key** จะไม่ถูกนำไปสร้าง Test Script |
| 3 | สร้าง Test Script ได้ทีละ **1 หน้าแอปพลิเคชัน** เท่านั้น ต่อ 1 การรัน |
| 4 | Test Case ที่สร้างอาจไม่สามารถระบุ **Expected Result** ได้อย่างสมบูรณ์ทุกกรณี |

---

## 6.3 ข้อเสนอแนะและแนวทางพัฒนาต่อ

| # | แนวทาง | ประโยชน์ที่จะได้ |
|---|---|---|
| 1 | **รองรับ Widget หลากหลายประเภทมากขึ้น** | ครอบคลุม Flutter Project ที่ซับซ้อนกว่าเดิม |
| 2 | **รองรับการสร้าง Test Script จากหลายไฟล์พร้อมกัน** | สะดวกขึ้นสำหรับโปรเจกต์ขนาดใหญ่ |
| 3 | **พัฒนา Constraint File ให้รองรับ Syntax ที่ซับซ้อนขึ้น** | จำลองพฤติกรรมจริงของระบบได้แม่นยำขึ้น |
| 4 | **นำแนวคิดไปใช้กับ Mobile Framework อื่น** เช่น React Native, Xamarin, SwiftUI | ขยาย scope ให้ครอบคลุม Project ที่ไม่ใช่ Flutter |
| 5 | **รองรับการส่ง Request ไปยัง Backend มากกว่า 1 ครั้งใน 1 Test Case** | ทดสอบ Multi-step workflow ได้ |
| 6 | **รองรับการวิเคราะห์มากกว่า 1 หน้าพร้อมกัน** พร้อม Navigation linking | สร้าง End-to-End Test ที่สมจริงและต่อเนื่องระหว่างหน้า |

---

## สรุปสั้น ๆ (Key Takeaway)

บทที่ 6 ปิดงานวิจัยใน 3 มิติ:

1. **ยืนยันความสำเร็จ:** เครื่องมือทำงานได้จริง, Script รันได้, Coverage > 91% ทุก Screen
2. **ยอมรับข้อจำกัด:** 4 จุดที่ชัดเจน — Widget scope, ต้องมี Key, 1 Screen/run, Expected result อาจไม่สมบูรณ์
3. **วางแผนอนาคต:** 6 แนวทาง — ขยาย Widget / Multi-file / Complex constraints / Cross-framework / Multi-request / Multi-screen navigation

> **Gap ที่ใหญ่ที่สุด** ระหว่างงานปัจจุบันกับงานในอนาคตคือ **Multi-screen testing** — ปัจจุบันทดสอบได้ทีละหน้า แต่แอปจริงมี Navigation flow ระหว่างหน้า

---

*ไฟล์นี้สร้างเพื่อเป็น context สำหรับเปรียบเทียบกับ ieee_paper.tex*
