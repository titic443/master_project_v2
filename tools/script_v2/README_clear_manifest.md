# clear_manifest.dart

## ภาพรวม
Script สำหรับลบไฟล์ทั้งหมดในโฟลเดอร์ `output/` เพื่อเคลียร์ข้อมูลเก่าก่อนสร้างไฟล์ใหม่

## การทำงาน
1. ค้นหาไฟล์ทั้งหมดใน `output/` directory (รวมทั้ง subdirectories)
2. ลบไฟล์ทั้งหมดที่พบ
3. ลบโฟลเดอร์ว่างเปล่าที่เหลืออยู่
4. แสดงสรุปจำนวนไฟล์และโฟลเดอร์ที่ถูกลบ

## วิธีใช้งาน

```bash
dart run tools/script_v2/clear_manifest.dart
```

## Output
- แสดงรายการไฟล์ที่ถูกลบพร้อมสถานะ (✓ = สำเร็จ, ✗ = เกิดข้อผิดพลาด)
- แสดงสรุปจำนวนไฟล์และโฟลเดอร์ที่ถูกลบ

## โฟลเดอร์ที่จะถูกลบ
- `output/manifest/` - UI manifest files
- `output/event_chains/` - Event chain files
- `output/graphs/` - Graph files
- `output/test_data/` - Test data files
- และ subdirectories อื่นๆ ใน `output/`

## ตัวอย่าง Output

```
🗑️  Clearing all files in output directory...

✓ Deleted: output/manifest/buttons_page.manifest.json
✓ Deleted: output/test_data/buttons_page.datasets.json
✓ Deleted: output/test_data/buttons_page.testdata.json

🗑️  Removing empty directories...

✓ Removed directory: output/manifest
✓ Removed directory: output/test_data

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 Summary:
   ✓ Deleted files: 3
   ✓ Removed empty directories: 2
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Exit Code
- `0` - สำเร็จ
- `1` - เกิดข้อผิดพลาดในการลบไฟล์

## หมายเหตุ
- ใช้งานด้วยความระมัดระวัง เพราะจะลบไฟล์ทั้งหมดใน `output/` โดยไม่สามารถกู้คืนได้
- เหมาะสำหรับการรันก่อนสร้าง manifest และ test data ใหม่ทั้งหมด
