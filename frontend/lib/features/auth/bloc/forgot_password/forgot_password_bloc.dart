import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/Repository/forgot_password/validate_email_repo.dart';
import 'package:frontend/features/auth/bloc/forgot_password/forgot_password_event.dart';
import 'package:frontend/features/auth/bloc/forgot_password/forgot_password_state.dart';

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
      try{
        final res= await validateEmailRepository.validateEmail(state.email);
        emit(state.copyWith(isSubmitting:false,isSuccess: true));
      }
      catch(e){
        emit(state.copyWith(isSubmitting: false,generalError: e.toString()));
      }
    });
  }
}
