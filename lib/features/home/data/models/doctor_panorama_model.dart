import 'package:doctor/features/home/data/models/doctor_tooth.dart';

class DoctorPanorama {
  final int id;
  final String photo;
  final String customerName;
  final String createdAt;
  final String updatedAt;
  final List<DoctorTooth> teeth;

  DoctorPanorama({
    required this.id,
    required this.photo,
    required this.customerName,
    required this.createdAt,
    required this.updatedAt,
    required this.teeth,
  });

  factory DoctorPanorama.fromApi(Map<String, dynamic> json) {
    return DoctorPanorama(
      id: json['id'] ?? 0,
      photo: json['photo'] ?? '',
      customerName: json['customer_name'] ?? '', // safe fallback
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      teeth:
          (json['teeth'] as List? ?? [])
              .map((e) => DoctorTooth.fromApi(e))
              .toList(),
    );
  }
}
