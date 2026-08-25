import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/constants/app_images.dart';
import 'package:ai_forma/core/widgets/app_cached_image.dart';

class CompareScanCard extends StatelessWidget {
  const CompareScanCard({
    super.key,
    this.imageAsset,
    this.imageUrl,
    required this.date,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final String? imageAsset;
  final String? imageUrl;
  final String date;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.selectedCardBackground
              : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.brandTealDark : AppColors.cardBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 48,
                height: 64,
                color: AppColors.insightChartBackground,
                child: (imageUrl != null && imageUrl!.isNotEmpty)
                    ? AppCachedNetworkImage(
                        imageUrl: imageUrl!,
                        fit: BoxFit.contain,
                        errorWidget: Image.asset(
                          imageAsset ?? AppImages.frontView,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        imageAsset ?? AppImages.frontView,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: AppTextStyles.featureTitle.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppTextStyles.featureDescription),
                  ],
                ],
              ),
            ),
            if (isSelected)
              const AppIcon(
                icon: AppIcons.checkCircleFill,
                size: 24,
                color: AppColors.brandTealDark,
              )
            else
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.cardBorder,
                    width: 1.5,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
