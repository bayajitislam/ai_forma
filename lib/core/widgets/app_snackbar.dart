import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum AppSnackbarType { success, error, warning, info }

/// Custom application snackbar utility with consistent branding,
/// typography, icons, and smooth floating card presentation.
abstract final class AppSnackbar {
  /// Global ScaffoldMessengerKey registered with [GetMaterialApp]
  /// to enable displaying snackbars without requiring BuildContext.
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  /// Shows a success snackbar with a brand teal check badge.
  static void showSuccess(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      message: message,
      title: title,
      type: AppSnackbarType.success,
      duration: duration,
    );
  }

  /// Shows an error snackbar with a red error badge.
  static void showError(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      message: message,
      title: title,
      type: AppSnackbarType.error,
      duration: duration,
    );
  }

  /// Shows a warning snackbar with an amber warning badge.
  static void showWarning(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      message: message,
      title: title,
      type: AppSnackbarType.warning,
      duration: duration,
    );
  }

  /// Shows an info snackbar with an information badge.
  static void showInfo(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      message: message,
      title: title,
      type: AppSnackbarType.info,
      duration: duration,
    );
  }

  /// Base presentation method that builds the floating custom SnackBar card.
  static void show({
    required String message,
    String? title,
    AppSnackbarType type = AppSnackbarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final state = messengerKey.currentState;
    if (state == null) {
      debugPrint('[AppSnackbar] ScaffoldMessengerState is null: $message');
      return;
    }

    state.hideCurrentSnackBar();

    final (Color iconBgColor, Color iconColor, Color borderColor, IconData icon) =
        switch (type) {
      AppSnackbarType.success => (
        AppColors.brandTeal.withValues(alpha: 0.12),
        AppColors.brandTeal,
        AppColors.brandTeal.withValues(alpha: 0.35),
        Icons.check_circle_rounded,
      ),
      AppSnackbarType.error => (
        Colors.redAccent.withValues(alpha: 0.12),
        Colors.redAccent,
        Colors.redAccent.withValues(alpha: 0.35),
        Icons.error_outline_rounded,
      ),
      AppSnackbarType.warning => (
        Colors.orangeAccent.withValues(alpha: 0.15),
        Colors.orangeAccent.shade700,
        Colors.orangeAccent.withValues(alpha: 0.4),
        Icons.warning_amber_rounded,
      ),
      AppSnackbarType.info => (
        AppColors.insightConsistencyIncompleteBg,
        AppColors.brandTealDark,
        AppColors.cardBorder.withValues(alpha: 0.6),
        Icons.info_outline_rounded,
      ),
    };

    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: EdgeInsets.zero,
      duration: duration,
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null && title.isNotEmpty) ...[
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: type == AppSnackbarType.error
                            ? Colors.redAccent.shade700
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                  Text(
                    message,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    state.showSnackBar(snackBar);
  }
}
