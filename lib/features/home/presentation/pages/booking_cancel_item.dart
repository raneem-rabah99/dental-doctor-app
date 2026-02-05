import 'dart:io';
import 'package:doctor/core/theme/app_assets.dart';
import 'package:doctor/core/theme/app_color.dart';
import 'package:doctor/features/home/data/models/booking_status_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BookingCancelItem extends StatelessWidget {
  final BookingStatusModel booking;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  BookingCancelItem({Key? key, required this.booking}) : super(key: key);

  Future<String?> _getUserImage() async {
    return await _secureStorage.read(key: 'image');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getUserImage(),
      builder: (context, snapshot) {
        String? imagePath = snapshot.data;
        String defaultImagePath = AppAssets.user;

        ImageProvider imageProvider;

        if (imagePath != null && File(imagePath).existsSync()) {
          imageProvider =
              kIsWeb
                  ? NetworkImage(imagePath)
                  : FileImage(File(imagePath)) as ImageProvider;
        } else {
          imageProvider = AssetImage(defaultImagePath);
        }

        return Container(
          width: 600,
          margin: const EdgeInsets.only(right: 10),
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
              // blue left strip
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
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row top info
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: imageProvider,
                        ),

                        const SizedBox(width: 12),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.firstName,
                              style: const TextStyle(
                                fontFamily: 'Serif',
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: 200,
                              child: Text(
                                booking.address,
                                style: const TextStyle(
                                  fontFamily: 'Serif',
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Date + time
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 12),
                        const SizedBox(width: 5),
                        Text(
                          "From: ${booking.date}",
                          style: TextStyle(fontFamily: 'Serif', fontSize: 11),
                        ),
                        const SizedBox(width: 10),
                        Icon(Icons.access_time, size: 12),
                        const SizedBox(width: 5),
                        Text(
                          "At: ${booking.time}",
                          style: TextStyle(fontFamily: 'Serif', fontSize: 11),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Cancel note
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
