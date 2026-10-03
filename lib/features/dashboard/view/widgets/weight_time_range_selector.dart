import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/features/dashboard/controllers/weight_controller.dart';

class WeightTimeRangeSelector extends StatelessWidget {
  const WeightTimeRangeSelector({
    super.key,
    required this.selectedRange,
    required this.onRangeSelected,
    this.verticalPadding = 10,
  });

  final TimeRange selectedRange;
  final ValueChanged<TimeRange> onRangeSelected;
  final double verticalPadding;

  static String getLabel(TimeRange range) => switch (range) {
        TimeRange.week1 => '1W',
        TimeRange.month1 => '1M',
        TimeRange.month3 => '3M',
        TimeRange.month6 => '6M',
        TimeRange.year1 => '1Y',
      };

  @override
  Widget build(BuildContext context) {
    return Row(
      children: TimeRange.values.map((range) {
        final isSelected = selectedRange == range;
        final label = getLabel(range);

        return Expanded(
          child: GestureDetector(
            onTap: () => onRangeSelected(range),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: EdgeInsets.symmetric(vertical: verticalPadding),
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
  }
}
