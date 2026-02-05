import '../../data/models/today_approved_model.dart';

class TodayApprovedState {
  final bool isLoading;
  final List<TodayApprovedModel> cases;
  final String? error;

  TodayApprovedState({
    required this.isLoading,
    required this.cases,
    this.error,
  });

  factory TodayApprovedState.initial() {
    return TodayApprovedState(isLoading: false, cases: [], error: null);
  }

  TodayApprovedState copyWith({
    bool? isLoading,
    List<TodayApprovedModel>? cases,
    String? error,
  }) {
    return TodayApprovedState(
      isLoading: isLoading ?? this.isLoading,
      cases: cases ?? this.cases,
      error: error,
    );
  }
}
