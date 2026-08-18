import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color primary = Color(0xFF1B5E5E);
  static const Color background = Color(0xFF0F2E2E);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF1A1A1A);
  static const Color accent = Color(0xFF4DB6AC);
  static const Color transparent = Color(0x00000000);

  static const Color brandTeal = Color(0xFF00B5AD);
  static const Color brandTealDark = Color(0xFF14968D);
  static const Color brandTealLight = Color(0xFF1AC9BD);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color onboardingBackground = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFDBDBDB);
  static const Color border = Color(0xFFF3F4F6);
  static const Color inputBorder = Color(0xFFE0E0E0);
  static const Color progressInactive = Color(0xFFE8E8E8);
  static const Color iconBackground = Color(0xFFE8F7F6);
  static const Color selectedCardBackground = Color(0xFFE8F7F6);

  static const Color dashboardBackground = Color(0xFFF5F5F5);
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkCardText = Color(0xFFB0B0B0);
  static const Color navInactive = Color(0xFF9E9E9E);
  static const Color cameraBackground = Color(0xFF000000);
  static const Color insightWarning = Color(0xFFE67E22);

  static const Color insightDetailBackground = Color(0x80F9FAFB);
  static const Color insightIconBackground = Color(0x1A14968D);
  static const Color cardShadow = Color(0x0D000000);
  static const Color insightBadgePositiveBg = Color(0xFFE8F7F6);
  static const Color insightBadgeWarningBg = Color(0xFFFFF3E6);
  static const Color insightChartBackground = Color(0xFFF5F5F5);
  static const Color insightAnalysisBackground = Color(0xFFF5FAFA);
  static const Color insightPrioritiesBackground = Color(0xFFEEF7F5);
  static const Color insightAnalysisTitle = Color(0xFF111827);
  static const Color insightAnalysisBody = Color(0xFF374151);
  static const Color insightAnalysisCardBorder = Color(0xFFE5E7EB);
  static const Color insightAnalysisDivider = Color(0xFFE5E7EB);
  static const Color insightAnalysisIconBg = Color(0xFF111827);

  static const Color insightConsistencyCompleteBg = Color(0xFFE8F7F6);
  static const Color insightConsistencyCompleteIcon = Color(0xFF14968D);
  static const Color insightConsistencyIncompleteBg = Color(0xFFFFFFFF);
  static const Color insightConsistencyIncompleteIcon = Color(0xFFD1D5DB);
  static const Color visualScanDatePill = Color(0xFF4A4A4A);

  static const Color splashBackground = Color(0xFFFFFFFF);
  static const Color assessmentInfoBannerBg = Color(0xFFFFF5F5);

  static const LinearGradient primaryButtonGradient = LinearGradient(
    colors: [brandTealDark, brandTealLight],
  );
}
