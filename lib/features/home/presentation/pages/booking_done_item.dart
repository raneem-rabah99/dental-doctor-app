import 'dart:io';
import 'package:doctor/core/theme/app_assets.dart';
import 'package:doctor/core/theme/app_color.dart';
import 'package:doctor/features/home/data/models/booking_status_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BookingDoneItem extends StatefulWidget {
  final BookingStatusModel booking;

  const BookingDoneItem({Key? key, required this.booking}) : super(key: key);

  @override
  _BookingDoneItemState createState() => _BookingDoneItemState();
}

class _BookingDoneItemState extends State<BookingDoneItem> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? imagePath;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final path = await _storage.read(key: 'image');
    setState(() => imagePath = path);
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
          // Left color strip
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
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile row
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
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Serif',
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 14),
                            SizedBox(width: 5),
                            SizedBox(
                              width: 180,
                              child: Text(
                                widget.booking.address,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Serif',
                                  decoration: TextDecoration.underline,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    Spacer(),
                  ],
                ),

                const SizedBox(height: 10),

                // Date + time
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14),
                    SizedBox(width: 5),
                    Text(
                      "From: ${widget.booking.date}",
                      style: TextStyle(fontSize: 12, fontFamily: 'Serif'),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.access_time, size: 14),
                    SizedBox(width: 5),
                    Text(
                      "At: ${widget.booking.time}",
                      style: TextStyle(fontSize: 12, fontFamily: 'Serif'),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Doctor note section (dummy UI)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.booking.note,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Serif',
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
