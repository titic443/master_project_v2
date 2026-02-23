import 'package:equatable/equatable.dart';

enum JobSearchStatus { initial, loading, success, empty, error }

class JobSearchState extends Equatable {
  final JobSearchStatus status;
  final String keyword;
  final String location;
  final String? category;
  final String? employmentType;
  final String salaryMin;
  final bool remoteOnly;
  final List<Map<String, dynamic>> jobs;
  final String? errorMessage;

  const JobSearchState({
    this.status = JobSearchStatus.initial,
    this.keyword = '',
    this.location = '',
    this.category,
    this.employmentType,
    this.salaryMin = '',
    this.remoteOnly = false,
    this.jobs = const [],
    this.errorMessage,
  });

  JobSearchState copyWith({
    JobSearchStatus? status,
    String? keyword,
    String? location,
    String? category,
    String? employmentType,
    String? salaryMin,
    bool? remoteOnly,
    List<Map<String, dynamic>>? jobs,
    String? errorMessage,
  }) {
    return JobSearchState(
      status: status ?? this.status,
      keyword: keyword ?? this.keyword,
      location: location ?? this.location,
      category: category ?? this.category,
      employmentType: employmentType ?? this.employmentType,
      salaryMin: salaryMin ?? this.salaryMin,
      remoteOnly: remoteOnly ?? this.remoteOnly,
      jobs: jobs ?? this.jobs,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        keyword,
        location,
        category,
        employmentType,
        salaryMin,
        remoteOnly,
        jobs,
        errorMessage,
      ];
}
