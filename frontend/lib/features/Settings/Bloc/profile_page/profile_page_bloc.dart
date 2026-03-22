import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/features/Settings/Bloc/profile_page/profile_page_event.dart';
import 'package:frontend/features/Settings/Bloc/profile_page/profile_page_state.dart';
import 'package:frontend/features/Settings/Repository/change_user_name_repo.dart';
import 'package:frontend/services/api_clients.dart';
import 'package:frontend/services/get_user_data.dart';

class ProfilePageBloc extends Bloc<ProfilePageEvent, ProfilePageState> {
  ChangeUserNameRepo changeUserNameRepo;

  ProfilePageBloc({required this.changeUserNameRepo})
      : super(const ProfilePageState()) {
    on<NameChangedEvent>((event, emit) {
      emit(state.copyWith(name: event.name, nameError: null));
    });

    on<EmailChangedEvent>((event, emit) {
      emit(state.copyWith(email: event.email));
    });

    on<NameSubmittedEvent>((event, emit) async {
      emit(state.copyWith(
          isSubmitting: true, generalError: null, nameError: null));
      try {
        await changeUserNameRepo.changeName(state.email, state.name);
        emit(state.copyWith(isSubmitting: false, isSuccess: true));
        emit(state.copyWith(isSuccess: false));
      } on DioException catch (e) {
        emit(state.copyWith(
            isSubmitting: false,
            isSuccess: false,
            generalError: e.message));
      } catch (e) {
        if (kDebugMode) print(e.toString());
        emit(state.copyWith(
            isSubmitting: false, generalError: e.toString()));
      }
    });

    on<ProfilePicChangedEvent>((event, emit) {
      emit(state.copyWith(profilePicFile: event.image));
    });

    on<ProfilePicSubmittedEvent>((event, emit) async {
      if (state.profilePicFile == null) return;
      emit(state.copyWith(isUploadingPic: true, generalError: null));
      try {
        final apiClient = ApiClient(baseUrl: ApiEndpoints.baseUrl);
        final formData = FormData.fromMap({
          "email": state.email,
          "image": await MultipartFile.fromFile(
            state.profilePicFile!.path,
            filename: state.profilePicFile!.path.split('/').last,
          ),
        });
        final res = await apiClient.post(
          ApiEndpoints.uploadProfilePic,
          formData,
        );
        final profilePic = res["profilePic"] ?? "";
        final profilePicUrl = profilePic.isNotEmpty
            ? "${ApiEndpoints.imageBaseUrl}$profilePic"
            : null;
        emit(state.copyWith(
          isUploadingPic: false,
          profilePicUrl: profilePicUrl,
        ));
      } catch (e) {
        if (kDebugMode) print(e.toString());
        emit(state.copyWith(
            isUploadingPic: false, generalError: e.toString()));
      }
    });

    on<FetchProfilePicEvent>((event, emit) async {
      try {
        final apiClient = ApiClient(baseUrl: ApiEndpoints.baseUrl);
        final email=await GetUserDataRepo.getUserEmail();
        final res = await apiClient
            .get("${ApiEndpoints.getProfilePic}/${email}");
        final profilePic = res["profilePic"];
        if (profilePic != null && profilePic.isNotEmpty) {
          emit(state.copyWith(
            profilePicUrl: "${ApiEndpoints.imageBaseUrl}$profilePic",
          ));
        }
      } catch (e) {
        if (kDebugMode) print(e.toString());
      }
    });
  }
}