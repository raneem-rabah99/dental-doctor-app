import 'package:dio/dio.dart';
import 'package:doctor/features/auth/data/models/customer_info_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:doctor/core/api/base_url.dart';

class DoctorProfileService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> uploadDoctorProfile(
    DoctorProfileModel model,
  ) async {
    try {
      // ───────────── AUTH TOKEN ─────────────
      final token = await _secureStorage.read(key: 'token');

      if (token == null || token.isEmpty) {
        throw Exception("Unauthenticated: Token not found");
      }

      // ───────────── FORM DATA ─────────────
      final FormData formData = FormData();

      // Text fields
      formData.fields.addAll([
        MapEntry("specialization", model.specialization),
        MapEntry("previous_works", model.previousWorks),
        MapEntry("open_time", model.openTime),
        MapEntry("close_time", model.closeTime),
      ]);

      // ───────────── FILE FIELD NAME ─────────────
      // ⚠️ VERY IMPORTANT
      // Change this ONLY if backend uses another name
      final String cvFieldName = "cv";

      // ───────────── CV FILE ─────────────
      if (kIsWeb) {
        // Web / Desktop (bytes)
        if (model.cvBytes == null || model.cvBytes!.isEmpty) {
          throw Exception("CV not selected");
        }

        formData.files.add(
          MapEntry(
            cvFieldName,
            MultipartFile.fromBytes(
              model.cvBytes!,
              filename: model.cvFileName ?? "cv.pdf",
            ),
          ),
        );
      } else {
        // Mobile (file path)
        if (model.cvFile == null) {
          throw Exception("CV not selected");
        }

        formData.files.add(
          MapEntry(
            cvFieldName,
            await MultipartFile.fromFile(
              model.cvFile!.path,
              filename: model.cvFileName ?? model.cvFile!.path.split('/').last,
            ),
          ),
        );
      }

      // ───────────── DEBUG (KEEP FOR NOW) ─────────────
      debugPrint("FORM FIELDS => ${formData.fields}");
      debugPrint(
        "FORM FILES => ${formData.files.map((e) => "${e.key}: ${e.value.filename}").toList()}",
      );

      // ───────────── REQUEST ─────────────
      final response = await ApiClient.dio.post(
        "/doctor/profile",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
            // ❌ DO NOT set Content-Type manually
          },
        ),
      );

      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception("Unauthenticated");
      }

      throw Exception(e.response?.data['message'] ?? "Upload failed");
    }
  }
}
