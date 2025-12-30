// GENERATED — Integration tests for full flow
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/widgets/date_picker_demo_cubit.dart';
import 'package:master_project//Users/70009215/Desktop/101/master_project_v2/lib/widgets/date_picker_demo_page.dart';

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
        await tester.ensureVisible(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.tap(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.pump();
        await tester.tap(find.text('null'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.tap(find.text('future_date'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.tap(find.text('future_date'));
        await tester.pump();
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
        await tester.tap(find.text('today'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.tap(find.text('future_date'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.tap(find.text('today'));
        await tester.pump();
        await tester.pump();
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
        await tester.tap(find.text('null'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.tap(find.text('null'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.tap(find.text('null'));
        await tester.pump();
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
        await tester.tap(find.text('today'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.tap(find.text('today'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.tap(find.text('null'));
        await tester.pump();
        await tester.pump();
      });

      testWidgets('pairwise_valid_invalid_cases_5', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.tap(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.pump();
        await tester.tap(find.text('today'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.tap(find.text('null'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.tap(find.text('future_date'));
        await tester.pump();
        await tester.pump();
      });

      testWidgets('pairwise_valid_invalid_cases_6', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.tap(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.pump();
        await tester.tap(find.text('past_date'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.tap(find.text('future_date'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.tap(find.text('null'));
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
        await tester.tap(find.text('null'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.tap(find.text('today'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.tap(find.text('today'));
        await tester.pump();
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
        await tester.tap(find.text('past_date'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.tap(find.text('today'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.tap(find.text('future_date'));
        await tester.pump();
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
        await tester.tap(find.text('past_date'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.tap(find.text('null'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.tap(find.text('today'));
        await tester.pump();
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
        await tester.ensureVisible(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.tap(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.pump();
        await tester.tap(find.text('null'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.tap(find.text('future_date'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.tap(find.text('future_date'));
        await tester.pump();
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
        await tester.tap(find.text('today'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.tap(find.text('future_date'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.tap(find.text('today'));
        await tester.pump();
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
        await tester.tap(find.text('null'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.tap(find.text('null'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.tap(find.text('null'));
        await tester.pump();
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
        await tester.tap(find.text('today'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.tap(find.text('today'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.tap(find.text('null'));
        await tester.pump();
        await tester.pump();
      });

      testWidgets('pairwise_valid_cases_5', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.tap(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.pump();
        await tester.tap(find.text('today'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.tap(find.text('null'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.tap(find.text('future_date'));
        await tester.pump();
        await tester.pump();
      });

      testWidgets('pairwise_valid_cases_6', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<DatePickerDemoCubit>(create: (_)=> DatePickerDemoCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: DatePickerDemoPage()));
        await tester.pumpWidget(w);
        await tester.ensureVisible(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.tap(find.byKey(const Key('datepicker_01_birthdate_tile')));
        await tester.pump();
        await tester.tap(find.text('past_date'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.tap(find.text('future_date'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.tap(find.text('null'));
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
        await tester.tap(find.text('null'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.tap(find.text('today'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.tap(find.text('today'));
        await tester.pump();
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
        await tester.tap(find.text('past_date'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.tap(find.text('today'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.tap(find.text('future_date'));
        await tester.pump();
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
        await tester.tap(find.text('past_date'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.tap(find.byKey(const Key('datepicker_02_appointment_date_tile')));
        await tester.pump();
        await tester.tap(find.text('null'));
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.tap(find.byKey(const Key('datepicker_03_appointment_time_tile')));
        await tester.pump();
        await tester.tap(find.text('today'));
        await tester.pump();
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
