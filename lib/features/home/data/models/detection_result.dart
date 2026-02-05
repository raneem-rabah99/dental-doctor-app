class DetectionResult {
  final String label;

  DetectionResult({required this.label});

  factory DetectionResult.fromJson(Map<String, dynamic> json) {
    return DetectionResult(label: json['label']);
  }
}
