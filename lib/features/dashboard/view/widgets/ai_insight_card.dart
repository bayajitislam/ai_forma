import 'package:ai_forma/features/dashboard/constants/dashboard_strings.dart';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';

class AiInsightCard extends StatelessWidget {
  final void Function()? goInsightPage;
  const AiInsightCard({super.key, required this.goInsightPage});

  static const Color _cardBackground = Color(0xFF081012);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const RadialGradient(
          center: Alignment(0.7, 0.6),
          radius: 1,
          colors: [Color.fromARGB(255, 48, 113, 106), _cardBackground],
          stops: [0.0, 1],
        ),
      ),
      child: Stack(
        children: [
          // Background icon — bottom right
          Positioned(
            right: 16,
            bottom: 12,
            child: AppIcon(
              icon: AppIcons.user,
              size: 96,
              color: AppColors.brandTeal.withValues(alpha: 0.18),
            ),
          ),
          // Foreground content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DashboardStrings.aiInsight,
                  style: AppTextStyles.dashboardSectionLabel.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  DashboardStrings.aiInsightBody,
                  style: const TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onPrimary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: goInsightPage,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DashboardStrings.viewAnalysis,
                        style: const TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onPrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const AppIcon(
                        icon: AppIcons.arrowRight,
                        size: 16,
                        color: AppColors.onPrimary,
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
