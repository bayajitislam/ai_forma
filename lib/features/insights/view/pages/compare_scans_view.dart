import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_network_error_widget.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/check_in/view/widgets/check_in_header.dart';
import 'package:ai_forma/features/insights/constants/insights_strings.dart';
import 'package:ai_forma/features/insights/controllers/compare_scans_controller.dart';
import 'package:ai_forma/features/insights/repositories/insights_repository.dart';
import 'package:ai_forma/features/insights/view/pages/comparison_summary_view.dart';
import 'package:ai_forma/features/insights/view/widgets/compare_scan_card.dart';
import 'package:intl/intl.dart';

class CompareScansView extends StatelessWidget {
  const CompareScansView({super.key});

  String _formatSubtitle(String scanDateStr) {
    try {
      final parsedDate = DateTime.parse(scanDateStr);
      final now = DateTime.now();
      final diffDays = now.difference(parsedDate).inDays;

      if (diffDays <= 1) return InsightsStrings.latestScanLabel;
      if (diffDays <= 7) return '1 week ago';
      if (diffDays <= 14) return InsightsStrings.twoWeeksAgo;
      if (diffDays <= 30) return InsightsStrings.oneMonthAgo;
      final weeks = (diffDays / 7).round();
      return '$weeks weeks ago';
    } catch (_) {
      return '';
    }
  }

  String _formatDisplayDate(String scanDateStr) {
    try {
      final parsedDate = DateTime.parse(scanDateStr);
      return DateFormat('MMMM d, yyyy').format(parsedDate);
    } catch (_) {
      return scanDateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<CompareScansController>()
        ? Get.find<CompareScansController>()
        : Get.put(
            CompareScansController(
              repository: InsightsRepository(
                Get.isRegistered<DioClient>()
                    ? Get.find<DioClient>()
                    : DioClient(),
              ),
            ),
          );

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Obx(() {
          final isLoading = controller.isLoadingScans.value;
          final error = controller.scansError.value;
          final scans = controller.scansList;
          final selectedIds = controller.selectedIds;
          final canGenerate = selectedIds.length == 2;
          final isComparing = controller.isComparing.value;

          if (isLoading && scans.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.brandTeal),
            );
          }

          if (error.isNotEmpty && scans.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: AppNetworkErrorWidget(
                onRetry: controller.fetchScansList,
                message: error,
              ),
            );
          }

          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CheckInHeader(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        InsightsStrings.compareScansTitle,
                        style: AppTextStyles.authSectionTitle.copyWith(
                          fontSize: 26,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        InsightsStrings.compareScansSubtitle,
                        style: AppTextStyles.featureDescription.copyWith(
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (scans.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Text(
                              'No completed scans available for comparison.',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        )
                      else
                        for (var i = 0; i < scans.length; i++) ...[
                          if (i > 0) const SizedBox(height: 12),
                          CompareScanCard(
                            imageUrl: scans[i].frontThumbUrl,
                            date: _formatDisplayDate(scans[i].scanDate),
                            subtitle: _formatSubtitle(scans[i].scanDate),
                            isSelected: selectedIds.contains(scans[i].id),
                            onTap: () => controller.toggleScanSelection(scans[i].id),
                          ),
                        ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: PrimaryButton(
                  onPressed: canGenerate && !isComparing
                      ? () async {
                          final success = await controller.fetchScanComparison();
                          if (success &&
                              controller.comparisonResult.value != null) {
                            Get.to(
                              () => ComparisonSummaryView(
                                result: controller.comparisonResult.value!,
                              ),
                            );
                          }
                        }
                      : null,
                  label: isComparing
                      ? 'GENERATING...'
                      : InsightsStrings.generateComparison,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
