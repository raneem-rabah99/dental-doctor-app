class ToothDetection {
  final List<int> box;
  final String cropUrl;

  ToothDetection({required this.box, required this.cropUrl});

  factory ToothDetection.fromJson(Map<String, dynamic> json) {
    return ToothDetection(
      box: List<int>.from(json['box']),
      cropUrl: json['crop_url'],
    );
  }
}
