import 'package:ai_forma/features/dashboard/constants/dashboard_strings.dart';
import 'package:ai_forma/features/dashboard/models/home_response_model.dart';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';

class AiInsightCard extends StatelessWidget {
  final void Function()? goInsightPage;
  final HomeAiInsightModel? aiInsightData;

  const AiInsightCard({
    super.key,
    required this.goInsightPage,
    this.aiInsightData,
  });

  @override
  Widget build(BuildContext context) {
    final bodyText = (aiInsightData?.text?.isNotEmpty ?? false)
        ? aiInsightData!.text!
        : DashboardStrings.aiInsightBody;

    final ctaText = (aiInsightData?.ctaLabel?.isNotEmpty ?? false)
        ? aiInsightData!.ctaLabel!
        : DashboardStrings.viewAnalysis;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.darkCard,
        gradient: const RadialGradient(
          center: Alignment(0.6, -1.3),
          radius: 1,
          colors: [Color.fromARGB(255, 39, 97, 90), AppColors.darkCard],
          stops: [0.0, 1],
        ),
        border: Border.all(
          color: AppColors.brandTeal.withValues(alpha: 0.12),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 10,
            bottom: 6,
            child: AppIcon(
              icon: AppIcons.user,
              size: 56,
              color: AppColors.brandTeal.withValues(alpha: 0.08),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DashboardStrings.aiInsight,
                  style: AppTextStyles.dashboardSectionLabel.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  bodyText,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.onPrimary.withValues(alpha: 1),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: goInsightPage,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        ctaText,
                        style: const TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.brandTealDark,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const AppIcon(
                        icon: AppIcons.arrowRight,
                        size: 14,
                        color: AppColors.brandTealDark,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
