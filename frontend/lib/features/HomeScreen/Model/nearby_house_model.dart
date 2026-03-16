class NearbyHouseModel {
  final String houseId;
  final String title;
  final String imageUrl;
  final String place;
  final double price;

  NearbyHouseModel({
    required this.houseId,
    required this.title,
    required this.imageUrl,
    required this.place,
    required this.price,
  });

  // place is passed in from repo after reverse geocoding
  factory NearbyHouseModel.fromJson(Map<String, dynamic> json, {String place = "Unknown"}) {
    return NearbyHouseModel(
      houseId: json["house_id"] ?? "",
      title: json["title"] ?? "",
      imageUrl: json["image_url"] ?? "",
      place: place,
      price: _parsePrice(json["price"]),
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