import 'package:bloc/bloc.dart';
import 'login_state.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class LoginCubit extends Cubit<LoginState> {
  final bool shouldSucceed;

  LoginCubit({this.shouldSucceed = false}) : super(LoginState.initial());

  void onUsernameChanged(String value) => emit(state.copyWith(username: value));

  void onPasswordChanged(String value) => emit(state.copyWith(password: value));

  void onRememberMeChanged(bool value) =>
      emit(state.copyWith(rememberMe: value));

  void reset() => emit(LoginState.initial());

  Future<void> callApi() async {
    const String envUrl =
        String.fromEnvironment('BACKEND_URL', defaultValue: '');
    String _defaultBaseUrl() {
      if (kIsWeb) return 'http://127.0.0.1:8000';
      try {
        if (Platform.isAndroid) return 'http://10.0.2.2:8000';
        if (Platform.isIOS || Platform.isMacOS) {
          return 'http://127.0.0.1:8000';
        }
        if (Platform.isWindows || Platform.isLinux) {
          return 'http://127.0.0.1:8000';
        }
      } catch (_) {
        // Platform not available; fall back
      }
      return 'http://127.0.0.1:8000';
    }

    final String backendBaseUrl =
        envUrl.isNotEmpty ? envUrl : _defaultBaseUrl();
    final uri = Uri.parse('$backendBaseUrl/api/demo/login');

    final payload = <String, dynamic>{
      'username': state.username,
      'password': state.password,
      'remember_me': state.rememberMe,
    };

    try {
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        final body = jsonDecode(resp.body) as Map<String, dynamic>;
        final api = ApiResponse.fromJson(body);
        emit(state.copyWith(response: api, exception: null));
      } else {
        final body = jsonDecode(resp.body) as Map<String, dynamic>;
        final errorMessage =
            body['detail']['message'] as String? ?? 'Unknown error';
        final errorCode = body['code'] as int? ?? resp.statusCode;
        print('HTTP Error ${resp.statusCode}: $errorMessage');
        emit(state.copyWith(
          exception: LoginException(message: errorMessage, code: errorCode),
          response: null,
        ));
      }
    } catch (e) {
      print('Network exception >>> ${e.toString()}');
      emit(state.copyWith(
          exception:
              const LoginException(message: 'network_error', code: 500)));
    }
  }
}
