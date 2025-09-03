import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/token_service.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

class DioClient {
  static final Dio _baseDio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL'] ?? "https://restominder.trip-swift.ai/api/v1",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  static final Dio _posDio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['POS_URL'] ?? "https://pos-restominder.trip-swift.ai/api/v1",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  /// Interceptor for BASE API
  static void addBaseInterceptors() {
    _baseDio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('BASE API request: ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('BASE API response: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          debugPrint('BASE API error: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  /// Interceptor for POS API
  static void addPosInterceptors() {
    _posDio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          debugPrint('POS API request: ${options.uri}');
          // Inject POS token
          final tokenService = TokenService();
          final token = await tokenService.getToken();
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
            debugPrint('Token attached to POS request: $token');
          } else {
            debugPrint('No token found for POS request');
          }
          debugPrint('POS request headers: ${options.headers}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('POS API response: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          debugPrint('POS API error: ${e.message}, Status: ${e.response?.statusCode}, Response: ${e.response?.data}');
          return handler.next(e);
        },
      ),
    );
  }

  static Dio get baseInstance => _baseDio;
  static Dio get posInstance => _posDio;
}
