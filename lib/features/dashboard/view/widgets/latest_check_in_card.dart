import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_images.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/features/dashboard/constants/dashboard_strings.dart';

class LatestCheckInCard extends StatelessWidget {
  const LatestCheckInCard({super.key});

  static const List<String> _analysisImages = [
    AppImages.frontView,
    AppImages.sideView,
    AppImages.backView,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
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
          const Text(
            DashboardStrings.latestAnalysis,
            style: AppTextStyles.dashboardMetricValue,
          ),
          const SizedBox(height: 4),
          Text(
            DashboardStrings.latestAnalysisDate,
            style: AppTextStyles.dashboardMetricLabel,
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(_analysisImages.length, (index) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index < _analysisImages.length - 1 ? 10 : 0,
                  ),
                  child: _AnalysisImage(imagePath: _analysisImages[index]),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _AnalysisImage extends StatelessWidget {
  const _AnalysisImage({required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 152,
        color: AppColors.progressInactive,
        child: Image.asset(
          imagePath,
          height: 152,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
