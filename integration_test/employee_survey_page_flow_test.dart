// GENERATED — Integration tests for full flow
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/employee_cubit.dart';
import 'package:master_project/cubit/employee_state.dart';
import 'package:master_project/demos/employee_survey_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('employee_survey_page.dart flow (integration)', () {
    group('pairwise_valid_invalid_cases', () {
      testWidgets('pairwise_valid_invalid_cases_1', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<EmployeeCubit>(create: (_)=> EmployeeCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: EmployeeSurveyPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.employee_02_id_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('employee_02_id_textfield')), 'EMP-ABCDE');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.tap(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Marketing'));
        await tester.pump();
        // dataset: byKey.employee_04_email_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('employee_04_email_textfield')), 'invalid-email');
        await tester.pump();
        // dataset: byKey.employee_05_years_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_05_years_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_06_rating_fair_radio')));
        await tester.tap(find.byKey(const Key('employee_06_rating_fair_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_08_training_checkbox')));
        await tester.tap(find.byKey(const Key('employee_08_training_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_09_end_button')));
        await tester.tap(find.byKey(const Key('employee_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Employee ID must match format: EMP-12345'),
          find.text('Please enter a valid email address'),
          find.byKey(const Key('employee_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_2', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<EmployeeCubit>(create: (_)=> EmployeeCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: EmployeeSurveyPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.employee_02_id_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_02_id_textfield')), 'EMP-12345');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.tap(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Engineering'));
        await tester.pump();
        // dataset: byKey.employee_04_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_04_email_textfield')), 'test.user@example.com');
        await tester.pump();
        // dataset: byKey.employee_05_years_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('employee_05_years_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_06_rating_excellent_radio')));
        await tester.tap(find.byKey(const Key('employee_06_rating_excellent_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.tap(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_09_end_button')));
        await tester.tap(find.byKey(const Key('employee_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Years must be 0 or greater'),
          find.byKey(const Key('employee_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_3', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<EmployeeCubit>(create: (_)=> EmployeeCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: EmployeeSurveyPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.employee_02_id_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('employee_02_id_textfield')), 'EMP-ABCDE');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.tap(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.pump();
        await tester.tap(find.text('HR'));
        await tester.pump();
        // dataset: byKey.employee_04_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_04_email_textfield')), 'test.user@example.com');
        await tester.pump();
        // dataset: byKey.employee_05_years_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_05_years_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_06_rating_excellent_radio')));
        await tester.tap(find.byKey(const Key('employee_06_rating_excellent_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_07_recommend_checkbox')));
        await tester.tap(find.byKey(const Key('employee_07_recommend_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.tap(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_08_training_checkbox')));
        await tester.tap(find.byKey(const Key('employee_08_training_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_09_end_button')));
        await tester.tap(find.byKey(const Key('employee_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Employee ID must match format: EMP-12345'),
          find.byKey(const Key('employee_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_4', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<EmployeeCubit>(create: (_)=> EmployeeCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: EmployeeSurveyPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.employee_02_id_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_02_id_textfield')), 'EMP-12345');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.tap(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Sales'));
        await tester.pump();
        // dataset: byKey.employee_04_email_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('employee_04_email_textfield')), 'invalid-email');
        await tester.pump();
        // dataset: byKey.employee_05_years_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('employee_05_years_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_06_rating_excellent_radio')));
        await tester.tap(find.byKey(const Key('employee_06_rating_excellent_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_07_recommend_checkbox')));
        await tester.tap(find.byKey(const Key('employee_07_recommend_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_09_end_button')));
        await tester.tap(find.byKey(const Key('employee_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Please enter a valid email address'),
          find.text('Years must be 0 or greater'),
          find.byKey(const Key('employee_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_5', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<EmployeeCubit>(create: (_)=> EmployeeCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: EmployeeSurveyPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.employee_02_id_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('employee_02_id_textfield')), 'EMP-ABCDE');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.tap(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Marketing'));
        await tester.pump();
        // dataset: byKey.employee_04_email_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('employee_04_email_textfield')), 'invalid-email');
        await tester.pump();
        // dataset: byKey.employee_05_years_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('employee_05_years_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_06_rating_poor_radio')));
        await tester.tap(find.byKey(const Key('employee_06_rating_poor_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_07_recommend_checkbox')));
        await tester.tap(find.byKey(const Key('employee_07_recommend_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.tap(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_09_end_button')));
        await tester.tap(find.byKey(const Key('employee_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Employee ID must match format: EMP-12345'),
          find.text('Please enter a valid email address'),
          find.text('Years must be 0 or greater'),
          find.byKey(const Key('employee_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_6', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<EmployeeCubit>(create: (_)=> EmployeeCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: EmployeeSurveyPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.employee_02_id_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_02_id_textfield')), 'EMP-12345');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.tap(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.pump();
        await tester.tap(find.text('HR'));
        await tester.pump();
        // dataset: byKey.employee_04_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_04_email_textfield')), 'test.user@example.com');
        await tester.pump();
        // dataset: byKey.employee_05_years_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('employee_05_years_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_06_rating_fair_radio')));
        await tester.tap(find.byKey(const Key('employee_06_rating_fair_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_07_recommend_checkbox')));
        await tester.tap(find.byKey(const Key('employee_07_recommend_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_09_end_button')));
        await tester.tap(find.byKey(const Key('employee_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Years must be 0 or greater'),
          find.byKey(const Key('employee_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_7', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<EmployeeCubit>(create: (_)=> EmployeeCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: EmployeeSurveyPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.employee_02_id_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_02_id_textfield')), 'EMP-12345');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.tap(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.pump();
        await tester.tap(find.text('HR'));
        await tester.pump();
        // dataset: byKey.employee_04_email_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('employee_04_email_textfield')), 'invalid-email');
        await tester.pump();
        // dataset: byKey.employee_05_years_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_05_years_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_06_rating_poor_radio')));
        await tester.tap(find.byKey(const Key('employee_06_rating_poor_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_08_training_checkbox')));
        await tester.tap(find.byKey(const Key('employee_08_training_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_09_end_button')));
        await tester.tap(find.byKey(const Key('employee_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Please enter a valid email address'),
          find.byKey(const Key('employee_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_8', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<EmployeeCubit>(create: (_)=> EmployeeCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: EmployeeSurveyPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.employee_02_id_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('employee_02_id_textfield')), 'EMP-ABCDE');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.tap(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Engineering'));
        await tester.pump();
        // dataset: byKey.employee_04_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_04_email_textfield')), 'test.user@example.com');
        await tester.pump();
        // dataset: byKey.employee_05_years_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('employee_05_years_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_06_rating_poor_radio')));
        await tester.tap(find.byKey(const Key('employee_06_rating_poor_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_07_recommend_checkbox')));
        await tester.tap(find.byKey(const Key('employee_07_recommend_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_08_training_checkbox')));
        await tester.tap(find.byKey(const Key('employee_08_training_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_09_end_button')));
        await tester.tap(find.byKey(const Key('employee_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Employee ID must match format: EMP-12345'),
          find.text('Years must be 0 or greater'),
          find.byKey(const Key('employee_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_9', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<EmployeeCubit>(create: (_)=> EmployeeCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: EmployeeSurveyPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.employee_02_id_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_02_id_textfield')), 'EMP-12345');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.tap(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Marketing'));
        await tester.pump();
        // dataset: byKey.employee_04_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_04_email_textfield')), 'test.user@example.com');
        await tester.pump();
        // dataset: byKey.employee_05_years_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_05_years_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_06_rating_excellent_radio')));
        await tester.tap(find.byKey(const Key('employee_06_rating_excellent_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.tap(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_09_end_button')));
        await tester.tap(find.byKey(const Key('employee_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('employee_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_10', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<EmployeeCubit>(create: (_)=> EmployeeCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: EmployeeSurveyPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.employee_02_id_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('employee_02_id_textfield')), 'EMP-ABCDE');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.tap(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Sales'));
        await tester.pump();
        // dataset: byKey.employee_04_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_04_email_textfield')), 'test.user@example.com');
        await tester.pump();
        // dataset: byKey.employee_05_years_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_05_years_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_06_rating_poor_radio')));
        await tester.tap(find.byKey(const Key('employee_06_rating_poor_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.tap(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_08_training_checkbox')));
        await tester.tap(find.byKey(const Key('employee_08_training_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_09_end_button')));
        await tester.tap(find.byKey(const Key('employee_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Employee ID must match format: EMP-12345'),
          find.byKey(const Key('employee_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_11', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<EmployeeCubit>(create: (_)=> EmployeeCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: EmployeeSurveyPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.employee_02_id_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_02_id_textfield')), 'EMP-12345');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.tap(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Sales'));
        await tester.pump();
        // dataset: byKey.employee_04_email_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('employee_04_email_textfield')), 'invalid-email');
        await tester.pump();
        // dataset: byKey.employee_05_years_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('employee_05_years_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_06_rating_fair_radio')));
        await tester.tap(find.byKey(const Key('employee_06_rating_fair_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.tap(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_08_training_checkbox')));
        await tester.tap(find.byKey(const Key('employee_08_training_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_09_end_button')));
        await tester.tap(find.byKey(const Key('employee_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Please enter a valid email address'),
          find.text('Years must be 0 or greater'),
          find.byKey(const Key('employee_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_12', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<EmployeeCubit>(create: (_)=> EmployeeCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: EmployeeSurveyPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.employee_02_id_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_02_id_textfield')), 'EMP-12345');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.tap(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Engineering'));
        await tester.pump();
        // dataset: byKey.employee_04_email_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('employee_04_email_textfield')), 'invalid-email');
        await tester.pump();
        // dataset: byKey.employee_05_years_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_05_years_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_06_rating_fair_radio')));
        await tester.tap(find.byKey(const Key('employee_06_rating_fair_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_07_recommend_checkbox')));
        await tester.tap(find.byKey(const Key('employee_07_recommend_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.tap(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_08_training_checkbox')));
        await tester.tap(find.byKey(const Key('employee_08_training_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_09_end_button')));
        await tester.tap(find.byKey(const Key('employee_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Please enter a valid email address'),
          find.byKey(const Key('employee_01_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

    });
    group('pairwise_valid_cases', () {
      testWidgets('pairwise_valid_cases_1', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<EmployeeCubit>(create: (_)=> EmployeeCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: EmployeeSurveyPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.employee_02_id_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_02_id_textfield')), 'EMP-12345');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.tap(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Marketing'));
        await tester.pump();
        // dataset: byKey.employee_04_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_04_email_textfield')), 'test.user@example.com');
        await tester.pump();
        // dataset: byKey.employee_05_years_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_05_years_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_06_rating_excellent_radio')));
        await tester.tap(find.byKey(const Key('employee_06_rating_excellent_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_07_recommend_checkbox')));
        await tester.tap(find.byKey(const Key('employee_07_recommend_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.tap(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_09_end_button')));
        await tester.tap(find.byKey(const Key('employee_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('employee_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_2', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<EmployeeCubit>(create: (_)=> EmployeeCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: EmployeeSurveyPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.employee_02_id_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_02_id_textfield')), 'EMP-12345');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.tap(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Engineering'));
        await tester.pump();
        // dataset: byKey.employee_04_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_04_email_textfield')), 'test.user@example.com');
        await tester.pump();
        // dataset: byKey.employee_05_years_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_05_years_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_06_rating_poor_radio')));
        await tester.tap(find.byKey(const Key('employee_06_rating_poor_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.tap(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_08_training_checkbox')));
        await tester.tap(find.byKey(const Key('employee_08_training_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_09_end_button')));
        await tester.tap(find.byKey(const Key('employee_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('employee_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_3', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<EmployeeCubit>(create: (_)=> EmployeeCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: EmployeeSurveyPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.employee_02_id_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_02_id_textfield')), 'EMP-12345');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.tap(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Sales'));
        await tester.pump();
        // dataset: byKey.employee_04_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_04_email_textfield')), 'test.user@example.com');
        await tester.pump();
        // dataset: byKey.employee_05_years_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_05_years_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_06_rating_excellent_radio')));
        await tester.tap(find.byKey(const Key('employee_06_rating_excellent_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.tap(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_08_training_checkbox')));
        await tester.tap(find.byKey(const Key('employee_08_training_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_09_end_button')));
        await tester.tap(find.byKey(const Key('employee_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('employee_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_4', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<EmployeeCubit>(create: (_)=> EmployeeCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: EmployeeSurveyPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.employee_02_id_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_02_id_textfield')), 'EMP-12345');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.tap(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Engineering'));
        await tester.pump();
        // dataset: byKey.employee_04_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_04_email_textfield')), 'test.user@example.com');
        await tester.pump();
        // dataset: byKey.employee_05_years_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_05_years_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_06_rating_fair_radio')));
        await tester.tap(find.byKey(const Key('employee_06_rating_fair_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.tap(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_09_end_button')));
        await tester.tap(find.byKey(const Key('employee_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('employee_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_5', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<EmployeeCubit>(create: (_)=> EmployeeCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: EmployeeSurveyPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.employee_02_id_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_02_id_textfield')), 'EMP-12345');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.tap(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Engineering'));
        await tester.pump();
        // dataset: byKey.employee_04_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_04_email_textfield')), 'test.user@example.com');
        await tester.pump();
        // dataset: byKey.employee_05_years_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_05_years_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_06_rating_excellent_radio')));
        await tester.tap(find.byKey(const Key('employee_06_rating_excellent_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_07_recommend_checkbox')));
        await tester.tap(find.byKey(const Key('employee_07_recommend_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.tap(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_08_training_checkbox')));
        await tester.tap(find.byKey(const Key('employee_08_training_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_09_end_button')));
        await tester.tap(find.byKey(const Key('employee_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('employee_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_6', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<EmployeeCubit>(create: (_)=> EmployeeCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: EmployeeSurveyPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.employee_02_id_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_02_id_textfield')), 'EMP-12345');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.tap(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Marketing'));
        await tester.pump();
        // dataset: byKey.employee_04_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_04_email_textfield')), 'test.user@example.com');
        await tester.pump();
        // dataset: byKey.employee_05_years_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_05_years_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_06_rating_poor_radio')));
        await tester.tap(find.byKey(const Key('employee_06_rating_poor_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_07_recommend_checkbox')));
        await tester.tap(find.byKey(const Key('employee_07_recommend_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.tap(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_09_end_button')));
        await tester.tap(find.byKey(const Key('employee_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('employee_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_7', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<EmployeeCubit>(create: (_)=> EmployeeCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: EmployeeSurveyPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.employee_02_id_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_02_id_textfield')), 'EMP-12345');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.tap(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.pump();
        await tester.tap(find.text('HR'));
        await tester.pump();
        // dataset: byKey.employee_04_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_04_email_textfield')), 'test.user@example.com');
        await tester.pump();
        // dataset: byKey.employee_05_years_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_05_years_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_06_rating_excellent_radio')));
        await tester.tap(find.byKey(const Key('employee_06_rating_excellent_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_07_recommend_checkbox')));
        await tester.tap(find.byKey(const Key('employee_07_recommend_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.tap(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_09_end_button')));
        await tester.tap(find.byKey(const Key('employee_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('employee_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_8', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<EmployeeCubit>(create: (_)=> EmployeeCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: EmployeeSurveyPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.employee_02_id_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_02_id_textfield')), 'EMP-12345');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.tap(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Marketing'));
        await tester.pump();
        // dataset: byKey.employee_04_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_04_email_textfield')), 'test.user@example.com');
        await tester.pump();
        // dataset: byKey.employee_05_years_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_05_years_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_06_rating_fair_radio')));
        await tester.tap(find.byKey(const Key('employee_06_rating_fair_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.tap(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_08_training_checkbox')));
        await tester.tap(find.byKey(const Key('employee_08_training_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_09_end_button')));
        await tester.tap(find.byKey(const Key('employee_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('employee_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_9', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<EmployeeCubit>(create: (_)=> EmployeeCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: EmployeeSurveyPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.employee_02_id_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_02_id_textfield')), 'EMP-12345');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.tap(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Sales'));
        await tester.pump();
        // dataset: byKey.employee_04_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_04_email_textfield')), 'test.user@example.com');
        await tester.pump();
        // dataset: byKey.employee_05_years_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_05_years_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_06_rating_poor_radio')));
        await tester.tap(find.byKey(const Key('employee_06_rating_poor_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_07_recommend_checkbox')));
        await tester.tap(find.byKey(const Key('employee_07_recommend_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.tap(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_09_end_button')));
        await tester.tap(find.byKey(const Key('employee_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('employee_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_10', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<EmployeeCubit>(create: (_)=> EmployeeCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: EmployeeSurveyPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.employee_02_id_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_02_id_textfield')), 'EMP-12345');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.tap(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.pump();
        await tester.tap(find.text('HR'));
        await tester.pump();
        // dataset: byKey.employee_04_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_04_email_textfield')), 'test.user@example.com');
        await tester.pump();
        // dataset: byKey.employee_05_years_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_05_years_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_06_rating_fair_radio')));
        await tester.tap(find.byKey(const Key('employee_06_rating_fair_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.tap(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_08_training_checkbox')));
        await tester.tap(find.byKey(const Key('employee_08_training_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_09_end_button')));
        await tester.tap(find.byKey(const Key('employee_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('employee_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_11', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<EmployeeCubit>(create: (_)=> EmployeeCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: EmployeeSurveyPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.employee_02_id_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_02_id_textfield')), 'EMP-12345');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.tap(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.pump();
        await tester.tap(find.text('HR'));
        await tester.pump();
        // dataset: byKey.employee_04_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_04_email_textfield')), 'test.user@example.com');
        await tester.pump();
        // dataset: byKey.employee_05_years_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_05_years_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_06_rating_poor_radio')));
        await tester.tap(find.byKey(const Key('employee_06_rating_poor_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_07_recommend_checkbox')));
        await tester.tap(find.byKey(const Key('employee_07_recommend_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.tap(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_09_end_button')));
        await tester.tap(find.byKey(const Key('employee_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('employee_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_12', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<EmployeeCubit>(create: (_)=> EmployeeCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: EmployeeSurveyPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.employee_02_id_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_02_id_textfield')), 'EMP-12345');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.tap(find.byKey(const Key('employee_03_department_dropdown')));
        await tester.pump();
        await tester.tap(find.text('Sales'));
        await tester.pump();
        // dataset: byKey.employee_04_email_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_04_email_textfield')), 'test.user@example.com');
        await tester.pump();
        // dataset: byKey.employee_05_years_textfield[0].valid
        await tester.enterText(find.byKey(const Key('employee_05_years_textfield')), '0');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_06_rating_fair_radio')));
        await tester.tap(find.byKey(const Key('employee_06_rating_fair_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_07_recommend_checkbox')));
        await tester.tap(find.byKey(const Key('employee_07_recommend_checkbox')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.tap(find.byKey(const Key('employee_07_recommend_formfield')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('employee_09_end_button')));
        await tester.tap(find.byKey(const Key('employee_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('employee_01_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

    });
    group('edge_cases', () {
      testWidgets('edge_cases_empty_all_fields', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<EmployeeCubit>(create: (_)=> EmployeeCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: EmployeeSurveyPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('employee_09_end_button')));
        await tester.tap(find.byKey(const Key('employee_09_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Employee ID is required'),
          find.text('Please select a department'),
          find.text('Email is required'),
          find.text('Years of service is required'),
          find.text('Please select a satisfaction rating'),
          find.text('You must recommend the company to proceed'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

    });
  });
}
