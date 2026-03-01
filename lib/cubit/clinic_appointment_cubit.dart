import 'dart:convert';
import 'dart:io' show Platform;

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'clinic_appointment_state.dart';

class ClinicAppointmentCubit extends Cubit<ClinicAppointmentState> {
  final String? baseUrl;

  ClinicAppointmentCubit({this.baseUrl})
      : super(const ClinicAppointmentState());

  String get _baseUrl {
    if (baseUrl != null) return baseUrl!;
    if (Platform.isAndroid) return 'http://10.0.2.2:8000';
    return 'http://localhost:8000';
  }

  void onPatientNameChanged(String v) => emit(state.copyWith(patientName: v));
  void onIdCardChanged(String v) => emit(state.copyWith(idCard: v));
  void onPhoneChanged(String v) => emit(state.copyWith(phone: v));
  void onDepartmentChanged(String? v) => emit(state.copyWith(department: v));
  void onAppointmentTypeChanged(String v) =>
      emit(state.copyWith(appointmentType: v));
  void onDateChanged(DateTime v) => emit(state.copyWith(appointmentDate: v));
  void onTimeChanged(TimeOfDay v) => emit(state.copyWith(appointmentTime: v));
  void onHasInsuranceChanged(bool v) => emit(state.copyWith(hasInsurance: v));
  void onNoteChanged(String v) => emit(state.copyWith(note: v));

  Future<void> submit() async {
    emit(state.copyWith(status: ClinicAppointmentStatus.loading));
    try {
      final date = state.appointmentDate;
      final time = state.appointmentTime;
      final response = await http.post(
        Uri.parse('$_baseUrl/api/demo/clinic/appointments'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'patientName': state.patientName,
          'idCard': state.idCard,
          'phone': state.phone,
          'department': state.department,
          'appointmentType': state.appointmentType,
          'appointmentDate': date != null
              ? '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'
              : null,
          'appointmentTime': time != null
              ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
              : null,
          'hasInsurance': state.hasInsurance,
          'note': state.note,
        }),
      );

      if (response.statusCode == 200) {
        emit(state.copyWith(status: ClinicAppointmentStatus.success));
      } else {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        emit(state.copyWith(
          status: ClinicAppointmentStatus.error,
          errorMessage:
              data['message']?.toString() ?? 'Failed to book appointment',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ClinicAppointmentStatus.error,
        errorMessage: 'Connection error: $e',
      ));
    }
  }
}
