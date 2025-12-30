import 'package:flutter_bloc/flutter_bloc.dart';

class DatePickerDemoState {
  final DateTime? birthDate;
  final DateTime? appointmentDate;

  DatePickerDemoState({
    this.birthDate,
    this.appointmentDate,
  });

  DatePickerDemoState copyWith({
    DateTime? birthDate,
    DateTime? appointmentDate,
  }) {
    return DatePickerDemoState(
      birthDate: birthDate ?? this.birthDate,
      appointmentDate: appointmentDate ?? this.appointmentDate,
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
}
