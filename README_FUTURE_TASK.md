# README_FUTURE_TASK.md

## งานที่ทำเสร็จแล้ว ✅

### ลบ Batch Mode จากทุก Scripts

| ไฟล์ | Batch Mode ที่ลบ | Lines ที่ลบ |
|------|------------------|------------|
| `extract_ui_manifest.dart` | scan lib/ หา *_page.dart | ~20 lines |
| `generate_datasets.dart` | scan output/manifest/ + `_scanManifestFolder()` | ~140 lines |
| `generate_test_data.dart` | scan output/manifest/ | ~30 lines |
| `generate_test_script.dart` | scan output/test_data/ หา *.testdata.json | ~35 lines |

### แก้ไข `server.dart` `/generate-all`
- ✅ Step 1: วนลูป extract manifest ทีละไฟล์
- ✅ Step 2: วนลูป generate datasets ทีละไฟล์
- ✅ Step 3: วนลูป generate test data ทีละไฟล์
- ✅ Step 4: วนลูป generate test script ทีละไฟล์

### ลบ Unused Code จาก `generate_test_data.dart`
- ✅ `_extractPagePrefix`, `buildSteps`, `_shortKey`
- ✅ `pageClass`, `hasExternalDatasets`, `successSetup`
- รวม ~257 lines

---

## สรุป Changes ทั้งหมด

| ไฟล์ | การเปลี่ยนแปลง |
|------|---------------|
| `extract_ui_manifest.dart` | ลบ batch mode, require file argument |
| `generate_datasets.dart` | ลบ batch mode + `_scanManifestFolder()` + unused import |
| `generate_test_data.dart` | ลบ batch mode + unused functions/variables |
| `generate_test_script.dart` | ลบ batch mode, require testdata file argument |
| `server.dart` | `/generate-all` วนลูป 4 steps แทน batch mode |

---

## วิธีใช้งานใหม่

```bash
# ทุก script ต้องระบุไฟล์
dart run tools/script_v2/extract_ui_manifest.dart lib/demos/buttons_page.dart
dart run tools/script_v2/generate_datasets.dart output/manifest/demos/buttons_page.manifest.json
dart run tools/script_v2/generate_test_data.dart output/manifest/demos/buttons_page.manifest.json
dart run tools/script_v2/generate_test_script.dart output/test_data/demos/buttons_page.testdata.json

# server ยังทำงานปกติ
dart run webview/server.dart
```

---

## Status: ไม่มี Errors ✅

ทุกไฟล์มีแค่ Information level warnings (print statements, angle brackets in comments)
