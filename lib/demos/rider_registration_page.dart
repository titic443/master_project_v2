import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/rider_cubit.dart';
import 'package:master_project/cubit/rider_state.dart';

class RiderRegistrationPage extends StatelessWidget {
  const RiderRegistrationPage({super.key});

  static const route = '/rider-registration';

  @override
  Widget build(BuildContext context) {
    return const _RiderRegistrationForm();
  }
}

class _RiderRegistrationForm extends StatefulWidget {
  const _RiderRegistrationForm();

  @override
  State<_RiderRegistrationForm> createState() => _RiderRegistrationFormState();
}

class _RiderRegistrationFormState extends State<_RiderRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _licensePlateController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _licensePlateController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<RiderCubit>().submitRiderRegistration();
    }
  }

  void _syncControllers(RiderState state) {
    _updateController(_fullNameController, state.fullName);
    _updateController(_phoneController, state.phone);
    _updateController(_emailController, state.email);
    _updateController(_licensePlateController, state.licensePlate);
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
          'Rider Registration Form',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocListener<RiderCubit, RiderState>(
        listener: (context, state) {
          if (state.status == RiderStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                key: Key('rider_01_expected_success'),
                content: Text(
                  'Rider registered successfully',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            );
          } else if (state.status == RiderStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                key: const Key('rider_01_expected_fail'),
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
        child: BlocBuilder<RiderCubit, RiderState>(
          builder: (context, state) {
            _syncControllers(state);
            final isLoading = state.status == RiderStatus.loading;
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // 1. Full Name - TextFormField
                    TextFormField(
                      key: const Key('rider_01_fullname_textfield'),
                      controller: _fullNameController,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'ชื่อ-นามสกุล',
                        labelStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Zก-๙\s]')),
                        LengthLimitingTextInputFormatter(100),
                      ],
                      onChanged: (value) {
                        context.read<RiderCubit>().onFullNameChanged(value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Full name is required';
                        }
                        if (!RegExp(r'^[a-zA-Zก-๙\s]{4,}$')
                            .hasMatch(value)) {
                          return 'Full name must contain only letters and spaces (minimum 4 characters)';
                        }
                        return null;
                      },
                    ),
                    // 2. Phone - TextFormField
                    TextFormField(
                      key: const Key('rider_02_phone_textfield'),
                      controller: _phoneController,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'เบอร์โทรศัพท์',
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
                        context.read<RiderCubit>().onPhoneChanged(value);
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
                    // 3. Email - TextFormField
                    TextFormField(
                      key: const Key('rider_03_email_textfield'),
                      controller: _emailController,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'อีเมล',
                        labelStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                        hintText: 'rider@example.com',
                        hintStyle: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(100),
                      ],
                      onChanged: (value) {
                        context.read<RiderCubit>().onEmailChanged(value);
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
                    // 4. Vehicle Type - DropdownButtonFormField
                    DropdownButtonFormField<String>(
                      key: const Key('rider_04_vehicle_dropdown'),
                      value: state.vehicleType,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'ประเภทยานพาหนะ',
                        labelStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'motorcycle',
                          child: Text('จักรยานยนต์',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                        ),
                        DropdownMenuItem(
                          value: 'car',
                          child: Text('รถยนต์',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                        ),
                        DropdownMenuItem(
                          value: 'bicycle',
                          child: Text('จักรยาน',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                        ),
                      ],
                      onChanged: (value) {
                        context.read<RiderCubit>().onVehicleTypeChanged(value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a vehicle type';
                        }
                        return null;
                      },
                    ),
                    // 5. License Plate - TextFormField
                    TextFormField(
                      key: const Key('rider_05_license_textfield'),
                      controller: _licensePlateController,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'เลขทะเบียนรถ',
                        labelStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9ก-๙\s\-]')),
                        LengthLimitingTextInputFormatter(20),
                      ],
                      onChanged: (value) {
                        context.read<RiderCubit>().onLicensePlateChanged(value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'License plate is required';
                        }
                        if (value.length < 2) {
                          return 'License plate must be at least 2 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // 6. Service Zone - FormField with Radio buttons
                    FormField<int>(
                      key: const Key('rider_06_zone_formfield'),
                      initialValue: state.serviceZone,
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a service zone';
                        }
                        return null;
                      },
                      builder: (FormFieldState<int> formState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'เขตให้บริการ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Row(
                                  children: [
                                    Radio<int>(
                                      key: const Key(
                                          'rider_06_zone_inner_radio'),
                                      value: 1,
                                      groupValue: state.serviceZone,
                                      onChanged: (value) {
                                        if (value != null) {
                                          context
                                              .read<RiderCubit>()
                                              .onServiceZoneSelected(value);
                                          formState.didChange(value);
                                        }
                                      },
                                    ),
                                    const Text(
                                      'กรุงเทพฯ ชั้นใน',
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
                                          'rider_06_zone_outer_radio'),
                                      value: 2,
                                      groupValue: state.serviceZone,
                                      onChanged: (value) {
                                        if (value != null) {
                                          context
                                              .read<RiderCubit>()
                                              .onServiceZoneSelected(value);
                                          formState.didChange(value);
                                        }
                                      },
                                    ),
                                    const Text(
                                      'ชั้นนอก',
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
                                          'rider_06_zone_suburban_radio'),
                                      value: 3,
                                      groupValue: state.serviceZone,
                                      onChanged: (value) {
                                        if (value != null) {
                                          context
                                              .read<RiderCubit>()
                                              .onServiceZoneSelected(value);
                                          formState.didChange(value);
                                        }
                                      },
                                    ),
                                    const Text(
                                      'ปริมณฑล',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
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
                    // 7. Accept Terms - FormField with Checkbox
                    FormField<bool>(
                      key: const Key('rider_07_terms_formfield'),
                      initialValue: state.acceptTerms,
                      validator: (value) {
                        if (value == null || !value) {
                          return 'You must accept the terms and conditions';
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
                                      'rider_07_terms_checkbox'),
                                  value: state.acceptTerms,
                                  onChanged: (value) {
                                    context
                                        .read<RiderCubit>()
                                        .onAcceptTermsChanged(value ?? false);
                                    formState.didChange(value);
                                  },
                                ),
                                const Text(
                                  'ยอมรับเงื่อนไข',
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
                    // 8. Receive Promotions - Checkbox (optional, no FormField)
                    Row(
                      children: [
                        Checkbox(
                          key: const Key('rider_08_promo_checkbox'),
                          value: state.receivePromotions,
                          onChanged: (value) {
                            context
                                .read<RiderCubit>()
                                .onReceivePromotionsChanged(value ?? false);
                          },
                        ),
                        const Text(
                          'รับข่าวสารโปรโมชัน',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // 9. Submit button
                    ElevatedButton(
                      key: const Key('rider_09_end_button'),
                      onPressed: isLoading ? null : _handleSubmit,
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'สมัครไรเดอร์',
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
