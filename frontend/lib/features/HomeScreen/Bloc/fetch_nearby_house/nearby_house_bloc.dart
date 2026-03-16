import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Repository/nearby_house_repo.dart';
import 'nearby_house_event.dart';
import 'nearby_house_state.dart';

class NearbyHouseBloc extends Bloc<NearbyHouseEvent, NearbyHouseState> {
  final NearbyHouseRepo repo;

  NearbyHouseBloc({required this.repo}) : super(NearbyHouseState()) {
    on<FetchNearbyHouses>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final houses = await repo.fetchNearbyHouses(event.latitude, event.longitude);
        emit(state.copyWith(isLoading: false, houses: houses));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });
  }
}