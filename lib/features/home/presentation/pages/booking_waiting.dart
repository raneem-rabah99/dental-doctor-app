import 'package:doctor/core/theme/app_color.dart';
import 'package:doctor/features/home/data/sources/booking_status_service.dart';
import 'package:doctor/features/home/presentation/managers/booking_status_cubit.dart';
import 'package:doctor/features/home/presentation/managers/booking_status_state.dart';
import 'package:doctor/features/home/presentation/pages/booking_waiting_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingWaitingSection extends StatelessWidget {
  const BookingWaitingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              BookingStatusCubit(BookingStatusService())..loadStatus("pending"),
      child: BlocConsumer<BookingStatusCubit, BookingStatusState>(
        listener: (context, state) {
          // SUCCESS SNACKBAR
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: Colors.green,
              ),
            );
          }

          // ERROR SNACKBAR
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColor.darkblue),
            );
          }

          if (state.bookings.isEmpty) {
            return const Center(child: Text("No pending bookings"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: state.bookings.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: BookingWaitingItem(booking: state.bookings[index]),
              );
            },
          );
        },
      ),
    );
  }
}
