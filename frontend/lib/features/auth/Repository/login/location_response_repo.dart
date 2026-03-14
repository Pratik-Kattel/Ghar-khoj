import 'dart:ffi';

import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/services/api_clients.dart';

class LocationResponseRepo {
  ApiClient apiClient;
  LocationResponseRepo({required this.apiClient});
  Future<void> sendLocation(double longitude,double latitude,String email) async{
    await apiClient.post(ApiEndpoints.sendLocation, {
      "email":email,
      "longitude":longitude,
      "latitude":latitude
    });

  }
}