import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/features/Settings/model/change_user_name_model.dart';
import 'package:frontend/services/api_clients.dart';

class ChangeUserNameRepo {
  ApiClient apiClient;
  
  ChangeUserNameRepo({required this.apiClient});
  
  Future<ChangeUserNameModel> changeName(String email,String name) async{
    final res=await apiClient.post(ApiEndpoints.changeName, {
      "email":email,
      "name":name,
    });
    return ChangeUserNameModel.fromJson(res);
  }
}