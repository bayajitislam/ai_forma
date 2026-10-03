import 'package:ai_forma/core/services/push_notification_service.dart';
import 'package:ai_forma/core/storage/auth_storage.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/app_snackbar.dart';
import 'package:ai_forma/features/auth/controllers/user_controller.dart';
import 'package:ai_forma/features/profile/constants/profile_strings.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileController extends GetxController with WidgetsBindingObserver {
  final RxBool notificationsEnabled = true.obs;
  final RxBool isToggling = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    checkNotificationStatus();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkNotificationStatus();
    }
  }

  Future<void> checkNotificationStatus() async {
    final enabled =
        await PushNotificationService.instance.getEffectiveNotificationStatus();
    notificationsEnabled.value = enabled;
  }

  Future<void> handleNotificationToggle(bool value) async {
    isToggling.value = true;
    final result =
        await PushNotificationService.instance.toggleNotifications(value);
    isToggling.value = false;

    switch (result) {
      case NotificationToggleResult.enabled:
        notificationsEnabled.value = true;
        AppSnackbar.showSuccess(
          ProfileStrings.notificationsEnabledDesc,
          title: ProfileStrings.notificationsEnabledTitle,
        );
        break;
      case NotificationToggleResult.disabled:
        notificationsEnabled.value = false;
        AppSnackbar.showInfo(
          ProfileStrings.notificationsDisabledDesc,
          title: ProfileStrings.notificationsDisabledTitle,
        );
        break;
      case NotificationToggleResult.permanentlyDenied:
        notificationsEnabled.value = false;
        showOpenSettingsDialog();
        break;
      case NotificationToggleResult.permissionDenied:
        notificationsEnabled.value = false;
        AppSnackbar.showError(
          ProfileStrings.permissionDeniedDesc,
          title: ProfileStrings.permissionDeniedTitle,
        );
        break;
    }
  }

  void showOpenSettingsDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          ProfileStrings.enableNotificationsTitle,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        content: const Text(
          ProfileStrings.enableNotificationsDesc,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              ProfileStrings.cancel,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: const Text(
              ProfileStrings.openSettings,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
                color: AppColors.brandTeal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> launchExternalUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      AppSnackbar.showInfo(
        '${ProfileStrings.pleaseVisitUrlInBrowser} ($url)',
        title: ProfileStrings.cannotOpenLink,
      );
    }
  }

  Future<void> handleLogout() async {
    if (Get.isRegistered<UserController>()) {
      await Get.find<UserController>().logout();
    } else {
      await AuthStorage.clearSession();
    }
    Get.offAllNamed(RoutesName.login);
  }

  void showDeleteAccountDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          ProfileStrings.deleteAccountTitle,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        content: const Text(
          ProfileStrings.deleteAccountDesc,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              ProfileStrings.cancel,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              executeDeleteAccount();
            },
            child: const Text(
              ProfileStrings.delete,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> executeDeleteAccount() async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(color: AppColors.brandTeal),
      ),
      barrierDismissible: false,
    );

    final userController = Get.isRegistered<UserController>()
        ? Get.find<UserController>()
        : null;

    if (userController == null) {
      Get.back();
      AppSnackbar.showError(
        ProfileStrings.unableToProcessRequest,
        title: ProfileStrings.error,
      );
      return;
    }

    final result = await userController.deleteAccount();

    Get.back();

    result.fold(
      (failure) {
        AppSnackbar.showError(
          failure.message,
          title: ProfileStrings.error,
        );
      },
      (successMessage) {
        AppSnackbar.showSuccess(
          successMessage,
          title: ProfileStrings.accountDeletedTitle,
        );
        Get.offAllNamed(RoutesName.login);
      },
    );
  }
}
