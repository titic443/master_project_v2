import 'package:equatable/equatable.dart';

enum LinkedinStatus { initial, loading, success, error }

class ApiResponse {
  final String message;
  final int code;

  const ApiResponse({required this.message, required this.code});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      message: json['message'] as String,
      code: json['code'] as int,
    );
  }
}

class LinkedinException implements Exception {
  final String message;
  final int code;

  const LinkedinException({required this.message, required this.code});
}

class LinkedinState extends Equatable {
  final LinkedinStatus status;
  final String fullName;
  final String email;
  final String position;
  final String company;
  final int? experience;
  final String? employmentType;
  final int? educationLevel;
  final String university;
  final bool agreeTerms;
  final bool openToWork;
  final String? responseMessage;
  final String? errorMessage;
  final ApiResponse? response;
  final LinkedinException? exception;

  const LinkedinState({
    this.status = LinkedinStatus.initial,
    this.fullName = '',
    this.email = '',
    this.position = '',
    this.company = '',
    this.experience,
    this.employmentType,
    this.educationLevel,
    this.university = '',
    this.agreeTerms = false,
    this.openToWork = false,
    this.responseMessage,
    this.errorMessage,
    this.response,
    this.exception,
  });

  LinkedinState copyWith({
    LinkedinStatus? status,
    String? fullName,
    String? email,
    String? position,
    String? company,
    int? experience,
    String? employmentType,
    int? educationLevel,
    String? university,
    bool? agreeTerms,
    bool? openToWork,
    String? responseMessage,
    String? errorMessage,
    ApiResponse? response,
    LinkedinException? exception,
  }) {
    return LinkedinState(
      status: status ?? this.status,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      position: position ?? this.position,
      company: company ?? this.company,
      experience: experience ?? this.experience,
      employmentType: employmentType ?? this.employmentType,
      educationLevel: educationLevel ?? this.educationLevel,
      university: university ?? this.university,
      agreeTerms: agreeTerms ?? this.agreeTerms,
      openToWork: openToWork ?? this.openToWork,
      responseMessage: responseMessage ?? this.responseMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      response: response ?? this.response,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [
        status,
        fullName,
        email,
        position,
        company,
        experience,
        employmentType,
        educationLevel,
        university,
        agreeTerms,
        openToWork,
        responseMessage,
        errorMessage,
        response,
        exception,
      ];
}
