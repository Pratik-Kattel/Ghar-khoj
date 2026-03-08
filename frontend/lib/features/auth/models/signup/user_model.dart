class UserModel {
  String name;
  String email;
  String role;
  String? profilePic;

  UserModel({
    required this.name,
    required this.email,
    required this.role,
    required this.profilePic,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      role: json['role'],
      profilePic: json['profile_pic'],
    );
  }
}
