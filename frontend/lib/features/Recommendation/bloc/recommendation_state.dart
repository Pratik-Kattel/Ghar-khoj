import 'package:equatable/equatable.dart';
import '../Model/recommendation_model.dart';

class RecommendedState extends Equatable {
  final bool isLoading;
  final List<RecommendedModel> houses;
  final String? error;

  RecommendedState({
    this.isLoading = false,
    this.houses = const [],
    this.error,
  });

  RecommendedState copyWith({
    bool? isLoading,
    List<RecommendedModel>? houses,
    String? error,
  }) {
    return RecommendedState(
      isLoading: isLoading ?? this.isLoading,
      houses: houses ?? this.houses,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, houses, error];
}