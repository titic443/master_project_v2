class DemoState {
  final String username;
  final int? options; // changed from bool? to int?
  final int count;
  final RegisterException? exception;
  final ApiResponse? response;

  const DemoState({
    required this.username,
    this.options,
    required this.count,
    this.exception,
    this.response,
  });

  factory DemoState.initial() => const DemoState(
        username: '',
        options: null,
        count: 0,
        exception: null,
        response: null,
      );

  DemoState copyWith({
    String? username,
    int? options,
    int? count,
    RegisterException? exception,
    ApiResponse? response,
  }) {
    return DemoState(
      username: username ?? this.username,
      options: options ?? this.options,
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
