import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/assessment_radio_indicator.dart';

class AssessmentRadioTile extends StatelessWidget {
  const AssessmentRadioTile({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    required this.isSelected,
    required this.onTap,
    this.nutritionStyle = false,
  });

  final IconData? icon;
  final String title;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final bool nutritionStyle;

  @override
  Widget build(BuildContext context) {
    final borderWidth = nutritionStyle ? (isSelected ? 2.0 : 1.0) : 2.0;
    final iconBackgroundColor = nutritionStyle
        ? AppColors.iconBackground
        : (isSelected ? AppColors.brandTeal : AppColors.progressInactive);
    final iconColor = nutritionStyle
        ? AppColors.brandTeal
        : (isSelected ? AppColors.onPrimary : AppColors.textSecondary);
    final titleColor = nutritionStyle
        ? AppColors.textPrimary
        : (isSelected ? AppColors.brandTeal : AppColors.textPrimary);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.brandTeal : AppColors.cardBorder,
            width: borderWidth,
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: AppIcon(
                  icon: icon!,
                  size: 22,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 14),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.featureTitle.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: AppTextStyles.featureDescription.copyWith(
                        color:  AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            AssessmentRadioIndicator(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}
