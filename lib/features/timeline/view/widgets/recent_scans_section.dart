import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/constants/app_images.dart';

import 'package:ai_forma/features/timeline/view/pages/scan_detail_view.dart';

class RecentScansSection extends StatelessWidget {
  const RecentScansSection({super.key});

  @override
  Widget build(BuildContext context) {
    final scans = [
      _ScanItem(date: 'May 4', imagePath: AppImages.sideView),
      _ScanItem(date: 'May 11', imagePath: AppImages.sideView),
      _ScanItem(date: 'May 18', imagePath: AppImages.sideView),
      _ScanItem(date: 'May 25', isPlaceholder: true),
    ];

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
            itemCount: scans.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final scan = scans[index];
              return GestureDetector(
                onTap: scan.isPlaceholder
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                ScanDetailView(date: scan.date),
                          ),
                        );
                      },
                child: Column(
                  children: [
                    Container(
                      width: 96,
                      height: 130,
                      decoration: BoxDecoration(
                        color: scan.isPlaceholder
                            ? AppColors.insightConsistencyIncompleteBg
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: scan.isPlaceholder
                              ? AppColors.cardBorder
                              : AppColors.cardBorder.withValues(alpha: 0.5),
                          width: 1,
                        ),
                        boxShadow: scan.isPlaceholder
                            ? null
                            : [
                                BoxShadow(
                                  color: AppColors.cardShadow.withValues(alpha: 0.06),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                      ),
                      child: scan.isPlaceholder
                          ? Center(
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.textSecondary.withValues(
                                      alpha: 0.4,
                                    ),
                                    width: 1.5,
                                  ),
                                ),
                                child: Icon(
                                  Icons.add,
                                  size: 18,
                                  color: AppColors.textSecondary.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                scan.imagePath!,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      scan.date,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: scan.isPlaceholder
                            ? AppColors.textSecondary.withValues(alpha: 0.7)
                            : AppColors.textPrimary,
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

class _ScanItem {
  final String date;
  final String? imagePath;
  final bool isPlaceholder;

  _ScanItem({required this.date, this.imagePath, this.isPlaceholder = false});
}
