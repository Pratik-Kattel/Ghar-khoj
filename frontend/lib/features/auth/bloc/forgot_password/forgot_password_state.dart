import 'package:equatable/equatable.dart';

class ForgotPasswordState extends Equatable {
  final String email;
  final String? emailError;
  final bool isSubmitting;
  final bool isSuccess;
  final String? generalError;

  const ForgotPasswordState({
    this.email = " ",
    this.emailError,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.generalError,
  });

  ForgotPasswordState copyWith({
    String? email,
    String? emailError,
    bool? isSubmitting,
    bool? isSuccess,
    String? generalError,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      emailError: emailError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      generalError: generalError,
    );
  }

  @override
  List<Object?> get props => [
    email,
    emailError,
    isSubmitting,
    isSuccess,
    generalError,
  ];
}
