abstract class LandlordRequestState {}

class LandlordRequestInitial extends LandlordRequestState {}

class LandlordRequestLoading extends LandlordRequestState {}

class LandlordRequestSuccess extends LandlordRequestState {}

class LandlordRequestError extends LandlordRequestState {
  final String message;
  LandlordRequestError(this.message);
}