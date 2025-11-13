import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/register_cubit.dart';
import 'package:master_project/cubit/register_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static const route = '/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final RegisterCubit _cubit;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _cubit = context.read<RegisterCubit>();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _cubit.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('หน้าสมัครสมาชิก')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocListener<RegisterCubit, RegisterState>(
          listenWhen: (prev, next) =>
              prev.response != next.response ||
              prev.exception != next.exception,
          listener: (context, state) async {
            final response = state.response;
            if (response != null && response.code == 200) {
              await _showStatusDialog(
                context,
                message: 'success',
                messageKey: const Key('register_09_status_200'),
              );
              if (!context.mounted) return;
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const _NextPage()),
              );
              return;
            }

            final exception = state.exception;
            if (exception != null) {
              final isBadRequest = exception.code == 400;
              await _showStatusDialog(
                context,
                message: isBadRequest ? 'error 400' : 'error 500',
                messageKey: Key(isBadRequest
                    ? 'register_10_status_400'
                    : 'register_11_status_500'),
              );
            }
          },
          child: BlocBuilder<RegisterCubit, RegisterState>(
            builder: (context, state) {
              _syncControllers(state);
              final theme = Theme.of(context);
              return SingleChildScrollView(
                child: Center(
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 32),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'สมัครสมาชิก',
                              style: theme.textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'กรอกข้อมูลเพื่อเริ่มต้นใช้งานแอปพลิเคชัน',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant),
                            ),
                            const SizedBox(height: 28),
                            Text('ข้อมูลบัญชี',
                                style: theme.textTheme.titleMedium),
                            const SizedBox(height: 16),
                            _buildUsernameField(),
                            const SizedBox(height: 16),
                            _buildPasswordField(),
                            const SizedBox(height: 16),
                            _buildConfirmPasswordField(),
                            const SizedBox(height: 16),
                            _buildEmailField(),
                            const SizedBox(height: 32),
                            Text('รายละเอียดผู้สมัคร',
                                style: theme.textTheme.titleMedium),
                            const SizedBox(height: 16),
                            _buildPrimaryRadioGroup(state),
                            const SizedBox(height: 20),
                            _buildSecondaryRadioGroup(state),
                            const SizedBox(height: 32),
                            Text('ข้อมูลเพิ่มเติม',
                                style: theme.textTheme.titleMedium),
                            const SizedBox(height: 16),
                            _buildDropdownField(state),
                            const SizedBox(height: 36),
                            _buildSubmitButton(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  TextFormField _buildUsernameField() {
    return TextFormField(
      key: const Key('register_01_username_textfield'),
      controller: _usernameController,
      decoration: const InputDecoration(
        labelText: 'ชื่อผู้ใช้',
        prefixIcon: Icon(Icons.person_outline),
        border: OutlineInputBorder(),
        helperText: 'ใช้ตัวอักษรหรือเลขผสม ความยาวไม่เกิน 10 ตัว',
      ),
      maxLength: 10,
      onChanged: (value) {
        _cubit.onUsernameChanged(value);
      },
      validator: (value) {
        if (value == null || value.isEmpty) return 'Required';
        if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
          return 'Please enter a valid username';
        }
        return null;
      },
    );
  }

  TextFormField _buildPasswordField() {
    return TextFormField(
      key: const Key('register_02_password_textfield'),
      controller: _passwordController,
      decoration: const InputDecoration(
        labelText: 'รหัสผ่าน',
        prefixIcon: Icon(Icons.lock_outline),
        border: OutlineInputBorder(),
        helperText: 'ต้องมีตัวเลขอย่างน้อย 1 ตัว และสามารถใช้สัญลักษณ์พิเศษได้',
      ),
      onChanged: (value) {
        _cubit.onPasswordChanged(value);
      },
      validator: (value) {
        if (value == null || value.isEmpty) return 'Required';
        const pattern = r'^(?=.*[0-9])[a-zA-Z0-9@#\$%\^&\+=!\*\-_]+$';
        if (!RegExp(pattern).hasMatch(value)) {
          return 'Please enter a valid password';
        }
        return null;
      },
    );
  }

  TextFormField _buildConfirmPasswordField() {
    return TextFormField(
      key: const Key('register_03_confirm_password_textfield'),
      decoration: const InputDecoration(
        labelText: 'ยืนยันรหัสผ่าน',
        prefixIcon: Icon(Icons.lock_reset_outlined),
        border: OutlineInputBorder(),
        helperText: 'กรอกรหัสผ่านอีกครั้งเพื่อยืนยัน',
      ),
      obscureText: true,
      onChanged: (value) {
        _cubit.onConfirmPasswordChanged(value);
      },
      validator: (value) {
        if (value == null || value.isEmpty) return 'Required';
        if (value != _cubit.state.password) {
          return 'รหัสผ่านไม่ตรงกัน';
        }
        return null;
      },
    );
  }

  TextFormField _buildEmailField() {
    return TextFormField(
      key: const Key('register_04_email_textfield'),
      decoration: const InputDecoration(
        labelText: 'อีเมล',
        prefixIcon: Icon(Icons.mail_outline),
        border: OutlineInputBorder(),
      ),
      maxLength: 25,
      onChanged: (value) {
        _cubit.onEmailChanged(value);
      },
      validator: (value) {
        if (value == null || value.isEmpty) return 'Required';
        const pattern = r'^[a-zA-Z0-9@.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
        if (!RegExp(pattern).hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildPrimaryRadioGroup(RegisterState state) {
    return FormField<int>(
      key: const Key('register_05_gender_group'),
      initialValue: state.gender,
      validator: (value) {
        if (value == null) {
          return 'กรุณาเลือกตัวเลือก';
        }
        return null;
      },
      builder: (field) {
        final theme = Theme.of(field.context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('เพศ',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Row(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<int>(
                      key: const Key('register_05_gender_male_radio'),
                      value: 0,
                      groupValue: field.value,
                      onChanged: (value) {
                        if (value != null) {
                          field.didChange(value);
                          _cubit.onGenderSelected(value);
                        }
                      },
                    ),
                    const Text('ชาย'),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<int>(
                      key: const Key('register_05_gender_female_radio'),
                      value: 1,
                      groupValue: field.value,
                      onChanged: (value) {
                        if (value != null) {
                          field.didChange(value);
                          _cubit.onGenderSelected(value);
                        }
                      },
                    ),
                    const Text('หญิง'),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<int>(
                      key: const Key('register_05_gender_other_radio'),
                      value: 2,
                      groupValue: field.value,
                      onChanged: (value) {
                        if (value != null) {
                          field.didChange(value);
                          _cubit.onGenderSelected(value);
                        }
                      },
                    ),
                    const Text('ไม่ระบุ'),
                  ],
                ),
              ],
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(field.errorText!,
                    style: TextStyle(color: theme.colorScheme.error)),
              ),
          ],
        );
      },
    );
  }

  Widget _buildSecondaryRadioGroup(RegisterState state) {
    return FormField<int>(
      key: const Key('register_06_education_group'),
      initialValue: state.education,
      validator: (value) {
        if (value == null) {
          return 'กรุณาเลือกตัวเลือก';
        }
        return null;
      },
      builder: (field) {
        final theme = Theme.of(field.context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('การศึกษา',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Row(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<int>(
                      key: const Key('register_06_education_highschool_radio'),
                      value: 0,
                      groupValue: field.value,
                      onChanged: (value) {
                        if (value != null) {
                          field.didChange(value);
                          _cubit.onEducationSelected(value);
                        }
                      },
                    ),
                    const Text('มัธยม'),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<int>(
                      key: const Key('register_06_education_bachelor_radio'),
                      value: 1,
                      groupValue: field.value,
                      onChanged: (value) {
                        if (value != null) {
                          field.didChange(value);
                          _cubit.onEducationSelected(value);
                        }
                      },
                    ),
                    const Text('ปริญญาตรี'),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<int>(
                      key: const Key('register_06_education_master_radio'),
                      value: 2,
                      groupValue: field.value,
                      onChanged: (value) {
                        if (value != null) {
                          field.didChange(value);
                          _cubit.onEducationSelected(value);
                        }
                      },
                    ),
                    const Text('ปริญญาโท'),
                  ],
                ),
              ],
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(field.errorText!,
                    style: TextStyle(color: theme.colorScheme.error)),
              ),
          ],
        );
      },
    );
  }

  DropdownButtonFormField<String> _buildDropdownField(RegisterState state) {
    return DropdownButtonFormField<String>(
        key: const Key('register_07_age_dropdown'),
        decoration: const InputDecoration(
          labelText: 'อายุ',
          prefixIcon: Icon(Icons.calendar_month),
          border: OutlineInputBorder(),
        ),
        value: state.ageGroup,
        items: const [
          DropdownMenuItem(
            value: '18-25',
            child: Text('18 - 25 ปี', style: TextStyle(fontSize: 20)),
          ),
          DropdownMenuItem(
            value: '26-35',
            child: Text('26 - 35 ปี', style: TextStyle(fontSize: 20)),
          ),
          DropdownMenuItem(
            value: '36-45',
            child: Text('36 - 45 ปี', style: TextStyle(fontSize: 20)),
          ),
          DropdownMenuItem(
            value: '46+',
            child: Text('46 ปีขึ้นไป', style: TextStyle(fontSize: 20)),
          ),
        ],
        onChanged: (value) {
          _cubit.onAgeGroupSelected(value);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'กรุณาเลือกอายุ';
          }
          return null;
        });
  }

  Center _buildSubmitButton() {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          key: const Key('register_08_submit_endapi_button'),
          onPressed: () async {
            final isValid = _formKey.currentState?.validate() ?? false;
            if (!isValid) return;
            await _cubit.callApi();
          },
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16)),
          child: const Text('Register',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  Future<void> _showStatusDialog(
    BuildContext context, {
    required String message,
    required Key messageKey,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(message, key: messageKey),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _syncControllers(RegisterState state) {
    _updateController(_usernameController, state.username);
    _updateController(_passwordController, state.password);
  }

  void _updateController(TextEditingController controller, String value) {
    if (controller.text == value) return;
    controller.value = controller.value.copyWith(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
      composing: TextRange.empty,
    );
  }
}

class _NextPage extends StatelessWidget {
  const _NextPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('register_next_root'),
      appBar: AppBar(title: const Text('Next')),
      body: const Center(child: Text('Next Page')),
    );
  }
}
