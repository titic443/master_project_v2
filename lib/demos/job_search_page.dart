import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/job_search_cubit.dart';
import 'package:master_project/cubit/job_search_state.dart';

class JobSearchPage extends StatelessWidget {
  const JobSearchPage({super.key});

  static const route = '/job-search';

  @override
  Widget build(BuildContext context) => const _JobSearchView();
}

// ─── Private View ─────────────────────────────────────────────────────────────

class _JobSearchView extends StatefulWidget {
  const _JobSearchView();

  @override
  State<_JobSearchView> createState() => _JobSearchViewState();
}

class _JobSearchViewState extends State<_JobSearchView> {
  final _keywordCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _salaryMinCtrl = TextEditingController();

  @override
  void dispose() {
    _keywordCtrl.dispose();
    _locationCtrl.dispose();
    _salaryMinCtrl.dispose();
    super.dispose();
  }

  void _sync(JobSearchState state) {
    if (_keywordCtrl.text != state.keyword) _keywordCtrl.text = state.keyword;
    if (_locationCtrl.text != state.location) {
      _locationCtrl.text = state.location;
    }
    if (_salaryMinCtrl.text != state.salaryMin) {
      _salaryMinCtrl.text = state.salaryMin;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ค้นหางาน',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<JobSearchCubit, JobSearchState>(
        listenWhen: (prev, curr) =>
            prev.status == JobSearchStatus.loading &&
            curr.status != JobSearchStatus.loading,
        listener: (context, state) {
          if (state.status == JobSearchStatus.success) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                key: const Key('search_01_expected_success'),
                title: const Text('ค้นหาสำเร็จ'),
                content: Text('พบ ${state.jobs.length} ตำแหน่งงาน'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          } else if (state.status == JobSearchStatus.error ||
              state.status == JobSearchStatus.empty) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                key: const Key('search_01_expected_fail'),
                title: const Text('ค้นหาไม่สำเร็จ'),
                content: Text(
                  state.status == JobSearchStatus.empty
                      ? 'ไม่พบตำแหน่งงานที่ตรงกับเงื่อนไข'
                      : state.errorMessage ?? 'ค้นหาไม่สำเร็จ',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        },
        builder: (context, state) {
          _sync(state);
          return Column(
            children: [
              _SearchPanel(
                keywordCtrl: _keywordCtrl,
                locationCtrl: _locationCtrl,
                salaryMinCtrl: _salaryMinCtrl,
                state: state,
              ),
              const Divider(height: 1),
              Expanded(child: _ResultSection(state: state)),
            ],
          );
        },
      ),
    );
  }
}

// ─── Search Panel ─────────────────────────────────────────────────────────────

class _SearchPanel extends StatelessWidget {
  final TextEditingController keywordCtrl;
  final TextEditingController locationCtrl;
  final TextEditingController salaryMinCtrl;
  final JobSearchState state;

  const _SearchPanel({
    required this.keywordCtrl,
    required this.locationCtrl,
    required this.salaryMinCtrl,
    required this.state,
  });

