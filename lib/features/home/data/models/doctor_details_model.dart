class DoctorDetailsModel {
  final int doctorId;
  final String date;
  final String time;

  DoctorDetailsModel({
    required this.doctorId,
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {"d_id": doctorId, "date": date, "time": time};
  }
}
