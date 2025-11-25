import 'package:dio/dio.dart';

class ApiClient {
  final String baseUrl;
  late Dio dio;

  ApiClient({required this.baseUrl}) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(milliseconds: 10000),
        receiveTimeout: Duration(milliseconds: 10000),
        headers: {"Content-Type": "application/json"},
      ),
    );
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await dio.post(endpoint, data: body);
      return response.data;
    }
    on DioError catch (e) {
      if (e.response != null) {
        return e.response?.data ?? {"message": "Unknown error from server"};
      } else {
        return {"message": e.message};
      }
    } catch (e) {
      return {"message": e.toString()};
    }
  }

  void setToken(String token) {
    dio.options.headers["Authorization"] = "Bearer $token";
  }
}
