class SubmitState {
  final String title;
  final String description;
  final String? category;
  final int? priority;
  final bool isUrgent;
  final SubmitException? exception;
  final ApiResponse? response;

  const SubmitState({
    required this.title,
    required this.description,
    this.category,
    this.priority,
    required this.isUrgent,
    this.exception,
    this.response,
  });

  factory SubmitState.initial() => const SubmitState(
        title: '',
        description: '',
        category: null,
        priority: null,
        isUrgent: false,
        exception: null,
        response: null,
      );

  SubmitState copyWith({
    String? title,
    String? description,
    String? category,
    int? priority,
    bool? isUrgent,
    SubmitException? exception,
    ApiResponse? response,
  }) {
    return SubmitState(
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      isUrgent: isUrgent ?? this.isUrgent,
      exception: exception,
      response: response ?? this.response,
    );
  }
}

class SubmitException implements Exception {
  final String? message;
  final int? code;
  const SubmitException({this.message, this.code});
  @override
  String toString() =>
      message == null ? 'SubmitException' : 'SubmitException: $message';
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
