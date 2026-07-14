import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';

abstract final class AppTextStyles {
  static const TextStyle appName = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  static const TextStyle appNameHighlight = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    color: AppColors.brandTeal,
    letterSpacing: 0.5,
  );

  static const TextStyle splashSubTagline = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: 2.5,
  );

  static const TextStyle splashSlogan = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle splashSloganHighlight = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.brandTeal,
    height: 1.4,
  );

  static const TextStyle tagline = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.accent,
    letterSpacing: 0.5,
  );

  static const TextStyle brandLogo = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  static const TextStyle brandLogoHighlight = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.brandTeal,
    letterSpacing: 0.5,
  );

  static const TextStyle onboardingTitle = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle onboardingTitleHighlight = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.brandTeal,
    height: 1.2,
  );

  static const TextStyle onboardingSubtitle = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle featureTitle = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle featureDescription = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.1,
  );

  static const TextStyle primaryButton = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.onPrimary,
    letterSpacing: 1.2,
  );

  static const TextStyle privacyCardLabel = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle fieldLabel = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle fieldInput = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle fieldHint = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle authSectionTitle = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle authBody = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle authLink = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.brandTeal,
  );

  static const TextStyle requirementLabel = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.brandTeal,
  );

  static const TextStyle requirementTitle = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle codeInput = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle successTitle = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle dashboardSectionLabel = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.brandTeal,
    letterSpacing: 1.2,
  );

  static const TextStyle dashboardCardTitle = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.onPrimary,
    height: 1.3,
  );

  static const TextStyle dashboardMetricLabel = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const TextStyle dashboardMetricValue = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle navLabel = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );
}
