import 'package:equatable/equatable.dart';

class ProfilePageState extends Equatable{
  final String name;
  final String? nameError;
  final String? generalError;
  final bool isSubmitting;
  final bool isSuccess;
  final String email;
  const ProfilePageState({
    this.name=" ",
    this.email=" ",
    this.generalError,
    this.nameError,
    this.isSubmitting=false,
    this.isSuccess=false
});
  ProfilePageState copyWith({
    String? name,
    String ? email,
    String?nameError,
    bool? isSubmitting,
    bool? isSuccess,
    String? generalError,

}){
    return ProfilePageState(
      name: name??this.name,
      nameError: nameError ?? this.nameError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      email: email ?? this.email,
      generalError: generalError?? this.generalError
    );
  }

  @override
  List<Object?> get props => [name,nameError,isSubmitting,isSuccess,email,generalError];
}