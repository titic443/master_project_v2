import 'package:bloc/bloc.dart';
import 'submit_state.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class SubmitCubit extends Cubit<SubmitState> {
  final bool shouldSucceed;

  SubmitCubit({this.shouldSucceed = false}) : super(SubmitState.initial());

  void onTitleChanged(String value) => emit(state.copyWith(title: value));

  void onDescriptionChanged(String value) =>
      emit(state.copyWith(description: value));

  void onCategorySelected(String? value) =>
      emit(state.copyWith(category: value));

  void onPrioritySelected(int? value) => emit(state.copyWith(priority: value));

  void onUrgentChanged(bool value) => emit(state.copyWith(isUrgent: value));

  void reset() => emit(SubmitState.initial());

  Future<void> callApi() async {
    const String envUrl =
        String.fromEnvironment('BACKEND_URL', defaultValue: '');
    String defaultBaseUrl() {
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
        envUrl.isNotEmpty ? envUrl : defaultBaseUrl();
    final uri = Uri.parse('$backendBaseUrl/api/demo/submit');

    String? priorityToString(int? value) {
      if (value == null) return null;
      const priorities = ['low', 'medium', 'high', 'critical'];
      return (value >= 0 && value < priorities.length)
          ? priorities[value]
          : null;
    }

    final payload = <String, dynamic>{
      'title': state.title,
      'description': state.description,
      'category': state.category,
      'priority': priorityToString(state.priority),
      'is_urgent': state.isUrgent,
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
          exception: SubmitException(message: errorMessage, code: errorCode),
          response: null,
        ));
      }
    } catch (e) {
      print('Network exception >>> ${e.toString()}');
      emit(state.copyWith(
          exception:
              const SubmitException(message: 'network_error', code: 500)));
    }
  }
}
