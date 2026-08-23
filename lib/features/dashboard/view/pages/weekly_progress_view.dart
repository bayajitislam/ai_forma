import 'package:ai_forma/core/models/weight_record.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/features/dashboard/controllers/weight_controller.dart';
import 'package:ai_forma/features/dashboard/view/widgets/weight_entry_bottom_sheet.dart';

class WeeklyProgressView extends StatefulWidget {
  const WeeklyProgressView({super.key});

  @override
  State<WeeklyProgressView> createState() => _WeeklyProgressViewState();
}

class _WeeklyProgressViewState extends State<WeeklyProgressView> {
  int _touchedIndex = -1;

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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'AiFORMA',
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Weekly Progress',
                      style: AppTextStyles.authSectionTitle,
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'See how your weight has changed this week and how you\'re tracking against your goal.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Time Range Filter Pills
                    _buildTimeRangeSelector(controller),

                    const SizedBox(height: 24),

                    // Interactive Line Chart with Touch & Vertical Dotted Line
                    SizedBox(
                      height: 230,
                      child: Obx(() => _buildChart(controller)),
                    ),

                    const SizedBox(height: 24),

                    // 3-Column Summary Cards Block
                    Obx(() => _buildSummaryMetricsCard(controller)),

                    const SizedBox(height: 24),

                    // Weight History Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Weight History',
                          style: AppTextStyles.featureTitle,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'View all',
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
                    Obx(() => _buildHistoryList(controller, context)),

