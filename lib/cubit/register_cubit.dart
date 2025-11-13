import 'package:bloc/bloc.dart';
import 'register_state.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class RegisterCubit extends Cubit<RegisterState> {
  final bool shouldSucceed;

  RegisterCubit({this.shouldSucceed = false}) : super(RegisterState.initial());

  void onUsernameChanged(String value) => emit(state.copyWith(username: value));

  void onPasswordChanged(String value) => emit(state.copyWith(password: value));

  void onConfirmPasswordChanged(String value) => emit(state.copyWith(confirmPassword: value));

  void onEmailChanged(String value) => emit(state.copyWith(email: value));

  void onGenderSelected(int selected) => emit(state.copyWith(gender: selected));

  void onEducationSelected(int selected) => emit(state.copyWith(education: selected));

  void onPlatformSelected(int selected) => emit(state.copyWith(platform: selected));

  void onAgeGroupSelected(String? value) => emit(state.copyWith(ageGroup: value));

  void onPrimaryButton() => emit(state.copyWith(count: state.count + 1));

  void reset() => emit(RegisterState.initial());

  Future<void> callApi() async {
    // Backend base URL can be overridden with --dart-define=BACKEND_URL=...
    const String envUrl = String.fromEnvironment('BACKEND_URL', defaultValue: '');
    String _defaultBaseUrl() {
      if (kIsWeb) return 'http://127.0.0.1:8000';
      try {
        if (Platform.isAndroid) return 'http://10.0.2.2:8000';
        if (Platform.isIOS || Platform.isMacOS) return 'http://127.0.0.1:8000';
        if (Platform.isWindows || Platform.isLinux) return 'http://127.0.0.1:8000';
      } catch (_) {
        // Platform not available; fall back
      }
      return 'http://127.0.0.1:8000';
    }
    final String backendBaseUrl = envUrl.isNotEmpty ? envUrl : _defaultBaseUrl();
    final uri = Uri.parse('$backendBaseUrl/api/demo/buttons');

    // Map selections to readable payload values
    String? _genderToString(int? value) {
      if (value == null) return null;
      const genders = ['male', 'female', 'unspecified'];
      return (value >= 0 && value < genders.length) ? genders[value] : null;
    }

    String? _educationToString(int? value) {
      if (value == null) return null;
      const educations = ['high_school', 'bachelor', 'master'];
      return (value >= 0 && value < educations.length) ? educations[value] : null;
    }

    String? _platformToString(int? value) {
      if (value == null) return null;
      const platforms = ['android', 'windows', 'ios'];
      return (value >= 0 && value < platforms.length) ? platforms[value] : null;
    }

    final payload = <String, dynamic>{
      'username': state.username,
      'password': state.password,
      'email': state.email,
      'option': _genderToString(state.gender),
      'radio3': _educationToString(state.education),
      'platform': _platformToString(state.platform),
      'dropdown': state.ageGroup,
    };

    try {
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      // Check HTTP status code and handle accordingly
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        // Success: HTTP 2xx
        final body = jsonDecode(resp.body) as Map<String, dynamic>;
        final api = ApiResponse.fromJson(body);
        emit(state.copyWith(response: api, exception: null));
      } else {
        // Error: HTTP 4xx/5xx
        final body = jsonDecode(resp.body) as Map<String, dynamic>;
        final errorMessage = body['detail']['message'] as String? ?? 'Unknown error';
        final errorCode = body['code'] as int? ?? resp.statusCode;
        print('HTTP Error ${resp.statusCode}: $errorMessage');
        emit(state.copyWith(
          exception: RegisterException(message: errorMessage, code: errorCode),
          response: null,
        ));
      }
    } catch (e) {
      print('Network exception >>> ${e.toString()}');
      // Network failure: set exception, keep previous response
      emit(state.copyWith(exception: const RegisterException(message: 'network_error', code: 500)));
    }
  }
}
