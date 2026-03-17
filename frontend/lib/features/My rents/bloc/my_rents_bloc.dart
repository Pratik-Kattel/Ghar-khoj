import 'package:flutter_bloc/flutter_bloc.dart';
import '../Repository/rents_repo.dart';
import 'my_rents_event.dart';
import 'my_rents_state.dart';


class RentsBloc extends Bloc<RentsEvent, RentsState> {
  final RentsRepo repo;

  RentsBloc({required this.repo}) : super(RentsState()) {
    on<AddToRents>((event, emit) async {
      emit(state.copyWith(isAdding: true, error: null, message: null));
      try {
        final result = await repo.addToRents(event.houseId);
        emit(state.copyWith(
          isAdding: false,
          message: result["message"],
        ));
      } catch (e) {
        emit(state.copyWith(isAdding: false, error: e.toString()));
      }
    });

    on<FetchRents>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null, message: null));
      try {
        final rents = await repo.getRents();
        emit(state.copyWith(isLoading: false, rents: rents));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });
  }
}