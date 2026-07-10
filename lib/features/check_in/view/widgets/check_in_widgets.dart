import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/features/check_in/constants/check_in_strings.dart';

class ScanReviewTile extends StatelessWidget {
  const ScanReviewTile({
    super.key,
    required this.label,
    required this.imagePath,
  });

  final String label;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              width: 48,
              height: 64,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.featureTitle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: AppColors.brandTeal,
              shape: BoxShape.circle,
            ),
            child: const AppIcon(
              icon: AppIcons.check,
              size: 14,
              color: AppColors.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class MeasurementRow extends StatefulWidget {
  const MeasurementRow({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
  });

  final String label;
  final double initialValue;
  final ValueChanged<double> onChanged;

  @override
  State<MeasurementRow> createState() => _MeasurementRowState();
}

class _MeasurementRowState extends State<MeasurementRow> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _adjust(double delta) {
    setState(() {
      _value = double.parse((_value + delta).toStringAsFixed(1));
      widget.onChanged(_value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.label,
              style: AppTextStyles.featureTitle.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            _value.toStringAsFixed(1),
            style: AppTextStyles.dashboardMetricValue.copyWith(fontSize: 20),
          ),
          const SizedBox(width: 8),
          const AppIcon(
            icon: AppIcons.arrowUpDown,
            size: 18,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            CheckInStrings.unitCm,
            style: AppTextStyles.dashboardMetricLabel,
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              GestureDetector(
                onTap: () => _adjust(0.1),
                child: const Icon(Icons.keyboard_arrow_up, size: 18),
              ),
              GestureDetector(
                onTap: () => _adjust(-0.1),
                child: const Icon(Icons.keyboard_arrow_down, size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AnalysisStepItem extends StatelessWidget {
  const AnalysisStepItem({
    super.key,
    required this.label,
    required this.isComplete,
  });

  final String label;
  final bool isComplete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isComplete ? AppColors.brandTeal : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: isComplete ? AppColors.brandTeal : AppColors.cardBorder,
                width: 1.5,
              ),
            ),
            child: isComplete
                ? const AppIcon(
                    icon: AppIcons.check,
                    size: 14,
                    color: AppColors.onPrimary,
                  )
                : null,
          ),
          const SizedBox(width: 14),
          Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: isComplete
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
