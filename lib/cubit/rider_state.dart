import 'package:equatable/equatable.dart';

enum RiderStatus { initial, loading, success, error }

class RiderState extends Equatable {
  final String fullName;
  final String phone;
  final String email;
  final String? vehicleType;
  final String licensePlate;
  final int? serviceZone;
  final bool acceptTerms;
  final bool receivePromotions;
  final RiderStatus status;
  final String? responseMessage;
  final String? errorMessage;

  const RiderState({
    this.fullName = '',
    this.phone = '',
    this.email = '',
    this.vehicleType,
    this.licensePlate = '',
    this.serviceZone,
    this.acceptTerms = false,
    this.receivePromotions = false,
    this.status = RiderStatus.initial,
    this.responseMessage,
    this.errorMessage,
  });

  factory RiderState.initial() => const RiderState();

  RiderState copyWith({
    String? fullName,
    String? phone,
    String? email,
    String? vehicleType,
    String? licensePlate,
    int? serviceZone,
    bool? acceptTerms,
    bool? receivePromotions,
    RiderStatus? status,
    String? responseMessage,
    String? errorMessage,
  }) {
    return RiderState(
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      vehicleType: vehicleType ?? this.vehicleType,
      licensePlate: licensePlate ?? this.licensePlate,
      serviceZone: serviceZone ?? this.serviceZone,
      acceptTerms: acceptTerms ?? this.acceptTerms,
      receivePromotions: receivePromotions ?? this.receivePromotions,
      status: status ?? this.status,
      responseMessage: responseMessage ?? this.responseMessage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        fullName,
        phone,
        email,
        vehicleType,
        licensePlate,
        serviceZone,
        acceptTerms,
        receivePromotions,
        status,
        responseMessage,
        errorMessage,
      ];
}
