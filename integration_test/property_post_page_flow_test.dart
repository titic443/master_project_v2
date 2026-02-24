// GENERATED — Integration tests for full flow
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/property_post_cubit.dart';
import 'package:master_project/demos/property_post_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('property_post_page.dart flow (integration)', () {
    group('pairwise_valid_invalid_cases', () {
      testWidgets('pairwise_valid_invalid_cases_1', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('House').last);
        await tester.tap(find.text('House').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'ท');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '9.99');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.tap(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดวิวสวย');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'ธ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 2 characters'),
          find.text('Min 10 sqm'),
          find.text('At least 20 characters'),
          find.text('At least 2 characters'),
          find.byKey(const Key('prop_13_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_2', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'ห้องเช่า');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Land').last);
        await tester.tap(find.text('Land').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ส');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '99999');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '');
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 5 characters'),
          find.text('At least 2 characters'),
          find.text('Min 100,000 THB'),
          find.text('general'),
          find.byKey(const Key('prop_13_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_3', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'ห้องเช่า');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Condo').last);
        await tester.tap(find.text('Condo').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ส');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'ท');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.tap(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดวิวสวย');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 5 characters'),
          find.text('At least 2 characters'),
          find.text('At least 2 characters'),
          find.text('general'),
          find.text('At least 20 characters'),
          find.byKey(const Key('prop_13_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_4', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Land').last);
        await tester.tap(find.text('Land').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '99999');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Studio').last);
        await tester.tap(find.text('Studio').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '9.99');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.tap(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'ธ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Min 100,000 THB'),
          find.text('Min 10 sqm'),
          find.text('At least 2 characters'),
          find.byKey(const Key('prop_13_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_5', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Condo').last);
        await tester.tap(find.text('Condo').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'ท');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '99999');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'ธ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 2 characters'),
          find.text('Min 100,000 THB'),
          find.text('At least 2 characters'),
          find.byKey(const Key('prop_13_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_6', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Commercial').last);
        await tester.tap(find.text('Commercial').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ส');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Studio').last);
        await tester.tap(find.text('Studio').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '9.99');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '');
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดวิวสวย');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 2 characters'),
          find.text('Min 10 sqm'),
          find.text('general'),
          find.text('At least 20 characters'),
          find.byKey(const Key('prop_13_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_7', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'ห้องเช่า');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Condo').last);
        await tester.tap(find.text('Condo').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ส');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '99999');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '9.99');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '');
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดวิวสวย');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'ธ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 5 characters'),
          find.text('At least 2 characters'),
          find.text('Min 100,000 THB'),
          find.text('Min 10 sqm'),
          find.text('general'),
          find.text('At least 20 characters'),
          find.text('At least 2 characters'),
          find.byKey(const Key('prop_13_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_8', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'ห้องเช่า');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Townhouse').last);
        await tester.tap(find.text('Townhouse').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'ท');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '9.99');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.tap(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 5 characters'),
          find.text('At least 2 characters'),
          find.text('Min 10 sqm'),
          find.byKey(const Key('prop_13_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_9', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Townhouse').last);
        await tester.tap(find.text('Townhouse').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ส');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '99999');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'ธ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 2 characters'),
          find.text('Min 100,000 THB'),
          find.text('At least 2 characters'),
          find.byKey(const Key('prop_13_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_10', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'ห้องเช่า');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('House').last);
        await tester.tap(find.text('House').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '');
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 5 characters'),
          find.text('general'),
          find.byKey(const Key('prop_13_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_11', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('House').last);
        await tester.tap(find.text('House').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ส');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '99999');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '');
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดวิวสวย');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'ธ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 2 characters'),
          find.text('Min 100,000 THB'),
          find.text('general'),
          find.text('At least 20 characters'),
          find.text('At least 2 characters'),
          find.byKey(const Key('prop_13_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_12', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Land').last);
        await tester.tap(find.text('Land').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ส');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '9.99');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดวิวสวย');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 2 characters'),
          find.text('Min 10 sqm'),
          find.text('At least 20 characters'),
          find.byKey(const Key('prop_13_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_13', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Townhouse').last);
        await tester.tap(find.text('Townhouse').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'ท');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.tap(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดวิวสวย');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 2 characters'),
          find.text('At least 20 characters'),
          find.byKey(const Key('prop_13_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_14', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'ห้องเช่า');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Commercial').last);
        await tester.tap(find.text('Commercial').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'ท');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '99999');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.tap(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'ธ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 5 characters'),
          find.text('At least 2 characters'),
          find.text('Min 100,000 THB'),
          find.text('At least 2 characters'),
          find.byKey(const Key('prop_13_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_15', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'ห้องเช่า');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Townhouse').last);
        await tester.tap(find.text('Townhouse').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ส');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'ท');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Studio').last);
        await tester.tap(find.text('Studio').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.tap(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 5 characters'),
          find.text('At least 2 characters'),
          find.text('At least 2 characters'),
          find.text('general'),
          find.byKey(const Key('prop_13_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_16', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'ห้องเช่า');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('House').last);
        await tester.tap(find.text('House').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '9.99');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.tap(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 5 characters'),
          find.text('Min 10 sqm'),
          find.byKey(const Key('prop_13_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_17', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'ห้องเช่า');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Condo').last);
        await tester.tap(find.text('Condo').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'ท');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Studio').last);
        await tester.tap(find.text('Studio').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '9.99');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.tap(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 5 characters'),
          find.text('At least 2 characters'),
          find.text('Min 10 sqm'),
          find.text('general'),
          find.byKey(const Key('prop_13_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_18', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'ห้องเช่า');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Commercial').last);
        await tester.tap(find.text('Commercial').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ส');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'ท');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '99999');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.tap(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 5 characters'),
          find.text('At least 2 characters'),
          find.text('At least 2 characters'),
          find.text('Min 100,000 THB'),
          find.text('general'),
          find.byKey(const Key('prop_13_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_19', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Condo').last);
        await tester.tap(find.text('Condo').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ส');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'ท');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '99999');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '');
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'ธ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 2 characters'),
          find.text('At least 2 characters'),
          find.text('Min 100,000 THB'),
          find.text('general'),
          find.text('At least 2 characters'),
          find.byKey(const Key('prop_13_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_20', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Land').last);
        await tester.tap(find.text('Land').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'ท');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดวิวสวย');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 2 characters'),
          find.text('At least 20 characters'),
          find.byKey(const Key('prop_13_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_21', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'ห้องเช่า');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Land').last);
        await tester.tap(find.text('Land').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '99999');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '');
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดวิวสวย');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 5 characters'),
          find.text('Min 100,000 THB'),
          find.text('general'),
          find.text('At least 20 characters'),
          find.byKey(const Key('prop_13_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_22', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'ห้องเช่า');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Townhouse').last);
        await tester.tap(find.text('Townhouse').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'ท');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '99999');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '9.99');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'ธ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 5 characters'),
          find.text('At least 2 characters'),
          find.text('Min 100,000 THB'),
          find.text('Min 10 sqm'),
          find.text('At least 2 characters'),
          find.byKey(const Key('prop_13_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_23', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'ห้องเช่า');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Commercial').last);
        await tester.tap(find.text('Commercial').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ส');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '9.99');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '');
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'ธ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 5 characters'),
          find.text('At least 2 characters'),
          find.text('Min 10 sqm'),
          find.text('general'),
          find.text('At least 2 characters'),
          find.byKey(const Key('prop_13_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_24', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Condo').last);
        await tester.tap(find.text('Condo').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '99999');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '9.99');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.tap(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดวิวสวย');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'ธ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Min 100,000 THB'),
          find.text('Min 10 sqm'),
          find.text('At least 20 characters'),
          find.text('At least 2 characters'),
          find.byKey(const Key('prop_13_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_25', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('House').last);
        await tester.tap(find.text('House').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ส');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'ท');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '99999');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Studio').last);
        await tester.tap(find.text('Studio').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.tap(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'ธ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 2 characters'),
          find.text('At least 2 characters'),
          find.text('Min 100,000 THB'),
          find.text('general'),
          find.text('At least 2 characters'),
          find.byKey(const Key('prop_13_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_26', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'ห้องเช่า');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Commercial').last);
        await tester.tap(find.text('Commercial').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ส');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '99999');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '9.99');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.tap(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'ธ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 5 characters'),
          find.text('At least 2 characters'),
          find.text('Min 100,000 THB'),
          find.text('Min 10 sqm'),
          find.text('At least 2 characters'),
          find.byKey(const Key('prop_13_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

    });
    group('pairwise_valid_cases', () {
      testWidgets('pairwise_valid_cases_1', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('House').last);
        await tester.tap(find.text('House').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('prop_13_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_2', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Commercial').last);
        await tester.tap(find.text('Commercial').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Studio').last);
        await tester.tap(find.text('Studio').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.tap(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('prop_13_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_3', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Townhouse').last);
        await tester.tap(find.text('Townhouse').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.tap(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('prop_13_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_4', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Townhouse').last);
        await tester.tap(find.text('Townhouse').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('prop_13_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_5', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Land').last);
        await tester.tap(find.text('Land').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.tap(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('prop_13_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_6', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Condo').last);
        await tester.tap(find.text('Condo').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('prop_13_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_7', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('House').last);
        await tester.tap(find.text('House').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.tap(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('prop_13_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_8', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Townhouse').last);
        await tester.tap(find.text('Townhouse').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('prop_13_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_9', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Land').last);
        await tester.tap(find.text('Land').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('prop_13_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_10', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Land').last);
        await tester.tap(find.text('Land').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.tap(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('prop_13_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_11', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Condo').last);
        await tester.tap(find.text('Condo').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.tap(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('prop_13_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_12', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('House').last);
        await tester.tap(find.text('House').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Studio').last);
        await tester.tap(find.text('Studio').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('prop_13_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_13', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Commercial').last);
        await tester.tap(find.text('Commercial').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('prop_13_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_14', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Land').last);
        await tester.tap(find.text('Land').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('prop_13_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_15', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Townhouse').last);
        await tester.tap(find.text('Townhouse').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Studio').last);
        await tester.tap(find.text('Studio').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.tap(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('prop_13_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_16', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Land').last);
        await tester.tap(find.text('Land').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Studio').last);
        await tester.tap(find.text('Studio').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('prop_13_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_17', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Townhouse').last);
        await tester.tap(find.text('Townhouse').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('prop_13_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_18', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Commercial').last);
        await tester.tap(find.text('Commercial').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.tap(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('prop_13_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_19', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Condo').last);
        await tester.tap(find.text('Condo').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Studio').last);
        await tester.tap(find.text('Studio').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.tap(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('prop_13_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_20', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Commercial').last);
        await tester.tap(find.text('Commercial').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.tap(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('prop_13_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_21', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('House').last);
        await tester.tap(find.text('House').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('prop_13_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_22', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('House').last);
        await tester.tap(find.text('House').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('prop_13_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_23', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Condo').last);
        await tester.tap(find.text('Condo').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('prop_13_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_24', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Commercial').last);
        await tester.tap(find.text('Commercial').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.tap(find.byKey(const Key('prop_10_furnished_switch')));
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('prop_13_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_25', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Condo').last);
        await tester.tap(find.text('Condo').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].valid
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('prop_13_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

    });
    group('edge_cases', () {
      testWidgets('edge_cases_empty_all_fields', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Required'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('edge_cases_boundary_at_max_length', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'คอนโดมิเนียมหรูใจกลางเมือง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Condo').last);
        await tester.tap(find.text('Condo').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ถนนสุขุมวิท 21');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'วัฒนา');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '5000000');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Studio').last);
        await tester.tap(find.text('Studio').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '120.50');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '25');
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดสวยหรู วิวเมืองงาม ตกแต่งครบครัน พร้อมเข้าอยู');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'สมศักดิ์ ชัยชนะ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('prop_13_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('edge_cases_boundary_at_min_length', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertyPostCubit>(create: (_)=> PropertyPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertyPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.prop_01_title_textfield[0].atMin
        await tester.enterText(find.byKey(const Key('prop_01_title_textfield')), 'ห้องเช่า');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('prop_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Condo').last);
        await tester.tap(find.text('Condo').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_03_location_textfield[0].atMin
        await tester.enterText(find.byKey(const Key('prop_03_location_textfield')), 'ส');
        await tester.pump();
        // dataset: byKey.prop_04_district_textfield[0].atMin
        await tester.enterText(find.byKey(const Key('prop_04_district_textfield')), 'ท');
        await tester.pump();
        // dataset: byKey.prop_05_price_textfield[0].atMin
        await tester.enterText(find.byKey(const Key('prop_05_price_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_06_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Studio').last);
        await tester.tap(find.text('Studio').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.tap(find.byKey(const Key('prop_07_bathrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.prop_08_area_textfield[0].atMin
        await tester.enterText(find.byKey(const Key('prop_08_area_textfield')), '');
        await tester.pump();
        // dataset: byKey.prop_09_floor_textfield[0].atMin
        await tester.enterText(find.byKey(const Key('prop_09_floor_textfield')), '');
        await tester.pump();
        // dataset: byKey.prop_11_desc_textfield[0].atMin
        await tester.enterText(find.byKey(const Key('prop_11_desc_textfield')), 'คอนโดวิวสวยบรรยากาศดีมากๆเลย');
        await tester.pump();
        // dataset: byKey.prop_12_contact_textfield[0].atMin
        await tester.enterText(find.byKey(const Key('prop_12_contact_textfield')), 'ธ');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('prop_13_end_button')));
        await tester.tap(find.byKey(const Key('prop_13_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('prop_13_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

    });
  });
}
