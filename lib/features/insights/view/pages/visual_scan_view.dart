import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_images.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/features/insights/constants/insights_strings.dart';
import 'package:ai_forma/features/insights/models/compare_result_model.dart';
import 'package:ai_forma/features/insights/view/pages/comparison_summary_view.dart';
import 'package:ai_forma/features/insights/view/widgets/visual_scan_compare_slider.dart';

class VisualScanView extends StatelessWidget {
  const VisualScanView({
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

  @override
  Widget build(BuildContext context) {
    final beforeImage = (result?.then?.frontImageUrl != null && result!.then!.frontImageUrl!.isNotEmpty)
        ? result!.then!.frontImageUrl!
        : (result?.then?.frontThumbUrl != null && result!.then!.frontThumbUrl!.isNotEmpty)
            ? result!.then!.frontThumbUrl!
            : thenScan.imageAsset;

    final afterImage = (result?.now?.frontImageUrl != null && result!.now!.frontImageUrl!.isNotEmpty)
        ? result!.now!.frontImageUrl!
        : (result?.now?.frontThumbUrl != null && result!.now!.frontThumbUrl!.isNotEmpty)
            ? result!.now!.frontThumbUrl!
            : nowScan.imageAsset;

    final beforeLabel = result?.then?.scanDate ?? thenScan.shortDate;
    final afterLabel = result?.now?.scanDate ?? nowScan.shortDate;

    return Scaffold(
      backgroundColor: AppColors.insightChartBackground,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.maybePop(context),
                      icon: const AppIcon(
                        icon: AppIcons.back,
                        size: 28,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    InsightsStrings.visualScanTitle,
                    style: AppTextStyles.authSectionTitle.copyWith(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: VisualScanCompareSlider(
                beforeImage: beforeImage,
                afterImage: afterImage,
                beforeLabel: beforeLabel,
                afterLabel: afterLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
