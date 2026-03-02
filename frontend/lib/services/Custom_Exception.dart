import '../features/auth/models/signup/Signup_Error_Model.dart';
class SignupException implements Exception{
  final SignupErrorModel errorModel;

  SignupException(this.errorModel);

}