import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;
import 'linkedin_state.dart';

class LinkedinCubit extends Cubit<LinkedinState> {
  final bool shouldSucceed;
  final String? baseUrl;

  LinkedinCubit({this.shouldSucceed = false, this.baseUrl})
      : super(const LinkedinState());

  String get _baseUrl {
    if (baseUrl != null) return baseUrl!;

    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000';
    }
    return 'http://localhost:8000';
  }

  void onFullNameChanged(String value) {
    emit(state.copyWith(fullName: value));
  }

  void onEmailChanged(String value) {
    emit(state.copyWith(email: value));
  }

  void onPositionChanged(String value) {
    emit(state.copyWith(position: value));
  }

  void onCompanyChanged(String value) {
    emit(state.copyWith(company: value));
  }

  void onExperienceChanged(String value) {
    final years = int.tryParse(value);
    emit(state.copyWith(experience: years));
  }

  void onEmploymentTypeChanged(String? value) {
    emit(state.copyWith(employmentType: value));
  }

  void onEducationLevelSelected(int value) {
    emit(state.copyWith(educationLevel: value));
  }

  void onUniversityChanged(String value) {
    emit(state.copyWith(university: value));
  }

  void onAgreeTermsChanged(bool value) {
    emit(state.copyWith(agreeTerms: value));
  }

  void onOpenToWorkChanged(bool value) {
    emit(state.copyWith(openToWork: value));
  }

  Future<void> submitProfile() async {
    emit(state.copyWith(status: LinkedinStatus.loading));

    try {
      final url = '$_baseUrl/api/demo/linkedin';
      print('🌐 Submitting to: $url');

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': state.fullName,
          'email': state.email,
          'position': state.position,
          'company': state.company,
          'experience': state.experience,
          'employmentType': state.employmentType,
          'educationLevel': state.educationLevel,
          'university': state.university,
          'agreeTerms': state.agreeTerms,
          'openToWork': state.openToWork,
        }),
      );

      print('📡 Response status: ${response.statusCode}');
      print('📡 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final apiResponse = ApiResponse.fromJson(data);
        emit(state.copyWith(
          status: LinkedinStatus.success,
          response: apiResponse,
        ));
      } else {
        final data = jsonDecode(response.body);
        emit(state.copyWith(
          status: LinkedinStatus.error,
          errorMessage: data['message'] ?? 'Unknown error',
        ));
      }
    } catch (e) {
      print('❌ Error: $e');
      emit(state.copyWith(
        status: LinkedinStatus.error,
        errorMessage: 'Failed to submit: $e',
      ));
    }
  }

  Future<void> callApi() async {
    await submitProfile();
  }

  Future<void> onEndButton() async {
    await submitProfile();
  }
}
