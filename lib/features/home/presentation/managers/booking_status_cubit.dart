import 'package:doctor/features/home/data/sources/booking_complete_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_status_state.dart';
import '../../data/sources/booking_status_service.dart';
import '../../data/sources/booking_update_status_service.dart';

class BookingStatusCubit extends Cubit<BookingStatusState> {
  final BookingStatusService service;
  final BookingUpdateStatusService updateService = BookingUpdateStatusService();
  final BookingCompleteService completeService = BookingCompleteService();

  BookingStatusCubit(this.service) : super(BookingStatusState.initial());

  Future<void> loadStatus(String status) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final bookings = await service.loadByStatus(status);
      if (isClosed) return; // ✅

      emit(state.copyWith(isLoading: false, bookings: bookings));
    } catch (e) {
      if (isClosed) return; // ✅ مهم جدًا
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// ✅ CANCEL / APPROVE
  Future<void> updateBookingStatus({
    required int bookingId,
    required String status,
  }) async {
    try {
      final message = await updateService.updateStatus(
        bookingId: bookingId,
        status: status,
      );
      if (isClosed) return; // ✅

      final updatedList =
          state.bookings.where((b) => b.bookingId != bookingId).toList();

      emit(
        state.copyWith(
          bookings: updatedList,
          successMessage: message,
          error: null,
        ),
      );
    } catch (e) {
      if (isClosed) return; // ✅ ناقصة عندك
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> completeBooking({
    required int bookingId,
    required String note,
  }) async {
    try {
      final message = await completeService.completeBooking(
        bookingId: bookingId,
        note: note,
      );
      if (isClosed) return; // ✅

      final updatedList =
          state.bookings.where((b) => b.bookingId != bookingId).toList();

      emit(
        state.copyWith(
          bookings: updatedList,
          successMessage: message,
          error: null,
        ),
      );
    } catch (e) {
      if (isClosed) return; // ✅ ناقصة
      emit(state.copyWith(error: e.toString()));
    }
  }
}
