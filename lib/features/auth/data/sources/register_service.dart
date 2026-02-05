import 'package:dio/dio.dart';
import 'package:doctor/core/api/base_url.dart';
import '../models/register_model.dart';

class RegisterService {
  Future<Map<String, dynamic>> register(RegisterModel model) async {
    try {
      final response = await ApiClient.dio.post(
        '/register',
        data: model.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception("Unexpected status code: ${response.statusCode}");
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? "Registration failed");
      } else {
        throw Exception("Network error");
      }
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
