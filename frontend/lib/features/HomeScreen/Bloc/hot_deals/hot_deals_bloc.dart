import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Repository/hotdeals_repo.dart';
import 'hot_deals_event.dart';
import 'hot_deals_state.dart';

class HotDealsBloc extends Bloc<HotDealsEvent, HotDealsState> {
  final HotDealsRepo repo;

  HotDealsBloc({required this.repo}) : super(HotDealsState()) {
    on<FetchHotDeals>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final houses = await repo.fetchHotDeals();
        emit(state.copyWith(isLoading: false, houses: houses));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });
  }
}