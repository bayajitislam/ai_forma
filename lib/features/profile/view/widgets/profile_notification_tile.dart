import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/features/profile/constants/profile_strings.dart';
import 'package:ai_forma/features/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileNotificationTile extends StatelessWidget {
  final ProfileController controller;

  const ProfileNotificationTile({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isToggling = controller.isToggling.value;
      final notificationsEnabled = controller.notificationsEnabled.value;

      return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        leading: Icon(
          Icons.notifications_outlined,
          color: AppColors.textPrimary.withValues(alpha: 0.7),
          size: 22,
        ),
        title: const Text(
          ProfileStrings.pushNotificationsTitle,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: const Text(
          ProfileStrings.pushNotificationsSubtitle,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: isToggling
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.brandTeal,
                ),
              )
            : Switch.adaptive(
                value: notificationsEnabled,
                activeTrackColor: AppColors.brandTeal,
                activeThumbColor: Colors.white,
                onChanged: isToggling
                    ? null
                    : controller.handleNotificationToggle,
              ),
      );
    });
  }
}
