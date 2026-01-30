import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:master_project/cubit/customer_cubit.dart';
import 'package:master_project/cubit/customer_state.dart';
import 'package:provider/provider.dart';

class CustomerDetailsPage extends StatelessWidget {
  const CustomerDetailsPage({super.key});

  static const route = '/customer-details';

  @override
  Widget build(BuildContext context) {
    return const _CustomerDetailsForm();
  }
}

class _CustomerDetailsForm extends StatefulWidget {
  const _CustomerDetailsForm();

  @override
  State<_CustomerDetailsForm> createState() => _CustomerDetailsFormState();
}

class _CustomerDetailsFormState extends State<_CustomerDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<CustomerCubit>().submitCustomerDetails();
    }
  }

  void _syncControllers(CustomerState state) {
    _updateController(_firstNameController, state.firstName);
    _updateController(_phoneController, state.phoneNumber);
    _updateController(_lastNameController, state.lastName);
  }

  void _updateController(TextEditingController controller, String value) {
    if (controller.text == value) return;
    controller.value = controller.value.copyWith(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
      composing: TextRange.empty,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Customer Details Form',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocListener<CustomerCubit, CustomerState>(
        listener: (context, state) {
          if (state.status == CustomerStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                key: Key('customer_01_expected_success'),
                content: Text(
                  'Form submitted successfully',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            );
          } else if (state.status == CustomerStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                key: const Key('customer_01_expected_fail'),
                content: Text(
                  state.errorMessage ?? 'Unknown error',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<CustomerCubit, CustomerState>(
          builder: (context, state) {
            _syncControllers(state);
            final isLoading = state.status == CustomerStatus.loading;
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('XXXXXX', key: const Key('customer_99_XXXX_text')),
                    // Title - Dropdown
                    DropdownButtonFormField<String>(
                      key: const Key('customer_01_title_dropdown'),
                      value: state.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Mr.',
                          child: Text('Mr.',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                        ),
                        DropdownMenuItem(
                          value: 'Mrs.',
                          child: Text('Mrs.',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                        ),
                        DropdownMenuItem(
                          value: 'Ms.',
                          child: Text('Ms.',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                        ),
                        DropdownMenuItem(
                          value: 'Dr.',
                          child: Text('Dr.',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                        ),
                      ],
                      onChanged: (value) {
                        context.read<CustomerCubit>().onTitleChanged(value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a title';
                        }
                        return null;
                      },
                    ),
                    // First Name - TextFormField
                    TextFormField(
                      key: const Key('customer_02_firstname_textfield'),
                      controller: _firstNameController,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        labelStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                        LengthLimitingTextInputFormatter(50),
                      ],
                      onChanged: (value) {
                        context.read<CustomerCubit>().onFirstNameChanged(value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'First name is required';
                        }
                        if (!RegExp(r'^[a-zA-Z]{2,}$').hasMatch(value)) {
                          return 'First name must contain only letters (minimum 2 characters)';
                        }
                        return null;
                      },
                    ),
                    // Phone Number - TextFormField (digits only)
                    TextFormField(
                      key: const Key('customer_03_phone_textfield'),
                      controller: _phoneController,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                        hintText: '0812345678',
                        hintStyle: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      onChanged: (value) {
                        context
                            .read<CustomerCubit>()
                            .onPhoneNumberChanged(value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone number is required';
                        }
                        if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                          return 'Phone number must be exactly 10 digits';
                        }
                        if (!value.startsWith('0')) {
                          return 'Phone number must start with 0';
                        }
                        return null;
                      },
                    ),
                    // Last Name - TextFormField
                    TextFormField(
                      key: const Key('customer_04_lastname_textfield'),
                      controller: _lastNameController,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        labelStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      maxLength: 10,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                        LengthLimitingTextInputFormatter(50),
                      ],
                      onChanged: (value) {
                        context.read<CustomerCubit>().onLastNameChanged(value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Last name is required';
                        }
                        if (!RegExp(r'^[a-zA-Z]{2,}$').hasMatch(value)) {
                          return 'Last name must contain only letters (minimum 2 characters)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Age Range - FormField with Radio buttons
                    FormField<int>(
                      key: const Key('customer_05_age_range_formfield'),
                      initialValue: state.ageRange,
                      validator: (value) {
                        if (value == null) {
                          return 'Please select an age range';
                        }
                        return null;
                      },
                      builder: (FormFieldState<int> formState) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Age Range',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Row(
                              children: [
                                Radio<int>(
                                  key: const Key('customer_05_age_10_20_radio'),
                                  value: 1,
                                  groupValue: state.ageRange,
                                  onChanged: (value) {
                                    if (value != null) {
                                      context
                                          .read<CustomerCubit>()
                                          .onAgeRangeSelected(value);
                                      // formState.didChange(value);
                                    }
                                  },
                                ),
                                const Text(
                                  '10-20',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Radio<int>(
                                  key: const Key('customer_05_age_30_40_radio'),
                                  value: 2,
                                  groupValue: state.ageRange,
                                  onChanged: (value) {
                                    if (value != null) {
                                      context
                                          .read<CustomerCubit>()
                                          .onAgeRangeSelected(value);
                                      formState.didChange(value);
                                    }
                                  },
                                ),
                                const Text(
                                  '30-40',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Radio<int>(
                                  key: const Key('customer_05_age_40_50_radio'),
                                  value: 3,
                                  groupValue: state.ageRange,
                                  onChanged: (value) {
                                    if (value != null) {
                                      context
                                          .read<CustomerCubit>()
                                          .onAgeRangeSelected(value);
                                      formState.didChange(value);
                                    }
                                  },
                                ),
                                const Text(
                                  '50-60',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            if (formState.hasError)
                              Text(
                                formState.errorText!,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 12),
                              ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    // Agree to terms - FormField with Checkbox
                    FormField<bool>(
                      key: const Key('customer_06_agree_terms_formfield'),
                      initialValue: state.agreeToTerms,
                      validator: (value) {
                        if (value == null || !value) {
                          return 'You must agree to terms';
                        }
                        return null;
                      },
                      builder: (FormFieldState<bool> formState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  key: const Key(
                                      'customer_06_agree_terms_checkbox'),
                                  value: state.agreeToTerms,
                                  onChanged: (value) {
                                    context
                                        .read<CustomerCubit>()
                                        .onAgreeToTermsChanged(value ?? false);
                                    formState.didChange(value);
                                  },
                                ),
                                const Text(
                                  'Agree to terms',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            if (formState.hasError)
                              Text(
                                formState.errorText!,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 12),
                              ),
                          ],
                        );
                      },
                    ),
                    // Subscribe newsletter - Checkbox (no FormField, optional)
                    Row(
                      children: [
                        Checkbox(
                          key: const Key(
                              'customer_07_subscribe_newsletter_checkbox'),
                          value: state.subscribeNewsletter,
                          onChanged: (value) {
                            context
                                .read<CustomerCubit>()
                                .onSubscribeNewsletterChanged(value ?? false);
                          },
                        ),
                        const Text(
                          'Subscribe to newsletter',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Submit button
                    ElevatedButton(
                      key: const Key('customer_08_end_button'),
                      onPressed: isLoading ? null : _handleSubmit,
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Submit',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
