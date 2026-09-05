import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/features/dashboard/models/home_response_model.dart';
import 'package:flutter/material.dart';

class TodaysPriorityCard extends StatelessWidget {
  const TodaysPriorityCard({
    super.key,
    this.priorityData,
    this.onActionTap,
  });

  final HomeTodayPriorityModel? priorityData;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    if (priorityData == null || priorityData!.text.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final priorityText = priorityData!.text;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.brandTeal,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                "TODAY'S PRIORITY",
                style: AppTextStyles.featureTitle.copyWith(
                  color: AppColors.brandTeal,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            priorityText,
            style: const TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

