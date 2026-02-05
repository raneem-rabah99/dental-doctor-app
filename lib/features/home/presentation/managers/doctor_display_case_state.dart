import 'package:doctor/features/home/data/models/doctor_display_case_model.dart';

class DoctorDisplayCaseState {
  final bool isLoading;
  final List<DoctorDisplayCaseModel> cases;
  final String? errorMessage;
  final String? successMessage;

  const DoctorDisplayCaseState({
    this.isLoading = false,
    this.cases = const [],
    this.errorMessage,
    this.successMessage,
  });

  DoctorDisplayCaseState copyWith({
    bool? isLoading,
    List<DoctorDisplayCaseModel>? cases,
    String? errorMessage,
    String? successMessage,
  }) {
    return DoctorDisplayCaseState(
      isLoading: isLoading ?? this.isLoading,
      cases: cases ?? this.cases,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}
