
import 'package:equatable/equatable.dart';
class SignupState extends Equatable {

  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String? nameError;
  final String? emailError;
  final String? passwordError;
  final String? confirmError;
  final bool isSubmitting;
  final bool isSuccess;
  final String? generalError;

  const SignupState({
    this.email = "",
    this.name = "",
    this.password = "",
    this.confirmPassword = "",
    this.nameError,
    this.emailError,
    this.passwordError,
    this.confirmError,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.generalError


  });

  SignupState CopyWith({
    final String? name,
    final String?email,
    final String? password,
    final String? confirmPassword,
    final String? nameError,
    final String? emailError,
    final String? passwordError,
    final String? confirmError,
    final bool? isSubmitting,
    final bool? isSuccess,
    final String? generalError,
}){
    return SignupState(
      name: name??this.name,
      email: email??this.email,
      password: password??this.password,
      confirmPassword: confirmPassword?? this.confirmPassword,
      nameError: nameError ,
      passwordError: passwordError ,
      emailError: emailError ,
      confirmError: confirmError ,
      isSubmitting: isSubmitting??this.isSubmitting,
      isSuccess: isSuccess??this.isSuccess,
      generalError: generalError
    );
  }

  @override
  List<Object?> get props =>[name,email,password,confirmPassword,nameError,passwordError,emailError,confirmError,isSubmitting,isSuccess,generalError];

}
