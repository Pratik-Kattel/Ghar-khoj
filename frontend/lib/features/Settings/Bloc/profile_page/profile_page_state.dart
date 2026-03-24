import 'package:equatable/equatable.dart';
import 'dart:io';

class ProfilePageState extends Equatable {
  final String name;
  final String? nameError;
  final String? generalError;
  final bool isSubmitting;
  final bool isSuccess;
  final String email;
  final File? profilePicFile;
  final String? profilePicUrl;
  final bool isUploadingPic;
  final bool justUpdatedPic;

  const ProfilePageState({
    this.name = " ",
    this.email = " ",
    this.generalError,
    this.nameError,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.profilePicFile,
    this.profilePicUrl,
    this.isUploadingPic = false,
    this.justUpdatedPic = false,
  });

  ProfilePageState copyWith({
    String? name,
    String? email,
    String? nameError,
    bool? isSubmitting,
    bool? isSuccess,
    String? generalError,
    File? profilePicFile,
    String? profilePicUrl,
    bool? isUploadingPic,
    bool ?justUpdatedPic,
  }) {
    return ProfilePageState(
      name: name ?? this.name,
      nameError: nameError ?? this.nameError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      email: email ?? this.email,
      generalError: generalError ?? this.generalError,
      profilePicFile: profilePicFile ?? this.profilePicFile,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      isUploadingPic: isUploadingPic ?? this.isUploadingPic,
      justUpdatedPic: justUpdatedPic ?? this.justUpdatedPic
    );
  }

  @override
  List<Object?> get props => [
    name,
    nameError,
    isSubmitting,
    isSuccess,
    email,
    generalError,
    profilePicFile,
    profilePicUrl,
    isUploadingPic,
    justUpdatedPic
  ];
}