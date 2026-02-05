import 'dart:io';
import 'package:doctor/core/api/base_url.dart';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:doctor/features/home/data/models/UpdatePhotoModel.dart';

class UpdatePhotoService {
  final _storage = const FlutterSecureStorage();

  Future<UpdatePhotoResponse> uploadPhoto(File file) async {
    try {
      String? token = await _storage.read(key: 'token');

      final formData = FormData.fromMap({
        "photo": await MultipartFile.fromFile(file.path),
      });

      final response = await ApiClient.dio.post(
        "/update-photo",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      return UpdatePhotoResponse.fromJson(response.data);
    } catch (e) {
      return UpdatePhotoResponse(status: false, message: e.toString());
    }
  }
}