                    const SizedBox(height: 20),
                  ],
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
                    'UPDATE WEIGHT',
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

  Widget _buildTimeRangeSelector(WeightController controller) {
    return Obx(() {
      return Row(
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
              onTap: () {
                setState(() {
                  _touchedIndex = -1;
                });
                controller.setTimeRange(range);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.brandTeal : const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? AppColors.brandTeal : const Color(0xFFEFEFEF),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
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
      return const Center(
        child: Text(
          'No data for this period.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    final spots = data
        .map((e) => FlSpot(e.date.millisecondsSinceEpoch.toDouble(), e.weightKg))
        .toList();
    final minX = spots.first.x;
    final maxX = spots.last.x;

    double minY = data.map((e) => e.weightKg).reduce((a, b) => a < b ? a : b) - 1;
    double maxY = data.map((e) => e.weightKg).reduce((a, b) => a > b ? a : b) + 1;

    // Default to last spot if not manually touched
    final activeIndex = (_touchedIndex >= 0 && _touchedIndex < spots.length)
        ? _touchedIndex
        : spots.length - 1;

    final lineChartBarData = LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.25,
      color: AppColors.brandTeal,
      barWidth: 2.5,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 4,
            color: AppColors.brandTeal,
            strokeWidth: 2,
            strokeColor: Colors.white,
          );
        },
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.brandTeal.withValues(alpha: 0.18),
            AppColors.brandTeal.withValues(alpha: 0.0),
          ],
        ),
      ),
    );

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) => const FlLine(
            color: Color(0xFFF0F0F0),
            strokeWidth: 1,
          ),
        ),
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
              reservedSize: 28,
              interval: maxX == minX ? 1 : (maxX - minX) / 6,
              getTitlesWidget: (value, meta) {
                final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    DateFormat('MMM d').format(date),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
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
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.left,
                );
              },
              reservedSize: 28,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: minX,
        maxX: maxX,
        minY: minY,
        maxY: maxY,
        lineBarsData: [lineChartBarData],
        showingTooltipIndicators: [
          ShowingTooltipIndicators([
            LineBarSpot(lineChartBarData, 0, spots[activeIndex]),
          ]),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          handleBuiltInTouches: true,
          getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
            return spotIndexes.map((index) {
              return TouchedSpotIndicatorData(
                const FlLine(
                  color: AppColors.brandTeal,
                  strokeWidth: 1.5,
                  dashArray: [4, 4],
                ),
                FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                    radius: 5,
                    color: AppColors.brandTeal,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  ),
                ),
              );
            }).toList();
          },
          touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
            if (touchResponse?.lineBarSpots != null &&
                touchResponse!.lineBarSpots!.isNotEmpty) {
              final spotIndex = touchResponse.lineBarSpots!.first.spotIndex;
              if (spotIndex != _touchedIndex) {
                setState(() {
                  _touchedIndex = spotIndex;
                });
              }
            }
          },
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => AppColors.brandTeal,
            tooltipPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                    fontSize: 13,
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
        ),
      ),
    );
  }

  Widget _buildSummaryMetricsCard(WeightController controller) {
    final chartData = controller.chartData;

    WeightRecord? startRecord;
    WeightRecord? endRecord;

    if (chartData.length >= 2) {
      startRecord = chartData.first;
      endRecord = chartData.last;
    } else {
      endRecord = controller.currentWeight;
      startRecord = controller.previousWeight ?? controller.currentWeight;
    }

    final currentWeightVal = endRecord?.weightKg;
    final previousWeightVal = startRecord?.weightKg;

    final double changeVal;
    if (currentWeightVal != null &&
        previousWeightVal != null &&
        startRecord != endRecord) {
      changeVal = currentWeightVal - previousWeightVal;
    } else {
      changeVal = controller.weightChangeSinceLast;
    }

    final changeAbsStr = changeVal.abs().toStringAsFixed(1);
    final signStr = changeVal > 0 ? '+' : (changeVal < 0 ? '-' : '');

    final currentWeightStr =
        currentWeightVal != null ? currentWeightVal.toStringAsFixed(1) : '--';
    final previousWeightStr =
        previousWeightVal != null ? previousWeightVal.toStringAsFixed(1) : '--';

    final currentDateStr = endRecord != null
        ? DateFormat('MMM d, yyyy').format(endRecord.date)
        : '';
    final previousDateStr = startRecord != null
        ? DateFormat('MMM d, yyyy').format(startRecord.date)
        : '';

    String changeLabel = 'WEEKLY CHANGE';
    switch (controller.selectedRange.value) {
      case TimeRange.week1:
        changeLabel = 'WEEKLY CHANGE';
        break;
      case TimeRange.month1:
        changeLabel = 'MONTHLY CHANGE';
        break;
      case TimeRange.month3:
        changeLabel = '3-MONTH CHANGE';
        break;
      case TimeRange.month6:
        changeLabel = '6-MONTH CHANGE';
        break;
      case TimeRange.year1:
        changeLabel = 'YEARLY CHANGE';
        break;
    }

    final statusText = controller.weeklyProgressStatus;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Column 1: CHANGE
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    changeLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '$signStr$changeAbsStr',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.brandTeal,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Text(
                          'kg',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildStatusPill(statusText),
                ],
              ),
            ),

            Container(
              width: 1,
              color: const Color(0xFFF0F0F0),
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),

            // Column 2: PREVIOUS WEIGHT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'PREVIOUS WEIGHT',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          previousWeightStr,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Text(
                          'kg',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    previousDateStr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: 1,
              color: const Color(0xFFF0F0F0),
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),

            // Column 3: CURRENT WEIGHT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'CURRENT WEIGHT',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          currentWeightStr,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Text(
                          'kg',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    currentDateStr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
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

  Widget _buildStatusPill(String status) {
    Color bg = const Color(0xFFE8F7F6);
    Color fg = AppColors.brandTeal;
    IconData icon = Icons.check_circle_outline;

    switch (status) {
      case 'On target':
        bg = const Color(0xFFE8F7F6);
        fg = AppColors.brandTeal;
        icon = Icons.check_circle_outline;
        break;
      case 'Faster than target':
        bg = const Color(0xFFE8F5E9);
        fg = const Color(0xFF2E7D32);
        icon = Icons.bolt;
        break;
      case 'Slower than target':
        bg = const Color(0xFFFFF8E1);
        fg = const Color(0xFFF57F17);
        icon = Icons.access_time;
        break;
      case 'Maintaining':
        bg = const Color(0xFFE3F2FD);
        fg = const Color(0xFF1565C0);
        icon = Icons.remove_circle_outline;
        break;
      case 'Insufficient data':
      default:
        bg = const Color(0xFFF5F5F5);
        fg = AppColors.textSecondary;
        icon = Icons.help_outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              status,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: fg,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(WeightController controller, BuildContext context) {
    final records = controller.records;
    if (records.isEmpty) {
      return const SizedBox.shrink();
    }

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: records.length > 5 ? 5 : records.length,
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
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
