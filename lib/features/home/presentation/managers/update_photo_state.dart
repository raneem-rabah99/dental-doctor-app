class UpdatePhotoState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  UpdatePhotoState({
    required this.isLoading,
    this.errorMessage,
    this.successMessage,
  });

  factory UpdatePhotoState.initial() {
    return UpdatePhotoState(isLoading: false);
  }

  UpdatePhotoState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return UpdatePhotoState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}
