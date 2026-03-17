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

  // sentinel — ใช้แยก "ไม่ได้ส่งมา" ออกจาก "ส่ง null มา"
  static const _unset = Object();

  JobSearchState copyWith({
    JobSearchStatus? status,
    String? keyword,
    String? location,
    Object? category = _unset,
    Object? employmentType = _unset,
    String? salaryMin,
    bool? remoteOnly,
    List<Map<String, dynamic>>? jobs,
    Object? errorMessage = _unset,
  }) {
    return JobSearchState(
      status: status ?? this.status,
      keyword: keyword ?? this.keyword,
      location: location ?? this.location,
      category:
          category == _unset ? this.category : category as String?,
      employmentType:
          employmentType == _unset ? this.employmentType : employmentType as String?,
      salaryMin: salaryMin ?? this.salaryMin,
      remoteOnly: remoteOnly ?? this.remoteOnly,
      jobs: jobs ?? this.jobs,
      errorMessage:
          errorMessage == _unset ? this.errorMessage : errorMessage as String?,
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
