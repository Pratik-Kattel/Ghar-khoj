import 'package:flutter_bloc/flutter_bloc.dart';
import '../Repository/my_houses_repo.dart';
import 'my_houses_event.dart';
import 'my_houses_state.dart';

class MyHousesBloc extends Bloc<MyHousesEvent, MyHousesState> {
  final MyHousesRepo repo;

  MyHousesBloc({required this.repo}) : super(const MyHousesState()) {
    on<FetchMyHouses>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null, message: null));
      try {
        final houses = await repo.getMyHouses();
        emit(state.copyWith(isLoading: false, houses: houses));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });

    on<UpdateHouse>((event, emit) async {
      emit(state.copyWith(isUpdating: true, error: null, message: null));
      try {
        await repo.updateHouse(event.houseId, event.title, event.description, event.price);
        emit(state.copyWith(isUpdating: false, message: "House updated successfully"));
        add(FetchMyHouses()); // refresh
      } catch (e) {
        emit(state.copyWith(isUpdating: false, error: e.toString()));
      }
    });

    on<DeleteHouse>((event, emit) async {
      emit(state.copyWith(isDeleting: true, error: null, message: null));
      try {
        await repo.deleteHouse(event.houseId);
        emit(state.copyWith(isDeleting: false, message: "House deleted successfully"));
        add(FetchMyHouses()); // refresh
      } catch (e) {
        emit(state.copyWith(isDeleting: false, error: e.toString()));
      }
    });
  }
}