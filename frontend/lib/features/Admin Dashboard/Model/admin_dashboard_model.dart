class AdminLandlordRequestModel {
  final String id;
  final String status;
  final String createdAt;
  final String name;
  final String email;
  final String? docPath;

  AdminLandlordRequestModel({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.name,
    required this.email,
    this.docPath,
  });

  factory AdminLandlordRequestModel.fromJson(Map<String, dynamic> json) {
    return AdminLandlordRequestModel(
      id: json['id'] ?? '',
      status: json['status'] ?? 'PENDING',
      createdAt: json['createdAt'] ?? '',
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? '',
      docPath: json['docPath'],
    );
  }
}