class BookingStatusModel {
  final int bookingId;
  final String date;
  final String time;
  final String status;
  final String note;

  // Patient info
  final int customerId;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String gender;
  final String address;
  final String birthdate;

  BookingStatusModel({
    required this.bookingId,
    required this.date,
    required this.time,
    required this.status,
    required this.note,
    required this.customerId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.gender,
    required this.address,
    required this.birthdate,
  });

  String get patientName => "$firstName $lastName";

  factory BookingStatusModel.fromJson(Map<String, dynamic> json) {
    return BookingStatusModel(
      bookingId: json["booking_id"] ?? 0, // ✅ FIX
      date: json["date"] ?? "",
      time: json["time"] ?? "",
      status: json["status"] ?? "",
      note: json["note"] ?? "",
      customerId: json["customer_id"] ?? 0,
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      phone: json["phone"] ?? "",
      email: json["email"] ?? "",
      gender: json["gender"] ?? "",
      address: json["address"] ?? "",
      birthdate: json["birthdate"] ?? "",
    );
  }
}
