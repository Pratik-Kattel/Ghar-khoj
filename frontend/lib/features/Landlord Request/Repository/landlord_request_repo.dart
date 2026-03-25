import 'dart:io';
import 'package:dio/dio.dart';
import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/services/api_clients.dart';
import 'package:frontend/services/secure_storage.dart';
import '../Model/landlord_request_model.dart';

class LandlordRequestRepo {
  final ApiClient apiClient;

  LandlordRequestRepo({required this.apiClient});

  Future<LandlordRequestModel> submitRequest({
    required String email,
    required File citizenshipFile,
  }) async {
    final token = await SecureStorage.getToken();

    final formData = FormData.fromMap({
      'email': email,
      'citizenship': await MultipartFile.fromFile(
        citizenshipFile.path,
        filename: citizenshipFile.path.split('/').last,
      ),
    });

    try {
      final res = await apiClient.post(
        ApiEndpoints.landlordRequest,
        formData,
        headers: {'Authorization': 'Bearer $token'},
      );
      return LandlordRequestModel.fromJson(res);
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Something went wrong. Please try again.');
    }
  }
}