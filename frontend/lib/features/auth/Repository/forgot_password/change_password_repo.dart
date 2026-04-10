import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/features/auth/models/forgot_password/password_change_model.dart';
import 'package:frontend/features/auth/models/signup/Signup_Error_Model.dart';
import 'package:frontend/services/Custom_Exception.dart';
import 'package:frontend/services/api_clients.dart';

class ChangePasswordRepo {
  ApiClient apiClient;

  ChangePasswordRepo({required this.apiClient});

  Future<PasswordChangeModel> changePassword(
    String email,
    String password,
  ) async {
    final res = await apiClient.post(ApiEndpoints.changePassword, {
      "email": email,
      "password": password,
    });
    // if (res.containsKey('errors')) {
    //   throw SignupException(SignupErrorModel.fromJson(res));
    // }
    return PasswordChangeModel.fromJson(res);
  }
}
