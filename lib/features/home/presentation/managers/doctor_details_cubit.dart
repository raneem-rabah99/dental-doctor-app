import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'doctor_details_state.dart';
import '../../data/sources/doctor_details_service.dart';

class DoctorDetailsCubit extends Cubit<DoctorDetailsState> {
  final Map<String, dynamic> doctor;
  final DoctorDetailsService _service = DoctorDetailsService();

  DoctorDetailsCubit(this.doctor) : super(DoctorDetailsState.initial());

  late final String rawRange = doctor["time"] ?? "00:00-23:59";

  TimeOfDay get rangeStart {
    final start = rawRange.split("-")[0];
    return _parseTime(start);
  }

  TimeOfDay get rangeEnd {
    final end = rawRange.split("-")[1];
    return _parseTime(end);
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(":");
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  bool _isTimeWithinRange(TimeOfDay t) {
    final selected = t.hour * 60 + t.minute;
    final start = rangeStart.hour * 60 + rangeStart.minute;
    final end = rangeEnd.hour * 60 + rangeEnd.minute;
    return selected >= start && selected <= end;
  }

  // ----------------------------- SELECT DATE -----------------------------
  void selectDate(DateTime date) {
    emit(
      state.copyWith(
        selectedDate: date,
        errorMessage: null,
        successMessage: null,
      ),
    );
  }

  // ----------------------------- SELECT TIME -----------------------------
  void selectTime(TimeOfDay time) {
    if (!_isTimeWithinRange(time)) {
      emit(
        state.copyWith(
          selectedTime: null,
          errorMessage:
              "The selected time is not available. Available time range is $rawRange",
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        selectedTime: time,
        errorMessage: null,
        successMessage: null,
      ),
    );
  }

  String formatTime24(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return "$h:$m";
  }

  // ----------------------------- BOOK APPOINTMENT -----------------------------
  Future<void> bookAppointment() async {
    if (doctor["id"] == null) {
      emit(state.copyWith(errorMessage: "Invalid doctor ID"));
      return;
    }

    if (state.selectedDate == null) {
      emit(state.copyWith(errorMessage: "Please choose a date"));
      return;
    }

    if (state.selectedTime == null) {
      emit(state.copyWith(errorMessage: "Please choose a valid time"));
      return;
    }

    if (!_isTimeWithinRange(state.selectedTime!)) {
      emit(
        state.copyWith(
          errorMessage: "This time is not available. Allowed time: $rawRange",
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true));

    try {
      final date =
          "${state.selectedDate!.year}-${state.selectedDate!.month.toString().padLeft(2, '0')}-${state.selectedDate!.day.toString().padLeft(2, '0')}";

      final time = formatTime24(state.selectedTime!);

      final result = await _service.bookAppointment(
        doctorId: doctor["id"],
        date: date,
        time: time,
      );

      if (isClosed) return; // ✅ الحل هنا

      emit(
        state.copyWith(
          isLoading: false,
          successMessage:
              result["message"] ?? "Appointment booked successfully",
        ),
      );
    } catch (e) {
      if (isClosed) return; // ✅ وأيضًا هنا
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
