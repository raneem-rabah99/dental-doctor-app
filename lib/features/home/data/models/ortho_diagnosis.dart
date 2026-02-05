class OrthoDiagnosis {
  final String upper;
  final String lower;
  final String finalResult;

  OrthoDiagnosis({
    required this.upper,
    required this.lower,
    required this.finalResult,
  });

  factory OrthoDiagnosis.fromJson(Map<String, dynamic> json) {
    return OrthoDiagnosis(
      upper: json['upper'],
      lower: json['lower'],
      finalResult: json['final'],
    );
  }
}
