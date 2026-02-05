import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:doctor/core/api/base_url.dart';

class BookingDeleteService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String> deleteBooking(int id) async {
    final token = await _storage.read(key: "token");
    if (token == null) throw Exception("User not authenticated.");

    final response = await ApiClient.dio.delete(
      "/customer/deletebookings",
      data: {"id": id},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    if (response.statusCode == 200) {
      return response.data["message"] ?? "Deleted successfully.";
    } else {
      throw Exception(response.data["message"] ?? "Failed to delete booking");
    }
  }
}
