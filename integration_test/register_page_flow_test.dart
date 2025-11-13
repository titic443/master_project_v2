// GENERATED — Integration tests for full flow
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/register_cubit.dart';
import 'package:master_project/cubit/register_state.dart';
import 'package:master_project/register/register_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('register_page.dart flow (integration)', () {
    group('pairwise_valid_invalid_cases', () {
      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_05_gender_male_radio')));
        await tester.tap(find.byKey(const Key('register_05_gender_male_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('46 ปีขึ้นไป'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Required'),
          find.text('Please enter a valid password'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_05_gender_male_radio')));
        await tester.tap(find.byKey(const Key('register_05_gender_male_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('36 - 45 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Required'),
          find.text('Please enter a valid username'),
          find.text('Required'),
          find.text('รหัสผ่านไม่ตรงกัน'),
          find.text('Required'),
          find.text('Please enter a valid email address'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_05_gender_female_radio')));
        await tester.tap(find.byKey(const Key('register_05_gender_female_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('36 - 45 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Required'),
          find.text('Please enter a valid username'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_06_education_bachelor_radio')));
        await tester.tap(find.byKey(const Key('register_06_education_bachelor_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('18 - 25 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Required'),
          find.text('Please enter a valid username'),
          find.text('Required'),
          find.text('Please enter a valid password'),
          find.text('Required'),
          find.text('Please enter a valid email address'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_05_gender_male_radio')));
        await tester.tap(find.byKey(const Key('register_05_gender_male_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('18 - 25 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Required'),
          find.text('รหัสผ่านไม่ตรงกัน'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_05_gender_female_radio')));
        await tester.tap(find.byKey(const Key('register_05_gender_female_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('46 ปีขึ้นไป'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Required'),
          find.text('Please enter a valid password'),
          find.text('Required'),
          find.text('รหัสผ่านไม่ตรงกัน'),
          find.text('Required'),
          find.text('Please enter a valid email address'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_06_education_highschool_radio')));
        await tester.tap(find.byKey(const Key('register_06_education_highschool_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('36 - 45 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Required'),
          find.text('Please enter a valid password'),
          find.text('Required'),
          find.text('รหัสผ่านไม่ตรงกัน'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_05_gender_other_radio')));
        await tester.tap(find.byKey(const Key('register_05_gender_other_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('26 - 35 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Required'),
          find.text('Please enter a valid username'),
          find.text('Required'),
          find.text('Please enter a valid email address'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_06_education_master_radio')));
        await tester.tap(find.byKey(const Key('register_06_education_master_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('36 - 45 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Required'),
          find.text('รหัสผ่านไม่ตรงกัน'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_05_gender_other_radio')));
        await tester.tap(find.byKey(const Key('register_05_gender_other_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('36 - 45 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Required'),
          find.text('Please enter a valid password'),
          find.text('Required'),
          find.text('รหัสผ่านไม่ตรงกัน'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_06_education_bachelor_radio')));
        await tester.tap(find.byKey(const Key('register_06_education_bachelor_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('46 ปีขึ้นไป'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Required'),
          find.text('Please enter a valid username'),
          find.text('Required'),
          find.text('รหัสผ่านไม่ตรงกัน'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_06_education_bachelor_radio')));
        await tester.tap(find.byKey(const Key('register_06_education_bachelor_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('36 - 45 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Required'),
          find.text('Please enter a valid password'),
          find.text('Required'),
          find.text('รหัสผ่านไม่ตรงกัน'),
          find.text('Required'),
          find.text('Please enter a valid email address'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_06_education_master_radio')));
        await tester.tap(find.byKey(const Key('register_06_education_master_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('46 ปีขึ้นไป'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Required'),
          find.text('Please enter a valid username'),
          find.text('Required'),
          find.text('Please enter a valid password'),
          find.text('Required'),
          find.text('Please enter a valid email address'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_06_education_highschool_radio')));
        await tester.tap(find.byKey(const Key('register_06_education_highschool_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('18 - 25 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Required'),
          find.text('Please enter a valid username'),
          find.text('Required'),
          find.text('Please enter a valid email address'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_06_education_bachelor_radio')));
        await tester.tap(find.byKey(const Key('register_06_education_bachelor_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('26 - 35 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Required'),
          find.text('Please enter a valid password'),
          find.text('Required'),
          find.text('รหัสผ่านไม่ตรงกัน'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_05_gender_female_radio')));
        await tester.tap(find.byKey(const Key('register_05_gender_female_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('26 - 35 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Required'),
          find.text('Please enter a valid username'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_05_gender_other_radio')));
        await tester.tap(find.byKey(const Key('register_05_gender_other_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('46 ปีขึ้นไป'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Required'),
          find.text('รหัสผ่านไม่ตรงกัน'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_05_gender_male_radio')));
        await tester.tap(find.byKey(const Key('register_05_gender_male_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('26 - 35 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Required'),
          find.text('Please enter a valid username'),
          find.text('Required'),
          find.text('Please enter a valid password'),
          find.text('Required'),
          find.text('Please enter a valid email address'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_06_education_highschool_radio')));
        await tester.tap(find.byKey(const Key('register_06_education_highschool_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('46 ปีขึ้นไป'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Required'),
          find.text('Please enter a valid password'),
          find.text('Required'),
          find.text('รหัสผ่านไม่ตรงกัน'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_05_gender_other_radio')));
        await tester.tap(find.byKey(const Key('register_05_gender_other_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('18 - 25 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Required'),
          find.text('Please enter a valid username'),
          find.text('Required'),
          find.text('รหัสผ่านไม่ตรงกัน'),
          find.text('Required'),
          find.text('Please enter a valid email address'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_06_education_master_radio')));
        await tester.tap(find.byKey(const Key('register_06_education_master_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('26 - 35 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Required'),
          find.text('Please enter a valid username'),
          find.text('Required'),
          find.text('Please enter a valid password'),
          find.text('Required'),
          find.text('รหัสผ่านไม่ตรงกัน'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_05_gender_female_radio')));
        await tester.tap(find.byKey(const Key('register_05_gender_female_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('18 - 25 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Required'),
          find.text('Please enter a valid username'),
          find.text('Required'),
          find.text('รหัสผ่านไม่ตรงกัน'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_06_education_master_radio')));
        await tester.tap(find.byKey(const Key('register_06_education_master_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('18 - 25 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Required'),
          find.text('Please enter a valid username'),
          find.text('Required'),
          find.text('Please enter a valid password'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.invalid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_06_education_highschool_radio')));
        await tester.tap(find.byKey(const Key('register_06_education_highschool_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('26 - 35 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Required'),
          find.text('รหัสผ่านไม่ตรงกัน'),
          find.text('Required'),
          find.text('Please enter a valid email address'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

    });
    group('pairwise_valid_cases', () {
      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_05_gender_male_radio')));
        await tester.tap(find.byKey(const Key('register_05_gender_male_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('46 ปีขึ้นไป'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_06_education_master_radio')));
        await tester.tap(find.byKey(const Key('register_06_education_master_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('36 - 45 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_05_gender_female_radio')));
        await tester.tap(find.byKey(const Key('register_05_gender_female_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('36 - 45 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_05_gender_female_radio')));
        await tester.tap(find.byKey(const Key('register_05_gender_female_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('18 - 25 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_05_gender_other_radio')));
        await tester.tap(find.byKey(const Key('register_05_gender_other_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('18 - 25 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_05_gender_male_radio')));
        await tester.tap(find.byKey(const Key('register_05_gender_male_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('26 - 35 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_05_gender_other_radio')));
        await tester.tap(find.byKey(const Key('register_05_gender_other_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('36 - 45 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_06_education_highschool_radio')));
        await tester.tap(find.byKey(const Key('register_06_education_highschool_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('26 - 35 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_06_education_bachelor_radio')));
        await tester.tap(find.byKey(const Key('register_06_education_bachelor_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('46 ปีขึ้นไป'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_06_education_bachelor_radio')));
        await tester.tap(find.byKey(const Key('register_06_education_bachelor_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('26 - 35 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_06_education_master_radio')));
        await tester.tap(find.byKey(const Key('register_06_education_master_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('26 - 35 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_06_education_master_radio')));
        await tester.tap(find.byKey(const Key('register_06_education_master_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('46 ปีขึ้นไป'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_05_gender_female_radio')));
        await tester.tap(find.byKey(const Key('register_05_gender_female_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('46 ปีขึ้นไป'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_06_education_bachelor_radio')));
        await tester.tap(find.byKey(const Key('register_06_education_bachelor_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('18 - 25 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_05_gender_male_radio')));
        await tester.tap(find.byKey(const Key('register_05_gender_male_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('18 - 25 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_06_education_highschool_radio')));
        await tester.tap(find.byKey(const Key('register_06_education_highschool_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('36 - 45 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_05_gender_female_radio')));
        await tester.tap(find.byKey(const Key('register_05_gender_female_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('26 - 35 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_06_education_highschool_radio')));
        await tester.tap(find.byKey(const Key('register_06_education_highschool_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('46 ปีขึ้นไป'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_05_gender_other_radio')));
        await tester.tap(find.byKey(const Key('register_05_gender_other_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('46 ปีขึ้นไป'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_06_education_highschool_radio')));
        await tester.tap(find.byKey(const Key('register_06_education_highschool_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('18 - 25 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_06_education_master_radio')));
        await tester.tap(find.byKey(const Key('register_06_education_master_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('18 - 25 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_05_gender_other_radio')));
        await tester.tap(find.byKey(const Key('register_05_gender_other_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('26 - 35 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_05_gender_male_radio')));
        await tester.tap(find.byKey(const Key('register_05_gender_male_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('36 - 45 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
      });

      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.register_01_username_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_01_username_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_02_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_02_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_03_confirm_password_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_03_confirm_password_textfield')), '');
        await tester.pump();
        // dataset: byKey.register_04_email_textfield.valid[0]
        await tester.enterText(find.byKey(const Key('register_04_email_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_06_education_bachelor_radio')));
        await tester.tap(find.byKey(const Key('register_06_education_bachelor_radio')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_07_age_dropdown')));
        await tester.tap(find.byKey(const Key('register_07_age_dropdown')));
        await tester.pump();
        await tester.tap(find.text('36 - 45 ปี'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Print actual backend response for debugging
        final element = find.byType(RegisterPage).evaluate().first;
        final cubit = BlocProvider.of<RegisterCubit>(element);
        if (cubit.state.response != null) {
          print('✓ [case] Backend Response: ${cubit.state.response!.code} - ${cubit.state.response!.message}');
        } else if (cubit.state.exception != null) {
          print('✗ [case] Backend Error: ${cubit.state.exception!.code} - ${cubit.state.exception!.message}');
        } else {
          print('? [case] No response or exception from backend');
        }
      });

    });
    group('edge_cases', () {
      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<RegisterCubit>(create: (_)=> RegisterCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RegisterPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.tap(find.byKey(const Key('register_08_submit_endapi_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Required'),
          find.text('กรุณาเลือกตัวเลือก'),
          find.text('กรุณาเลือกอายุ'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

    });
  });
}
