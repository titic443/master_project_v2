import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/login_cubit.dart';
import 'package:master_project/cubit/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const route = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginCubit _cubit;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _cubit = context.read<LoginCubit>();
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
      appBar: AppBar(title: const Text('เข้าสู่ระบบ')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocListener<LoginCubit, LoginState>(
          listenWhen: (prev, next) =>
              prev.response != next.response || prev.exception != next.exception,
          listener: (context, state) async {
            final response = state.response;
            if (response != null && response.code == 200) {
              await _showStatusDialog(
                context,
                message: 'Login successful',
                messageKey: const Key('login_status_200'),
              );
              if (!context.mounted) return;
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const _DashboardPage()),
              );
              return;
            }

            final exception = state.exception;
            if (exception != null) {
              final isUnauthorized = exception.code == 401;
              await _showStatusDialog(
                context,
                message: isUnauthorized
                    ? 'Invalid credentials'
                    : 'Server error ${exception.code}',
                messageKey: Key(isUnauthorized
                    ? 'login_status_401'
                    : 'login_status_${exception.code}'),
              );
            }
          },
          child: BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              _syncControllers(state);
              final theme = Theme.of(context);
              return Center(
                child: SingleChildScrollView(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Icon(
                              Icons.lock_person_rounded,
                              size: 64,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'ยินดีต้อนรับกลับมา',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'กรุณาเข้าสู่ระบบเพื่อดำเนินการต่อ',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 32),
                            _buildUsernameField(),
                            const SizedBox(height: 16),
                            _buildPasswordField(),
                            const SizedBox(height: 16),
                            _buildRememberMeCheckbox(state),
                            const SizedBox(height: 24),
                            _buildLoginButton(),
                            const SizedBox(height: 16),
                            TextButton(
                              key: const Key('forgot_password_button'),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Forgot password clicked'),
                                  ),
                                );
                              },
                              child: const Text('ลืมรหัสผ่าน?'),
                            ),
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
      key: const Key('login_username_textfield'),
      controller: _usernameController,
      decoration: const InputDecoration(
        labelText: 'ชื่อผู้ใช้',
        prefixIcon: Icon(Icons.person_outline),
        border: OutlineInputBorder(),
      ),
      onChanged: (value) => _cubit.onUsernameChanged(value),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Required';
        return null;
      },
    );
  }

  TextFormField _buildPasswordField() {
    return TextFormField(
      key: const Key('login_password_textfield'),
      controller: _passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'รหัสผ่าน',
        prefixIcon: Icon(Icons.lock_outline),
        border: OutlineInputBorder(),
      ),
      onChanged: (value) => _cubit.onPasswordChanged(value),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Required';
        return null;
      },
    );
  }

  Widget _buildRememberMeCheckbox(LoginState state) {
    return CheckboxListTile(
      key: const Key('remember_me_checkbox'),
      title: const Text('จดจำฉันไว้'),
      value: state.rememberMe,
      onChanged: (value) => _cubit.onRememberMeChanged(value ?? false),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        key: const Key('login_submit_button'),
        onPressed: () async {
          final isValid = _formKey.currentState?.validate() ?? false;
          if (!isValid) return;
          await _cubit.callApi();
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text(
          'เข้าสู่ระบบ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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

  void _syncControllers(LoginState state) {
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

class _DashboardPage extends StatelessWidget {
  const _DashboardPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('login_dashboard_root'),
      appBar: AppBar(title: const Text('Dashboard')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 64, color: Colors.green),
            SizedBox(height: 16),
            Text(
              'Login Successful!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
