# ตัวอย่างการเรียก `generate_datasets.dart`

ไฟล์นี้ช่วยให้เห็นภาพรวมของการส่งพรอมต์ไปยัง Gemini และผลลัพธ์ที่ใช้สร้าง test datasets สำหรับฟอร์ม Flutter ได้ง่ายขึ้น

## ตัวอย่างสั้นๆ
- **Input**  
  ```txt
    {
      "source": {...},
      "widgets": [...]
    }

  ```
- **Output**  
  ```txt
      DropdownButtonFormField<String>(
        key: const Key('customer_01_title_dropdown'),
        value: state.title,
        decoration: const InputDecoration(labelText: 'Title'),
        items: const [
          DropdownMenuItem<String>(value: 'Mr.',  child: Text('Mr.')),
          DropdownMenuItem<String>(value: 'Mrs.', child: Text('Mrs.')),
          DropdownMenuItem<String>(value: 'Ms.',  child: Text('Ms.')),
          DropdownMenuItem<String>(value: 'Dr.',  child: Text('Dr.')),
        ],
        onChanged: (value) {
          context.read<CustomerCubit>().onTitleChanged(value);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a title';
          }
          return null;
        },
      )
  ```
- **เหตุผล**  
  มี 2 rule จึงต้องได้ผลลัพธ์ 2 คู่: `"abc"` และ `"test"` ผ่านทุก rule, `""` ฝ่าฝืน isEmpty, `"ab"` ฝ่าฝืน length < 3

## พรอมต์ที่ส่งให้ Gemini
```text
      "steps": [
        {"tap": {"byKey": "customer_01_title_dropdown"}},
        {"pump": true},
        {"tapText": "Dr."},
        {"pump": true},
        {"enterText": {
          "byKey": "customer_02_firstname_textfield",
          "dataset": "byKey.customer_02_firstname_textfield[0].invalid"
          }
        },
        {"pump": true},
        {"enterText": {
          "byKey": "customer_03_phone_textfield",
          "dataset": "byKey.customer_03_phone_textfield[0].valid"
          }
        },
        {"pump": true},
        {"enterText": {
          "byKey": "customer_04_lastname_textfield",
          "dataset": "byKey.customer_04_lastname_textfield[0].valid"
          }
        },
        {"pump": true},
        {"tap": {"byKey": "customer_05_age_30_40_radio"}},
        {"pump": true},
        {"tap": {"byKey": "customer_06_agree_terms_checkbox"}},
        {"pump": true},
        {"tap": {"byKey": "customer_07_subscribe_newsletter_checkbox"}},
        {"pump": true},
        {"tap": {"byKey": "customer_08_end_button"}},
        {"pumpAndSettle": true}
      ],
```

## Context (JSON) ที่แนบไปกับพรอมต์
```txt
      "asserts": [
        {
          "byKey": "customer_01_expected_success",
          "exists": true
        }
      ]
```

## คำตอบที่ได้จาก Gemini
```txt
    // GENERATED — Integration tests for full flow
    import 'package:flutter/material.dart';
    import 'package:flutter_test/flutter_test.dart';
    import 'package:integration_test/integration_test.dart';
    import 'package:flutter_bloc/flutter_bloc.dart';
    import 'package:master_project/cubit/customer_cubit.dart';
    import 'package:master_project/cubit/customer_state.dart';
    import 'package:master_project/demos/customer_details_page.dart';

    void main() {
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();
      group('customer_details_page.dart flow (integration)', () {
        group('pairwise_valid_invalid_cases', () {
          testWidgets('pairwise_valid_invalid_cases_1', (tester) async {
            final providers = <BlocProvider>[
              BlocProvider<CustomerCubit>(create: (_)=> CustomerCubit()),
            ];
            final w = MaterialApp(
              home: MultiBlocProvider(
                providers: providers, 
                child: CustomerDetailsPage()
                )
              );
            await tester.pumpWidget(w);
            await tester.ensureVisible(
              find.byKey(const Key('customer_01_title_dropdown')));
            await tester.tap(
              find.byKey(const Key('customer_01_title_dropdown')));
            await tester.pump();
            await tester.tap(find.text('Dr.'));
            await tester.pump();
            // dataset: byKey.customer_02_firstname_textfield[0].invalid
            await tester.enterText(
              find.byKey(const Key('customer_02_firstname_textfield')), 'A');
            await tester.pump();
            // dataset: byKey.customer_03_phone_textfield[0].valid
            await tester.enterText(
              find.byKey(const Key('customer_03_phone_textfield')), '0909877913');
            await tester.pumpAndSettle();
            final expected = [
              find.text('First name must contain only letters (minimum 2 characters)'),
              find.byKey(const Key('customer_01_expected_fail')),
            ];
            expect(expected.any(
              (f) => f.evaluate().isNotEmpty), 
              isTrue, 
              reason: 'Expected at least one of the elements to exist'
              );
          });
```

## สรุปสั้นๆ
- โมเดลสร้างค่าที่ผ่านทุก rule ไว้ใน `valid` และค่าที่เจาะจงทำให้แต่ละ rule fail ไว้ใน `invalid`
- โครงสร้าง JSON ตรงกับสิ่งที่สคริปต์คาดหวัง (`file` + `datasets.byKey`)
- สามารถเปิดดูไฟล์ `output/test_data/customer_details_page.datasets.json` เพื่อเปรียบเทียบผลลัพธ์จริงได้
