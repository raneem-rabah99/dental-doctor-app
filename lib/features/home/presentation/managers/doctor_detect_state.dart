import 'package:doctor/features/home/data/models/doctor_detect_result.dart';

class DoctorDetectState {
  final bool isLoading;
  final DoctorDetectResult? result;
  final String? error;
  final String? successMessage;

  DoctorDetectState({
    required this.isLoading,
    this.result,
    this.error,
    this.successMessage,
  });

  factory DoctorDetectState.initial() => DoctorDetectState(
    isLoading: false,
    result: null,
    error: null,
    successMessage: null,
  );

  DoctorDetectState copyWith({
    bool? isLoading,
    DoctorDetectResult? result,
    String? error,
    String? successMessage,
  }) {
    return DoctorDetectState(
      isLoading: isLoading ?? this.isLoading,
      result: result ?? this.result,
      error: error,
      successMessage: successMessage,
    );
  }
}
