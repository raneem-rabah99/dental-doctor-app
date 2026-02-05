import 'package:doctor/core/api/base_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:doctor/features/home/data/models/booking_status_model.dart';

class BookingStatusService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<List<BookingStatusModel>> loadByStatus(String status) async {
    try {
      // 🔐 Token
      final token = await _storage.read(key: "token");
      if (token == null || token.isEmpty) {
        throw Exception("User not authenticated");
      }

      // 🔥 API call (DOCTOR)
      final response = await ApiClient.dio.post(
        "/doctor/bookings/by-status",
        data: {"status": status},
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 200 && response.data["status"] == true) {
        final List list = response.data["data"];
        return list.map((e) => BookingStatusModel.fromJson(e)).toList();
      } else {
        throw Exception(response.data["message"] ?? "Failed to load bookings");
      }
    } catch (e) {
      throw Exception("Error loading bookings: $e");
    }
  }
}
