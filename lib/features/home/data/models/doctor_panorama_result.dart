import 'package:doctor/features/home/data/models/doctor_tooth.dart';

class DoctorPanoramaResult {
  final int panoramaId;
  final String photo;
  final String customerName;
  final int teethCount;
  final List<DoctorTooth> teeth;

  DoctorPanoramaResult({
    required this.panoramaId,
    required this.photo,
    required this.customerName,
    required this.teethCount,
    required this.teeth,
  });

  factory DoctorPanoramaResult.fromApi(Map<String, dynamic> json) {
    final data = json['data'];
    return DoctorPanoramaResult(
      panoramaId: data['panorama_id'],
      photo: data['photo'],
      customerName: data['customer_name'],
      teethCount: data['teeth_count'],
      teeth:
          (data['teeth'] as List).map((e) => DoctorTooth.fromApi(e)).toList(),
    );
  }
}
