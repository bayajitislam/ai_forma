import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/features/dashboard/constants/dashboard_strings.dart';

class TodaysPriorityCard extends StatelessWidget {
  const TodaysPriorityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
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
          Row(
            children: [
              Icon(AppIcons.connector, size: 18, color: AppColors.brandTeal),
              const SizedBox(width: 8),
              Text(
                DashboardStrings.todaysPriority,
                style: AppTextStyles.featureTitle.copyWith(
                  color: AppColors.brandTeal,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.92,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            DashboardStrings.todaysPriorityBody,
            style: AppTextStyles.authBody.copyWith(
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
