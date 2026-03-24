abstract class MyHousesEvent {}

class FetchMyHouses extends MyHousesEvent {}

class UpdateHouse extends MyHousesEvent {
  final String houseId;
  final String title;
  final String description;
  final double price;
  UpdateHouse({
    required this.houseId,
    required this.title,
    required this.description,
    required this.price,
  });
}

class DeleteHouse extends MyHousesEvent {
  final String houseId;
  DeleteHouse({required this.houseId});
}