import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (from design)
  static const Color primaryTeal = Color(0xFF2C5F5A);
  static const Color lightGray = Color(0xFFF8F9FA);
  static const Color white = Color(0xFFFFFFFF);

  // Accent Colors
  static const Color positiveGreen = Color(0xFF22C55E);
  static const Color negativeRed = Color(0xFFEF4444);
  static const Color neutralBlue = Color(0xFF3B82F6);

  // Text Colors
  static const Color primaryText = Color(0xFF1F2937);
  static const Color secondaryText = Color(0xFF6B7280);
  static const Color lightText = Color(0xFF9CA3AF);

  // Card and Surface Colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color surfaceGray = Color(0xFFF3F4F6);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2C5F5A), Color(0xFF1E4A43)],
  );

  // Shadow Colors
  static const Color shadowLight = Color(0x0D000000);
  static const Color shadowMedium = Color(0x1A000000);
}
