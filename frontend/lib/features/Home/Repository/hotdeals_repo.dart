import 'package:flutter/foundation.dart';
import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/services/api_clients.dart';
import 'package:frontend/services/location_service.dart';
import '../Model/hotdeals_model.dart';

class HotDealsRepo {
  ApiClient apiClient;

  HotDealsRepo({required this.apiClient});

  Future<List<HotDealModel>> fetchHotDeals() async {
    final res = await apiClient.get(ApiEndpoints.hotDeals);

    if (kDebugMode) {
      print("Hot Deals RAW RESPONSE: $res");
    }

    List housesList = [];

    if (res is List) {
      housesList = res;
    } else if (res is Map && res["houses"] != null) {
      var raw = res["houses"];
      if (raw is List) housesList = raw;
    } else {
      if (kDebugMode) {
        print("Unexpected hot deals format: ${res.runtimeType}");
      }
      return [];
    }

    if (housesList.isEmpty) return [];

    List<HotDealModel> parsed = [];
    for (var e in housesList) {
      try {
        if (e is Map<String, dynamic>) {
          String place = "Unknown";
          try {
            final lat = (e["latitude"] as num).toDouble();
            final lng = (e["longitude"] as num).toDouble();
            place = await PlaceName.getPlace(lng, lat) ?? "Unknown";
          } catch (geoError) {
            if (kDebugMode) {
              print("Geocoding failed: $geoError");
            }
          }
          parsed.add(HotDealModel.fromJson(e, place: place));
        }
      } catch (err) {
        if (kDebugMode) {
          print("Error parsing hot deal: $err | data: $e");
        }
      }
    }

    if (kDebugMode) {
      print("Parsed ${parsed.length} hot deals");
    }
    return parsed;
  }
}