import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:resto_minder/common/api_manager/dio_client.dart';
import 'package:resto_minder/common/services/token_service.dart';
import 'package:resto_minder/features/auth/controller/auth_controller.dart';
import 'package:resto_minder/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  DioClient.addPosInterceptors();
  DioClient.addBaseInterceptors();

  // Check for auto-login
  final tokenService = TokenService();
  final authController = AuthController();

  if (await tokenService.isRememberMeEnabled()) {
    if (await authController.autoLogin()) {
// Ensure AppRoutes.home is defined
    } else {
    }
  } else {
  }

  runApp(MyApp());
}