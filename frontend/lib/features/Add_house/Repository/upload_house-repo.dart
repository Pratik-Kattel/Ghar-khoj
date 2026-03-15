import 'dart:io';
import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/services/api_clients.dart';
import 'package:dio/dio.dart';

import '../Model/add_house_model.dart';

class HouseRepository {
  final ApiClient apiClient;

  HouseRepository({required this.apiClient});

  Future<HouseUploadResponse> uploadHouse({
    required String title,
    required String description,
    required double price,
    required double latitude,
    required double longitude,
    required File imageFile,
  }) async {
    try {
      String fileName = imageFile.path.split('/').last;

      FormData formData = FormData.fromMap({
        'title': title,
        'description': description,
        'price': price,
        'latitude': latitude,
        'longitude': longitude,
        'image': await MultipartFile.fromFile(imageFile.path, filename: fileName),
      });

      final res = await apiClient.post(
        ApiEndpoints.upladHouse,
        formData.fields.fold<Map<String, dynamic>>({}, (map, field) {
          map[field.key] = field.value;
          return map;
        }),
      );

      return HouseUploadResponse.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }
}