class LogoutState {
  final bool isLoading;
  final bool success;
  final String? error;

  LogoutState({required this.isLoading, required this.success, this.error});

  factory LogoutState.initial() =>
      LogoutState(isLoading: false, success: false);

  LogoutState copyWith({bool? isLoading, bool? success, String? error}) {
    return LogoutState(
      isLoading: isLoading ?? this.isLoading,
      success: success ?? this.success,
      error: error,
    );
  }
}
