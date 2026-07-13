import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';

enum InsightStatChangeDirection { up, down, none }

class InsightStatsCard extends StatelessWidget {
  const InsightStatsCard({super.key, required this.rows});

  final List<InsightStatRowData> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: AppColors.cardBorder),
            InsightStatRow(data: rows[i]),
          ],
        ],
      ),
    );
  }
}

class InsightStatRowData {
  const InsightStatRowData({
    required this.value,
    required this.label,
    this.change,
    this.changeDirection = InsightStatChangeDirection.none,
    this.changeIsPositive = true,
  });

  final String value;
  final String label;
  final String? change;
  final InsightStatChangeDirection changeDirection;
  final bool changeIsPositive;
}

class InsightStatRow extends StatelessWidget {
  const InsightStatRow({super.key, required this.data});

  final InsightStatRowData data;

  Color get _changeColor {
    if (data.changeDirection == InsightStatChangeDirection.none) {
      return AppColors.textSecondary;
    }
    return data.changeIsPositive
        ? AppColors.brandTealDark
        : AppColors.textSecondary;
  }

  IconData? get _changeIcon => switch (data.changeDirection) {
    InsightStatChangeDirection.up => AppIcons.arrowUp,
    InsightStatChangeDirection.down => AppIcons.arrowDown,
    InsightStatChangeDirection.none => null,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.value,
                  style: AppTextStyles.featureTitle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 2),
                Text(data.label, style: AppTextStyles.featureDescription),
              ],
            ),
          ),
          if (data.change != null) ...[
            if (_changeIcon != null)
              AppIcon(icon: _changeIcon!, size: 16, color: _changeColor),
            const SizedBox(width: 4),
            Text(
              data.change!,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _changeColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
