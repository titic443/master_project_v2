import 'dart:convert';
import 'dart:io' show Platform;

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'clinic_search_state.dart';

class ClinicSearchCubit extends Cubit<ClinicSearchState> {
  final String? baseUrl;

  ClinicSearchCubit({this.baseUrl}) : super(const ClinicSearchState());

  String get _baseUrl {
    if (baseUrl != null) return baseUrl!;
    if (Platform.isAndroid) return 'http://10.0.2.2:8000';
    return 'http://localhost:8000';
  }

  void onPatientNameChanged(String v) =>
      emit(state.copyWith(patientName: v));

  void onDepartmentChanged(String? v) =>
      emit(state.copyWith(department: v));

  void onAppointmentDateChanged(DateTime picked) {
    final display = DateFormat('dd/MM/yyyy').format(picked);
    emit(state.copyWith(appointmentDate: display));
  }

  void clearAppointmentDate() =>
      emit(state.copyWith(appointmentDate: ''));

  void onAppointmentTypeOpdChanged(bool? v) =>
      emit(state.copyWith(appointmentTypeOpd: v));

  Future<void> search() async {
    emit(state.copyWith(
        status: ClinicSearchStatus.loading, appointments: []));

    try {
      final params = <String, String>{};

      if (state.patientName.trim().isNotEmpty) {
        params['patient_name'] = state.patientName.trim();
      }
      if (state.department != null) {
        params['department'] = state.department!;
      }
      if (state.appointmentDate.trim().isNotEmpty) {
        // Convert dd/MM/yyyy → yyyy-MM-dd for backend
        final parsed =
            DateFormat('dd/MM/yyyy').parse(state.appointmentDate.trim());
        params['appointment_date'] = DateFormat('yyyy-MM-dd').format(parsed);
      }
      if (state.appointmentTypeOpd != null) {
        params['appointment_type'] =
            state.appointmentTypeOpd! ? 'OPD' : 'Telemedicine';
      }

      final uri =
          Uri.parse('$_baseUrl/api/demo/clinic/appointments/search')
              .replace(queryParameters: params);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final appts = List<Map<String, dynamic>>.from(
            data['appointments'] as List);
        emit(state.copyWith(
          status: appts.isEmpty
              ? ClinicSearchStatus.empty
              : ClinicSearchStatus.success,
          appointments: appts,
        ));
      } else {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        emit(state.copyWith(
          status: ClinicSearchStatus.error,
          errorMessage:
              data['message']?.toString() ?? 'Search failed',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ClinicSearchStatus.error,
        errorMessage: 'Connection error: $e',
      ));
    }
  }
}
