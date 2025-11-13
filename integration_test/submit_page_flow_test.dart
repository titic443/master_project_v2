// GENERATED — Integration tests for full flow
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/submit_cubit.dart';
import 'package:master_project/cubit/submit_state.dart';
import 'package:master_project/submit/submit_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('submit_page.dart flow (integration)', () {
    group('edge_cases', () {
      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<SubmitCubit>(create: (_)=> SubmitCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: SubmitPage()));
        await tester.pumpWidget(w);
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Required'),
          find.text('กรุณาเลือกหมวดหมู่'),
          find.text('กรุณาเลือกระดับความสำคัญ'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

    });
  });
}
