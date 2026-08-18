import 'package:ai_forma/core/storage/auth_storage.dart';
import 'package:ai_forma/core/widgets/app_brand_text.dart';
import 'package:ai_forma/features/auth/controllers/user_controller.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:get/get.dart';

class CheckInHeader extends StatelessWidget {
  final String? title;
  final bool isTitle;
  final bool showLogout;

  const CheckInHeader({
    super.key,
    this.title,
    this.isTitle = false,
    this.showLogout = false,
  });

  Future<void> _onLogoutTap(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.onboardingBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Log Out?',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: const Text(
          'Are you sure you want to log out? You need to complete your initial check-in scan to prepare your personalized dashboard.',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              'Log Out',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await AuthStorage.clearSession();
      if (Get.isRegistered<UserController>()) {
        Get.find<UserController>().currentUser.value = null;
      }
      Get.offAllNamed(RoutesName.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool canPop = Navigator.canPop(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        if (canPop)
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.maybePop(context),
              child: const AppIcon(
                icon: AppIcons.back,
                size: 28,
                color: AppColors.textPrimary,
              ),
            ),
          )
        else if (showLogout)
          Obx(() {
            final user = Get.isRegistered<UserController>()
                ? Get.find<UserController>().currentUser.value
                : null;

            // Only display logout icon if initial scan is NOT yet completed
            final isInitialScanIncomplete =
                user == null || !user.initialScanCompleted;

            if (!isInitialScanIncomplete) return const SizedBox.shrink();

            return Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => _onLogoutTap(context),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.logout_rounded,
                    size: 24,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            );
          }),

        isTitle
            ? Text(
                title ?? '',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              )
            : const AppBrandText(height: 22, width: 150),
      ],
    );
  }
}
