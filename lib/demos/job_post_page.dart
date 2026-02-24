import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/job_post_cubit.dart';
import 'package:master_project/cubit/job_post_state.dart';

class JobPostPage extends StatelessWidget {
  const JobPostPage({super.key});

  static const route = '/job-post';

  @override
  Widget build(BuildContext context) => const _JobPostView();
}

// ─── Private View ─────────────────────────────────────────────────────────────

class _JobPostView extends StatefulWidget {
  const _JobPostView();

  @override
  State<_JobPostView> createState() => _JobPostViewState();
}

class _JobPostViewState extends State<_JobPostView> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _salaryMinCtrl = TextEditingController();
  final _salaryMaxCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _skillsCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _companyCtrl.dispose();
    _locationCtrl.dispose();
    _salaryMinCtrl.dispose();
    _salaryMaxCtrl.dispose();
    _descCtrl.dispose();
    _skillsCtrl.dispose();
    super.dispose();
  }

  void _sync(JobPostState state) {
    if (_titleCtrl.text != state.title) _titleCtrl.text = state.title;
    if (_companyCtrl.text != state.company) _companyCtrl.text = state.company;
    if (_locationCtrl.text != state.location) {
      _locationCtrl.text = state.location;
    }
    if (_salaryMinCtrl.text != state.salaryMin) {
      _salaryMinCtrl.text = state.salaryMin;
    }
    if (_salaryMaxCtrl.text != state.salaryMax) {
      _salaryMaxCtrl.text = state.salaryMax;
    }
    if (_descCtrl.text != state.description) {
      _descCtrl.text = state.description;
    }
    if (_skillsCtrl.text != state.skills) _skillsCtrl.text = state.skills;
  }

  void _onSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          key: Key('job_12_expected_fail'),
          content: Text('Please correct the highlighted fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    context.read<JobPostCubit>().submit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Post a Job',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<JobPostCubit, JobPostState>(
        listenWhen: (prev, curr) =>
            prev.status == JobPostStatus.loading &&
            curr.status != JobPostStatus.loading,
        listener: (context, state) {
          if (state.status == JobPostStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                key: Key('job_12_expected_success'),
                content: Text('Job posted successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state.status == JobPostStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                key: const Key('job_12_expected_fail'),
                content: Text(state.errorMessage ?? 'Failed to post job'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          _sync(state);
          final cubit = context.read<JobPostCubit>();
          final isLoading = state.status == JobPostStatus.loading;

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
              children: [
                // ── Section 1: Job Information ───────────────────────────
                const _SectionHeader(
                  title: 'Job Information',
                  icon: Icons.work_outline,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('job_01_title_textfield'),
                  controller: _titleCtrl,
                  decoration: _dec(
                    label: 'Job Title',
                    hint: 'e.g. Senior Flutter Developer',
                    icon: Icons.title,
                  ),
                  textCapitalization: TextCapitalization.words,
                  onChanged: cubit.onTitleChanged,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (v.trim().length < 3) return 'At least 3 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  key: const Key('job_02_company_textfield'),
                  controller: _companyCtrl,
                  decoration: _dec(
                    label: 'Company Name',
                    hint: 'e.g. Acme Corporation',
                    icon: Icons.business_outlined,
                  ),
                  textCapitalization: TextCapitalization.words,
                  onChanged: cubit.onCompanyChanged,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (v.trim().length < 2) return 'At least 2 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  key: const Key('job_03_location_textfield'),
                  controller: _locationCtrl,
                  decoration: _dec(
                    label: 'Location',
                    hint: 'e.g. Bangkok, Thailand',
                    icon: Icons.location_on_outlined,
                  ),
                  onChanged: cubit.onLocationChanged,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (v.trim().length < 2) return 'At least 2 characters';
                    return null;
                  },
                ),

                // ── Section 2: Role Details ──────────────────────────────
                const SizedBox(height: 28),
                const _SectionHeader(
                  title: 'Role Details',
                  icon: Icons.category_outlined,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  key: const Key('job_04_category_dropdown'),
                  value: state.category,
                  decoration: _dec(
                    label: 'Job Category',
                    icon: Icons.category_outlined,
                  ),
                  hint: const Text('Select category'),
                  items: const [
                    DropdownMenuItem(value: 'IT & Tech', child: Text('IT & Tech')),
                    DropdownMenuItem(value: 'Finance', child: Text('Finance')),
                    DropdownMenuItem(value: 'Marketing', child: Text('Marketing')),
                    DropdownMenuItem(value: 'Engineering', child: Text('Engineering')),
                    DropdownMenuItem(value: 'Healthcare', child: Text('Healthcare')),
                    DropdownMenuItem(value: 'Education', child: Text('Education')),
                  ],
                  onChanged: cubit.onCategoryChanged,
                  validator: (v) => v == null ? 'Required' : null,
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  key: const Key('job_05_type_dropdown'),
                  value: state.employmentType,
                  decoration: _dec(
                    label: 'Employment Type',
                    icon: Icons.badge_outlined,
                  ),
                  hint: const Text('Select type'),
                  items: const [
                    DropdownMenuItem(value: 'Full-time', child: Text('Full-time')),
                    DropdownMenuItem(value: 'Part-time', child: Text('Part-time')),
                    DropdownMenuItem(value: 'Contract', child: Text('Contract')),
                    DropdownMenuItem(value: 'Freelance', child: Text('Freelance')),
                    DropdownMenuItem(value: 'Internship', child: Text('Internship')),
                  ],
                  onChanged: cubit.onEmploymentTypeChanged,
                  validator: (v) => v == null ? 'Required' : null,
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  key: const Key('job_06_exp_dropdown'),
                  value: state.experienceLevel,
                  decoration: _dec(
                    label: 'Experience Level',
                    icon: Icons.stairs_outlined,
                  ),
                  hint: const Text('Select experience'),
                  items: const [
                    DropdownMenuItem(value: 'Entry Level', child: Text('Entry Level')),
                    DropdownMenuItem(value: 'Junior', child: Text('Junior')),
                    DropdownMenuItem(value: 'Mid-Level', child: Text('Mid-Level')),
                    DropdownMenuItem(value: 'Senior', child: Text('Senior')),
                  ],
                  onChanged: cubit.onExperienceLevelChanged,
                  validator: (v) => v == null ? 'Required' : null,
                ),

                // ── Section 3: Compensation ──────────────────────────────
                const SizedBox(height: 28),
                const _SectionHeader(
                  title: 'Compensation',
                  icon: Icons.payments_outlined,
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        key: const Key('job_07_salary_min_textfield'),
                        controller: _salaryMinCtrl,
                        decoration: _dec(
                          label: 'Min Salary (THB)',
                          hint: '25000',
                          icon: Icons.south_outlined,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: cubit.onSalaryMinChanged,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          if (int.tryParse(v) == null) return 'Invalid';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        key: const Key('job_08_salary_max_textfield'),
                        controller: _salaryMaxCtrl,
                        decoration: _dec(
                          label: 'Max Salary (THB)',
                          hint: '50000',
                          icon: Icons.north_outlined,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: cubit.onSalaryMaxChanged,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          final max = int.tryParse(v);
                          if (max == null) return 'Invalid';
                          final min = int.tryParse(_salaryMinCtrl.text);
                          if (min != null && max < min) return 'Must be ≥ min';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 0,
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.home_work_outlined,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Remote Friendly',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Allow candidates to work remotely',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          key: const Key('job_11_remote_switch'),
                          value: state.isRemote,
                          onChanged: cubit.onIsRemoteChanged,
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Section 4: Job Details ───────────────────────────────
                const SizedBox(height: 28),
                const _SectionHeader(
                  title: 'Job Details',
                  icon: Icons.description_outlined,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('job_09_desc_textfield'),
                  controller: _descCtrl,
                  decoration: _dec(
                    label: 'Job Description',
                    hint:
                        'Describe responsibilities, qualifications, and benefits...',
                    icon: Icons.description_outlined,
                  ),
                  maxLines: 5,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: cubit.onDescriptionChanged,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (v.trim().length < 20) return 'At least 20 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  key: const Key('job_10_skills_textfield'),
                  controller: _skillsCtrl,
                  decoration: _dec(
                    label: 'Required Skills',
                    hint: 'e.g. Flutter, Dart, Firebase, REST API',
                    icon: Icons.code_outlined,
                  ),
                  onChanged: cubit.onSkillsChanged,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (v.trim().length < 2) return 'At least 2 characters';
                    return null;
                  },
                ),

                // ── Submit ───────────────────────────────────────────────
                const SizedBox(height: 36),
                ElevatedButton(
                  key: const Key('job_12_end_button'),
                  onPressed: isLoading ? null : () => _onSubmit(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.send_rounded),
                            SizedBox(width: 8),
                            Text(
                              'Post Job',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

InputDecoration _dec({
  required String label,
  String? hint,
  required IconData icon,
}) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
    hintText: hint,
    hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
    prefixIcon: Icon(icon),
    border: const OutlineInputBorder(),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
  );
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.deepOrange),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(child: Divider()),
      ],
    );
  }
}
