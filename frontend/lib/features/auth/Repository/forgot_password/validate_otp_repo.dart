import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/features/auth/models/forgot_password/validate_otp_model.dart';
import 'package:frontend/services/api_clients.dart';

class ValidateOtpRepo {
  
  ApiClient apiClient;
  
  ValidateOtpRepo({required this.apiClient});
  
  Future<ValidateOtpModel> validateOTP(String email,int otp) async{
    final res=await apiClient.post(ApiEndpoints.validateOTP, {
      "email":email,
      "otp":otp
    });
    return ValidateOtpModel.fromJson(res);
  }
}