import 'package:flutter/material.dart';

abstract class AppTheme {
  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    primaryColor: const Color(0xFF1A3C34), // Dark teal
    scaffoldBackgroundColor: const Color(0xFFF5F7FA), // Light grayish blue
    colorScheme: const ColorScheme.light().copyWith(
      primary: const Color(0xFF1A3C34),
      secondary: const Color(0xFF007BFF), // Blue
      surfaceTint: const Color(0xFF28A745), // Green
      error: Color(0xFFDC3545), // Red
      onSurface: Color(0xFF6C757D), // Gray
    ),
    cardColor: const Color(0xFFFFFFFF), // White
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF007BFF), // Blue button
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF1A3C34)),
      bodyMedium: TextStyle(color: Color(0xFF6C757D)),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    primaryColor: const Color(0xFFA3BABA), // Light teal
    scaffoldBackgroundColor: const Color(0xFF1E2A32), // Dark grayish blue
    colorScheme: const ColorScheme.dark().copyWith(
      primary: Color(0xFFA3BABA),
      secondary: Color(0xFF4DA8DA), // Lighter blue
      error: Color(0xFFE06C75), // Softer red
      onSurface: Color(0xFFA9ADB4), // Light gray
    ),
    cardColor: const Color(0xFF2D3A3E), // Dark slate
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF4DA8DA), // Lighter blue button
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFFA3BABA)),
      bodyMedium: TextStyle(color: Color(0xFFA9ADB4)),
    ),
  );
}
