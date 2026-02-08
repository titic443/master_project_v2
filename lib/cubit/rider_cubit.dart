import 'package:flutter_bloc/flutter_bloc.dart';
import 'rider_state.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class RiderCubit extends Cubit<RiderState> {
  RiderCubit() : super(RiderState.initial());

  void onFullNameChanged(String value) => emit(state.copyWith(fullName: value));

  void onPhoneChanged(String value) => emit(state.copyWith(phone: value));

  void onEmailChanged(String value) => emit(state.copyWith(email: value));

  void onVehicleTypeChanged(String? value) => emit(state.copyWith(vehicleType: value));

  void onLicensePlateChanged(String value) => emit(state.copyWith(licensePlate: value));

  void onServiceZoneSelected(int? value) => emit(state.copyWith(serviceZone: value));

  void onAcceptTermsChanged(bool value) => emit(state.copyWith(acceptTerms: value));

  void onReceivePromotionsChanged(bool value) => emit(state.copyWith(receivePromotions: value));

  Future<void> submitRiderRegistration() async {
    if (state.fullName.isEmpty) return;
    if (state.phone.isEmpty) return;
    if (state.email.isEmpty) return;
    if (state.vehicleType == null || state.vehicleType!.isEmpty) return;
    if (state.licensePlate.isEmpty) return;
    if (state.serviceZone == null) return;
    if (!state.acceptTerms) return;

    emit(state.copyWith(status: RiderStatus.loading));

    const String envUrl = String.fromEnvironment('BACKEND_URL', defaultValue: '');
    String _defaultBaseUrl() {
      if (kIsWeb) return 'http://127.0.0.1:8000';
      try {
        if (Platform.isAndroid) return 'http://10.0.2.2:8000';
        if (Platform.isIOS || Platform.isMacOS) return 'http://127.0.0.1:8000';
        if (Platform.isWindows || Platform.isLinux) return 'http://127.0.0.1:8000';
      } catch (_) {}
      return 'http://127.0.0.1:8000';
    }
    final String backendBaseUrl = envUrl.isNotEmpty ? envUrl : _defaultBaseUrl();
    final uri = Uri.parse('$backendBaseUrl/api/demo/rider');

    final payload = <String, dynamic>{
      'fullName': state.fullName,
      'phone': state.phone,
      'email': state.email,
      'vehicleType': state.vehicleType,
      'licensePlate': state.licensePlate,
      'serviceZone': state.serviceZone,
      'acceptTerms': state.acceptTerms,
      'receivePromotions': state.receivePromotions,
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

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        final body = jsonDecode(resp.body) as Map<String, dynamic>;
        final message = body['message'] as String? ?? 'Rider registered successfully';
        emit(state.copyWith(
          status: RiderStatus.success,
          responseMessage: message,
        ));
      } else {
        final body = jsonDecode(resp.body) as Map<String, dynamic>;
        final errorMessage = body['detail']?['message'] as String? ?? 'Unknown error';
        print('❌ HTTP Error ${resp.statusCode}: $errorMessage');
        emit(state.copyWith(
          status: RiderStatus.error,
          errorMessage: errorMessage,
        ));
      }
    } catch (e) {
      print('❌ Network exception: ${e.toString()}');
      emit(state.copyWith(
        status: RiderStatus.error,
        errorMessage: 'Network error occurred',
      ));
    }
  }

  void reset() {
    emit(RiderState.initial());
  }
}
