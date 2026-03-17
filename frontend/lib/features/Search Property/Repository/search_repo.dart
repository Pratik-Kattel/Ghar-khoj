import 'package:flutter/foundation.dart';
import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/services/api_clients.dart';
import '../model/search_model.dart';

class SearchRepo {
  final ApiClient apiClient;

  SearchRepo({required this.apiClient});

  Future<List<SearchModel>> searchHouses({
    required String query,
    String sortBy = "none",
  }) async {
    final res = await apiClient.get(
      "${ApiEndpoints.searchHouses}?query=$query&sortBy=$sortBy",
    );

    if (kDebugMode) print("Search RAW: $res");

    List rawList = [];
    if (res is Map && res["houses"] != null) {
      rawList = res["houses"] as List;
    } else {
      return [];
    }

    return rawList
        .whereType<Map<String, dynamic>>()
        .map((e) => SearchModel.fromJson(e))
        .toList();
  }
}