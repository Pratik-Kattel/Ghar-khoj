import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/Repository/forgot_password/change_password_repo.dart';
import 'package:frontend/features/auth/Repository/forgot_password/validate_email_repo.dart';
import 'package:frontend/features/auth/Repository/forgot_password/validate_otp_repo.dart';
import 'package:frontend/features/auth/bloc/forgot_password/forgot_password_event.dart';
import 'package:frontend/features/auth/bloc/forgot_password/forgot_password_state.dart';
import 'package:frontend/features/auth/screens/forgot_password/validate_otp_screen.dart';
import '../../../../services/Custom_Exception.dart';
import '../../models/signup/Signup_Error_Model.dart';

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

class PasswordChangeBloc extends Bloc<PasswordChangeEvent,PasswordChangeState>{
ChangePasswordRepo changePasswordRepo;
  PasswordChangeBloc({required this.changePasswordRepo}):super(PasswordChangeState()){
    on<PasswordChangedEvent>((event,emit){
      emit(state.copyWith(password:event.password,passwordError: null));
    });
    on<ConfirmPasswordChangedEvent>((event,emit){
      emit(state.copyWith(confirmPassword: event.confirmPassword,confirmPasswordError: null));
    });
    on<ForgotPasswordEmailChanged>((event,emit){
      emit(state.copyWith(email: event.email));
    });
    on<PasswordSubmittedEvent>((event,emit) async {
      if(state.password!=state.confirmPassword){
        emit(state.copyWith(
          isSubmitting: false,
          confirmPasswordError: "Password didn't match"
        ));
        return;
      }
      emit(state.copyWith(
          isSubmitting: true,
          passwordError: null,
          confirmPasswordError: null,
          generalError: null
      ));
      try{
        final res=await changePasswordRepo.changePassword(state.email, state.password);
        if(kDebugMode){
          print(res);
        }
        if (kDebugMode) {
          print(res.message);
        }
        emit(state.copyWith(isSubmitting: false, isSuccess: true));
        emit(state.copyWith(isSubmitting: false,isSuccess: false));
      }
      catch (e) {
        if (e is DioException) {
          emit(state.copyWith(isSubmitting: false, generalError: e.message));
        } else if (e is ValidationException) {
          final errorModel = SignupErrorModel.fromJson(e.data);
          String? passwordError = errorModel.errors
              .firstWhere(
                (e) => e.path.contains('password'),
            orElse: () => FieldErrors(code: '', message: '', path: []),
          )
              .message;

          String? generalError = errorModel.message;
          if (kDebugMode) {
            print("General error: $generalError");
          }

          emit(
            state.copyWith(
              isSubmitting: false,
              isSuccess: false,
              passwordError: passwordError.isNotEmpty ? passwordError : null,
              generalError: generalError,
            ),
          );
        }
        else {
          emit(
            state.copyWith(
              isSubmitting: false,
              isSuccess: false,
              generalError: "Internal error occurred, Please try again later",
            ),
          );
        }
      }
    }
    );
  }
}
