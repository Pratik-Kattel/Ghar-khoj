class ValidateOtpModel {
  final String? message;

  ValidateOtpModel(this.message);

  factory ValidateOtpModel.fromJson(Map<String,dynamic> json){
    return ValidateOtpModel(json['message']);
  }
}