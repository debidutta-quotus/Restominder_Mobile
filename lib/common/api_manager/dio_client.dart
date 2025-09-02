import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
          // Example: inject BASE token
          // final token = await SecureStorage.getBaseToken();
          // if (token != null) {
          //   options.headers["Authorization"] = "Bearer $token";
          // }
          return handler.next(options);
        },
        onResponse: (response, handler) => handler.next(response),
        onError: (DioException e, handler) => handler.next(e),
      ),
    );
  }

  /// Interceptor for POS API
  static void addPosInterceptors() {
    _posDio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Example: inject POS token / API Key
          final apiKey = dotenv.env['API_KEY'];
          if (apiKey != null) {
            options.headers["x-api-key"] = apiKey;
          }
          return handler.next(options);
        },
        onResponse: (response, handler) => handler.next(response),
        onError: (DioException e, handler) => handler.next(e),
      ),
    );
  }

  static Dio get baseInstance => _baseDio;
  static Dio get posInstance => _posDio;
}
