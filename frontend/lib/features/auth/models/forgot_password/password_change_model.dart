class PasswordChangeModel {
  final String message;

  PasswordChangeModel({required this.message});

  factory PasswordChangeModel.fromJson(Map<String,dynamic> json){
    return PasswordChangeModel(
      message:json['message']
    );
  }
}