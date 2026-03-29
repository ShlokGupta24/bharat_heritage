import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFC0C1FF);
  static const Color primaryContainer = Color(0xFF2E3192);
  static const Color onPrimary = Color(0xFF1E2084);
  static const Color onPrimaryContainer = Color(0xFF9DA1FF);
  
  static const Color secondary = Color(0xFFFFB4A5);
  static const Color secondaryContainer = Color(0xFF802918);
  static const Color onSecondary = Color(0xFF611205);
  
  static const Color tertiary = Color(0xFFFFB77A);
  static const Color tertiaryContainer = Color(0xFF613300);
  static const Color onTertiary = Color(0xFF4C2700);

  static const Color surface = Color(0xFF131319);
  static const Color surfaceVariant = Color(0xFF34343B);
  static const Color surfaceContainerLow = Color(0xFF1B1B21);
  static const Color surfaceContainerLowest = Color(0xFF0E0E14);
  static const Color surfaceContainer = Color(0xFF1F1F25);
  static const Color surfaceContainerHigh = Color(0xFF2A2930);
  static const Color surfaceContainerHighest = Color(0xFF34343B);
  
  static const Color onSurface = Color(0xFFE4E1EA);
  static const Color onSurfaceVariant = Color(0xFFC7C5D4);
  
  static const Color outline = Color(0xFF908F9D);
  static const Color outlineVariant = Color(0xFF464652);
  
  static const Color error = Color(0xFFFFB4AB);
  
  static Gradient primaryGradient = const LinearGradient(
    colors: [primary, primaryContainer],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppColors.surface,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryContainer,
        secondary: AppColors.secondary,
        secondaryContainer: AppColors.secondaryContainer,
        tertiary: AppColors.tertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        error: AppColors.error,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
      ),
      // To be updated after adding google_fonts
      textTheme: const TextTheme(),
    );
  }
}
