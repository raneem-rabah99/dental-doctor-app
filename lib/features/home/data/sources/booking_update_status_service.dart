import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:doctor/core/api/base_url.dart';

class BookingUpdateStatusService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String> updateStatus({
    required int bookingId,
    required String status,
    String? note,
  }) async {
    try {
      final token = await _storage.read(key: "token");

      if (token == null || token.isEmpty) {
        throw Exception("Unauthenticated");
      }

      final response = await ApiClient.dio.post(
        "/doctor/bookings/update-status",
        data: {
          "booking_id": bookingId,
          "status": status,
          if (note != null) "note": note,
        },

        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 200 && response.data["status"] == true) {
        return response.data["message"];
      } else {
        throw Exception(response.data["message"] ?? "Update failed");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
