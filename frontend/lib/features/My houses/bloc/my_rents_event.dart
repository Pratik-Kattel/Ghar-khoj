abstract class RentsEvent {}

class AddToRents extends RentsEvent {
  final String houseId;
  AddToRents({required this.houseId});
}

class FetchRents extends RentsEvent {}