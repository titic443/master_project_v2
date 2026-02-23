import 'package:equatable/equatable.dart';

enum JobPostStatus { initial, loading, success, error }

class JobPostState extends Equatable {
  final JobPostStatus status;
  final String title;
  final String company;
  final String location;
  final String? category;
  final String? employmentType;
  final String? experienceLevel;
  final String salaryMin;
  final String salaryMax;
  final String description;
  final String skills;
  final bool isRemote;
  final String? errorMessage;

  const JobPostState({
    this.status = JobPostStatus.initial,
    this.title = '',
    this.company = '',
    this.location = '',
    this.category,
    this.employmentType,
    this.experienceLevel,
    this.salaryMin = '',
    this.salaryMax = '',
    this.description = '',
    this.skills = '',
    this.isRemote = false,
    this.errorMessage,
  });

  JobPostState copyWith({
    JobPostStatus? status,
    String? title,
    String? company,
    String? location,
    String? category,
    String? employmentType,
    String? experienceLevel,
    String? salaryMin,
    String? salaryMax,
    String? description,
    String? skills,
    bool? isRemote,
    String? errorMessage,
  }) {
    return JobPostState(
      status: status ?? this.status,
      title: title ?? this.title,
      company: company ?? this.company,
      location: location ?? this.location,
      category: category ?? this.category,
      employmentType: employmentType ?? this.employmentType,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      salaryMin: salaryMin ?? this.salaryMin,
      salaryMax: salaryMax ?? this.salaryMax,
      description: description ?? this.description,
      skills: skills ?? this.skills,
      isRemote: isRemote ?? this.isRemote,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        title,
        company,
        location,
        category,
        employmentType,
        experienceLevel,
        salaryMin,
        salaryMax,
        description,
        skills,
        isRemote,
        errorMessage,
      ];
}
