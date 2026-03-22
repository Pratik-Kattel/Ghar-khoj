import 'package:equatable/equatable.dart';
import 'dart:io';

class ProfilePageEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class NameChangedEvent extends ProfilePageEvent {
  final String name;

  NameChangedEvent({required this.name});

  @override
  List<Object?> get props => [name];
}

class EmailChangedEvent extends ProfilePageEvent {
  final String email;

  EmailChangedEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class NameSubmittedEvent extends ProfilePageEvent {}

class ProfilePicChangedEvent extends ProfilePageEvent {
  final File image;

  ProfilePicChangedEvent({required this.image});

  @override
  List<Object?> get props => [image];
}

class ProfilePicSubmittedEvent extends ProfilePageEvent {}

class FetchProfilePicEvent extends ProfilePageEvent {}
