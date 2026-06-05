import 'package:equatable/equatable.dart';

enum CourseEnrollmentStatus { initial, loading, success, error }

class CourseEnrollmentState extends Equatable {
  final CourseEnrollmentStatus status;
  final String courseName;
  final String studentName;
  final String email;
  final String phone;
  final String? studentLevel;
  final String? courseCategory;
  final String? paymentMethod;
  final String duration;
  final String price;
  final bool needCertificate;
  final bool agreeTerms;
  final String? errorMessage;

  const CourseEnrollmentState({
    this.status = CourseEnrollmentStatus.initial,
    this.courseName = '',
    this.studentName = '',
    this.email = '',
    this.phone = '',
    this.studentLevel,
    this.courseCategory,
    this.paymentMethod,
    this.duration = '',
    this.price = '',
    this.needCertificate = false,
    this.agreeTerms = false,
    this.errorMessage,
  });

  CourseEnrollmentState copyWith({
    CourseEnrollmentStatus? status,
    String? courseName,
    String? studentName,
    String? email,
    String? phone,
    String? studentLevel,
    String? courseCategory,
    String? paymentMethod,
    String? duration,
    String? price,
    bool? needCertificate,
    bool? agreeTerms,
    String? errorMessage,
  }) {
    return CourseEnrollmentState(
      status: status ?? this.status,
      courseName: courseName ?? this.courseName,
      studentName: studentName ?? this.studentName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      studentLevel: studentLevel ?? this.studentLevel,
      courseCategory: courseCategory ?? this.courseCategory,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      needCertificate: needCertificate ?? this.needCertificate,
      agreeTerms: agreeTerms ?? this.agreeTerms,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        courseName,
        studentName,
        email,
        phone,
        studentLevel,
        courseCategory,
        paymentMethod,
        duration,
        price,
        needCertificate,
        agreeTerms,
        errorMessage,
      ];
}
