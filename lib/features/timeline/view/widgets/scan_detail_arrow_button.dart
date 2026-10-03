import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ScanDetailArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const ScanDetailArrowButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.insightConsistencyIncompleteBg.withValues(
            alpha: 0.5,
          ),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.cardBorder.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Icon(icon, color: AppColors.brandTeal, size: 20),
      ),
    );
  }
}
