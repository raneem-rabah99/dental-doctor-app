import 'package:dio/dio.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://fded2fe2f977.ngrok-free.app/api",
      connectTimeout: const Duration(seconds: 150),
      receiveTimeout: const Duration(seconds: 150),
      headers: {"Accept": "application/json"},
      followRedirects: true,
      validateStatus: (status) => status != null && status < 500,
    ),
  )..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
}
