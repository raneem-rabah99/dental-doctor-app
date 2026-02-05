class RateAppModel {
  final int rate;
  final String feedback;

  RateAppModel({required this.rate, required this.feedback});

  Map<String, dynamic> toJson() {
    return {"rate": rate, "feedback": feedback};
  }
}
