import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_images.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/features/check_in/view/widgets/check_in_header.dart';
import 'package:ai_forma/features/insights/constants/insights_strings.dart';
import 'package:ai_forma/features/insights/view/pages/visual_scan_view.dart';

class ComparisonScanData {
  const ComparisonScanData({
    required this.shortDate,
    required this.imageAsset,
  });

  final String shortDate;
  final String imageAsset;
}

class ComparisonSummaryView extends StatelessWidget {
  const ComparisonSummaryView({
    super.key,
    this.thenScan = const ComparisonScanData(
      shortDate: InsightsStrings.scanShortMay4,
      imageAsset: AppImages.frontView,
    ),
    this.nowScan = const ComparisonScanData(
      shortDate: InsightsStrings.scanShortMay18,
      imageAsset: AppImages.sideView,
    ),
  });

  final ComparisonScanData thenScan;
  final ComparisonScanData nowScan;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            const CheckInHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            InsightsStrings.comparisonTitle(
                              thenScan.shortDate,
                              nowScan.shortDate,
                            ),
                            style: AppTextStyles.authSectionTitle.copyWith(
                              fontSize: 22,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (_) => VisualScanView(
                                  thenScan: thenScan,
                                  nowScan: nowScan,
                                ),
                              ),
                            );
                          },
                          child: const AppIcon(
                            icon: AppIcons.layoutColumn,
                            size: 22,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _ComparisonImageCard(
                            imageAsset: thenScan.imageAsset,
                            date: thenScan.shortDate,
                            label: InsightsStrings.comparisonThen,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 90, left: 8, right: 8),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: AppColors.brandTealDark,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: AppIcon(
                                icon: AppIcons.arrowRightLine,
                                size: 18,
                                color: AppColors.surface,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: _ComparisonImageCard(
                            imageAsset: nowScan.imageAsset,
                            date: nowScan.shortDate,
                            label: InsightsStrings.comparisonNow,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      InsightsStrings.aiComparisonSummary,
                      style: AppTextStyles.authSectionTitle.copyWith(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const _ComparisonMetricRow(
                      label: InsightsStrings.comparisonBodyFat,
                      value: InsightsStrings.comparisonBodyFatChange,
                    ),
                    const Divider(height: 1, color: AppColors.cardBorder),
                    const _ComparisonMetricRow(
                      label: InsightsStrings.comparisonMuscleMass,
                      value: InsightsStrings.comparisonMuscleMassChange,
                    ),
                    const Divider(height: 1, color: AppColors.cardBorder),
                    const _ComparisonMetricRow(
                      label: InsightsStrings.comparisonWeight,
                      value: InsightsStrings.comparisonWeightChange,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComparisonImageCard extends StatelessWidget {
  const _ComparisonImageCard({
    required this.imageAsset,
    required this.date,
    required this.label,
  });

  final String imageAsset;
  final String date;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 210,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.insightChartBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                  child: Image.asset(
                    imageAsset,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  date,
                  style: const TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            fontFamily: AppFonts.family,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _ComparisonMetricRow extends StatelessWidget {
  const _ComparisonMetricRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.featureDescription.copyWith(fontSize: 15),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.brandTealDark,
            ),
          ),
        ],
      ),
    );
  }
}
