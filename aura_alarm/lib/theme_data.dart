import 'package:flutter/material.dart';

// 1. Define a custom color class for easy access
class AppColors {
  static const Color background = Color(0xFFF2F4F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF3A415C);
  static const Color textSecondary = Color(0xFF5E6C84);
  static const Color accent = Color(0xFFFFC749);
  static const Color secondHand = Color(0xFFEB5055);
  static const Color darkModeBg = Color(0xFF372F4F);
  static const Color onDarkModeSurface = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFD0D9E3);
}

// 2. Use these colors in your ThemeData
final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.background,
  cardColor: AppColors.surface,

  // Use colorScheme for modern Material 3 theming
  colorScheme: ColorScheme.light(
    primary: AppColors.accent,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    
    // Add dark theme colors if implementing dual modes
    // background: AppColors.darkModeBg, 
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(color: AppColors.textPrimary), // For the main time "04:45 AM"
    bodyLarge: TextStyle(color: AppColors.textSecondary), // For city names
    // ... other text styles
  ),
  // For the dark bottom navigation bar
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.darkModeBg,
    selectedItemColor: AppColors.onDarkModeSurface,
    unselectedItemColor: AppColors.divider, // Using divider color for unselected icons
  ),
);
