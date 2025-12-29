import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/widgets/chip_demo_cubit.dart';

class ChipDemoPage extends StatelessWidget {
  const ChipDemoPage({super.key});

  static const route = '/chip-demo';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChipDemoCubit(),
      child: const _ChipDemoForm(),
    );
  }
}

class _ChipDemoForm extends StatelessWidget {
  const _ChipDemoForm();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chip Widget Demo'),
      ),
      body: BlocBuilder<ChipDemoCubit, ChipDemoState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ChoiceChip - Single Selection
                const Text(
                  'Choose Priority (ChoiceChip)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  children: [
                    ChoiceChip(
                      key: const Key('chip_01_priority_low'),
                      label: const Text('Low'),
                      selected: state.selectedChoice == 'low',
                      onSelected: (selected) {
                        if (selected) {
                          context.read<ChipDemoCubit>().onChoiceSelected('low');
                        }
                      },
                    ),
                    ChoiceChip(
                      key: const Key('chip_02_priority_medium'),
                      label: const Text('Medium'),
                      selected: state.selectedChoice == 'medium',
                      onSelected: (selected) {
                        if (selected) {
                          context.read<ChipDemoCubit>().onChoiceSelected('medium');
                        }
                      },
                    ),
                    ChoiceChip(
                      key: const Key('chip_03_priority_high'),
                      label: const Text('High'),
                      selected: state.selectedChoice == 'high',
                      onSelected: (selected) {
                        if (selected) {
                          context.read<ChipDemoCubit>().onChoiceSelected('high');
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // FilterChip - Multiple Selection
                const Text(
                  'Filter Categories (FilterChip)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  children: [
                    FilterChip(
                      key: const Key('chip_04_filter_work'),
                      label: const Text('Work'),
                      selected: state.selectedFilters.contains('work'),
                      onSelected: (selected) {
                        context.read<ChipDemoCubit>().onFilterToggled('work');
                      },
                    ),
                    FilterChip(
                      key: const Key('chip_05_filter_personal'),
                      label: const Text('Personal'),
                      selected: state.selectedFilters.contains('personal'),
                      onSelected: (selected) {
                        context.read<ChipDemoCubit>().onFilterToggled('personal');
                      },
                    ),
                    FilterChip(
                      key: const Key('chip_06_filter_urgent'),
                      label: const Text('Urgent'),
                      selected: state.selectedFilters.contains('urgent'),
                      onSelected: (selected) {
                        context.read<ChipDemoCubit>().onFilterToggled('urgent');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // InputChip - Interests
                const Text(
                  'Select Interests (InputChip)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  children: [
                    InputChip(
                      key: const Key('chip_07_interest_tech'),
                      label: const Text('Technology'),
                      selected: state.selectedInterests.contains('tech'),
                      onSelected: (selected) {
                        context.read<ChipDemoCubit>().onInterestToggled('tech');
                      },
                    ),
                    InputChip(
                      key: const Key('chip_08_interest_sports'),
                      label: const Text('Sports'),
                      selected: state.selectedInterests.contains('sports'),
                      onSelected: (selected) {
                        context.read<ChipDemoCubit>().onInterestToggled('sports');
                      },
                    ),
                    InputChip(
                      key: const Key('chip_09_interest_music'),
                      label: const Text('Music'),
                      selected: state.selectedInterests.contains('music'),
                      onSelected: (selected) {
                        context.read<ChipDemoCubit>().onInterestToggled('music');
                      },
                    ),
                    InputChip(
                      key: const Key('chip_10_interest_travel'),
                      label: const Text('Travel'),
                      selected: state.selectedInterests.contains('travel'),
                      onSelected: (selected) {
                        context.read<ChipDemoCubit>().onInterestToggled('travel');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Display current state
                Text(
                  key: const Key('chip_11_status_text'),
                  'Current Selection:\n'
                  'Priority: ${state.selectedChoice.isEmpty ? "None" : state.selectedChoice}\n'
                  'Filters: ${state.selectedFilters.isEmpty ? "None" : state.selectedFilters.join(", ")}\n'
                  'Interests: ${state.selectedInterests.isEmpty ? "None" : state.selectedInterests.join(", ")}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
