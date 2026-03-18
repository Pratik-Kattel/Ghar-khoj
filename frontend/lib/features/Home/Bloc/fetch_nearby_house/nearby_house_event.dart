abstract class NearbyHouseEvent {}

class FetchNearbyHouses extends NearbyHouseEvent {
  final double latitude;
  final double longitude;

  FetchNearbyHouses({required this.latitude, required this.longitude});
}