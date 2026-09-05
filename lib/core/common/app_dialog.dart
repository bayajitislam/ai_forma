import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';

enum DialogType { info, warning }

class AppDialog extends StatelessWidget {
  final String? title;
  final String message;
  final DialogType type;
  final IconData? icon;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  final String confirmText;
  final String cancelText;

  const AppDialog({
    super.key,
    this.title,
    required this.message,
    this.type = DialogType.info,
    this.icon,
    this.onCancel,
    this.onConfirm,
    this.confirmText = "OK",
    this.cancelText = "Cancel",
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor = type == DialogType.warning
        ? AppColors.insightWarning
        : AppColors.brandTeal;

    final Color iconBgColor = (type == DialogType.warning
            ? AppColors.insightWarning
            : AppColors.brandTeal)
        .withValues(alpha: 0.1);

    final IconData displayIcon = icon ??
        (type == DialogType.warning
            ? Icons.warning_amber_rounded
            : Icons.info_outline_rounded);

    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                displayIcon,
                color: iconColor,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),

            // 2. Title
            if (title != null)
              Text(
                title!,
                style: AppTextStyles.authSectionTitle.copyWith(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            if (title != null) const SizedBox(height: 10),

            // 3. Message
            Text(
              message,
              style: AppTextStyles.authBody.copyWith(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // 4. Buttons
            Row(
              children: [
                // Cancel Button (Only if onConfirm exists)
                if (onConfirm != null)
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppColors.brandTeal.withValues(alpha: 0.5),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(33),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: onCancel ?? () => Navigator.pop(context),
                      child: Text(
                        cancelText,
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.brandTeal,
                        ),
                      ),
                    ),
                  ),

                if (onConfirm != null) const SizedBox(width: 12),

                // Confirm / OK Button
                Expanded(
                  child: PrimaryButton(
                    label: confirmText,
                    borderRadius: 33,
                    onPressed: onConfirm ?? () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
