import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/Search%20Property/bloc/search_property_event.dart';
import 'package:frontend/features/Search%20Property/bloc/search_property_state.dart';
import '../Repository/search_repo.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepo repo;

  SearchBloc({required this.repo}) : super(SearchState()) {
    on<SearchHouses>((event, emit) async {
      emit(state.copyWith(
        isLoading: true,
        error: null,
        sortBy: event.sortBy,
      ));
      try {
        final results = await repo.searchHouses(
          query: event.query,
          sortBy: event.sortBy,
        );
        emit(state.copyWith(isLoading: false, results: results));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });

    on<ClearSearch>((event, emit) {
      emit(SearchState());
    });
  }
}