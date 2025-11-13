import 'package:flutter/material.dart';

class RadioDemo extends StatefulWidget {
  const RadioDemo({super.key});

  @override
  State<RadioDemo> createState() => _RadioDemoState();
}

class _RadioDemoState extends State<RadioDemo> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedGender;
  String? _selectedSize;
  int? _selectedPayment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radio Demo'),
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
                          'Radio Button with Validation',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        FormField<int>(
                          key: const Key('gender_radio_group'),
                          initialValue: _selectedGender,
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a gender';
                            }
                            return null;
                          },
                          builder: (formFieldState) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Group1:'),
                                RadioListTile<int>(
                                  key: const Key('male_radio'),
                                  title: const Text('Radio1'),
                                  value: 1,
                                  groupValue: _selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedGender = value;
                                    });
                                    formFieldState.didChange(value);
                                  },
                                ),
                                RadioListTile<int>(
                                  key: const Key('female_radio'),
                                  title: const Text('Radio2'),
                                  value: 2,
                                  groupValue: _selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedGender = value;
                                    });
                                    formFieldState.didChange(value);
                                  },
                                ),
                                RadioListTile<int>(
                                  key: const Key('other_radio'),
                                  title: const Text('Other'),
                                  value: 3,
                                  groupValue: _selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedGender = value;
                                    });
                                    formFieldState.didChange(value);
                                  },
                                ),
                                if (formFieldState.hasError)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text(
                                      formFieldState.errorText!,
                                      key: const Key('gender_error'),
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
                          'T-Shirt Size',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        FormField<String>(
                          key: const Key('size_radio_group'),
                          initialValue: _selectedSize,
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a size';
                            }
                            return null;
                          },
                          builder: (formFieldState) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: ['S', 'M', 'L', 'XL'].map((size) {
                                    return Expanded(
                                      child: RadioListTile<String>(
                                        key: Key(
                                            'size_${size.toLowerCase()}_radio'),
                                        title: Text(size),
                                        value: size,
                                        groupValue: _selectedSize,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedSize = value;
                                          });
                                          formFieldState.didChange(value);
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ),
                                if (formFieldState.hasError)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text(
                                      formFieldState.errorText!,
                                      key: const Key('size_error'),
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
                          'Payment Method',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        FormField<int>(
                          key: const Key('payment_radio_group'),
                          initialValue: _selectedPayment,
                          builder: (formFieldState) {
                            return Column(
                              children: [
                                RadioListTile<int>(
                                  key: const Key('credit_card_radio'),
                                  title: const Text('Credit Card'),
                                  subtitle:
                                      const Text('Visa, Mastercard, etc.'),
                                  value: 1,
                                  groupValue: _selectedPayment,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedPayment = value;
                                    });
                                    formFieldState.didChange(value);
                                  },
                                ),
                                RadioListTile<int>(
                                  key: const Key('bank_transfer_radio'),
                                  title: const Text('Bank Transfer'),
                                  subtitle: const Text('Direct bank payment'),
                                  value: 2,
                                  groupValue: _selectedPayment,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedPayment = value;
                                    });
                                    formFieldState.didChange(value);
                                  },
                                ),
                                RadioListTile<int>(
                                  key: const Key('cash_radio'),
                                  title: const Text('Cash on Delivery'),
                                  subtitle: const Text('Pay when you receive'),
                                  value: 3,
                                  groupValue: _selectedPayment,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedPayment = value;
                                    });
                                    formFieldState.didChange(value);
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    key: const Key('submit_button'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Form Submitted Successfully!'),
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
      ),
    );
  }
}
