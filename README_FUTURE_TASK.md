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
      testWidgets('pairwise_valid_invalid_cases_1', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'SE');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Agoda');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Finance').last);
        await tester.tap(find.text('Finance').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Part-time').last);
        await tester.tap(find.text('Part-time').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Senior').last);
        await tester.tap(find.text('Senior').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '1');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are seeking a highly motivated and experienced ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'F');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 3 characters'),
          find.text('Must be ≥ min'),
          find.text('At least 2 characters'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });


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
