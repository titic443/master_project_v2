// GENERATED — Integration tests for full flow
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/clinic_search_cubit.dart';
import 'package:master_project/demos/clinic_search_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('clinic_search_page.dart flow (integration)', () {
    group('pairwise_valid_invalid_cases', () {
      testWidgets('pairwise_valid_invalid_cases_1', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicSearchCubit>(create: (_)=> ClinicSearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicSearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_05_end_button')));
        await tester.tap(find.byKey(const Key('search_05_end_button')));
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

      testWidgets('pairwise_valid_invalid_cases_2', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicSearchCubit>(create: (_)=> ClinicSearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicSearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_patient_name_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_01_patient_name_textfield')), 'สxddasd');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_05_end_button')));
        await tester.tap(find.byKey(const Key('search_05_end_button')));
        await tester.pump();
        await tester.pumpAndSettle();
      });

    });
    group('pairwise_valid_cases', () {
      testWidgets('pairwise_valid_cases_1', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<ClinicSearchCubit>(create: (_)=> ClinicSearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicSearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_patient_name_textfield[0].valid
        await tester.enterText(find.byKey(const Key('search_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_05_end_button')));
        await tester.tap(find.byKey(const Key('search_05_end_button')));
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
          BlocProvider<ClinicSearchCubit>(create: (_)=> ClinicSearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicSearchPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('search_05_end_button')));
        await tester.tap(find.byKey(const Key('search_05_end_button')));
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
          BlocProvider<ClinicSearchCubit>(create: (_)=> ClinicSearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicSearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_patient_name_textfield[0].atMax
        await tester.enterText(find.byKey(const Key('search_01_patient_name_textfield')), 'สมชาย ใจดี');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_05_end_button')));
        await tester.tap(find.byKey(const Key('search_05_end_button')));
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
          BlocProvider<ClinicSearchCubit>(create: (_)=> ClinicSearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: ClinicSearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_patient_name_textfield[0].atMin
        await tester.enterText(find.byKey(const Key('search_01_patient_name_textfield')), '');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_05_end_button')));
        await tester.tap(find.byKey(const Key('search_05_end_button')));
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
