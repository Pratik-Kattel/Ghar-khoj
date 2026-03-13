import 'package:bloc/bloc.dart';
import 'package:frontend/features/auth/Repository/login/location_response_repo.dart';
import 'package:frontend/services/get_user_data.dart';
import 'package:geolocator/geolocator.dart';
import '../../../services/location_service.dart';
import '../Screen/HomeScreen.dart';
import 'home_screen_event.dart';
import 'home_screen_state.dart';



class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  final GetUserDataRepo getUserDataRepo;
  final LocationResponseRepo locationResponseRepo;
  HomeScreenBloc({required this.getUserDataRepo,required this.locationResponseRepo}) : super(HomeScreenState()) {
    on <HomeStarted>((event,emit) async{
      emit(state.copyWith(isLoading: true));
      try{
        // Fetching name
        String? email=await GetUserDataRepo.getUserEmail();
        await getUserDataRepo.getUserData(email);
        final getUsername=GetUserName(getUserDataRepo: getUserDataRepo);
        final name=await getUsername.getuserName();

        //Sending longitude and latitude to database

        Position position=await LocationService.getUserLocation();
        double lat=position.latitude;
        double long=position.longitude;
        await locationResponseRepo.sendLocation(long, lat, email);

        // Fetching placename from longitude and latitude
        String? place=await PlaceName.getPlace(long, lat);
        print("Place:$place");

        emit(state.copyWith(
          isLoading: false,
          name: name,
          place: place
        ));
      }
      catch(e){
        emit(state.copyWith(
          isLoading: false,
          name: "Loading...",
            place: "Location Not Available"
        ));
      }
    });
  }
}
