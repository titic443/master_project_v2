import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/register_cubit.dart';
import 'package:master_project/cubit/login_cubit.dart';
import 'package:master_project/cubit/submit_cubit.dart';
import 'package:master_project/cubit/customer_cubit.dart';
import 'package:master_project/demos/customer_details_page.dart';
import 'register/register_page.dart';
import 'login/login_page.dart';
import 'submit/submit_page.dart';
import 'dashboard/dashboard_page.dart';

// Widget demos
import 'widgets/text_field_page.dart';
import 'widgets/text_form_field_page.dart';
import 'widgets/form_field_page.dart';
import 'widgets/radio_page.dart';
import 'widgets/elevated_button_page.dart';
import 'widgets/text_button_page.dart';
import 'widgets/outlined_button_page.dart';
import 'widgets/icon_button_page.dart';
import 'widgets/text_page.dart';
import 'widgets/dropdown_button_page.dart';
import 'widgets/dropdown_button_form_field_page.dart';
import 'widgets/checkbox_widget_page.dart';
import 'widgets/switch_page.dart';
import 'widgets/visibility_page.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => RegisterCubit()),
          BlocProvider(create: (_) => LoginCubit()),
          BlocProvider(create: (_) => SubmitCubit()),
          BlocProvider(create: (_) => CustomerCubit()),
        ],
        child: MaterialApp(
          title: 'Common Widgets Demo',
          home: const CustomerDetailsPage(),
          // routes: {
          //   CustomerDetailsPage.route: (_) => const CustomerDetailsPage()
          // },
        ));
  }
}

class DemoHome extends StatelessWidget {
  const DemoHome({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_Nav>[
      _Nav('Customer Details Form', (_) => const CustomerDetailsPage()),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Common Widgets Demo')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (_, i) => ListTile(
          key: Key('home_nav_$i'),
          title: Text(items[i].label),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: items[i].builder),
          ),
        ),
      ),
    );
  }
}

class _Nav {
  final String label;
  final WidgetBuilder builder;
  _Nav(this.label, this.builder);
}
