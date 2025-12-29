import 'package:flutter_bloc/flutter_bloc.dart';

class SegmentedButtonDemoState {
  final String size;
  final String deliverySpeed;
  final Set<String> toppings;

  SegmentedButtonDemoState({
    this.size = 'M',
    this.deliverySpeed = 'standard',
    this.toppings = const {},
  });

  SegmentedButtonDemoState copyWith({
    String? size,
    String? deliverySpeed,
    Set<String>? toppings,
  }) {
    return SegmentedButtonDemoState(
      size: size ?? this.size,
      deliverySpeed: deliverySpeed ?? this.deliverySpeed,
      toppings: toppings ?? this.toppings,
    );
  }
}

class SegmentedButtonDemoCubit extends Cubit<SegmentedButtonDemoState> {
  SegmentedButtonDemoCubit() : super(SegmentedButtonDemoState());

  void onSizeChanged(String value) {
    emit(state.copyWith(size: value));
  }

  void onDeliverySpeedChanged(String value) {
    emit(state.copyWith(deliverySpeed: value));
  }

  void onToppingsChanged(Set<String> value) {
    emit(state.copyWith(toppings: value));
  }
}
