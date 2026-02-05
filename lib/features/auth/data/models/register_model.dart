class RegisterModel {
  final String firstName;
  final String fatherName;
  final String lastName;
  final String phone;
  final String email;
  final String password;
  final String address;
  final String gender;
  final String type;

  RegisterModel({
    required this.firstName,
    required this.fatherName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.password,
    required this.address,
    required this.gender,
    this.type = "doctor",
  });

  Map<String, dynamic> toJson() {
    return {
      "first_name": firstName,
      "father_name": fatherName,
      "last_name": lastName,
      "phone": phone,
      "email": email,
      "password": password,
      "address": address,
      "gender": gender,
      "type": type,
    };
  }

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      firstName: json['first_name'] ?? '',
      fatherName: json['father_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      address: json['address'] ?? '',
      gender: json['gender'] ?? '',
      type: json['type'] ?? 'doctor',
    );
  }
}
