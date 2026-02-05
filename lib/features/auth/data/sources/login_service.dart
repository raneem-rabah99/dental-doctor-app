import 'package:dio/dio.dart';
import 'package:doctor/core/api/base_url.dart';

import '../models/login_model.dart';

class LoginService {
  Future<Map<String, dynamic>> login(LoginModel model) async {
    try {
      final response = await ApiClient.dio.post('/login', data: model.toJson());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Unexpected response: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? "Login failed");
      } else {
        throw Exception("Network error");
      }
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
