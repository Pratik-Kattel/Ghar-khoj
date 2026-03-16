import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/services/api_clients.dart';

import '../Model/nearby_house_model.dart';

class NearbyHouseRepo {

  ApiClient apiClient;

  NearbyHouseRepo({required this.apiClient});

  Future<List<NearbyHouseModel>> fetchNearbyHouses(
      double latitude,
      double longitude
      ) async {

    final res = await apiClient.get(
        "${ApiEndpoints.nearByHouses}?latitude=$latitude&longitude=$longitude"
    );

    List houses = res["houses"];

    return houses
        .map((e) => NearbyHouseModel.fromJson(e))
        .toList();
  }
}