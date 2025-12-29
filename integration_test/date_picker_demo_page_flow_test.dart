// GENERATED — Integration tests for full flow
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/widgets/date_picker_demo_cubit.dart';
import 'package:master_project/cubit/datepickerdemo_state.dart';
import 'package:master_project/widgets/date_picker_demo_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('date_picker_demo_page.dart flow (integration)', () {
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
