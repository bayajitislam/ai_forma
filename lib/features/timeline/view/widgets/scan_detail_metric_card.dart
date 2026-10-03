import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ScanDetailMetricCard extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trendWidget;

  const ScanDetailMetricCard({
    super.key,
    required this.label,
    required this.value,
    this.trendWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.insightConsistencyIncompleteBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.cardBorder.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          ?trendWidget,
        ],
      ),
    );
  }
}

class ScanDetailTrendBadge extends StatelessWidget {
  final String label;
  final bool isPositive;

  const ScanDetailTrendBadge({
    super.key,
    required this.label,
    this.isPositive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isPositive ? AppColors.insightBadgePositiveBg : AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: isPositive ? AppColors.brandTealDark : AppColors.textSecondary,
        ),
      ),
    );
  }
}
