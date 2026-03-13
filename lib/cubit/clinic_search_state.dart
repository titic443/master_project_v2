import 'package:equatable/equatable.dart';

enum ClinicSearchStatus { initial, loading, success, empty, error }

class ClinicSearchState extends Equatable {
  final ClinicSearchStatus status;
  final String patientName;
  final String? department;
  final String appointmentDate; // 'dd/MM/yyyy' display string
  final bool? appointmentTypeOpd; // true = OPD, false = Telemedicine, null = all
  final List<Map<String, dynamic>> appointments;
  final String? errorMessage;

  const ClinicSearchState({
    this.status = ClinicSearchStatus.initial,
    this.patientName = '',
    this.department,
    this.appointmentDate = '',
    this.appointmentTypeOpd,
    this.appointments = const [],
    this.errorMessage,
  });

  ClinicSearchState copyWith({
    ClinicSearchStatus? status,
    String? patientName,
    Object? department = _sentinel,
    String? appointmentDate,
    Object? appointmentTypeOpd = _sentinel,
    List<Map<String, dynamic>>? appointments,
    Object? errorMessage = _sentinel,
  }) {
    return ClinicSearchState(
      status: status ?? this.status,
      patientName: patientName ?? this.patientName,
      department:
          department == _sentinel ? this.department : department as String?,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTypeOpd: appointmentTypeOpd == _sentinel
          ? this.appointmentTypeOpd
          : appointmentTypeOpd as bool?,
      appointments: appointments ?? this.appointments,
      errorMessage:
          errorMessage == _sentinel ? this.errorMessage : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
        status,
        patientName,
        department,
        appointmentDate,
        appointmentTypeOpd,
        appointments,
        errorMessage,
      ];
}

// Sentinel object for nullable copyWith fields
const _sentinel = Object();
