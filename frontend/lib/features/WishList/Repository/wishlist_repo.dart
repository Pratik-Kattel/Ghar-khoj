import 'package:flutter/foundation.dart';
import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/services/api_clients.dart';
import 'package:frontend/services/location_service.dart';
import 'package:frontend/services/get_user_data.dart';
import '../Model/wishlist_model.dart';

class WishlistRepo {
  final ApiClient apiClient;

  WishlistRepo({required this.apiClient});

  Future<Map<String, dynamic>> addToWishlist(String houseId) async {
    final email = await GetUserDataRepo.getUserEmail();
    if (email == null) throw Exception("User not logged in");

    final res = await apiClient.post(ApiEndpoints.addWishlist, {
      "email": email,
      "house_id": houseId,
    });

    return {
      "message": res["message"] ?? "",
      "wishlisted": res["wishlisted"] ?? false,
    };
  }

  Future<List<WishlistModel>> getWishlist() async {
    final email = await GetUserDataRepo.getUserEmail();
    if (email == null) throw Exception("User not logged in");

    final res = await apiClient.get("${ApiEndpoints.getWishlist}/$email");
    if (kDebugMode) print("Wishlist RAW RESPONSE: $res");

    List rawList = [];
    if (res is Map && res["wishlist"] != null) {
      rawList = res["wishlist"] as List;
    } else {
      return [];
    }

    List<WishlistModel> parsed = [];
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
          parsed.add(WishlistModel.fromJson(e, place: place));
        }
      } catch (err) {
        if (kDebugMode) print("Error parsing wishlist item: $err");
      }
    }

    if (kDebugMode) print("Parsed ${parsed.length} wishlist items");
    return parsed;
  }

  // ADD THIS
  Future<bool> checkWishlistStatus(String houseId) async {
    final email = await GetUserDataRepo.getUserEmail();
    if (email == null) return false;

    final res = await apiClient.get(
      "${ApiEndpoints.checkWishlist}/$email/$houseId",
    );
    return res["wishlisted"] ?? false;
  }
}