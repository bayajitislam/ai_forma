import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/check_in/constants/check_in_strings.dart';
import 'package:ai_forma/features/check_in/view/widgets/check_in_header.dart';

class AnalysisCompleteView extends StatelessWidget {
  const AnalysisCompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const CheckInHeader(),
              const Spacer(),
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColors.brandTeal.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const AppIcon(
                  icon: AppIcons.star,
                  size: 40,
                  color: AppColors.brandTeal,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                CheckInStrings.completeTitle,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 12),
              const Text(
                CheckInStrings.completeSubtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.authBody,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatColumn(
                    label: CheckInStrings.checkInLabel,
                    value: CheckInStrings.checkInNumber,
                  ),
                  _StatColumn(
                    label: CheckInStrings.currentStreakLabel,
                    value: CheckInStrings.streakValue,
                  ),
                  _StatColumn(
                    label: CheckInStrings.momentumLabel,
                    value: CheckInStrings.momentumValue,
                    suffix: '/100',
                    highlight: true,
                  ),
                ],
              ),
              const Spacer(),
              PrimaryButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                label: CheckInStrings.viewResults,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
    required this.label,
    required this.value,
    this.suffix,
    this.highlight = false,
  });

  final String label;
  final String value;
  final String? suffix;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.dashboardMetricLabel),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: highlight ? AppColors.brandTeal : AppColors.textPrimary,
              ),
            ),
            if (suffix != null)
              Text(
                suffix!,
                style: const TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
