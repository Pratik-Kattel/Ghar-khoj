import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/services/api_clients.dart';
import 'package:frontend/services/secure_storage.dart';
import '../Model/admin_dashboard_model.dart';

class AdminDashboardRepo {
  final ApiClient apiClient;

  AdminDashboardRepo({required this.apiClient});

  Future<List<AdminLandlordRequestModel>> getAllRequests() async {
    final token = await SecureStorage.getToken();
    apiClient.setToken(token!);

    final data = await apiClient.get(ApiEndpoints.adminLandlordRequests);
    final List list = data as List;
    return list.map((e) => AdminLandlordRequestModel.fromJson(e)).toList();
  }

  Future<void> approveRequest(String requestId) async {
    final token = await SecureStorage.getToken();
    apiClient.setToken(token!);

    await apiClient.post(
      '${ApiEndpoints.approveLandlord}/$requestId',
      {},
    );
  }

  Future<void> rejectRequest(String requestId) async {
    final token = await SecureStorage.getToken();
    apiClient.setToken(token!);

    await apiClient.post(
      '${ApiEndpoints.rejectLandlord}/$requestId',
      {},
    );
  }
}