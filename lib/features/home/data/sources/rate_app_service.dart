import 'package:doctor/core/api/base_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RateAppService {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> sendRate({
    required int rate,
    required String feedback,
  }) async {
    final token = await storage.read(key: 'token');

    final response = await ApiClient.dio.post(
      "/rate-app",
      data: {"rate": rate, "feedback": feedback},
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ),
    );

    return response.data;
  }
}
