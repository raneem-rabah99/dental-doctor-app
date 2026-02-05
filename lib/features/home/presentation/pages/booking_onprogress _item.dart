import 'dart:io';

import 'package:doctor/features/home/presentation/pages/BookingOnProgressItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:doctor/core/theme/app_assets.dart';
import 'package:doctor/core/theme/app_color.dart';
import 'package:doctor/features/home/data/models/booking_status_model.dart';
import 'package:doctor/features/home/presentation/managers/booking_status_cubit.dart';

class BookingOnProgressItem extends StatefulWidget {
  final BookingStatusModel booking;

  const BookingOnProgressItem({super.key, required this.booking});

  @override
  State<BookingOnProgressItem> createState() => _BookingOnProgressItemState();
}

class _BookingOnProgressItemState extends State<BookingOnProgressItem> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final TextEditingController _noteController = TextEditingController();

  String? imagePath;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final path = await _secureStorage.read(key: 'image');
    if (mounted) {
      setState(() => imagePath = path);
    }
  }

  void _showCompleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Complete Booking"),
          content: TextField(
            controller: _noteController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "Add treatment note...",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _noteController.clear();
                Navigator.pop(dialogContext);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<BookingStatusCubit>().completeBooking(
                  bookingId: widget.booking.bookingId,
                  note: _noteController.text,
                );
                _noteController.clear();
                Navigator.pop(dialogContext);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.darkblue,
              ),
              child: const Text("Complete"),
            ),
          ],
        );
      },
    );
  }

  void _openDetectTeethPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetectTeethPage(customerId: widget.booking.customerId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _openDetectTeethPage,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 6),
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
            /// Left blue indicator
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 6,
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
                  /// Header
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage:
                            (imagePath != null && File(imagePath!).existsSync())
                                ? FileImage(File(imagePath!))
                                : const AssetImage(AppAssets.user)
                                    as ImageProvider,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.booking.firstName,
                            style: const TextStyle(
                              fontFamily: 'Serif',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
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

                  /// Date & Time
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 13),
                      const SizedBox(width: 5),
                      Text("From: ${widget.booking.date}"),
                      const SizedBox(width: 10),
                      const Icon(Icons.access_time, size: 13),
                      const SizedBox(width: 5),
                      Text("At: ${widget.booking.time}"),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => _showCompleteDialog(context),
                        style: TextButton.styleFrom(
                          backgroundColor: AppColor.darkblue.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Complete",
                          style: TextStyle(
                            fontFamily: 'Serif',
                            color: AppColor.darkblue,
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
      ),
    );
  }
}
