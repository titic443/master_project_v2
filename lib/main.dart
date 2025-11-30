import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/customer_cubit.dart';
import 'demos/customer_details_page.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CustomerCubit()),
      ],
      child: MaterialApp(
        title: 'Common Widgets Demo',
        home: const CustomerDetailsPage(),
      ),
    );
  }
}

