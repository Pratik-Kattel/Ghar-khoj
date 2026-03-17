import 'package:flutter/foundation.dart';
import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/services/api_clients.dart';
import 'package:frontend/services/location_service.dart';
import '../Model/recommendation_model.dart';


class RecommendedRepo {
  final ApiClient apiClient;

  RecommendedRepo({required this.apiClient});

  Future<List<RecommendedModel>> fetchRecommendedHouses() async {
    final res = await apiClient.get(ApiEndpoints.recommendedHouses);
    print("Recommended RAW RESPONSE: $res");

    List rawList = [];
    if (res is Map && res["houses"] != null) {
      rawList = res["houses"] as List;
    } else {
      return [];
    }

    List<RecommendedModel> parsed = [];
    for (var e in rawList) {
      try {
        if (e is Map<String, dynamic>) {
          String place = "Unknown";
          try {
            final lat = (e["latitude"] as num).toDouble();
            final lng = (e["longitude"] as num).toDouble();
            place = await PlaceName.getPlace(lng, lat) ?? "Unknown";
          } catch (geoError) {
            print("Geocoding failed: $geoError");
          }
          parsed.add(RecommendedModel.fromJson(e, place: place));
        }
      } catch (err) {
        if (kDebugMode) {
          print("Error parsing recommended house: $err");
        }
      }
    }

    if (kDebugMode) {
      print("Parsed ${parsed.length} recommended houses");
    }
    return parsed;
  }
}