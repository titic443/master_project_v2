import 'dart:convert';
import 'dart:io' show Platform;

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

import 'job_search_state.dart';

class JobSearchCubit extends Cubit<JobSearchState> {
  final String? baseUrl;

  JobSearchCubit({this.baseUrl}) : super(const JobSearchState());

  String get _baseUrl {
    if (baseUrl != null) return baseUrl!;
    if (Platform.isAndroid) return 'http://10.0.2.2:8000';
    return 'http://localhost:8000';
  }

  void onKeywordChanged(String v) => emit(state.copyWith(keyword: v));
  void onLocationChanged(String v) => emit(state.copyWith(location: v));
  void onCategoryChanged(String? v) => emit(state.copyWith(category: v));
  void onEmploymentTypeChanged(String? v) =>
      emit(state.copyWith(employmentType: v));
  void onSalaryMinChanged(String v) => emit(state.copyWith(salaryMin: v));
  void onRemoteOnlyChanged(bool v) => emit(state.copyWith(remoteOnly: v));

  Future<void> search() async {
    emit(state.copyWith(status: JobSearchStatus.loading, jobs: []));
    try {
      final params = <String, String>{};
      if (state.keyword.trim().isNotEmpty) {
        params['keyword'] = state.keyword.trim();
      }
      if (state.location.trim().isNotEmpty) {
        params['location'] = state.location.trim();
      }
      if (state.category != null) params['category'] = state.category!;
      if (state.employmentType != null) {
        params['employment_type'] = state.employmentType!;
      }
      if (state.salaryMin.trim().isNotEmpty) {
        params['salary_min'] = state.salaryMin.trim();
      }
      if (state.remoteOnly) params['is_remote'] = 'true';

      final uri = Uri.parse('$_baseUrl/api/demo/jobs/search')
          .replace(queryParameters: params);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final jobs = List<Map<String, dynamic>>.from(data['jobs'] as List);
        emit(state.copyWith(
          status:
              jobs.isEmpty ? JobSearchStatus.empty : JobSearchStatus.success,
          jobs: jobs,
        ));
      } else {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        emit(state.copyWith(
          status: JobSearchStatus.error,
          errorMessage: data['message']?.toString() ?? 'Search failed',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: JobSearchStatus.error,
        errorMessage: 'Connection error: $e',
      ));
    }
  }
}
