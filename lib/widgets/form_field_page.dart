import 'package:flutter/material.dart';

class FormFieldDemo extends StatefulWidget {
  const FormFieldDemo({super.key});

  @override
  State<FormFieldDemo> createState() => _FormFieldDemoState();
}

class _FormFieldDemoState extends State<FormFieldDemo> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedColor;
  int? _rating;
  bool? _agreed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FormField Demo'),
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
                          'Custom FormField Examples',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        FormField<String>(
                          key: const Key('color_formfield'),
                          initialValue: _selectedColor,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a color';
                            }
                            return null;
                          },
                          builder: (formFieldState) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Select a Color:'),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  children: ['Red', 'Green', 'Blue', 'Yellow']
                                      .map((color) => ChoiceChip(
                                            key: Key('color_${color.toLowerCase()}'),
                                            label: Text(color),
                                            selected: _selectedColor == color,
                                            onSelected: (selected) {
                                              setState(() {
                                                _selectedColor = selected ? color : null;
                                              });
                                              formFieldState.didChange(_selectedColor);
                                            },
                                          ))
                                      .toList(),
                                ),
                                if (formFieldState.hasError)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      formFieldState.errorText!,
                                      key: const Key('color_error'),
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.error,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        FormField<int>(
                          key: const Key('rating_formfield'),
                          initialValue: _rating,
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a rating';
                            }
                            return null;
                          },
                          builder: (formFieldState) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Rate your experience:'),
                                const SizedBox(height: 8),
                                Row(
                                  children: List.generate(5, (index) {
                                    final starValue = index + 1;
                                    return IconButton(
                                      key: Key('star_$starValue'),
                                      icon: Icon(
                                        _rating != null && _rating! >= starValue
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.amber,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _rating = starValue;
                                        });
                                        formFieldState.didChange(_rating);
                                      },
                                    );
                                  }),
                                ),
                                if (formFieldState.hasError)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      formFieldState.errorText!,
                                      key: const Key('rating_error'),
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.error,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        FormField<bool>(
                          key: const Key('agreement_formfield'),
                          initialValue: _agreed,
                          validator: (value) {
                            if (value != true) {
                              return 'You must agree to continue';
                            }
                            return null;
                          },
                          builder: (formFieldState) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CheckboxListTile(
                                  title: const Text('I agree to the terms and conditions'),
                                  value: _agreed ?? false,
                                  onChanged: (value) {
                                    setState(() {
                                      _agreed = value;
                                    });
                                    formFieldState.didChange(value);
                                  },
                                ),
                                if (formFieldState.hasError)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text(
                                      formFieldState.errorText!,
                                      key: const Key('agreement_error'),
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.error,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            key: const Key('validate_button'),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('All fields validated!'),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
