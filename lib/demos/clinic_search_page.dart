import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/clinic_search_cubit.dart';
import 'package:master_project/cubit/clinic_search_state.dart';

class ClinicSearchPage extends StatelessWidget {
  const ClinicSearchPage({super.key});

  static const route = '/clinic-search';

  @override
  Widget build(BuildContext context) => const _ClinicSearchView();
}

// ─── Private View ─────────────────────────────────────────────────────────────

class _ClinicSearchView extends StatelessWidget {
  const _ClinicSearchView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ค้นหานัดหมาย',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<ClinicSearchCubit, ClinicSearchState>(
        listenWhen: (prev, curr) =>
            prev.status == ClinicSearchStatus.loading &&
            curr.status != ClinicSearchStatus.loading,
        listener: (context, state) {
          if (state.status == ClinicSearchStatus.success) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                key: const Key('search_01_expected_success'),
                title: const Text('ค้นหาสำเร็จ'),
                content: Text('พบนัดหมาย ${state.appointments.length} รายการ'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('ตกลง'),
                  ),
                ],
              ),
            );
          } else if (state.status == ClinicSearchStatus.error ||
              state.status == ClinicSearchStatus.empty) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                key: const Key('search_01_expected_fail'),
                title: const Text('ค้นหาล้มเหลว'),
                content: Text(
                  state.status == ClinicSearchStatus.empty
                      ? 'ไม่พบนัดหมายที่ตรงกับเงื่อนไข'
                      : state.errorMessage ?? 'ค้นหาล้มเหลว',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('ตกลง'),
                  ),
                ],
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<ClinicSearchCubit>();
          final isLoading = state.status == ClinicSearchStatus.loading;
          return Column(
            children: [
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        key: const Key('search_01_patient_name_textfield'),
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                          labelText: 'ชื่อผู้ป่วย',
                          labelStyle: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600),
                          hintText: 'เช่น สมชาย',
                          hintStyle:
                              TextStyle(fontSize: 12, color: Colors.grey),
                          prefixIcon:
                              Icon(Icons.person_search_outlined, size: 18),
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 10),
                        ),
                        onChanged: cubit.onPatientNameChanged,
                        onSubmitted: (_) => cubit.search(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      key: const Key('search_05_end_button'),
                      onPressed: isLoading ? null : cubit.search,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 18),
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.search, size: 18),
                                SizedBox(width: 4),
                                Text('ค้นหา',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
              Expanded(child: _ResultSection(state: state)),
            ],
          );
        },
      ),
    );
  }
}

// ─── Result Section ───────────────────────────────────────────────────────────

class _ResultSection extends StatelessWidget {
  final ClinicSearchState state;

  const _ResultSection({required this.state});

  @override
  Widget build(BuildContext context) {
    switch (state.status) {
      case ClinicSearchStatus.initial:
        return const _HintCard();
      case ClinicSearchStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case ClinicSearchStatus.empty:
        return const _NotFoundCard();
      case ClinicSearchStatus.error:
        return _ErrorCard(message: state.errorMessage ?? 'เกิดข้อผิดพลาด');
      case ClinicSearchStatus.success:
        return _AppointmentList(appointments: state.appointments);
    }
  }
}

class _HintCard extends StatelessWidget {
  const _HintCard();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_note_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text('ค้นหานัดหมายผู้ป่วย',
              style: TextStyle(fontSize: 16, color: Colors.grey[500])),
          const SizedBox(height: 8),
          Text('ใช้ตัวกรองด้านบนเพื่อค้นหา',
              style: TextStyle(fontSize: 13, color: Colors.grey[400])),
        ],
      ),
    );
  }
}

class _NotFoundCard extends StatelessWidget {
  const _NotFoundCard();

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const Key('search_04_not_found'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.find_in_page_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text('ไม่พบนัดหมาย',
              style: TextStyle(fontSize: 16, color: Colors.grey[500])),
          const SizedBox(height: 8),
          Text('ลองปรับเงื่อนไขการค้นหา',
              style: TextStyle(fontSize: 13, color: Colors.grey[400])),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;

  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const Key('search_05_error'),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Appointment List ─────────────────────────────────────────────────────────

class _AppointmentList extends StatelessWidget {
  final List<Map<String, dynamic>> appointments;

  const _AppointmentList({required this.appointments});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            'พบ ${appointments.length} นัดหมาย',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            key: const Key('search_06_result_list'),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            itemCount: appointments.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) =>
                _AppointmentCard(appt: appointments[index], index: index),
          ),
        ),
      ],
    );
  }
}

// ─── Appointment Card ─────────────────────────────────────────────────────────

class _AppointmentCard extends StatelessWidget {
  final Map<String, dynamic> appt;
  final int index;

  const _AppointmentCard({required this.appt, required this.index});

  static const _deptLabels = <String, String>{
    'internal_medicine': 'อายุรกรรม',
    'surgery': 'ศัลยกรรม',
    'pediatrics': 'กุมารเวชศาสตร์',
    'obstetrics': 'สูติ-นรีเวช',
    'ophthalmology': 'จักษุวิทยา',
    'ent': 'หู คอ จมูก',
    'orthopedics': 'กระดูกและข้อ',
  };

  @override
  Widget build(BuildContext context) {
    final name = appt['patientName']?.toString() ?? '-';
    final dept = _deptLabels[appt['department']?.toString()] ??
        appt['department']?.toString() ??
        '-';
    final date = appt['appointmentDate']?.toString() ?? '-';
    final time = appt['appointmentTime']?.toString() ?? '-';
    final type = appt['appointmentType']?.toString() ?? '-';
    final hasInsurance = appt['hasInsurance'] == true;
    final note = appt['note']?.toString() ?? '';

    final isOpd = type == 'OPD';
    final typeColor = isOpd ? Colors.teal : Colors.indigo;

    return Card(
      key: Key('search_appt_card_$index'),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      name.isNotEmpty ? name[0] : '?',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Row(children: [
                        const Icon(Icons.local_hospital_outlined,
                            size: 13, color: Colors.grey),
                        const SizedBox(width: 3),
                        Text(dept,
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[600])),
                      ]),
                    ],
                  ),
                ),
                // Type badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: typeColor.withOpacity(0.4)),
                  ),
                  child: Text(
                    type,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: typeColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),

            // Date / Time / Insurance row
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 14, color: Colors.grey),
                const SizedBox(width: 5),
                Text(date,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(width: 16),
                const Icon(Icons.access_time_outlined,
                    size: 14, color: Colors.grey),
                const SizedBox(width: 5),
                Text(time,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500)),
                const Spacer(),
                if (hasInsurance)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.health_and_safety_outlined,
                            size: 12, color: Colors.green),
                        SizedBox(width: 3),
                        Text('มีประกัน',
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.green,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
              ],
            ),

            if (note.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.notes_outlined,
                      size: 14, color: Colors.grey),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(note,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
