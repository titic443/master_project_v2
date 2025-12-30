// GENERATED — Integration tests for full flow
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/widgets/date_picker_demo_cubit.dart';
import 'package:master_project/widgets/date_picker_demo_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('date_picker_demo_page.dart flow (integration)', () {
    group('pairwise_valid_invalid_cases', () {
      testWidgets('pairwise_valid_invalid_cases_1', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
        // Skip tap for 'datepicker_01_birthdate_tile' (next action is null/cancel)
        // Skip date selection (null/cancel)
        await tester.pump();
        // Skip tap for 'datepicker_02_appointment_date_tile' (next action is null/cancel)
        // Skip date selection (null/cancel)
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 14:30
        await tester.tap(find.text('14').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('30').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pump();
      });

      testWidgets('pairwise_valid_invalid_cases_2', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.tap(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/1901
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 1901
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('1901')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('1901'))) {
            await tester.tap(find.text('1901'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Jan
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Jan')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/12/2026
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 2026
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('2026')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('2026'))) {
            await tester.tap(find.text('2026'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Dec
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Dec')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        // await tester.pumpAndSettle();
        // await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        // await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        // await tester.pump();
        // await tester.pumpAndSettle();
        // // Select time: 18:00
        // await tester.tap(find.text('18').first);
        // await tester.pumpAndSettle();
        // await tester.tap(find.text('00').first);
        // await tester.pumpAndSettle();
        // await tester.tap(find.text('OK'));
        // await tester.pump();
        // await tester.pumpAndSettle();
        // await tester.pump();
      });

      testWidgets('pairwise_valid_invalid_cases_3', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.tap(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/1901
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 1901
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('1901')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('1901'))) {
            await tester.tap(find.text('1901'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Jan
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Jan')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/06/2025
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 2025
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('2025')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('2025'))) {
            await tester.tap(find.text('2025'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Jun
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Jun')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 09:00
        await tester.tap(find.text('09').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('00').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pump();
      });

      testWidgets('pairwise_valid_invalid_cases_4', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.tap(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/06/1962
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 1962
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('1962')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('1962'))) {
            await tester.tap(find.text('1962'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Jun
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Jun')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/06/2025
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 2025
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('2025')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('2025'))) {
            await tester.tap(find.text('2025'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Jun
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Jun')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 18:00
        await tester.tap(find.text('18').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('00').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pump();
      });

      testWidgets('pairwise_valid_invalid_cases_5', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
        // Skip tap for 'datepicker_01_birthdate_tile' (next action is null/cancel)
        // Skip date selection (null/cancel)
        await tester.pump();
        // Skip tap for 'datepicker_02_appointment_date_tile' (next action is null/cancel)
        // Skip date selection (null/cancel)
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 18:00
        await tester.tap(find.text('18').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('00').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pump();
      });

      testWidgets('pairwise_valid_invalid_cases_6', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
        // Skip tap for 'datepicker_01_birthdate_tile' (next action is null/cancel)
        // Skip date selection (null/cancel)
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/06/2025
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 2025
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('2025')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('2025'))) {
            await tester.tap(find.text('2025'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Jun
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Jun')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        // Skip tap for 'datepicker_03_appointment_time_tile' (next action is null/cancel)
        // Skip time selection (null/cancel)
        await tester.pump();
        await tester.pump();
      });

      testWidgets('pairwise_valid_invalid_cases_7', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.tap(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/06/1962
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 1962
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('1962')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('1962'))) {
            await tester.tap(find.text('1962'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Jun
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Jun')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/12/2026
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 2026
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('2026')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('2026'))) {
            await tester.tap(find.text('2026'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Dec
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Dec')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 09:00
        await tester.tap(find.text('09').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('00').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pump();
      });

      testWidgets('pairwise_valid_invalid_cases_8', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.tap(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/1901
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 1901
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('1901')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('1901'))) {
            await tester.tap(find.text('1901'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Jan
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Jan')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/12/2026
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 2026
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('2026')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('2026'))) {
            await tester.tap(find.text('2026'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Dec
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Dec')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 14:30
        await tester.tap(find.text('14').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('30').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pump();
      });

      testWidgets('pairwise_valid_invalid_cases_9', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.tap(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/1901
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 1901
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('1901')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('1901'))) {
            await tester.tap(find.text('1901'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Jan
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Jan')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/12/2026
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 2026
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('2026')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('2026'))) {
            await tester.tap(find.text('2026'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Dec
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Dec')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        // Skip tap for 'datepicker_03_appointment_time_tile' (next action is null/cancel)
        // Skip time selection (null/cancel)
        await tester.pump();
        await tester.pump();
      });

      testWidgets('pairwise_valid_invalid_cases_10', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.tap(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/06/1962
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 1962
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('1962')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('1962'))) {
            await tester.tap(find.text('1962'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Jun
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Jun')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/06/2025
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 2025
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('2025')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('2025'))) {
            await tester.tap(find.text('2025'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Jun
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Jun')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 14:30
        await tester.tap(find.text('14').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('30').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pump();
      });

      testWidgets('pairwise_valid_invalid_cases_11', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
        // Skip tap for 'datepicker_01_birthdate_tile' (next action is null/cancel)
        // Skip date selection (null/cancel)
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/12/2026
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 2026
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('2026')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('2026'))) {
            await tester.tap(find.text('2026'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Dec
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Dec')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 09:00
        await tester.tap(find.text('09').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('00').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pump();
      });

      testWidgets('pairwise_valid_invalid_cases_12', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.tap(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/1901
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 1901
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('1901')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('1901'))) {
            await tester.tap(find.text('1901'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Jan
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Jan')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        // Skip tap for 'datepicker_02_appointment_date_tile' (next action is null/cancel)
        // Skip date selection (null/cancel)
        await tester.pump();
        // Skip tap for 'datepicker_03_appointment_time_tile' (next action is null/cancel)
        // Skip time selection (null/cancel)
        await tester.pump();
        await tester.pump();
      });

      testWidgets('pairwise_valid_invalid_cases_13', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.tap(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/06/1962
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 1962
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('1962')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('1962'))) {
            await tester.tap(find.text('1962'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Jun
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Jun')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        // Skip tap for 'datepicker_02_appointment_date_tile' (next action is null/cancel)
        // Skip date selection (null/cancel)
        await tester.pump();
        // Skip tap for 'datepicker_03_appointment_time_tile' (next action is null/cancel)
        // Skip time selection (null/cancel)
        await tester.pump();
        await tester.pump();
      });

      testWidgets('pairwise_valid_invalid_cases_14', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
        // Skip tap for 'datepicker_01_birthdate_tile' (next action is null/cancel)
        // Skip date selection (null/cancel)
        await tester.pump();
        // Skip tap for 'datepicker_02_appointment_date_tile' (next action is null/cancel)
        // Skip date selection (null/cancel)
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 09:00
        await tester.tap(find.text('09').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('00').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pump();
      });

    });
    group('pairwise_valid_cases', () {
      testWidgets('pairwise_valid_cases_1', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
        // Skip tap for 'datepicker_01_birthdate_tile' (next action is null/cancel)
        // Skip date selection (null/cancel)
        await tester.pump();
        // Skip tap for 'datepicker_02_appointment_date_tile' (next action is null/cancel)
        // Skip date selection (null/cancel)
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 14:30
        await tester.tap(find.text('14').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('30').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pump();
      });

      testWidgets('pairwise_valid_cases_2', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.tap(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/1901
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 1901
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('1901')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('1901'))) {
            await tester.tap(find.text('1901'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Jan
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Jan')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/12/2026
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 2026
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('2026')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('2026'))) {
            await tester.tap(find.text('2026'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Dec
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Dec')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 18:00
        await tester.tap(find.text('18').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('00').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pump();
      });

      testWidgets('pairwise_valid_cases_3', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.tap(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/1901
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 1901
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('1901')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('1901'))) {
            await tester.tap(find.text('1901'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Jan
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Jan')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/06/2025
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 2025
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('2025')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('2025'))) {
            await tester.tap(find.text('2025'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Jun
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Jun')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 09:00
        await tester.tap(find.text('09').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('00').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pump();
      });

      testWidgets('pairwise_valid_cases_4', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.tap(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/06/1962
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 1962
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('1962')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('1962'))) {
            await tester.tap(find.text('1962'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Jun
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Jun')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/06/2025
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 2025
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('2025')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('2025'))) {
            await tester.tap(find.text('2025'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Jun
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Jun')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 18:00
        await tester.tap(find.text('18').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('00').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pump();
      });

      testWidgets('pairwise_valid_cases_5', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
        // Skip tap for 'datepicker_01_birthdate_tile' (next action is null/cancel)
        // Skip date selection (null/cancel)
        await tester.pump();
        // Skip tap for 'datepicker_02_appointment_date_tile' (next action is null/cancel)
        // Skip date selection (null/cancel)
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 18:00
        await tester.tap(find.text('18').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('00').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pump();
      });

      testWidgets('pairwise_valid_cases_6', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
        // Skip tap for 'datepicker_01_birthdate_tile' (next action is null/cancel)
        // Skip date selection (null/cancel)
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/06/2025
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 2025
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('2025')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('2025'))) {
            await tester.tap(find.text('2025'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Jun
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Jun')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        // Skip tap for 'datepicker_03_appointment_time_tile' (next action is null/cancel)
        // Skip time selection (null/cancel)
        await tester.pump();
        await tester.pump();
      });

      testWidgets('pairwise_valid_cases_7', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.tap(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/06/1962
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 1962
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('1962')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('1962'))) {
            await tester.tap(find.text('1962'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Jun
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Jun')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/12/2026
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 2026
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('2026')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('2026'))) {
            await tester.tap(find.text('2026'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Dec
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Dec')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 09:00
        await tester.tap(find.text('09').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('00').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pump();
      });

      testWidgets('pairwise_valid_cases_8', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.tap(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/1901
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 1901
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('1901')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('1901'))) {
            await tester.tap(find.text('1901'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Jan
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Jan')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/12/2026
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 2026
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('2026')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('2026'))) {
            await tester.tap(find.text('2026'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Dec
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Dec')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 14:30
        await tester.tap(find.text('14').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('30').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pump();
      });

      testWidgets('pairwise_valid_cases_9', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.tap(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/1901
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 1901
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('1901')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('1901'))) {
            await tester.tap(find.text('1901'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Jan
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Jan')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/12/2026
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 2026
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('2026')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('2026'))) {
            await tester.tap(find.text('2026'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Dec
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Dec')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        // Skip tap for 'datepicker_03_appointment_time_tile' (next action is null/cancel)
        // Skip time selection (null/cancel)
        await tester.pump();
        await tester.pump();
      });

      testWidgets('pairwise_valid_cases_10', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.tap(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/06/1962
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 1962
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('1962')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('1962'))) {
            await tester.tap(find.text('1962'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Jun
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Jun')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/06/2025
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 2025
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('2025')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('2025'))) {
            await tester.tap(find.text('2025'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Jun
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Jun')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 14:30
        await tester.tap(find.text('14').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('30').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pump();
      });

      testWidgets('pairwise_valid_cases_11', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
        // Skip tap for 'datepicker_01_birthdate_tile' (next action is null/cancel)
        // Skip date selection (null/cancel)
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/12/2026
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 2026
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('2026')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('2026'))) {
            await tester.tap(find.text('2026'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Dec
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Dec')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 09:00
        await tester.tap(find.text('09').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('00').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pump();
      });

      testWidgets('pairwise_valid_cases_12', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.tap(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/01/1901
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 1901
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('1901')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('1901'))) {
            await tester.tap(find.text('1901'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Jan
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Jan')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        // Skip tap for 'datepicker_02_appointment_date_tile' (next action is null/cancel)
        // Skip date selection (null/cancel)
        await tester.pump();
        // Skip tap for 'datepicker_03_appointment_time_tile' (next action is null/cancel)
        // Skip time selection (null/cancel)
        await tester.pump();
        await tester.pump();
      });

      testWidgets('pairwise_valid_cases_13', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.tap(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select date: 15/06/1962
        {
          // Wait for DatePicker to appear
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
          // Find and tap the year in header (e.g., '202x') to open year picker
          final yearInHeader = find.byWidgetPredicate(
            (widget) => widget is Text && (widget.data ?? '').contains('202'),
          );
          if (tester.any(yearInHeader)) {
            await tester.tap(yearInHeader.first);
            await tester.pumpAndSettle();
          }
          // Wait until year picker is fully loaded (check for year items)
          int waitAttempts = 0;
          while (waitAttempts < 50) {
            await tester.pump(const Duration(milliseconds: 50));
            // Check if year picker has loaded by finding any 4-digit year
            final yearItems = find.byWidgetPredicate(
              (w) => w is Text && RegExp(r'^\d{4}$').hasMatch(w.data ?? ''),
            );
            if (tester.any(yearItems)) {
              // Found year items, picker is ready
              await tester.pumpAndSettle();
              break;
            }
            waitAttempts++;
          }
          // Scroll to find year 1962
          int scrollAttempts = 0;
          bool scrollingUp = true; // Start by scrolling up
          while (!tester.any(find.text('1962')) && scrollAttempts < 30) {
            final scrollable = find.byType(Scrollable);
            if (tester.any(scrollable)) {
              // Try scrolling up first (for older years), then down
              final offset = scrollingUp ? const Offset(0, -300) : const Offset(0, 300);
              await tester.drag(scrollable.first, offset);
              await tester.pumpAndSettle();
              // After 15 attempts scrolling up, try scrolling down
              if (scrollAttempts == 15) scrollingUp = false;
            }
            scrollAttempts++;
          }
          // Tap the year
          if (tester.any(find.text('1962'))) {
            await tester.tap(find.text('1962'), warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Navigate to Jun
        {
          int monthNavAttempts = 0;
          while (!tester.any(find.textContaining('Jun')) && monthNavAttempts < 12) {
            if (tester.any(find.byIcon(Icons.chevron_right))) {
              await tester.tap(find.byIcon(Icons.chevron_right));
              await tester.pumpAndSettle();
            }
            monthNavAttempts++;
          }
        }
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        // Skip tap for 'datepicker_02_appointment_date_tile' (next action is null/cancel)
        // Skip date selection (null/cancel)
        await tester.pump();
        // Skip tap for 'datepicker_03_appointment_time_tile' (next action is null/cancel)
        // Skip time selection (null/cancel)
        await tester.pump();
        await tester.pump();
      });

      testWidgets('pairwise_valid_cases_14', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
        // Skip tap for 'datepicker_01_birthdate_tile' (next action is null/cancel)
        // Skip date selection (null/cancel)
        await tester.pump();
        // Skip tap for 'datepicker_02_appointment_date_tile' (next action is null/cancel)
        // Skip date selection (null/cancel)
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.pumpAndSettle();
        // Select time: 09:00
        await tester.tap(find.text('09').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('00').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pump();
        await tester.pumpAndSettle();
        await tester.pump();
      });

    });
    group('edge_cases', () {
      testWidgets('edge_cases_empty_all_fields', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
      });

    });
  });
}
