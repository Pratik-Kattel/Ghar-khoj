class NearbyHouseModel {
  final String houseId;
  final String title;
  final String imageUrl;
  final String place;
  final double price;
  final double latitude;
  final double longitude;
  final String description;

  NearbyHouseModel({
    required this.houseId,
    required this.title,
    required this.imageUrl,
    required this.place,
    required this.price,
    required this.latitude,
    required this.longitude,
    required this.description,
  });

  factory NearbyHouseModel.fromJson(Map<String, dynamic> json, {String place = "Unknown"}) {
    return NearbyHouseModel(
      houseId: json["house_id"] ?? "",
      title: json["title"] ?? "",
      imageUrl: json["image_url"] ?? "",
      place: place,
      price: _parsePrice(json["price"]),
      latitude: (json["latitude"] as num?)?.toDouble() ?? 0.0,
      longitude: (json["longitude"] as num?)?.toDouble() ?? 0.0,
      description: json["description"] ?? "No description available",
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