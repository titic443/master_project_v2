import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/course_enrollment_cubit.dart';
import 'package:master_project/cubit/course_enrollment_state.dart';

class CourseEnrollmentPage extends StatelessWidget {
  const CourseEnrollmentPage({super.key});

  static const route = '/course-enrollment';

  @override
  Widget build(BuildContext context) => const _CourseEnrollmentView();
}

// ─── Private View ─────────────────────────────────────────────────────────────

class _CourseEnrollmentView extends StatefulWidget {
  const _CourseEnrollmentView();

  @override
  State<_CourseEnrollmentView> createState() => _CourseEnrollmentViewState();
}

class _CourseEnrollmentViewState extends State<_CourseEnrollmentView> {
  final _formKey = GlobalKey<FormState>();
  final _courseNameCtrl = TextEditingController();
  final _studentNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _durationCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  @override
  void dispose() {
    _courseNameCtrl.dispose();
    _studentNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _durationCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  void _sync(CourseEnrollmentState state) {
    if (_courseNameCtrl.text != state.courseName) {
      _courseNameCtrl.text = state.courseName;
    }
    if (_studentNameCtrl.text != state.studentName) {
      _studentNameCtrl.text = state.studentName;
    }
    if (_emailCtrl.text != state.email) _emailCtrl.text = state.email;
    if (_phoneCtrl.text != state.phone) _phoneCtrl.text = state.phone;
    if (_durationCtrl.text != state.duration) {
      _durationCtrl.text = state.duration;
    }
    if (_priceCtrl.text != state.price) _priceCtrl.text = state.price;
  }

  void _onSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          key: const Key('course_13_expected_fail'),
          title: const Text('ข้อมูลไม่ถูกต้อง'),
          content: const Text('กรุณาตรวจสอบและแก้ไขข้อมูลที่ไฮไลต์'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ตกลง'),
            ),
          ],
        ),
      );
      return;
    }
    final state = context.read<CourseEnrollmentCubit>().state;
    if (!state.agreeTerms) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          key: const Key('course_13_expected_fail'),
          title: const Text('ยังไม่ได้ยอมรับเงื่อนไข'),
          content: const Text('กรุณายอมรับข้อกำหนดและเงื่อนไขก่อนสมัคร'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ตกลง'),
            ),
          ],
        ),
      );
      return;
    }
    context.read<CourseEnrollmentCubit>().submit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ลงทะเบียนเรียน',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<CourseEnrollmentCubit, CourseEnrollmentState>(
        listenWhen: (prev, curr) =>
            prev.status == CourseEnrollmentStatus.loading &&
            curr.status != CourseEnrollmentStatus.loading,
        listener: (context, state) {
          if (state.status == CourseEnrollmentStatus.success) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                key: const Key('course_13_expected_success'),
                title: const Text('สำเร็จ'),
                content: const Text('ลงทะเบียนเรียนเรียบร้อยแล้ว'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('ตกลง'),
                  ),
                ],
              ),
            );
          } else if (state.status == CourseEnrollmentStatus.error) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                key: const Key('course_13_expected_fail'),
                title: const Text('เกิดข้อผิดพลาด'),
                content:
                    Text(state.errorMessage ?? 'ไม่สามารถลงทะเบียนเรียนได้'),
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
          _sync(state);
          final cubit = context.read<CourseEnrollmentCubit>();
          final isLoading = state.status == CourseEnrollmentStatus.loading;

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
              children: [
                // ── Section 1: Course Information ────────────────────────
                const _SectionHeader(
                  title: 'ข้อมูลคอร์สเรียน',
                  icon: Icons.menu_book_outlined,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('course_01_name_textfield'),
                  controller: _courseNameCtrl,
                  decoration: _dec(
                    label: 'ชื่อคอร์ส',
                    hint: 'เช่น Flutter for Beginners',
                    icon: Icons.school_outlined,
                  ),
                  textCapitalization: TextCapitalization.words,
                  onChanged: cubit.onCourseNameChanged,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'กรุณากรอกชื่อคอร์ส';
                    }
                    if (v.trim().length < 3) {
                      return 'กรุณากรอกอย่างน้อย 3 ตัวอักษร';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  key: const Key('course_05_category_dropdown'),
                  value: state.courseCategory,
                  decoration: _dec(
                    label: 'หมวดหมู่คอร์ส',
                    icon: Icons.category_outlined,
                  ),
                  hint: const Text('เลือกหมวดหมู่'),
                  items: const [
                    DropdownMenuItem(
                        value: 'Programming', child: Text('Programming')),
                    DropdownMenuItem(value: 'Design', child: Text('Design')),
                    DropdownMenuItem(
                        value: 'Business', child: Text('Business')),
                    DropdownMenuItem(
                        value: 'Languages', child: Text('Languages')),
                    DropdownMenuItem(
                        value: 'Math & Science',
                        child: Text('Math & Science')),
                  ],
                  onChanged: cubit.onCourseCategoryChanged,
                  validator: (v) =>
                      v == null ? 'กรุณาเลือกหมวดหมู่คอร์ส' : null,
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  key: const Key('course_06_level_dropdown'),
                  value: state.studentLevel,
                  decoration: _dec(
                    label: 'ระดับผู้เรียน',
                    icon: Icons.stairs_outlined,
                  ),
                  hint: const Text('เลือกระดับ'),
                  items: const [
                    DropdownMenuItem(
                        value: 'High School', child: Text('High School')),
                    DropdownMenuItem(
                        value: 'Undergraduate', child: Text('Undergraduate')),
                    DropdownMenuItem(
                        value: 'Graduate', child: Text('Graduate')),
                    DropdownMenuItem(
                        value: 'Professional', child: Text('Professional')),
                  ],
                  onChanged: cubit.onStudentLevelChanged,
                  validator: (v) => v == null ? 'กรุณาเลือกระดับผู้เรียน' : null,
                ),

                // ── Section 2: Student Information ───────────────────────
                const SizedBox(height: 28),
                const _SectionHeader(
                  title: 'ข้อมูลผู้เรียน',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('course_02_student_textfield'),
                  controller: _studentNameCtrl,
                  decoration: _dec(
                    label: 'ชื่อ-นามสกุล',
                    hint: 'เช่น สมชาย ใจดี',
                    icon: Icons.badge_outlined,
                  ),
                  textCapitalization: TextCapitalization.words,
                  onChanged: cubit.onStudentNameChanged,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'กรุณากรอกชื่อ-นามสกุล';
                    }
                    if (v.trim().length < 2) {
                      return 'กรุณากรอกอย่างน้อย 2 ตัวอักษร';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  key: const Key('course_03_email_textfield'),
                  controller: _emailCtrl,
                  decoration: _dec(
                    label: 'อีเมล',
                    hint: 'name@example.com',
                    icon: Icons.email_outlined,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: cubit.onEmailChanged,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'กรุณากรอกอีเมล';
                    final pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                    if (!pattern.hasMatch(v.trim())) {
                      return 'รูปแบบอีเมลไม่ถูกต้อง';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  key: const Key('course_04_phone_textfield'),
                  controller: _phoneCtrl,
                  decoration: _dec(
                    label: 'เบอร์โทรศัพท์',
                    hint: '0812345678',
                    icon: Icons.phone_outlined,
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  onChanged: cubit.onPhoneChanged,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'กรุณากรอกเบอร์โทรศัพท์';
                    }
                    if (v.trim().length < 9) {
                      return 'เบอร์โทรต้องมี 9-10 หลัก';
                    }
                    return null;
                  },
                ),

                // ── Section 3: Course Detail & Pricing ───────────────────
                const SizedBox(height: 28),
                const _SectionHeader(
                  title: 'ระยะเวลาและค่าเรียน',
                  icon: Icons.payments_outlined,
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        key: const Key('course_08_duration_textfield'),
                        controller: _durationCtrl,
                        decoration: _dec(
                          label: 'ระยะเวลา (สัปดาห์)',
                          hint: '8',
                          icon: Icons.timelapse_outlined,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: cubit.onDurationChanged,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'กรุณากรอกระยะเวลา';
                          }
                          final n = int.tryParse(v);
                          if (n == null) return 'กรุณากรอกเป็นตัวเลข';
                          if (n < 1 || n > 52) return 'ระยะเวลา 1-52 สัปดาห์';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        key: const Key('course_09_price_textfield'),
                        controller: _priceCtrl,
                        decoration: _dec(
                          label: 'ค่าเรียน (บาท)',
                          hint: '5000',
                          icon: Icons.attach_money_outlined,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: cubit.onPriceChanged,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'กรุณากรอกค่าเรียน';
                          }
                          final n = int.tryParse(v);
                          if (n == null) return 'กรุณากรอกเป็นตัวเลข';
                          if (n < 0) return 'ค่าเรียนต้องไม่ติดลบ';
                          if (n > 1000000) {
                            return 'ค่าเรียนต้องไม่เกิน 1,000,000 บาท';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  key: const Key('course_07_payment_dropdown'),
                  value: state.paymentMethod,
                  decoration: _dec(
                    label: 'วิธีการชำระเงิน',
                    icon: Icons.account_balance_wallet_outlined,
                  ),
                  hint: const Text('เลือกวิธีการชำระเงิน'),
                  items: const [
                    DropdownMenuItem(
                        value: 'Credit Card', child: Text('Credit Card')),
                    DropdownMenuItem(
                        value: 'Bank Transfer', child: Text('Bank Transfer')),
                    DropdownMenuItem(
                        value: 'PromptPay', child: Text('PromptPay')),
                    DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                  ],
                  onChanged: cubit.onPaymentMethodChanged,
                  validator: (v) =>
                      v == null ? 'กรุณาเลือกวิธีการชำระเงิน' : null,
                ),

                // ── Section 4: Options ───────────────────────────────────
                const SizedBox(height: 28),
                const _SectionHeader(
                  title: 'ตัวเลือกเพิ่มเติม',
                  icon: Icons.tune_outlined,
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 0,
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withOpacity(0.4),
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
                          Icons.workspace_premium_outlined,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ต้องการใบประกาศนียบัตร',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'รับใบประกาศหลังจบคอร์ส (อาจมีค่าใช้จ่ายเพิ่ม)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          key: const Key('course_10_certificate_switch'),
                          value: state.needCertificate,
                          onChanged: cubit.onNeedCertificateChanged,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                CheckboxListTile(
                  key: const Key('course_11_terms_checkbox'),
                  value: state.agreeTerms,
                  onChanged: (v) =>
                      cubit.onAgreeTermsChanged(v ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text(
                    'ยอมรับข้อกำหนดและเงื่อนไข',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    'ฉันได้อ่านและยอมรับนโยบายการคืนเงินและความเป็นส่วนตัว',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  tileColor: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withOpacity(0.4),
                ),

                // ── Submit ───────────────────────────────────────────────
                const SizedBox(height: 36),
                ElevatedButton(
                  key: const Key('course_12_end_button'),
                  onPressed: isLoading ? null : () => _onSubmit(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.indigo,
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
                            Icon(Icons.app_registration_outlined),
                            SizedBox(width: 8),
                            Text(
                              'ลงทะเบียนเรียน',
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
        Icon(icon, size: 18, color: Colors.indigo),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(child: Divider()),
      ],
    );
  }
}
