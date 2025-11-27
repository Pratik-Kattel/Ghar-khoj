import './user_model.dart';

class SignupResponseModel {
  String message;
  UserModel userModel;

  SignupResponseModel({required this.message, required this.userModel});

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
      message: json['message'] ?? "",

      userModel: UserModel.fromJson(json['user'] ?? {}),
    );
  }
}
