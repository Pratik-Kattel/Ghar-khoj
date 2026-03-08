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
    } on DioException catch (e) {
      // Backend error code like 400,404
      if (e.response != null) {
        final message = e.response?.data['message'] ?? "Something went wrong";
        throw DioException(requestOptions: e.requestOptions,
        type: DioExceptionType.badResponse,
          error: message,
          message: message
        );
      }
      // Error if not internet or server is unreachable
       throw DioException(requestOptions: e.requestOptions,
         type: DioExceptionType.connectionError,
         message: "Couldn't connect to the server please try again"
       );
    }
  }

  void setToken(String token) {
    dio.options.headers["Authorization"] = "Bearer $token";
  }
}
