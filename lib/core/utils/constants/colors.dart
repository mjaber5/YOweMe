import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (from design)
  static const Color primaryTeal = Color(0xFF2C5F5A);
  static const Color lightGray = Color(0xFFF8F9FA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Accent Colors
  static const Color positiveGreen = Color(0xFF22C55E);
  static const Color negativeRed = Color(0xFFEF4444);
  static const Color neutralBlue = Color(0xFF3B82F6);

  // Text Colors
  static const Color primaryText = Color(0xFF1F2937);
  static const Color secondaryText = Color(0xFF6B7280);
  static const Color lightText = Color(0xFF9CA3AF);

  // Dark Theme Text Colors
  static const Color darkPrimaryText = Color(0xFFE5E7EB);
  static const Color darkSecondaryText = Color(0xFF9CA3AF);
  static const Color darkLightText = Color(0xFF6B7280);

  // Card and Surface Colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color surfaceGray = Color(0xFFF3F4F6);

  // Dark Theme Surface Colors
  static const Color darkCardBackground = Color(0xFF1F2937);
  static const Color darkSurfaceGray = Color(0xFF374151);
  static const Color darkBackground = Color(0xFF111827);

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

  static const LinearGradient darkPrimaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2C5F5A), Color(0xFF1E4A43)],
  );

  // Shadow Colors
  static const Color shadowLight = Color(0x0D000000);
  static const Color shadowMedium = Color(0x1A000000);
  static const Color darkShadowLight = Color(0x26000000);
  static const Color darkShadowMedium = Color(0x40000000);

  // Theme-aware getters
  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBackground
        : lightGray;
  }

  static Color getCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkCardBackground
        : cardBackground;
  }

  static Color getSurfaceColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSurfaceGray
        : surfaceGray;
  }

  static Color getPrimaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkPrimaryText
        : primaryText;
  }

  static Color getSecondaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSecondaryText
        : secondaryText;
  }

  static Color getLightTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkLightText
        : lightText;
  }

  static LinearGradient getPrimaryGradient(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkPrimaryGradient
        : primaryGradient;
  }

  static Color getShadowLight(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkShadowLight
        : shadowLight;
  }

  static Color getShadowMedium(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkShadowMedium
        : shadowMedium;
  }
}
