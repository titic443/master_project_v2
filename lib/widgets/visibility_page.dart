import 'package:flutter/material.dart';

class VisibilityWidgetDemo extends StatefulWidget {
  const VisibilityWidgetDemo({super.key});

  @override
  State<VisibilityWidgetDemo> createState() => _VisibilityWidgetDemoState();
}

class _VisibilityWidgetDemoState extends State<VisibilityWidgetDemo> {
  bool _showContent1 = true;
  bool _showContent2 = false;
  bool _showDetails = false;
  bool _maintainState = false;
  bool _maintainAnimation = false;
  bool _showAdvanced = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visibility Demo'),
      ),
      body: Padding(
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
                        'Basic Visibility',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        key: const Key('toggle_content1_button'),
                        onPressed: () {
                          setState(() {
                            _showContent1 = !_showContent1;
                          });
                        },
                        child: Text(_showContent1 ? 'Hide Content' : 'Show Content'),
                      ),
                      const SizedBox(height: 16),
                      Visibility(
                        visible: _showContent1,
                        child: Container(
                          key: const Key('content1_container'),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'This content can be toggled on and off',
                            style: TextStyle(fontSize: 16),
                          ),
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
                        'Multiple Toggle Example',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              key: const Key('show_content2_button'),
                              onPressed: () {
                                setState(() {
                                  _showContent2 = true;
                                });
                              },
                              child: const Text('Show'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              key: const Key('hide_content2_button'),
                              onPressed: () {
                                setState(() {
                                  _showContent2 = false;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Hide'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Visibility(
                        visible: _showContent2,
                        child: Container(
                          key: const Key('content2_container'),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Separate show/hide controls',
                            style: TextStyle(fontSize: 16),
                          ),
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
                        'Conditional Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Product Name: Flutter Widget',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text('Price: \$99.99'),
                      const SizedBox(height: 8),
                      TextButton(
                        key: const Key('toggle_details_button'),
                        onPressed: () {
                          setState(() {
                            _showDetails = !_showDetails;
                          });
                        },
                        child: Text(_showDetails ? 'Hide Details' : 'Show Details'),
                      ),
                      Visibility(
                        visible: _showDetails,
                        child: Container(
                          key: const Key('details_container'),
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Description: A comprehensive widget demo'),
                              SizedBox(height: 4),
                              Text('Category: Development'),
                              SizedBox(height: 4),
                              Text('Rating: 4.5/5'),
                              SizedBox(height: 4),
                              Text('Reviews: 100+'),
                            ],
                          ),
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
                        'Advanced Visibility Options',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        key: const Key('maintain_state_switch'),
                        title: const Text('Maintain State'),
                        subtitle: const Text('Keep widget in tree when hidden'),
                        value: _maintainState,
                        onChanged: (value) {
                          setState(() {
                            _maintainState = value;
                          });
                        },
                      ),
                      SwitchListTile(
                        key: const Key('maintain_animation_switch'),
                        title: const Text('Maintain Animation'),
                        subtitle: const Text('Keep animation running when hidden'),
                        value: _maintainAnimation,
                        onChanged: (value) {
                          setState(() {
                            _maintainAnimation = value;
                          });
                        },
                      ),
                      SwitchListTile(
                        key: const Key('show_advanced_switch'),
                        title: const Text('Show Advanced Content'),
                        value: _showAdvanced,
                        onChanged: (value) {
                          setState(() {
                            _showAdvanced = value;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      Visibility(
                        visible: _showAdvanced,
                        maintainState: _maintainState,
                        maintainAnimation: _maintainAnimation,
                        child: Container(
                          key: const Key('advanced_container'),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.purple[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Advanced content with custom visibility options',
                            style: TextStyle(fontSize: 16),
                          ),
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
                        'Visibility Status',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        key: const Key('visibility_status_text'),
                        'Content 1: ${_showContent1 ? 'Visible' : 'Hidden'}\n'
                        'Content 2: ${_showContent2 ? 'Visible' : 'Hidden'}\n'
                        'Details: ${_showDetails ? 'Visible' : 'Hidden'}\n'
                        'Advanced: ${_showAdvanced ? 'Visible' : 'Hidden'}',
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
