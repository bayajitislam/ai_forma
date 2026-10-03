import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PhysiqueTargetItem {
  final String label;
  final String goalCaption;
  final String value;

  const PhysiqueTargetItem({
    required this.label,
    required this.goalCaption,
    required this.value,
  });
}

class PhysiqueTargetItemRow extends StatelessWidget {
  final PhysiqueTargetItem item;

  const PhysiqueTargetItemRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.label,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.goalCaption,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            item.value,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
