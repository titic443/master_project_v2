// GENERATED — Integration tests for full flow
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/job_post_cubit.dart';
import 'package:master_project/demos/job_post_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('job_post_page.dart flow (integration)', () {
    group('pairwise_valid_invalid_cases', () {
      testWidgets('pairwise_valid_invalid_cases_1', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Sr');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
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
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'S');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
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

      testWidgets('pairwise_valid_invalid_cases_2', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'T');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'B');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Education').last);
        await tester.tap(find.text('Education').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Full-time').last);
        await tester.tap(find.text('Full-time').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Mid-Level').last);
        await tester.tap(find.text('Mid-Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'Job desc too short.');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 2 characters'),
          find.text('At least 2 characters'),
          find.text('At least 20 characters'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_3', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'B');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Healthcare').last);
        await tester.tap(find.text('Healthcare').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Freelance').last);
        await tester.tap(find.text('Freelance').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Junior').last);
        await tester.tap(find.text('Junior').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '1');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'Job desc too short.');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'S');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 2 characters'),
          find.text('At least 20 characters'),
          find.text('At least 2 characters'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_4', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Sr');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'T');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
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
        await tester.ensureVisible(find.text('Full-time').last);
        await tester.tap(find.text('Full-time').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Entry_Level').last);
        await tester.tap(find.text('Entry_Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 3 characters'),
          find.text('At least 2 characters'),
          find.text('Must be ≥ min'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_5', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Sr');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'T');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'B');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Education').last);
        await tester.tap(find.text('Education').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Contract').last);
        await tester.tap(find.text('Contract').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Junior').last);
        await tester.tap(find.text('Junior').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'S');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 3 characters'),
          find.text('At least 2 characters'),
          find.text('At least 2 characters'),
          find.text('Must be ≥ min'),
          find.text('At least 2 characters'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_6', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Engineering').last);
        await tester.tap(find.text('Engineering').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Contract').last);
        await tester.tap(find.text('Contract').last);
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
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'Job desc too short.');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 20 characters'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_7', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'T');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'B');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Engineering').last);
        await tester.tap(find.text('Engineering').last);
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
        await tester.ensureVisible(find.text('Entry_Level').last);
        await tester.tap(find.text('Entry_Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'S');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 2 characters'),
          find.text('At least 2 characters'),
          find.text('At least 2 characters'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_8', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
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
        await tester.ensureVisible(find.text('Internship').last);
        await tester.tap(find.text('Internship').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Mid-Level').last);
        await tester.tap(find.text('Mid-Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '1');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'Job desc too short.');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Must be ≥ min'),
          find.text('At least 20 characters'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_9', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Sr');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'B');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('IT_&_Tech').last);
        await tester.tap(find.text('IT_&_Tech').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Full-time').last);
        await tester.tap(find.text('Full-time').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Entry_Level').last);
        await tester.tap(find.text('Entry_Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '1');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'Job desc too short.');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'S');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 3 characters'),
          find.text('At least 2 characters'),
          find.text('At least 20 characters'),
          find.text('At least 2 characters'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_10', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'T');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('IT_&_Tech').last);
        await tester.tap(find.text('IT_&_Tech').last);
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
        await tester.ensureVisible(find.text('Junior').last);
        await tester.tap(find.text('Junior').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 2 characters'),
          find.text('Must be ≥ min'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_11', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Sr');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'B');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Marketing').last);
        await tester.tap(find.text('Marketing').last);
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
        await tester.ensureVisible(find.text('Mid-Level').last);
        await tester.tap(find.text('Mid-Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'Job desc too short.');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'S');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 3 characters'),
          find.text('At least 2 characters'),
          find.text('At least 20 characters'),
          find.text('At least 2 characters'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_12', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Sr');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'T');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Engineering').last);
        await tester.tap(find.text('Engineering').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Freelance').last);
        await tester.tap(find.text('Freelance').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Mid-Level').last);
        await tester.tap(find.text('Mid-Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 3 characters'),
          find.text('At least 2 characters'),
          find.text('Must be ≥ min'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_13', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Sr');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'T');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Education').last);
        await tester.tap(find.text('Education').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Freelance').last);
        await tester.tap(find.text('Freelance').last);
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
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 3 characters'),
          find.text('At least 2 characters'),
          find.text('Must be ≥ min'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_14', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Sr');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'T');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'B');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Engineering').last);
        await tester.tap(find.text('Engineering').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Internship').last);
        await tester.tap(find.text('Internship').last);
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
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'S');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 3 characters'),
          find.text('At least 2 characters'),
          find.text('At least 2 characters'),
          find.text('At least 2 characters'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_15', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'T');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'B');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('IT_&_Tech').last);
        await tester.tap(find.text('IT_&_Tech').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Freelance').last);
        await tester.tap(find.text('Freelance').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Entry_Level').last);
        await tester.tap(find.text('Entry_Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 2 characters'),
          find.text('At least 2 characters'),
          find.text('Must be ≥ min'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_16', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Sr');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'B');
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
        await tester.ensureVisible(find.text('Contract').last);
        await tester.tap(find.text('Contract').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Mid-Level').last);
        await tester.tap(find.text('Mid-Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'Job desc too short.');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'S');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 3 characters'),
          find.text('At least 2 characters'),
          find.text('At least 20 characters'),
          find.text('At least 2 characters'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_17', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Sr');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'T');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Healthcare').last);
        await tester.tap(find.text('Healthcare').last);
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
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 3 characters'),
          find.text('At least 2 characters'),
          find.text('Must be ≥ min'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_18', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'T');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Marketing').last);
        await tester.tap(find.text('Marketing').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Freelance').last);
        await tester.tap(find.text('Freelance').last);
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
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 2 characters'),
          find.text('Must be ≥ min'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_19', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Marketing').last);
        await tester.tap(find.text('Marketing').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Full-time').last);
        await tester.tap(find.text('Full-time').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Junior').last);
        await tester.tap(find.text('Junior').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '1');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'Job desc too short.');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 20 characters'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_20', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Sr');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Marketing').last);
        await tester.tap(find.text('Marketing').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Internship').last);
        await tester.tap(find.text('Internship').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Entry_Level').last);
        await tester.tap(find.text('Entry_Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '1');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'Job desc too short.');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'S');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 3 characters'),
          find.text('At least 20 characters'),
          find.text('At least 2 characters'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_21', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'T');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('IT_&_Tech').last);
        await tester.tap(find.text('IT_&_Tech').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Contract').last);
        await tester.tap(find.text('Contract').last);
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
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 2 characters'),
          find.text('Must be ≥ min'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_22', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Sr');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'T');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
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
        await tester.ensureVisible(find.text('Freelance').last);
        await tester.tap(find.text('Freelance').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Junior').last);
        await tester.tap(find.text('Junior').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'Job desc too short.');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'S');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 3 characters'),
          find.text('At least 2 characters'),
          find.text('Must be ≥ min'),
          find.text('At least 20 characters'),
          find.text('At least 2 characters'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_23', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Sr');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Marketing').last);
        await tester.tap(find.text('Marketing').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Contract').last);
        await tester.tap(find.text('Contract').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Entry_Level').last);
        await tester.tap(find.text('Entry_Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 3 characters'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_24', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Sr');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'T');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Healthcare').last);
        await tester.tap(find.text('Healthcare').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Contract').last);
        await tester.tap(find.text('Contract').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Entry_Level').last);
        await tester.tap(find.text('Entry_Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'S');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 3 characters'),
          find.text('At least 2 characters'),
          find.text('Must be ≥ min'),
          find.text('At least 2 characters'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_25', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Sr');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'B');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Education').last);
        await tester.tap(find.text('Education').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Internship').last);
        await tester.tap(find.text('Internship').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Junior').last);
        await tester.tap(find.text('Junior').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '1');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'Job desc too short.');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 3 characters'),
          find.text('At least 2 characters'),
          find.text('Must be ≥ min'),
          find.text('At least 20 characters'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_26', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'T');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Healthcare').last);
        await tester.tap(find.text('Healthcare').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Internship').last);
        await tester.tap(find.text('Internship').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Mid-Level').last);
        await tester.tap(find.text('Mid-Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 2 characters'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_27', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'B');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Healthcare').last);
        await tester.tap(find.text('Healthcare').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Full-time').last);
        await tester.tap(find.text('Full-time').last);
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
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'Job desc too short.');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 2 characters'),
          find.text('Must be ≥ min'),
          find.text('At least 20 characters'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_28', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Sr');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'B');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Education').last);
        await tester.tap(find.text('Education').last);
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
        await tester.ensureVisible(find.text('Entry_Level').last);
        await tester.tap(find.text('Entry_Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '1');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'S');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 3 characters'),
          find.text('At least 2 characters'),
          find.text('Must be ≥ min'),
          find.text('At least 2 characters'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_29', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'B');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Engineering').last);
        await tester.tap(find.text('Engineering').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Full-time').last);
        await tester.tap(find.text('Full-time').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Junior').last);
        await tester.tap(find.text('Junior').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '1');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'S');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 2 characters'),
          find.text('Must be ≥ min'),
          find.text('At least 2 characters'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_30', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Sr');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'B');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('IT_&_Tech').last);
        await tester.tap(find.text('IT_&_Tech').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Internship').last);
        await tester.tap(find.text('Internship').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Mid-Level').last);
        await tester.tap(find.text('Mid-Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '1');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'Job desc too short.');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'S');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('At least 3 characters'),
          find.text('At least 2 characters'),
          find.text('Must be ≥ min'),
          find.text('At least 20 characters'),
          find.text('At least 2 characters'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

    });
    group('pairwise_valid_cases', () {
      testWidgets('pairwise_valid_cases_1', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Engineering').last);
        await tester.tap(find.text('Engineering').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Freelance').last);
        await tester.tap(find.text('Freelance').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Junior').last);
        await tester.tap(find.text('Junior').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_2', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Healthcare').last);
        await tester.tap(find.text('Healthcare').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Contract').last);
        await tester.tap(find.text('Contract').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Mid-Level').last);
        await tester.tap(find.text('Mid-Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_3', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Healthcare').last);
        await tester.tap(find.text('Healthcare').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Freelance').last);
        await tester.tap(find.text('Freelance').last);
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
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_4', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Education').last);
        await tester.tap(find.text('Education').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Contract').last);
        await tester.tap(find.text('Contract').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Entry_Level').last);
        await tester.tap(find.text('Entry_Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_5', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('IT_&_Tech').last);
        await tester.tap(find.text('IT_&_Tech').last);
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
        await tester.ensureVisible(find.text('Entry_Level').last);
        await tester.tap(find.text('Entry_Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_6', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
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
        await tester.ensureVisible(find.text('Freelance').last);
        await tester.tap(find.text('Freelance').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Mid-Level').last);
        await tester.tap(find.text('Mid-Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_7', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Engineering').last);
        await tester.tap(find.text('Engineering').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Internship').last);
        await tester.tap(find.text('Internship').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Entry_Level').last);
        await tester.tap(find.text('Entry_Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_8', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Marketing').last);
        await tester.tap(find.text('Marketing').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Contract').last);
        await tester.tap(find.text('Contract').last);
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
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_9', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('IT_&_Tech').last);
        await tester.tap(find.text('IT_&_Tech').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Full-time').last);
        await tester.tap(find.text('Full-time').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Mid-Level').last);
        await tester.tap(find.text('Mid-Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_10', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Marketing').last);
        await tester.tap(find.text('Marketing').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Freelance').last);
        await tester.tap(find.text('Freelance').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Junior').last);
        await tester.tap(find.text('Junior').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_11', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Education').last);
        await tester.tap(find.text('Education').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Freelance').last);
        await tester.tap(find.text('Freelance').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Junior').last);
        await tester.tap(find.text('Junior').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_12', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('IT_&_Tech').last);
        await tester.tap(find.text('IT_&_Tech').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Contract').last);
        await tester.tap(find.text('Contract').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Junior').last);
        await tester.tap(find.text('Junior').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_13', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Marketing').last);
        await tester.tap(find.text('Marketing').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Internship').last);
        await tester.tap(find.text('Internship').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Mid-Level').last);
        await tester.tap(find.text('Mid-Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_14', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Education').last);
        await tester.tap(find.text('Education').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Internship').last);
        await tester.tap(find.text('Internship').last);
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
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_15', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Healthcare').last);
        await tester.tap(find.text('Healthcare').last);
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
        await tester.ensureVisible(find.text('Junior').last);
        await tester.tap(find.text('Junior').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_16', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Marketing').last);
        await tester.tap(find.text('Marketing').last);
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
        await tester.ensureVisible(find.text('Mid-Level').last);
        await tester.tap(find.text('Mid-Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_17', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Engineering').last);
        await tester.tap(find.text('Engineering').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Contract').last);
        await tester.tap(find.text('Contract').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Mid-Level').last);
        await tester.tap(find.text('Mid-Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_18', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
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
        await tester.ensureVisible(find.text('Full-time').last);
        await tester.tap(find.text('Full-time').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Entry_Level').last);
        await tester.tap(find.text('Entry_Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_19', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Healthcare').last);
        await tester.tap(find.text('Healthcare').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Internship').last);
        await tester.tap(find.text('Internship').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Entry_Level').last);
        await tester.tap(find.text('Entry_Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_20', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Engineering').last);
        await tester.tap(find.text('Engineering').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Full-time').last);
        await tester.tap(find.text('Full-time').last);
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
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_21', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Healthcare').last);
        await tester.tap(find.text('Healthcare').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Full-time').last);
        await tester.tap(find.text('Full-time').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Junior').last);
        await tester.tap(find.text('Junior').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_22', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Education').last);
        await tester.tap(find.text('Education').last);
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
        await tester.ensureVisible(find.text('Mid-Level').last);
        await tester.tap(find.text('Mid-Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_23', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
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
        await tester.ensureVisible(find.text('Internship').last);
        await tester.tap(find.text('Internship').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Junior').last);
        await tester.tap(find.text('Junior').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_24', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('IT_&_Tech').last);
        await tester.tap(find.text('IT_&_Tech').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Freelance').last);
        await tester.tap(find.text('Freelance').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Entry_Level').last);
        await tester.tap(find.text('Entry_Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_25', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Marketing').last);
        await tester.tap(find.text('Marketing').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Full-time').last);
        await tester.tap(find.text('Full-time').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Entry_Level').last);
        await tester.tap(find.text('Entry_Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_26', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('IT_&_Tech').last);
        await tester.tap(find.text('IT_&_Tech').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Internship').last);
        await tester.tap(find.text('Internship').last);
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
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_27', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
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
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_28', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Engineering').last);
        await tester.tap(find.text('Engineering').last);
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
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_29', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
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
        await tester.ensureVisible(find.text('Contract').last);
        await tester.tap(find.text('Contract').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Junior').last);
        await tester.tap(find.text('Junior').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_30', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Education').last);
        await tester.tap(find.text('Education').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Full-time').last);
        await tester.tap(find.text('Full-time').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Entry_Level').last);
        await tester.tap(find.text('Entry_Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

    });
    group('edge_cases', () {
      testWidgets('edge_cases_empty_all_fields', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
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
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'Senior Software Engineer');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'Tech Innovations Co.');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'Bangkok, Thailand');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('IT & Tech').last);
        await tester.tap(find.text('IT & Tech').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Full-time').last);
        await tester.tap(find.text('Full-time').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Entry Level').last);
        await tester.tap(find.text('Entry Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '50000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '80000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'We are looking for a highly motivated and skilled ');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, AWS');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('edge_cases_boundary_at_min_length', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].atMin
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'SE');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].atMin
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'T');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].atMin
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'B');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_04_category_dropdown')));
        await tester.tap(find.byKey(const Key('job_04_category_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('IT & Tech').last);
        await tester.tap(find.text('IT & Tech').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_05_type_dropdown')));
        await tester.tap(find.byKey(const Key('job_05_type_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Full-time').last);
        await tester.tap(find.text('Full-time').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.tap(find.byKey(const Key('job_06_exp_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Entry Level').last);
        await tester.tap(find.text('Entry Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].atMin
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].atMin
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].atMin
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'This is a short text.');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].atMin
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'F');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_end_button')));
        await tester.tap(find.byKey(const Key('job_12_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

    });
  });
}
