import 'package:flutter_bloc/flutter_bloc.dart';

class SliderDemoState {
  final double volume;
  final double brightness;
  final double temperature;

  SliderDemoState({
    this.volume = 50.0,
    this.brightness = 75.0,
    this.temperature = 20.0,
  });

  SliderDemoState copyWith({
    double? volume,
    double? brightness,
    double? temperature,
  }) {
    return SliderDemoState(
      volume: volume ?? this.volume,
      brightness: brightness ?? this.brightness,
      temperature: temperature ?? this.temperature,
    );
  }
}

class SliderDemoCubit extends Cubit<SliderDemoState> {
  SliderDemoCubit() : super(SliderDemoState());

  void onVolumeChanged(double value) {
    emit(state.copyWith(volume: value));
  }

  void onBrightnessChanged(double value) {
    emit(state.copyWith(brightness: value));
  }

  void onTemperatureChanged(double value) {
    emit(state.copyWith(temperature: value));
  }
}
