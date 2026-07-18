import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/features/timeline/view/widgets/progress_line_chart.dart';

class ProgressTrendSection extends StatelessWidget {
  const ProgressTrendSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Your Progress',
            style: AppTextStyles.featureTitle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.insightAnalysisTitle,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.border,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                // Metrics Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMetricItem(
                      value: '+1.2',
                      unit: ' kg Muscle',
                      color: AppColors.textPrimary,
                    ),
                    _buildMetricItem(
                      value: '-2.3%',
                      unit: ' Body Fat',
                      color: AppColors.brandTeal,
                    ),
                    _buildMetricItem(
                      value: '+8',
                      unit: ' Momentum',
                      color: AppColors.textPrimary,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Trend Line Chart
                const ProgressLineChart(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricItem({
    required String value,
    required String unit,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          unit,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
