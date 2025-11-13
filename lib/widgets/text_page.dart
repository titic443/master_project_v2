import 'package:flutter/material.dart';

class TextWidgetDemo extends StatefulWidget {
  const TextWidgetDemo({super.key});

  @override
  State<TextWidgetDemo> createState() => _TextWidgetDemoState();
}

class _TextWidgetDemoState extends State<TextWidgetDemo> {
  int _counter = 0;
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Widget Demo'),
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
                        'Basic Text Styles',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        key: Key('basic_text'),
                        'This is a basic text widget',
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        key: Key('large_text'),
                        'Large Text',
                        style: TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        key: Key('bold_text'),
                        'Bold Text',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        key: Key('italic_text'),
                        'Italic Text',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        key: Key('colored_text'),
                        'Colored Text',
                        style: TextStyle(color: Colors.blue),
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
                        'Dynamic Text',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        key: const Key('counter_display_text'),
                        'Counter: $_counter',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        key: const Key('increment_counter_button'),
                        onPressed: () {
                          setState(() {
                            _counter++;
                          });
                        },
                        child: const Text('Increment'),
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
                        'Text Overflow',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        key: Key('ellipsis_text'),
                        'This is a very long text that will be truncated with ellipsis when it exceeds the available width',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        key: Key('fade_text'),
                        'This text will fade when it overflows the available space',
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        key: Key('clip_text'),
                        'This text will be clipped at the boundary',
                        maxLines: 1,
                        overflow: TextOverflow.clip,
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
                        'Rich Text',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        key: const Key('rich_text'),
                        text: const TextSpan(
                          text: 'This is ',
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'bold',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: ' and this is '),
                            TextSpan(
                              text: 'colored',
                              style: TextStyle(color: Colors.blue),
                            ),
                            TextSpan(text: ' text'),
                          ],
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
                        'Text Alignment',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        color: Colors.grey[200],
                        child: const Text(
                          key: Key('left_aligned_text'),
                          'Left Aligned',
                          textAlign: TextAlign.left,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        color: Colors.grey[200],
                        child: const Text(
                          key: Key('center_aligned_text'),
                          'Center Aligned',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        color: Colors.grey[200],
                        child: const Text(
                          key: Key('right_aligned_text'),
                          'Right Aligned',
                          textAlign: TextAlign.right,
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
                        'Conditional Text',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        key: const Key('toggle_details_button'),
                        onPressed: () {
                          setState(() {
                            _showDetails = !_showDetails;
                          });
                        },
                        child: Text(_showDetails ? 'Hide Details' : 'Show Details'),
                      ),
                      const SizedBox(height: 8),
                      if (_showDetails)
                        const Text(
                          key: Key('details_text'),
                          'Here are the additional details that are shown when the button is clicked.',
                          style: TextStyle(color: Colors.grey),
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
                        'Status Messages',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            key: Key('success_text'),
                            'Success Message',
                            style: TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        children: [
                          Icon(Icons.error, color: Colors.red),
                          SizedBox(width: 8),
                          Text(
                            key: Key('error_text'),
                            'Error Message',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        children: [
                          Icon(Icons.warning, color: Colors.orange),
                          SizedBox(width: 8),
                          Text(
                            key: Key('warning_text'),
                            'Warning Message',
                            style: TextStyle(color: Colors.orange),
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
    );
  }
}
