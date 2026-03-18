import 'package:flutter/foundation.dart';
import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/services/api_clients.dart';
import 'package:frontend/services/location_service.dart';
import 'package:frontend/services/get_user_data.dart';
import '../Model/rents_model.dart';

class RentsRepo {
  final ApiClient apiClient;

  RentsRepo({required this.apiClient});

  Future<Map<String, dynamic>> addToRents(String houseId) async {
    final email = await GetUserDataRepo.getUserEmail();
    if (email == null) throw Exception("User not logged in");

    final res = await apiClient.post(ApiEndpoints.addRent, {
      "userEmail": email,
      "houseId": houseId,
    });

    return {
      "message": res["message"] ?? "",
      "alreadyRented": res["alreadyRented"] ?? false,
    };
  }

  Future<List<RentsModel>> getRents() async {
    final email = await GetUserDataRepo.getUserEmail();
    if (email == null) throw Exception("User not logged in");

    final res = await apiClient.get("${ApiEndpoints.getRents}/$email");
    if (kDebugMode) print("Rents RAW RESPONSE: $res");

    List rawList = [];
    if (res is Map && res["rents"] != null) {
      rawList = res["rents"] as List;
    } else {
      return [];
    }

    List<RentsModel> parsed = [];
    for (var e in rawList) {
      try {
        if (e is Map<String, dynamic>) {
          String place = "Unknown";
          try {
            final lat = (e["latitude"] as num).toDouble();
            final lng = (e["longitude"] as num).toDouble();
            place = await PlaceName.getPlace(lng, lat) ?? "Unknown";
          } catch (geoError) {
            if (kDebugMode) print("Geocoding failed: $geoError");
          }
          parsed.add(RentsModel.fromJson(e, place: place));
        }
      } catch (err) {
        if (kDebugMode) print("Error parsing rent: $err");
      }
    }

    if (kDebugMode) print("Parsed ${parsed.length} rents");
    return parsed;
  }
}