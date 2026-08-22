import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/features/insights/constants/insights_strings.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';

class InsightConsistencyGrid extends StatelessWidget {
  const InsightConsistencyGrid({
    super.key,
    this.completedCount = 1,
    this.totalCount = 8,
  });

  final int completedCount;
  final int totalCount;

  static const int _columns = 8;
  static const double _gap = 6;
  static const double _cellRadius = 8;
  static const double _iconSize = 18;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _columns,
        mainAxisSpacing: _gap,
        crossAxisSpacing: _gap,
        childAspectRatio: 1,
      ),
      itemCount: totalCount > 0 ? totalCount : 8,
      itemBuilder: (context, index) {
        final isComplete = index < completedCount;
        return Container(
          decoration: BoxDecoration(
            color: isComplete
                ? AppColors.insightConsistencyCompleteBg
                : AppColors.insightConsistencyIncompleteBg,
            borderRadius: BorderRadius.circular(_cellRadius),
          ),
          child: Center(
            child: AppIcon(
              icon: AppIcons.checkCircle,
              size: _iconSize,
              color: isComplete
                  ? AppColors.insightConsistencyCompleteIcon
                  : AppColors.insightConsistencyIncompleteIcon,
            ),
          ),
        );
      },
    );
  }
}

class InsightConsistencyStatsCard extends StatelessWidget {
  const InsightConsistencyStatsCard({
    super.key,
    this.currentStreak = '1 weeks',
    this.onTimeRate = '100%',
    this.momentumGained = 'N/A',
  });

  final String currentStreak;
  final String onTimeRate;
  final String momentumGained;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _StatRow(
            label: InsightsStrings.currentStreak,
            value: currentStreak,
          ),
          const Divider(height: 1, color: AppColors.cardBorder),
          _StatRow(
            label: InsightsStrings.onTimeRate,
            value: onTimeRate,
          ),
          const Divider(height: 1, color: AppColors.cardBorder),
          _StatRow(
            label: InsightsStrings.momentumGained,
            value: momentumGained,
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.featureDescription),
          Text(
            value,
            style: const TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
