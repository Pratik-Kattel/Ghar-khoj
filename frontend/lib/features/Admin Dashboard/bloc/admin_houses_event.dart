abstract class AdminHousesEvent {}

class FetchAdminHousesEvent extends AdminHousesEvent {}

class DeleteAdminHouseEvent extends AdminHousesEvent {
  final String houseId;
  DeleteAdminHouseEvent({required this.houseId});
}