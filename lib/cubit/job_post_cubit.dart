import 'dart:convert';
import 'dart:io' show Platform;

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

import 'job_post_state.dart';

class JobPostCubit extends Cubit<JobPostState> {
  final String? baseUrl;

  JobPostCubit({this.baseUrl}) : super(const JobPostState());

  String get _baseUrl {
    if (baseUrl != null) return baseUrl!;
    if (Platform.isAndroid) return 'http://10.0.2.2:8000';
    return 'http://localhost:8000';
  }

  void onTitleChanged(String v) => emit(state.copyWith(title: v));
  void onCompanyChanged(String v) => emit(state.copyWith(company: v));
  void onLocationChanged(String v) => emit(state.copyWith(location: v));
  void onCategoryChanged(String? v) => emit(state.copyWith(category: v));
  void onEmploymentTypeChanged(String? v) =>
      emit(state.copyWith(employmentType: v));
  void onExperienceLevelChanged(String? v) =>
      emit(state.copyWith(experienceLevel: v));
  void onSalaryMinChanged(String v) => emit(state.copyWith(salaryMin: v));
  void onSalaryMaxChanged(String v) => emit(state.copyWith(salaryMax: v));
  void onDescriptionChanged(String v) => emit(state.copyWith(description: v));
  void onSkillsChanged(String v) => emit(state.copyWith(skills: v));
  void onIsRemoteChanged(bool v) => emit(state.copyWith(isRemote: v));

  Future<void> submit() async {
    emit(state.copyWith(status: JobPostStatus.loading));
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/demo/jobs'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': state.title,
          'company': state.company,
          'location': state.location,
          'category': state.category,
          'employmentType': state.employmentType,
          'experienceLevel': state.experienceLevel,
          'salaryMin': int.tryParse(state.salaryMin) ?? 0,
          'salaryMax': int.tryParse(state.salaryMax) ?? 0,
          'description': state.description,
          'skills': state.skills,
          'isRemote': state.isRemote,
        }),
      );

      if (response.statusCode == 200) {
        emit(state.copyWith(status: JobPostStatus.success));
      } else {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        emit(state.copyWith(
          status: JobPostStatus.error,
          errorMessage: data['message']?.toString() ?? 'Failed to post job',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: JobPostStatus.error,
        errorMessage: 'Connection error: $e',
      ));
    }
  }
}
