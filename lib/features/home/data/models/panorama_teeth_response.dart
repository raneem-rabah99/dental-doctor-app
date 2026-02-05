import 'package:doctor/features/home/data/models/customer_model.dart';
import 'package:doctor/features/home/data/models/panorama_photo_model.dart';
import 'tooth_model.dart';

class PanoramaTeethResponse {
  final CustomerModel? customer;
  final PanoramaPhotoModel? panoramaPhoto;
  final List<ToothModel> teeth;

  PanoramaTeethResponse({
    required this.customer,
    required this.panoramaPhoto,
    required this.teeth,
  });

  factory PanoramaTeethResponse.fromJson(Map<String, dynamic> json) {
    return PanoramaTeethResponse(
      customer:
          json['customer'] != null
              ? CustomerModel.fromJson(json['customer'])
              : null,

      panoramaPhoto:
          json['panorama_photo'] != null
              ? PanoramaPhotoModel.fromJson(json['panorama_photo'])
              : null,

      teeth:
          (json['teeth'] as List? ?? [])
              .map((e) => ToothModel.fromJson(e))
              .toList(),
    );
  }
}
