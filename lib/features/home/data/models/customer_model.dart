class CustomerModel {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String gender;
  final String address;
  final String birthdate;

  CustomerModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.gender,
    required this.address,
    required this.birthdate,
  });

  String get fullName => "$firstName $lastName";
  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['customer_id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      address: json['address'] ?? '',
      birthdate: json['birthdate'] ?? '',
    );
  }
}
