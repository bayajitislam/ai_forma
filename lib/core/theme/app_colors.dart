import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color primary = Color(0xFF1B5E5E);
  static const Color background = Color(0xFF0F2E2E);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF1A1A1A);
  static const Color accent = Color(0xFF4DB6AC);

  static const Color brandTeal = Color(0xFF00B5AD);
  static const Color brandTealDark = Color(0xFF14968D);
  static const Color brandTealLight = Color(0xFF1AC9BD);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color onboardingBackground = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFDBDBDB);
  static const Color inputBorder = Color(0xFFE0E0E0);
  static const Color progressInactive = Color(0xFFE8E8E8);
  static const Color iconBackground = Color(0xFFE8F7F6);
  static const Color selectedCardBackground = Color(0xFFE8F7F6);

  static const Color dashboardBackground = Color(0xFFF5F5F5);
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkCardText = Color(0xFFB0B0B0);
  static const Color navInactive = Color(0xFF9E9E9E);

  static const Color splashBackground = Color(0xFFFFFFFF);

  static const LinearGradient primaryButtonGradient = LinearGradient(
    colors: [brandTealDark, brandTealLight],
  );
}
