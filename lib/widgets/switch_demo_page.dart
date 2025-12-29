import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/widgets/switch_demo_cubit.dart';

class SwitchDemoPage extends StatelessWidget {
  const SwitchDemoPage({super.key});

  static const route = '/switch-demo';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SwitchDemoCubit(),
      child: const _SwitchDemoForm(),
    );
  }
}

class _SwitchDemoForm extends StatelessWidget {
  const _SwitchDemoForm();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Switch Widget Demo'),
      ),
      body: BlocBuilder<SwitchDemoCubit, SwitchDemoState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enable Notifications Switch
                SwitchListTile(
                  key: const Key('switch_01_notifications_switch'),
                  title: const Text('Enable Notifications'),
                  subtitle: const Text('Receive push notifications'),
                  value: state.enableNotifications,
                  onChanged: (value) {
                    context.read<SwitchDemoCubit>().onNotificationsChanged(value);
                  },
                ),
                const Divider(),

                // Dark Mode Switch
                SwitchListTile(
                  key: const Key('switch_02_darkmode_switch'),
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Use dark theme'),
                  value: state.darkMode,
                  onChanged: (value) {
                    context.read<SwitchDemoCubit>().onDarkModeChanged(value);
                  },
                ),
                const Divider(),

                // Auto Save Switch
                SwitchListTile(
                  key: const Key('switch_03_autosave_switch'),
                  title: const Text('Auto Save'),
                  subtitle: const Text('Automatically save changes'),
                  value: state.autoSave,
                  onChanged: (value) {
                    context.read<SwitchDemoCubit>().onAutoSaveChanged(value);
                  },
                ),
                const SizedBox(height: 24),

                // Display current state
                Text(
                  key: const Key('switch_04_status_text'),
                  'Current Settings:\n'
                  'Notifications: ${state.enableNotifications ? "ON" : "OFF"}\n'
                  'Dark Mode: ${state.darkMode ? "ON" : "OFF"}\n'
                  'Auto Save: ${state.autoSave ? "ON" : "OFF"}',
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
