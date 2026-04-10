import 'package:flutter_bloc/flutter_bloc.dart';
import '../Repository/admin_houses_repo.dart';
import 'admin_houses_event.dart';
import 'admin_houses_state.dart';
import '../Model/admin_house_model.dart';

class AdminHousesBloc extends Bloc<AdminHousesEvent, AdminHousesState> {
  final AdminHousesRepo repo;
  List<AdminHouseModel> _houses = [];

  AdminHousesBloc({required this.repo}) : super(AdminHousesInitial()) {
    on<FetchAdminHousesEvent>(_onFetch);
    on<DeleteAdminHouseEvent>(_onDelete);
  }

  Future<void> _onFetch(
      FetchAdminHousesEvent event,
      Emitter<AdminHousesState> emit,
      ) async {
    emit(AdminHousesLoading());
    try {
      _houses = await repo.getAllHouses();
      emit(AdminHousesLoaded(houses: _houses));
    } on Exception catch (e) {
      emit(AdminHousesError(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onDelete(
      DeleteAdminHouseEvent event,
      Emitter<AdminHousesState> emit,
      ) async {
    try {
      await repo.deleteHouse(event.houseId);
      _houses.removeWhere((h) => h.houseId == event.houseId);
      emit(AdminHouseDeleted(houses: List.from(_houses)));
    } on Exception catch (e) {
      emit(AdminHousesError(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }
}