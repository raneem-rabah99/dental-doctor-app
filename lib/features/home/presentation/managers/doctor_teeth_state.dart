import '../../data/models/doctor_tooth_model.dart';

class DoctorTeethState {
  final bool isLoading;
  final String? error;
  final String? message;

  final DoctorTooth? created;
  final DoctorTooth? updated;
  final int? deletedId;

  const DoctorTeethState({
    required this.isLoading,
    this.error,
    this.message,
    this.created,
    this.updated,
    this.deletedId,
  });

  factory DoctorTeethState.initial() =>
      const DoctorTeethState(isLoading: false);

  DoctorTeethState copyWith({
    bool? isLoading,
    String? error,
    String? message,
    DoctorTooth? created,
    DoctorTooth? updated,
    int? deletedId,
    bool clearError = false,
    bool clearMessage = false,
    bool clearResults = false,
  }) {
    return DoctorTeethState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      message: clearMessage ? null : (message ?? this.message),
      created: clearResults ? null : (created ?? this.created),
      updated: clearResults ? null : (updated ?? this.updated),
      deletedId: clearResults ? null : (deletedId ?? this.deletedId),
    );
  }
}
