class UserData{
  final String email;
  final String role;
  UserData({required this.email,required this.role});

  factory UserData.fromJson(Map<String,dynamic> json){
    return UserData(email: json['email'] ?? ""
        , role:json['role']?? ""
    );
  }

  Map<String,dynamic> toJson()=>{
    "email":email,
    "role":role
  };
}




