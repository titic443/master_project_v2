import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/linkedin_cubit.dart';
import 'package:master_project/cubit/linkedin_state.dart';

class LinkedinProfilePage extends StatelessWidget {
  const LinkedinProfilePage({super.key});

  static const route = '/linkedin-profile';

  @override
  Widget build(BuildContext context) {
    return const _LinkedinProfileForm();
  }
}

class _LinkedinProfileForm extends StatefulWidget {
  const _LinkedinProfileForm();

  @override
  State<_LinkedinProfileForm> createState() => _LinkedinProfileFormState();
}

class _LinkedinProfileFormState extends State<_LinkedinProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _positionController = TextEditingController();
  final _companyController = TextEditingController();
  final _experienceController = TextEditingController();
  final _universityController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _positionController.dispose();
    _companyController.dispose();
    _experienceController.dispose();
    _universityController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<LinkedinCubit>().submitProfile();
    }
  }

  void _syncControllers(LinkedinState state) {
    _updateController(_fullNameController, state.fullName);
    _updateController(_emailController, state.email);
    _updateController(_positionController, state.position);
    _updateController(_companyController, state.company);
    _updateController(
        _experienceController, state.experience?.toString() ?? '');
    _updateController(_universityController, state.university);
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
          'LinkedIn Profile Registration',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocListener<LinkedinCubit, LinkedinState>(
        listener: (context, state) {
          if (state.status == LinkedinStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                key: Key('linkedin_01_expected_success'),
                content: Text(
                  'Profile submitted successfully',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            );
          } else if (state.status == LinkedinStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                key: const Key('linkedin_01_expected_fail'),
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
        child: BlocBuilder<LinkedinCubit, LinkedinState>(
          builder: (context, state) {
            _syncControllers(state);
            final isLoading = state.status == LinkedinStatus.loading;
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      // Full Name - TextFormField
                      TextFormField(
                        key: const Key('linkedin_02_fullname_textfield'),
                        controller: _fullNameController,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          labelStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z\s]')),
                          LengthLimitingTextInputFormatter(100),
                        ],
                        onChanged: (value) {
                          context
                              .read<LinkedinCubit>()
                              .onFullNameChanged(value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Full name is required';
                          }
                          if (value.trim().length < 2) {
                            return 'Full name must be at least 2 characters';
                          }
                          if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                            return 'Full name must contain only letters and spaces';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Email - TextFormField
                      TextFormField(
                        key: const Key('linkedin_03_email_textfield'),
                        controller: _emailController,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          hintText: 'name@example.com',
                          hintStyle: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                        ],
                        onChanged: (value) {
                          context.read<LinkedinCubit>().onEmailChanged(value);
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
                      // Position - TextFormField
                      TextFormField(
                        key: const Key('linkedin_04_position_textfield'),
                        controller: _positionController,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Current Position',
                          labelStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(100),
                        ],
                        onChanged: (value) {
                          context
                              .read<LinkedinCubit>()
                              .onPositionChanged(value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Position is required';
                          }
                          if (value.trim().length < 2) {
                            return 'Position must be at least 2 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Company - TextFormField
                      TextFormField(
                        key: const Key('linkedin_05_company_textfield'),
                        controller: _companyController,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Company / Organization',
                          labelStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(100),
                        ],
                        onChanged: (value) {
                          context.read<LinkedinCubit>().onCompanyChanged(value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Company is required';
                          }
                          if (value.trim().length < 2) {
                            return 'Company must be at least 2 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Experience - TextFormField (number)
                      TextFormField(
                        key: const Key('linkedin_06_experience_textfield'),
                        controller: _experienceController,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Years of Experience',
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
                              .read<LinkedinCubit>()
                              .onExperienceChanged(value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Years of experience is required';
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
                      const SizedBox(height: 16),
                      // Employment Type - Dropdown
                      DropdownButtonFormField<String>(
                        key: const Key('linkedin_07_employment_dropdown'),
                        value: state.employmentType,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Employment Type',
                          labelStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Full-time',
                            child: Text('Full-time',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                          ),
                          DropdownMenuItem(
                            value: 'Part-time',
                            child: Text('Part-time',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                          ),
                          DropdownMenuItem(
                            value: 'Contract',
                            child: Text('Contract',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                          ),
                          DropdownMenuItem(
                            value: 'Freelance',
                            child: Text('Freelance',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                          ),
                        ],
                        onChanged: (value) {
                          context
                              .read<LinkedinCubit>()
                              .onEmploymentTypeChanged(value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an employment type';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      // Education Level - FormField with Radio buttons
                      FormField<int>(
                        key: const Key('linkedin_08_education_formfield'),
                        initialValue: state.educationLevel,
                        validator: (value) {
                          if (value == null) {
                            return 'Please select an education level';
                          }
                          return null;
                        },
                        builder: (FormFieldState<int> formState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Education Level',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              Row(
                                children: [
                                  Radio<int>(
                                    key: const Key(
                                        'linkedin_08_education_bachelor_radio'),
                                    value: 1,
                                    groupValue: state.educationLevel,
                                    onChanged: (value) {
                                      if (value != null) {
                                        context
                                            .read<LinkedinCubit>()
                                            .onEducationLevelSelected(value);
                                        formState.didChange(value);
                                      }
                                    },
                                  ),
                                  const Text(
                                    'Bachelor',
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
                                        'linkedin_08_education_master_radio'),
                                    value: 2,
                                    groupValue: state.educationLevel,
                                    onChanged: (value) {
                                      if (value != null) {
                                        context
                                            .read<LinkedinCubit>()
                                            .onEducationLevelSelected(value);
                                        formState.didChange(value);
                                      }
                                    },
                                  ),
                                  const Text(
                                    'Master',
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
                                        'linkedin_08_education_phd_radio'),
                                    value: 3,
                                    groupValue: state.educationLevel,
                                    onChanged: (value) {
                                      if (value != null) {
                                        context
                                            .read<LinkedinCubit>()
                                            .onEducationLevelSelected(value);
                                        formState.didChange(value);
                                      }
                                    },
                                  ),
                                  const Text(
                                    'PhD',
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
                      // University - TextFormField
                      TextFormField(
                        key: const Key('linkedin_09_university_textfield'),
                        controller: _universityController,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'University / Institution',
                          labelStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(100),
                        ],
                        onChanged: (value) {
                          context
                              .read<LinkedinCubit>()
                              .onUniversityChanged(value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'University is required';
                          }
                          if (value.trim().length < 2) {
                            return 'University must be at least 2 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Agree Terms - FormField with Checkbox
                      FormField<bool>(
                        key: const Key('linkedin_10_agree_terms_formfield'),
                        initialValue: state.agreeTerms,
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
                                        'linkedin_10_agree_terms_checkbox'),
                                    value: state.agreeTerms,
                                    onChanged: (value) {
                                      context
                                          .read<LinkedinCubit>()
                                          .onAgreeTermsChanged(value ?? false);
                                      formState.didChange(value);
                                    },
                                  ),
                                  const Text(
                                    'I agree to the terms and conditions',
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
                      // Open to Work - Checkbox (optional)
                      Row(
                        children: [
                          Checkbox(
                            key: const Key(
                                'linkedin_11_open_to_work_checkbox'),
                            value: state.openToWork,
                            onChanged: (value) {
                              context
                                  .read<LinkedinCubit>()
                                  .onOpenToWorkChanged(value ?? false);
                            },
                          ),
                          const Text(
                            'Open to work',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Submit button
                      ElevatedButton(
                        key: const Key('linkedin_12_end_button'),
                        onPressed: isLoading ? null : _handleSubmit,
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text(
                                'Submit Profile',
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
