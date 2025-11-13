import 'package:bloc/bloc.dart';
import 'register_state.dart';

class DemoCubit extends Cubit<RegisterState> {
  final bool shouldSucceed;

  DemoCubit({this.shouldSucceed = false}) : super(RegisterState.initial());

  void onTextChanged(String value) => emit(state.copyWith(username: value));

  void onGenderSelected(int selected) => emit(state.copyWith(gender: selected));

  void onPrimaryButton() => emit(state.copyWith(count: state.count + 1));

  void reset() => emit(RegisterState.initial());

  Future<void> onEndButton() async {
    try {
      // Simulate an API call
      await Future<void>.delayed(const Duration(milliseconds: 300));

      if (shouldSucceed) {
        // Fake API JSON response
        final json = {
          'message': 'ok',
          'code': 200,
          // any other fields could be added when UI needs them
        };
        final resp = ApiResponse.fromJson(json);
        // Map response into state and clear exception
        emit(state.copyWith(response: resp, exception: null));
      } else {
        // Derive error code from selected option: <3 => 400, >=3 => 500
        final opt = state.gender ?? 0;
        final code = opt >= 3 ? 500 : 400;
        throw RegisterException(message: 'api_failed', code: code);
      }
    } catch (e) {
      // Failure: set exception, keep previous response
      if (e is RegisterException) {
        emit(state.copyWith(exception: e));
      } else {
        emit(state.copyWith(exception: const RegisterException(message: 'api_failed', code: 500)));
      }
    }
  }
}
