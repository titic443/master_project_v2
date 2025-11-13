import 'package:flutter/material.dart';

class CheckboxWidgetDemo extends StatefulWidget {
  const CheckboxWidgetDemo({super.key});

  @override
  State<CheckboxWidgetDemo> createState() => _CheckboxWidgetDemoState();
}

class _CheckboxWidgetDemoState extends State<CheckboxWidgetDemo> {
  final _formKey = GlobalKey<FormState>();
  bool _acceptTerms = false;
  bool _subscribe = false;
  bool _notifications = true;
  bool _darkMode = false;
  final List<String> _selectedHobbies = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkbox Demo'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Basic Checkboxes',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Checkbox(
                              key: const Key('basic_checkbox'),
                              value: _acceptTerms,
                              onChanged: (value) {
                                setState(() {
                                  _acceptTerms = value ?? false;
                                });
                              },
                            ),
                            const Text('Checkbox1'),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              key: const Key('subscribe_checkbox'),
                              value: _subscribe,
                              onChanged: (value) {
                                setState(() {
                                  _subscribe = value ?? false;
                                });
                              },
                            ),
                            const Text('Checkbox2'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CheckboxListTile',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        CheckboxListTile(
                          key: const Key('notifications_checkbox'),
                          title: const Text('Enable Notifications'),
                          subtitle: const Text('Receive push notifications'),
                          value: _notifications,
                          onChanged: (value) {
                            setState(() {
                              _notifications = value ?? false;
                            });
                          },
                        ),
                        CheckboxListTile(
                          key: const Key('dark_mode_checkbox'),
                          title: const Text('Dark Mode'),
                          subtitle: const Text('Use dark theme'),
                          value: _darkMode,
                          onChanged: (value) {
                            setState(() {
                              _darkMode = value ?? false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Checkbox with Validation',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        FormField<bool>(
                          key: const Key('terms_formfield'),
                          initialValue: _acceptTerms,
                          validator: (value) {
                            if (value != true) {
                              return 'You must accept the terms';
                            }
                            return null;
                          },
                          builder: (formFieldState) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CheckboxListTile(
                                  title: const Text(
                                      'I accept the terms and conditions'),
                                  value: _acceptTerms,
                                  onChanged: (value) {
                                    setState(() {
                                      _acceptTerms = value ?? false;
                                    });
                                    formFieldState.didChange(value);
                                  },
                                ),
                                if (formFieldState.hasError)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text(
                                      formFieldState.errorText!,
                                      key: const Key('terms_error'),
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            key: const Key('validate_button'),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Form validated successfully!'),
                                  ),
                                );
                              }
                            },
                            child: const Text('Validate'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Multiple Selection',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text('Select your hobbies:'),
                        const SizedBox(height: 8),
                        ...['Reading', 'Gaming', 'Sports', 'Music', 'Cooking']
                            .map((hobby) {
                          return CheckboxListTile(
                            key: Key('hobby_${hobby.toLowerCase()}_checkbox'),
                            title: Text(hobby),
                            value: _selectedHobbies.contains(hobby),
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  _selectedHobbies.add(hobby);
                                } else {
                                  _selectedHobbies.remove(hobby);
                                }
                              });
                            },
                          );
                        }),
                        const SizedBox(height: 8),
                        Text(
                          key: const Key('selected_hobbies_text'),
                          'Selected: ${_selectedHobbies.isEmpty ? 'None' : _selectedHobbies.join(', ')}',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Summary',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          key: const Key('summary_text'),
                          'Terms: ${_acceptTerms ? 'Accepted' : 'Not Accepted'}\n'
                          'Newsletter: ${_subscribe ? 'Subscribed' : 'Not Subscribed'}\n'
                          'Notifications: ${_notifications ? 'Enabled' : 'Disabled'}\n'
                          'Dark Mode: ${_darkMode ? 'Enabled' : 'Disabled'}\n'
                          'Hobbies: ${_selectedHobbies.isEmpty ? 'None' : _selectedHobbies.join(', ')}',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
