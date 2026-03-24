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
        final now = DateTime.now();
        final activeRents = rents.where((rent) {
          if (rent.end_date.isEmpty) return true;
          try {
            final endDate = DateTime.parse(rent.end_date);
            return endDate.isAfter(now);
          } catch (_) {
            return true;
          }
        }).toList();

        emit(state.copyWith(isLoading: false, rents: activeRents));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });
    on<ResetBookingStatus>((event, emit) {
      emit(state.copyWith(
        isBooked: false,
        clearBookedDates: true,
      ));
    });
    on<CheckBookingStatus>((event, emit) async {
      try {
        final result = await repo.getBookingStatus(event.houseId);
        if (result != null && result['startDate'] != null) {
          emit(state.copyWith(
            isBooked: true,
            bookedStartDate: result['startDate'],
            bookedEndDate: result['endDate'],
          ));
        } else {
          emit(state.copyWith(isBooked: false));
        }
      } catch (e) {
        emit(state.copyWith(isBooked: false));
      }
    });
  }
}
