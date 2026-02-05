class UpdatePhotoResponse {
  final bool status;
  final String message;
  final String? photoUrl;

  UpdatePhotoResponse({
    required this.status,
    required this.message,
    this.photoUrl,
  });

  factory UpdatePhotoResponse.fromJson(Map<String, dynamic> json) {
    return UpdatePhotoResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      photoUrl: json['photo_url'],
    );
  }
}
