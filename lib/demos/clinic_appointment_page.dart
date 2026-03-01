import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:master_project/cubit/clinic_appointment_cubit.dart';
import 'package:master_project/cubit/clinic_appointment_state.dart';

class ClinicAppointmentPage extends StatelessWidget {
  const ClinicAppointmentPage({super.key});

  static const route = '/clinic-appointment';

  @override
  Widget build(BuildContext context) => const _ClinicAppointmentView();
}

// ─── Private View ─────────────────────────────────────────────────────────────

class _ClinicAppointmentView extends StatefulWidget {
  const _ClinicAppointmentView();

  @override
  State<_ClinicAppointmentView> createState() => _ClinicAppointmentViewState();
}

class _ClinicAppointmentViewState extends State<_ClinicAppointmentView> {
  final _formKey = GlobalKey<FormState>();
  final _patientNameCtrl = TextEditingController();
  final _idCardCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  @override
  void dispose() {
    _patientNameCtrl.dispose();
    _idCardCtrl.dispose();
    _phoneCtrl.dispose();
    _dateCtrl.dispose();
    _timeCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _sync(ClinicAppointmentState state) {
    if (_patientNameCtrl.text != state.patientName) {
      _patientNameCtrl.text = state.patientName;
    }
    if (_idCardCtrl.text != state.idCard) _idCardCtrl.text = state.idCard;
    if (_phoneCtrl.text != state.phone) _phoneCtrl.text = state.phone;
    if (_noteCtrl.text != state.note) _noteCtrl.text = state.note;

    final dateStr = state.appointmentDate != null
        ? DateFormat('dd/MM/yyyy').format(state.appointmentDate!)
        : '';
    if (_dateCtrl.text != dateStr) _dateCtrl.text = dateStr;

    final timeStr = state.appointmentTime != null
        ? '${state.appointmentTime!.hour.toString().padLeft(2, '0')}:${state.appointmentTime!.minute.toString().padLeft(2, '0')}'
        : '';
    if (_timeCtrl.text != timeStr) _timeCtrl.text = timeStr;
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );
    if (picked != null && context.mounted) {
      context.read<ClinicAppointmentCubit>().onDateChanged(picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
      initialEntryMode: TimePickerEntryMode.input,
      // Force 24-hour format so hours 13-23 are valid in input mode
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked != null && context.mounted) {
      context.read<ClinicAppointmentCubit>().onTimeChanged(picked);
    }
  }

  void _onSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          key: Key('appt_10_expected_fail'),
          content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    context.read<ClinicAppointmentCubit>().submit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'นัดหมายแพทย์',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<ClinicAppointmentCubit, ClinicAppointmentState>(
        listenWhen: (prev, curr) =>
            prev.status == ClinicAppointmentStatus.loading &&
            curr.status != ClinicAppointmentStatus.loading,
        listener: (context, state) {
          if (state.status == ClinicAppointmentStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                key: Key('appt_10_expected_success'),
                content: Text('นัดหมายสำเร็จ! ระบบจะส่ง SMS ยืนยันให้ท่าน'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state.status == ClinicAppointmentStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                key: const Key('appt_10_expected_fail'),
                content:
                    Text(state.errorMessage ?? 'ไม่สามารถจองนัดหมายได้'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          _sync(state);
          final cubit = context.read<ClinicAppointmentCubit>();
          final isLoading =
              state.status == ClinicAppointmentStatus.loading;

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
              children: [
                // ── Section 1: ข้อมูลผู้ป่วย ────────────────────────────
                const _SectionHeader(
                  title: 'ข้อมูลผู้ป่วย',
                  icon: Icons.person_outlined,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('appt_01_patient_name_textfield'),
                  controller: _patientNameCtrl,
                  decoration: _dec(
                    label: 'ชื่อ-นามสกุล',
                    hint: 'เช่น สมชาย ใจดี',
                    icon: Icons.badge_outlined,
                  ),
                  textCapitalization: TextCapitalization.words,
                  onChanged: cubit.onPatientNameChanged,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'กรุณากรอกชื่อ-นามสกุล';
                    if (v.trim().length < 2) return 'อย่างน้อย 2 ตัวอักษร';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  key: const Key('appt_02_id_card_textfield'),
                  controller: _idCardCtrl,
                  decoration: _dec(
                    label: 'เลขบัตรประชาชน',
                    hint: 'กรอกเลข 13 หลัก',
                    icon: Icons.credit_card_outlined,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(13),
                  ],
                  onChanged: cubit.onIdCardChanged,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'กรุณากรอกเลขบัตรประชาชน';
                    if (v.trim().length != 13) return 'ต้องมี 13 หลัก';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  key: const Key('appt_03_phone_textfield'),
                  controller: _phoneCtrl,
                  decoration: _dec(
                    label: 'เบอร์โทรศัพท์',
                    hint: 'เช่น 0812345678',
                    icon: Icons.phone_outlined,
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  onChanged: cubit.onPhoneChanged,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'กรุณากรอกเบอร์โทรศัพท์';
                    if (v.trim().length < 9) return 'เบอร์โทรไม่ถูกต้อง';
                    return null;
                  },
                ),

                // ── Section 2: รายละเอียดการนัด ─────────────────────────
                const SizedBox(height: 28),
                const _SectionHeader(
                  title: 'รายละเอียดการนัดหมาย',
                  icon: Icons.medical_services_outlined,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  key: const Key('appt_04_department_dropdown'),
                  value: state.department,
                  decoration: _dec(
                    label: 'แผนกที่ต้องการ',
                    icon: Icons.local_hospital_outlined,
                  ),
                  hint: const Text('เลือกแผนก'),
                  items: const [
                    DropdownMenuItem(
                        value: 'internal_medicine', child: Text('อายุรกรรม')),
                    DropdownMenuItem(
                        value: 'surgery', child: Text('ศัลยกรรม')),
                    DropdownMenuItem(
                        value: 'pediatrics', child: Text('กุมารเวชศาสตร์')),
                    DropdownMenuItem(
                        value: 'obstetrics', child: Text('สูติ-นรีเวช')),
                    DropdownMenuItem(
                        value: 'ophthalmology', child: Text('จักษุวิทยา')),
                    DropdownMenuItem(
                        value: 'ent', child: Text('หู คอ จมูก')),
                    DropdownMenuItem(
                        value: 'orthopedics', child: Text('กระดูกและข้อ')),
                  ],
                  onChanged: cubit.onDepartmentChanged,
                  validator: (v) => v == null ? 'กรุณาเลือกแผนก' : null,
                ),
                const SizedBox(height: 20),

                // ── ประเภทการนัด (Radio) ─────────────────────────────────
                Text(
                  'ประเภทการนัดหมาย',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Radio<String>(
                      key: const Key('appt_05_type_radio_opd'),
                      value: 'OPD',
                      groupValue: state.appointmentType,
                      onChanged: (v) {
                        if (v != null) cubit.onAppointmentTypeChanged(v);
                      },
                    ),
                    const Text('มาด้วยตนเอง (OPD)'),
                    const SizedBox(width: 24),
                    Radio<String>(
                      key: const Key('appt_05_type_radio_tele'),
                      value: 'Telemedicine',
                      groupValue: state.appointmentType,
                      onChanged: (v) {
                        if (v != null) cubit.onAppointmentTypeChanged(v);
                      },
                    ),
                    const Text('พบแพทย์ออนไลน์'),
                  ],
                ),

                // ── Section 3: วันและเวลา ─────────────────────────────────
                const SizedBox(height: 28),
                const _SectionHeader(
                  title: 'วันและเวลานัดหมาย',
                  icon: Icons.calendar_month_outlined,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('appt_06_date_textfield'),
                  controller: _dateCtrl,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  decoration: _dec(
                    label: 'วันที่นัดหมาย',
                    hint: 'เลือกวันที่',
                    icon: Icons.calendar_today_outlined,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'กรุณาเลือกวันที่นัดหมาย';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  key: const Key('appt_07_time_textfield'),
                  controller: _timeCtrl,
                  readOnly: true,
                  onTap: () => _selectTime(context),
                  decoration: _dec(
                    label: 'ช่วงเวลา',
                    hint: 'เลือกเวลา',
                    icon: Icons.access_time_outlined,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'กรุณาเลือกช่วงเวลา';
                    return null;
                  },
                ),

                // ── Section 4: ข้อมูลเพิ่มเติม ──────────────────────────
                const SizedBox(height: 28),
                const _SectionHeader(
                  title: 'ข้อมูลเพิ่มเติม',
                  icon: Icons.info_outline,
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 0,
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.health_and_safety_outlined,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'มีบัตรประกันสุขภาพ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'บัตรทอง / ประกันสังคม / ประกันเอกชน',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          key: const Key('appt_08_insurance_switch'),
                          value: state.hasInsurance,
                          onChanged: cubit.onHasInsuranceChanged,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  key: const Key('appt_09_note_textfield'),
                  controller: _noteCtrl,
                  decoration: _dec(
                    label: 'อาการเบื้องต้น / หมายเหตุ (ไม่บังคับ)',
                    hint: 'เช่น ปวดหัว มีไข้ 3 วัน...',
                    icon: Icons.notes_outlined,
                  ),
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: cubit.onNoteChanged,
                ),

                // ── Submit ───────────────────────────────────────────────
                const SizedBox(height: 36),
                ElevatedButton(
                  key: const Key('appt_10_confirm_button'),
                  onPressed: isLoading ? null : () => _onSubmit(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.event_available_rounded),
                            SizedBox(width: 8),
                            Text(
                              'ยืนยันนัดหมาย',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

InputDecoration _dec({
  required String label,
  String? hint,
  required IconData icon,
}) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
    hintText: hint,
    hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
    prefixIcon: Icon(icon),
    border: const OutlineInputBorder(),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
  );
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.teal),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(child: Divider()),
      ],
    );
  }
}
