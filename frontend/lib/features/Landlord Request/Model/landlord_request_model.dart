class LandlordRequestModel {
  final String id;
  final String status;
  final String createdAt;

  LandlordRequestModel({
    required this.id,
    required this.status,
    required this.createdAt,
  });

  factory LandlordRequestModel.fromJson(Map<String, dynamic> json) {
    return LandlordRequestModel(
      id: json['id'] ?? '',
      status: json['status'] ?? 'PENDING',
      createdAt: json['createdAt'] ?? '',
    );
  }
}