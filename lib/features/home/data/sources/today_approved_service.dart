import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/today_approved_model.dart';
import '../../../../core/api/base_url.dart';

class TodayApprovedService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<List<TodayApprovedModel>> fetchTodayApproved() async {
    final token = await _storage.read(key: "token");

    if (token == null) {
      throw Exception("Token not found");
    }

    final response = await ApiClient.dio.get(
      "/doctor/today-approved",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    if (response.data == null || response.data["status"] != true) {
      throw Exception(response.data?["message"] ?? "Failed");
    }

    final List list = response.data["data"];

    return list.map((e) => TodayApprovedModel.fromJson(e)).toList();
  }
}
