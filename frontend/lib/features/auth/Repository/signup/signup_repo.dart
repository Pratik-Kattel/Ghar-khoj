import 'package:frontend/features/auth/models/signup/Signup_Error_Model.dart';
import 'package:frontend/services/Custom_Exception.dart';

import '../../../../services/api_clients.dart';
import '../../../../constants/api_endpoints.dart';
import '../../models/signup/signup_response_model.dart';

class SignupRepository {
  ApiClient apiClient;

  SignupRepository({required this.apiClient});

  Future<SignupResponseModel> register(
    String email,
    String name,
    String password,
  ) async {
    final res = await apiClient.post(ApiEndpoints.register, {
      "email": email,
      "name": name,
      "password": password,
    });
    if (res.containsKey('errors')) {
      throw SignupException(SignupErrorModel.fromJson(res));
    }
    return SignupResponseModel.fromJson(res);
  }
}
