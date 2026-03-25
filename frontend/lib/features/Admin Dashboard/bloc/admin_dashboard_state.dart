import '../Model/admin_dashboard_model.dart';


abstract class AdminDashboardState {}

class AdminDashboardInitial extends AdminDashboardState {}

class AdminDashboardLoading extends AdminDashboardState {}

class AdminDashboardLoaded extends AdminDashboardState {
  final List<AdminLandlordRequestModel> requests;
  AdminDashboardLoaded(this.requests);
}

class AdminDashboardActionSuccess extends AdminDashboardState {
  final String message;
  AdminDashboardActionSuccess(this.message);
}

class AdminDashboardError extends AdminDashboardState {
  final String message;
  AdminDashboardError(this.message);
}