import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/widgets/date_picker_demo_cubit.dart';
import 'package:intl/intl.dart';

class DatePickerDemoPage extends StatelessWidget {
  const DatePickerDemoPage({super.key});

  static const route = '/date-picker-demo';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DatePickerDemoCubit(),
      child: const _DatePickerDemoForm(),
    );
  }
}

class _DatePickerDemoForm extends StatelessWidget {
  const _DatePickerDemoForm();

  Future<void> _selectBirthDate(BuildContext context) async {
    final cubit = context.read<DatePickerDemoCubit>();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: cubit.state.birthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      cubit.onBirthDateChanged(picked);
    }
  }

  Future<void> _selectAppointmentDate(BuildContext context) async {
    final cubit = context.read<DatePickerDemoCubit>();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: cubit.state.appointmentDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      cubit.onAppointmentDateChanged(picked);
    }
  }

  Future<void> _selectAppointmentTime(BuildContext context) async {
    final cubit = context.read<DatePickerDemoCubit>();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: cubit.state.appointmentTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      cubit.onAppointmentTimeChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DatePicker Demo'),
      ),
      body: BlocBuilder<DatePickerDemoCubit, DatePickerDemoState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Birth Date Picker
                const Text(
                  'Birth Date',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ListTile(
                  key: const Key('datepicker_01_birthdate_tile'),
                  title: Text(
                    state.birthDate != null
                        ? DateFormat('yyyy-MM-dd').format(state.birthDate!)
                        : 'Select Birth Date',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectBirthDate(context),
                  tileColor: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 24),

                // Appointment Date Picker
                const Text(
                  'Appointment Date',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ListTile(
                  key: const Key('datepicker_02_appointment_date_tile'),
                  title: Text(
                    state.appointmentDate != null
                        ? DateFormat('yyyy-MM-dd').format(state.appointmentDate!)
                        : 'Select Appointment Date',
                  ),
                  trailing: const Icon(Icons.event),
                  onTap: () => _selectAppointmentDate(context),
                  tileColor: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 24),

                // Appointment Time Picker
                const Text(
                  'Appointment Time',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ListTile(
                  key: const Key('datepicker_03_appointment_time_tile'),
                  title: Text(
                    state.appointmentTime != null
                        ? state.appointmentTime!.format(context)
                        : 'Select Appointment Time',
                  ),
                  trailing: const Icon(Icons.access_time),
                  onTap: () => _selectAppointmentTime(context),
                  tileColor: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 24),

                // Display current state
                Text(
                  key: const Key('datepicker_04_status_text'),
                  'Current Selection:\n'
                  'Birth Date: ${state.birthDate != null ? DateFormat('yyyy-MM-dd').format(state.birthDate!) : "Not selected"}\n'
                  'Appointment: ${state.appointmentDate != null ? DateFormat('yyyy-MM-dd').format(state.appointmentDate!) : "Not selected"}\n'
                  'Time: ${state.appointmentTime != null ? state.appointmentTime!.format(context) : "Not selected"}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
