abstract class AdminDashboardEvent {}

class LoadAllRequestsEvent extends AdminDashboardEvent {}

class ApproveRequestEvent extends AdminDashboardEvent {
  final String requestId;
  ApproveRequestEvent(this.requestId);
}

class RejectRequestEvent extends AdminDashboardEvent {
  final String requestId;
  RejectRequestEvent(this.requestId);
}