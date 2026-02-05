class DeletePhotoResponse {
  final bool status;
  final String message;
  final bool deleted;

  DeletePhotoResponse({
    required this.status,
    required this.message,
    required this.deleted,
  });

  factory DeletePhotoResponse.fromJson(Map<String, dynamic> json) {
    return DeletePhotoResponse(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      deleted: json["deleted"] ?? false,
    );
  }
}
