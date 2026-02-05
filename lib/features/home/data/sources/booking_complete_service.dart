import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:doctor/core/api/base_url.dart';

class BookingCompleteService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String> completeBooking({
    required int bookingId,
    required String note,
  }) async {
    try {
      final token = await _storage.read(key: "token");

      if (token == null || token.isEmpty) {
        throw Exception("Unauthenticated");
      }

      final response = await ApiClient.dio.post(
        "/doctor/bookings/complete",
        data: {"booking_id": bookingId, "note": note},
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
        throw Exception(
          response.data["message"] ?? "Failed to complete booking",
        );
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
