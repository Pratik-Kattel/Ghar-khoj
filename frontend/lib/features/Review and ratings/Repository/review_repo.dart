import 'package:flutter/foundation.dart';
import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/services/api_clients.dart';
import 'package:frontend/services/get_user_data.dart';
import '../Model/review_model.dart';

class ReviewRepo {
  final ApiClient apiClient;

  ReviewRepo({required this.apiClient});

  Future<void> submitReview(
      String houseId,
      int rating,
      String comment,
      ) async {
    final email = await GetUserDataRepo.getUserEmail();
    if (email == null) throw Exception("User not logged in");

    if (kDebugMode) {
      print("Submitting: houseId=$houseId, email=$email, rating=$rating");
    }

    await apiClient.post(ApiEndpoints.addReview, {
      "houseId": houseId,
      "tenantEmail": email,
      "rating": rating,
      "comment": comment,
    });
  }

  Future<List<ReviewModel>> getReviews(String houseId) async {
    final res = await apiClient.get("${ApiEndpoints.getReviews}/$houseId");
    List raw = [];
    if (res is Map && res['reviews'] != null) {
      raw = res['reviews'] as List;
    }
    return raw
        .whereType<Map<String, dynamic>>()
        .map((e) => ReviewModel.fromJson(e))
        .toList();
  }

  Future<Map<String, dynamic>> getAverageRating(String houseId) async {
    final res =
    await apiClient.get("${ApiEndpoints.getAverageRating}/$houseId");
    if (kDebugMode) print("Average rating raw: $res");
    return {
      "average": double.tryParse(res["average"]?.toString() ?? "0") ?? 0.0,
      "total": int.tryParse(res["total"]?.toString() ?? "0") ?? 0,
    };
  }

  Future<bool> checkReviewStatus(String houseId) async {
    final email = await GetUserDataRepo.getUserEmail();
    if (email == null) return false;

    final res = await apiClient.get(
      "${ApiEndpoints.checkReview}/$houseId/$email",
    );
    return res["hasReviewed"] ?? false;
  }
}