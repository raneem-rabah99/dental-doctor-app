class DoctorTooth {
  final int id;
  final String name; // "1_8"
  String descripe;
  final int number;
  final String? photo;
  final String createdAt;
  final String updatedAt;

  DoctorTooth({
    required this.id,
    required this.name,
    required this.descripe,
    required this.number,
    this.photo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DoctorTooth.fromApi(Map<String, dynamic> json) {
    return DoctorTooth(
      // ✅ id قد يأتي String أو int
      id:
          json['id'] is int
              ? json['id']
              : int.tryParse(json['id']?.toString() ?? '0') ?? 0,

      name: json['name']?.toString() ?? '',

      descripe: json['descripe']?.toString() ?? '',

      // ✅ number غالبًا String
      number:
          json['number'] is int
              ? json['number']
              : int.tryParse(json['number']?.toString() ?? '0') ?? 0,

      // ✅ nullable
      photo: json['photo_panorama_generated'] as String?,

      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  /// 🔑 نفس النظام القديم
  String toProblemString() => "${name}_${descripe}";
}
