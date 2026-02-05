class DoctorProfileState {
  final bool isLoading;
  final String? success;
  final String? error;

  DoctorProfileState({required this.isLoading, this.success, this.error});

  factory DoctorProfileState.initial() {
    return DoctorProfileState(isLoading: false);
  }

  DoctorProfileState copyWith({
    bool? isLoading,
    String? success,
    String? error,
  }) {
    return DoctorProfileState(
      isLoading: isLoading ?? this.isLoading,
      success: success,
      error: error,
    );
  }
}
