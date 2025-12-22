import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final bool shouldSucceed;

  EmployeeCubit({this.shouldSucceed = false}) : super(const EmployeeState());

  void onEmployeeIdChanged(String value) {
    emit(state.copyWith(employeeId: value));
  }

  void onDepartmentChanged(String? value) {
    emit(state.copyWith(department: value));
  }

  void onEmailChanged(String value) {
    emit(state.copyWith(email: value));
  }

  void onYearsOfServiceChanged(String value) {
    final years = int.tryParse(value);
    emit(state.copyWith(yearsOfService: years));
  }

  void onSatisfactionRatingSelected(int value) {
    emit(state.copyWith(satisfactionRating: value));
  }

  void onRecommendCompanyChanged(bool value) {
    emit(state.copyWith(recommendCompany: value));
  }

  void onAttendTrainingChanged(bool value) {
    emit(state.copyWith(attendTraining: value));
  }

  Future<void> submitEmployeeSurvey() async {
    emit(state.copyWith(status: EmployeeStatus.loading));

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/api/demo/employee'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'employeeId': state.employeeId,
          'department': state.department,
          'email': state.email,
          'yearsOfService': state.yearsOfService,
          'satisfactionRating': state.satisfactionRating,
          'recommendCompany': state.recommendCompany,
          'attendTraining': state.attendTraining,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final apiResponse = ApiResponse.fromJson(data);
        emit(state.copyWith(
          status: EmployeeStatus.success,
          response: apiResponse,
        ));
      } else {
        final data = jsonDecode(response.body);
        emit(state.copyWith(
          status: EmployeeStatus.error,
          errorMessage: data['message'] ?? 'Unknown error',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: EmployeeStatus.error,
        errorMessage: 'Failed to submit: $e',
      ));
    }
  }

  Future<void> callApi() async {
    await submitEmployeeSurvey();
  }

  Future<void> onEndButton() async {
    await submitEmployeeSurvey();
  }
}
