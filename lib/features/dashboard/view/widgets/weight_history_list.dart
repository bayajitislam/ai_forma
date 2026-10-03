import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ai_forma/core/models/weight_record.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/utils/app_date_formatter.dart';
import 'package:ai_forma/features/dashboard/constants/dashboard_strings.dart';

class WeightHistoryList extends StatelessWidget {
  const WeightHistoryList({
    super.key,
    required this.records,
    this.maxItems = 5,
  });

  final List<WeightRecord> records;
  final int maxItems;

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return const SizedBox.shrink();
    }

    final displayRecords =
        records.length > maxItems ? records.take(maxItems).toList() : records;

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
          itemCount: displayRecords.length,
          separatorBuilder: (context, index) =>
              const Divider(height: 1, color: AppColors.border),
          itemBuilder: (context, index) {
            final record = displayRecords[index];
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
                AppDateFormatter.toDayMonthYear(record.date),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              subtitle: Text(
                DateFormat('h:mm a').format(record.date),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              trailing: Text(
                '${record.weightKg.toStringAsFixed(1)} ${DashboardStrings.kgUnit}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
