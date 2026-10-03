import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/features/timeline/constants/timeline_strings.dart';
import 'package:flutter/material.dart';

class TrendsBaselineCard extends StatelessWidget {
  const TrendsBaselineCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.brandTeal.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.brandTeal.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.info_outline,
              color: AppColors.brandTeal,
              size: 24,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    TimelineStrings.baselineCapturedTitle,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    TimelineStrings.baselineCapturedSubtitle,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
