class AdminHouseModel {
  final String houseId;
  final String title;
  final String description;
  final String price;
  final String imageUrl;
  final String landlordEmail;
  final String landlordName;
  final String createdAt;

  AdminHouseModel({
    required this.houseId,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.landlordEmail,
    required this.landlordName,
    required this.createdAt,
  });

  factory AdminHouseModel.fromJson(Map<String, dynamic> json) {
    return AdminHouseModel(
      houseId: json['house_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '0',
      imageUrl: json['image_url'] ?? '',
      landlordEmail: json['landlord_email'] ?? '',
      landlordName: json['landlord_name'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}