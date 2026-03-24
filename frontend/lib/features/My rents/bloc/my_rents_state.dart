import 'package:equatable/equatable.dart';
import '../Model/rents_model.dart';

class RentsState extends Equatable {
  final bool isLoading;
  final bool isAdding;
  final List<RentsModel> rents;
  final String? error;
  final String? message;

  final bool isBooked;
  final String? bookedStartDate;
  final String? bookedEndDate;


  RentsState({
    this.isLoading = false,
    this.isAdding = false,
    this.rents = const [],
    this.error,
    this.message,
    this.isBooked=false,
    this.bookedStartDate,
    this.bookedEndDate
  });

  RentsState copyWith({
    bool? isLoading,
    bool? isAdding,
    List<RentsModel>? rents,
    String? error,
    String? message,
    bool? isBooked,
    String? bookedStartDate,
    String? bookedEndDate,
    bool clearBookedDates = false,
  }) {
    return RentsState(
      isLoading: isLoading ?? this.isLoading,
      isAdding: isAdding ?? this.isAdding,
      rents: rents ?? this.rents,
      error: error,
      message: message,
      isBooked: isBooked ?? this.isBooked,
      bookedStartDate: clearBookedDates ? null : (bookedStartDate ?? this.bookedStartDate),
      bookedEndDate: clearBookedDates ? null : (bookedEndDate ?? this.bookedEndDate),
    );
  }

  @override
  List<Object?> get props => [isLoading, isAdding, rents, error, message,bookedStartDate,bookedEndDate];
}