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
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: CustomerDetailsPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.tap(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Dr.'));
        await tester.pump();
        // dataset: byKey.customer_02_firstname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_02_firstname_textfield')), 'Nattapong');
        await tester.pump();
        // dataset: byKey.customer_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('customer_03_phone_textfield')), '0812345');
        await tester.pump();
        // dataset: byKey.customer_04_lastname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_04_lastname_textfield')), 'Srisakul');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_05_age_10_20_radio')));
        await tester.tap(find.byKey(const Key('customer_05_age_10_20_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_08_end_button')));
        await tester.tap(find.byKey(const Key('customer_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Phone number must be exactly 10 digits'),
          find.text('You must agree to terms'),
          find.byKey(const Key('customer_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_2', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<CustomerCubit>(create: (_)=> CustomerCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: CustomerDetailsPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.tap(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Mr.'));
        await tester.pump();
        // dataset: byKey.customer_02_firstname_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('customer_02_firstname_textfield')), 'N');
        await tester.pump();
        // dataset: byKey.customer_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_03_phone_textfield')), '0812345678');
        await tester.pump();
        // dataset: byKey.customer_04_lastname_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('customer_04_lastname_textfield')), 'S');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_05_age_30_40_radio')));
        await tester.tap(find.byKey(const Key('customer_05_age_30_40_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_07_subscribe_newsletter_checkbox')));
        await tester.tap(find.byKey(const Key('customer_07_subscribe_newsletter_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_08_end_button')));
        await tester.tap(find.byKey(const Key('customer_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('First name must contain only letters (minimum 2 characters)'),
          find.text('Last name must contain only letters (minimum 2 characters)'),
          find.byKey(const Key('customer_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_3', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<CustomerCubit>(create: (_)=> CustomerCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: CustomerDetailsPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.tap(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Mrs.'));
        await tester.pump();
        // dataset: byKey.customer_02_firstname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_02_firstname_textfield')), 'Nattapong');
        await tester.pump();
        // dataset: byKey.customer_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_03_phone_textfield')), '0812345678');
        await tester.pump();
        // dataset: byKey.customer_04_lastname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_04_lastname_textfield')), 'Srisakul');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_05_age_40_50_radio')));
        await tester.tap(find.byKey(const Key('customer_05_age_40_50_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_07_subscribe_newsletter_checkbox')));
        await tester.tap(find.byKey(const Key('customer_07_subscribe_newsletter_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_08_end_button')));
        await tester.tap(find.byKey(const Key('customer_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('You must agree to terms'),
          find.byKey(const Key('customer_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_4', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<CustomerCubit>(create: (_)=> CustomerCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: CustomerDetailsPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.tap(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Dr.'));
        await tester.pump();
        // dataset: byKey.customer_02_firstname_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('customer_02_firstname_textfield')), 'N');
        await tester.pump();
        // dataset: byKey.customer_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('customer_03_phone_textfield')), '0812345');
        await tester.pump();
        // dataset: byKey.customer_04_lastname_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('customer_04_lastname_textfield')), 'S');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_05_age_30_40_radio')));
        await tester.tap(find.byKey(const Key('customer_05_age_30_40_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_08_end_button')));
        await tester.tap(find.byKey(const Key('customer_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('First name must contain only letters (minimum 2 characters)'),
          find.text('Phone number must be exactly 10 digits'),
          find.text('Last name must contain only letters (minimum 2 characters)'),
          find.byKey(const Key('customer_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_5', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<CustomerCubit>(create: (_)=> CustomerCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: CustomerDetailsPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.tap(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Ms.'));
        await tester.pump();
        // dataset: byKey.customer_02_firstname_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('customer_02_firstname_textfield')), 'N');
        await tester.pump();
        // dataset: byKey.customer_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('customer_03_phone_textfield')), '0812345');
        await tester.pump();
        // dataset: byKey.customer_04_lastname_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('customer_04_lastname_textfield')), 'S');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_05_age_40_50_radio')));
        await tester.tap(find.byKey(const Key('customer_05_age_40_50_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_08_end_button')));
        await tester.tap(find.byKey(const Key('customer_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('First name must contain only letters (minimum 2 characters)'),
          find.text('Phone number must be exactly 10 digits'),
          find.text('Last name must contain only letters (minimum 2 characters)'),
          find.text('You must agree to terms'),
          find.byKey(const Key('customer_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_6', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<CustomerCubit>(create: (_)=> CustomerCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: CustomerDetailsPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.tap(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Dr.'));
        await tester.pump();
        // dataset: byKey.customer_02_firstname_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('customer_02_firstname_textfield')), 'N');
        await tester.pump();
        // dataset: byKey.customer_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('customer_03_phone_textfield')), '0812345');
        await tester.pump();
        // dataset: byKey.customer_04_lastname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_04_lastname_textfield')), 'Srisakul');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_05_age_40_50_radio')));
        await tester.tap(find.byKey(const Key('customer_05_age_40_50_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_07_subscribe_newsletter_checkbox')));
        await tester.tap(find.byKey(const Key('customer_07_subscribe_newsletter_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_08_end_button')));
        await tester.tap(find.byKey(const Key('customer_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('First name must contain only letters (minimum 2 characters)'),
          find.text('Phone number must be exactly 10 digits'),
          find.byKey(const Key('customer_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_7', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<CustomerCubit>(create: (_)=> CustomerCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: CustomerDetailsPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.tap(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Mrs.'));
        await tester.pump();
        // dataset: byKey.customer_02_firstname_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('customer_02_firstname_textfield')), 'N');
        await tester.pump();
        // dataset: byKey.customer_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_03_phone_textfield')), '0812345678');
        await tester.pump();
        // dataset: byKey.customer_04_lastname_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('customer_04_lastname_textfield')), 'S');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_05_age_10_20_radio')));
        await tester.tap(find.byKey(const Key('customer_05_age_10_20_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_08_end_button')));
        await tester.tap(find.byKey(const Key('customer_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('First name must contain only letters (minimum 2 characters)'),
          find.text('Last name must contain only letters (minimum 2 characters)'),
          find.byKey(const Key('customer_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_8', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<CustomerCubit>(create: (_)=> CustomerCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: CustomerDetailsPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.tap(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Mr.'));
        await tester.pump();
        // dataset: byKey.customer_02_firstname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_02_firstname_textfield')), 'Nattapong');
        await tester.pump();
        // dataset: byKey.customer_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('customer_03_phone_textfield')), '0812345');
        await tester.pump();
        // dataset: byKey.customer_04_lastname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_04_lastname_textfield')), 'Srisakul');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_05_age_10_20_radio')));
        await tester.tap(find.byKey(const Key('customer_05_age_10_20_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_07_subscribe_newsletter_checkbox')));
        await tester.tap(find.byKey(const Key('customer_07_subscribe_newsletter_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_08_end_button')));
        await tester.tap(find.byKey(const Key('customer_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Phone number must be exactly 10 digits'),
          find.text('You must agree to terms'),
          find.byKey(const Key('customer_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_9', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<CustomerCubit>(create: (_)=> CustomerCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: CustomerDetailsPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.tap(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Mr.'));
        await tester.pump();
        // dataset: byKey.customer_02_firstname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_02_firstname_textfield')), 'Nattapong');
        await tester.pump();
        // dataset: byKey.customer_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('customer_03_phone_textfield')), '0812345');
        await tester.pump();
        // dataset: byKey.customer_04_lastname_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('customer_04_lastname_textfield')), 'S');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_05_age_40_50_radio')));
        await tester.tap(find.byKey(const Key('customer_05_age_40_50_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_08_end_button')));
        await tester.tap(find.byKey(const Key('customer_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Phone number must be exactly 10 digits'),
          find.text('Last name must contain only letters (minimum 2 characters)'),
          find.byKey(const Key('customer_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_10', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<CustomerCubit>(create: (_)=> CustomerCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: CustomerDetailsPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.tap(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Mrs.'));
        await tester.pump();
        // dataset: byKey.customer_02_firstname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_02_firstname_textfield')), 'Nattapong');
        await tester.pump();
        // dataset: byKey.customer_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('customer_03_phone_textfield')), '0812345');
        await tester.pump();
        // dataset: byKey.customer_04_lastname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_04_lastname_textfield')), 'Srisakul');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_05_age_30_40_radio')));
        await tester.tap(find.byKey(const Key('customer_05_age_30_40_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_07_subscribe_newsletter_checkbox')));
        await tester.tap(find.byKey(const Key('customer_07_subscribe_newsletter_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_08_end_button')));
        await tester.tap(find.byKey(const Key('customer_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Phone number must be exactly 10 digits'),
          find.text('You must agree to terms'),
          find.byKey(const Key('customer_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_11', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<CustomerCubit>(create: (_)=> CustomerCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: CustomerDetailsPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.tap(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Dr.'));
        await tester.pump();
        // dataset: byKey.customer_02_firstname_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('customer_02_firstname_textfield')), 'N');
        await tester.pump();
        // dataset: byKey.customer_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_03_phone_textfield')), '0812345678');
        await tester.pump();
        // dataset: byKey.customer_04_lastname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_04_lastname_textfield')), 'Srisakul');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_05_age_30_40_radio')));
        await tester.tap(find.byKey(const Key('customer_05_age_30_40_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_08_end_button')));
        await tester.tap(find.byKey(const Key('customer_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('First name must contain only letters (minimum 2 characters)'),
          find.byKey(const Key('customer_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_12', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<CustomerCubit>(create: (_)=> CustomerCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: CustomerDetailsPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.tap(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Ms.'));
        await tester.pump();
        // dataset: byKey.customer_02_firstname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_02_firstname_textfield')), 'Nattapong');
        await tester.pump();
        // dataset: byKey.customer_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_03_phone_textfield')), '0812345678');
        await tester.pump();
        // dataset: byKey.customer_04_lastname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_04_lastname_textfield')), 'Srisakul');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_05_age_30_40_radio')));
        await tester.tap(find.byKey(const Key('customer_05_age_30_40_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_07_subscribe_newsletter_checkbox')));
        await tester.tap(find.byKey(const Key('customer_07_subscribe_newsletter_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_08_end_button')));
        await tester.tap(find.byKey(const Key('customer_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('customer_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_13', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<CustomerCubit>(create: (_)=> CustomerCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: CustomerDetailsPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.tap(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Ms.'));
        await tester.pump();
        // dataset: byKey.customer_02_firstname_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('customer_02_firstname_textfield')), 'N');
        await tester.pump();
        // dataset: byKey.customer_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_03_phone_textfield')), '0812345678');
        await tester.pump();
        // dataset: byKey.customer_04_lastname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_04_lastname_textfield')), 'Srisakul');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_05_age_10_20_radio')));
        await tester.tap(find.byKey(const Key('customer_05_age_10_20_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_08_end_button')));
        await tester.tap(find.byKey(const Key('customer_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('First name must contain only letters (minimum 2 characters)'),
          find.text('You must agree to terms'),
          find.byKey(const Key('customer_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

    });
    group('pairwise_valid_cases', () {
      testWidgets('pairwise_valid_cases_1', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<CustomerCubit>(create: (_)=> CustomerCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: CustomerDetailsPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.tap(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Dr.'));
        await tester.pump();
        // dataset: byKey.customer_02_firstname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_02_firstname_textfield')), 'Nattapong');
        await tester.pump();
        // dataset: byKey.customer_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_03_phone_textfield')), '0812345678');
        await tester.pump();
        // dataset: byKey.customer_04_lastname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_04_lastname_textfield')), 'Srisakul');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_05_age_40_50_radio')));
        await tester.tap(find.byKey(const Key('customer_05_age_40_50_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_08_end_button')));
        await tester.tap(find.byKey(const Key('customer_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('customer_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_2', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<CustomerCubit>(create: (_)=> CustomerCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: CustomerDetailsPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.tap(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Mr.'));
        await tester.pump();
        // dataset: byKey.customer_02_firstname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_02_firstname_textfield')), 'Nattapong');
        await tester.pump();
        // dataset: byKey.customer_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_03_phone_textfield')), '0812345678');
        await tester.pump();
        // dataset: byKey.customer_04_lastname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_04_lastname_textfield')), 'Srisakul');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_05_age_30_40_radio')));
        await tester.tap(find.byKey(const Key('customer_05_age_30_40_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_07_subscribe_newsletter_checkbox')));
        await tester.tap(find.byKey(const Key('customer_07_subscribe_newsletter_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_08_end_button')));
        await tester.tap(find.byKey(const Key('customer_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('customer_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_3', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<CustomerCubit>(create: (_)=> CustomerCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: CustomerDetailsPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.tap(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Mr.'));
        await tester.pump();
        // dataset: byKey.customer_02_firstname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_02_firstname_textfield')), 'Nattapong');
        await tester.pump();
        // dataset: byKey.customer_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_03_phone_textfield')), '0812345678');
        await tester.pump();
        // dataset: byKey.customer_04_lastname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_04_lastname_textfield')), 'Srisakul');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_05_age_40_50_radio')));
        await tester.tap(find.byKey(const Key('customer_05_age_40_50_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_08_end_button')));
        await tester.tap(find.byKey(const Key('customer_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('customer_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_4', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<CustomerCubit>(create: (_)=> CustomerCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: CustomerDetailsPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.tap(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Mrs.'));
        await tester.pump();
        // dataset: byKey.customer_02_firstname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_02_firstname_textfield')), 'Nattapong');
        await tester.pump();
        // dataset: byKey.customer_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_03_phone_textfield')), '0812345678');
        await tester.pump();
        // dataset: byKey.customer_04_lastname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_04_lastname_textfield')), 'Srisakul');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_05_age_10_20_radio')));
        await tester.tap(find.byKey(const Key('customer_05_age_10_20_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_08_end_button')));
        await tester.tap(find.byKey(const Key('customer_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('customer_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_5', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<CustomerCubit>(create: (_)=> CustomerCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: CustomerDetailsPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.tap(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Ms.'));
        await tester.pump();
        // dataset: byKey.customer_02_firstname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_02_firstname_textfield')), 'Nattapong');
        await tester.pump();
        // dataset: byKey.customer_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_03_phone_textfield')), '0812345678');
        await tester.pump();
        // dataset: byKey.customer_04_lastname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_04_lastname_textfield')), 'Srisakul');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_05_age_40_50_radio')));
        await tester.tap(find.byKey(const Key('customer_05_age_40_50_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_07_subscribe_newsletter_checkbox')));
        await tester.tap(find.byKey(const Key('customer_07_subscribe_newsletter_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_08_end_button')));
        await tester.tap(find.byKey(const Key('customer_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('customer_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_6', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<CustomerCubit>(create: (_)=> CustomerCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: CustomerDetailsPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.tap(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Dr.'));
        await tester.pump();
        // dataset: byKey.customer_02_firstname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_02_firstname_textfield')), 'Nattapong');
        await tester.pump();
        // dataset: byKey.customer_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_03_phone_textfield')), '0812345678');
        await tester.pump();
        // dataset: byKey.customer_04_lastname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_04_lastname_textfield')), 'Srisakul');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_05_age_30_40_radio')));
        await tester.tap(find.byKey(const Key('customer_05_age_30_40_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_07_subscribe_newsletter_checkbox')));
        await tester.tap(find.byKey(const Key('customer_07_subscribe_newsletter_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_08_end_button')));
        await tester.tap(find.byKey(const Key('customer_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('customer_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_7', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<CustomerCubit>(create: (_)=> CustomerCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: CustomerDetailsPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.tap(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Ms.'));
        await tester.pump();
        // dataset: byKey.customer_02_firstname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_02_firstname_textfield')), 'Nattapong');
        await tester.pump();
        // dataset: byKey.customer_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_03_phone_textfield')), '0812345678');
        await tester.pump();
        // dataset: byKey.customer_04_lastname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_04_lastname_textfield')), 'Srisakul');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_05_age_30_40_radio')));
        await tester.tap(find.byKey(const Key('customer_05_age_30_40_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_08_end_button')));
        await tester.tap(find.byKey(const Key('customer_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('customer_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_8', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<CustomerCubit>(create: (_)=> CustomerCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: CustomerDetailsPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.tap(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Mrs.'));
        await tester.pump();
        // dataset: byKey.customer_02_firstname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_02_firstname_textfield')), 'Nattapong');
        await tester.pump();
        // dataset: byKey.customer_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_03_phone_textfield')), '0812345678');
        await tester.pump();
        // dataset: byKey.customer_04_lastname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_04_lastname_textfield')), 'Srisakul');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_05_age_40_50_radio')));
        await tester.tap(find.byKey(const Key('customer_05_age_40_50_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_07_subscribe_newsletter_checkbox')));
        await tester.tap(find.byKey(const Key('customer_07_subscribe_newsletter_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_08_end_button')));
        await tester.tap(find.byKey(const Key('customer_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('customer_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_9', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<CustomerCubit>(create: (_)=> CustomerCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: CustomerDetailsPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.tap(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Ms.'));
        await tester.pump();
        // dataset: byKey.customer_02_firstname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_02_firstname_textfield')), 'Nattapong');
        await tester.pump();
        // dataset: byKey.customer_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_03_phone_textfield')), '0812345678');
        await tester.pump();
        // dataset: byKey.customer_04_lastname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_04_lastname_textfield')), 'Srisakul');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_05_age_10_20_radio')));
        await tester.tap(find.byKey(const Key('customer_05_age_10_20_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_07_subscribe_newsletter_checkbox')));
        await tester.tap(find.byKey(const Key('customer_07_subscribe_newsletter_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_08_end_button')));
        await tester.tap(find.byKey(const Key('customer_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('customer_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_10', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<CustomerCubit>(create: (_)=> CustomerCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: CustomerDetailsPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.tap(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Mrs.'));
        await tester.pump();
        // dataset: byKey.customer_02_firstname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_02_firstname_textfield')), 'Nattapong');
        await tester.pump();
        // dataset: byKey.customer_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_03_phone_textfield')), '0812345678');
        await tester.pump();
        // dataset: byKey.customer_04_lastname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_04_lastname_textfield')), 'Srisakul');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_05_age_30_40_radio')));
        await tester.tap(find.byKey(const Key('customer_05_age_30_40_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_07_subscribe_newsletter_checkbox')));
        await tester.tap(find.byKey(const Key('customer_07_subscribe_newsletter_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_08_end_button')));
        await tester.tap(find.byKey(const Key('customer_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('customer_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_11', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<CustomerCubit>(create: (_)=> CustomerCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: CustomerDetailsPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.tap(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Mr.'));
        await tester.pump();
        // dataset: byKey.customer_02_firstname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_02_firstname_textfield')), 'Nattapong');
        await tester.pump();
        // dataset: byKey.customer_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_03_phone_textfield')), '0812345678');
        await tester.pump();
        // dataset: byKey.customer_04_lastname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_04_lastname_textfield')), 'Srisakul');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_05_age_10_20_radio')));
        await tester.tap(find.byKey(const Key('customer_05_age_10_20_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_07_subscribe_newsletter_checkbox')));
        await tester.tap(find.byKey(const Key('customer_07_subscribe_newsletter_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_08_end_button')));
        await tester.tap(find.byKey(const Key('customer_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('customer_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_12', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<CustomerCubit>(create: (_)=> CustomerCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: CustomerDetailsPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.tap(find.byKey(const Key('customer_01_title_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Dr.'));
        await tester.pump();
        // dataset: byKey.customer_02_firstname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_02_firstname_textfield')), 'Nattapong');
        await tester.pump();
        // dataset: byKey.customer_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_03_phone_textfield')), '0812345678');
        await tester.pump();
        // dataset: byKey.customer_04_lastname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('customer_04_lastname_textfield')), 'Srisakul');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_05_age_10_20_radio')));
        await tester.tap(find.byKey(const Key('customer_05_age_10_20_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('customer_06_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('customer_08_end_button')));
        await tester.tap(find.byKey(const Key('customer_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('customer_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

    });
    group('edge_cases', () {
      testWidgets('edge_cases_empty_all_fields', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<CustomerCubit>(create: (_)=> CustomerCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: CustomerDetailsPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('customer_08_end_button')));
        await tester.tap(find.byKey(const Key('customer_08_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Please select a title'),
          find.text('First name is required'),
          find.text('Phone number is required'),
          find.text('Last name is required'),
          find.text('Please select an age range'),
          find.text('You must agree to terms'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

    });
  });
}
