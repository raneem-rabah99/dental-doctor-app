import 'package:doctor/core/api/base_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LogoutService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String> logout() async {
    final token = await _storage.read(key: "token");
    if (token == null) throw Exception("No token stored. User not logged in.");

    final response = await ApiClient.dio.post(
      "/logout",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ),
    );

    if (response.statusCode == 200 && response.data["status"] == true) {
      // Remove token locally
      await _storage.delete(key: "token");

      return response.data["message"] ?? "Logout successful";
    } else {
      throw Exception(response.data["message"] ?? "Logout failed.");
    }
  }
}
