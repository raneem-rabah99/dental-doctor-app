class LoginState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const LoginState({
    required this.isLoading,
    this.errorMessage,
    this.successMessage,
  });

  factory LoginState.initial() {
    return const LoginState(isLoading: false);
  }

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}
