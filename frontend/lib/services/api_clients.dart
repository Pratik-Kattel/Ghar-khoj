import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../services/Custom_Exception.dart';

class ApiClient {
  final String baseUrl;
  late Dio dio;

  ApiClient({required this.baseUrl}) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(milliseconds: 10000),
        receiveTimeout: const Duration(milliseconds: 10000),
        headers: {"Content-Type": "application/json"},
      ),
    );
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    dynamic body,
  //       Map<String, dynamic>? headers,
  // }
  ) async {
    try {
      final response = await dio.post(
        endpoint,
        data: body,
        options: Options(
          // headers: headers,
          contentType: body is FormData
              ? "multipart/form-data"
              : Headers.formUrlEncodedContentType,
        ),
      );
      if (kDebugMode) {
        print("SUCCESS RESPONSE: ${response.data}");
      }
      return response.data;
    } on DioException catch (e) {
      if (kDebugMode) {
        print("DIO ERROR: ${e.response?.data}");
      }
      if (e.response != null) {
        final validationError = e.response?.data;
        if (validationError != null && validationError['errors'] != null) {
          throw ValidationException(validationError);
        }
        final message = e.response?.data['message'] ?? "Something went wrong";
        throw DioException(
          requestOptions: e.requestOptions,
          type: DioExceptionType.badResponse,
          error: message,
          message: message,
        );
      }
      throw DioException(
        requestOptions: e.requestOptions,
        type: DioExceptionType.connectionError,
        message: "Couldn't connect to the server please try again",
      );
    }
  }

  void setToken(String token) {
    dio.options.headers["Authorization"] = "Bearer $token";
  }

  Future<dynamic> get(String endpoint) async {
    try {
      final res = await dio.get(endpoint);
      if (kDebugMode) {
        print("GET RAW RESPONSE: ${res.data}");
      }
      if (kDebugMode) {
        print("GET RESPONSE TYPE: ${res.data.runtimeType}");
      }
      return res.data;
    } on DioException catch (e) {
      if (kDebugMode) {
        print("DIO GET ERROR: ${e.response?.statusCode} | ${e.response?.data}");
      }
      if (e.response != null) {
        String error = "Something went wrong";
        final data = e.response?.data;
        if (data is Map) {
          error = data['message'] ?? "Something went wrong";
        } else if (data is String) {
          error = data;
        }
        throw DioException(
          requestOptions: e.requestOptions,
          type: DioExceptionType.badResponse,
          error: error,
          message: error,
        );
      }
      throw DioException(
        requestOptions: e.requestOptions,
        type: DioExceptionType.connectionError,
        error: "Couldn't connect to the server try again later",
        message: "Couldn't connect to the server try again later",
      );
    }
  }
}
