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
        rethrow;
      }
      // Error if not internet or server is unreachable
      else {
       throw DioException(requestOptions: e.requestOptions,
         type: DioExceptionType.connectionError,
         message: "Couldn't connect to the server please try again"
       );
      }
    }
    // Any other unexpected errors
    catch (e) {
     throw Exception(e.toString());
    }
  }

  void setToken(String token) {
    dio.options.headers["Authorization"] = "Bearer $token";
  }
}
