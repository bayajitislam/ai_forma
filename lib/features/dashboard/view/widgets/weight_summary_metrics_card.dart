import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_forma/core/models/weight_record.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/utils/app_date_formatter.dart';
import 'package:ai_forma/features/dashboard/constants/dashboard_strings.dart';
import 'package:ai_forma/features/dashboard/controllers/weight_controller.dart';

class WeightSummaryMetricsCard extends StatelessWidget {
  const WeightSummaryMetricsCard({
    super.key,
    required this.controller,
  });

  final WeightController controller;

  Widget _buildStatusPill(String status) {
    Color bg = const Color(0xFFE8F7F6);
    Color fg = AppColors.brandTeal;
    IconData icon = Icons.check_circle_outline;

    switch (status) {
      case DashboardStrings.onTarget:
        bg = const Color(0xFFE8F7F6);
        fg = AppColors.brandTeal;
        icon = Icons.check_circle_outline;
        break;
      case DashboardStrings.fasterThanTarget:
        bg = const Color(0xFFE8F5E9);
        fg = const Color(0xFF2E7D32);
        icon = Icons.bolt;
        break;
      case DashboardStrings.slowerThanTarget:
        bg = const Color(0xFFFFF8E1);
        fg = const Color(0xFFF57F17);
        icon = Icons.access_time;
        break;
      case DashboardStrings.maintaining:
        bg = const Color(0xFFE3F2FD);
        fg = const Color(0xFF1565C0);
        icon = Icons.remove_circle_outline;
        break;
      case DashboardStrings.insufficientData:
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

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildContent());
  }

  Widget _buildContent() {
    final chartData = controller.chartData;

    WeightRecord? startRecord;
    WeightRecord? endRecord;

    if (chartData.length >= 2) {
      startRecord = chartData.first;
      endRecord = chartData.last;
    } else if (chartData.length == 1) {
      endRecord = chartData.first;
      startRecord = controller.previousWeight ?? chartData.first;
    } else {
      endRecord = controller.currentWeight;
      startRecord = controller.previousWeight ?? controller.currentWeight;
    }

    final currentWeightVal = endRecord?.weightKg;
    final previousWeightVal = (startRecord != null && startRecord != endRecord)
        ? startRecord.weightKg
        : (controller.previousWeight?.weightKg ?? currentWeightVal);

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
        ? AppDateFormatter.toDayMonthYear(endRecord.date)
        : '';
    final previousDateStr = (startRecord != null && startRecord != endRecord)
        ? AppDateFormatter.toDayMonthYear(startRecord.date)
        : (controller.previousWeight != null
            ? AppDateFormatter.toDayMonthYear(controller.previousWeight!.date)
            : '');

    String changeLabel = switch (controller.selectedRange.value) {
      TimeRange.week1 => DashboardStrings.weeklyChangeCaps,
      TimeRange.month1 => DashboardStrings.monthlyChangeCaps,
      TimeRange.month3 => DashboardStrings.threeMonthChangeCaps,
      TimeRange.month6 => DashboardStrings.sixMonthChangeCaps,
      TimeRange.year1 => DashboardStrings.yearlyChangeCaps,
    };

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
                          DashboardStrings.kgUnit,
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
                    DashboardStrings.previousWeightCaps,
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
                          DashboardStrings.kgUnit,
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
                    DashboardStrings.currentWeightCaps,
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
                          DashboardStrings.kgUnit,
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
}
