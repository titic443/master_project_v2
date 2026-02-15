// GENERATED — Integration tests for full flow
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/linkedin_cubit.dart';
import 'package:master_project/cubit/linkedin_state.dart';
import 'package:master_project/demos/linkedin_profile_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('linkedin_profile_page.dart flow (integration)', () {
    group('pairwise_valid_invalid_cases', () {
      testWidgets('pairwise_valid_invalid_cases_1', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<LinkedinCubit>(create: (_)=> LinkedinCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: LinkedinProfilePage()));
        await tester.pumpWidget(w);
        // dataset: byKey.linkedin_02_fullname_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_02_fullname_textfield')), 'S');
        await tester.pump();
        // dataset: byKey.linkedin_03_email_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_03_email_textfield')), 'somchai@invalid');
        await tester.pump();
        // dataset: byKey.linkedin_04_position_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_04_position_textfield')), 'C');
        await tester.pump();
        // dataset: byKey.linkedin_05_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_05_company_textfield')), 'T');
        await tester.pump();
        // dataset: byKey.linkedin_06_experience_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_06_experience_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.tap(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('linkedin_08_education_master_radio')));
        await tester.tap(find.byKey(const Key('linkedin_08_education_master_radio')));
        await tester.pump();
        // dataset: byKey.linkedin_09_university_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_09_university_textfield')), 'M');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_11_open_to_work_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_11_open_to_work_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_12_end_button')));
        await tester.tap(find.byKey(const Key('linkedin_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Full name must be at least 2 characters'),
          find.text('Please enter a valid email address'),
          find.text('Position must be at least 2 characters'),
          find.text('Company must be at least 2 characters'),
          find.text('University must be at least 2 characters'),
          find.text('You must agree to terms'),
          find.byKey(const Key('linkedin_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_2', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<LinkedinCubit>(create: (_)=> LinkedinCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: LinkedinProfilePage()));
        await tester.pumpWidget(w);
        // dataset: byKey.linkedin_02_fullname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_02_fullname_textfield')), 'Siriporn Chantra');
        await tester.pump();
        // dataset: byKey.linkedin_03_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_03_email_textfield')), 'somchai.p@thaicompany.co.th');
        await tester.pump();
        // dataset: byKey.linkedin_04_position_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_04_position_textfield')), 'Cloud Solutions Architect');
        await tester.pump();
        // dataset: byKey.linkedin_05_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_05_company_textfield')), 'Tech Solutions Asia');
        await tester.pump();
        // dataset: byKey.linkedin_06_experience_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_06_experience_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.tap(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('linkedin_08_education_bachelor_radio')));
        await tester.tap(find.byKey(const Key('linkedin_08_education_bachelor_radio')));
        await tester.pump();
        // dataset: byKey.linkedin_09_university_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_09_university_textfield')), 'Mahidol University');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_12_end_button')));
        await tester.tap(find.byKey(const Key('linkedin_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Years must be 0 or greater'),
          find.byKey(const Key('linkedin_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_3', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<LinkedinCubit>(create: (_)=> LinkedinCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: LinkedinProfilePage()));
        await tester.pumpWidget(w);
        // dataset: byKey.linkedin_02_fullname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_02_fullname_textfield')), 'Siriporn Chantra');
        await tester.pump();
        // dataset: byKey.linkedin_03_email_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_03_email_textfield')), 'somchai@invalid');
        await tester.pump();
        // dataset: byKey.linkedin_04_position_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_04_position_textfield')), 'C');
        await tester.pump();
        // dataset: byKey.linkedin_05_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_05_company_textfield')), 'Tech Solutions Asia');
        await tester.pump();
        // dataset: byKey.linkedin_06_experience_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_06_experience_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.tap(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('linkedin_08_education_phd_radio')));
        await tester.tap(find.byKey(const Key('linkedin_08_education_phd_radio')));
        await tester.pump();
        // dataset: byKey.linkedin_09_university_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_09_university_textfield')), 'M');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_12_end_button')));
        await tester.tap(find.byKey(const Key('linkedin_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Please enter a valid email address'),
          find.text('Position must be at least 2 characters'),
          find.text('Years must be 0 or greater'),
          find.text('University must be at least 2 characters'),
          find.text('You must agree to terms'),
          find.byKey(const Key('linkedin_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_4', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<LinkedinCubit>(create: (_)=> LinkedinCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: LinkedinProfilePage()));
        await tester.pumpWidget(w);
        // dataset: byKey.linkedin_02_fullname_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_02_fullname_textfield')), 'S');
        await tester.pump();
        // dataset: byKey.linkedin_03_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_03_email_textfield')), 'somchai.p@thaicompany.co.th');
        await tester.pump();
        // dataset: byKey.linkedin_04_position_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_04_position_textfield')), 'Cloud Solutions Architect');
        await tester.pump();
        // dataset: byKey.linkedin_05_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_05_company_textfield')), 'T');
        await tester.pump();
        // dataset: byKey.linkedin_06_experience_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_06_experience_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.tap(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('linkedin_08_education_phd_radio')));
        await tester.tap(find.byKey(const Key('linkedin_08_education_phd_radio')));
        await tester.pump();
        // dataset: byKey.linkedin_09_university_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_09_university_textfield')), 'Mahidol University');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_11_open_to_work_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_11_open_to_work_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_12_end_button')));
        await tester.tap(find.byKey(const Key('linkedin_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Full name must be at least 2 characters'),
          find.text('Company must be at least 2 characters'),
          find.byKey(const Key('linkedin_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_5', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<LinkedinCubit>(create: (_)=> LinkedinCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: LinkedinProfilePage()));
        await tester.pumpWidget(w);
        // dataset: byKey.linkedin_02_fullname_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_02_fullname_textfield')), 'S');
        await tester.pump();
        // dataset: byKey.linkedin_03_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_03_email_textfield')), 'somchai.p@thaicompany.co.th');
        await tester.pump();
        // dataset: byKey.linkedin_04_position_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_04_position_textfield')), 'Cloud Solutions Architect');
        await tester.pump();
        // dataset: byKey.linkedin_05_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_05_company_textfield')), 'Tech Solutions Asia');
        await tester.pump();
        // dataset: byKey.linkedin_06_experience_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_06_experience_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.tap(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('linkedin_08_education_phd_radio')));
        await tester.tap(find.byKey(const Key('linkedin_08_education_phd_radio')));
        await tester.pump();
        // dataset: byKey.linkedin_09_university_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_09_university_textfield')), 'M');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_12_end_button')));
        await tester.tap(find.byKey(const Key('linkedin_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Full name must be at least 2 characters'),
          find.text('University must be at least 2 characters'),
          find.text('You must agree to terms'),
          find.byKey(const Key('linkedin_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_6', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<LinkedinCubit>(create: (_)=> LinkedinCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: LinkedinProfilePage()));
        await tester.pumpWidget(w);
        // dataset: byKey.linkedin_02_fullname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_02_fullname_textfield')), 'Siriporn Chantra');
        await tester.pump();
        // dataset: byKey.linkedin_03_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_03_email_textfield')), 'somchai.p@thaicompany.co.th');
        await tester.pump();
        // dataset: byKey.linkedin_04_position_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_04_position_textfield')), 'C');
        await tester.pump();
        // dataset: byKey.linkedin_05_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_05_company_textfield')), 'T');
        await tester.pump();
        // dataset: byKey.linkedin_06_experience_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_06_experience_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.tap(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('linkedin_08_education_master_radio')));
        await tester.tap(find.byKey(const Key('linkedin_08_education_master_radio')));
        await tester.pump();
        // dataset: byKey.linkedin_09_university_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_09_university_textfield')), 'Mahidol University');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_12_end_button')));
        await tester.tap(find.byKey(const Key('linkedin_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Position must be at least 2 characters'),
          find.text('Company must be at least 2 characters'),
          find.text('Years must be 0 or greater'),
          find.byKey(const Key('linkedin_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_7', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<LinkedinCubit>(create: (_)=> LinkedinCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: LinkedinProfilePage()));
        await tester.pumpWidget(w);
        // dataset: byKey.linkedin_02_fullname_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_02_fullname_textfield')), 'S');
        await tester.pump();
        // dataset: byKey.linkedin_03_email_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_03_email_textfield')), 'somchai@invalid');
        await tester.pump();
        // dataset: byKey.linkedin_04_position_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_04_position_textfield')), 'Cloud Solutions Architect');
        await tester.pump();
        // dataset: byKey.linkedin_05_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_05_company_textfield')), 'Tech Solutions Asia');
        await tester.pump();
        // dataset: byKey.linkedin_06_experience_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_06_experience_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.tap(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('linkedin_08_education_bachelor_radio')));
        await tester.tap(find.byKey(const Key('linkedin_08_education_bachelor_radio')));
        await tester.pump();
        // dataset: byKey.linkedin_09_university_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_09_university_textfield')), 'M');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_11_open_to_work_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_11_open_to_work_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_12_end_button')));
        await tester.tap(find.byKey(const Key('linkedin_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Full name must be at least 2 characters'),
          find.text('Please enter a valid email address'),
          find.text('University must be at least 2 characters'),
          find.text('You must agree to terms'),
          find.byKey(const Key('linkedin_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_8', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<LinkedinCubit>(create: (_)=> LinkedinCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: LinkedinProfilePage()));
        await tester.pumpWidget(w);
        // dataset: byKey.linkedin_02_fullname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_02_fullname_textfield')), 'Siriporn Chantra');
        await tester.pump();
        // dataset: byKey.linkedin_03_email_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_03_email_textfield')), 'somchai@invalid');
        await tester.pump();
        // dataset: byKey.linkedin_04_position_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_04_position_textfield')), 'C');
        await tester.pump();
        // dataset: byKey.linkedin_05_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_05_company_textfield')), 'T');
        await tester.pump();
        // dataset: byKey.linkedin_06_experience_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_06_experience_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.tap(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('linkedin_08_education_phd_radio')));
        await tester.tap(find.byKey(const Key('linkedin_08_education_phd_radio')));
        await tester.pump();
        // dataset: byKey.linkedin_09_university_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_09_university_textfield')), 'Mahidol University');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_11_open_to_work_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_11_open_to_work_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_12_end_button')));
        await tester.tap(find.byKey(const Key('linkedin_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Please enter a valid email address'),
          find.text('Position must be at least 2 characters'),
          find.text('Company must be at least 2 characters'),
          find.text('Years must be 0 or greater'),
          find.text('You must agree to terms'),
          find.byKey(const Key('linkedin_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_9', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<LinkedinCubit>(create: (_)=> LinkedinCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: LinkedinProfilePage()));
        await tester.pumpWidget(w);
        // dataset: byKey.linkedin_02_fullname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_02_fullname_textfield')), 'Siriporn Chantra');
        await tester.pump();
        // dataset: byKey.linkedin_03_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_03_email_textfield')), 'somchai.p@thaicompany.co.th');
        await tester.pump();
        // dataset: byKey.linkedin_04_position_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_04_position_textfield')), 'C');
        await tester.pump();
        // dataset: byKey.linkedin_05_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_05_company_textfield')), 'T');
        await tester.pump();
        // dataset: byKey.linkedin_06_experience_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_06_experience_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.tap(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('linkedin_08_education_bachelor_radio')));
        await tester.tap(find.byKey(const Key('linkedin_08_education_bachelor_radio')));
        await tester.pump();
        // dataset: byKey.linkedin_09_university_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_09_university_textfield')), 'Mahidol University');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_11_open_to_work_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_11_open_to_work_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_12_end_button')));
        await tester.tap(find.byKey(const Key('linkedin_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Position must be at least 2 characters'),
          find.text('Company must be at least 2 characters'),
          find.byKey(const Key('linkedin_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_10', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<LinkedinCubit>(create: (_)=> LinkedinCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: LinkedinProfilePage()));
        await tester.pumpWidget(w);
        // dataset: byKey.linkedin_02_fullname_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_02_fullname_textfield')), 'S');
        await tester.pump();
        // dataset: byKey.linkedin_03_email_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_03_email_textfield')), 'somchai@invalid');
        await tester.pump();
        // dataset: byKey.linkedin_04_position_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_04_position_textfield')), 'Cloud Solutions Architect');
        await tester.pump();
        // dataset: byKey.linkedin_05_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_05_company_textfield')), 'Tech Solutions Asia');
        await tester.pump();
        // dataset: byKey.linkedin_06_experience_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_06_experience_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.tap(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('linkedin_08_education_master_radio')));
        await tester.tap(find.byKey(const Key('linkedin_08_education_master_radio')));
        await tester.pump();
        // dataset: byKey.linkedin_09_university_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_09_university_textfield')), 'M');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_12_end_button')));
        await tester.tap(find.byKey(const Key('linkedin_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Full name must be at least 2 characters'),
          find.text('Please enter a valid email address'),
          find.text('Years must be 0 or greater'),
          find.text('University must be at least 2 characters'),
          find.byKey(const Key('linkedin_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_11', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<LinkedinCubit>(create: (_)=> LinkedinCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: LinkedinProfilePage()));
        await tester.pumpWidget(w);
        // dataset: byKey.linkedin_02_fullname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_02_fullname_textfield')), 'Siriporn Chantra');
        await tester.pump();
        // dataset: byKey.linkedin_03_email_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_03_email_textfield')), 'somchai@invalid');
        await tester.pump();
        // dataset: byKey.linkedin_04_position_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_04_position_textfield')), 'C');
        await tester.pump();
        // dataset: byKey.linkedin_05_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_05_company_textfield')), 'Tech Solutions Asia');
        await tester.pump();
        // dataset: byKey.linkedin_06_experience_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_06_experience_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.tap(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('linkedin_08_education_bachelor_radio')));
        await tester.tap(find.byKey(const Key('linkedin_08_education_bachelor_radio')));
        await tester.pump();
        // dataset: byKey.linkedin_09_university_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_09_university_textfield')), 'Mahidol University');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_11_open_to_work_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_11_open_to_work_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_12_end_button')));
        await tester.tap(find.byKey(const Key('linkedin_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Please enter a valid email address'),
          find.text('Position must be at least 2 characters'),
          find.text('You must agree to terms'),
          find.byKey(const Key('linkedin_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_12', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<LinkedinCubit>(create: (_)=> LinkedinCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: LinkedinProfilePage()));
        await tester.pumpWidget(w);
        // dataset: byKey.linkedin_02_fullname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_02_fullname_textfield')), 'Siriporn Chantra');
        await tester.pump();
        // dataset: byKey.linkedin_03_email_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_03_email_textfield')), 'somchai@invalid');
        await tester.pump();
        // dataset: byKey.linkedin_04_position_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_04_position_textfield')), 'C');
        await tester.pump();
        // dataset: byKey.linkedin_05_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_05_company_textfield')), 'T');
        await tester.pump();
        // dataset: byKey.linkedin_06_experience_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_06_experience_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.tap(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('linkedin_08_education_master_radio')));
        await tester.tap(find.byKey(const Key('linkedin_08_education_master_radio')));
        await tester.pump();
        // dataset: byKey.linkedin_09_university_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_09_university_textfield')), 'Mahidol University');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_11_open_to_work_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_11_open_to_work_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_12_end_button')));
        await tester.tap(find.byKey(const Key('linkedin_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Please enter a valid email address'),
          find.text('Position must be at least 2 characters'),
          find.text('Company must be at least 2 characters'),
          find.text('Years must be 0 or greater'),
          find.byKey(const Key('linkedin_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_13', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<LinkedinCubit>(create: (_)=> LinkedinCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: LinkedinProfilePage()));
        await tester.pumpWidget(w);
        // dataset: byKey.linkedin_02_fullname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_02_fullname_textfield')), 'Siriporn Chantra');
        await tester.pump();
        // dataset: byKey.linkedin_03_email_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_03_email_textfield')), 'somchai@invalid');
        await tester.pump();
        // dataset: byKey.linkedin_04_position_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_04_position_textfield')), 'C');
        await tester.pump();
        // dataset: byKey.linkedin_05_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_05_company_textfield')), 'T');
        await tester.pump();
        // dataset: byKey.linkedin_06_experience_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_06_experience_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.tap(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('linkedin_08_education_bachelor_radio')));
        await tester.tap(find.byKey(const Key('linkedin_08_education_bachelor_radio')));
        await tester.pump();
        // dataset: byKey.linkedin_09_university_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_09_university_textfield')), 'Mahidol University');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_11_open_to_work_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_11_open_to_work_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_12_end_button')));
        await tester.tap(find.byKey(const Key('linkedin_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Please enter a valid email address'),
          find.text('Position must be at least 2 characters'),
          find.text('Company must be at least 2 characters'),
          find.text('Years must be 0 or greater'),
          find.text('You must agree to terms'),
          find.byKey(const Key('linkedin_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_14', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<LinkedinCubit>(create: (_)=> LinkedinCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: LinkedinProfilePage()));
        await tester.pumpWidget(w);
        // dataset: byKey.linkedin_02_fullname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_02_fullname_textfield')), 'Siriporn Chantra');
        await tester.pump();
        // dataset: byKey.linkedin_03_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_03_email_textfield')), 'somchai.p@thaicompany.co.th');
        await tester.pump();
        // dataset: byKey.linkedin_04_position_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_04_position_textfield')), 'Cloud Solutions Architect');
        await tester.pump();
        // dataset: byKey.linkedin_05_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_05_company_textfield')), 'Tech Solutions Asia');
        await tester.pump();
        // dataset: byKey.linkedin_06_experience_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_06_experience_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.tap(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('linkedin_08_education_bachelor_radio')));
        await tester.tap(find.byKey(const Key('linkedin_08_education_bachelor_radio')));
        await tester.pump();
        // dataset: byKey.linkedin_09_university_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('linkedin_09_university_textfield')), 'M');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_12_end_button')));
        await tester.tap(find.byKey(const Key('linkedin_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('University must be at least 2 characters'),
          find.byKey(const Key('linkedin_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

    });
    group('pairwise_valid_cases', () {
      testWidgets('pairwise_valid_cases_1', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<LinkedinCubit>(create: (_)=> LinkedinCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: LinkedinProfilePage()));
        await tester.pumpWidget(w);
        // dataset: byKey.linkedin_02_fullname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_02_fullname_textfield')), 'Siriporn Chantra');
        await tester.pump();
        // dataset: byKey.linkedin_03_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_03_email_textfield')), 'somchai.p@thaicompany.co.th');
        await tester.pump();
        // dataset: byKey.linkedin_04_position_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_04_position_textfield')), 'Cloud Solutions Architect');
        await tester.pump();
        // dataset: byKey.linkedin_05_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_05_company_textfield')), 'Tech Solutions Asia');
        await tester.pump();
        // dataset: byKey.linkedin_06_experience_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_06_experience_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.tap(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('linkedin_08_education_bachelor_radio')));
        await tester.tap(find.byKey(const Key('linkedin_08_education_bachelor_radio')));
        await tester.pump();
        // dataset: byKey.linkedin_09_university_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_09_university_textfield')), 'Mahidol University');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_11_open_to_work_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_11_open_to_work_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_12_end_button')));
        await tester.tap(find.byKey(const Key('linkedin_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('linkedin_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_2', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<LinkedinCubit>(create: (_)=> LinkedinCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: LinkedinProfilePage()));
        await tester.pumpWidget(w);
        // dataset: byKey.linkedin_02_fullname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_02_fullname_textfield')), 'Siriporn Chantra');
        await tester.pump();
        // dataset: byKey.linkedin_03_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_03_email_textfield')), 'somchai.p@thaicompany.co.th');
        await tester.pump();
        // dataset: byKey.linkedin_04_position_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_04_position_textfield')), 'Cloud Solutions Architect');
        await tester.pump();
        // dataset: byKey.linkedin_05_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_05_company_textfield')), 'Tech Solutions Asia');
        await tester.pump();
        // dataset: byKey.linkedin_06_experience_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_06_experience_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.tap(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('linkedin_08_education_phd_radio')));
        await tester.tap(find.byKey(const Key('linkedin_08_education_phd_radio')));
        await tester.pump();
        // dataset: byKey.linkedin_09_university_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_09_university_textfield')), 'Mahidol University');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_12_end_button')));
        await tester.tap(find.byKey(const Key('linkedin_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('linkedin_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_3', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<LinkedinCubit>(create: (_)=> LinkedinCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: LinkedinProfilePage()));
        await tester.pumpWidget(w);
        // dataset: byKey.linkedin_02_fullname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_02_fullname_textfield')), 'Siriporn Chantra');
        await tester.pump();
        // dataset: byKey.linkedin_03_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_03_email_textfield')), 'somchai.p@thaicompany.co.th');
        await tester.pump();
        // dataset: byKey.linkedin_04_position_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_04_position_textfield')), 'Cloud Solutions Architect');
        await tester.pump();
        // dataset: byKey.linkedin_05_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_05_company_textfield')), 'Tech Solutions Asia');
        await tester.pump();
        // dataset: byKey.linkedin_06_experience_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_06_experience_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.tap(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('linkedin_08_education_bachelor_radio')));
        await tester.tap(find.byKey(const Key('linkedin_08_education_bachelor_radio')));
        await tester.pump();
        // dataset: byKey.linkedin_09_university_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_09_university_textfield')), 'Mahidol University');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_12_end_button')));
        await tester.tap(find.byKey(const Key('linkedin_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('linkedin_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_4', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<LinkedinCubit>(create: (_)=> LinkedinCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: LinkedinProfilePage()));
        await tester.pumpWidget(w);
        // dataset: byKey.linkedin_02_fullname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_02_fullname_textfield')), 'Siriporn Chantra');
        await tester.pump();
        // dataset: byKey.linkedin_03_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_03_email_textfield')), 'somchai.p@thaicompany.co.th');
        await tester.pump();
        // dataset: byKey.linkedin_04_position_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_04_position_textfield')), 'Cloud Solutions Architect');
        await tester.pump();
        // dataset: byKey.linkedin_05_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_05_company_textfield')), 'Tech Solutions Asia');
        await tester.pump();
        // dataset: byKey.linkedin_06_experience_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_06_experience_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.tap(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('linkedin_08_education_master_radio')));
        await tester.tap(find.byKey(const Key('linkedin_08_education_master_radio')));
        await tester.pump();
        // dataset: byKey.linkedin_09_university_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_09_university_textfield')), 'Mahidol University');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_11_open_to_work_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_11_open_to_work_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_12_end_button')));
        await tester.tap(find.byKey(const Key('linkedin_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('linkedin_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_5', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<LinkedinCubit>(create: (_)=> LinkedinCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: LinkedinProfilePage()));
        await tester.pumpWidget(w);
        // dataset: byKey.linkedin_02_fullname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_02_fullname_textfield')), 'Siriporn Chantra');
        await tester.pump();
        // dataset: byKey.linkedin_03_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_03_email_textfield')), 'somchai.p@thaicompany.co.th');
        await tester.pump();
        // dataset: byKey.linkedin_04_position_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_04_position_textfield')), 'Cloud Solutions Architect');
        await tester.pump();
        // dataset: byKey.linkedin_05_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_05_company_textfield')), 'Tech Solutions Asia');
        await tester.pump();
        // dataset: byKey.linkedin_06_experience_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_06_experience_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.tap(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('linkedin_08_education_master_radio')));
        await tester.tap(find.byKey(const Key('linkedin_08_education_master_radio')));
        await tester.pump();
        // dataset: byKey.linkedin_09_university_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_09_university_textfield')), 'Mahidol University');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_11_open_to_work_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_11_open_to_work_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_12_end_button')));
        await tester.tap(find.byKey(const Key('linkedin_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('linkedin_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_6', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<LinkedinCubit>(create: (_)=> LinkedinCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: LinkedinProfilePage()));
        await tester.pumpWidget(w);
        // dataset: byKey.linkedin_02_fullname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_02_fullname_textfield')), 'Siriporn Chantra');
        await tester.pump();
        // dataset: byKey.linkedin_03_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_03_email_textfield')), 'somchai.p@thaicompany.co.th');
        await tester.pump();
        // dataset: byKey.linkedin_04_position_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_04_position_textfield')), 'Cloud Solutions Architect');
        await tester.pump();
        // dataset: byKey.linkedin_05_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_05_company_textfield')), 'Tech Solutions Asia');
        await tester.pump();
        // dataset: byKey.linkedin_06_experience_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_06_experience_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.tap(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('linkedin_08_education_master_radio')));
        await tester.tap(find.byKey(const Key('linkedin_08_education_master_radio')));
        await tester.pump();
        // dataset: byKey.linkedin_09_university_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_09_university_textfield')), 'Mahidol University');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_11_open_to_work_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_11_open_to_work_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_12_end_button')));
        await tester.tap(find.byKey(const Key('linkedin_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('linkedin_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_7', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<LinkedinCubit>(create: (_)=> LinkedinCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: LinkedinProfilePage()));
        await tester.pumpWidget(w);
        // dataset: byKey.linkedin_02_fullname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_02_fullname_textfield')), 'Siriporn Chantra');
        await tester.pump();
        // dataset: byKey.linkedin_03_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_03_email_textfield')), 'somchai.p@thaicompany.co.th');
        await tester.pump();
        // dataset: byKey.linkedin_04_position_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_04_position_textfield')), 'Cloud Solutions Architect');
        await tester.pump();
        // dataset: byKey.linkedin_05_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_05_company_textfield')), 'Tech Solutions Asia');
        await tester.pump();
        // dataset: byKey.linkedin_06_experience_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_06_experience_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.tap(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('linkedin_08_education_phd_radio')));
        await tester.tap(find.byKey(const Key('linkedin_08_education_phd_radio')));
        await tester.pump();
        // dataset: byKey.linkedin_09_university_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_09_university_textfield')), 'Mahidol University');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_11_open_to_work_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_11_open_to_work_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_12_end_button')));
        await tester.tap(find.byKey(const Key('linkedin_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('linkedin_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_8', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<LinkedinCubit>(create: (_)=> LinkedinCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: LinkedinProfilePage()));
        await tester.pumpWidget(w);
        // dataset: byKey.linkedin_02_fullname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_02_fullname_textfield')), 'Siriporn Chantra');
        await tester.pump();
        // dataset: byKey.linkedin_03_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_03_email_textfield')), 'somchai.p@thaicompany.co.th');
        await tester.pump();
        // dataset: byKey.linkedin_04_position_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_04_position_textfield')), 'Cloud Solutions Architect');
        await tester.pump();
        // dataset: byKey.linkedin_05_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_05_company_textfield')), 'Tech Solutions Asia');
        await tester.pump();
        // dataset: byKey.linkedin_06_experience_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_06_experience_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.tap(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('linkedin_08_education_bachelor_radio')));
        await tester.tap(find.byKey(const Key('linkedin_08_education_bachelor_radio')));
        await tester.pump();
        // dataset: byKey.linkedin_09_university_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_09_university_textfield')), 'Mahidol University');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_12_end_button')));
        await tester.tap(find.byKey(const Key('linkedin_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('linkedin_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_9', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<LinkedinCubit>(create: (_)=> LinkedinCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: LinkedinProfilePage()));
        await tester.pumpWidget(w);
        // dataset: byKey.linkedin_02_fullname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_02_fullname_textfield')), 'Siriporn Chantra');
        await tester.pump();
        // dataset: byKey.linkedin_03_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_03_email_textfield')), 'somchai.p@thaicompany.co.th');
        await tester.pump();
        // dataset: byKey.linkedin_04_position_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_04_position_textfield')), 'Cloud Solutions Architect');
        await tester.pump();
        // dataset: byKey.linkedin_05_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_05_company_textfield')), 'Tech Solutions Asia');
        await tester.pump();
        // dataset: byKey.linkedin_06_experience_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_06_experience_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.tap(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('linkedin_08_education_master_radio')));
        await tester.tap(find.byKey(const Key('linkedin_08_education_master_radio')));
        await tester.pump();
        // dataset: byKey.linkedin_09_university_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_09_university_textfield')), 'Mahidol University');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_12_end_button')));
        await tester.tap(find.byKey(const Key('linkedin_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('linkedin_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_10', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<LinkedinCubit>(create: (_)=> LinkedinCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: LinkedinProfilePage()));
        await tester.pumpWidget(w);
        // dataset: byKey.linkedin_02_fullname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_02_fullname_textfield')), 'Siriporn Chantra');
        await tester.pump();
        // dataset: byKey.linkedin_03_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_03_email_textfield')), 'somchai.p@thaicompany.co.th');
        await tester.pump();
        // dataset: byKey.linkedin_04_position_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_04_position_textfield')), 'Cloud Solutions Architect');
        await tester.pump();
        // dataset: byKey.linkedin_05_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_05_company_textfield')), 'Tech Solutions Asia');
        await tester.pump();
        // dataset: byKey.linkedin_06_experience_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_06_experience_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.tap(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('linkedin_08_education_phd_radio')));
        await tester.tap(find.byKey(const Key('linkedin_08_education_phd_radio')));
        await tester.pump();
        // dataset: byKey.linkedin_09_university_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_09_university_textfield')), 'Mahidol University');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_11_open_to_work_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_11_open_to_work_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_12_end_button')));
        await tester.tap(find.byKey(const Key('linkedin_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('linkedin_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_11', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<LinkedinCubit>(create: (_)=> LinkedinCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: LinkedinProfilePage()));
        await tester.pumpWidget(w);
        // dataset: byKey.linkedin_02_fullname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_02_fullname_textfield')), 'Siriporn Chantra');
        await tester.pump();
        // dataset: byKey.linkedin_03_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_03_email_textfield')), 'somchai.p@thaicompany.co.th');
        await tester.pump();
        // dataset: byKey.linkedin_04_position_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_04_position_textfield')), 'Cloud Solutions Architect');
        await tester.pump();
        // dataset: byKey.linkedin_05_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_05_company_textfield')), 'Tech Solutions Asia');
        await tester.pump();
        // dataset: byKey.linkedin_06_experience_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_06_experience_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.tap(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('linkedin_08_education_phd_radio')));
        await tester.tap(find.byKey(const Key('linkedin_08_education_phd_radio')));
        await tester.pump();
        // dataset: byKey.linkedin_09_university_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_09_university_textfield')), 'Mahidol University');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_12_end_button')));
        await tester.tap(find.byKey(const Key('linkedin_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('linkedin_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_12', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<LinkedinCubit>(create: (_)=> LinkedinCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: LinkedinProfilePage()));
        await tester.pumpWidget(w);
        // dataset: byKey.linkedin_02_fullname_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_02_fullname_textfield')), 'Siriporn Chantra');
        await tester.pump();
        // dataset: byKey.linkedin_03_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_03_email_textfield')), 'somchai.p@thaicompany.co.th');
        await tester.pump();
        // dataset: byKey.linkedin_04_position_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_04_position_textfield')), 'Cloud Solutions Architect');
        await tester.pump();
        // dataset: byKey.linkedin_05_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_05_company_textfield')), 'Tech Solutions Asia');
        await tester.pump();
        // dataset: byKey.linkedin_06_experience_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_06_experience_textfield')), '10');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.tap(find.byKey(const Key('linkedin_07_employment_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('linkedin_08_education_bachelor_radio')));
        await tester.tap(find.byKey(const Key('linkedin_08_education_bachelor_radio')));
        await tester.pump();
        // dataset: byKey.linkedin_09_university_textfield[0].valid
        await tester.enterText(find.byKey(const Key('linkedin_09_university_textfield')), 'Mahidol University');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_10_agree_terms_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_11_open_to_work_checkbox')));
        await tester.tap(find.byKey(const Key('linkedin_11_open_to_work_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('linkedin_12_end_button')));
        await tester.tap(find.byKey(const Key('linkedin_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('linkedin_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

    });
    group('edge_cases', () {
      testWidgets('edge_cases_empty_all_fields', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<LinkedinCubit>(create: (_)=> LinkedinCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: LinkedinProfilePage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('linkedin_12_end_button')));
        await tester.tap(find.byKey(const Key('linkedin_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Full name is required'),
          find.text('Email is required'),
          find.text('Position is required'),
          find.text('Company is required'),
          find.text('Years of experience is required'),
          find.text('Please select an employment type'),
          find.text('Please select an education level'),
          find.text('University is required'),
          find.text('You must agree to terms'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

    });
  });
}
