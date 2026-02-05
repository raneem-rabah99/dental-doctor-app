class TodayApprovedModel {
  final int bookingId;
  final String date;
  final String time;
  final String status;
  final String note;

  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String gender;
  final String address;
  final String? photo;

  TodayApprovedModel({
    required this.bookingId,
    required this.date,
    required this.time,
    required this.status,
    required this.note,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.gender,
    required this.address,
    this.photo,
  });

  factory TodayApprovedModel.fromJson(Map<String, dynamic> json) {
    return TodayApprovedModel(
      bookingId: json['booking_id'],
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      status: json['status'] ?? '',
      note: json['note'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      address: json['address'] ?? '',
      photo: json['photo'],
    );
  }
}
