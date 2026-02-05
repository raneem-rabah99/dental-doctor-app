import 'dart:io';
import 'package:dio/dio.dart';
import 'package:doctor/core/api/base_url.dart';

import 'package:doctor/features/home/data/models/doctor_detect_result.dart';
import 'package:doctor/features/home/data/models/doctor_panorama_model.dart';
import 'package:doctor/features/home/data/models/doctor_tooth.dart';

class DioService {
  Future<DoctorDetectResult> detectDoctorTeeth(
    File image,
    String token,
    String customerName,
  ) async {
    final formData = FormData.fromMap({
      "photo": await MultipartFile.fromFile(
        image.path,
        filename: image.path.split('/').last,
      ),
      "customer_name": customerName, // ✅ REQUIRED
    });

    final response = await ApiClient.dio.post(
      "/ai/doctor/detect-teeth",
      data: formData,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    if (response.data['status'] == true) {
      return DoctorDetectResult.fromApi(response.data);
    } else {
      throw Exception(response.data['message']);
    }
  }

  Future<List<DoctorPanorama>> getDoctorPanoramas(String token) async {
    final response = await ApiClient.dio.get(
      "/doctor/getpanoramasteeth",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    // ✅ تأكد من النوع
    final data = response.data;

    if (data is Map<String, dynamic> && data['status'] == true) {
      final list = data['data'] as List;

      return list
          .map((e) => DoctorPanorama.fromApi(e as Map<String, dynamic>))
          .toList();
    } else if (data is Map<String, dynamic>) {
      throw Exception(data['message'] ?? 'Unknown error');
    } else {
      throw Exception('Invalid response format');
    }
  }

  // =========================
  // ✏️ Update Tooth Descripe
  // =========================
  Future<void> updateToothDescripe({
    required int toothId,
    required String descripe,
    File? photo,
    required String token,
  }) async {
    final formData = FormData.fromMap({
      "_method": "PUT", // ✅ مهم جدًا لـ Laravel
      "id": toothId.toString(), // ✅ لازم String
      "descripe": descripe,
      if (photo != null)
        "photo": await MultipartFile.fromFile(
          photo.path,
          filename: photo.path.split('/').last,
        ),
    });

    final response = await ApiClient.dio.post(
      "/doctor/teeth/update-descripe",
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ),
    );

    final data = response.data;

    if (data is! Map || data['status'] != true) {
      throw Exception(data is Map ? data['message'] : "Update failed");
    }
  }

  Future<void> deleteTooth({
    required int toothId,
    required String token,
  }) async {
    final formData = FormData.fromMap({
      "_method": "DELETE", // ✅ Laravel
      "id": toothId.toString(), // ✅ String
    });

    final response = await ApiClient.dio.post(
      "/doctor/delete/teeth",
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ),
    );

    final data = response.data;

    if (data is! Map || data['status'] != true) {
      throw Exception(data is Map ? data['message'] : "Delete failed");
    }
  }

  Future<DoctorTooth> createToothDoctor({
    required int panoramaId,
    required String name,
    required int number,
    required String descripe,
    File? photo,
    required String token,
  }) async {
    final formData = FormData.fromMap({
      "p_id": panoramaId.toString(),
      "name": name,
      "number": number.toString(),
      "descripe": descripe,
      if (photo != null)
        "photo": await MultipartFile.fromFile(
          photo.path,
          filename: photo.path.split('/').last,
        ),
    });

    final response = await ApiClient.dio.post(
      "/doctor/teeth/store", // ✅ المسار الصحيح
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ),
    );

    final data = response.data;

    if (data is! Map || data['status'] != true) {
      throw Exception(data is Map ? data['message'] : "Create failed");
    }

    // ✅ رجّع السن الجديد
    return DoctorTooth.fromApi(data['data']);
  }

  /*
  // ============================
  // API 2️⃣ Orthodontic Diagnosis
  // ============================
  Future<Map<String, dynamic>> diagnoseOrtho(File image) async {
    final formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(
        image.path,
        filename: image.path.split('/').last,
      ),
    });

    final response = await _dio.post(
      "/diagnose_ortho",
      data: formData,
      options: Options(
        sendTimeout: const Duration(seconds: 120),
        receiveTimeout: const Duration(seconds: 120),
      ),
    );

    return Map<String, dynamic>.from(response.data);
  }
}

  // ============================
  // API 2️⃣ Orthodontic Diagnosis
  // ============================

  /**
  Future<Map<String, dynamic>> diagnoseOrtho(File image) async {
    final formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(image.path),
    });

    final response = await _dio.post("/diagnose_ortho", data: formData);
    return response.data;
  }*/
*/
}
