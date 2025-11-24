import 'package:frontend/features/auth/models/user_data_model.dart';

class User{
  final UserData userData;
  final String token;
  
  User({required this.userData,required this.token});
  
  factory User.fromJson(Map<String,dynamic> json){
    return User(userData:UserData.fromJson(json['userData']??{}) , token:
    json['token'] ?? ""
    );
  }

  Map<String,dynamic> toJson()=>{
    "userData":userData.toJson(),
    "token":token
  };
}