import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/check_in/constants/check_in_strings.dart';

abstract final class ScheduleFeedbackBottomSheet {
  /// Show popup confirmation bottom sheet upon successful schedule change response
  static Future<void> showSuccess(
    BuildContext context, {
    String? title,
    required String message,
    bool activeCycleExists = false,
    String? pendingScanDay,
  }) {
    final displayTitle = title ??
        (activeCycleExists
            ? CheckInStrings.scanScheduleChangeSet
            : CheckInStrings.scanScheduleUpdated);

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.iconBackground,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.event_available_rounded,
                  size: 32,
                  color: AppColors.brandTeal,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              displayTitle,
              style: AppTextStyles.authSectionTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              onPressed: () => Navigator.of(ctx).pop(),
              label: CheckInStrings.gotIt,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  /// Show popup error bottom sheet when schedule update fails (e.g. 7-day restriction)
  static Future<void> showError(
    BuildContext context, {
    required String message,
  }) {
    final cleanMsg = message.isNotEmpty
        ? message
        : CheckInStrings.scheduleChangeRestrictedBody;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.calendar_month_rounded,
                  size: 32,
                  color: Colors.redAccent,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              CheckInStrings.scheduleChangeRestricted,
              style: AppTextStyles.authSectionTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              cleanMsg,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              onPressed: () => Navigator.of(ctx).pop(),
              label: CheckInStrings.gotIt,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
