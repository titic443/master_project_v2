// GENERATED — Integration tests for full flow
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/property_search_cubit.dart';
import 'package:master_project/demos/property_search_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('property_search_page.dart flow (integration)', () {
    group('pairwise_valid_invalid_cases', () {
      testWidgets('pairwise_valid_invalid_cases_1', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'น');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('บ้านเดี่ยว').last);
        await tester.tap(find.text('บ้านเดี่ยว').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_invalid_cases_2', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ที่ดิน').last);
        await tester.tap(find.text('ที่ดิน').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('สตูดิโอ').last);
        await tester.tap(find.text('สตูดิโอ').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_07_furnished_switch')));
        await tester.tap(find.byKey(const Key('search_07_furnished_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('search_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_invalid_cases_3', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'น');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('อาคารพาณิชย์').last);
        await tester.tap(find.text('อาคารพาณิชย์').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_07_furnished_switch')));
        await tester.tap(find.byKey(const Key('search_07_furnished_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_invalid_cases_4', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'น');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ทาวน์เฮาส์').last);
        await tester.tap(find.text('ทาวน์เฮาส์').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_invalid_cases_5', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ที่ดิน').last);
        await tester.tap(find.text('ที่ดิน').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_invalid_cases_6', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('อาคารพาณิชย์').last);
        await tester.tap(find.text('อาคารพาณิชย์').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_07_furnished_switch')));
        await tester.tap(find.byKey(const Key('search_07_furnished_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_invalid_cases_7', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('บ้านเดี่ยว').last);
        await tester.tap(find.text('บ้านเดี่ยว').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('สตูดิโอ').last);
        await tester.tap(find.text('สตูดิโอ').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_invalid_cases_8', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'น');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('อาคารพาณิชย์').last);
        await tester.tap(find.text('อาคารพาณิชย์').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_invalid_cases_9', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'น');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('อาคารพาณิชย์').last);
        await tester.tap(find.text('อาคารพาณิชย์').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('สตูดิโอ').last);
        await tester.tap(find.text('สตูดิโอ').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_07_furnished_switch')));
        await tester.tap(find.byKey(const Key('search_07_furnished_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_invalid_cases_10', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ที่ดิน').last);
        await tester.tap(find.text('ที่ดิน').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_invalid_cases_11', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ทาวน์เฮาส์').last);
        await tester.tap(find.text('ทาวน์เฮาส์').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_07_furnished_switch')));
        await tester.tap(find.byKey(const Key('search_07_furnished_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_invalid_cases_12', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('คอนโด').last);
        await tester.tap(find.text('คอนโด').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_invalid_cases_13', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'น');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('คอนโด').last);
        await tester.tap(find.text('คอนโด').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_07_furnished_switch')));
        await tester.tap(find.byKey(const Key('search_07_furnished_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_invalid_cases_14', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('บ้านเดี่ยว').last);
        await tester.tap(find.text('บ้านเดี่ยว').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_07_furnished_switch')));
        await tester.tap(find.byKey(const Key('search_07_furnished_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('search_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_invalid_cases_15', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'น');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('คอนโด').last);
        await tester.tap(find.text('คอนโด').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('สตูดิโอ').last);
        await tester.tap(find.text('สตูดิโอ').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_07_furnished_switch')));
        await tester.tap(find.byKey(const Key('search_07_furnished_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_invalid_cases_16', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ที่ดิน').last);
        await tester.tap(find.text('ที่ดิน').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_07_furnished_switch')));
        await tester.tap(find.byKey(const Key('search_07_furnished_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('search_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_invalid_cases_17', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ทาวน์เฮาส์').last);
        await tester.tap(find.text('ทาวน์เฮาส์').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('สตูดิโอ').last);
        await tester.tap(find.text('สตูดิโอ').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_invalid_cases_18', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'น');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('อาคารพาณิชย์').last);
        await tester.tap(find.text('อาคารพาณิชย์').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_invalid_cases_19', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('คอนโด').last);
        await tester.tap(find.text('คอนโด').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_invalid_cases_20', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('บ้านเดี่ยว').last);
        await tester.tap(find.text('บ้านเดี่ยว').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_invalid_cases_21', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'น');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('บ้านเดี่ยว').last);
        await tester.tap(find.text('บ้านเดี่ยว').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_invalid_cases_22', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'น');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ทาวน์เฮาส์').last);
        await tester.tap(find.text('ทาวน์เฮาส์').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_07_furnished_switch')));
        await tester.tap(find.byKey(const Key('search_07_furnished_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_invalid_cases_23', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'น');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ที่ดิน').last);
        await tester.tap(find.text('ที่ดิน').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_07_furnished_switch')));
        await tester.tap(find.byKey(const Key('search_07_furnished_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_invalid_cases_24', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('คอนโด').last);
        await tester.tap(find.text('คอนโด').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_invalid_cases_25', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ทาวน์เฮาส์').last);
        await tester.tap(find.text('ทาวน์เฮาส์').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
      });

    });
    group('pairwise_valid_cases', () {
      testWidgets('pairwise_valid_cases_1', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ทาวน์เฮาส์').last);
        await tester.tap(find.text('ทาวน์เฮาส์').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_07_furnished_switch')));
        await tester.tap(find.byKey(const Key('search_07_furnished_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('search_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_cases_2', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('อาคารพาณิชย์').last);
        await tester.tap(find.text('อาคารพาณิชย์').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('search_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_cases_3', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('อาคารพาณิชย์').last);
        await tester.tap(find.text('อาคารพาณิชย์').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_07_furnished_switch')));
        await tester.tap(find.byKey(const Key('search_07_furnished_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('search_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_cases_4', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('บ้านเดี่ยว').last);
        await tester.tap(find.text('บ้านเดี่ยว').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('สตูดิโอ').last);
        await tester.tap(find.text('สตูดิโอ').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_07_furnished_switch')));
        await tester.tap(find.byKey(const Key('search_07_furnished_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('search_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_cases_5', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('คอนโด').last);
        await tester.tap(find.text('คอนโด').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('search_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_cases_6', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ทาวน์เฮาส์').last);
        await tester.tap(find.text('ทาวน์เฮาส์').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('สตูดิโอ').last);
        await tester.tap(find.text('สตูดิโอ').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('search_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_cases_7', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ทาวน์เฮาส์').last);
        await tester.tap(find.text('ทาวน์เฮาส์').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_07_furnished_switch')));
        await tester.tap(find.byKey(const Key('search_07_furnished_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('search_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_cases_8', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('บ้านเดี่ยว').last);
        await tester.tap(find.text('บ้านเดี่ยว').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('search_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_cases_9', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('บ้านเดี่ยว').last);
        await tester.tap(find.text('บ้านเดี่ยว').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('search_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_cases_10', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('อาคารพาณิชย์').last);
        await tester.tap(find.text('อาคารพาณิชย์').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('สตูดิโอ').last);
        await tester.tap(find.text('สตูดิโอ').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_07_furnished_switch')));
        await tester.tap(find.byKey(const Key('search_07_furnished_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('search_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_cases_11', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ทาวน์เฮาส์').last);
        await tester.tap(find.text('ทาวน์เฮาส์').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_07_furnished_switch')));
        await tester.tap(find.byKey(const Key('search_07_furnished_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('search_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_cases_12', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ที่ดิน').last);
        await tester.tap(find.text('ที่ดิน').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_07_furnished_switch')));
        await tester.tap(find.byKey(const Key('search_07_furnished_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('search_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_cases_13', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('คอนโด').last);
        await tester.tap(find.text('คอนโด').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('สตูดิโอ').last);
        await tester.tap(find.text('สตูดิโอ').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_07_furnished_switch')));
        await tester.tap(find.byKey(const Key('search_07_furnished_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('search_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_cases_14', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ที่ดิน').last);
        await tester.tap(find.text('ที่ดิน').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('สตูดิโอ').last);
        await tester.tap(find.text('สตูดิโอ').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('search_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_cases_15', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('อาคารพาณิชย์').last);
        await tester.tap(find.text('อาคารพาณิชย์').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_07_furnished_switch')));
        await tester.tap(find.byKey(const Key('search_07_furnished_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('search_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_cases_16', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('อาคารพาณิชย์').last);
        await tester.tap(find.text('อาคารพาณิชย์').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('search_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_cases_17', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('บ้านเดี่ยว').last);
        await tester.tap(find.text('บ้านเดี่ยว').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('search_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_cases_18', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('คอนโด').last);
        await tester.tap(find.text('คอนโด').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_07_furnished_switch')));
        await tester.tap(find.byKey(const Key('search_07_furnished_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('search_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_cases_19', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ที่ดิน').last);
        await tester.tap(find.text('ที่ดิน').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_07_furnished_switch')));
        await tester.tap(find.byKey(const Key('search_07_furnished_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('search_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_cases_20', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ที่ดิน').last);
        await tester.tap(find.text('ที่ดิน').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_07_furnished_switch')));
        await tester.tap(find.byKey(const Key('search_07_furnished_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('search_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_cases_21', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ทาวน์เฮาส์').last);
        await tester.tap(find.text('ทาวน์เฮาส์').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_07_furnished_switch')));
        await tester.tap(find.byKey(const Key('search_07_furnished_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('search_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_cases_22', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('คอนโด').last);
        await tester.tap(find.text('คอนโด').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('4+').last);
        await tester.tap(find.text('4+').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('search_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_cases_23', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('บ้านเดี่ยว').last);
        await tester.tap(find.text('บ้านเดี่ยว').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('1').last);
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_07_furnished_switch')));
        await tester.tap(find.byKey(const Key('search_07_furnished_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('search_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_cases_24', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ที่ดิน').last);
        await tester.tap(find.text('ที่ดิน').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_07_furnished_switch')));
        await tester.tap(find.byKey(const Key('search_07_furnished_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('search_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_cases_25', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('คอนโด').last);
        await tester.tap(find.text('คอนโด').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('2').last);
        await tester.tap(find.text('2').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '75.50');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('search_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

    });
    group('edge_cases', () {
      testWidgets('edge_cases_empty_all_fields', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('search_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('edge_cases_boundary_at_max_length', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'กรุงเทพมหานคร');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('คอนโด').last);
        await tester.tap(find.text('คอนโด').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('สตูดิโอ').last);
        await tester.tap(find.text('สตูดิโอ').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '500000');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '10000000');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '123456789.01');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('search_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('edge_cases_boundary_at_min_length', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<PropertySearchCubit>(create: (_)=> PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].atMin
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('คอนโด').last);
        await tester.tap(find.text('คอนโด').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('สตูดิโอ').last);
        await tester.tap(find.text('สตูดิโอ').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].atMin
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].atMin
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].atMin
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('search_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

    });
  });
}