  InputDecoration _searchDec({
    required String label,
    String? hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
      prefixIcon: Icon(icon, size: 18),
      border: const OutlineInputBorder(),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<JobSearchCubit>();
    final isLoading = state.status == JobSearchStatus.loading;

    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Row 1: Keyword + Location
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  key: const Key('search_01_keyword_textfield'),
                  controller: keywordCtrl,
                  style: const TextStyle(fontSize: 14),
                  decoration: _searchDec(
                    label: 'ตำแหน่งงาน / คีย์เวิร์ด',
                    hint: 'เช่น นักพัฒนา Flutter, นักวิเคราะห์ข้อมูล',
                    icon: Icons.search,
                  ),
                  onChanged: cubit.onKeywordChanged,
                  onSubmitted: (_) => cubit.search(),
                ),
              ),
              // const SizedBox(width: 10),
              // Expanded(
              //   flex: 2,
              //   child: TextField(
              //     key: const Key('search_02_location_textfield'),
              //     controller: locationCtrl,
              //     style: const TextStyle(fontSize: 14),
              //     autocorrect: false,
              //     enableSuggestions: false,
              //     decoration: _searchDec(
              //       label: 'สถานที่',
              //       hint: 'กรุงเทพฯ, เชียงใหม่',
              //       icon: Icons.location_on_outlined,
              //     ),
              //     onChanged: cubit.onLocationChanged,
              //     onSubmitted: (_) => cubit.search(),
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 10),

          // Row 2: Category + Employment Type
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  key: const Key('search_02_category_dropdown'),
                  value: state.category,
                  decoration: _searchDec(
                    label: 'หมวดหมู่งาน',
                    icon: Icons.category_outlined,
                  ),
                  hint: const Text('ทั้งหมด', style: TextStyle(fontSize: 13)),
                  items: const [
                    DropdownMenuItem(
                        value: 'IT & Tech',
                        child:
                            Text('IT & Tech', style: TextStyle(fontSize: 13))),
                    DropdownMenuItem(
                        value: 'Finance',
                        child: Text('Finance', style: TextStyle(fontSize: 13))),
                    DropdownMenuItem(
                        value: 'Marketing',
                        child:
                            Text('Marketing', style: TextStyle(fontSize: 13))),
                    DropdownMenuItem(
                        value: 'Engineering',
                        child: Text('Engineering',
                            style: TextStyle(fontSize: 13))),
                    DropdownMenuItem(
                        value: 'Healthcare',
                        child:
                            Text('Healthcare', style: TextStyle(fontSize: 13))),
                    DropdownMenuItem(
                        value: 'Education',
                        child:
                            Text('Education', style: TextStyle(fontSize: 13))),
                  ],
                  onChanged: cubit.onCategoryChanged,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  key: const Key('search_03_type_dropdown'),
                  value: state.employmentType,
                  decoration: _searchDec(
                    label: 'ประเภทการจ้างงาน',
                    icon: Icons.badge_outlined,
                  ),
                  hint: const Text('ทั้งหมด', style: TextStyle(fontSize: 13)),
                  items: const [
                    DropdownMenuItem(
                        value: 'Full-time',
                        child:
                            Text('Full-time', style: TextStyle(fontSize: 13))),
                    DropdownMenuItem(
                        value: 'Part-time',
                        child:
                            Text('Part-time', style: TextStyle(fontSize: 13))),
                    DropdownMenuItem(
                        value: 'Contract',
                        child:
                            Text('Contract', style: TextStyle(fontSize: 13))),
                    DropdownMenuItem(
                        value: 'Freelance',
                        child:
                            Text('Freelance', style: TextStyle(fontSize: 13))),
                    DropdownMenuItem(
                        value: 'Internship',
                        child:
                            Text('Internship', style: TextStyle(fontSize: 13))),
                  ],
                  onChanged: cubit.onEmploymentTypeChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Row 3: Min Salary + Remote toggle + Search button
          Row(
            children: [
              Expanded(
                child: TextField(
                  key: const Key('search_04_salary_min_textfield'),
                  controller: salaryMinCtrl,
                  style: const TextStyle(fontSize: 14),
                  decoration: _searchDec(
                    label: 'เงินเดือนขั้นต่ำ (บาท)',
                    hint: '25000',
                    icon: Icons.payments_outlined,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: cubit.onSalaryMinChanged,
                  onSubmitted: (_) => cubit.search(),
                ),
              ),
              const SizedBox(width: 10),
              // Remote switch pill
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.home_work_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'ทำงานระยะไกล',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Switch(
                      key: const Key('search_05_remote_switch'),
                      value: state.remoteOnly,
                      onChanged: cubit.onRemoteOnlyChanged,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                key: const Key('search_06_end_button'),
                onPressed: isLoading ? null : cubit.search,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 18,
                  ),
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search, size: 18),
                          SizedBox(width: 4),
                          Text(
                            'ค้นหา',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Result Section ───────────────────────────────────────────────────────────

class _ResultSection extends StatelessWidget {
  final JobSearchState state;

  const _ResultSection({required this.state});

  @override
  Widget build(BuildContext context) {
    switch (state.status) {
      case JobSearchStatus.initial:
        return const _HintCard();
      case JobSearchStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case JobSearchStatus.empty:
        return const _NotFoundCard();
      case JobSearchStatus.error:
        return _ErrorCard(message: state.errorMessage ?? 'Unknown error');
      case JobSearchStatus.success:
        return _JobList(jobs: state.jobs);
    }
  }
}

class _HintCard extends StatelessWidget {
  const _HintCard();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.manage_search, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'ค้นหาโอกาสงานที่ใช่สำหรับคุณ',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
          const SizedBox(height: 8),
          Text(
            'ใช้ตัวกรองด้านบนเพื่อค้นหางานที่ตรงใจ',
            style: TextStyle(fontSize: 13, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}

class _NotFoundCard extends StatelessWidget {
  const _NotFoundCard();

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const Key('search_04_not_found'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.find_in_page_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'ไม่พบตำแหน่งงาน',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
          const SizedBox(height: 8),
          Text(
            'ลองปรับเงื่อนไขการค้นหาใหม่',
            style: TextStyle(fontSize: 13, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;

  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const Key('search_05_error'),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Job List ─────────────────────────────────────────────────────────────────

class _JobList extends StatelessWidget {
  final List<Map<String, dynamic>> jobs;

  const _JobList({required this.jobs});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            'พบ ${jobs.length} ตำแหน่งงาน',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            key: const Key('search_06_result_list'),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            itemCount: jobs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) =>
                _JobCard(job: jobs[index], index: index),
          ),
        ),
      ],
    );
  }
}

// ─── Job Card ─────────────────────────────────────────────────────────────────

class _JobCard extends StatelessWidget {
  final Map<String, dynamic> job;
  final int index;

  const _JobCard({required this.job, required this.index});

  String _fmtSalary(dynamic n) {
    final val = n is int ? n : (int.tryParse(n.toString()) ?? 0);
    if (val >= 1000) return '${(val / 1000).toStringAsFixed(0)}K';
    return val.toString();
  }

  @override
  Widget build(BuildContext context) {
    final title = job['title']?.toString() ?? '-';
    final company = job['company']?.toString() ?? '-';
    final location = job['location']?.toString() ?? '-';
    final category = job['category']?.toString() ?? '-';
    final employmentType = job['employmentType']?.toString() ?? '-';
    final experienceLevel = job['experienceLevel']?.toString() ?? '-';
    final salaryMin = job['salaryMin'];
    final salaryMax = job['salaryMax'];
    final isRemote = job['isRemote'] == true;
    final skills = job['skills']?.toString() ?? '';

    final salaryText = (salaryMin != null && salaryMax != null)
        ? '฿${_fmtSalary(salaryMin)} – ฿${_fmtSalary(salaryMax)} / mo'
        : '-';

    return Card(
      key: Key('search_job_card_$index'),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      title.isNotEmpty ? title[0].toUpperCase() : '?',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
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
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.business_outlined,
                            size: 13,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              '$company · $location',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isRemote)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.teal.shade300),
                    ),
                    child: const Text(
                      'ทำงานระยะไกล',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.teal,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Tags
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _Tag(label: category, color: Colors.deepOrange),
                _Tag(label: employmentType, color: Colors.blue),
                _Tag(label: experienceLevel, color: Colors.purple),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 10),

            // Salary
            Row(
              children: [
                const Icon(
                  Icons.payments_outlined,
                  size: 15,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(
                  salaryText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),

            // Skills
            if (skills.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.code_outlined,
                    size: 15,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      skills,
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;

  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color.withOpacity(0.85),
        ),
      ),
    );
  }
}
