import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:resto_minder/common/services/token_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:resto_minder/features/auth/controller/auth_controller.dart';

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

  static void addPosInterceptors() {
    _posDio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final tokenService = TokenService();
          final token = await tokenService.getToken();
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
            options.headers["x-auth-token"] = token;
            debugPrint('Token attached to POS request: $token');
          } else {
            debugPrint('No token found for POS request');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            debugPrint('Unauthorized: Preparing to redirect to login');
            await AuthController().logout();
            // Use a post-frame callback to ensure navigation happens after async
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final context = navigatorKey.currentContext;
              if (context != null && context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              }
            });
          }
          return handler.next(e);
        },
      ),
    );
  }

  static Dio get baseInstance => _baseDio;
  static Dio get posInstance => _posDio;
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();