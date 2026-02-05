import 'dart:io';
import 'package:doctor/core/theme/app_assets.dart';
import 'package:doctor/core/theme/app_color.dart';
import 'package:doctor/features/home/data/models/booking_status_model.dart';
import 'package:doctor/features/home/presentation/managers/booking_status_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BookingWaitingItem extends StatefulWidget {
  final BookingStatusModel booking;

  const BookingWaitingItem({Key? key, required this.booking}) : super(key: key);

  @override
  State<BookingWaitingItem> createState() => _BookingWaitingItemState();
}

class _BookingWaitingItemState extends State<BookingWaitingItem> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  String? imagePath;

  @override
  void initState() {
    super.initState();
    _loadUserImage();
  }

  Future<void> _loadUserImage() async {
    String? storedImagePath = await _secureStorage.read(key: 'image');
    setState(() => imagePath = storedImagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Blue strip
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 8,
              decoration: BoxDecoration(
                color: AppColor.darkblue,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage:
                          (imagePath != null && File(imagePath!).existsSync())
                              ? FileImage(File(imagePath!))
                              : AssetImage(AppAssets.user) as ImageProvider,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.booking.firstName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 13),
                            const SizedBox(width: 5),
                            SizedBox(
                              width: 180,
                              child: Text(
                                widget.booking.address,
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Date & time
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14),
                    const SizedBox(width: 5),
                    Text("From: ${widget.booking.date}"),
                    const SizedBox(width: 10),
                    const Icon(Icons.access_time, size: 14),
                    const SizedBox(width: 5),
                    Text("At: ${widget.booking.time}"),
                  ],
                ),

                const SizedBox(height: 10),

                // Buttons (Approve + Cancel)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        context.read<BookingStatusCubit>().updateBookingStatus(
                          bookingId: widget.booking.bookingId,
                          status: "approved",
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: AppColor.darkblue.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Approve",
                        style: TextStyle(
                          fontFamily: 'Serif',
                          color: AppColor.darkblue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        context.read<BookingStatusCubit>().updateBookingStatus(
                          bookingId: widget.booking.bookingId,
                          status: "cancelled",
                        );
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Color(0xffE3E3E3)),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontFamily: 'Serif',
                          color: Color(0xff666666),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
