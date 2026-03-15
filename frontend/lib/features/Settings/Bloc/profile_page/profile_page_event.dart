import 'package:equatable/equatable.dart';

class ProfilePageEvent extends Equatable{
  @override
  List<Object?> get props =>[];
}

class NameChangedEvent extends ProfilePageEvent{
  String name;
  NameChangedEvent({required this.name});

  @override
  List<Object?> get props =>[name];
}

class EmailChangedEvent extends ProfilePageEvent{
  String email;
  EmailChangedEvent({required this.email});

  @override
  List<Object?> get props =>[email];
}
class NameSubmittedEvent extends ProfilePageEvent{}