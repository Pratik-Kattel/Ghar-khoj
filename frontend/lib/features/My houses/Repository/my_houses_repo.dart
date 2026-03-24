import 'package:flutter/foundation.dart';
import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/services/api_clients.dart';
import 'package:frontend/services/get_user_data.dart';
import '../../../services/location_service.dart';
import '../Model/my_houses_model.dart';

class MyHousesRepo {
  final ApiClient apiClient;

  MyHousesRepo({required this.apiClient});

  Future<List<MyHouseModel>> getMyHouses() async {
    final email = await GetUserDataRepo.getUserEmail();
    if (email == null) throw Exception("User not logged in");

    final res = await apiClient.get("${ApiEndpoints.myHouses}/$email");
    final List raw = res["houses"] ?? [];
    List<MyHouseModel> parsed = [];
    for (var e in raw) {
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
          parsed.add(MyHouseModel.fromJson(e, place: place));
        }
      } catch (err) {
        if (kDebugMode) {
          print("Error parsing house: $err");
        }
      }
    }
    return parsed;
  }

  Future<void> updateHouse(
    String houseId,
    String title,
    String description,
    double price,
  ) async {
    await apiClient.post(ApiEndpoints.updateHouse, {
      "houseId": houseId,
      "title": title,
      "description": description,
      "price": price,
    });
  }

  Future<void> deleteHouse(String houseId) async {
    await apiClient.delete("${ApiEndpoints.deleteHouse}/$houseId");
  }
}
