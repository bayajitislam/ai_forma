import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';

class AssessmentSelectionBadge extends StatelessWidget {
  const AssessmentSelectionBadge({
    super.key,
    required this.selectedCount,
    required this.maxCount,
  });

  final int selectedCount;
  final int maxCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.insightBadgePositiveBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppIcon(
            icon: AppIcons.checkCircleFill,
            size: 14,
            color: AppColors.brandTeal,
          ),
          const SizedBox(width: 6),
          Text(
            '$selectedCount of $maxCount selected',
            style: AppTextStyles.featureDescription.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.brandTeal,
            ),
          ),
        ],
      ),
    );
  }
}
