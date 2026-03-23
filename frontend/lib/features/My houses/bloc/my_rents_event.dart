abstract class RentsEvent {}

class AddToRents extends RentsEvent {
  final String houseId;
  final String startDate;
  final String endDate;
  final double totalAmount;
  final Map<String, String>? bookedPeriod;
  AddToRents({required this.houseId,required this.startDate,required this.endDate,required this.totalAmount,required this.bookedPeriod});
}

class FetchRents extends RentsEvent {}