import 'package:flutter_bloc/flutter_bloc.dart';

class SwitchDemoState {
  final bool enableNotifications;
  final bool darkMode;
  final bool autoSave;

  SwitchDemoState({
    this.enableNotifications = false,
    this.darkMode = false,
    this.autoSave = false,
  });

  SwitchDemoState copyWith({
    bool? enableNotifications,
    bool? darkMode,
    bool? autoSave,
  }) {
    return SwitchDemoState(
      enableNotifications: enableNotifications ?? this.enableNotifications,
      darkMode: darkMode ?? this.darkMode,
      autoSave: autoSave ?? this.autoSave,
    );
  }
}

class SwitchDemoCubit extends Cubit<SwitchDemoState> {
  SwitchDemoCubit() : super(SwitchDemoState());

  void onNotificationsChanged(bool value) {
    emit(state.copyWith(enableNotifications: value));
  }

  void onDarkModeChanged(bool value) {
    emit(state.copyWith(darkMode: value));
  }

  void onAutoSaveChanged(bool value) {
    emit(state.copyWith(autoSave: value));
  }
}
