import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/widgets/segmented_button_demo_cubit.dart';

class SegmentedButtonDemoPage extends StatelessWidget {
  const SegmentedButtonDemoPage({super.key});

  static const route = '/segmented-button-demo';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SegmentedButtonDemoCubit(),
      child: const _SegmentedButtonDemoForm(),
    );
  }
}

class _SegmentedButtonDemoForm extends StatelessWidget {
  const _SegmentedButtonDemoForm();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SegmentedButton Demo'),
      ),
      body: BlocBuilder<SegmentedButtonDemoCubit, SegmentedButtonDemoState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Size Selection (Single Select)
                const Text(
                  'Select Size',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  key: const Key('segmented_01_size_button'),
                  segments: const [
                    ButtonSegment(value: 'S', label: Text('S')),
                    ButtonSegment(value: 'M', label: Text('M')),
                    ButtonSegment(value: 'L', label: Text('L')),
                    ButtonSegment(value: 'XL', label: Text('XL')),
                  ],
                  selected: {state.size},
                  onSelectionChanged: (Set<String> newSelection) {
                    context.read<SegmentedButtonDemoCubit>().onSizeChanged(newSelection.first);
                  },
                ),
                const SizedBox(height: 24),

                // Delivery Speed (Single Select)
                const Text(
                  'Delivery Speed',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  key: const Key('segmented_02_delivery_button'),
                  segments: const [
                    ButtonSegment(
                      value: 'express',
                      label: Text('Express'),
                      icon: Icon(Icons.flash_on),
                    ),
                    ButtonSegment(
                      value: 'standard',
                      label: Text('Standard'),
                      icon: Icon(Icons.local_shipping),
                    ),
                    ButtonSegment(
                      value: 'economy',
                      label: Text('Economy'),
                      icon: Icon(Icons.access_time),
                    ),
                  ],
                  selected: {state.deliverySpeed},
                  onSelectionChanged: (Set<String> newSelection) {
                    context.read<SegmentedButtonDemoCubit>().onDeliverySpeedChanged(newSelection.first);
                  },
                ),
                const SizedBox(height: 24),

                // Toppings (Multi Select)
                const Text(
                  'Select Toppings',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  key: const Key('segmented_03_toppings_button'),
                  segments: const [
                    ButtonSegment(value: 'cheese', label: Text('Cheese')),
                    ButtonSegment(value: 'pepperoni', label: Text('Pepperoni')),
                    ButtonSegment(value: 'mushroom', label: Text('Mushroom')),
                    ButtonSegment(value: 'olive', label: Text('Olive')),
                  ],
                  selected: state.toppings,
                  onSelectionChanged: (Set<String> newSelection) {
                    context.read<SegmentedButtonDemoCubit>().onToppingsChanged(newSelection);
                  },
                  multiSelectionEnabled: true,
                ),
                const SizedBox(height: 24),

                // Display current state
                Text(
                  key: const Key('segmented_04_status_text'),
                  'Current Selection:\n'
                  'Size: ${state.size}\n'
                  'Delivery: ${state.deliverySpeed}\n'
                  'Toppings: ${state.toppings.isEmpty ? "None" : state.toppings.join(", ")}',
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
