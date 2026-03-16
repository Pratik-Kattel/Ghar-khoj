class WishlistModel {
  final String wishlistId;
  final String houseId;
  final String title;
  final String description;
  final double price;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final String landlordEmail;
  final String place;

  WishlistModel({
    required this.wishlistId,
    required this.houseId,
    required this.title,
    required this.description,
    required this.price,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.landlordEmail,
    required this.place,
  });

  factory WishlistModel.fromJson(
    Map<String, dynamic> json, {
    String place = "Unknown",
  }) {
    return WishlistModel(
      wishlistId: json["wishlist_id"] ?? "",
      houseId: json["house_id"] ?? "",
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      price: _parsePrice(json["price"]),
      latitude: (json["latitude"] as num?)?.toDouble() ?? 0.0,
      longitude: (json["longitude"] as num?)?.toDouble() ?? 0.0,
      imageUrl: json["image_url"] ?? "",
      landlordEmail: json["landlord_email"] ?? "",
      place: place,
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
