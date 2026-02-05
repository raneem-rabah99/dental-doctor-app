import 'package:doctor/core/api/base_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:doctor/features/home/data/models/delete_photo_response.dart';

class DeletePhotoService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<DeletePhotoResponse> deletePhoto() async {
    final token = await _storage.read(key: "token");
    if (token == null) throw Exception("User not authenticated!");

    final response = await ApiClient.dio.delete(
      "/delete-photo",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    if (response.statusCode == 200) {
      return DeletePhotoResponse.fromJson(response.data);
    } else {
      throw Exception(response.data["message"] ?? "Failed to delete photo");
    }
  }
}
