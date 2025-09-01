import 'package:dio/dio.dart';
import 'dio_client.dart';

class ApiManager {
  final Dio _dio = DioClient.instance;

  // GET request
  Future<dynamic> getRequest(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return response.data;
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  // POST request
  Future<dynamic> postRequest(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response.data;
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  // Centralized error handling
  String _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return "Connection timeout!";
    } else if (e.type == DioExceptionType.sendTimeout) {
      return "Send timeout!";
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return "Receive timeout!";
    } else if (e.type == DioExceptionType.badResponse) {
      return "Error: ${e.response?.statusCode} - ${e.response?.statusMessage}";
    } else {
      return "Unexpected error: ${e.message}";
    }
  }
}
