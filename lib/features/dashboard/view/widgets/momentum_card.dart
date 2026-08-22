import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/features/dashboard/constants/dashboard_strings.dart';
import 'package:ai_forma/features/dashboard/models/home_response_model.dart';

class MomentumCard extends StatelessWidget {
  const MomentumCard({super.key, this.momentumData});

  final HomeMomentumModel? momentumData;

  @override
  Widget build(BuildContext context) {
    final score = momentumData?.displayedScore ?? 82;
    final maxScore = momentumData?.max ?? 100;
    final progressValue = (maxScore > 0) ? (score / maxScore).clamp(0.0, 1.0) : 0.0;

    final changeVal = momentumData?.change;
    final changeBadgeText = changeVal != null
        ? (changeVal > 0 ? '+$changeVal this week' : '$changeVal this week')
        : DashboardStrings.momentumBadge;

    final stateTitle = (momentumData?.stateLabel.isNotEmpty ?? false)
        ? momentumData!.stateLabel
        : DashboardStrings.momentumTitle;

    final insightText = (momentumData?.insight.isNotEmpty ?? false)
        ? momentumData!.insight
        : DashboardStrings.momentumSubtitle;

    final pills = momentumData?.pills ?? [];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const RadialGradient(
          center: Alignment(0.6, -1.3),
          radius: 1,
          colors: [Color.fromARGB(255, 39, 97, 90), AppColors.darkCard],
          stops: [0.0, 1],
        ),
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
                child: Text(
                  changeBadgeText,
                  style: const TextStyle(
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
                    // Glow layer
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
                        value: progressValue,
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
                          '$score',
                          style: const TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onPrimary,
                            height: 1.0,
                          ),
                        ),
                        Text(
                          '/ $maxScore',
                          style: const TextStyle(
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

              // Title + subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stateTitle,
                      style: AppTextStyles.dashboardCardTitle,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      insightText,
                      style: const TextStyle(
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

          // ── Chips row ──────────────────────────────────────
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: pills.isNotEmpty
                ? pills.map((pill) => _MomentumChip(label: pill.label)).toList()
                : const [
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
          const Icon(
            Icons.check,
            size: 14,
            color: AppColors.brandTealLight,
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
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
