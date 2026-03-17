import 'package:equatable/equatable.dart';
import '../model/search_model.dart';

class SearchState extends Equatable {
  final bool isLoading;
  final List<SearchModel> results;
  final String? error;
  final String sortBy;

  SearchState({
    this.isLoading = false,
    this.results = const [],
    this.error,
    this.sortBy = "none",
  });

  SearchState copyWith({
    bool? isLoading,
    List<SearchModel>? results,
    String? error,
    String? sortBy,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      results: results ?? this.results,
      error: error,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  @override
  List<Object?> get props => [isLoading, results, error, sortBy];
}