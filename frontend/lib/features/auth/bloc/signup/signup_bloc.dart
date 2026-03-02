import 'package:flutter_bloc/flutter_bloc.dart';
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

    on<SignupSubmitted>((event, emit) async{
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
      final res=await signupRepository.register(state.email, state.name, state.password);
      // if(res.userModel==null){
      //   emit(state.CopyWith(
      //     isSubmitting: false,
      //     generalError:
      //   ));
      // }
      });
    }
  }

