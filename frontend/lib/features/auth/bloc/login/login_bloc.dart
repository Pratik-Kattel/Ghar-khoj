import 'package:flutter_bloc/flutter_bloc.dart';
import '../login/login_event.dart';
import '../login/login_state.dart';
import '../../Repository/login/login_repo.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository repository;

  LoginBloc({required this.repository}) : super(const LoginState()) {
    on<EmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email, emailError: null));
    });

    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password, passwordError: null));
    });

    on<LoginSubmitted>((event, emit) async {
      emit(state.copyWith(isSubmitting: true, emailError: null, passwordError: null, generalError: null));

      final res = await repository.login(state.email, state.password);

      if (res.user == null) {
        emit(state.copyWith(isSubmitting: false, generalError: res.message));
      } else {
        emit(state.copyWith(isSubmitting: false, isSuccess: true));
      }
    });
  }
}
