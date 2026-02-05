import 'package:dio/dio.dart';
import 'package:doctor/features/home/data/models/panorama_teeth_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:doctor/core/api/base_url.dart'; // contains ApiClient

class PanoramaTeethService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // ===============================
  // POST /doctor/panorama-teeth
  // ===============================
  Future<PanoramaTeethResponse> fetchPanoramaTeeth({
    required int customerId,
  }) async {
    final token = await _storage.read(key: "token");

    if (token == null || token.isEmpty) {
      throw Exception("Authentication token not found");
    }

    final response = await ApiClient.dio.post(
      "/doctor/panorama-teeth",
      data: {"customer_id": customerId},
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      ),
    );

    if (response.statusCode == 401) {
      throw Exception("Session expired. Please login again.");
    }

    if (response.data == null || response.data["status"] != true) {
      throw Exception(
        response.data?["message"] ?? "Failed to load panorama teeth",
      );
    }

    return PanoramaTeethResponse.fromJson(response.data["data"]);
  }
}
