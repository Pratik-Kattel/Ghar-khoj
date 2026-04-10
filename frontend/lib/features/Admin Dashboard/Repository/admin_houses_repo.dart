import 'package:dio/dio.dart';
import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/services/api_clients.dart';
import '../Model/admin_house_model.dart';

class AdminHousesRepo {
  final ApiClient apiClient;
  AdminHousesRepo({required this.apiClient});

  Future<List<AdminHouseModel>> getAllHouses() async {
    try {
      final res = await apiClient.get(ApiEndpoints.adminAllHouses);
      final List houses = res['houses'];
      return houses.map((h) => AdminHouseModel.fromJson(h)).toList();
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Failed to fetch houses');
    }
  }

  Future<void> deleteHouse(String houseId) async {
    try {
      await apiClient.delete('${ApiEndpoints.adminDeleteHouse}/$houseId');
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Failed to delete house');
    }
  }
}