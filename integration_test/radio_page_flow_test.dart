// GENERATED — Integration tests for full flow
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:master_project/widgets/radio_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('radio_page.dart flow (integration)', () {
    group('edge_cases', () {
      testWidgets('case', (tester) async {
        final providers = <BlocProvider>[
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: RadioDemo()));
        await tester.pumpWidget(w);
      });

    });
  });
}
