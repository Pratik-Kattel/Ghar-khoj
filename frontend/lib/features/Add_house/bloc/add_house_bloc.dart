import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import '../Model/add_house_model.dart';
import '../Repository/upload_house-repo.dart';
import 'add_house_event.dart';
import 'add_house_state.dart';

class HouseUploadBloc extends Bloc<HouseUploadEvent, HouseUploadState> {
  final HouseRepository repository;

  HouseUploadBloc({required this.repository}) : super(const HouseUploadState()) {
    on<HouseTitleChanged>((event, emit) => emit(state.copyWith(title: event.title)));
    on<HouseDescriptionChanged>((event, emit) => emit(state.copyWith(description: event.description)));
    on<HousePriceChanged>((event, emit) => emit(state.copyWith(price: event.price)));
    on<HouseImagePicked>((event, emit) => emit(state.copyWith(imageFile: event.image)));

    on<HouseUploadSubmitted>((event, emit) async {
      if (state.title.isEmpty || state.imageFile == null) {
        emit(state.copyWith(errorMessage: "Title and image are required"));
        return;
      }

      emit(state.copyWith(isSubmitting: true, errorMessage: null));

      try {
        HouseUploadResponse res = await repository.uploadHouse(
          title: state.title,
          description: state.description,
          price: state.price,
          latitude: 27.675,
          longitude: 84.428,
          imageFile: state.imageFile!,
        );

        emit(state.copyWith(isSubmitting: false, isSuccess: true, message: res.message));
      } catch (e) {
        emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
      }
    });
  }
}