import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    brightness: Brightness.light,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textPrimary),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      iconTheme: IconThemeData(color: AppColors.iconColor),
    ),
    iconTheme: const IconThemeData(color: AppColors.iconColor),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.cursor,
      selectionColor: AppColors.cursor,
      selectionHandleColor: AppColors.cursor,
    ),
  );
}