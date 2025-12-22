import 'package:equatable/equatable.dart';

enum EmployeeStatus { initial, loading, success, error }

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

class EmployeeException implements Exception {
  final String message;
  final int code;

  const EmployeeException({required this.message, required this.code});
}

class EmployeeState extends Equatable {
  final EmployeeStatus status;
  final String? employeeId;
  final String? department;
  final String? email;
  final int? yearsOfService;
  final int? satisfactionRating;
  final bool recommendCompany;
  final bool attendTraining;
  final String? errorMessage;
  final ApiResponse? response;
  final EmployeeException? exception;

  const EmployeeState({
    this.status = EmployeeStatus.initial,
    this.employeeId,
    this.department,
    this.email,
    this.yearsOfService,
    this.satisfactionRating,
    this.recommendCompany = false,
    this.attendTraining = false,
    this.errorMessage,
    this.response,
    this.exception,
  });

  EmployeeState copyWith({
    EmployeeStatus? status,
    String? employeeId,
    String? department,
    String? email,
    int? yearsOfService,
    int? satisfactionRating,
    bool? recommendCompany,
    bool? attendTraining,
    String? errorMessage,
    ApiResponse? response,
    EmployeeException? exception,
  }) {
    return EmployeeState(
      status: status ?? this.status,
      employeeId: employeeId ?? this.employeeId,
      department: department ?? this.department,
      email: email ?? this.email,
      yearsOfService: yearsOfService ?? this.yearsOfService,
      satisfactionRating: satisfactionRating ?? this.satisfactionRating,
      recommendCompany: recommendCompany ?? this.recommendCompany,
      attendTraining: attendTraining ?? this.attendTraining,
      errorMessage: errorMessage ?? this.errorMessage,
      response: response ?? this.response,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [
        status,
        employeeId,
        department,
        email,
        yearsOfService,
        satisfactionRating,
        recommendCompany,
        attendTraining,
        errorMessage,
        response,
        exception,
      ];
}
