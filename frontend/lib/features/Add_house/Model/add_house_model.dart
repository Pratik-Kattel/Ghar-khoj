class HouseUploadResponse {
  final String message;

  HouseUploadResponse({required this.message});

  factory HouseUploadResponse.fromJson(Map<String, dynamic> json) {
    return HouseUploadResponse(
      message: json['message'] ?? '',
    );
  }
}