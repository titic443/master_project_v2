import 'package:equatable/equatable.dart';

enum CustomerStatus { initial, loading, success, error }

class CustomerState extends Equatable {
  final String? title;
  final String firstName;
  final String phoneNumber;
  final String lastName;
  final int? ageRange;
  final bool agreeToTerms;
  final bool subscribeNewsletter;
  final CustomerStatus status;
  final String? responseMessage;
  final String? errorMessage;

  const CustomerState({
    this.title,
    this.firstName = '',
    this.phoneNumber = '',
    this.lastName = '',
    this.ageRange,
    this.agreeToTerms = false,
    this.subscribeNewsletter = false,
    this.status = CustomerStatus.initial,
    this.responseMessage,
    this.errorMessage,
  });

  factory CustomerState.initial() => const CustomerState();

  CustomerState copyWith({
    String? title,
    String? firstName,
    String? phoneNumber,
    String? lastName,
    int? ageRange,
    bool? agreeToTerms,
    bool? subscribeNewsletter,
    CustomerStatus? status,
    String? responseMessage,
    String? errorMessage,
  }) {
    return CustomerState(
      title: title ?? this.title,
      firstName: firstName ?? this.firstName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      lastName: lastName ?? this.lastName,
      ageRange: ageRange ?? this.ageRange,
      agreeToTerms: agreeToTerms ?? this.agreeToTerms,
      subscribeNewsletter: subscribeNewsletter ?? this.subscribeNewsletter,
      status: status ?? this.status,
      responseMessage: responseMessage ?? this.responseMessage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        title,
        firstName,
        phoneNumber,
        lastName,
        ageRange,
        agreeToTerms,
        subscribeNewsletter,
        status,
        responseMessage,
        errorMessage,
      ];
}
