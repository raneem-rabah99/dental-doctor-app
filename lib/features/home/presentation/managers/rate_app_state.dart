class RateAppState {
  final bool isLoading;
  final String? success;
  final String? error;

  RateAppState({required this.isLoading, this.success, this.error});

  factory RateAppState.initial() => RateAppState(isLoading: false);

  RateAppState copyWith({bool? isLoading, String? success, String? error}) {
    return RateAppState(
      isLoading: isLoading ?? this.isLoading,
      success: success,
      error: error,
    );
  }
}
