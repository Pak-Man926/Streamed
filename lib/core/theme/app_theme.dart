import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkAccent,
        onPrimary: AppColors.darkAccentText,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkText,
        outline: AppColors.darkLine,
      ),
      textTheme: TextTheme(
        bodyMedium: AppTypography.dmSans(
          color: AppColors.darkText,
          fontSize: 14,
        ),
        bodySmall: AppTypography.dmSans(
          color: AppColors.darkMuted,
          fontSize: 12,
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBg,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightAccent,
        onPrimary: AppColors.lightAccentText,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightText,
        outline: AppColors.lightLine,
      ),
      textTheme: TextTheme(
        bodyMedium: AppTypography.dmSans(
          color: AppColors.lightText,
          fontSize: 14,
        ),
        bodySmall: AppTypography.dmSans(
          color: AppColors.lightMuted,
          fontSize: 12,
        ),
      ),
    );
  }
}
