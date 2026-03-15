class ChangeUserNameModel {
  final String message;
  ChangeUserNameModel({required this.message});

  factory ChangeUserNameModel.fromJson(Map<String,dynamic> json){
    return ChangeUserNameModel(message:  json['message']);
  }
}