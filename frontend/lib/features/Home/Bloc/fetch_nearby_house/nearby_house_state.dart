import 'package:equatable/equatable.dart';

import '../../Model/nearby_house_model.dart';

class NearbyHouseState extends Equatable {
  final bool isLoading;
  final List<NearbyHouseModel> houses;
  final String? error;

  NearbyHouseState({this.isLoading = false, this.houses = const [], this.error});

  NearbyHouseState copyWith({
    bool? isLoading,
    List<NearbyHouseModel>? houses,
    String? error,
  }) {
    return NearbyHouseState(
      isLoading: isLoading ?? this.isLoading,
      houses: houses ?? this.houses,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, houses, error];
}