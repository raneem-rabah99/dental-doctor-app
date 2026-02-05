class DeletePhotoState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  DeletePhotoState({
    required this.isLoading,
    this.errorMessage,
    this.successMessage,
  });

  factory DeletePhotoState.initial() {
    return DeletePhotoState(isLoading: false);
  }

  DeletePhotoState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return DeletePhotoState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}
