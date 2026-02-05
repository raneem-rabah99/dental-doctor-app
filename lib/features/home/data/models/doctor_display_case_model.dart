class DoctorDisplayCaseModel {
  final int id;
  final int dId;
  final String photoBefore;
  final String photoAfter;
  final int favoriteFlag;
  final String createdAt;
  final String updatedAt;

  DoctorDisplayCaseModel({
    required this.id,
    required this.dId,
    required this.photoBefore,
    required this.photoAfter,
    required this.favoriteFlag,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DoctorDisplayCaseModel.fromJson(Map<String, dynamic> json) {
    return DoctorDisplayCaseModel(
      id: json["id"],
      dId: json["d_id"],
      photoBefore: json["photo_before"],
      photoAfter: json["photo_after"],
      favoriteFlag: json["favorite_flag"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }
}
