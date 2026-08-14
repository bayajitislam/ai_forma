import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';

class AssessmentRadioIndicator extends StatelessWidget {
  const AssessmentRadioIndicator({
    super.key,
    required this.isSelected,
  });

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.brandTeal : AppColors.cardBorder,
          width: isSelected ? 6 : 1.5,
        ),
        color: isSelected ? AppColors.onPrimary : Colors.transparent,
      ),
    );
  }
}
