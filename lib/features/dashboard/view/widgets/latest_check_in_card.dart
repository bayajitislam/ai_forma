import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/features/dashboard/constants/dashboard_strings.dart';

class LatestCheckInCard extends StatelessWidget {
  const LatestCheckInCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            DashboardStrings.latestAnalysis,
            style: AppTextStyles.dashboardMetricValue,
          ),
          const SizedBox(height: 4),
          Text(
            DashboardStrings.latestAnalysisDate,
            style: AppTextStyles.dashboardMetricLabel,
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(3, (index) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index < 2 ? 10 : 0,
                  ),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.progressInactive,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: AppIcon(
                        icon: AppIcons.bodyScan,
                        size: 36,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
