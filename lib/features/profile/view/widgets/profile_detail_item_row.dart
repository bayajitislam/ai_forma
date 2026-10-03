import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileDetailItem {
  final IconData icon;
  final String label;
  final String value;

  const ProfileDetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class ProfileDetailItemRow extends StatelessWidget {
  final ProfileDetailItem item;

  const ProfileDetailItemRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            item.icon,
            color: AppColors.textSecondary.withValues(alpha: 0.8),
            size: 22,
          ),
          const SizedBox(width: 12),
          Text(
            item.label,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          Text(
            item.value,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
