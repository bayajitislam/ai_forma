import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_images.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';

class InsightPostureComparison extends StatelessWidget {
  const InsightPostureComparison({
    super.key,
    required this.beforeLabel,
    required this.afterLabel,
  });

  final String beforeLabel;
  final String afterLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _ComparisonCard(label: beforeLabel)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: AppIcon(
            icon: AppIcons.arrowUpRight,
            size: 20,
            color: AppColors.brandTealDark,
          ),
        ),
        Expanded(child: _ComparisonCard(label: afterLabel)),
      ],
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 180,
          width: 96,
          decoration: BoxDecoration(
            color: AppColors.insightChartBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder),
            boxShadow: const [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              AppImages.frontView,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontFamily: AppFonts.family,
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

enum InsightStatusTone { positive, warning, neutral }

class InsightStatusList extends StatelessWidget {
  const InsightStatusList({super.key, required this.items});

  final List<InsightStatusItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0)
              const Divider(height: 1, color: AppColors.cardBorder),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      items[i].label,
                      style: AppTextStyles.featureTitle.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    items[i].status,
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _toneColor(items[i].tone),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _toneColor(InsightStatusTone tone) => switch (tone) {
        InsightStatusTone.positive => AppColors.brandTealDark,
        InsightStatusTone.warning => AppColors.insightWarning,
        InsightStatusTone.neutral => AppColors.textSecondary,
      };
}

class InsightStatusItem {
  const InsightStatusItem({
    required this.label,
    required this.status,
    required this.tone,
  });

  final String label;
  final String status;
  final InsightStatusTone tone;
}
