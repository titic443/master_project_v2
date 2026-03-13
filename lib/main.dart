import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/clinic_appointment_cubit.dart';
import 'cubit/clinic_search_cubit.dart';
import 'cubit/linkedin_cubit.dart';
import 'cubit/linkedin_search_cubit.dart';
import 'cubit/job_post_cubit.dart';
import 'cubit/job_search_cubit.dart';
import 'cubit/property_post_cubit.dart';
import 'cubit/property_search_cubit.dart';
import 'demos/clinic_appointment_page.dart';
import 'demos/clinic_search_page.dart';
import 'demos/linkedin_profile_page.dart';
import 'demos/linkedin_search_page.dart';
import 'demos/job_post_page.dart';
import 'demos/job_search_page.dart';
import 'demos/property_post_page.dart';
import 'demos/property_search_page.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Apps',
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
          'Demo Apps',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              // ── LinkedIn ────────────────────────────────────────────────
              _AppGroupHeader(
                title: 'LinkedIn',
                icon: Icons.work,
                color: Colors.indigo,
              ),
              const SizedBox(height: 12),
              _buildCard(
                context,
                title: 'LinkedIn Profile Registration',
                description: 'Register your professional profile',
                icon: Icons.person_add_outlined,
                color: Colors.indigo,
                onTap: () => _go(
                  context,
                  BlocProvider(
                    create: (_) => LinkedinCubit(),
                    child: const LinkedinProfilePage(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildCard(
                context,
                title: 'LinkedIn Profile Search',
                description: 'Search profiles by name or email',
                icon: Icons.manage_search,
                color: Colors.indigo,
                onTap: () => _go(
                  context,
                  BlocProvider(
                    create: (_) => LinkedinSearchCubit(),
                    child: const LinkedinSearchPage(),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ── Job Board ───────────────────────────────────────────────
              _AppGroupHeader(
                title: 'Job Board',
                icon: Icons.work_history_outlined,
                color: Colors.deepOrange,
              ),
              const SizedBox(height: 12),
              _buildCard(
                context,
                title: 'Post a Job',
                description: 'Create a job listing with full position details',
                icon: Icons.post_add,
                color: Colors.deepOrange,
                onTap: () => _go(
                  context,
                  BlocProvider(
                    create: (_) => JobPostCubit(),
                    child: const JobPostPage(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildCard(
                context,
                title: 'Find Jobs',
                description:
                    'Search listings by keyword, location, salary and more',
                icon: Icons.manage_search,
                color: Colors.deepOrange,
                onTap: () => _go(
                  context,
                  BlocProvider(
                    create: (_) => JobSearchCubit(),
                    child: const JobSearchPage(),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ── Clinic ──────────────────────────────────────────────────
              _AppGroupHeader(
                title: 'Clinic',
                icon: Icons.local_hospital_outlined,
                color: Colors.teal,
              ),
              const SizedBox(height: 12),
              _buildCard(
                context,
                title: 'นัดหมายแพทย์',
                description: 'จองคิวพบแพทย์ เลือกแผนก วันที่ และเวลา',
                icon: Icons.event_available_outlined,
                color: Colors.teal,
                onTap: () => _go(
                  context,
                  BlocProvider(
                    create: (_) => ClinicAppointmentCubit(),
                    child: const ClinicAppointmentPage(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildCard(
                context,
                title: 'ค้นหานัดหมาย',
                description: 'ค้นหาด้วยชื่อผู้ป่วย แผนก วันที่ หรือประเภทการนัด',
                icon: Icons.manage_search,
                color: Colors.teal,
                onTap: () => _go(
                  context,
                  BlocProvider(
                    create: (_) => ClinicSearchCubit(),
                    child: const ClinicSearchPage(),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ── Real Estate ─────────────────────────────────────────────
              _AppGroupHeader(
                title: 'Real Estate',
                icon: Icons.holiday_village_outlined,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 12),
              _buildCard(
                context,
                title: 'List a Property',
                description:
                    'Post a property listing with full details and pricing',
                icon: Icons.home_work_outlined,
                color: Colors.deepPurple,
                onTap: () => _go(
                  context,
                  BlocProvider(
                    create: (_) => PropertyPostCubit(),
                    child: const PropertyPostPage(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildCard(
                context,
                title: 'Find Properties',
                description:
                    'Search by location, type, price, bedrooms, area and more',
                icon: Icons.search,
                color: Colors.deepPurple,
                onTap: () => _go(
                  context,
                  BlocProvider(
                    create: (_) => PropertySearchCubit(),
                    child: const PropertySearchPage(),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 28, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      description,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  void _go(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}

class _AppGroupHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _AppGroupHeader({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(child: Divider()),
      ],
    );
  }
}
