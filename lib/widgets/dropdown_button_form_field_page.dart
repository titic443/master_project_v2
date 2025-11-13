import 'package:flutter/material.dart';

class DropdownButtonFormFieldDemo extends StatefulWidget {
  const DropdownButtonFormFieldDemo({super.key});

  @override
  State<DropdownButtonFormFieldDemo> createState() => _DropdownButtonFormFieldDemoState();
}

class _DropdownButtonFormFieldDemoState extends State<DropdownButtonFormFieldDemo> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  String? _selectedPriority;
  String? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DropdownButtonFormField Demo'),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Task Form with Validation',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          key: const Key('category_dropdown'),
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.category),
                          ),
                          value: _selectedCategory,
                          items: const [
                            DropdownMenuItem(value: 'work', child: Text('Work')),
                            DropdownMenuItem(value: 'personal', child: Text('Personal')),
                            DropdownMenuItem(value: 'shopping', child: Text('Shopping')),
                            DropdownMenuItem(value: 'health', child: Text('Health')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a category';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          key: const Key('priority_dropdown'),
                          decoration: const InputDecoration(
                            labelText: 'Priority',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.priority_high),
                          ),
                          value: _selectedPriority,
                          items: const [
                            DropdownMenuItem(
                              value: 'low',
                              child: Row(
                                children: [
                                  Icon(Icons.arrow_downward, color: Colors.green, size: 16),
                                  SizedBox(width: 8),
                                  Text('Low'),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'medium',
                              child: Row(
                                children: [
                                  Icon(Icons.remove, color: Colors.orange, size: 16),
                                  SizedBox(width: 8),
                                  Text('Medium'),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'high',
                              child: Row(
                                children: [
                                  Icon(Icons.arrow_upward, color: Colors.red, size: 16),
                                  SizedBox(width: 8),
                                  Text('High'),
                                ],
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedPriority = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a priority';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          key: const Key('status_dropdown'),
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.check_circle),
                          ),
                          value: _selectedStatus,
                          items: const [
                            DropdownMenuItem(value: 'todo', child: Text('To Do')),
                            DropdownMenuItem(value: 'in_progress', child: Text('In Progress')),
                            DropdownMenuItem(value: 'completed', child: Text('Completed')),
                            DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedStatus = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a status';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            key: const Key('submit_button'),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Form validated successfully!'),
                                  ),
                                );
                              }
                            },
                            child: const Text('Submit'),
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
                          'Selected Values',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          key: const Key('selected_values_text'),
                          'Category: ${_selectedCategory ?? 'Not selected'}\n'
                          'Priority: ${_selectedPriority ?? 'Not selected'}\n'
                          'Status: ${_selectedStatus ?? 'Not selected'}',
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
                          'Quick Actions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ElevatedButton(
                              key: const Key('reset_form_button'),
                              onPressed: () {
                                setState(() {
                                  _selectedCategory = null;
                                  _selectedPriority = null;
                                  _selectedStatus = null;
                                  _formKey.currentState?.reset();
                                });
                              },
                              child: const Text('Reset Form'),
                            ),
                            ElevatedButton(
                              key: const Key('preset_high_priority_button'),
                              onPressed: () {
                                setState(() {
                                  _selectedCategory = 'work';
                                  _selectedPriority = 'high';
                                  _selectedStatus = 'todo';
                                });
                              },
                              child: const Text('Preset High Priority'),
                            ),
                          ],
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
