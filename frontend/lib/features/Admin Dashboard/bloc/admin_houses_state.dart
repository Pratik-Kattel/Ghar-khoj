import '../Model/admin_house_model.dart';

abstract class AdminHousesState {}

class AdminHousesInitial extends AdminHousesState {}
class AdminHousesLoading extends AdminHousesState {}
class AdminHousesLoaded extends AdminHousesState {
  final List<AdminHouseModel> houses;
  AdminHousesLoaded({required this.houses});
}
class AdminHouseDeleted extends AdminHousesState {
  final List<AdminHouseModel> houses;
  AdminHouseDeleted({required this.houses});
}
class AdminHousesError extends AdminHousesState {
  final String message;
  AdminHousesError({required this.message});
}