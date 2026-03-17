class RecommendedModel {
  final String houseId;
  final String title;
  final String description;
  final double price;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final String landlordEmail;
  final String place;
  final double averageRating;
  final int totalReviews;

  RecommendedModel({
    required this.houseId,
    required this.title,
    required this.description,
    required this.price,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.landlordEmail,
    required this.place,
    required this.averageRating,
    required this.totalReviews,
  });

  factory RecommendedModel.fromJson(
      Map<String, dynamic> json, {
        String place = "Unknown",
      }) {
    return RecommendedModel(
      houseId: json["house_id"] ?? "",
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      price: _parsePrice(json["price"]),
      latitude: (json["latitude"] as num?)?.toDouble() ?? 0.0,
      longitude: (json["longitude"] as num?)?.toDouble() ?? 0.0,
      imageUrl: json["image_url"] ?? "",
      landlordEmail: json["landlord_email"] ?? "",
      place: place,
      averageRating:
      double.tryParse(json["average_rating"]?.toString() ?? "0") ?? 0.0,
      totalReviews:
      int.tryParse(json["total_reviews"]?.toString() ?? "0") ?? 0,
    );
  }

  static double _parsePrice(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}