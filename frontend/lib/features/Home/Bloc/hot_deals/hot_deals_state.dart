import 'package:equatable/equatable.dart';
import '../../Model/hotdeals_model.dart';

class HotDealsState extends Equatable {
  final bool isLoading;
  final List<HotDealModel> houses;
  final String? error;

  HotDealsState({this.isLoading = false, this.houses = const [], this.error});

  HotDealsState copyWith({
    bool? isLoading,
    List<HotDealModel>? houses,
    String? error,
  }) {
    return HotDealsState(
      isLoading: isLoading ?? this.isLoading,
      houses: houses ?? this.houses,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, houses, error];
}