abstract class SearchEvent {}

class SearchHouses extends SearchEvent {
  final String query;
  final String sortBy;
  SearchHouses({required this.query, this.sortBy = "none"});
}

class ClearSearch extends SearchEvent {}