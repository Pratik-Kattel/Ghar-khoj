import 'dart:io';
import 'package:dio/dio.dart';
import '../../../constants/api_endpoints.dart';
import '../../../services/api_clients.dart';
import '../../../services/get_user_data.dart';
import '../Model/add_house_model.dart';

class HouseRepository {
  final ApiClient apiClient;

  HouseRepository({required this.apiClient});

  Future<HouseUploadResponse> uploadHouse({
    required String title,
    required String email,
    required String description,
    required double price,
    required double latitude,
    required double longitude,
    required File imageFile,
  }) async {
    try {
      // Get logged-in user's email
      final landlordEmail = await GetUserDataRepo.getUserEmail();
      if (landlordEmail == null) {
        throw Exception("User email not found. Please login again.");
      }

      // Prepare multipart form
      final formData = FormData.fromMap({
        "title": title,
        "description": description,
        "price": price,
        "latitude": latitude,
        "longitude": longitude,
        "landlord_email": landlordEmail,
        "image": await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      // Post request
      final res = await apiClient.post(ApiEndpoints.uploadHouse, formData);

      return HouseUploadResponse.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }
}