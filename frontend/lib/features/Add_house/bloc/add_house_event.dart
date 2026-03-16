// lib/features/house/bloc/house_upload_event.dart
import 'dart:io';

sealed class HouseUploadEvent {}

class HouseTitleChanged extends HouseUploadEvent {
  final String title;
  HouseTitleChanged(this.title);
}

class HouseDescriptionChanged extends HouseUploadEvent {
  final String description;
  HouseDescriptionChanged(this.description);
}

class HousePriceChanged extends HouseUploadEvent {
  final double price;
  HousePriceChanged(this.price);
}

class HouseImagePicked extends HouseUploadEvent {
  final File image;
  HouseImagePicked(this.image);
}

class HouseCountryChanged extends HouseUploadEvent {
  final String country;
  HouseCountryChanged(this.country);
}

class HousePlaceChanged extends HouseUploadEvent {
  final String place;
  HousePlaceChanged(this.place);
}
class HouseResetState extends HouseUploadEvent {}

class HouseUploadSubmitted extends HouseUploadEvent {}

abstract class HomeScreenEvent {}

class HomeStarted extends HomeScreenEvent {}

class FetchNearbyHouses extends HomeScreenEvent {

  final double lat;
  final double lng;

  FetchNearbyHouses(this.lat,this.lng);

}