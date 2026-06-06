// GENERATED — Integration tests for full flow
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/clinic_appointment_cubit.dart';
import 'package:master_project/demos/clinic_appointment_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('clinic_appointment_page.dart flow (integration)', () {
    group('pairwise_invalid_cases', () {
      testWidgets('pairwise_invalid_cases_1', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย123');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '123456789012');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '081234567');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('อายุรกรรม').last);
        await tester.tap(find.text('อายุรกรรม').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_05_type_radio_opd')));
        await tester.tap(find.byKey(const Key('appt_05_type_radio_opd')));
        await tester.pump();
        // Skip tap for 'appt_06_date_textfield' (next action is null/cancel)
        // Skip date selection (null/cancel)
        // Skip tap for 'appt_07_time_textfield' (next action is null/cancel)
        // Skip time selection (null/cancel)
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), '!');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ใช้ได้เฉพาะตัวอักษรไทยหรืออังกฤษ'),
          find.text('ต้องมี 13 หลัก'),
          find.text('เบอร์โทรไม่ถูกต้อง (ต้องขึ้นต้นด้วย 0 และมี 9-10 หลัก)'),
          find.text('กรุณาเลือกวันที่นัดหมาย'),
          find.text('กรุณาเลือกช่วงเวลา'),
          find.byKey(const Key('appt_10_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_invalid_cases_2', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย123');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '123456789012');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '081234567');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('กระดูกและข้อ').last);
        await tester.tap(find.text('กระดูกและข้อ').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // Skip tap for 'appt_06_date_textfield' (next action is null/cancel)
        // Skip date selection (null/cancel)
        // Skip tap for 'appt_07_time_textfield' (next action is null/cancel)
        // Skip time selection (null/cancel)
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), '!');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ใช้ได้เฉพาะตัวอักษรไทยหรืออังกฤษ'),
          find.text('ต้องมี 13 หลัก'),
          find.text('เบอร์โทรไม่ถูกต้อง (ต้องขึ้นต้นด้วย 0 และมี 9-10 หลัก)'),
          find.text('กรุณาเลือกวันที่นัดหมาย'),
          find.text('กรุณาเลือกช่วงเวลา'),
          find.text('กรุณาเลือกประเภทการนัด'),
          find.byKey(const Key('appt_10_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_invalid_cases_3', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย123');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '123456789012');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '081234567');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ศัลยกรรม').last);
        await tester.tap(find.text('ศัลยกรรม').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_05_type_radio_opd')));
        await tester.tap(find.byKey(const Key('appt_05_type_radio_opd')));
        await tester.pump();
        // Skip tap for 'appt_06_date_textfield' (next action is null/cancel)
        // Skip date selection (null/cancel)
        // Skip tap for 'appt_07_time_textfield' (next action is null/cancel)
        // Skip time selection (null/cancel)
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), '!');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ใช้ได้เฉพาะตัวอักษรไทยหรืออังกฤษ'),
          find.text('ต้องมี 13 หลัก'),
          find.text('เบอร์โทรไม่ถูกต้อง (ต้องขึ้นต้นด้วย 0 และมี 9-10 หลัก)'),
          find.text('กรุณาเลือกวันที่นัดหมาย'),
          find.text('กรุณาเลือกช่วงเวลา'),
          find.byKey(const Key('appt_10_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_invalid_cases_4', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย123');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '123456789012');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '081234567');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('กุมารเวชศาสตร์').last);
        await tester.tap(find.text('กุมารเวชศาสตร์').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_05_type_radio_opd')));
        await tester.tap(find.byKey(const Key('appt_05_type_radio_opd')));
        await tester.pump();
        // Skip tap for 'appt_06_date_textfield' (next action is null/cancel)
        // Skip date selection (null/cancel)
        // Skip tap for 'appt_07_time_textfield' (next action is null/cancel)
        // Skip time selection (null/cancel)
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), '!');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ใช้ได้เฉพาะตัวอักษรไทยหรืออังกฤษ'),
          find.text('ต้องมี 13 หลัก'),
          find.text('เบอร์โทรไม่ถูกต้อง (ต้องขึ้นต้นด้วย 0 และมี 9-10 หลัก)'),
          find.text('กรุณาเลือกวันที่นัดหมาย'),
          find.text('กรุณาเลือกช่วงเวลา'),
          find.byKey(const Key('appt_10_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_invalid_cases_5', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย123');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '123456789012');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '081234567');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ศัลยกรรม').last);
        await tester.tap(find.text('ศัลยกรรม').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_05_type_radio_tele')));
        await tester.tap(find.byKey(const Key('appt_05_type_radio_tele')));
        await tester.pump();
        // Skip tap for 'appt_06_date_textfield' (next action is null/cancel)
        // Skip date selection (null/cancel)
        // Skip tap for 'appt_07_time_textfield' (next action is null/cancel)
        // Skip time selection (null/cancel)
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), '!');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ใช้ได้เฉพาะตัวอักษรไทยหรืออังกฤษ'),
          find.text('ต้องมี 13 หลัก'),
          find.text('เบอร์โทรไม่ถูกต้อง (ต้องขึ้นต้นด้วย 0 และมี 9-10 หลัก)'),
          find.text('กรุณาเลือกวันที่นัดหมาย'),
          find.text('กรุณาเลือกช่วงเวลา'),
          find.byKey(const Key('appt_10_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_invalid_cases_6', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย123');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '123456789012');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '081234567');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('หู คอ จมูก').last);
        await tester.tap(find.text('หู คอ จมูก').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_05_type_radio_opd')));
        await tester.tap(find.byKey(const Key('appt_05_type_radio_opd')));
        await tester.pump();
        // Skip tap for 'appt_06_date_textfield' (next action is null/cancel)
        // Skip date selection (null/cancel)
        // Skip tap for 'appt_07_time_textfield' (next action is null/cancel)
        // Skip time selection (null/cancel)
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), '!');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ใช้ได้เฉพาะตัวอักษรไทยหรืออังกฤษ'),
          find.text('ต้องมี 13 หลัก'),
          find.text('เบอร์โทรไม่ถูกต้อง (ต้องขึ้นต้นด้วย 0 และมี 9-10 หลัก)'),
          find.text('กรุณาเลือกวันที่นัดหมาย'),
          find.text('กรุณาเลือกช่วงเวลา'),
          find.byKey(const Key('appt_10_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_invalid_cases_7', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย123');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '123456789012');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '081234567');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('อายุรกรรม').last);
        await tester.tap(find.text('อายุรกรรม').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_05_type_radio_tele')));
        await tester.tap(find.byKey(const Key('appt_05_type_radio_tele')));
        await tester.pump();
        // Skip tap for 'appt_06_date_textfield' (next action is null/cancel)
        // Skip date selection (null/cancel)
        // Skip tap for 'appt_07_time_textfield' (next action is null/cancel)
        // Skip time selection (null/cancel)
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), '!');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ใช้ได้เฉพาะตัวอักษรไทยหรืออังกฤษ'),
          find.text('ต้องมี 13 หลัก'),
          find.text('เบอร์โทรไม่ถูกต้อง (ต้องขึ้นต้นด้วย 0 และมี 9-10 หลัก)'),
          find.text('กรุณาเลือกวันที่นัดหมาย'),
          find.text('กรุณาเลือกช่วงเวลา'),
          find.byKey(const Key('appt_10_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_invalid_cases_8', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย123');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '123456789012');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '081234567');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('หู คอ จมูก').last);
        await tester.tap(find.text('หู คอ จมูก').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // Skip tap for 'appt_06_date_textfield' (next action is null/cancel)
        // Skip date selection (null/cancel)
        // Skip tap for 'appt_07_time_textfield' (next action is null/cancel)
        // Skip time selection (null/cancel)
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), '!');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ใช้ได้เฉพาะตัวอักษรไทยหรืออังกฤษ'),
          find.text('ต้องมี 13 หลัก'),
          find.text('เบอร์โทรไม่ถูกต้อง (ต้องขึ้นต้นด้วย 0 และมี 9-10 หลัก)'),
          find.text('กรุณาเลือกวันที่นัดหมาย'),
          find.text('กรุณาเลือกช่วงเวลา'),
          find.text('กรุณาเลือกประเภทการนัด'),
          find.byKey(const Key('appt_10_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_invalid_cases_9', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย123');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '123456789012');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '081234567');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('กุมารเวชศาสตร์').last);
        await tester.tap(find.text('กุมารเวชศาสตร์').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_05_type_radio_tele')));
        await tester.tap(find.byKey(const Key('appt_05_type_radio_tele')));
        await tester.pump();
        // Skip tap for 'appt_06_date_textfield' (next action is null/cancel)
        // Skip date selection (null/cancel)
        // Skip tap for 'appt_07_time_textfield' (next action is null/cancel)
        // Skip time selection (null/cancel)
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), '!');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ใช้ได้เฉพาะตัวอักษรไทยหรืออังกฤษ'),
          find.text('ต้องมี 13 หลัก'),
          find.text('เบอร์โทรไม่ถูกต้อง (ต้องขึ้นต้นด้วย 0 และมี 9-10 หลัก)'),
          find.text('กรุณาเลือกวันที่นัดหมาย'),
          find.text('กรุณาเลือกช่วงเวลา'),
          find.byKey(const Key('appt_10_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_invalid_cases_10', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย123');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '123456789012');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '081234567');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('จักษุวิทยา').last);
        await tester.tap(find.text('จักษุวิทยา').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // Skip tap for 'appt_06_date_textfield' (next action is null/cancel)
        // Skip date selection (null/cancel)
        // Skip tap for 'appt_07_time_textfield' (next action is null/cancel)
        // Skip time selection (null/cancel)
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), '!');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ใช้ได้เฉพาะตัวอักษรไทยหรืออังกฤษ'),
          find.text('ต้องมี 13 หลัก'),
          find.text('เบอร์โทรไม่ถูกต้อง (ต้องขึ้นต้นด้วย 0 และมี 9-10 หลัก)'),
          find.text('กรุณาเลือกวันที่นัดหมาย'),
          find.text('กรุณาเลือกช่วงเวลา'),
          find.text('กรุณาเลือกประเภทการนัด'),
          find.byKey(const Key('appt_10_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_invalid_cases_11', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย123');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '123456789012');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '081234567');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('จักษุวิทยา').last);
        await tester.tap(find.text('จักษุวิทยา').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_05_type_radio_tele')));
        await tester.tap(find.byKey(const Key('appt_05_type_radio_tele')));
        await tester.pump();
        // Skip tap for 'appt_06_date_textfield' (next action is null/cancel)
        // Skip date selection (null/cancel)
        // Skip tap for 'appt_07_time_textfield' (next action is null/cancel)
        // Skip time selection (null/cancel)
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), '!');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ใช้ได้เฉพาะตัวอักษรไทยหรืออังกฤษ'),
          find.text('ต้องมี 13 หลัก'),
          find.text('เบอร์โทรไม่ถูกต้อง (ต้องขึ้นต้นด้วย 0 และมี 9-10 หลัก)'),
          find.text('กรุณาเลือกวันที่นัดหมาย'),
          find.text('กรุณาเลือกช่วงเวลา'),
          find.byKey(const Key('appt_10_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_invalid_cases_12', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย123');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '123456789012');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '081234567');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('สูติ-นรีเวช').last);
        await tester.tap(find.text('สูติ-นรีเวช').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // Skip tap for 'appt_06_date_textfield' (next action is null/cancel)
        // Skip date selection (null/cancel)
        // Skip tap for 'appt_07_time_textfield' (next action is null/cancel)
        // Skip time selection (null/cancel)
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), '!');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ใช้ได้เฉพาะตัวอักษรไทยหรืออังกฤษ'),
          find.text('ต้องมี 13 หลัก'),
          find.text('เบอร์โทรไม่ถูกต้อง (ต้องขึ้นต้นด้วย 0 และมี 9-10 หลัก)'),
          find.text('กรุณาเลือกวันที่นัดหมาย'),
          find.text('กรุณาเลือกช่วงเวลา'),
          find.text('กรุณาเลือกประเภทการนัด'),
          find.byKey(const Key('appt_10_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_invalid_cases_13', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย123');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '123456789012');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '081234567');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('กุมารเวชศาสตร์').last);
        await tester.tap(find.text('กุมารเวชศาสตร์').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // Skip tap for 'appt_06_date_textfield' (next action is null/cancel)
        // Skip date selection (null/cancel)
        // Skip tap for 'appt_07_time_textfield' (next action is null/cancel)
        // Skip time selection (null/cancel)
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), '!');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ใช้ได้เฉพาะตัวอักษรไทยหรืออังกฤษ'),
          find.text('ต้องมี 13 หลัก'),
          find.text('เบอร์โทรไม่ถูกต้อง (ต้องขึ้นต้นด้วย 0 และมี 9-10 หลัก)'),
          find.text('กรุณาเลือกวันที่นัดหมาย'),
          find.text('กรุณาเลือกช่วงเวลา'),
          find.text('กรุณาเลือกประเภทการนัด'),
          find.byKey(const Key('appt_10_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_invalid_cases_14', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย123');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '123456789012');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '081234567');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('สูติ-นรีเวช').last);
        await tester.tap(find.text('สูติ-นรีเวช').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_05_type_radio_tele')));
        await tester.tap(find.byKey(const Key('appt_05_type_radio_tele')));
        await tester.pump();
        // Skip tap for 'appt_06_date_textfield' (next action is null/cancel)
        // Skip date selection (null/cancel)
        // Skip tap for 'appt_07_time_textfield' (next action is null/cancel)
        // Skip time selection (null/cancel)
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), '!');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ใช้ได้เฉพาะตัวอักษรไทยหรืออังกฤษ'),
          find.text('ต้องมี 13 หลัก'),
          find.text('เบอร์โทรไม่ถูกต้อง (ต้องขึ้นต้นด้วย 0 และมี 9-10 หลัก)'),
          find.text('กรุณาเลือกวันที่นัดหมาย'),
          find.text('กรุณาเลือกช่วงเวลา'),
          find.byKey(const Key('appt_10_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_invalid_cases_15', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย123');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '123456789012');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '081234567');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('สูติ-นรีเวช').last);
        await tester.tap(find.text('สูติ-นรีเวช').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_05_type_radio_opd')));
        await tester.tap(find.byKey(const Key('appt_05_type_radio_opd')));
        await tester.pump();
        // Skip tap for 'appt_06_date_textfield' (next action is null/cancel)
        // Skip date selection (null/cancel)
        // Skip tap for 'appt_07_time_textfield' (next action is null/cancel)
        // Skip time selection (null/cancel)
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), '!');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ใช้ได้เฉพาะตัวอักษรไทยหรืออังกฤษ'),
          find.text('ต้องมี 13 หลัก'),
          find.text('เบอร์โทรไม่ถูกต้อง (ต้องขึ้นต้นด้วย 0 และมี 9-10 หลัก)'),
          find.text('กรุณาเลือกวันที่นัดหมาย'),
          find.text('กรุณาเลือกช่วงเวลา'),
          find.byKey(const Key('appt_10_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_invalid_cases_16', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย123');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '123456789012');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '081234567');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('กระดูกและข้อ').last);
        await tester.tap(find.text('กระดูกและข้อ').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_05_type_radio_tele')));
        await tester.tap(find.byKey(const Key('appt_05_type_radio_tele')));
        await tester.pump();
        // Skip tap for 'appt_06_date_textfield' (next action is null/cancel)
        // Skip date selection (null/cancel)
        // Skip tap for 'appt_07_time_textfield' (next action is null/cancel)
        // Skip time selection (null/cancel)
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), '!');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ใช้ได้เฉพาะตัวอักษรไทยหรืออังกฤษ'),
          find.text('ต้องมี 13 หลัก'),
          find.text('เบอร์โทรไม่ถูกต้อง (ต้องขึ้นต้นด้วย 0 และมี 9-10 หลัก)'),
          find.text('กรุณาเลือกวันที่นัดหมาย'),
          find.text('กรุณาเลือกช่วงเวลา'),
          find.byKey(const Key('appt_10_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_invalid_cases_17', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย123');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '123456789012');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '081234567');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('กระดูกและข้อ').last);
        await tester.tap(find.text('กระดูกและข้อ').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_05_type_radio_opd')));
        await tester.tap(find.byKey(const Key('appt_05_type_radio_opd')));
        await tester.pump();
        // Skip tap for 'appt_06_date_textfield' (next action is null/cancel)
        // Skip date selection (null/cancel)
        // Skip tap for 'appt_07_time_textfield' (next action is null/cancel)
        // Skip time selection (null/cancel)
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), '!');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ใช้ได้เฉพาะตัวอักษรไทยหรืออังกฤษ'),
          find.text('ต้องมี 13 หลัก'),
          find.text('เบอร์โทรไม่ถูกต้อง (ต้องขึ้นต้นด้วย 0 และมี 9-10 หลัก)'),
          find.text('กรุณาเลือกวันที่นัดหมาย'),
          find.text('กรุณาเลือกช่วงเวลา'),
          find.byKey(const Key('appt_10_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_invalid_cases_18', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย123');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '123456789012');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '081234567');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('หู คอ จมูก').last);
        await tester.tap(find.text('หู คอ จมูก').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_05_type_radio_tele')));
        await tester.tap(find.byKey(const Key('appt_05_type_radio_tele')));
        await tester.pump();
        // Skip tap for 'appt_06_date_textfield' (next action is null/cancel)
        // Skip date selection (null/cancel)
        // Skip tap for 'appt_07_time_textfield' (next action is null/cancel)
        // Skip time selection (null/cancel)
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), '!');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ใช้ได้เฉพาะตัวอักษรไทยหรืออังกฤษ'),
          find.text('ต้องมี 13 หลัก'),
          find.text('เบอร์โทรไม่ถูกต้อง (ต้องขึ้นต้นด้วย 0 และมี 9-10 หลัก)'),
          find.text('กรุณาเลือกวันที่นัดหมาย'),
          find.text('กรุณาเลือกช่วงเวลา'),
          find.byKey(const Key('appt_10_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_invalid_cases_19', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย123');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '123456789012');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '081234567');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ศัลยกรรม').last);
        await tester.tap(find.text('ศัลยกรรม').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // Skip tap for 'appt_06_date_textfield' (next action is null/cancel)
        // Skip date selection (null/cancel)
        // Skip tap for 'appt_07_time_textfield' (next action is null/cancel)
        // Skip time selection (null/cancel)
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), '!');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ใช้ได้เฉพาะตัวอักษรไทยหรืออังกฤษ'),
          find.text('ต้องมี 13 หลัก'),
          find.text('เบอร์โทรไม่ถูกต้อง (ต้องขึ้นต้นด้วย 0 และมี 9-10 หลัก)'),
          find.text('กรุณาเลือกวันที่นัดหมาย'),
          find.text('กรุณาเลือกช่วงเวลา'),
          find.text('กรุณาเลือกประเภทการนัด'),
          find.byKey(const Key('appt_10_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_invalid_cases_20', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย123');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '123456789012');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '081234567');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('จักษุวิทยา').last);
        await tester.tap(find.text('จักษุวิทยา').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_05_type_radio_opd')));
        await tester.tap(find.byKey(const Key('appt_05_type_radio_opd')));
        await tester.pump();
        // Skip tap for 'appt_06_date_textfield' (next action is null/cancel)
        // Skip date selection (null/cancel)
        // Skip tap for 'appt_07_time_textfield' (next action is null/cancel)
        // Skip time selection (null/cancel)
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), '!');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ใช้ได้เฉพาะตัวอักษรไทยหรืออังกฤษ'),
          find.text('ต้องมี 13 หลัก'),
          find.text('เบอร์โทรไม่ถูกต้อง (ต้องขึ้นต้นด้วย 0 และมี 9-10 หลัก)'),
          find.text('กรุณาเลือกวันที่นัดหมาย'),
          find.text('กรุณาเลือกช่วงเวลา'),
          find.byKey(const Key('appt_10_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
        // Dismiss AlertDialog
        final _dialogBtn = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextButton));
        if (_dialogBtn.evaluate().isNotEmpty) await tester.tap(_dialogBtn.last);
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_invalid_cases_21', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย123');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '123456789012');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '081234567');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('อายุรกรรม').last);
        await tester.tap(find.text('อายุรกรรม').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // Skip tap for 'appt_06_date_textfield' (next action is null/cancel)
        // Skip date selection (null/cancel)
        // Skip tap for 'appt_07_time_textfield' (next action is null/cancel)
        // Skip time selection (null/cancel)
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), '!');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ใช้ได้เฉพาะตัวอักษรไทยหรืออังกฤษ'),
          find.text('ต้องมี 13 หลัก'),
          find.text('เบอร์โทรไม่ถูกต้อง (ต้องขึ้นต้นด้วย 0 และมี 9-10 หลัก)'),
          find.text('กรุณาเลือกวันที่นัดหมาย'),
          find.text('กรุณาเลือกช่วงเวลา'),
          find.text('กรุณาเลือกประเภทการนัด'),
          find.byKey(const Key('appt_10_expected_fail')),
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
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102030000004');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('จักษุวิทยา').last);
        await tester.tap(find.text('จักษุวิทยา').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_05_type_radio_opd')));
        await tester.tap(find.byKey(const Key('appt_05_type_radio_opd')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pumpAndSettle();
        // Select date: 06/06/2026 (text input mode)
        {
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Switch DatePicker to text-input mode via edit icon
          final editIcon = find.byIcon(Icons.edit);
          if (tester.any(editIcon)) {
            await tester.tap(editIcon.first);
            await tester.pumpAndSettle();
          }
          // Enter date as MM/DD/YYYY in the text field
          final dateTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
          if (tester.any(dateTF)) {
            await tester.tap(dateTF.first);
            await tester.pumpAndSettle();
            await tester.enterText(dateTF.first, '06/06/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pumpAndSettle();
        // Select time: 10:00
        {
          final keyboardBtn = find.byIcon(Icons.keyboard);
          if (tester.any(keyboardBtn)) {
            await tester.tap(keyboardBtn.first);
            await tester.pumpAndSettle();
          }
        }
        {
          final dialogTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
          if (dialogTF.evaluate().length >= 1) {
            await tester.tap(dialogTF.first);
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.first, '10');
            await tester.pumpAndSettle();
          }
          if (dialogTF.evaluate().length >= 2) {
            await tester.tap(dialogTF.at(1));
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.at(1), '00');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'ผู้ป่วยมีอาการไอเรื้อรังมา 2 สัปดาห์');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
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
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102030000004');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ศัลยกรรม').last);
        await tester.tap(find.text('ศัลยกรรม').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_05_type_radio_tele')));
        await tester.tap(find.byKey(const Key('appt_05_type_radio_tele')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pumpAndSettle();
        // Select date: 06/06/2026 (text input mode)
        {
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Switch DatePicker to text-input mode via edit icon
          final editIcon = find.byIcon(Icons.edit);
          if (tester.any(editIcon)) {
            await tester.tap(editIcon.first);
            await tester.pumpAndSettle();
          }
          // Enter date as MM/DD/YYYY in the text field
          final dateTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
          if (tester.any(dateTF)) {
            await tester.tap(dateTF.first);
            await tester.pumpAndSettle();
            await tester.enterText(dateTF.first, '06/06/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pumpAndSettle();
        // Select time: 10:00
        {
          final keyboardBtn = find.byIcon(Icons.keyboard);
          if (tester.any(keyboardBtn)) {
            await tester.tap(keyboardBtn.first);
            await tester.pumpAndSettle();
          }
        }
        {
          final dialogTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
          if (dialogTF.evaluate().length >= 1) {
            await tester.tap(dialogTF.first);
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.first, '10');
            await tester.pumpAndSettle();
          }
          if (dialogTF.evaluate().length >= 2) {
            await tester.tap(dialogTF.at(1));
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.at(1), '00');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'ผู้ป่วยมีอาการไอเรื้อรังมา 2 สัปดาห์');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
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
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102030000004');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('หู คอ จมูก').last);
        await tester.tap(find.text('หู คอ จมูก').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_05_type_radio_tele')));
        await tester.tap(find.byKey(const Key('appt_05_type_radio_tele')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pumpAndSettle();
        // Select date: 06/06/2026 (text input mode)
        {
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Switch DatePicker to text-input mode via edit icon
          final editIcon = find.byIcon(Icons.edit);
          if (tester.any(editIcon)) {
            await tester.tap(editIcon.first);
            await tester.pumpAndSettle();
          }
          // Enter date as MM/DD/YYYY in the text field
          final dateTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
          if (tester.any(dateTF)) {
            await tester.tap(dateTF.first);
            await tester.pumpAndSettle();
            await tester.enterText(dateTF.first, '06/06/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pumpAndSettle();
        // Select time: 10:00
        {
          final keyboardBtn = find.byIcon(Icons.keyboard);
          if (tester.any(keyboardBtn)) {
            await tester.tap(keyboardBtn.first);
            await tester.pumpAndSettle();
          }
        }
        {
          final dialogTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
          if (dialogTF.evaluate().length >= 1) {
            await tester.tap(dialogTF.first);
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.first, '10');
            await tester.pumpAndSettle();
          }
          if (dialogTF.evaluate().length >= 2) {
            await tester.tap(dialogTF.at(1));
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.at(1), '00');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'ผู้ป่วยมีอาการไอเรื้อรังมา 2 สัปดาห์');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
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
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102030000004');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('กุมารเวชศาสตร์').last);
        await tester.tap(find.text('กุมารเวชศาสตร์').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_05_type_radio_tele')));
        await tester.tap(find.byKey(const Key('appt_05_type_radio_tele')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pumpAndSettle();
        // Select date: 06/06/2026 (text input mode)
        {
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Switch DatePicker to text-input mode via edit icon
          final editIcon = find.byIcon(Icons.edit);
          if (tester.any(editIcon)) {
            await tester.tap(editIcon.first);
            await tester.pumpAndSettle();
          }
          // Enter date as MM/DD/YYYY in the text field
          final dateTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
          if (tester.any(dateTF)) {
            await tester.tap(dateTF.first);
            await tester.pumpAndSettle();
            await tester.enterText(dateTF.first, '06/06/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pumpAndSettle();
        // Select time: 10:00
        {
          final keyboardBtn = find.byIcon(Icons.keyboard);
          if (tester.any(keyboardBtn)) {
            await tester.tap(keyboardBtn.first);
            await tester.pumpAndSettle();
          }
        }
        {
          final dialogTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
          if (dialogTF.evaluate().length >= 1) {
            await tester.tap(dialogTF.first);
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.first, '10');
            await tester.pumpAndSettle();
          }
          if (dialogTF.evaluate().length >= 2) {
            await tester.tap(dialogTF.at(1));
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.at(1), '00');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'ผู้ป่วยมีอาการไอเรื้อรังมา 2 สัปดาห์');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
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
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102030000004');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('อายุรกรรม').last);
        await tester.tap(find.text('อายุรกรรม').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_05_type_radio_opd')));
        await tester.tap(find.byKey(const Key('appt_05_type_radio_opd')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pumpAndSettle();
        // Select date: 06/06/2026 (text input mode)
        {
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Switch DatePicker to text-input mode via edit icon
          final editIcon = find.byIcon(Icons.edit);
          if (tester.any(editIcon)) {
            await tester.tap(editIcon.first);
            await tester.pumpAndSettle();
          }
          // Enter date as MM/DD/YYYY in the text field
          final dateTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
          if (tester.any(dateTF)) {
            await tester.tap(dateTF.first);
            await tester.pumpAndSettle();
            await tester.enterText(dateTF.first, '06/06/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pumpAndSettle();
        // Select time: 10:00
        {
          final keyboardBtn = find.byIcon(Icons.keyboard);
          if (tester.any(keyboardBtn)) {
            await tester.tap(keyboardBtn.first);
            await tester.pumpAndSettle();
          }
        }
        {
          final dialogTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
          if (dialogTF.evaluate().length >= 1) {
            await tester.tap(dialogTF.first);
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.first, '10');
            await tester.pumpAndSettle();
          }
          if (dialogTF.evaluate().length >= 2) {
            await tester.tap(dialogTF.at(1));
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.at(1), '00');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'ผู้ป่วยมีอาการไอเรื้อรังมา 2 สัปดาห์');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
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
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102030000004');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ศัลยกรรม').last);
        await tester.tap(find.text('ศัลยกรรม').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_05_type_radio_opd')));
        await tester.tap(find.byKey(const Key('appt_05_type_radio_opd')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pumpAndSettle();
        // Select date: 06/06/2026 (text input mode)
        {
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Switch DatePicker to text-input mode via edit icon
          final editIcon = find.byIcon(Icons.edit);
          if (tester.any(editIcon)) {
            await tester.tap(editIcon.first);
            await tester.pumpAndSettle();
          }
          // Enter date as MM/DD/YYYY in the text field
          final dateTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
          if (tester.any(dateTF)) {
            await tester.tap(dateTF.first);
            await tester.pumpAndSettle();
            await tester.enterText(dateTF.first, '06/06/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pumpAndSettle();
        // Select time: 10:00
        {
          final keyboardBtn = find.byIcon(Icons.keyboard);
          if (tester.any(keyboardBtn)) {
            await tester.tap(keyboardBtn.first);
            await tester.pumpAndSettle();
          }
        }
        {
          final dialogTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
          if (dialogTF.evaluate().length >= 1) {
            await tester.tap(dialogTF.first);
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.first, '10');
            await tester.pumpAndSettle();
          }
          if (dialogTF.evaluate().length >= 2) {
            await tester.tap(dialogTF.at(1));
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.at(1), '00');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'ผู้ป่วยมีอาการไอเรื้อรังมา 2 สัปดาห์');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
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
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102030000004');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('สูติ-นรีเวช').last);
        await tester.tap(find.text('สูติ-นรีเวช').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_05_type_radio_tele')));
        await tester.tap(find.byKey(const Key('appt_05_type_radio_tele')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pumpAndSettle();
        // Select date: 06/06/2026 (text input mode)
        {
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Switch DatePicker to text-input mode via edit icon
          final editIcon = find.byIcon(Icons.edit);
          if (tester.any(editIcon)) {
            await tester.tap(editIcon.first);
            await tester.pumpAndSettle();
          }
          // Enter date as MM/DD/YYYY in the text field
          final dateTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
          if (tester.any(dateTF)) {
            await tester.tap(dateTF.first);
            await tester.pumpAndSettle();
            await tester.enterText(dateTF.first, '06/06/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pumpAndSettle();
        // Select time: 10:00
        {
          final keyboardBtn = find.byIcon(Icons.keyboard);
          if (tester.any(keyboardBtn)) {
            await tester.tap(keyboardBtn.first);
            await tester.pumpAndSettle();
          }
        }
        {
          final dialogTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
          if (dialogTF.evaluate().length >= 1) {
            await tester.tap(dialogTF.first);
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.first, '10');
            await tester.pumpAndSettle();
          }
          if (dialogTF.evaluate().length >= 2) {
            await tester.tap(dialogTF.at(1));
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.at(1), '00');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'ผู้ป่วยมีอาการไอเรื้อรังมา 2 สัปดาห์');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
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
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102030000004');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('กระดูกและข้อ').last);
        await tester.tap(find.text('กระดูกและข้อ').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_05_type_radio_opd')));
        await tester.tap(find.byKey(const Key('appt_05_type_radio_opd')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pumpAndSettle();
        // Select date: 06/06/2026 (text input mode)
        {
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Switch DatePicker to text-input mode via edit icon
          final editIcon = find.byIcon(Icons.edit);
          if (tester.any(editIcon)) {
            await tester.tap(editIcon.first);
            await tester.pumpAndSettle();
          }
          // Enter date as MM/DD/YYYY in the text field
          final dateTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
          if (tester.any(dateTF)) {
            await tester.tap(dateTF.first);
            await tester.pumpAndSettle();
            await tester.enterText(dateTF.first, '06/06/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pumpAndSettle();
        // Select time: 10:00
        {
          final keyboardBtn = find.byIcon(Icons.keyboard);
          if (tester.any(keyboardBtn)) {
            await tester.tap(keyboardBtn.first);
            await tester.pumpAndSettle();
          }
        }
        {
          final dialogTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
          if (dialogTF.evaluate().length >= 1) {
            await tester.tap(dialogTF.first);
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.first, '10');
            await tester.pumpAndSettle();
          }
          if (dialogTF.evaluate().length >= 2) {
            await tester.tap(dialogTF.at(1));
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.at(1), '00');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'ผู้ป่วยมีอาการไอเรื้อรังมา 2 สัปดาห์');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
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
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102030000004');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('หู คอ จมูก').last);
        await tester.tap(find.text('หู คอ จมูก').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_05_type_radio_opd')));
        await tester.tap(find.byKey(const Key('appt_05_type_radio_opd')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pumpAndSettle();
        // Select date: 06/06/2026 (text input mode)
        {
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Switch DatePicker to text-input mode via edit icon
          final editIcon = find.byIcon(Icons.edit);
          if (tester.any(editIcon)) {
            await tester.tap(editIcon.first);
            await tester.pumpAndSettle();
          }
          // Enter date as MM/DD/YYYY in the text field
          final dateTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
          if (tester.any(dateTF)) {
            await tester.tap(dateTF.first);
            await tester.pumpAndSettle();
            await tester.enterText(dateTF.first, '06/06/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pumpAndSettle();
        // Select time: 10:00
        {
          final keyboardBtn = find.byIcon(Icons.keyboard);
          if (tester.any(keyboardBtn)) {
            await tester.tap(keyboardBtn.first);
            await tester.pumpAndSettle();
          }
        }
        {
          final dialogTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
          if (dialogTF.evaluate().length >= 1) {
            await tester.tap(dialogTF.first);
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.first, '10');
            await tester.pumpAndSettle();
          }
          if (dialogTF.evaluate().length >= 2) {
            await tester.tap(dialogTF.at(1));
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.at(1), '00');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'ผู้ป่วยมีอาการไอเรื้อรังมา 2 สัปดาห์');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
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
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102030000004');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('อายุรกรรม').last);
        await tester.tap(find.text('อายุรกรรม').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_05_type_radio_tele')));
        await tester.tap(find.byKey(const Key('appt_05_type_radio_tele')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pumpAndSettle();
        // Select date: 06/06/2026 (text input mode)
        {
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Switch DatePicker to text-input mode via edit icon
          final editIcon = find.byIcon(Icons.edit);
          if (tester.any(editIcon)) {
            await tester.tap(editIcon.first);
            await tester.pumpAndSettle();
          }
          // Enter date as MM/DD/YYYY in the text field
          final dateTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
          if (tester.any(dateTF)) {
            await tester.tap(dateTF.first);
            await tester.pumpAndSettle();
            await tester.enterText(dateTF.first, '06/06/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pumpAndSettle();
        // Select time: 10:00
        {
          final keyboardBtn = find.byIcon(Icons.keyboard);
          if (tester.any(keyboardBtn)) {
            await tester.tap(keyboardBtn.first);
            await tester.pumpAndSettle();
          }
        }
        {
          final dialogTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
          if (dialogTF.evaluate().length >= 1) {
            await tester.tap(dialogTF.first);
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.first, '10');
            await tester.pumpAndSettle();
          }
          if (dialogTF.evaluate().length >= 2) {
            await tester.tap(dialogTF.at(1));
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.at(1), '00');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'ผู้ป่วยมีอาการไอเรื้อรังมา 2 สัปดาห์');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
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
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102030000004');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('จักษุวิทยา').last);
        await tester.tap(find.text('จักษุวิทยา').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_05_type_radio_tele')));
        await tester.tap(find.byKey(const Key('appt_05_type_radio_tele')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pumpAndSettle();
        // Select date: 06/06/2026 (text input mode)
        {
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Switch DatePicker to text-input mode via edit icon
          final editIcon = find.byIcon(Icons.edit);
          if (tester.any(editIcon)) {
            await tester.tap(editIcon.first);
            await tester.pumpAndSettle();
          }
          // Enter date as MM/DD/YYYY in the text field
          final dateTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
          if (tester.any(dateTF)) {
            await tester.tap(dateTF.first);
            await tester.pumpAndSettle();
            await tester.enterText(dateTF.first, '06/06/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pumpAndSettle();
        // Select time: 10:00
        {
          final keyboardBtn = find.byIcon(Icons.keyboard);
          if (tester.any(keyboardBtn)) {
            await tester.tap(keyboardBtn.first);
            await tester.pumpAndSettle();
          }
        }
        {
          final dialogTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
          if (dialogTF.evaluate().length >= 1) {
            await tester.tap(dialogTF.first);
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.first, '10');
            await tester.pumpAndSettle();
          }
          if (dialogTF.evaluate().length >= 2) {
            await tester.tap(dialogTF.at(1));
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.at(1), '00');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'ผู้ป่วยมีอาการไอเรื้อรังมา 2 สัปดาห์');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
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
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102030000004');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('กุมารเวชศาสตร์').last);
        await tester.tap(find.text('กุมารเวชศาสตร์').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_05_type_radio_opd')));
        await tester.tap(find.byKey(const Key('appt_05_type_radio_opd')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pumpAndSettle();
        // Select date: 06/06/2026 (text input mode)
        {
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Switch DatePicker to text-input mode via edit icon
          final editIcon = find.byIcon(Icons.edit);
          if (tester.any(editIcon)) {
            await tester.tap(editIcon.first);
            await tester.pumpAndSettle();
          }
          // Enter date as MM/DD/YYYY in the text field
          final dateTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
          if (tester.any(dateTF)) {
            await tester.tap(dateTF.first);
            await tester.pumpAndSettle();
            await tester.enterText(dateTF.first, '06/06/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pumpAndSettle();
        // Select time: 10:00
        {
          final keyboardBtn = find.byIcon(Icons.keyboard);
          if (tester.any(keyboardBtn)) {
            await tester.tap(keyboardBtn.first);
            await tester.pumpAndSettle();
          }
        }
        {
          final dialogTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
          if (dialogTF.evaluate().length >= 1) {
            await tester.tap(dialogTF.first);
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.first, '10');
            await tester.pumpAndSettle();
          }
          if (dialogTF.evaluate().length >= 2) {
            await tester.tap(dialogTF.at(1));
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.at(1), '00');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'ผู้ป่วยมีอาการไอเรื้อรังมา 2 สัปดาห์');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
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
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102030000004');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('สูติ-นรีเวช').last);
        await tester.tap(find.text('สูติ-นรีเวช').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_05_type_radio_opd')));
        await tester.tap(find.byKey(const Key('appt_05_type_radio_opd')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pumpAndSettle();
        // Select date: 06/06/2026 (text input mode)
        {
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Switch DatePicker to text-input mode via edit icon
          final editIcon = find.byIcon(Icons.edit);
          if (tester.any(editIcon)) {
            await tester.tap(editIcon.first);
            await tester.pumpAndSettle();
          }
          // Enter date as MM/DD/YYYY in the text field
          final dateTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
          if (tester.any(dateTF)) {
            await tester.tap(dateTF.first);
            await tester.pumpAndSettle();
            await tester.enterText(dateTF.first, '06/06/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pumpAndSettle();
        // Select time: 10:00
        {
          final keyboardBtn = find.byIcon(Icons.keyboard);
          if (tester.any(keyboardBtn)) {
            await tester.tap(keyboardBtn.first);
            await tester.pumpAndSettle();
          }
        }
        {
          final dialogTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
          if (dialogTF.evaluate().length >= 1) {
            await tester.tap(dialogTF.first);
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.first, '10');
            await tester.pumpAndSettle();
          }
          if (dialogTF.evaluate().length >= 2) {
            await tester.tap(dialogTF.at(1));
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.at(1), '00');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'ผู้ป่วยมีอาการไอเรื้อรังมา 2 สัปดาห์');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
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
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102030000004');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('กระดูกและข้อ').last);
        await tester.tap(find.text('กระดูกและข้อ').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_05_type_radio_tele')));
        await tester.tap(find.byKey(const Key('appt_05_type_radio_tele')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pumpAndSettle();
        // Select date: 06/06/2026 (text input mode)
        {
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Switch DatePicker to text-input mode via edit icon
          final editIcon = find.byIcon(Icons.edit);
          if (tester.any(editIcon)) {
            await tester.tap(editIcon.first);
            await tester.pumpAndSettle();
          }
          // Enter date as MM/DD/YYYY in the text field
          final dateTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
          if (tester.any(dateTF)) {
            await tester.tap(dateTF.first);
            await tester.pumpAndSettle();
            await tester.enterText(dateTF.first, '06/06/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pumpAndSettle();
        // Select time: 10:00
        {
          final keyboardBtn = find.byIcon(Icons.keyboard);
          if (tester.any(keyboardBtn)) {
            await tester.tap(keyboardBtn.first);
            await tester.pumpAndSettle();
          }
        }
        {
          final dialogTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
          if (dialogTF.evaluate().length >= 1) {
            await tester.tap(dialogTF.first);
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.first, '10');
            await tester.pumpAndSettle();
          }
          if (dialogTF.evaluate().length >= 2) {
            await tester.tap(dialogTF.at(1));
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.at(1), '00');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'ผู้ป่วยมีอาการไอเรื้อรังมา 2 สัปดาห์');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
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
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('กรุณากรอกชื่อ-นามสกุล'),
          find.text('กรุณากรอกเลขบัตรประชาชน'),
          find.text('กรุณากรอกเบอร์โทรศัพท์'),
          find.text('กรุณาเลือกแผนก'),
          find.text('กรุณาเลือกวันที่นัดหมาย'),
          find.text('กรุณาเลือกช่วงเวลา'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('edge_cases_boundary_at_max_length', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'ปัญญาพร วัฒนามานะชัยกุลสวัสดิ์เจริญสุขสำราญใจจริงย');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1234567890123');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('อายุรกรรม').last);
        await tester.tap(find.text('อายุรกรรม').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_05_type_radio_opd')));
        await tester.tap(find.byKey(const Key('appt_05_type_radio_opd')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pumpAndSettle();
        // Select date: 06/06/2026 (text input mode)
        {
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Switch DatePicker to text-input mode via edit icon
          final editIcon = find.byIcon(Icons.edit);
          if (tester.any(editIcon)) {
            await tester.tap(editIcon.first);
            await tester.pumpAndSettle();
          }
          // Enter date as MM/DD/YYYY in the text field
          final dateTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
          if (tester.any(dateTF)) {
            await tester.tap(dateTF.first);
            await tester.pumpAndSettle();
            await tester.enterText(dateTF.first, '06/06/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pumpAndSettle();
        // Select time: 09:00
        {
          final keyboardBtn = find.byIcon(Icons.keyboard);
          if (tester.any(keyboardBtn)) {
            await tester.tap(keyboardBtn.first);
            await tester.pumpAndSettle();
          }
        }
        {
          final dialogTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
          if (dialogTF.evaluate().length >= 1) {
            await tester.tap(dialogTF.first);
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.first, '09');
            await tester.pumpAndSettle();
          }
          if (dialogTF.evaluate().length >= 2) {
            await tester.tap(dialogTF.at(1));
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.at(1), '00');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        // dataset: byKey.appt_09_note_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'ผู้ป่วยเคยมีประวัติแพ้ยาเพนิซิลลิน ควรระวังในการใช');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
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
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].atMin
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), '');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].atMin
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].atMin
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('อายุรกรรม').last);
        await tester.tap(find.text('อายุรกรรม').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_05_type_radio_opd')));
        await tester.tap(find.byKey(const Key('appt_05_type_radio_opd')));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pumpAndSettle();
        // Select date: 06/06/2026 (text input mode)
        {
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Switch DatePicker to text-input mode via edit icon
          final editIcon = find.byIcon(Icons.edit);
          if (tester.any(editIcon)) {
            await tester.tap(editIcon.first);
            await tester.pumpAndSettle();
          }
          // Enter date as MM/DD/YYYY in the text field
          final dateTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
          if (tester.any(dateTF)) {
            await tester.tap(dateTF.first);
            await tester.pumpAndSettle();
            await tester.enterText(dateTF.first, '06/06/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pumpAndSettle();
        // Select time: 09:00
        {
          final keyboardBtn = find.byIcon(Icons.keyboard);
          if (tester.any(keyboardBtn)) {
            await tester.tap(keyboardBtn.first);
            await tester.pumpAndSettle();
          }
        }
        {
          final dialogTF = find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
          if (dialogTF.evaluate().length >= 1) {
            await tester.tap(dialogTF.first);
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.first, '09');
            await tester.pumpAndSettle();
          }
          if (dialogTF.evaluate().length >= 2) {
            await tester.tap(dialogTF.at(1));
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.at(1), '00');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        // dataset: byKey.appt_09_note_textfield[0].atMin
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), '');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_fail')),
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
