import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/dashboard/controllers/weight_controller.dart';
import 'package:ai_forma/features/dashboard/view/widgets/weight_entry_bottom_sheet.dart';
import 'package:intl/intl.dart';

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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'AiFORMA',
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'Weight Trends',
                      style: AppTextStyles.authSectionTitle,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Track your weight over time and monitor your progress.',
                      style: AppTextStyles.authBody,
                    ),
                    const SizedBox(height: 24),
                    _buildTimeRangeSelector(controller),
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
                          'Weight History',
                          style: AppTextStyles.featureTitle,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'View all',
                            style: TextStyle(color: AppColors.brandTeal),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Obx(() => _buildHistoryList(controller, context)),
                  ],
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
                label: 'UPDATE WEIGHT',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRangeSelector(WeightController controller) {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: TimeRange.values.map((range) {
          final isSelected = controller.selectedRange.value == range;
          String label = '';
          switch (range) {
            case TimeRange.week1:
              label = '1W';
              break;
            case TimeRange.month1:
              label = '1M';
              break;
            case TimeRange.month3:
              label = '3M';
              break;
            case TimeRange.month6:
              label = '6M';
              break;
            case TimeRange.year1:
              label = '1Y';
              break;
          }
          return Expanded(
            child: GestureDetector(
              onTap: () => controller.setTimeRange(range),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.brandTeal : AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? AppColors.brandTeal : AppColors.border,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildChart(WeightController controller) {
    final data = controller.chartData;
    if (data.isEmpty) {
      return const Center(child: Text('No data for this period.'));
    }

    final spots = data
        .map(
          (e) => FlSpot(e.date.millisecondsSinceEpoch.toDouble(), e.weightKg),
        )
        .toList();
    final minX = spots.first.x;
    final maxX = spots.last.x;

    double minY =
        data.map((e) => e.weightKg).reduce((a, b) => a < b ? a : b) - 2;
    double maxY =
        data.map((e) => e.weightKg).reduce((a, b) => a > b ? a : b) + 2;

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
              interval: maxX == minX ? 1 : (maxX - minX) / 4,
              getTitlesWidget: (value, meta) {
                if (value == maxX || value == minX) {
                  return const SizedBox.shrink();
                }
                final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    DateFormat('MMM d').format(date),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.left,
                );
              },
              reservedSize: 42,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: minX,
        maxX: maxX,
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: false,
            color: AppColors.brandTeal,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.brandTeal.withValues(alpha: 0.1),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            // Use getTooltipColor instead of tooltipBgColor
            getTooltipColor: (touchedSpot) => AppColors.brandTeal,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((LineBarSpot touchedSpot) {
                final date = DateTime.fromMillisecondsSinceEpoch(
                  touchedSpot.x.toInt(),
                );
                return LineTooltipItem(
                  '${touchedSpot.y.toStringAsFixed(1)} kg\n',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: DateFormat('MMM d, yyyy').format(date),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                );
              }).toList();
            },
          ),
          handleBuiltInTouches: true,
        ),
      ),
    );
  }

  Widget _buildHistoryList(WeightController controller, BuildContext context) {
    final records = controller.records;
    if (records.isEmpty) {
      return const Text('No history available.');
    }

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: records.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, color: AppColors.border),
        itemBuilder: (context, index) {
          final record = records[index];
          return ListTile(
            leading: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.brandTeal,
                shape: BoxShape.circle,
              ),
            ),
            title: Text(
              DateFormat('MMM d, yyyy').format(record.date),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            subtitle: Text(
              DateFormat('h:mm a').format(record.date),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${record.weightKg.toStringAsFixed(1)} kg',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ],
            ),
            onTap: () {
              WeightEntryBottomSheet.show(context, record: record);
            },
          );
        },
      ),
    ),
  );
  }
}
