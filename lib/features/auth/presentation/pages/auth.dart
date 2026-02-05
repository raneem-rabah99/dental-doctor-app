import 'package:doctor/features/auth/presentation/pages/login_page.dart';
import 'package:doctor/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthGate extends StatelessWidget {
  AuthGate({super.key});

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<bool> _isLoggedIn() async {
    final token = await _storage.read(key: 'token');
    return token != null && token.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isLoggedIn(),
      builder: (context, snapshot) {
        // ⏳ Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ✅ Logged in
        if (snapshot.data == true) {
          return const HomePage();
        }

        // ❌ Not logged in
        return LoginPage();
      },
    );
  }
}
