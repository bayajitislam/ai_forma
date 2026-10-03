import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/widgets/app_secondary_button.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/check_in/constants/check_in_strings.dart';
import 'package:get/get.dart';

abstract final class AnalysisErrorDialog {
  static void show({
    required BuildContext context,
    required String message,
    required VoidCallback onReturnToDashboard,
    required VoidCallback onBackToReview,
    required VoidCallback onTryAgain,
  }) {
    final lowerMsg = message.toLowerCase();
    final bool isWindowClosed =
        lowerMsg.contains('window') ||
        lowerMsg.contains('closed') ||
        lowerMsg.contains('not available') ||
        lowerMsg.contains('schedule') ||
        lowerMsg.contains('subscription') ||
        lowerMsg.contains('paywall');

    final String dialogTitle = isWindowClosed
        ? CheckInStrings.checkInWindowClosed
        : CheckInStrings.analysisFailed;
    final IconData dialogIcon = isWindowClosed
        ? Icons.event_busy_rounded
        : Icons.warning_amber_rounded;
    final Color dialogAccentColor = isWindowClosed
        ? AppColors.brandTeal
        : Colors.redAccent;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: dialogAccentColor.withValues(alpha: 0.3),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: dialogAccentColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(dialogIcon, color: dialogAccentColor, size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                dialogTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message.isNotEmpty
                    ? message
                    : CheckInStrings.analysisFailedDefaultMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              if (isWindowClosed) ...[
                PrimaryButton(
                  onPressed: onReturnToDashboard,
                  label: CheckInStrings.returnToDashboard,
                ),
                const SizedBox(height: 10),
                AppSecondaryButton(
                  onPressed: onBackToReview,
                  label: CheckInStrings.backToReview,
                ),
              ] else ...[
                PrimaryButton(
                  onPressed: onTryAgain,
                  label: CheckInStrings.tryAgain,
                ),
                const SizedBox(height: 10),
                AppSecondaryButton(
                  onPressed: onBackToReview,
                  label: CheckInStrings.backToReview,
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: onReturnToDashboard,
                  child: const Text(
                    CheckInStrings.returnToDashboard,
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
