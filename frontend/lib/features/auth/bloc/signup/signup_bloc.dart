import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/services/Custom_Exception.dart';
import './signup_event.dart';
import './signup_state.dart';
import '../../Repository/signup/signup_repo.dart';
import '../../models/signup/Signup_Error_Model.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupRepository signupRepository;

  SignupBloc({required this.signupRepository}) : super(SignupState()) {
    on<NameChanged>((event, emit) {
      emit(state.CopyWith(name: event.name, nameError: null));
    });

    on<EmailChanged>((event, emit) {
      emit(state.CopyWith(email: event.email, emailError: null));
    });

    on<PasswordChanged>((event, emit) {
      emit(state.CopyWith(password: event.password, passwordError: null));
    });

    on<PasswordConfirm>((event, emit) {
      emit(
        state.CopyWith(
          confirmPassword: event.confirmPassword,
          confirmError: null,
        ),
      );
    });

    on<SignupSubmitted>((event, emit) async {
      if (state.password != state.confirmPassword) {
        emit(
          state.CopyWith(
            isSubmitting: false,
            confirmError: "Password didn't match",
          ),
        );
        return;
      }

      emit(
        state.CopyWith(
          isSubmitting: true,
          emailError: null,
          passwordError: null,
          nameError: null,
          confirmError: null,
          generalError: null,
        ),
      );
      try {
        final res = await signupRepository.register(
          state.email,
          state.name,
          state.password,
        );
        if (kDebugMode) {
          print(res);
        }
        if (kDebugMode) {
          print(res.userModel);
        }
        emit(state.CopyWith(isSubmitting: false, isSuccess: true));
      }
      catch (e) {
        if (e is DioException) {
          emit(state.CopyWith(isSubmitting: false, generalError: e.message));
        } else if (e is ValidationException) {
          final errorModel = SignupErrorModel.fromJson(e.data);
          String? emailError = errorModel.errors
              .firstWhere(
                (err) => err.path.contains('email'),
            orElse: () => FieldErrors(code: '', message: '', path: []),
          )
              .message;
          String? passwordError = errorModel.errors
              .firstWhere(
                (e) => e.path.contains('password'),
            orElse: () => FieldErrors(code: '', message: '', path: []),
          )
              .message;

          String? generalError = errorModel.message;
          print("General error: $generalError");

          emit(
            state.CopyWith(
              isSubmitting: false,
              isSuccess: false,
              emailError: emailError.isNotEmpty ? emailError : null,
              passwordError: passwordError.isNotEmpty ? passwordError : null,
              generalError: generalError,
            ),
          );
        }
        // } else {
        //   emit(
        //     state.CopyWith(
        //       isSubmitting: false,
        //       isSuccess: false,
        //       generalError: "Internal error occurred, Please try again later",
        //     ),
        //   );
        // }
      }
    });
  }
}
