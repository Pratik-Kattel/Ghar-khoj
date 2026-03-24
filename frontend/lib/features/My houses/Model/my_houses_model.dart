class MyHouseModel {
  final String houseId;
  final String title;
  final String description;
  final double price;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final double averageRating;
  final int totalReviews;
  final String place;

  MyHouseModel({
    required this.houseId,
    required this.title,
    required this.description,
    required this.price,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.averageRating,
    required this.totalReviews,
    required this.place
  });

  factory MyHouseModel.fromJson(Map<String, dynamic> json,{String place="Unknown"}) {
    return MyHouseModel(
      houseId: json["house_id"] ?? "",
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      price: double.tryParse(json["price"]?.toString() ?? "0") ?? 0.0,
      latitude: (json["latitude"] as num?)?.toDouble() ?? 0.0,
      longitude: (json["longitude"] as num?)?.toDouble() ?? 0.0,
      imageUrl: json["image_url"] ?? "",
      averageRating: double.tryParse(json["average_rating"]?.toString() ?? "0") ?? 0.0,
      totalReviews: int.tryParse(json["total_reviews"]?.toString() ?? "0") ?? 0,
      place: place
    );
  }
}