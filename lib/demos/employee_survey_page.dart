import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/employee_cubit.dart';
import 'package:master_project/cubit/employee_state.dart';

class EmployeeSurveyPage extends StatelessWidget {
  const EmployeeSurveyPage({super.key});

  static const route = '/employee-survey';

  @override
  Widget build(BuildContext context) {
    return const _EmployeeSurveyForm();
  }
}

class _EmployeeSurveyForm extends StatefulWidget {
  const _EmployeeSurveyForm();

  @override
  State<_EmployeeSurveyForm> createState() => _EmployeeSurveyFormState();
}

class _EmployeeSurveyFormState extends State<_EmployeeSurveyForm> {
  final _formKey = GlobalKey<FormState>();
  final _employeeIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _yearsController = TextEditingController();

  @override
  void dispose() {
    _employeeIdController.dispose();
    _emailController.dispose();
    _yearsController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<EmployeeCubit>().submitEmployeeSurvey();
    }
  }

  void _syncControllers(EmployeeState state) {
    _updateController(_employeeIdController, state.employeeId);
    _updateController(_emailController, state.email);
    _updateController(
        _yearsController, state.yearsOfService?.toString() ?? '');
  }

  void _updateController(TextEditingController controller, String? value) {
    final val = value ?? '';
    if (controller.text == val) return;
    controller.value = controller.value.copyWith(
      text: val,
      selection: TextSelection.collapsed(offset: val.length),
      composing: TextRange.empty,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Employee Satisfaction Survey',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocListener<EmployeeCubit, EmployeeState>(
        listener: (context, state) {
          if (state.status == EmployeeStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                key: Key('employee_01_expected_success'),
                content: Text(
                  'Survey submitted successfully',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            );
          } else if (state.status == EmployeeStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                key: const Key('employee_01_expected_fail'),
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
        child: BlocBuilder<EmployeeCubit, EmployeeState>(
          builder: (context, state) {
            _syncControllers(state);
            final isLoading = state.status == EmployeeStatus.loading;
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      // Employee ID - TextFormField
                      TextFormField(
                        key: const Key('employee_02_id_textfield'),
                        controller: _employeeIdController,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Employee ID',
                          labelStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          hintText: 'EMP-12345',
                          hintStyle: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[A-Z0-9\-]')),
                          LengthLimitingTextInputFormatter(15),
                        ],
                        onChanged: (value) {
                          context
                              .read<EmployeeCubit>()
                              .onEmployeeIdChanged(value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Employee ID is required';
                          }
                          if (!RegExp(r'^EMP-\d{5}$').hasMatch(value)) {
                            return 'Employee ID must match format: EMP-12345';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Department - Dropdown
                      DropdownButtonFormField<String>(
                        key: const Key('employee_03_department_dropdown'),
                        value: state.department,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Department',
                          labelStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Engineering',
                            child: Text('Engineering',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                          ),
                          DropdownMenuItem(
                            value: 'Sales',
                            child: Text('Sales',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                          ),
                          DropdownMenuItem(
                            value: 'HR',
                            child: Text('HR',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                          ),
                          DropdownMenuItem(
                            value: 'Marketing',
                            child: Text('Marketing',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                          ),
                        ],
                        onChanged: (value) {
                          context
                              .read<EmployeeCubit>()
                              .onDepartmentChanged(value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a department';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Email - TextFormField
                      TextFormField(
                        key: const Key('employee_04_email_textfield'),
                        controller: _emailController,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          hintText: 'employee@company.com',
                          hintStyle: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                        ],
                        onChanged: (value) {
                          context.read<EmployeeCubit>().onEmailChanged(value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w{2,}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Years of Service - TextFormField (numbers only)
                      TextFormField(
                        key: const Key('employee_05_years_textfield'),
                        controller: _yearsController,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Years of Service',
                          labelStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          hintText: '5',
                          hintStyle: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                        onChanged: (value) {
                          context
                              .read<EmployeeCubit>()
                              .onYearsOfServiceChanged(value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Years of service is required';
                          }
                          final years = int.tryParse(value);
                          if (years == null || years < 0) {
                            return 'Years must be 0 or greater';
                          }
                          if (years > 50) {
                            return 'Years cannot exceed 50';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      // Satisfaction Rating - FormField with Radio buttons
                      FormField<int>(
                        key: const Key('employee_06_rating_formfield'),
                        initialValue: state.satisfactionRating,
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a satisfaction rating';
                          }
                          return null;
                        },
                        builder: (FormFieldState<int> formState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Satisfaction Rating',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              Row(
                                children: [
                                  Radio<int>(
                                    key: const Key(
                                        'employee_06_rating_poor_radio'),
                                    value: 1,
                                    groupValue: state.satisfactionRating,
                                    onChanged: (value) {
                                      if (value != null) {
                                        context
                                            .read<EmployeeCubit>()
                                            .onSatisfactionRatingSelected(value);
                                        formState.didChange(value);
                                      }
                                    },
                                  ),
                                  const Text(
                                    'Poor',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio<int>(
                                    key: const Key(
                                        'employee_06_rating_fair_radio'),
                                    value: 2,
                                    groupValue: state.satisfactionRating,
                                    onChanged: (value) {
                                      if (value != null) {
                                        context
                                            .read<EmployeeCubit>()
                                            .onSatisfactionRatingSelected(value);
                                        formState.didChange(value);
                                      }
                                    },
                                  ),
                                  const Text(
                                    'Fair',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio<int>(
                                    key: const Key(
                                        'employee_06_rating_excellent_radio'),
                                    value: 3,
                                    groupValue: state.satisfactionRating,
                                    onChanged: (value) {
                                      if (value != null) {
                                        context
                                            .read<EmployeeCubit>()
                                            .onSatisfactionRatingSelected(value);
                                        formState.didChange(value);
                                      }
                                    },
                                  ),
                                  const Text(
                                    'Excellent',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              if (formState.hasError)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    formState.errorText!,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 12),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      // Recommend Company - FormField with Checkbox
                      FormField<bool>(
                        key: const Key('employee_07_recommend_formfield'),
                        initialValue: state.recommendCompany,
                        validator: (value) {
                          if (value == null || !value) {
                            return 'You must recommend the company to proceed';
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
                                        'employee_07_recommend_checkbox'),
                                    value: state.recommendCompany,
                                    onChanged: (value) {
                                      context
                                          .read<EmployeeCubit>()
                                          .onRecommendCompanyChanged(
                                              value ?? false);
                                      formState.didChange(value);
                                    },
                                  ),
                                  const Text(
                                    'I would recommend this company',
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
                      // Attend Training - Checkbox (optional)
                      Row(
                        children: [
                          Checkbox(
                            key: const Key('employee_08_training_checkbox'),
                            value: state.attendTraining,
                            onChanged: (value) {
                              context
                                  .read<EmployeeCubit>()
                                  .onAttendTrainingChanged(value ?? false);
                            },
                          ),
                          const Text(
                            'Interested in training programs',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Submit button
                      ElevatedButton(
                        key: const Key('employee_09_end_button'),
                        onPressed: isLoading ? null : _handleSubmit,
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text(
                                'Submit Survey',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
