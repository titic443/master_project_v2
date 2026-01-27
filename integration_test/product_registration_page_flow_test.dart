// GENERATED — Integration tests for full flow
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/product_cubit.dart';
import 'package:master_project/cubit/product_state.dart';
import 'package:master_project/demos/product_registration_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('product_registration_page.dart flow (integration)', () {
    group('pairwise_valid_invalid_cases', () {
      testWidgets('pairwise_valid_invalid_cases_1', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ProductCubit>(create: (_)=> ProductCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ProductRegistrationPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.product_02_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('product_02_name_textfield')), 'SW');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_03_category_dropdown')));
        await tester.tap(find.byKey(const Key('product_03_category_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Electronics'));
        await tester.pump();
        // dataset: byKey.product_04_sku_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_04_sku_textfield')), 'PROD-ABC123');
        await tester.pump();
        // dataset: byKey.product_05_quantity_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('product_05_quantity_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_06_price_100_500_radio')));
        await tester.tap(find.byKey(const Key('product_06_price_100_500_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.tap(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_08_featured_checkbox')));
        await tester.tap(find.byKey(const Key('product_08_featured_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_09_end_button')));
        await tester.tap(find.byKey(const Key('product_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Product name must be at least 3 characters'),
          find.text('Quantity must be at least 1'),
          find.byKey(const Key('product_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_2', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ProductCubit>(create: (_)=> ProductCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ProductRegistrationPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.product_02_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_02_name_textfield')), 'SuperWidget Pro');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_03_category_dropdown')));
        await tester.tap(find.byKey(const Key('product_03_category_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Food'));
        await tester.pump();
        // dataset: byKey.product_04_sku_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('product_04_sku_textfield')), 'S-1');
        await tester.pump();
        // dataset: byKey.product_05_quantity_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_05_quantity_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_06_price_0_100_radio')));
        await tester.tap(find.byKey(const Key('product_06_price_0_100_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_09_end_button')));
        await tester.tap(find.byKey(const Key('product_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('SKU must be uppercase alphanumeric with dash (min 5 chars)'),
          find.text('Product must be in stock to register'),
          find.byKey(const Key('product_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_3', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ProductCubit>(create: (_)=> ProductCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ProductRegistrationPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.product_02_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_02_name_textfield')), 'SuperWidget Pro');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_03_category_dropdown')));
        await tester.tap(find.byKey(const Key('product_03_category_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Food'));
        await tester.pump();
        // dataset: byKey.product_04_sku_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_04_sku_textfield')), 'PROD-ABC123');
        await tester.pump();
        // dataset: byKey.product_05_quantity_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_05_quantity_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_06_price_500_plus_radio')));
        await tester.tap(find.byKey(const Key('product_06_price_500_plus_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.tap(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_08_featured_checkbox')));
        await tester.tap(find.byKey(const Key('product_08_featured_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_09_end_button')));
        await tester.tap(find.byKey(const Key('product_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('product_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_4', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ProductCubit>(create: (_)=> ProductCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ProductRegistrationPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.product_02_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('product_02_name_textfield')), 'SW');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_03_category_dropdown')));
        await tester.tap(find.byKey(const Key('product_03_category_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Clothing'));
        await tester.pump();
        // dataset: byKey.product_04_sku_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('product_04_sku_textfield')), 'S-1');
        await tester.pump();
        // dataset: byKey.product_05_quantity_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('product_05_quantity_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_06_price_100_500_radio')));
        await tester.tap(find.byKey(const Key('product_06_price_100_500_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_09_end_button')));
        await tester.tap(find.byKey(const Key('product_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Product name must be at least 3 characters'),
          find.text('SKU must be uppercase alphanumeric with dash (min 5 chars)'),
          find.text('Quantity must be at least 1'),
          find.text('Product must be in stock to register'),
          find.byKey(const Key('product_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_5', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ProductCubit>(create: (_)=> ProductCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ProductRegistrationPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.product_02_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('product_02_name_textfield')), 'SW');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_03_category_dropdown')));
        await tester.tap(find.byKey(const Key('product_03_category_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Clothing'));
        await tester.pump();
        // dataset: byKey.product_04_sku_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_04_sku_textfield')), 'PROD-ABC123');
        await tester.pump();
        // dataset: byKey.product_05_quantity_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_05_quantity_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_06_price_0_100_radio')));
        await tester.tap(find.byKey(const Key('product_06_price_0_100_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.tap(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_08_featured_checkbox')));
        await tester.tap(find.byKey(const Key('product_08_featured_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_09_end_button')));
        await tester.tap(find.byKey(const Key('product_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Product name must be at least 3 characters'),
          find.byKey(const Key('product_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_6', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ProductCubit>(create: (_)=> ProductCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ProductRegistrationPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.product_02_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_02_name_textfield')), 'SuperWidget Pro');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_03_category_dropdown')));
        await tester.tap(find.byKey(const Key('product_03_category_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Electronics'));
        await tester.pump();
        // dataset: byKey.product_04_sku_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('product_04_sku_textfield')), 'S-1');
        await tester.pump();
        // dataset: byKey.product_05_quantity_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('product_05_quantity_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_06_price_500_plus_radio')));
        await tester.tap(find.byKey(const Key('product_06_price_500_plus_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_09_end_button')));
        await tester.tap(find.byKey(const Key('product_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('SKU must be uppercase alphanumeric with dash (min 5 chars)'),
          find.text('Quantity must be at least 1'),
          find.text('Product must be in stock to register'),
          find.byKey(const Key('product_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_7', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ProductCubit>(create: (_)=> ProductCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ProductRegistrationPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.product_02_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_02_name_textfield')), 'SuperWidget Pro');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_03_category_dropdown')));
        await tester.tap(find.byKey(const Key('product_03_category_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Books'));
        await tester.pump();
        // dataset: byKey.product_04_sku_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_04_sku_textfield')), 'PROD-ABC123');
        await tester.pump();
        // dataset: byKey.product_05_quantity_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_05_quantity_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_06_price_100_500_radio')));
        await tester.tap(find.byKey(const Key('product_06_price_100_500_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.tap(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_09_end_button')));
        await tester.tap(find.byKey(const Key('product_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('product_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_8', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ProductCubit>(create: (_)=> ProductCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ProductRegistrationPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.product_02_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('product_02_name_textfield')), 'SW');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_03_category_dropdown')));
        await tester.tap(find.byKey(const Key('product_03_category_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Food'));
        await tester.pump();
        // dataset: byKey.product_04_sku_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('product_04_sku_textfield')), 'S-1');
        await tester.pump();
        // dataset: byKey.product_05_quantity_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('product_05_quantity_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_06_price_100_500_radio')));
        await tester.tap(find.byKey(const Key('product_06_price_100_500_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.tap(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_08_featured_checkbox')));
        await tester.tap(find.byKey(const Key('product_08_featured_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_09_end_button')));
        await tester.tap(find.byKey(const Key('product_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Product name must be at least 3 characters'),
          find.text('SKU must be uppercase alphanumeric with dash (min 5 chars)'),
          find.text('Quantity must be at least 1'),
          find.byKey(const Key('product_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_9', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ProductCubit>(create: (_)=> ProductCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ProductRegistrationPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.product_02_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('product_02_name_textfield')), 'SW');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_03_category_dropdown')));
        await tester.tap(find.byKey(const Key('product_03_category_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Electronics'));
        await tester.pump();
        // dataset: byKey.product_04_sku_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_04_sku_textfield')), 'PROD-ABC123');
        await tester.pump();
        // dataset: byKey.product_05_quantity_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('product_05_quantity_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_06_price_0_100_radio')));
        await tester.tap(find.byKey(const Key('product_06_price_0_100_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_08_featured_checkbox')));
        await tester.tap(find.byKey(const Key('product_08_featured_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_09_end_button')));
        await tester.tap(find.byKey(const Key('product_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Product name must be at least 3 characters'),
          find.text('Quantity must be at least 1'),
          find.text('Product must be in stock to register'),
          find.byKey(const Key('product_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_10', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ProductCubit>(create: (_)=> ProductCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ProductRegistrationPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.product_02_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('product_02_name_textfield')), 'SW');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_03_category_dropdown')));
        await tester.tap(find.byKey(const Key('product_03_category_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Books'));
        await tester.pump();
        // dataset: byKey.product_04_sku_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('product_04_sku_textfield')), 'S-1');
        await tester.pump();
        // dataset: byKey.product_05_quantity_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('product_05_quantity_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_06_price_500_plus_radio')));
        await tester.tap(find.byKey(const Key('product_06_price_500_plus_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_08_featured_checkbox')));
        await tester.tap(find.byKey(const Key('product_08_featured_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_09_end_button')));
        await tester.tap(find.byKey(const Key('product_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Product name must be at least 3 characters'),
          find.text('SKU must be uppercase alphanumeric with dash (min 5 chars)'),
          find.text('Quantity must be at least 1'),
          find.text('Product must be in stock to register'),
          find.byKey(const Key('product_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_11', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ProductCubit>(create: (_)=> ProductCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ProductRegistrationPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.product_02_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_02_name_textfield')), 'SuperWidget Pro');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_03_category_dropdown')));
        await tester.tap(find.byKey(const Key('product_03_category_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Clothing'));
        await tester.pump();
        // dataset: byKey.product_04_sku_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_04_sku_textfield')), 'PROD-ABC123');
        await tester.pump();
        // dataset: byKey.product_05_quantity_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('product_05_quantity_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_06_price_500_plus_radio')));
        await tester.tap(find.byKey(const Key('product_06_price_500_plus_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.tap(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_08_featured_checkbox')));
        await tester.tap(find.byKey(const Key('product_08_featured_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_09_end_button')));
        await tester.tap(find.byKey(const Key('product_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Quantity must be at least 1'),
          find.byKey(const Key('product_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_12', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ProductCubit>(create: (_)=> ProductCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ProductRegistrationPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.product_02_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('product_02_name_textfield')), 'SW');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_03_category_dropdown')));
        await tester.tap(find.byKey(const Key('product_03_category_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Electronics'));
        await tester.pump();
        // dataset: byKey.product_04_sku_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('product_04_sku_textfield')), 'S-1');
        await tester.pump();
        // dataset: byKey.product_05_quantity_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_05_quantity_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_06_price_0_100_radio')));
        await tester.tap(find.byKey(const Key('product_06_price_0_100_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_08_featured_checkbox')));
        await tester.tap(find.byKey(const Key('product_08_featured_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_09_end_button')));
        await tester.tap(find.byKey(const Key('product_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Product name must be at least 3 characters'),
          find.text('SKU must be uppercase alphanumeric with dash (min 5 chars)'),
          find.text('Product must be in stock to register'),
          find.byKey(const Key('product_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_13', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ProductCubit>(create: (_)=> ProductCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ProductRegistrationPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.product_02_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('product_02_name_textfield')), 'SW');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_03_category_dropdown')));
        await tester.tap(find.byKey(const Key('product_03_category_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Books'));
        await tester.pump();
        // dataset: byKey.product_04_sku_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_04_sku_textfield')), 'PROD-ABC123');
        await tester.pump();
        // dataset: byKey.product_05_quantity_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('product_05_quantity_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_06_price_0_100_radio')));
        await tester.tap(find.byKey(const Key('product_06_price_0_100_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.tap(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_09_end_button')));
        await tester.tap(find.byKey(const Key('product_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Product name must be at least 3 characters'),
          find.text('Quantity must be at least 1'),
          find.byKey(const Key('product_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

    });
    group('pairwise_valid_cases', () {
      testWidgets('pairwise_valid_cases_1', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ProductCubit>(create: (_)=> ProductCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ProductRegistrationPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.product_02_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_02_name_textfield')), 'SuperWidget Pro');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_03_category_dropdown')));
        await tester.tap(find.byKey(const Key('product_03_category_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Clothing'));
        await tester.pump();
        // dataset: byKey.product_04_sku_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_04_sku_textfield')), 'PROD-ABC123');
        await tester.pump();
        // dataset: byKey.product_05_quantity_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_05_quantity_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_06_price_0_100_radio')));
        await tester.tap(find.byKey(const Key('product_06_price_0_100_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.tap(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_08_featured_checkbox')));
        await tester.tap(find.byKey(const Key('product_08_featured_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_09_end_button')));
        await tester.tap(find.byKey(const Key('product_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('product_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_2', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ProductCubit>(create: (_)=> ProductCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ProductRegistrationPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.product_02_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_02_name_textfield')), 'SuperWidget Pro');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_03_category_dropdown')));
        await tester.tap(find.byKey(const Key('product_03_category_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Electronics'));
        await tester.pump();
        // dataset: byKey.product_04_sku_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_04_sku_textfield')), 'PROD-ABC123');
        await tester.pump();
        // dataset: byKey.product_05_quantity_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_05_quantity_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_06_price_0_100_radio')));
        await tester.tap(find.byKey(const Key('product_06_price_0_100_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.tap(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_09_end_button')));
        await tester.tap(find.byKey(const Key('product_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('product_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_3', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ProductCubit>(create: (_)=> ProductCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ProductRegistrationPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.product_02_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_02_name_textfield')), 'SuperWidget Pro');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_03_category_dropdown')));
        await tester.tap(find.byKey(const Key('product_03_category_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Electronics'));
        await tester.pump();
        // dataset: byKey.product_04_sku_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_04_sku_textfield')), 'PROD-ABC123');
        await tester.pump();
        // dataset: byKey.product_05_quantity_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_05_quantity_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_06_price_100_500_radio')));
        await tester.tap(find.byKey(const Key('product_06_price_100_500_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.tap(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_08_featured_checkbox')));
        await tester.tap(find.byKey(const Key('product_08_featured_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_09_end_button')));
        await tester.tap(find.byKey(const Key('product_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('product_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_4', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ProductCubit>(create: (_)=> ProductCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ProductRegistrationPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.product_02_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_02_name_textfield')), 'SuperWidget Pro');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_03_category_dropdown')));
        await tester.tap(find.byKey(const Key('product_03_category_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Clothing'));
        await tester.pump();
        // dataset: byKey.product_04_sku_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_04_sku_textfield')), 'PROD-ABC123');
        await tester.pump();
        // dataset: byKey.product_05_quantity_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_05_quantity_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_06_price_500_plus_radio')));
        await tester.tap(find.byKey(const Key('product_06_price_500_plus_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.tap(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_09_end_button')));
        await tester.tap(find.byKey(const Key('product_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('product_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_5', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ProductCubit>(create: (_)=> ProductCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ProductRegistrationPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.product_02_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_02_name_textfield')), 'SuperWidget Pro');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_03_category_dropdown')));
        await tester.tap(find.byKey(const Key('product_03_category_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Books'));
        await tester.pump();
        // dataset: byKey.product_04_sku_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_04_sku_textfield')), 'PROD-ABC123');
        await tester.pump();
        // dataset: byKey.product_05_quantity_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_05_quantity_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_06_price_100_500_radio')));
        await tester.tap(find.byKey(const Key('product_06_price_100_500_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.tap(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_09_end_button')));
        await tester.tap(find.byKey(const Key('product_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('product_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_6', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ProductCubit>(create: (_)=> ProductCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ProductRegistrationPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.product_02_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_02_name_textfield')), 'SuperWidget Pro');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_03_category_dropdown')));
        await tester.tap(find.byKey(const Key('product_03_category_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Food'));
        await tester.pump();
        // dataset: byKey.product_04_sku_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_04_sku_textfield')), 'PROD-ABC123');
        await tester.pump();
        // dataset: byKey.product_05_quantity_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_05_quantity_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_06_price_0_100_radio')));
        await tester.tap(find.byKey(const Key('product_06_price_0_100_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.tap(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_09_end_button')));
        await tester.tap(find.byKey(const Key('product_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('product_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_7', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ProductCubit>(create: (_)=> ProductCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ProductRegistrationPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.product_02_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_02_name_textfield')), 'SuperWidget Pro');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_03_category_dropdown')));
        await tester.tap(find.byKey(const Key('product_03_category_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Books'));
        await tester.pump();
        // dataset: byKey.product_04_sku_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_04_sku_textfield')), 'PROD-ABC123');
        await tester.pump();
        // dataset: byKey.product_05_quantity_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_05_quantity_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_06_price_0_100_radio')));
        await tester.tap(find.byKey(const Key('product_06_price_0_100_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.tap(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_08_featured_checkbox')));
        await tester.tap(find.byKey(const Key('product_08_featured_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_09_end_button')));
        await tester.tap(find.byKey(const Key('product_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('product_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_8', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ProductCubit>(create: (_)=> ProductCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ProductRegistrationPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.product_02_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_02_name_textfield')), 'SuperWidget Pro');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_03_category_dropdown')));
        await tester.tap(find.byKey(const Key('product_03_category_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Food'));
        await tester.pump();
        // dataset: byKey.product_04_sku_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_04_sku_textfield')), 'PROD-ABC123');
        await tester.pump();
        // dataset: byKey.product_05_quantity_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_05_quantity_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_06_price_500_plus_radio')));
        await tester.tap(find.byKey(const Key('product_06_price_500_plus_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.tap(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_08_featured_checkbox')));
        await tester.tap(find.byKey(const Key('product_08_featured_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_09_end_button')));
        await tester.tap(find.byKey(const Key('product_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('product_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_9', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ProductCubit>(create: (_)=> ProductCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ProductRegistrationPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.product_02_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_02_name_textfield')), 'SuperWidget Pro');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_03_category_dropdown')));
        await tester.tap(find.byKey(const Key('product_03_category_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Clothing'));
        await tester.pump();
        // dataset: byKey.product_04_sku_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_04_sku_textfield')), 'PROD-ABC123');
        await tester.pump();
        // dataset: byKey.product_05_quantity_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_05_quantity_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_06_price_100_500_radio')));
        await tester.tap(find.byKey(const Key('product_06_price_100_500_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.tap(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_09_end_button')));
        await tester.tap(find.byKey(const Key('product_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('product_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_10', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ProductCubit>(create: (_)=> ProductCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ProductRegistrationPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.product_02_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_02_name_textfield')), 'SuperWidget Pro');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_03_category_dropdown')));
        await tester.tap(find.byKey(const Key('product_03_category_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Food'));
        await tester.pump();
        // dataset: byKey.product_04_sku_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_04_sku_textfield')), 'PROD-ABC123');
        await tester.pump();
        // dataset: byKey.product_05_quantity_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_05_quantity_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_06_price_100_500_radio')));
        await tester.tap(find.byKey(const Key('product_06_price_100_500_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.tap(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_09_end_button')));
        await tester.tap(find.byKey(const Key('product_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('product_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_11', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ProductCubit>(create: (_)=> ProductCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ProductRegistrationPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.product_02_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_02_name_textfield')), 'SuperWidget Pro');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_03_category_dropdown')));
        await tester.tap(find.byKey(const Key('product_03_category_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Electronics'));
        await tester.pump();
        // dataset: byKey.product_04_sku_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_04_sku_textfield')), 'PROD-ABC123');
        await tester.pump();
        // dataset: byKey.product_05_quantity_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_05_quantity_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_06_price_500_plus_radio')));
        await tester.tap(find.byKey(const Key('product_06_price_500_plus_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.tap(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_08_featured_checkbox')));
        await tester.tap(find.byKey(const Key('product_08_featured_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_09_end_button')));
        await tester.tap(find.byKey(const Key('product_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('product_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_12', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ProductCubit>(create: (_)=> ProductCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ProductRegistrationPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.product_02_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_02_name_textfield')), 'SuperWidget Pro');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_03_category_dropdown')));
        await tester.tap(find.byKey(const Key('product_03_category_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Books'));
        await tester.pump();
        // dataset: byKey.product_04_sku_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_04_sku_textfield')), 'PROD-ABC123');
        await tester.pump();
        // dataset: byKey.product_05_quantity_textfield[0].valid
        await tester.enterText(find.byKey(const Key('product_05_quantity_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_06_price_500_plus_radio')));
        await tester.tap(find.byKey(const Key('product_06_price_500_plus_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.tap(find.byKey(const Key('product_07_instock_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_08_featured_checkbox')));
        await tester.tap(find.byKey(const Key('product_08_featured_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('product_09_end_button')));
        await tester.tap(find.byKey(const Key('product_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('product_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

    });
    group('edge_cases', () {
      testWidgets('edge_cases_empty_all_fields', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ProductCubit>(create: (_)=> ProductCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ProductRegistrationPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('product_09_end_button')));
        await tester.tap(find.byKey(const Key('product_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Product name is required'),
          find.text('Please select a category'),
          find.text('SKU is required'),
          find.text('Quantity is required'),
          find.text('Please select a price range'),
          find.text('Product must be in stock to register'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

    });
  });
}
