import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DatePickerDemoState {
  final DateTime? birthDate;
  final DateTime? appointmentDate;
  final TimeOfDay? appointmentTime;

  DatePickerDemoState({
    this.birthDate,
    this.appointmentDate,
    this.appointmentTime,
  });

  DatePickerDemoState copyWith({
    DateTime? birthDate,
    DateTime? appointmentDate,
    TimeOfDay? appointmentTime,
  }) {
    return DatePickerDemoState(
      birthDate: birthDate ?? this.birthDate,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTime: appointmentTime ?? this.appointmentTime,
    );
  }
}

class DatePickerDemoCubit extends Cubit<DatePickerDemoState> {
  DatePickerDemoCubit() : super(DatePickerDemoState());

  void onBirthDateChanged(DateTime? value) {
    emit(state.copyWith(birthDate: value));
  }

  void onAppointmentDateChanged(DateTime? value) {
    emit(state.copyWith(appointmentDate: value));
  }

  void onAppointmentTimeChanged(TimeOfDay? value) {
    emit(state.copyWith(appointmentTime: value));
  }
}
