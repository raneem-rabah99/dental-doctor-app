class PanoramaPhotoModel {
  final int id;
  final String photo;

  PanoramaPhotoModel({required this.id, required this.photo});

  factory PanoramaPhotoModel.fromJson(Map<String, dynamic> json) {
    return PanoramaPhotoModel(id: json['id'] ?? 0, photo: json['photo'] ?? '');
  }
}
