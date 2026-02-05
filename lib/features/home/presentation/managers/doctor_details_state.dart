import 'package:flutter/material.dart';

class DoctorDetailsState {
  final bool isLoading;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final String? errorMessage;
  final String? successMessage;

  const DoctorDetailsState({
    required this.isLoading,
    this.selectedDate,
    this.selectedTime,
    this.errorMessage,
    this.successMessage,
  });

  factory DoctorDetailsState.initial() {
    return DoctorDetailsState(
      isLoading: false,
      selectedDate: null,
      selectedTime: null,
      errorMessage: null,
      successMessage: null,
    );
  }

  DoctorDetailsState copyWith({
    bool? isLoading,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    String? errorMessage,
    String? successMessage,
  }) {
    return DoctorDetailsState(
      isLoading: isLoading ?? this.isLoading,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      // هنا الأهم 👇 نحافظ على القيم القديمة لو ما مررت قيمة جديدة
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}
