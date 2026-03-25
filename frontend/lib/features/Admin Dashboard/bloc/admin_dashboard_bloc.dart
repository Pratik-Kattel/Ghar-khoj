import 'package:flutter_bloc/flutter_bloc.dart';
import '../Repository/admin_dashboard_repo.dart';
import 'admin_dashboard_event.dart';
import 'admin_dashboard_state.dart';

class AdminDashboardBloc
    extends Bloc<AdminDashboardEvent, AdminDashboardState> {
  final AdminDashboardRepo repo;

  AdminDashboardBloc({required this.repo}) : super(AdminDashboardInitial()) {
    on<LoadAllRequestsEvent>(_onLoad);
    on<ApproveRequestEvent>(_onApprove);
    on<RejectRequestEvent>(_onReject);
  }

  Future<void> _onLoad(
      LoadAllRequestsEvent event,
      Emitter<AdminDashboardState> emit,
      ) async {
    emit(AdminDashboardLoading());
    try {
      final requests = await repo.getAllRequests();
      emit(AdminDashboardLoaded(requests));
    } catch (e) {
      emit(AdminDashboardError(e.toString()));
    }
  }

  Future<void> _onApprove(
      ApproveRequestEvent event,
      Emitter<AdminDashboardState> emit,
      ) async {
    emit(AdminDashboardLoading());
    try {
      await repo.approveRequest(event.requestId);
      emit(AdminDashboardActionSuccess('Request approved successfully'));
      final requests = await repo.getAllRequests();
      emit(AdminDashboardLoaded(requests));
    } catch (e) {
      emit(AdminDashboardError(e.toString()));
    }
  }

  Future<void> _onReject(
      RejectRequestEvent event,
      Emitter<AdminDashboardState> emit,
      ) async {
    emit(AdminDashboardLoading());
    try {
      await repo.rejectRequest(event.requestId);
      emit(AdminDashboardActionSuccess('Request rejected'));
      final requests = await repo.getAllRequests();
      emit(AdminDashboardLoaded(requests));
    } catch (e) {
      emit(AdminDashboardError(e.toString()));
    }
  }
}