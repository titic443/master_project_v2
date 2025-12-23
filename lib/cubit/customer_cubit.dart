import 'package:flutter_bloc/flutter_bloc.dart';
import 'customer_state.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class CustomerCubit extends Cubit<CustomerState> {
  CustomerCubit() : super(CustomerState.initial());

  // Update methods for each field
  void onTitleChanged(String? value) => emit(state.copyWith(title: value));

  void onFirstNameChanged(String value) => emit(state.copyWith(firstName: value));

  void onPhoneNumberChanged(String value) => emit(state.copyWith(phoneNumber: value));

  void onLastNameChanged(String value) => emit(state.copyWith(lastName: value));

  void onAgeRangeSelected(int? value) => emit(state.copyWith(ageRange: value));

  void onAgreeToTermsChanged(bool value) => emit(state.copyWith(agreeToTerms: value));

  void onSubscribeNewsletterChanged(bool value) => emit(state.copyWith(subscribeNewsletter: value));

  Future<void> submitCustomerDetails() async {
    // Validate required fields
    if (state.title == null || state.title!.isEmpty) return;
    if (state.firstName.isEmpty) return;
    if (state.lastName.isEmpty) return;
    if (state.ageRange == null) return;
    if (!state.agreeToTerms) return;

    emit(state.copyWith(status: CustomerStatus.loading));

    // Backend base URL - same as register_cubit.dart
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

    // Prepare payload with customer details
    final payload = <String, dynamic>{
      'title': state.title,
      'firstName': state.firstName,
      'lastName': state.lastName,
      'ageRange': state.ageRange,
      'agreeToTerms': state.agreeToTerms,
      'subscribeNewsletter': state.subscribeNewsletter,
    };

    try {
      print('🌐 Submitting to: $uri');

      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      print('📡 Response status: ${resp.statusCode}');
      print('📡 Response body: ${resp.body}');

      // Check HTTP status code and handle accordingly
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        // Success: HTTP 2xx
        final body = jsonDecode(resp.body) as Map<String, dynamic>;
        final message = body['message'] as String? ?? 'Customer details submitted successfully';
        emit(state.copyWith(
          status: CustomerStatus.success,
          responseMessage: message,
        ));
      } else {
        // Error: HTTP 4xx/5xx
        final body = jsonDecode(resp.body) as Map<String, dynamic>;
        final errorMessage = body['detail']?['message'] as String? ?? 'Unknown error';
        print('❌ HTTP Error ${resp.statusCode}: $errorMessage');
        emit(state.copyWith(
          status: CustomerStatus.error,
          errorMessage: errorMessage,
        ));
      }
    } catch (e) {
      print('❌ Network exception: ${e.toString()}');
      emit(state.copyWith(
        status: CustomerStatus.error,
        errorMessage: 'Network error occurred',
      ));
    }
  }

  void reset() {
    emit(CustomerState.initial());
  }
}
