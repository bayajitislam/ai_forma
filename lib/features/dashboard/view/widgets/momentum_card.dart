import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/features/dashboard/constants/dashboard_strings.dart';

class MomentumCard extends StatelessWidget {
  const MomentumCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DashboardStrings.momentumScore,
                style: AppTextStyles.featureTitle.copyWith(
                  color: AppColors.brandTeal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.brandTeal.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  DashboardStrings.momentumBadge,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.brandTeal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 96,
                height: 96,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 96,
                      height: 96,
                      child: CircularProgressIndicator(
                        value: 0.82,
                        strokeWidth: 8,
                        backgroundColor: AppColors.darkCardText.withValues(
                          alpha: 0.3,
                        ),
                        color: AppColors.brandTeal,
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '82',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onPrimary,
                          ),
                        ),
                        Text(
                          '/ 100',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkCardText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      DashboardStrings.momentumTitle,
                      style: AppTextStyles.dashboardCardTitle,
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      DashboardStrings.momentumSubtitle,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.darkCardText,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: const [
                        _MomentumChip(label: DashboardStrings.momentumChipMuscle),
                        _MomentumChip(label: DashboardStrings.momentumChipFat),
                        _MomentumChip(
                          label: DashboardStrings.momentumChipStreak,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MomentumChip extends StatelessWidget {
  const _MomentumChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.brandTeal.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.brandTeal.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: AppFonts.family,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.brandTeal,
        ),
      ),
    );
  }
}
