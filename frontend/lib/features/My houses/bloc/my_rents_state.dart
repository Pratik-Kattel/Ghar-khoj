import 'package:equatable/equatable.dart';
import '../Model/rents_model.dart';

class RentsState extends Equatable {
  final bool isLoading;
  final bool isAdding;
  final List<RentsModel> rents;
  final String? error;
  final String? message;

  RentsState({
    this.isLoading = false,
    this.isAdding = false,
    this.rents = const [],
    this.error,
    this.message,
  });

  RentsState copyWith({
    bool? isLoading,
    bool? isAdding,
    List<RentsModel>? rents,
    String? error,
    String? message,
  }) {
    return RentsState(
      isLoading: isLoading ?? this.isLoading,
      isAdding: isAdding ?? this.isAdding,
      rents: rents ?? this.rents,
      error: error,
      message: message,
    );
  }

  @override
  List<Object?> get props => [isLoading, isAdding, rents, error, message];
}