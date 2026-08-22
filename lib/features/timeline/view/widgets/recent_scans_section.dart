import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/constants/app_images.dart';
import 'package:ai_forma/core/widgets/app_shimmer.dart';
import 'package:ai_forma/features/timeline/models/timeline_overview_model.dart';

class RecentScansSection extends StatelessWidget {
  const RecentScansSection({
    super.key,
    this.recentScans = const [],
    this.nextScanDate,
    this.onScanTap,
  });

  final List<TimelineRecentScanModel> recentScans;
  final String? nextScanDate;
  final Function(String id)? onScanTap;

  @override
  Widget build(BuildContext context) {
    if (recentScans.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Recent Scans',
            style: AppTextStyles.featureTitle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.insightAnalysisTitle,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 175,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: recentScans.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final scan = recentScans[index];
              final imageUrl =
                  scan.thumbs?.side ?? scan.thumbs?.front ?? scan.thumbs?.back;

              return GestureDetector(
                onTap: () => onScanTap?.call(scan.id),
                child: Column(
                  children: [
                    Container(
                      width: 96,
                      height: 130,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.cardBorder.withValues(alpha: 0.5),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cardShadow.withValues(
                              alpha: 0.06,
                            ),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: imageUrl != null && imageUrl.isNotEmpty
                            ? AppShimmerImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.contain,
                                errorWidget: Image.asset(
                                  AppImages.sideView,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image.asset(
                                AppImages.sideView,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      scan.scanDate,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
