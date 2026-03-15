import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/Settings/Bloc/profile_page/profile_page_event.dart';
import 'package:frontend/features/Settings/Bloc/profile_page/profile_page_state.dart';
import 'package:frontend/features/Settings/Repository/change_user_name_repo.dart';
import 'package:frontend/services/get_user_data.dart';

class ProfilePageBloc extends Bloc<ProfilePageEvent, ProfilePageState> {
  ChangeUserNameRepo changeUserNameRepo;

  ProfilePageBloc({required this.changeUserNameRepo})
    : super(ProfilePageState()) {
      on<NameChangedEvent>((event, emit) {
        emit(state.copyWith(name: event.name,nameError: null));
      });
      on<EmailChangedEvent>((event,emit){
        emit(state.copyWith(email: event.email));
              });
    on<NameSubmittedEvent>((event, emit) async {
      emit(
        state.copyWith(isSubmitting: true, generalError: null, nameError: null),
      );
      try {
        await changeUserNameRepo.changeName(state.email, state.name);
        emit(state.copyWith(isSubmitting: false, isSuccess: true));
        emit(state.copyWith(isSuccess: false));
      }
      on DioException catch(e){
        emit(state.copyWith(isSubmitting: false,isSuccess: false,generalError: e.message));
      }
      catch(e){
        if (kDebugMode) {
          print(e.toString());
        }
        emit(
            state.copyWith(
                isSubmitting: false,
                generalError:e.toString()
            )
        );
      }
    });
  }
}
