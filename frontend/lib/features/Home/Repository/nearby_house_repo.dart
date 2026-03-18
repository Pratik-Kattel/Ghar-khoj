import 'package:flutter/foundation.dart';
import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/services/api_clients.dart';
import 'package:frontend/services/location_service.dart';
import '../Model/nearby_house_model.dart';

class NearbyHouseRepo {
  ApiClient apiClient;

  NearbyHouseRepo({required this.apiClient});

  Future<List<NearbyHouseModel>> fetchNearbyHouses(double latitude, double longitude) async {
    final res = await apiClient.get(
        "${ApiEndpoints.nearByHouses}/$latitude/$longitude"
    );

    if (kDebugMode) {
      print("RAW RESPONSE: $res");
    }
    if (kDebugMode) {
      print("RAW RESPONSE TYPE: ${res.runtimeType}");
    }

    List housesList = [];

    if (res is List) {
      housesList = res;
    } else if (res is Map && res["houses"] != null) {
      var housesRaw = res["houses"];
      if (housesRaw is List) {
        housesList = housesRaw;
      } else if (housesRaw is Map) {
        housesList = housesRaw.values.toList();
      }
    } else if (res is Map && res["data"] != null) {
      var housesRaw = res["data"];
      if (housesRaw is List) {
        housesList = housesRaw;
      }
    } else {
      if (kDebugMode) {
        print("Unexpected response format: ${res.runtimeType} => $res");
      }
      return [];
    }

    if (housesList.isEmpty) {
      if (kDebugMode) {
        print("No houses found nearby");
      }
      return [];
    }

    List<NearbyHouseModel> parsed = [];
    for (var e in housesList) {
      try {
        if (e is Map<String, dynamic>) {
          // Reverse-geocode lat/long to place name
          String place = "Unknown";
          try {
            final lat = (e["latitude"] as num).toDouble();
            final lng = (e["longitude"] as num).toDouble();
            place = await PlaceName.getPlace(lng, lat) ?? "Unknown";
            if (kDebugMode) {
              print("Resolved place: $place for lat=$lat, lng=$lng");
            }
          } catch (geoError) {
            if (kDebugMode) {
              print("Geocoding failed: $geoError");
            }
          }

          parsed.add(NearbyHouseModel.fromJson(e, place: place));
        } else {
          if (kDebugMode) {
            print("Skipping invalid item: $e (${e.runtimeType})");
          }
        }
      } catch (err) {
        if (kDebugMode) {
          print("Error parsing house: $err | data: $e");
        }
      }
    }

    if (kDebugMode) {
      print("Parsed ${parsed.length} nearby houses");
    }
    return parsed;
  }
}