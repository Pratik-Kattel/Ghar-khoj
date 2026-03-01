
import '../../models/login/user_model.dart';

class LoginResponse {
  String message;
  User? user;

  LoginResponse({required this.message, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json["message"],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }
}
