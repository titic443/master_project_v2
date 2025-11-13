class LoginState {
  final String username;
  final String password;
  final bool rememberMe;
  final LoginException? exception;
  final ApiResponse? response;

  const LoginState({
    required this.username,
    required this.password,
    required this.rememberMe,
    this.exception,
    this.response,
  });

  factory LoginState.initial() => const LoginState(
        username: '',
        password: '',
        rememberMe: false,
        exception: null,
        response: null,
      );

  LoginState copyWith({
    String? username,
    String? password,
    bool? rememberMe,
    LoginException? exception,
    ApiResponse? response,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
      exception: exception,
      response: response ?? this.response,
    );
  }
}

class LoginException implements Exception {
  final String? message;
  final int? code;
  const LoginException({this.message, this.code});
  @override
  String toString() =>
      message == null ? 'LoginException' : 'LoginException: $message';
}

class ApiResponse {
  final String message;
  final int code;

  const ApiResponse({required this.message, required this.code});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    final codeRaw = json['code'];
    final code = codeRaw is int
        ? codeRaw
        : int.tryParse(codeRaw?.toString() ?? '') ?? 0;
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
