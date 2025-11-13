import 'package:flutter/material.dart';

class TextButtonDemo extends StatefulWidget {
  const TextButtonDemo({super.key});

  @override
  State<TextButtonDemo> createState() => _TextButtonDemoState();
}

class _TextButtonDemoState extends State<TextButtonDemo> {
  String _selectedTab = 'home';
  final List<String> _items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TextButton Demo'),
        actions: [
          TextButton(
            key: const Key('help_button'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Help'),
                  content: const Text('This is a help dialog'),
                  actions: [
                    TextButton(
                      key: const Key('close_help_button'),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Help', style: TextStyle(color: Colors.white)),
          ),
        ],
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
                        'Basic TextButton',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        key: const Key('basic_text_button'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Text button pressed')),
                          );
                        },
                        child: const Text('Basic Text Button'),
                      ),
                      TextButton.icon(
                        key: const Key('icon_text_button'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Icon button pressed')),
                          );
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Download'),
                      ),
                      TextButton(
                        key: const Key('disabled_text_button'),
                        onPressed: null,
                        child: const Text('Disabled Text Button'),
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
                        'Tab Navigation',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            key: const Key('home_tab_button'),
                            onPressed: () {
                              setState(() {
                                _selectedTab = 'home';
                              });
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: _selectedTab == 'home'
                                  ? Colors.blue.withOpacity(0.1)
                                  : null,
                            ),
                            child: const Text('Home'),
                          ),
                          TextButton(
                            key: const Key('profile_tab_button'),
                            onPressed: () {
                              setState(() {
                                _selectedTab = 'profile';
                              });
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: _selectedTab == 'profile'
                                  ? Colors.blue.withOpacity(0.1)
                                  : null,
                            ),
                            child: const Text('Profile'),
                          ),
                          TextButton(
                            key: const Key('settings_tab_button'),
                            onPressed: () {
                              setState(() {
                                _selectedTab = 'settings';
                              });
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: _selectedTab == 'settings'
                                  ? Colors.blue.withOpacity(0.1)
                                  : null,
                            ),
                            child: const Text('Settings'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          key: const Key('selected_tab_text'),
                          'Selected: $_selectedTab',
                          style: const TextStyle(fontSize: 16),
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
                        'Dialog Actions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        key: const Key('show_confirm_dialog_button'),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              key: const Key('confirm_dialog'),
                              title: const Text('Confirm Action'),
                              content: const Text('Are you sure you want to proceed?'),
                              actions: [
                                TextButton(
                                  key: const Key('cancel_button'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Cancelled')),
                                    );
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  key: const Key('confirm_button'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Confirmed')),
                                    );
                                  },
                                  child: const Text('Confirm'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text('Show Confirm Dialog'),
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
                        'List Management',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            key: const Key('add_item_button'),
                            onPressed: () {
                              setState(() {
                                _items.add('Item ${_items.length + 1}');
                              });
                            },
                            child: const Text('Add Item'),
                          ),
                          TextButton(
                            key: const Key('clear_items_button'),
                            onPressed: _items.isNotEmpty
                                ? () {
                                    setState(() {
                                      _items.clear();
                                    });
                                  }
                                : null,
                            child: const Text('Clear All'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        key: const Key('items_count_text'),
                        'Items: ${_items.length}',
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
