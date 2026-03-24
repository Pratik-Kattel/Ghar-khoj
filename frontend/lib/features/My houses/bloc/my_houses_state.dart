import 'package:equatable/equatable.dart';
import '../Model/my_houses_model.dart';

class MyHousesState extends Equatable {
  final bool isLoading;
  final bool isUpdating;
  final bool isDeleting;
  final List<MyHouseModel> houses;
  final String? error;
  final String? message;

  const MyHousesState({
    this.isLoading = false,
    this.isUpdating = false,
    this.isDeleting = false,
    this.houses = const [],
    this.error,
    this.message,
  });

  MyHousesState copyWith({
    bool? isLoading,
    bool? isUpdating,
    bool? isDeleting,
    List<MyHouseModel>? houses,
    String? error,
    String? message,
  }) {
    return MyHousesState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      isDeleting: isDeleting ?? this.isDeleting,
      houses: houses ?? this.houses,
      error: error,
      message: message,
    );
  }

  @override
  List<Object?> get props => [isLoading, isUpdating, isDeleting, houses, error, message];
}