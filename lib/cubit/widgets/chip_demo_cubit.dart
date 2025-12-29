import 'package:flutter_bloc/flutter_bloc.dart';

class ChipDemoState {
  final String selectedChoice;
  final Set<String> selectedFilters;
  final Set<String> selectedInterests;

  ChipDemoState({
    this.selectedChoice = '',
    this.selectedFilters = const {},
    this.selectedInterests = const {},
  });

  ChipDemoState copyWith({
    String? selectedChoice,
    Set<String>? selectedFilters,
    Set<String>? selectedInterests,
  }) {
    return ChipDemoState(
      selectedChoice: selectedChoice ?? this.selectedChoice,
      selectedFilters: selectedFilters ?? this.selectedFilters,
      selectedInterests: selectedInterests ?? this.selectedInterests,
    );
  }
}

class ChipDemoCubit extends Cubit<ChipDemoState> {
  ChipDemoCubit() : super(ChipDemoState());

  void onChoiceSelected(String value) {
    emit(state.copyWith(selectedChoice: value));
  }

  void onFilterToggled(String value) {
    final newFilters = Set<String>.from(state.selectedFilters);
    if (newFilters.contains(value)) {
      newFilters.remove(value);
    } else {
      newFilters.add(value);
    }
    emit(state.copyWith(selectedFilters: newFilters));
  }

  void onInterestToggled(String value) {
    final newInterests = Set<String>.from(state.selectedInterests);
    if (newInterests.contains(value)) {
      newInterests.remove(value);
    } else {
      newInterests.add(value);
    }
    emit(state.copyWith(selectedInterests: newInterests));
  }
}
