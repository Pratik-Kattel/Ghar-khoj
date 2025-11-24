import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;
  final bool isSubmitting;
  final bool isSuccess;
  final String? generalError;

  const LoginState({
    this.email = "",
    this.password = "",
    this.emailError,
    this.passwordError,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.generalError,
  });

  LoginState copyWith({
    String? email,
    String? password,
    String? emailError,
    String? passwordError,
    bool? isSubmitting,
    bool? isSuccess,
    String? generalError,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: emailError,
      passwordError: passwordError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      generalError: generalError,
    );
  }

  @override
  List<Object?> get props => [email, password, emailError, passwordError, isSubmitting, isSuccess, generalError];
}
