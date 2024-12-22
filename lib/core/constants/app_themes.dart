import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppThemes {
  static ThemeData get light => ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        cardTheme: const CardTheme(
          color: AppColors.cardBackground,
          elevation: 2,
        ),
      );
}
