import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/linkedin_search_cubit.dart';
import 'package:master_project/cubit/linkedin_search_state.dart';

class LinkedinSearchPage extends StatelessWidget {
  const LinkedinSearchPage({super.key});

  static const route = '/linkedin-search';

  @override
  Widget build(BuildContext context) {
    return const _LinkedinSearchView();
  }
}

class _LinkedinSearchView extends StatefulWidget {
  const _LinkedinSearchView();

  @override
  State<_LinkedinSearchView> createState() => _LinkedinSearchViewState();
}

class _LinkedinSearchViewState extends State<_LinkedinSearchView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _sync(LinkedinSearchState state) {
    if (_nameController.text != state.name) {
      _nameController.text = state.name;
    }
    if (_emailController.text != state.email) {
      _emailController.text = state.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LinkedIn Profile Search',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<LinkedinSearchCubit, LinkedinSearchState>(
        listenWhen: (prev, curr) =>
            prev.status == LinkedinSearchStatus.loading &&
            curr.status != LinkedinSearchStatus.loading,
        listener: (context, state) {
          if (state.status == LinkedinSearchStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                key: const Key('search_01_expected_success'),
                content: Text('Found ${state.profiles.length} profile(s)'),
              ),
            );
          } else if (state.status == LinkedinSearchStatus.error ||
              state.status == LinkedinSearchStatus.empty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                key: const Key('search_01_expected_fail'),
                content: Text(
                  state.status == LinkedinSearchStatus.empty
                      ? 'No profiles found'
                      : state.errorMessage ?? 'An error occurred',
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          _sync(state);
          return Column(
            children: [
              _SearchForm(
                nameController: _nameController,
                emailController: _emailController,
                isLoading: state.status == LinkedinSearchStatus.loading,
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

// ─── Search Form ──────────────────────────────────────────────────────────────

class _SearchForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final bool isLoading;

  const _SearchForm({
    required this.nameController,
    required this.emailController,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LinkedinSearchCubit>();
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            key: const Key('search_01_name_textfield'),
            controller: nameController,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              labelText: 'Full Name',
              labelStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              hintText: 'e.g. Alice Smith',
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
              prefixIcon: const Icon(Icons.person_search),
              border: const OutlineInputBorder(),
            ),
            onChanged: cubit.onNameChanged,
            onSubmitted: (_) => cubit.search(),
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('search_02_email_textfield'),
            controller: emailController,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              hintText: 'e.g. alice@example.com',
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
              prefixIcon: const Icon(Icons.email_outlined),
              border: const OutlineInputBorder(),
            ),
            onChanged: cubit.onEmailChanged,
            onSubmitted: (_) => cubit.search(),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            key: const Key('search_03_end_button'),
            onPressed: isLoading ? null : cubit.search,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search),
                      SizedBox(width: 8),
                      Text(
                        'Search',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Result Section ───────────────────────────────────────────────────────────

class _ResultSection extends StatelessWidget {
  final LinkedinSearchState state;

  const _ResultSection({required this.state});

  @override
  Widget build(BuildContext context) {
    switch (state.status) {
      case LinkedinSearchStatus.initial:
        return const _HintCard();
      case LinkedinSearchStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case LinkedinSearchStatus.empty:
        return const _NotFoundCard();
      case LinkedinSearchStatus.error:
        return _ErrorCard(message: state.errorMessage ?? 'Unknown error');
      case LinkedinSearchStatus.success:
        return _ProfileList(profiles: state.profiles);
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
            'Enter name or email to search',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
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
          Icon(Icons.person_off_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No profiles found',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
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

class _ProfileList extends StatelessWidget {
  final List<Map<String, dynamic>> profiles;

  const _ProfileList({required this.profiles});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      key: const Key('search_06_result_list'),
      padding: const EdgeInsets.all(16),
      itemCount: profiles.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) =>
          _ProfileCard(profile: profiles[index], index: index),
    );
  }
}

// ─── Profile Card ─────────────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  final Map<String, dynamic> profile;
  final int index;

  const _ProfileCard({required this.profile, required this.index});

  static const _eduLabels = {1: 'Bachelor', 2: 'Master', 3: 'PhD'};

  @override
  Widget build(BuildContext context) {
    final name = profile['fullName']?.toString() ?? '-';
    final email = profile['email']?.toString() ?? '-';
    final position = profile['position']?.toString() ?? '-';
    final company = profile['company']?.toString() ?? '-';
    final experience = profile['experience']?.toString() ?? '-';
    final employmentType = profile['employmentType']?.toString() ?? '-';
    final educationLevel = profile['educationLevel'] as int?;
    final university = profile['university']?.toString() ?? '-';
    final openToWork = profile['openToWork'] == true;

    return Card(
      key: Key('search_profile_card_$index'),
      elevation: 3,
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
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.indigo.withOpacity(0.15),
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$position · $company',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (openToWork)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade300),
                    ),
                    child: const Text(
                      '#OpenToWork',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 12),
            // Details
            _InfoRow(icon: Icons.email_outlined, label: 'Email', value: email),
            const SizedBox(height: 6),
            _InfoRow(
              icon: Icons.work_history_outlined,
              label: 'Experience',
              value: '$experience years',
            ),
            const SizedBox(height: 6),
            _InfoRow(
              icon: Icons.badge_outlined,
              label: 'Employment',
              value: employmentType,
            ),
            const SizedBox(height: 6),
            _InfoRow(
              icon: Icons.school_outlined,
              label: 'Education',
              value: educationLevel != null
                  ? '${_eduLabels[educationLevel] ?? educationLevel} · $university'
                  : university,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[500]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }
}
