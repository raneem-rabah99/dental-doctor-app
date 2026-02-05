import 'package:doctor/core/theme/app_color.dart';
import 'package:doctor/features/home/data/sources/booking_status_service.dart';
import 'package:doctor/features/home/presentation/managers/booking_status_cubit.dart';
import 'package:doctor/features/home/presentation/managers/booking_status_state.dart';
import 'package:doctor/features/home/presentation/pages/booking_onprogress%20_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingOnProgressSection extends StatelessWidget {
  const BookingOnProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              BookingStatusCubit(BookingStatusService())
                ..loadStatus("approved"),
      child: BlocBuilder<BookingStatusCubit, BookingStatusState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColor.darkblue),
            );
          }

          if (state.error != null) {
            return Center(child: Text(state.error!));
          }

          if (state.bookings.isEmpty) {
            return const Center(child: Text("No confirmed bookings"));
          }

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 15.0),
              itemCount: state.bookings.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: BookingOnProgressItem(booking: state.bookings[index]),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
