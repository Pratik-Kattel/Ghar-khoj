import 'package:equatable/equatable.dart';
import 'package:frontend/features/auth/models/forgot_password/validate_otp_model.dart';

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

class OTPValidationState extends Equatable {
  final String otp;
  final String? otpError;
  final String email;
  final bool isSubmitting;
  final bool isSuccess;
  final String? generalError;

  const OTPValidationState({
    this.otp = "",
    this.email="",
    this.otpError,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.generalError,
  });

  OTPValidationState copyWith({
    final String? otp,
    final String?email,
    final String? otpError,
    final bool? isSubmitting,
    final bool? isSuccess,
    final String? generalError,
  }) {
    return OTPValidationState(
      otp: otp ?? this.otp,
      email: email ?? this.email,
      otpError: otpError ,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      generalError: generalError
    );
  }

  @override
  List<Object?> get props => [
    otp,
    email,
    otpError,
    isSubmitting,
    isSuccess,
    generalError,
  ];
}
