class RegisterState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const RegisterState({
    required this.isLoading,
    this.errorMessage,
    this.successMessage,
  });

  factory RegisterState.initial() {
    return const RegisterState(isLoading: false);
  }

  RegisterState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}
