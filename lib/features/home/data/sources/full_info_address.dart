import 'package:dio/dio.dart';

final Dio _dio = Dio();

Future<String> getFullAddress(double lat, double lng) async {
  final response = await _dio.get(
    "https://nominatim.openstreetmap.org/reverse",
    queryParameters: {"format": "json", "lat": lat, "lon": lng},
    options: Options(headers: {"User-Agent": "FlutterApp"}),
  );

  if (response.statusCode == 200) {
    final data = response.data;
    final address = data["address"] ?? {};

    final road = address["road"] ?? "";
    final neighbourhood = address["neighbourhood"] ?? "";
    final city = address["city"] ?? address["town"] ?? address["village"] ?? "";
    final state = address["state"] ?? "";
    final country = address["country"] ?? "";

    return "$road, $neighbourhood, $city, $state, $country";
  }

  return "Unknown location";
}
