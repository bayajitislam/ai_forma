import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/features/insights/constants/insights_strings.dart';

enum InsightScoreBadgeType {
  positive,
  warning,
  good,
  excellent;

  static InsightScoreBadgeType fromTone(
    String? statusTone,
    String? statusText, {
    InsightScoreBadgeType fallback = InsightScoreBadgeType.positive,
  }) {
    final tone = statusTone?.toLowerCase().trim() ?? '';
    final text = statusText?.toLowerCase().trim() ?? '';

    if (tone == 'warning' ||
        tone == 'needs_attention' ||
        tone == 'attention' ||
        tone == 'negative' ||
        text.contains('warning') ||
        text.contains('attention')) {
      return InsightScoreBadgeType.warning;
    }

    if (tone == 'excellent' || text == 'excellent') {
      return InsightScoreBadgeType.excellent;
    }

    if (tone == 'good' || text == 'good') {
      return InsightScoreBadgeType.good;
    }

    if (text.contains('progressing') || tone == 'positive') {
      return InsightScoreBadgeType.positive;
    }

    return fallback;
  }
}

class InsightScoreSection extends StatelessWidget {
  const InsightScoreSection({
    super.key,
    required this.scoreLabel,
    required this.score,
    required this.badge,
    required this.badgeType,
    required this.summary,
  });

  final String scoreLabel;
  final int score;
  final String badge;
  final InsightScoreBadgeType badgeType;
  final String summary;

  Color get _badgeBackground => switch (badgeType) {
    InsightScoreBadgeType.warning => AppColors.insightBadgeWarningBg,
    InsightScoreBadgeType.positive => AppColors.insightBadgeWarningBg,
    _ => AppColors.insightBadgePositiveBg,
  };

  Color get _badgeTextColor => switch (badgeType) {
    InsightScoreBadgeType.warning => AppColors.insightWarning,
    InsightScoreBadgeType.positive => AppColors.insightWarning,
    _ => AppColors.brandTealDark,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(scoreLabel, style: AppTextStyles.featureDescription),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  '$score',
                  style: const TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6, left: 2),
                  child: Text(
                    InsightsStrings.outOfHundred,
                    style: AppTextStyles.featureDescription.copyWith(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _badgeBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _badgeTextColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(summary, style: AppTextStyles.featureDescription),
      ],
    );
  }
}
