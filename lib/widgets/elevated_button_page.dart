import 'package:flutter/material.dart';

class ElevatedButtonDemo extends StatefulWidget {
  const ElevatedButtonDemo({super.key});

  @override
  State<ElevatedButtonDemo> createState() => _ElevatedButtonDemoState();
}

class _ElevatedButtonDemoState extends State<ElevatedButtonDemo> {
  int _counter = 0;
  bool _isLoading = false;
  bool _isEnabled = true;

  Future<void> _simulateAsyncOperation() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Operation completed!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ElevatedButton Demo'),
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
                        'Basic Buttons',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        key: const Key('basic_button'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Basic button pressed')),
                          );
                        },
                        child: const Text('Basic Button'),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        key: const Key('icon_button'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Icon button pressed')),
                          );
                        },
                        icon: const Icon(Icons.send),
                        label: const Text('Send Message'),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        key: const Key('disabled_button'),
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
                        'Counter Example',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        key: const Key('counter_text'),
                        'Counter: $_counter',
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            key: const Key('increment_button'),
                            onPressed: () {
                              setState(() {
                                _counter++;
                              });
                            },
                            child: const Text('Increment'),
                          ),
                          ElevatedButton(
                            key: const Key('decrement_button'),
                            onPressed: _counter > 0
                                ? () {
                                    setState(() {
                                      _counter--;
                                    });
                                  }
                                : null,
                            child: const Text('Decrement'),
                          ),
                          ElevatedButton(
                            key: const Key('reset_button'),
                            onPressed: () {
                              setState(() {
                                _counter = 0;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Button'),
                          ),
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
                        'Async Operation',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        key: const Key('async_button'),
                        onPressed: _isLoading ? null : _simulateAsyncOperation,
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Start Operation'),
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
                        'Conditional Button',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        key: const Key('enable_switch'),
                        title: const Text('Enable button'),
                        value: _isEnabled,
                        onChanged: (value) {
                          setState(() {
                            _isEnabled = value;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        key: const Key('conditional_button'),
                        onPressed: _isEnabled
                            ? () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Conditional button pressed'),
                                  ),
                                );
                              }
                            : null,
                        child: const Text('Conditional Button'),
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
