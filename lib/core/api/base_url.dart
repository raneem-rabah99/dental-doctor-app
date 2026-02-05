import 'package:dio/dio.dart';

class ApiClient {
  static final Dio dio = Dio(
      BaseOptions(
        baseUrl: "http://46.224.222.138/api",

        connectTimeout: const Duration(seconds: 150),
        receiveTimeout: const Duration(seconds: 150),

        headers: {"Accept": "application/json"},

        // ✅ FIX 307 (ngrok redirect)
        followRedirects: true,

        // ✅ Allow 3xx, only fail on 5xx
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    )
    // ✅ Optional: log requests for debugging
    ..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
}
