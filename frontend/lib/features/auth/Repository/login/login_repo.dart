import 'package:frontend/services/api_clients.dart';
import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/services/secure_storage.dart';
import '../../models/login/login_response_model.dart';

class LoginRepository {
  final ApiClient apiClient;

  LoginRepository({required this.apiClient});

  Future<LoginResponse> login(String email, String password) async {
    final res = await apiClient.post(ApiEndpoints.login, {
      "email": email,
      "password": password,
    });
    await SecureStorage.saveToken(res['token']);
    return LoginResponse.fromJson(res);
  }
}
