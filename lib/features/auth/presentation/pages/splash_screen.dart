import 'package:doctor/core/classes/icon_classes.dart';
import 'package:doctor/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 3));

    final token = await _storage.read(key: 'token');

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      // ✅ Logged in
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      // ❌ Not logged in
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [AppColor.darkblue, AppColor.lightblue],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Iconsteeth.teeth,
              const SizedBox(height: 12),
              const Text(
                'ByteDent',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
