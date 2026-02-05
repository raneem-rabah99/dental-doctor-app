import 'dart:io';
import 'package:dio/dio.dart';
import 'package:doctor/core/api/base_url.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DoctorDisplayCaseService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // ===============================
  // GET /doctor/display-cases
  // ===============================
  Future<List<Map<String, dynamic>>> getDisplayCases() async {
    final token = await _storage.read(key: "token");

    if (token == null || token.isEmpty) {
      throw Exception("Token not found");
    }

    final response = await ApiClient.dio.get(
      "/doctor/display-cases",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    if (response.data == null || response.data["status"] != true) {
      throw Exception(
        response.data?["message"] ?? "Failed to load display cases",
      );
    }

    return List<Map<String, dynamic>>.from(response.data["data"]);
  }

  // ===============================
  // POST /doctor/upload_display-cases
  // ===============================
  Future<Map<String, dynamic>> uploadDisplayCase({
    required File beforeImage,
    required File afterImage,
  }) async {
    final token = await _storage.read(key: "token");

    if (token == null || token.isEmpty) {
      throw Exception("Authentication token not found");
    }

    final formData = FormData.fromMap({
      "photo_before": await MultipartFile.fromFile(beforeImage.path),
      "photo_after": await MultipartFile.fromFile(afterImage.path),
    });

    final response = await ApiClient.dio.post(
      "/doctor/upload_display-cases",
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "multipart/form-data",
        },
      ),
    );

    if (response.data == null || response.data["status"] != true) {
      throw Exception(response.data?["message"] ?? "Upload failed");
    }

    return Map<String, dynamic>.from(response.data["data"]);
  }

  // ===============================
  // DELETE /doctor/delete-display-cases
  // ===============================
  Future<void> deleteDisplayCase({required int displayCaseId}) async {
    final token = await _storage.read(key: "token");

    if (token == null || token.isEmpty) {
      throw Exception("Authentication token not found");
    }

    final response = await ApiClient.dio.delete(
      // 🔥 USE POST INSTEAD OF DELETE
      "/doctor/delete-display-cases",
      data: {"display_case_id": displayCaseId},
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      ),
    );

    if (response.data == null || response.data["status"] != true) {
      throw Exception(response.data?["message"] ?? "Delete failed");
    }
  }

  Future<Map<String, dynamic>> setFavoriteDisplayCase({
    required int displayCaseId,
    required int favoriteFlag, // 1 or 0
  }) async {
    final token = await _storage.read(key: "token");

    if (token == null || token.isEmpty) {
      throw Exception("Authentication token not found");
    }

    final response = await ApiClient.dio.post(
      "/doctor/display-cases/favorite",
      data: {"display_case_id": displayCaseId, "favorite_flag": favoriteFlag},
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      ),
    );

    if (response.data == null || response.data["status"] != true) {
      throw Exception(response.data?["message"] ?? "Failed to update favorite");
    }

    return Map<String, dynamic>.from(response.data["data"]);
  }
}
