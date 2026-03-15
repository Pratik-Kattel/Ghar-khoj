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

class HouseUploadSubmitted extends HouseUploadEvent {}