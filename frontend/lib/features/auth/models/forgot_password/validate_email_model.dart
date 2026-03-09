class ValidateEmailModel {
  final String message;

  ValidateEmailModel({required this.message});

  factory ValidateEmailModel.fromJson(Map<String,dynamic> json){
    return ValidateEmailModel(message: json['message']);
  }
}