import 'package:flutter/material.dart';
import 'package:resto_minder/splash_screen.dart';
import 'package:resto_minder/onboard_screens/onboard_screen1.dart';
import 'package:resto_minder/features/auth/screens/login_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const home = '/onboard1';
  static const login = '/login';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    home: (context) => const OnboardScreen1(),
    login: (context) => const LoginScreen(),
  };
}
