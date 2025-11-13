class RegisterState {
  final String username;
  final String password;
  final String confirmPassword;
  final String email;
  final int? gender; // Radio group: gender selection
  final int? education; // Radio group: education level
  final int? platform; // Radio group: preferred platform
  final String? ageGroup; // Dropdown: age range
  final int count;
  final RegisterException? exception;
  final ApiResponse? response;

  const RegisterState({
    required this.username,
    required this.password,
    required this.confirmPassword,
    required this.email,
    this.gender,
    this.education,
    this.platform,
    this.ageGroup,
    required this.count,
    this.exception,
    this.response,
  });

  factory RegisterState.initial() => const RegisterState(
        username: '',
        password: '',
        confirmPassword: '',
        email: '',
        gender: null,
        education: null,
        platform: null,
        ageGroup: null,
        count: 0,
        exception: null,
        response: null,
      );

  RegisterState copyWith({
    String? username,
    String? password,
    String? confirmPassword,
    String? email,
    int? gender,
    int? education,
    int? platform,
    String? ageGroup,
    int? count,
    RegisterException? exception,
    ApiResponse? response,
  }) {
    return RegisterState(
      username: username ?? this.username,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      education: education ?? this.education,
      platform: platform ?? this.platform,
      ageGroup: ageGroup ?? this.ageGroup,
      count: count ?? this.count,
      exception: exception,
      // Keep previous response if not explicitly provided
      response: response ?? this.response,
    );
  }
}

class RegisterException implements Exception {
  final String? message;
  final int? code;
  const RegisterException({this.message, this.code});
  @override
  String toString() => message == null ? 'RegisterException' : 'RegisterException: $message';
}

class ApiResponse {
  final String message;
  final int code;

  const ApiResponse({required this.message, required this.code});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    final codeRaw = json['code'];
    final code = codeRaw is int ? codeRaw : int.tryParse(codeRaw?.toString() ?? '') ?? 0;
    return ApiResponse(
      message: json['message']?.toString() ?? '',
      code: code,
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'code': code,
      };
}
