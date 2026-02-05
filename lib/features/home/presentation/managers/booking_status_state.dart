import 'package:doctor/features/home/data/models/booking_status_model.dart';

class BookingStatusState {
  final bool isLoading;
  final String? error;
  final String? successMessage;
  final List<BookingStatusModel> bookings;

  BookingStatusState({
    required this.isLoading,
    required this.bookings,
    this.error,
    this.successMessage,
  });

  factory BookingStatusState.initial() => BookingStatusState(
    isLoading: false,
    bookings: [],
    error: null,
    successMessage: null,
  );

  BookingStatusState copyWith({
    bool? isLoading,
    List<BookingStatusModel>? bookings,
    String? error,
    String? successMessage,
  }) {
    return BookingStatusState(
      isLoading: isLoading ?? this.isLoading,
      bookings: bookings ?? this.bookings,
      error: error,
      successMessage: successMessage,
    );
  }
}
