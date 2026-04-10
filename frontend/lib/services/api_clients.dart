import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../services/Custom_Exception.dart';

// A client class to handle network requests using the Dio package.
class ApiClient {
  final String baseUrl;
  late Dio dio;

  ApiClient({required this.baseUrl}) {
    // Initialize Dio with base configuration.
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(milliseconds: 10000),
        receiveTimeout: const Duration(milliseconds: 10000),
        headers: {"Content-Type": "application/json"},
      ),
    );
  }

  // Performs a POST request to the specified endpoint.
  Future<Map<String, dynamic>> post(
    String endpoint,
    dynamic body,
      {
        Map<String, dynamic>? headers,
  }
  ) async {
    try {
      final response = await dio.post(
        endpoint,
        data: body,
        options: Options(
          headers: headers,
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
        // Handle validation errors specifically if they exist.
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
      // Handle cases where no response was received (e.g., connection issues).
      throw DioException(
        requestOptions: e.requestOptions,
        type: DioExceptionType.connectionError,
        message: "Couldn't connect to the server please try again",
      );
    }
  }

  // Sets the authorization token for subsequent requests.
  void setToken(String token) {
    dio.options.headers["Authorization"] = "Bearer $token";
  }

  // Performs a GET request to the specified endpoint.
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

  // Performs a DELETE request to the specified endpoint.
  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final res = await dio.delete(endpoint);
      if (kDebugMode) {
        print("DELETE RESPONSE: ${res.data}");
      }
      return res.data;
    } on DioException catch (e) {
      if (kDebugMode) {
        print("DIO DELETE ERROR: ${e.response?.statusCode} | ${e.response?.data}");
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
