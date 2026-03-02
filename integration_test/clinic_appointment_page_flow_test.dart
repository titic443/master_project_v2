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
    group('pairwise_valid_invalid_cases', () {
      testWidgets('pairwise_valid_invalid_cases_1', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'ส');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '123456789012');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '08123456');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ศัลยกรรม').last);
        await tester.tap(find.text('ศัลยกรรม').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/2001 (text input mode)
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
            await tester.enterText(dateTF.first, '01/15/2001');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 14:30
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
            await tester.enterText(dialogTF.first, '14');
            await tester.pumpAndSettle();
          }
          if (dialogTF.evaluate().length >= 2) {
            await tester.tap(dialogTF.at(1));
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.at(1), '30');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('อย่างน้อย 2 ตัวอักษร'),
          find.text('ต้องมี 13 หลัก'),
          find.text('เบอร์โทรไม่ถูกต้อง'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_2', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'ส');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('กุมารเวชศาสตร์').last);
        await tester.tap(find.text('กุมารเวชศาสตร์').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // Skip tap for 'appt_06_date_textfield' (next action is null/cancel)
        // Skip date selection (null/cancel)
        await tester.pump();
        // Skip tap for 'appt_07_time_textfield' (next action is null/cancel)
        // Skip time selection (null/cancel)
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'X');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('อย่างน้อย 2 ตัวอักษร'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_3', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '08123456');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('กระดูกและข้อ').last);
        await tester.tap(find.text('กระดูกและข้อ').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 03/03/2026 (text input mode)
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
            await tester.enterText(dateTF.first, '03/03/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 14:30
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
            await tester.enterText(dialogTF.first, '14');
            await tester.pumpAndSettle();
          }
          if (dialogTF.evaluate().length >= 2) {
            await tester.tap(dialogTF.at(1));
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.at(1), '30');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'X');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('เบอร์โทรไม่ถูกต้อง'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_4', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '123456789012');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('จักษุวิทยา').last);
        await tester.tap(find.text('จักษุวิทยา').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/2030 (text input mode)
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
            await tester.enterText(dateTF.first, '01/15/2030');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 14:30
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
            await tester.enterText(dialogTF.first, '14');
            await tester.pumpAndSettle();
          }
          if (dialogTF.evaluate().length >= 2) {
            await tester.tap(dialogTF.at(1));
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.at(1), '30');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ต้องมี 13 หลัก'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_5', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '08123456');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('หู คอ จมูก').last);
        await tester.tap(find.text('หู คอ จมูก').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/2001 (text input mode)
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
            await tester.enterText(dateTF.first, '01/15/2001');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 18:00
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
            await tester.enterText(dialogTF.first, '18');
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
        await tester.pump();
        await tester.pumpAndSettle();
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'X');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('เบอร์โทรไม่ถูกต้อง'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_6', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'ส');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '123456789012');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('กระดูกและข้อ').last);
        await tester.tap(find.text('กระดูกและข้อ').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/2030 (text input mode)
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
            await tester.enterText(dateTF.first, '01/15/2030');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
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
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('อย่างน้อย 2 ตัวอักษร'),
          find.text('ต้องมี 13 หลัก'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_7', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '123456789012');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '08123456');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('สูติ-นรีเวช').last);
        await tester.tap(find.text('สูติ-นรีเวช').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // Skip tap for 'appt_06_date_textfield' (next action is null/cancel)
        // Skip date selection (null/cancel)
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 14:30
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
            await tester.enterText(dialogTF.first, '14');
            await tester.pumpAndSettle();
          }
          if (dialogTF.evaluate().length >= 2) {
            await tester.tap(dialogTF.at(1));
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.at(1), '30');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ต้องมี 13 หลัก'),
          find.text('เบอร์โทรไม่ถูกต้อง'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_8', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'ส');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '123456789012');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('กุมารเวชศาสตร์').last);
        await tester.tap(find.text('กุมารเวชศาสตร์').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 03/03/2026 (text input mode)
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
            await tester.enterText(dateTF.first, '03/03/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 18:00
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
            await tester.enterText(dialogTF.first, '18');
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
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('อย่างน้อย 2 ตัวอักษร'),
          find.text('ต้องมี 13 หลัก'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_9', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '123456789012');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '08123456');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('อายุรกรรม').last);
        await tester.tap(find.text('อายุรกรรม').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // Skip tap for 'appt_06_date_textfield' (next action is null/cancel)
        // Skip date selection (null/cancel)
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
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
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'X');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ต้องมี 13 หลัก'),
          find.text('เบอร์โทรไม่ถูกต้อง'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_10', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'ส');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('อายุรกรรม').last);
        await tester.tap(find.text('อายุรกรรม').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 03/03/2026 (text input mode)
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
            await tester.enterText(dateTF.first, '03/03/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        // Skip tap for 'appt_07_time_textfield' (next action is null/cancel)
        // Skip time selection (null/cancel)
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('อย่างน้อย 2 ตัวอักษร'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_11', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ศัลยกรรม').last);
        await tester.tap(find.text('ศัลยกรรม').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // Skip tap for 'appt_06_date_textfield' (next action is null/cancel)
        // Skip date selection (null/cancel)
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
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
        await tester.pump();
        await tester.pumpAndSettle();
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'X');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
      });

      testWidgets('pairwise_valid_invalid_cases_12', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '08123456');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('จักษุวิทยา').last);
        await tester.tap(find.text('จักษุวิทยา').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/2001 (text input mode)
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
            await tester.enterText(dateTF.first, '01/15/2001');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        // Skip tap for 'appt_07_time_textfield' (next action is null/cancel)
        // Skip time selection (null/cancel)
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'X');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('เบอร์โทรไม่ถูกต้อง'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_13', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '08123456');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('กุมารเวชศาสตร์').last);
        await tester.tap(find.text('กุมารเวชศาสตร์').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/2030 (text input mode)
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
            await tester.enterText(dateTF.first, '01/15/2030');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
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
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'X');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('เบอร์โทรไม่ถูกต้อง'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_14', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('อายุรกรรม').last);
        await tester.tap(find.text('อายุรกรรม').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/2030 (text input mode)
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
            await tester.enterText(dateTF.first, '01/15/2030');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 18:00
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
            await tester.enterText(dialogTF.first, '18');
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
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_15', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'ส');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '123456789012');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('กระดูกและข้อ').last);
        await tester.tap(find.text('กระดูกและข้อ').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/2001 (text input mode)
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
            await tester.enterText(dateTF.first, '01/15/2001');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        // Skip tap for 'appt_07_time_textfield' (next action is null/cancel)
        // Skip time selection (null/cancel)
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('อย่างน้อย 2 ตัวอักษร'),
          find.text('ต้องมี 13 หลัก'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_16', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'ส');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('สูติ-นรีเวช').last);
        await tester.tap(find.text('สูติ-นรีเวช').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 03/03/2026 (text input mode)
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
            await tester.enterText(dateTF.first, '03/03/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 18:00
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
            await tester.enterText(dialogTF.first, '18');
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
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'X');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('อย่างน้อย 2 ตัวอักษร'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_17', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '123456789012');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '08123456');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('อายุรกรรม').last);
        await tester.tap(find.text('อายุรกรรม').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/2001 (text input mode)
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
            await tester.enterText(dateTF.first, '01/15/2001');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 14:30
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
            await tester.enterText(dialogTF.first, '14');
            await tester.pumpAndSettle();
          }
          if (dialogTF.evaluate().length >= 2) {
            await tester.tap(dialogTF.at(1));
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.at(1), '30');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('ต้องมี 13 หลัก'),
          find.text('เบอร์โทรไม่ถูกต้อง'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_18', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('กุมารเวชศาสตร์').last);
        await tester.tap(find.text('กุมารเวชศาสตร์').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/2001 (text input mode)
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
            await tester.enterText(dateTF.first, '01/15/2001');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 14:30
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
            await tester.enterText(dialogTF.first, '14');
            await tester.pumpAndSettle();
          }
          if (dialogTF.evaluate().length >= 2) {
            await tester.tap(dialogTF.at(1));
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.at(1), '30');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_19', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '08123456');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('กระดูกและข้อ').last);
        await tester.tap(find.text('กระดูกและข้อ').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // Skip tap for 'appt_06_date_textfield' (next action is null/cancel)
        // Skip date selection (null/cancel)
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 18:00
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
            await tester.enterText(dialogTF.first, '18');
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
        await tester.pump();
        await tester.pumpAndSettle();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('เบอร์โทรไม่ถูกต้อง'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_20', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '08123456');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('สูติ-นรีเวช').last);
        await tester.tap(find.text('สูติ-นรีเวช').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/2001 (text input mode)
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
            await tester.enterText(dateTF.first, '01/15/2001');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
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
        await tester.pump();
        await tester.pumpAndSettle();
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'X');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('เบอร์โทรไม่ถูกต้อง'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_21', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'ส');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '123456789012');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('หู คอ จมูก').last);
        await tester.tap(find.text('หู คอ จมูก').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 03/03/2026 (text input mode)
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
            await tester.enterText(dateTF.first, '03/03/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
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
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('อย่างน้อย 2 ตัวอักษร'),
          find.text('ต้องมี 13 หลัก'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_22', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'ส');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ศัลยกรรม').last);
        await tester.tap(find.text('ศัลยกรรม').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/2030 (text input mode)
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
            await tester.enterText(dateTF.first, '01/15/2030');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        // Skip tap for 'appt_07_time_textfield' (next action is null/cancel)
        // Skip time selection (null/cancel)
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('อย่างน้อย 2 ตัวอักษร'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_23', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'ส');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '08123456');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('จักษุวิทยา').last);
        await tester.tap(find.text('จักษุวิทยา').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // Skip tap for 'appt_06_date_textfield' (next action is null/cancel)
        // Skip date selection (null/cancel)
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 18:00
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
            await tester.enterText(dialogTF.first, '18');
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
        await tester.pump();
        await tester.pumpAndSettle();
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'X');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('อย่างน้อย 2 ตัวอักษร'),
          find.text('เบอร์โทรไม่ถูกต้อง'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_24', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'ส');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '123456789012');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ศัลยกรรม').last);
        await tester.tap(find.text('ศัลยกรรม').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 03/03/2026 (text input mode)
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
            await tester.enterText(dateTF.first, '03/03/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 18:00
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
            await tester.enterText(dialogTF.first, '18');
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
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('อย่างน้อย 2 ตัวอักษร'),
          find.text('ต้องมี 13 หลัก'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_25', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'ส');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('สูติ-นรีเวช').last);
        await tester.tap(find.text('สูติ-นรีเวช').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/2030 (text input mode)
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
            await tester.enterText(dateTF.first, '01/15/2030');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        // Skip tap for 'appt_07_time_textfield' (next action is null/cancel)
        // Skip time selection (null/cancel)
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'X');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('อย่างน้อย 2 ตัวอักษร'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_26', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'ส');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '123456789012');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('หู คอ จมูก').last);
        await tester.tap(find.text('หู คอ จมูก').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/2030 (text input mode)
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
            await tester.enterText(dateTF.first, '01/15/2030');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        // Skip tap for 'appt_07_time_textfield' (next action is null/cancel)
        // Skip time selection (null/cancel)
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'X');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('อย่างน้อย 2 ตัวอักษร'),
          find.text('ต้องมี 13 หลัก'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_27', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'ส');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '08123456');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('หู คอ จมูก').last);
        await tester.tap(find.text('หู คอ จมูก').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // Skip tap for 'appt_06_date_textfield' (next action is null/cancel)
        // Skip date selection (null/cancel)
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 14:30
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
            await tester.enterText(dialogTF.first, '14');
            await tester.pumpAndSettle();
          }
          if (dialogTF.evaluate().length >= 2) {
            await tester.tap(dialogTF.at(1));
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.at(1), '30');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('อย่างน้อย 2 ตัวอักษร'),
          find.text('เบอร์โทรไม่ถูกต้อง'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_invalid_cases_28', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'ส');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('จักษุวิทยา').last);
        await tester.tap(find.text('จักษุวิทยา').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 03/03/2026 (text input mode)
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
            await tester.enterText(dateTF.first, '03/03/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
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
        await tester.pump();
        await tester.pumpAndSettle();
        // dataset: byKey.appt_09_note_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'X');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('อย่างน้อย 2 ตัวอักษร'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
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
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('อายุรกรรม').last);
        await tester.tap(find.text('อายุรกรรม').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 03/03/2026 (text input mode)
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
            await tester.enterText(dateTF.first, '03/03/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
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
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
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
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('กุมารเวชศาสตร์').last);
        await tester.tap(find.text('กุมารเวชศาสตร์').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/2030 (text input mode)
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
            await tester.enterText(dateTF.first, '01/15/2030');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
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
        await tester.pump();
        await tester.pumpAndSettle();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
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
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('กระดูกและข้อ').last);
        await tester.tap(find.text('กระดูกและข้อ').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 03/03/2026 (text input mode)
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
            await tester.enterText(dateTF.first, '03/03/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
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
        await tester.pump();
        await tester.pumpAndSettle();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
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
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('กุมารเวชศาสตร์').last);
        await tester.tap(find.text('กุมารเวชศาสตร์').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/2030 (text input mode)
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
            await tester.enterText(dateTF.first, '01/15/2030');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 18:00
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
            await tester.enterText(dialogTF.first, '18');
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
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
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
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('กระดูกและข้อ').last);
        await tester.tap(find.text('กระดูกและข้อ').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/2030 (text input mode)
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
            await tester.enterText(dateTF.first, '01/15/2030');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 18:00
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
            await tester.enterText(dialogTF.first, '18');
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
        await tester.pump();
        await tester.pumpAndSettle();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
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
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ศัลยกรรม').last);
        await tester.tap(find.text('ศัลยกรรม').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/2030 (text input mode)
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
            await tester.enterText(dateTF.first, '01/15/2030');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 14:30
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
            await tester.enterText(dialogTF.first, '14');
            await tester.pumpAndSettle();
          }
          if (dialogTF.evaluate().length >= 2) {
            await tester.tap(dialogTF.at(1));
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.at(1), '30');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
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
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('กระดูกและข้อ').last);
        await tester.tap(find.text('กระดูกและข้อ').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 03/03/2026 (text input mode)
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
            await tester.enterText(dateTF.first, '03/03/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 14:30
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
            await tester.enterText(dialogTF.first, '14');
            await tester.pumpAndSettle();
          }
          if (dialogTF.evaluate().length >= 2) {
            await tester.tap(dialogTF.at(1));
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.at(1), '30');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
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
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('อายุรกรรม').last);
        await tester.tap(find.text('อายุรกรรม').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/2030 (text input mode)
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
            await tester.enterText(dateTF.first, '01/15/2030');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 14:30
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
            await tester.enterText(dialogTF.first, '14');
            await tester.pumpAndSettle();
          }
          if (dialogTF.evaluate().length >= 2) {
            await tester.tap(dialogTF.at(1));
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.at(1), '30');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
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
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('จักษุวิทยา').last);
        await tester.tap(find.text('จักษุวิทยา').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 03/03/2026 (text input mode)
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
            await tester.enterText(dateTF.first, '03/03/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 18:00
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
            await tester.enterText(dialogTF.first, '18');
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
        await tester.pump();
        await tester.pumpAndSettle();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
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
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('กุมารเวชศาสตร์').last);
        await tester.tap(find.text('กุมารเวชศาสตร์').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 03/03/2026 (text input mode)
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
            await tester.enterText(dateTF.first, '03/03/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 14:30
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
            await tester.enterText(dialogTF.first, '14');
            await tester.pumpAndSettle();
          }
          if (dialogTF.evaluate().length >= 2) {
            await tester.tap(dialogTF.at(1));
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.at(1), '30');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
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
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ศัลยกรรม').last);
        await tester.tap(find.text('ศัลยกรรม').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 03/03/2026 (text input mode)
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
            await tester.enterText(dateTF.first, '03/03/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 18:00
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
            await tester.enterText(dialogTF.first, '18');
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
        await tester.pump();
        await tester.pumpAndSettle();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
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
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ศัลยกรรม').last);
        await tester.tap(find.text('ศัลยกรรม').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 03/03/2026 (text input mode)
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
            await tester.enterText(dateTF.first, '03/03/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
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
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
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
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('สูติ-นรีเวช').last);
        await tester.tap(find.text('สูติ-นรีเวช').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/2030 (text input mode)
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
            await tester.enterText(dateTF.first, '01/15/2030');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 18:00
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
            await tester.enterText(dialogTF.first, '18');
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
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
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
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('สูติ-นรีเวช').last);
        await tester.tap(find.text('สูติ-นรีเวช').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 03/03/2026 (text input mode)
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
            await tester.enterText(dateTF.first, '03/03/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 14:30
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
            await tester.enterText(dialogTF.first, '14');
            await tester.pumpAndSettle();
          }
          if (dialogTF.evaluate().length >= 2) {
            await tester.tap(dialogTF.at(1));
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.at(1), '30');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_15', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('จักษุวิทยา').last);
        await tester.tap(find.text('จักษุวิทยา').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/2030 (text input mode)
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
            await tester.enterText(dateTF.first, '01/15/2030');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 14:30
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
            await tester.enterText(dialogTF.first, '14');
            await tester.pumpAndSettle();
          }
          if (dialogTF.evaluate().length >= 2) {
            await tester.tap(dialogTF.at(1));
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.at(1), '30');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_16', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('หู คอ จมูก').last);
        await tester.tap(find.text('หู คอ จมูก').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 03/03/2026 (text input mode)
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
            await tester.enterText(dateTF.first, '03/03/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 18:00
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
            await tester.enterText(dialogTF.first, '18');
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
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_17', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('อายุรกรรม').last);
        await tester.tap(find.text('อายุรกรรม').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 03/03/2026 (text input mode)
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
            await tester.enterText(dateTF.first, '03/03/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 18:00
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
            await tester.enterText(dialogTF.first, '18');
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
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_18', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('จักษุวิทยา').last);
        await tester.tap(find.text('จักษุวิทยา').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 03/03/2026 (text input mode)
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
            await tester.enterText(dateTF.first, '03/03/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
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
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.tap(find.byKey(const Key('appt_08_insurance_switch')));
        await tester.pump();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_19', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('หู คอ จมูก').last);
        await tester.tap(find.text('หู คอ จมูก').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/2030 (text input mode)
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
            await tester.enterText(dateTF.first, '01/15/2030');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 14:30
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
            await tester.enterText(dialogTF.first, '14');
            await tester.pumpAndSettle();
          }
          if (dialogTF.evaluate().length >= 2) {
            await tester.tap(dialogTF.at(1));
            await tester.pumpAndSettle();
            await tester.enterText(dialogTF.at(1), '30');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_20', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('หู คอ จมูก').last);
        await tester.tap(find.text('หู คอ จมูก').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 03/03/2026 (text input mode)
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
            await tester.enterText(dateTF.first, '03/03/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
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
        await tester.pump();
        await tester.pumpAndSettle();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('pairwise_valid_cases_21', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1102001234567');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0812345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('สูติ-นรีเวช').last);
        await tester.tap(find.text('สูติ-นรีเวช').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_06_date_textfield')));
        await tester.tap(find.byKey(const Key('appt_06_date_textfield')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/2030 (text input mode)
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
            await tester.enterText(dateTF.first, '01/15/2030');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
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
        await tester.pump();
        await tester.pumpAndSettle();
        // dataset: byKey.appt_09_note_textfield[0].valid
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

    });
    group('edge_cases', () {
      testWidgets('edge_cases_empty_all_fields', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
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
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '1234567890123');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '0987654321');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
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
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 03/03/2026 (text input mode)
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
            await tester.enterText(dateTF.first, '03/03/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
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
        await tester.pump();
        await tester.pumpAndSettle();
        // dataset: byKey.appt_09_note_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), 'คนไข้มีอาการปวดหัวเรื้อรัง');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_success')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

      testWidgets('edge_cases_boundary_at_min_length', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicAppointmentCubit>(create: (_)=> ClinicAppointmentCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicAppointmentPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.appt_01_patient_name_textfield[0].atMin
        await tester.enterText(find.byKey(const Key('appt_01_patient_name_textfield')), 'ส');
        await tester.pump();
        // dataset: byKey.appt_02_id_card_textfield[0].atMin
        await tester.enterText(find.byKey(const Key('appt_02_id_card_textfield')), '');
        await tester.pump();
        // dataset: byKey.appt_03_phone_textfield[0].atMin
        await tester.enterText(find.byKey(const Key('appt_03_phone_textfield')), '12345678');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.tap(find.byKey(const Key('appt_04_department_dropdown')));
        await tester.pump();
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
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 03/03/2026 (text input mode)
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
            await tester.enterText(dateTF.first, '03/03/2026');
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('appt_07_time_textfield')));
        await tester.tap(find.byKey(const Key('appt_07_time_textfield')));
        await tester.pump();
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
        await tester.pump();
        await tester.pumpAndSettle();
        // dataset: byKey.appt_09_note_textfield[0].atMin
        await tester.enterText(find.byKey(const Key('appt_09_note_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('appt_10_confirm_button')));
        await tester.tap(find.byKey(const Key('appt_10_confirm_button')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Check if any expected element exists (OR logic)
        final expected = [
          find.byKey(const Key('appt_10_expected_fail')),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

    });
  });
}
