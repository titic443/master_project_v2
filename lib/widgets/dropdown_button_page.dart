import 'package:flutter/material.dart';

class DropdownButtonDemo extends StatefulWidget {
  const DropdownButtonDemo({super.key});

  @override
  State<DropdownButtonDemo> createState() => _DropdownButtonDemoState();
}

class _DropdownButtonDemoState extends State<DropdownButtonDemo> {
  String? _selectedFruit;
  String? _selectedCountry;
  int? _selectedNumber;
  String _selectedColor = 'Red';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DropdownButton Demo'),
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
                        'Basic Dropdown',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: 200,
                        child: DropdownButton<String>(
                          key: const Key('fruit_dropdown'),
                          hint: const Text('Select a dropdown'),
                          value: _selectedFruit,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(
                                value: 'apple', child: Text('dropdown1')),
                            DropdownMenuItem(
                                value: 'banana', child: Text('dropdown2')),
                            DropdownMenuItem(
                                value: 'cherry', child: Text('dropdown3')),
                            DropdownMenuItem(
                                value: 'orange', child: Text('dropdown4')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedFruit = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        key: const Key('selected_fruit_text'),
                        'Selected: ${_selectedFruit ?? 'None'}',
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
                        'Dropdown with Icons',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButton<String>(
                        key: const Key('country_dropdown'),
                        hint: const Text('Select a country'),
                        value: _selectedCountry,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(
                            value: 'usa',
                            child: Row(
                              children: [
                                Icon(Icons.flag, color: Colors.blue),
                                SizedBox(width: 8),
                                Text('United States'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'uk',
                            child: Row(
                              children: [
                                Icon(Icons.flag, color: Colors.red),
                                SizedBox(width: 8),
                                Text('United Kingdom'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'japan',
                            child: Row(
                              children: [
                                Icon(Icons.flag, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Japan'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'thailand',
                            child: Row(
                              children: [
                                Icon(Icons.flag, color: Colors.blue),
                                SizedBox(width: 8),
                                Text('Thailand'),
                              ],
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCountry = value;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        key: const Key('selected_country_text'),
                        'Selected: ${_selectedCountry ?? 'None'}',
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
                        'Numeric Dropdown',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButton<int>(
                        key: const Key('number_dropdown'),
                        hint: const Text('Select a number'),
                        value: _selectedNumber,
                        isExpanded: true,
                        items: List.generate(10, (index) {
                          return DropdownMenuItem(
                            value: index + 1,
                            child: Text('Number ${index + 1}'),
                          );
                        }),
                        onChanged: (value) {
                          setState(() {
                            _selectedNumber = value;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        key: const Key('selected_number_text'),
                        'Selected: ${_selectedNumber ?? 'None'}',
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
                        'Styled Dropdown',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<String>(
                          key: const Key('color_dropdown'),
                          value: _selectedColor,
                          isExpanded: true,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(value: 'Red', child: Text('Red')),
                            DropdownMenuItem(
                                value: 'Green', child: Text('Green')),
                            DropdownMenuItem(
                                value: 'Blue', child: Text('Blue')),
                            DropdownMenuItem(
                                value: 'Yellow', child: Text('Yellow')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedColor = value;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        key: const Key('color_preview'),
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: _getColorFromString(_selectedColor),
                          borderRadius: BorderRadius.circular(8),
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
                        'Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        key: const Key('summary_text'),
                        'Fruit: ${_selectedFruit ?? 'Not selected'}\n'
                        'Country: ${_selectedCountry ?? 'Not selected'}\n'
                        'Number: ${_selectedNumber ?? 'Not selected'}\n'
                        'Color: $_selectedColor',
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

  Color _getColorFromString(String color) {
    switch (color) {
      case 'Red':
        return Colors.red;
      case 'Green':
        return Colors.green;
      case 'Blue':
        return Colors.blue;
      case 'Yellow':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }
}
