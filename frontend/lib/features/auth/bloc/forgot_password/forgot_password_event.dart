import 'package:equatable/equatable.dart';

class ForgotPasswordEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmailChanged extends ForgotPasswordEvent {
  final String email;

  EmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class EmailSubmitted extends ForgotPasswordEvent {}

class OTPValidationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OTPChangedEvent extends OTPValidationEvent {
  final String OTP;

  OTPChangedEvent(this.OTP);

  @override
  List<Object?> get props => [OTP];
}
class EmailChangedEvent extends OTPValidationEvent{
  final String email;

  EmailChangedEvent(this.email);

  List<Object?> get props => [email];
}

class OTPSubmittedEvent extends OTPValidationEvent{}
