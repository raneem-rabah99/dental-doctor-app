class ToothModel {
  final int id;
  final int number;
  final String name;
  final String description;
  final String panoramaImage;
  final String icon;

  ToothModel({
    required this.id,
    required this.number,
    required this.name,
    required this.description,
    required this.panoramaImage,
    required this.icon,
  });

  factory ToothModel.fromJson(Map<String, dynamic> json) {
    return ToothModel(
      id: json['id'] ?? 0,
      number: json['number'] ?? 0,
      name: json['name'] ?? '',
      description: json['descripe'] ?? '', // ✅ FIX
      panoramaImage: json['photo_panorama_generated'] ?? '', // ✅ FIX
      icon: json['photo_icon'] ?? '', // ✅ FIX (field does not exist)
    );
  }
}
