import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/features/dashboard/constants/dashboard_strings.dart';
import 'package:ai_forma/features/dashboard/controllers/weight_controller.dart';
import 'package:ai_forma/features/dashboard/view/widgets/weekly_progress_chart.dart';
import 'package:ai_forma/features/dashboard/view/widgets/weight_entry_bottom_sheet.dart';
import 'package:ai_forma/features/dashboard/view/widgets/weight_history_list.dart';
import 'package:ai_forma/features/dashboard/view/widgets/weight_summary_metrics_card.dart';
import 'package:ai_forma/features/dashboard/view/widgets/weight_time_range_selector.dart';

class WeeklyProgressView extends StatelessWidget {
  const WeeklyProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WeightController>();

    return Scaffold(
      backgroundColor: AppColors.dashboardBackground,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: Get.back,
        ),
        title: const Text(
          DashboardStrings.appTitle,
          style: TextStyle(
            color: AppColors.brandTeal,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.info_outline,
              color: AppColors.textPrimary,
              size: 22,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.fetchWeightProgress(
                  range: controller.selectedRange.value,
                ),
                color: AppColors.brandTeal,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        DashboardStrings.weeklyProgressTitle,
                        style: AppTextStyles.authSectionTitle,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        DashboardStrings.weeklyProgressSubtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Time Range Filter Pills
                      Obx(
                        () => WeightTimeRangeSelector(
                          selectedRange: controller.selectedRange.value,
                          onRangeSelected: (range) {
                            controller.setTouchedChartIndex(-1);
                            controller.setTimeRange(range);
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Interactive Line Chart with Touch & Vertical Dotted Line
                      SizedBox(
                        height: 230,
                        child: Obx(
                          () => WeeklyProgressChart(
                            controller: controller,
                            touchedIndex: controller.touchedChartIndex.value,
                            onTouchIndexChanged: controller.setTouchedChartIndex,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 3-Column Summary Cards Block
                      WeightSummaryMetricsCard(controller: controller),

                      const SizedBox(height: 24),

                      // Weight History Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            DashboardStrings.weightHistory,
                            style: AppTextStyles.featureTitle,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              DashboardStrings.viewAll,
                              style: TextStyle(
                                color: AppColors.brandTeal,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Weight History List
                      Obx(
                        () => WeightHistoryList(
                          records: controller.records.toList(),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Fixed Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    WeightEntryBottomSheet.show(
                      context,
                      initialWeightKg: controller.currentWeight?.weightKg,
                    );
                  },
                  icon: const Icon(Icons.add, color: Colors.white, size: 20),
                  label: const Text(
                    DashboardStrings.updateWeight,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      letterSpacing: 1,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandTeal,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
