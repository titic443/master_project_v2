import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum ClinicAppointmentStatus { initial, loading, success, error }

class ClinicAppointmentState extends Equatable {
  final ClinicAppointmentStatus status;
  final String patientName;
  final String idCard;
  final String phone;
  final String? department;
  final String appointmentType; // 'OPD' | 'Telemedicine'
  final DateTime? appointmentDate;
  final TimeOfDay? appointmentTime;
  final bool hasInsurance;
  final String note;
  final String? errorMessage;

  const ClinicAppointmentState({
    this.status = ClinicAppointmentStatus.initial,
    this.patientName = '',
    this.idCard = '',
    this.phone = '',
    this.department,
    this.appointmentType = 'OPD',
    this.appointmentDate,
    this.appointmentTime,
    this.hasInsurance = false,
    this.note = '',
    this.errorMessage,
  });

  ClinicAppointmentState copyWith({
    ClinicAppointmentStatus? status,
    String? patientName,
    String? idCard,
    String? phone,
    String? department,
    String? appointmentType,
    DateTime? appointmentDate,
    TimeOfDay? appointmentTime,
    bool? hasInsurance,
    String? note,
    String? errorMessage,
  }) {
    return ClinicAppointmentState(
      status: status ?? this.status,
      patientName: patientName ?? this.patientName,
      idCard: idCard ?? this.idCard,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      appointmentType: appointmentType ?? this.appointmentType,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      hasInsurance: hasInsurance ?? this.hasInsurance,
      note: note ?? this.note,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        patientName,
        idCard,
        phone,
        department,
        appointmentType,
        appointmentDate,
        appointmentTime,
        hasInsurance,
        note,
        errorMessage,
      ];
}
