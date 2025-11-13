// GENERATED — Integration tests for full flow
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/login_cubit.dart';
import 'package:master_project/cubit/login_state.dart';
import 'package:master_project/login/login_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('login_page.dart flow (integration)', () {
    group('edge_cases', () {
      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
          BlocProvider<LoginCubit>(create: (_)=> LoginCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: LoginPage()));
        await tester.pumpWidget(w);
        // Check if any expected element exists (OR logic)
        final expected = [
          find.text('Required'),
        ];
        expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue,
            reason: 'Expected at least one of the elements to exist');
      });

    });
  });
}
