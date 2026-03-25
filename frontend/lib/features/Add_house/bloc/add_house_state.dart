import 'dart:io';

class HouseUploadState {
  final String title;
  final String description;
  final double price;
  final File? imageFile;
  final String country;
  final String place;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;
  final String? message;

  const HouseUploadState({
    this.title = '',
    this.description = '',
    this.price = 0.0,
    this.imageFile,
    this.country = '',
    this.place = '',
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
    this.message,
  });

  HouseUploadState copyWith({
    String? title,
    String? description,
    double? price,
    File? imageFile,
    String? country,
    String? place,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    String? message,
  }) {
    return HouseUploadState(
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageFile: imageFile ?? this.imageFile,
      country: country ?? this.country,
      place: place ?? this.place,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      message: message ?? this.message,
    );
  }

  factory HouseUploadState.initial() {
    return HouseUploadState(
      imageFile: null,
      title: '',
      description: '',
      price: 0,
      country: '',
      place: '',
      isSubmitting: false,
      isSuccess: false,
      errorMessage: null,
      message: null,
    );
  }
}
