import 'package:flutter/foundation.dart';
import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/services/api_clients.dart';
import 'package:frontend/services/secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';

class GetUserDataModel {
  final String message;
  final String name;

  GetUserDataModel({required this.message, required this.name});

  factory GetUserDataModel.fromJson(Map<String, dynamic> json) {
    return GetUserDataModel(message: json['message'], name: json['name']);
  }
}

class GetUserDataRepo {
  final ApiClient apiClient;

  GetUserDataRepo(this.apiClient);

  static Future<String?> getUserEmail() async {
    final token = await SecureStorage.getToken();
    if (token == null) {
      return null;
    }
    Map<String, dynamic> jwtPayload = Jwt.parseJwt(token);

    final String ?userEmail = jwtPayload['email'] as String?;
    if (kDebugMode) {
      print(jwtPayload['email']);
    }
    return userEmail;
  }

  static Future<String?> getUserRole() async {
    final token = await SecureStorage.getToken();
    if (token == null) return null;
    Map<String, dynamic> jwtPayload = Jwt.parseJwt(token);
    if (kDebugMode) print("Role: ${jwtPayload['role']}");
    print("FULL JWT PAYLOAD: $jwtPayload");
    return jwtPayload['role'] as String?;
  }

   Future<GetUserDataModel> getUserData(String? userEmail) async {
    final res = await apiClient.post(ApiEndpoints.getUserName, {
      "email": userEmail,
    });
    return GetUserDataModel.fromJson(res);
  }
}

class GetUserName {
  GetUserDataRepo getUserDataRepo;

  GetUserName({required this.getUserDataRepo});

   Future<String?> getuserName() async {
    final email = await GetUserDataRepo.getUserEmail();
    if (email == null) {
      return "Guest";
    }
    final name = await getUserDataRepo.getUserData(email);
    return name.name;
  }
}
