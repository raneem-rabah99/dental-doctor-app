import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:doctor/core/api/base_url.dart';

class DoctorDetailsService {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> bookAppointment({
    required int doctorId,
    required String date,
    required String time,
  }) async {
    final token = await storage.read(key: "token");
    if (token == null) throw Exception("User not authenticated");

    final response = await ApiClient.dio.post(
      "/customer/createbookings",
      data: {"d_id": doctorId, "date": date, "time": time},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    return response.data;
  }
}
