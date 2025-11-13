import 'package:flutter/material.dart';

class OutlinedButtonDemo extends StatefulWidget {
  const OutlinedButtonDemo({super.key});

  @override
  State<OutlinedButtonDemo> createState() => _OutlinedButtonDemoState();
}

class _OutlinedButtonDemoState extends State<OutlinedButtonDemo> {
  String? _selectedOption;
  final List<String> _selectedFilters = [];
  bool _isSubscribed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OutlinedButton Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Basic OutlinedButton',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        key: const Key('basic_outlined_button'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Outlined button pressed')),
                          );
                        },
                        child: const Text('Basic Outlined Button'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        key: const Key('icon_outlined_button'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Icon button pressed')),
                          );
                        },
                        icon: const Icon(Icons.share),
                        label: const Text('Share'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        key: const Key('disabled_outlined_button'),
                        onPressed: null,
                        child: const Text('Disabled Button'),
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
                        'Single Selection',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ['Option 1', 'Option 2', 'Option 3'].map((option) {
                          final isSelected = _selectedOption == option;
                          return OutlinedButton(
                            key: Key('select_${option.toLowerCase().replaceAll(' ', '_')}_button'),
                            onPressed: () {
                              setState(() {
                                _selectedOption = isSelected ? null : option;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: isSelected
                                  ? Theme.of(context).colorScheme.primaryContainer
                                  : null,
                              side: BorderSide(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Text(option),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        key: const Key('selected_option_text'),
                        'Selected: ${_selectedOption ?? 'None'}',
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
                        'Multiple Selection (Filters)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ['Electronics', 'Clothing', 'Books', 'Sports'].map((filter) {
                          final isSelected = _selectedFilters.contains(filter);
                          return OutlinedButton(
                            key: Key('filter_${filter.toLowerCase()}_button'),
                            onPressed: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedFilters.remove(filter);
                                } else {
                                  _selectedFilters.add(filter);
                                }
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: isSelected
                                  ? Theme.of(context).colorScheme.primaryContainer
                                  : null,
                              side: BorderSide(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(filter),
                                if (isSelected) ...[
                                  const SizedBox(width: 4),
                                  const Icon(Icons.check, size: 16),
                                ],
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        key: const Key('selected_filters_text'),
                        'Filters: ${_selectedFilters.isEmpty ? 'None' : _selectedFilters.join(', ')}',
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
                        'Styled Buttons',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        key: const Key('success_button'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Success action')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green,
                          side: const BorderSide(color: Colors.green, width: 2),
                        ),
                        child: const Text('Success'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        key: const Key('danger_button'),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Confirm Delete'),
                              content: const Text('Are you sure?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                OutlinedButton(
                                  key: const Key('confirm_delete_button'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Deleted')),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    side: const BorderSide(color: Colors.red, width: 2),
                                  ),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red, width: 2),
                        ),
                        child: const Text('Danger'),
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
                        'Toggle Button',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        key: const Key('subscribe_toggle_button'),
                        onPressed: () {
                          setState(() {
                            _isSubscribed = !_isSubscribed;
                          });
                        },
                        icon: Icon(_isSubscribed ? Icons.notifications_active : Icons.notifications_off),
                        label: Text(_isSubscribed ? 'Subscribed' : 'Subscribe'),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: _isSubscribed
                              ? Theme.of(context).colorScheme.primaryContainer
                              : null,
                          side: BorderSide(
                            color: _isSubscribed
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                            width: _isSubscribed ? 2 : 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
