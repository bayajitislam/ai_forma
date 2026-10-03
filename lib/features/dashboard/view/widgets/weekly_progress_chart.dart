import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/utils/app_date_formatter.dart';
import 'package:ai_forma/features/dashboard/constants/dashboard_strings.dart';
import 'package:ai_forma/features/dashboard/controllers/weight_controller.dart';

class WeeklyProgressChart extends StatelessWidget {
  const WeeklyProgressChart({
    super.key,
    required this.controller,
    required this.touchedIndex,
    required this.onTouchIndexChanged,
  });

  final WeightController controller;
  final int touchedIndex;
  final ValueChanged<int> onTouchIndexChanged;

  @override
  Widget build(BuildContext context) {
    final data = controller.chartData;
    if (data.isEmpty) {
      return const Center(
        child: Text(
          DashboardStrings.noDataForPeriod,
          style: TextStyle(color: AppColors.textSecondary),
        ),
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

    // Default to last spot if not manually touched
    final activeIndex = (touchedIndex >= 0 && touchedIndex < spots.length)
        ? touchedIndex
        : spots.length - 1;

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

    final lineChartBarData = LineChartBarData(
      spots: spots,
      isCurved: data.length > 1,
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
          horizontalInterval: ((maxY - minY) / 4).clamp(0.5, 10.0),
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
                        fontSize: 11,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: ((maxY - minY) / 4).clamp(0.5, 10.0),
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(value % 1 == 0 ? 0 : 1),
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
        maxX: maxX == minX ? minX + 1 : maxX,
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
          getTouchedSpotIndicator:
              (LineChartBarData barData, List<int> spotIndexes) {
            return spotIndexes.map((index) {
              return TouchedSpotIndicatorData(
                const FlLine(
                  color: AppColors.brandTeal,
                  strokeWidth: 1.5,
                  dashArray: [4, 4],
                ),
                FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) =>
                      FlDotCirclePainter(
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
              if (spotIndex != touchedIndex) {
                onTouchIndexChanged(spotIndex);
              }
            }
          },
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => AppColors.brandTeal,
            tooltipPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((LineBarSpot touchedSpot) {
                final idx = touchedSpot.x.round().clamp(0, data.length - 1);
                final record = data[idx];
                return LineTooltipItem(
                  '${record.weightKg.toStringAsFixed(1)} ${DashboardStrings.kgUnit}\n',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  children: [
                    TextSpan(
                      text: AppDateFormatter.toDayMonthYear(record.date),
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
}
