import 'dart:io';

abstract class LandlordRequestEvent {}

class SubmitLandlordRequestEvent extends LandlordRequestEvent {
  final String email;
  final File citizenshipFile;

  SubmitLandlordRequestEvent({
    required this.email,
    required this.citizenshipFile,
  });
}