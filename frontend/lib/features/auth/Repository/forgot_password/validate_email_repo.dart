import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/features/auth/models/forgot_password/validate_email_model.dart';
import 'package:frontend/services/api_clients.dart';

class ValidateEmailRepository {
  ApiClient apiClient;

  ValidateEmailRepository({required this.apiClient});

  Future<ValidateEmailModel> validateEmail(String email) async {
    final res = await apiClient.post(ApiEndpoints.validateEmail, {
      "email": email,
    });
    return ValidateEmailModel.fromJson(res);
  }
}
