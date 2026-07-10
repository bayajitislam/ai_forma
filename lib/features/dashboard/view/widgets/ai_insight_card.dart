import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/features/dashboard/constants/dashboard_strings.dart';

class AiInsightCard extends StatelessWidget {
  const AiInsightCard({super.key});

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
          const Text(
            DashboardStrings.aiInsight,
            style: AppTextStyles.dashboardSectionLabel,
          ),
          const SizedBox(height: 12),
          const Text(
            DashboardStrings.aiInsightBody,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: AppColors.onPrimary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                DashboardStrings.viewAnalysis,
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onPrimary,
                ),
              ),
              const SizedBox(width: 4),
              AppIcon(
                icon: AppIcons.arrowRight,
                size: 16,
                color: AppColors.onPrimary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
