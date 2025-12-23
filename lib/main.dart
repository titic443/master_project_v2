import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/customer_cubit.dart';
import 'cubit/product_cubit.dart';
import 'cubit/employee_cubit.dart';
import 'demos/customer_details_page.dart';
import 'demos/product_registration_page.dart';
import 'demos/employee_survey_page.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Demos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Form Demos',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Select a Form to Test',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              _buildFormCard(
                context,
                title: '1. Customer Details Form',
                description: 'Customer registration with personal information',
                icon: Icons.person_add,
                color: Colors.blue,
                onTap: () => _navigateToPage(
                  context,
                  BlocProvider(
                    create: (_) => CustomerCubit(),
                    child: const CustomerDetailsPage(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildFormCard(
                context,
                title: '2. Product Registration Form',
                description: 'Register new products with SKU and pricing',
                icon: Icons.inventory_2,
                color: Colors.green,
                onTap: () => _navigateToPage(
                  context,
                  BlocProvider(
                    create: (_) => ProductCubit(),
                    child: const ProductRegistrationPage(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildFormCard(
                context,
                title: '3. Employee Survey Form',
                description: 'Employee satisfaction survey and feedback',
                icon: Icons.poll,
                color: Colors.orange,
                onTap: () => _navigateToPage(
                  context,
                  BlocProvider(
                    create: (_) => EmployeeCubit(),
                    child: const EmployeeSurveyPage(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }
}

