class DoctorTooth {
  final int id;
  final int pId;
  final String name; // "1_7"
  final int number;
  final String descripe;
  final String? photoPanoramaGenerated;
  final String createdAt;
  final String updatedAt;

  const DoctorTooth({
    required this.id,
    required this.pId,
    required this.name,
    required this.number,
    required this.descripe,
    required this.photoPanoramaGenerated,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DoctorTooth.fromApi(Map<String, dynamic> json) {
    return DoctorTooth(
      id: _toInt(json['id']),
      pId: _toInt(json['p_id']),
      name: (json['name'] ?? '').toString(),
      number: _toInt(json['number']),
      descripe: (json['descripe'] ?? json['describe'] ?? '').toString(),
      photoPanoramaGenerated: json['photo_panorama_generated']?.toString(),
      createdAt: (json['created_at'] ?? '').toString(),
      updatedAt: (json['updated_at'] ?? '').toString(),
    );
  }

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }
}
