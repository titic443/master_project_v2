import 'dart:convert';
import 'dart:io' show Platform;

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

import 'course_enrollment_state.dart';

class CourseEnrollmentCubit extends Cubit<CourseEnrollmentState> {
  final String? baseUrl;

  CourseEnrollmentCubit({this.baseUrl}) : super(const CourseEnrollmentState());

  String get _baseUrl {
    if (baseUrl != null) return baseUrl!;
    if (Platform.isAndroid) return 'http://10.0.2.2:8000';
    return 'http://localhost:8000';
  }

  void onCourseNameChanged(String v) => emit(state.copyWith(courseName: v));
  void onStudentNameChanged(String v) => emit(state.copyWith(studentName: v));
  void onEmailChanged(String v) => emit(state.copyWith(email: v));
  void onPhoneChanged(String v) => emit(state.copyWith(phone: v));
  void onStudentLevelChanged(String? v) =>
      emit(state.copyWith(studentLevel: v));
  void onCourseCategoryChanged(String? v) =>
      emit(state.copyWith(courseCategory: v));
  void onPaymentMethodChanged(String? v) =>
      emit(state.copyWith(paymentMethod: v));
  void onDurationChanged(String v) => emit(state.copyWith(duration: v));
  void onPriceChanged(String v) => emit(state.copyWith(price: v));
  void onNeedCertificateChanged(bool v) =>
      emit(state.copyWith(needCertificate: v));
  void onAgreeTermsChanged(bool v) => emit(state.copyWith(agreeTerms: v));

  Future<void> submit() async {
    emit(state.copyWith(status: CourseEnrollmentStatus.loading));
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/demo/enrollments'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'courseName': state.courseName,
          'studentName': state.studentName,
          'email': state.email,
          'phone': state.phone,
          'studentLevel': state.studentLevel,
          'courseCategory': state.courseCategory,
          'paymentMethod': state.paymentMethod,
          'duration': int.tryParse(state.duration) ?? 0,
          'price': int.tryParse(state.price) ?? 0,
          'needCertificate': state.needCertificate,
          'agreeTerms': state.agreeTerms,
        }),
      );

      if (response.statusCode == 200) {
        emit(state.copyWith(status: CourseEnrollmentStatus.success));
      } else {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        emit(state.copyWith(
          status: CourseEnrollmentStatus.error,
          errorMessage:
              data['message']?.toString() ?? 'Failed to enroll in course',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: CourseEnrollmentStatus.error,
        errorMessage: 'Connection error: $e',
      ));
    }
  }
}
