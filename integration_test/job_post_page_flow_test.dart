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
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'ผู้');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'C');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('กรุณากรอกเงินเดือนขั้นต่ำ'),
          find.text('ต้องมากกว่าหรือเท่ากับเงินเดือนขั้นต่ำ'),
          find.text('กรุณากรอกเงินเดือนสูงสุด'),
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
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บ');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'ต');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'รายละเอียดงานสั้นเกินไป');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_invalid_cases_3', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'ต');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'รายละเอียดงานสั้นเกินไป');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'C');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('กรุณากรอกเงินเดือนขั้นต่ำ'),
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
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'ผู้');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บ');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.ensureVisible(find.text('Entry Level').last);
        await tester.tap(find.text('Entry Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ต้องมากกว่าหรือเท่ากับเงินเดือนขั้นต่ำ'),
          find.text('กรุณากรอกเงินเดือนสูงสุด'),
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
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'ผู้');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บ');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'ต');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'C');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ต้องมากกว่าหรือเท่ากับเงินเดือนขั้นต่ำ'),
          find.text('กรุณากรอกเงินเดือนสูงสุด'),
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
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'รายละเอียดงานสั้นเกินไป');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('กรุณากรอกเงินเดือนขั้นต่ำ'),
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
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บ');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'ต');
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
        await tester.ensureVisible(find.text('Entry Level').last);
        await tester.tap(find.text('Entry Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'C');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_invalid_cases_8', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'รายละเอียดงานสั้นเกินไป');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('กรุณากรอกเงินเดือนขั้นต่ำ'),
          find.text('ต้องมากกว่าหรือเท่ากับเงินเดือนขั้นต่ำ'),
          find.text('กรุณากรอกเงินเดือนสูงสุด'),
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
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'ผู้');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'ต');
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
        // dataset: byKey.job_07_salary_min_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'รายละเอียดงานสั้นเกินไป');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'C');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('กรุณากรอกเงินเดือนขั้นต่ำ'),
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
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บ');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ต้องมากกว่าหรือเท่ากับเงินเดือนขั้นต่ำ'),
          find.text('กรุณากรอกเงินเดือนสูงสุด'),
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
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'ผู้');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'ต');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'รายละเอียดงานสั้นเกินไป');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'C');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_invalid_cases_12', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'ผู้');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บ');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ต้องมากกว่าหรือเท่ากับเงินเดือนขั้นต่ำ'),
          find.text('กรุณากรอกเงินเดือนสูงสุด'),
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
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'ผู้');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บ');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('กรุณากรอกเงินเดือนขั้นต่ำ'),
          find.text('ต้องมากกว่าหรือเท่ากับเงินเดือนขั้นต่ำ'),
          find.text('กรุณากรอกเงินเดือนสูงสุด'),
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
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'ผู้');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บ');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'ต');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'C');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_invalid_cases_15', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บ');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'ต');
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
        await tester.ensureVisible(find.text('Freelance').last);
        await tester.tap(find.text('Freelance').last);
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
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ต้องมากกว่าหรือเท่ากับเงินเดือนขั้นต่ำ'),
          find.text('กรุณากรอกเงินเดือนสูงสุด'),
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
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'ผู้');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'ต');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'รายละเอียดงานสั้นเกินไป');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'C');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_invalid_cases_17', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'ผู้');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บ');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ต้องมากกว่าหรือเท่ากับเงินเดือนขั้นต่ำ'),
          find.text('กรุณากรอกเงินเดือนสูงสุด'),
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
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บ');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('กรุณากรอกเงินเดือนขั้นต่ำ'),
          find.text('ต้องมากกว่าหรือเท่ากับเงินเดือนขั้นต่ำ'),
          find.text('กรุณากรอกเงินเดือนสูงสุด'),
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
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'รายละเอียดงานสั้นเกินไป');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('กรุณากรอกเงินเดือนขั้นต่ำ'),
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
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'ผู้');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.ensureVisible(find.text('Entry Level').last);
        await tester.tap(find.text('Entry Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'รายละเอียดงานสั้นเกินไป');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'C');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('กรุณากรอกเงินเดือนขั้นต่ำ'),
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
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บ');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('กรุณากรอกเงินเดือนขั้นต่ำ'),
          find.text('ต้องมากกว่าหรือเท่ากับเงินเดือนขั้นต่ำ'),
          find.text('กรุณากรอกเงินเดือนสูงสุด'),
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
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'ผู้');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บ');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'รายละเอียดงานสั้นเกินไป');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'C');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ต้องมากกว่าหรือเท่ากับเงินเดือนขั้นต่ำ'),
          find.text('กรุณากรอกเงินเดือนสูงสุด'),
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
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'ผู้');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.ensureVisible(find.text('Entry Level').last);
        await tester.tap(find.text('Entry Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_invalid_cases_24', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'ผู้');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บ');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.ensureVisible(find.text('Entry Level').last);
        await tester.tap(find.text('Entry Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'C');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ต้องมากกว่าหรือเท่ากับเงินเดือนขั้นต่ำ'),
          find.text('กรุณากรอกเงินเดือนสูงสุด'),
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
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'ผู้');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'ต');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'รายละเอียดงานสั้นเกินไป');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('กรุณากรอกเงินเดือนขั้นต่ำ'),
          find.text('ต้องมากกว่าหรือเท่ากับเงินเดือนขั้นต่ำ'),
          find.text('กรุณากรอกเงินเดือนสูงสุด'),
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
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บ');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_invalid_cases_27', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'ต');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'รายละเอียดงานสั้นเกินไป');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ต้องมากกว่าหรือเท่ากับเงินเดือนขั้นต่ำ'),
          find.text('กรุณากรอกเงินเดือนสูงสุด'),
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
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'ผู้');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'ต');
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
        await tester.ensureVisible(find.text('Entry Level').last);
        await tester.tap(find.text('Entry Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'C');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('กรุณากรอกเงินเดือนขั้นต่ำ'),
          find.text('ต้องมากกว่าหรือเท่ากับเงินเดือนขั้นต่ำ'),
          find.text('กรุณากรอกเงินเดือนสูงสุด'),
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
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'ต');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'C');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('กรุณากรอกเงินเดือนขั้นต่ำ'),
          find.text('ต้องมากกว่าหรือเท่ากับเงินเดือนขั้นต่ำ'),
          find.text('กรุณากรอกเงินเดือนสูงสุด'),
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
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'ผู้');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'ต');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'รายละเอียดงานสั้นเกินไป');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'C');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('กรุณากรอกเงินเดือนขั้นต่ำ'),
          find.text('ต้องมากกว่าหรือเท่ากับเงินเดือนขั้นต่ำ'),
          find.text('กรุณากรอกเงินเดือนสูงสุด'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_31', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
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
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
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
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
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
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
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
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.ensureVisible(find.text('Entry Level').last);
        await tester.tap(find.text('Entry Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
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
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.ensureVisible(find.text('Part-time').last);
        await tester.tap(find.text('Part-time').last);
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
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
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
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
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
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.ensureVisible(find.text('Entry Level').last);
        await tester.tap(find.text('Entry Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
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
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
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
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.ensureVisible(find.text('Mid-Level').last);
        await tester.tap(find.text('Mid-Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
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
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
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
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
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
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
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
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
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
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
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
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
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
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
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
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
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
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.ensureVisible(find.text('Entry Level').last);
        await tester.tap(find.text('Entry Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
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
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.ensureVisible(find.text('Entry Level').last);
        await tester.tap(find.text('Entry Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
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
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
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
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
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
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
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
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
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
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.ensureVisible(find.text('Freelance').last);
        await tester.tap(find.text('Freelance').last);
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
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
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
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.ensureVisible(find.text('Entry Level').last);
        await tester.tap(find.text('Entry Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_cases_26', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_cases_27', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_cases_28', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_cases_29', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_cases_30', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'วิศวกรซอฟต์แวร์');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท ดิจิทัล โซลูชั่นส์ จำกัด');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร');
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
        await tester.ensureVisible(find.text('Entry Level').last);
        await tester.tap(find.text('Entry Level').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.job_07_salary_min_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '40000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].valid
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Flutter, Dart, Firebase');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_11_remote_switch')));
        await tester.tap(find.byKey(const Key('job_11_remote_switch')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
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
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('กรุณากรอกตำแหน่งงาน'),
          find.text('กรุณากรอกชื่อบริษัท'),
          find.text('กรุณากรอกสถานที่ทำงาน'),
          find.text('กรุณาเลือกหมวดหมู่งาน'),
          find.text('กรุณาเลือกประเภทการจ้างงาน'),
          find.text('กรุณาเลือกระดับประสบการณ์'),
          find.text('กรุณากรอกเงินเดือนขั้นต่ำ'),
          find.text('กรุณากรอกเงินเดือนสูงสุด'),
          find.text('กรุณากรอกรายละเอียดงาน'),
          find.text('กรุณากรอกทักษะที่ต้องการ'),
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
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'ผู้จัดการโครงการอาวุโสและหัวหน้าทีมพัฒนาซอฟต์แวร์แ');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บริษัท เทคโนโลยีขั้นสูงและนวัตกรรมเพื่อการพัฒนาอย่');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'กรุงเทพมหานคร เขตบางกะปิ แขวงหัวหมาก ซอยรามคำแหง 2');
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
        await tester.enterText(find.byKey(const Key('job_07_salary_min_textfield')), '30000');
        await tester.pump();
        // dataset: byKey.job_08_salary_max_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('job_08_salary_max_textfield')), '150000');
        await tester.pump();
        // dataset: byKey.job_09_desc_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'บริษัทของเรากำลังมองหาวิศวกรซอฟต์แวร์ที่มีความสามา');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'Dart, Flutter, Firebase, NodeJS, React, TypeScript');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_success')),
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
          BlocProvider<JobPostCubit>(create: (_)=> JobPostCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: JobPostPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.job_01_title_textfield[0].atMin
        await tester.enterText(find.byKey(const Key('job_01_title_textfield')), 'งา');
        await tester.pump();
        // dataset: byKey.job_02_company_textfield[0].atMin
        await tester.enterText(find.byKey(const Key('job_02_company_textfield')), 'บ');
        await tester.pump();
        // dataset: byKey.job_03_location_textfield[0].atMin
        await tester.enterText(find.byKey(const Key('job_03_location_textfield')), 'ก');
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
        await tester.enterText(find.byKey(const Key('job_09_desc_textfield')), 'รายละเอียดงานสั้นเกินไป');
        await tester.pump();
        // dataset: byKey.job_10_skills_textfield[0].atMin
        await tester.enterText(find.byKey(const Key('job_10_skills_textfield')), 'ท');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('job_12_xxx_button')));
        await tester.tap(find.byKey(const Key('job_12_xxx_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('job_12_expected_fail')),
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
