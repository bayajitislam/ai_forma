import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_images.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/core/widgets/app_shimmer.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/check_in/view/widgets/check_in_header.dart';
import 'package:ai_forma/features/insights/constants/insights_strings.dart';
import 'package:ai_forma/features/insights/models/compare_result_model.dart';
import 'package:ai_forma/features/insights/view/pages/visual_scan_view.dart';
import 'package:ai_forma/features/shell/view/utils/shell_navigation.dart';

class ComparisonScanData {
  const ComparisonScanData({required this.shortDate, required this.imageAsset});

  final String shortDate;
  final String imageAsset;
}

class ComparisonSummaryView extends StatelessWidget {
  const ComparisonSummaryView({
    super.key,
    this.result,
    this.thenScan = const ComparisonScanData(
      shortDate: InsightsStrings.scanShortMay4,
      imageAsset: AppImages.frontView,
    ),
    this.nowScan = const ComparisonScanData(
      shortDate: InsightsStrings.scanShortMay18,
      imageAsset: AppImages.sideView,
    ),
  });

  final CompareResultResponseModel? result;
  final ComparisonScanData thenScan;
  final ComparisonScanData nowScan;

  String _formatDelta(String? rawVal, String suffix) {
    if (rawVal == null || rawVal.isEmpty) return '--';
    final numVal = double.tryParse(rawVal);
    if (numVal != null && numVal > 0 && !rawVal.startsWith('+')) {
      return '+$rawVal$suffix';
    }
    return '$rawVal$suffix';
  }

  @override
  Widget build(BuildContext context) {
    final titleText = (result?.title.isNotEmpty ?? false)
        ? result!.title
        : InsightsStrings.comparisonTitle(
            thenScan.shortDate,
            nowScan.shortDate,
          );

    final thenDate = result?.then?.scanDate ?? thenScan.shortDate;
    final thenImageUrl = result?.then?.frontImageUrl ?? result?.then?.frontThumbUrl;

    final nowDate = result?.now?.scanDate ?? nowScan.shortDate;
    final nowImageUrl = result?.now?.frontImageUrl ?? result?.now?.frontThumbUrl;

    final bodyFatChangeStr = _formatDelta(result?.deltas?.bodyFatPercent, '%');
    final muscleChangeStr = _formatDelta(result?.deltas?.muscleMassKg, ' kg');
    final weightChangeStr = _formatDelta(result?.deltas?.weightKg, ' kg');

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: CheckInHeader(),
            ),
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
                            titleText,
                            style: AppTextStyles.authSectionTitle.copyWith(
                              fontSize: 22,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => navigateToAppShell(context),
                          child: const AppIcon(
                            icon: AppIcons.home,
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
                            imageUrl: thenImageUrl,
                            imageAsset: thenScan.imageAsset,
                            date: thenDate,
                            label: InsightsStrings.comparisonThen,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 90,
                            left: 8,
                            right: 8,
                          ),
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
                            imageUrl: nowImageUrl,
                            imageAsset: nowScan.imageAsset,
                            date: nowDate,
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
                    _ComparisonMetricRow(
                      label: InsightsStrings.comparisonBodyFat,
                      value: bodyFatChangeStr,
                    ),
                    const Divider(height: 1, color: AppColors.cardBorder),
                    _ComparisonMetricRow(
                      label: InsightsStrings.comparisonMuscleMass,
                      value: muscleChangeStr,
                    ),
                    const Divider(height: 1, color: AppColors.cardBorder),
                    _ComparisonMetricRow(
                      label: InsightsStrings.comparisonWeight,
                      value: weightChangeStr,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: PrimaryButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          VisualScanView(thenScan: thenScan, nowScan: nowScan),
                    ),
                  );
                },
                label: InsightsStrings.slideCompare,
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
    this.imageUrl,
    required this.imageAsset,
    required this.date,
    required this.label,
  });

  final String? imageUrl;
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: (imageUrl != null && imageUrl!.isNotEmpty)
                        ? AppShimmerImage(
                            imageUrl: imageUrl!,
                            fit: BoxFit.contain,
                            errorWidget: Image.asset(imageAsset, fit: BoxFit.contain),
                          )
                        : Image.asset(imageAsset, fit: BoxFit.contain),
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
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _ComparisonMetricRow extends StatelessWidget {
  const _ComparisonMetricRow({required this.label, required this.value});

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
