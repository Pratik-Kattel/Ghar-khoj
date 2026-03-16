import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/get_user_data.dart';
import '../../../services/location_service.dart';
import '../../HomeScreen/Repository/nearby_house_repo.dart';
import '../Model/add_house_model.dart';
import '../Repository/upload_house-repo.dart';
import 'add_house_event.dart';
import 'add_house_state.dart';

class HouseUploadBloc extends Bloc<HouseUploadEvent, HouseUploadState> {
  final HouseRepository repository;

  HouseUploadBloc({required this.repository})
    : super(const HouseUploadState()) {
    on<HouseTitleChanged>(
      (event, emit) => emit(state.copyWith(title: event.title)),
    );
    on<HouseDescriptionChanged>(
      (event, emit) => emit(state.copyWith(description: event.description)),
    );
    on<HousePriceChanged>(
      (event, emit) => emit(state.copyWith(price: event.price)),
    );
    on<HouseImagePicked>(
      (event, emit) => emit(state.copyWith(imageFile: event.image)),
    );
    on<HouseResetState>((event, emit) {
      emit(HouseUploadState.initial());
    });
    on<HouseCountryChanged>(
      (event, emit) => emit(state.copyWith(country: event.country)),
    );
    on<HousePlaceChanged>(
      (event, emit) => emit(state.copyWith(place: event.place)),
    );

    on<HouseUploadSubmitted>((event, emit) async {
      if (state.title.isEmpty ||
          state.imageFile == null ||
          state.country.isEmpty ||
          state.place.isEmpty) {
        emit(
          state.copyWith(
            errorMessage:
                "All fields including image, country, and place are required",
          ),
        );
        return;
      }

      emit(state.copyWith(isSubmitting: true, errorMessage: null));

      try {
        final userEmail = await GetUserDataRepo.getUserEmail();
        if (userEmail == null) {
          emit(state.copyWith(isSubmitting: false, errorMessage: "User email not found!"));
          return;
        }
        List<double> latLong = await LocationService.getLatLongFromAddress(
          state.country,
          state.place,
        );
        double latitude = latLong[0];
        double longitude = latLong[1];

        HouseUploadResponse res = await repository.uploadHouse(
          title: state.title,
          email:userEmail ,
          description: state.description,
          price: state.price,
          latitude: latitude,
          longitude: longitude,
          imageFile: state.imageFile!,
        );

        emit(
          state.copyWith(
            isSubmitting: false,
            isSuccess: true,
            message: res.message,
          ),
        );
      } catch (e) {
        emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
      }
    });
  }
}



class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {

  final NearbyHouseRepo repo;

  HomeScreenBloc(this.repo) : super(HomeScreenState.initial()) {

    on<FetchNearbyHouses>((event, emit) async {

      emit(state.copyWith(isLoading: true));

      final houses = await repo.fetchNearbyHouses(
        event.lat,
        event.lng,
      );

      emit(state.copyWith(
        isLoading: false,
        nearbyHouses: houses,
      ));

    });

  }
}
