import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/Repository/forgot_password/validate_email_repo.dart';
import 'package:frontend/features/auth/Repository/forgot_password/validate_otp_repo.dart';
import 'package:frontend/features/auth/bloc/forgot_password/forgot_password_event.dart';
import 'package:frontend/features/auth/bloc/forgot_password/forgot_password_state.dart';
import 'package:frontend/features/auth/screens/forgot_password/validate_otp_screen.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ValidateEmailRepository validateEmailRepository;

  ForgotPasswordBloc({required this.validateEmailRepository})
    : super(const ForgotPasswordState()) {
    on<EmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email, emailError: null));
    });
    on<EmailSubmitted>((event, emit) async {
      emit(
        state.copyWith(
          isSubmitting: true,
          emailError: null,
          generalError: null,
        ),
      );
      try {
        final res = await validateEmailRepository.validateEmail(state.email);
        if (res.message != null) {
          emit(state.copyWith(isSubmitting: false, isSuccess: true));
          emit(state.copyWith(isSuccess: false));
        } else {
          emit(state.copyWith(isSubmitting: false, isSuccess: false));
        }
      } on DioException catch (e) {
        print(e.message);
        emit(state.copyWith(isSubmitting: false, generalError: e.message));
      }
    });
  }
}

class OTPValidationBloc extends Bloc<OTPValidationEvent, OTPValidationState> {
  ValidateOtpRepo validateOtpRepo;

  OTPValidationBloc({required this.validateOtpRepo})
    : super(const OTPValidationState()) {
    on<OTPChangedEvent>((event, emit) {
      emit(state.copyWith(otp: event.OTP, otpError: null));
    });

    on<EmailChangedEvent>((event, emit) {
      emit(state.copyWith(email: event.email));
    });
    on<OTPSubmittedEvent>((event, emit) async {
      emit(
        state.copyWith(isSubmitting: true, generalError: null, otpError: null),
      );
      try {
        final res = await validateOtpRepo.validateOTP(state.email, state.otp);
        if (res.message != null) {
          emit(state.copyWith(isSubmitting: false, isSuccess: true));
          emit(state.copyWith(isSuccess: false));
        } else {
          emit(state.copyWith(isSubmitting: false, isSuccess: true));
        }
      } on DioException catch (e) {
        emit(state.copyWith(isSubmitting: false, generalError: e.message));
      }
    });
  }
}
