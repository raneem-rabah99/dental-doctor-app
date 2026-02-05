import 'package:doctor/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Header extends StatelessWidget {
  Header({super.key});
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          // ✅ allow theme background
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FutureBuilder<Map<String, String?>>(
                future: _getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColor.darkblue,
                      ),
                    );
                  }

                  final userData = snapshot.data;
                  final username = userData?['username'] ?? 'User';
                  final imagePath = userData?['image'];

                  const String defaultImage = 'assets/images/dentist.png';

                  ImageProvider imageProvider;

                  // CASE 1: Network image
                  if (imagePath != null &&
                      (imagePath.startsWith('http://') ||
                          imagePath.startsWith('https://'))) {
                    imageProvider = NetworkImage(imagePath);
                  }
                  // CASE 2: Local file
                  else if (imagePath != null &&
                      !kIsWeb &&
                      File(imagePath).existsSync()) {
                    imageProvider = FileImage(File(imagePath));
                  }
                  // CASE 3: Default asset
                  else {
                    imageProvider = const AssetImage(defaultImage);
                  }

                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white,
                        backgroundImage: imageProvider,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        username,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                },
              ),
              Text("ByteDent"),
            ],
          ),
        ),
      ],
    );
  }

  Future<Map<String, String?>> _getUserData() async {
    String? username = await _secureStorage.read(key: 'username');
    String? imagePath = await _secureStorage.read(key: 'image');
    return {'username': username, 'image': imagePath};
  }
}
