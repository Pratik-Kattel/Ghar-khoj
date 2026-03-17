import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/Recommendation/bloc/recommendation_event.dart';
import 'package:frontend/features/Recommendation/bloc/recommendation_state.dart';
import '../Repository/recommendation_repo.dart';


class RecommendedBloc extends Bloc<RecommendedEvent, RecommendedState> {
  final RecommendedRepo repo;

  RecommendedBloc({required this.repo}) : super(RecommendedState()) {
    on<FetchRecommendedHouses>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null));
      try {
        final houses = await repo.fetchRecommendedHouses();
        emit(state.copyWith(isLoading: false, houses: houses));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });
  }
}