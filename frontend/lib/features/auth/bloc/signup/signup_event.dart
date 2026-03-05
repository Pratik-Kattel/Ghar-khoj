import 'package:equatable/equatable.dart';

sealed class SignupEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class NameChanged extends SignupEvent {
  final String name;

  NameChanged({required this.name});

  @override
  List<Object?> get props => [name];
}

class EmailChanged extends SignupEvent {
  final String email;

  EmailChanged({required this.email});

  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends SignupEvent {
  final String password;

  PasswordChanged({required this.password});

  @override
  List<Object?> get props => [password];
}

class PasswordConfirm extends SignupEvent {
  final String confirmPassword;

  PasswordConfirm({required this.confirmPassword});

  @override
  List<Object?> get props => [confirmPassword];
}

class SignupSubmitted extends SignupEvent {}
