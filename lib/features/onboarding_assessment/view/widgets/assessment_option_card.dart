import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';

class AssessmentOptionCard extends StatelessWidget {
  const AssessmentOptionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 140,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.selectedCardBackground
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.brandTeal : AppColors.cardBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppIcon(
                    icon: icon,
                    size: 40,
                    color: isSelected
                        ? AppColors.brandTeal
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    label,
                    style: AppTextStyles.featureTitle.copyWith(
                      color: isSelected
                          ? AppColors.brandTeal
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Positioned(
                top: 10,
                right: 10,
                child: _SelectedBadge(),
              ),
          ],
        ),
      ),
    );
  }
}

class _SelectedBadge extends StatelessWidget {
  const _SelectedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        color: AppColors.brandTeal,
        shape: BoxShape.circle,
      ),
      child: const AppIcon(
        icon: AppIcons.check,
        size: 14,
        color: AppColors.onPrimary,
      ),
    );
  }
}
