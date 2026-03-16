class NearbyHouseModel {

  final String houseId;
  final String title;
  final String imageUrl;
  final String place;
  final int price;

  NearbyHouseModel({
    required this.houseId,
    required this.title,
    required this.imageUrl,
    required this.place,
    required this.price,
  });

  factory NearbyHouseModel.fromJson(Map<String,dynamic> json){
    return NearbyHouseModel(
      houseId: json["house_id"],
      title: json["title"],
      imageUrl: json["image_url"],
      place: json["place"],
      price: json["price"],
    );
  }
}