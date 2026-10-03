import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/utils/app_date_formatter.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/dashboard/constants/dashboard_strings.dart';
import 'package:ai_forma/features/dashboard/controllers/weight_controller.dart';
import 'package:ai_forma/features/dashboard/view/widgets/weight_entry_bottom_sheet.dart';
import 'package:ai_forma/features/dashboard/view/widgets/weight_history_list.dart';
import 'package:ai_forma/features/dashboard/view/widgets/weight_time_range_selector.dart';

class WeightTrendsView extends StatelessWidget {
  const WeightTrendsView({super.key});

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
          ),
          onPressed: Get.back,
        ),
        title: const Text(
          DashboardStrings.appTitle,
          style: TextStyle(
            color: AppColors.brandTeal,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.fetchWeightTrends(
                  range: controller.selectedRange.value,
                ),
                color: AppColors.brandTeal,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        DashboardStrings.weightTrendsTitle,
                        style: AppTextStyles.authSectionTitle,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        DashboardStrings.weightTrendsSubtitle,
                        style: AppTextStyles.authBody,
                      ),
                      const SizedBox(height: 24),
                      Obx(
                        () => WeightTimeRangeSelector(
                          selectedRange: controller.selectedRange.value,
                          onRangeSelected: controller.setTimeRange,
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        height: 250,
                        child: Obx(() => _buildChart(controller)),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            DashboardStrings.weightHistory,
                            style: AppTextStyles.featureTitle,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              DashboardStrings.viewAll,
                              style: TextStyle(color: AppColors.brandTeal),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: PrimaryButton(
                onPressed: () {
                  WeightEntryBottomSheet.show(
                    context,
                    initialWeightKg: controller.currentWeight?.weightKg,
                  );
                },
                label: DashboardStrings.updateWeight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(WeightController controller) {
    final data = controller.chartData;
    if (data.isEmpty) {
      return const Center(
        child: Text(DashboardStrings.noDataForPeriod),
      );
    }

    final spots = List.generate(
      data.length,
      (i) => FlSpot(i.toDouble(), data[i].weightKg),
    );
    const minX = 0.0;
    final maxX = (data.length - 1).toDouble();

    final double rawMinY =
        data.map((e) => e.weightKg).reduce((a, b) => a < b ? a : b);
    final double rawMaxY =
        data.map((e) => e.weightKg).reduce((a, b) => a > b ? a : b);

    final double minY;
    final double maxY;
    if (rawMinY == rawMaxY) {
      minY = rawMinY - 1.0;
      maxY = rawMaxY + 1.0;
    } else {
      final pad = (rawMaxY - rawMinY) * 0.15;
      final effectivePad = pad > 0.5 ? pad : 0.5;
      minY = rawMinY - effectivePad;
      maxY = rawMaxY + effectivePad;
    }

    // Build unique, non-overlapping label map by spot index
    final Map<int, String> labelBySpotIndex = {};
    if (data.length == 1) {
      labelBySpotIndex[0] = DateFormat('d MMM').format(data[0].date);
    } else if (data.length <= 5) {
      String? lastDate;
      for (int i = 0; i < data.length; i++) {
        final dateStr = DateFormat('d MMM').format(data[i].date);
        if (dateStr != lastDate) {
          labelBySpotIndex[i] = dateStr;
          lastDate = dateStr;
        }
      }
    } else {
      const int targetLabels = 4;
      final step = (data.length - 1) / (targetLabels - 1);
      final usedDates = <String>{};
      for (int k = 0; k < targetLabels; k++) {
        final idx = (k * step).round().clamp(0, data.length - 1);
        final dateStr = DateFormat('d MMM').format(data[idx].date);
        if (!usedDates.contains(dateStr)) {
          labelBySpotIndex[idx] = dateStr;
          usedDates.add(dateStr);
        }
      }
    }

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.round();
                if (value == index.toDouble() &&
                    labelBySpotIndex.containsKey(index)) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      labelBySpotIndex[index]!,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: minX,
        maxX: maxX == minX ? minX + 1 : maxX,
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: data.length > 1,
            color: AppColors.brandTeal,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.brandTeal.withValues(alpha: 0.2),
                  AppColors.brandTeal.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => AppColors.brandTeal,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((LineBarSpot touchedSpot) {
                final idx = touchedSpot.x.round().clamp(0, data.length - 1);
                final record = data[idx];
                return LineTooltipItem(
                  '${record.weightKg.toStringAsFixed(1)} ${DashboardStrings.kgUnit}\n',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: AppDateFormatter.toDayMonthYear(record.date),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
