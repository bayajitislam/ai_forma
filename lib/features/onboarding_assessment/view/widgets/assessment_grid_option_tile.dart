import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';

class AssessmentGridOptionTile extends StatelessWidget {
  const AssessmentGridOptionTile({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.selectedCardBackground
              : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.brandTeal : AppColors.cardBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Center(
                      child: AppIcon(
                        icon: icon,
                        size: 28,
                        color: AppColors.brandTeal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    style: AppTextStyles.featureDescription.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.brandTeal : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.brandTeal
                        : AppColors.cardBorder,
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? const AppIcon(
                        icon: AppIcons.check,
                        size: 11,
                        color: AppColors.onPrimary,
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
