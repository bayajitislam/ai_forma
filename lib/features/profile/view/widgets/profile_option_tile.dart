import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const ProfileOptionTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      leading: Icon(
        icon,
        color: AppColors.textPrimary.withValues(alpha: 0.7),
        size: subtitle != null ? 24 : 22,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: subtitle != null ? 16 : 15,
          fontWeight: subtitle != null ? FontWeight.w700 : FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: subtitle != null
          ? Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                subtitle!,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            )
          : null,
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.cardBorder,
        size: 20,
      ),
      onTap: onTap,
    );
  }
}
