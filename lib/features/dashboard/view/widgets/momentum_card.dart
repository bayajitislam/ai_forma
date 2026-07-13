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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ──────────────────────────────────────────────────
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
              // Badge with arrow + text
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.brandTeal.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.brandTeal.withValues(alpha: 0.25),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      DashboardStrings.momentumBadge,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.brandTeal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Score ring + text block ──────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circular progress ring
              SizedBox(
                width: 96,
                height: 96,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Glow layer (subtle teal halo behind ring)
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.brandTeal.withValues(alpha: 0.18),
                            blurRadius: 18,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    // Track
                    SizedBox(
                      width: 96,
                      height: 96,
                      child: CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 7,
                        backgroundColor: Colors.transparent,
                        color: AppColors.darkCardText.withValues(alpha: 0.18),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    // Fill
                    SizedBox(
                      width: 96,
                      height: 96,
                      child: CircularProgressIndicator(
                        value: 0.82,
                        strokeWidth: 7,
                        backgroundColor: Colors.transparent,
                        color: AppColors.brandTeal,
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    // Center label
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '82',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onPrimary,
                            height: 1.0,
                          ),
                        ),
                        Text(
                          '/ 100',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: 11,
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

              // Title + subtitle + chips
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      DashboardStrings.momentumTitle,
                      style: AppTextStyles.dashboardCardTitle,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      DashboardStrings.momentumSubtitle,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.darkCardText,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Chips row (full-width, evenly spaced) ───────────────────────
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MomentumChip(label: DashboardStrings.momentumChipMuscle),
              _MomentumChip(label: DashboardStrings.momentumChipFat),
              _MomentumChip(label: DashboardStrings.momentumChipStreak),
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
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.brandTeal.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: AppColors.brandTeal.withValues(alpha: 0.28),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Checkmark icon
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: const Icon(
              Icons.check,
              size: 14,
              color: AppColors.brandTealLight,
            ),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
