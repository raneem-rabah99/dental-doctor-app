import 'dart:io';
import 'package:dio/dio.dart';
import 'package:doctor/core/api/base_url.dart';
import '../models/doctor_tooth_model.dart';

class DoctorTeethService {
  Dio get _dio => ApiClient.dio;

  Options _authOptions(String token) {
    return Options(headers: {"Authorization": "Bearer $token"});
  }

  /// POST /doctor/create_teeth-doctor
  Future<DoctorTooth> createTooth({
    required String token,
    required int pId,
    required String name, // "3_8"
    required int number,
    required String descripe,
    File? photo, // optional
  }) async {
    final form = FormData.fromMap({
      "p_id": pId,
      "name": name,
      "number": number,
      "describe": descripe, // ✅ API wants "describe" here
      if (photo != null)
        "photo": await MultipartFile.fromFile(
          photo.path,
          filename: photo.path.split(Platform.pathSeparator).last,
        ),
    });

    final res = await _dio.post(
      "/doctor/create_teeth-doctor",
      data: form,
      options: _authOptions(token),
    );

    if (res.data is Map && res.data["status"] == true) {
      return DoctorTooth.fromApi(res.data["data"] as Map<String, dynamic>);
    }
    throw Exception(_extractMessage(res.data) ?? "Create tooth failed");
  }

  /// POST /doctor/teeth/update-descripe
  Future<DoctorTooth> updateDescripe({
    required String token,
    required int id,
    required String descripe,
    File? photo, // optional
  }) async {
    final form = FormData.fromMap({
      "id": id,
      "descripe": descripe,
      if (photo != null)
        "photo": await MultipartFile.fromFile(
          photo.path,
          filename: photo.path.split(Platform.pathSeparator).last,
        ),
    });

    final res = await _dio.post(
      "/doctor/teeth/update-descripe",
      data: form,
      options: _authOptions(token),
    );

    if (res.data is Map && res.data["status"] == true) {
      return DoctorTooth.fromApi(res.data["data"] as Map<String, dynamic>);
    }
    throw Exception(_extractMessage(res.data) ?? "Update descripe failed");
  }

  /// POST /doctor/delete/teeth
  Future<String> deleteTooth({required String token, required int id}) async {
    final res = await _dio.post(
      "/doctor/delete/teeth",
      data: {"id": id},
      options: _authOptions(token),
    );

    if (res.data is Map && res.data["status"] == true) {
      return (res.data["message"] ?? "Deleted").toString();
    }
    throw Exception(_extractMessage(res.data) ?? "Delete failed");
  }

  String? _extractMessage(dynamic data) {
    if (data is Map) return data["message"]?.toString();
    return null;
  }
}
