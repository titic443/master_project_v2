import 'package:equatable/equatable.dart';

enum LinkedinSearchStatus { initial, loading, success, empty, error }

class LinkedinSearchState extends Equatable {
  final LinkedinSearchStatus status;
  final String email;
  final String name;
  final List<Map<String, dynamic>> profiles;
  final String? errorMessage;

  const LinkedinSearchState({
    this.status = LinkedinSearchStatus.initial,
    this.email = '',
    this.name = '',
    this.profiles = const [],
    this.errorMessage,
  });

  LinkedinSearchState copyWith({
    LinkedinSearchStatus? status,
    String? email,
    String? name,
    List<Map<String, dynamic>>? profiles,
    String? errorMessage,
  }) {
    return LinkedinSearchState(
      status: status ?? this.status,
      email: email ?? this.email,
      name: name ?? this.name,
      profiles: profiles ?? this.profiles,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, email, name, profiles, errorMessage];
}
