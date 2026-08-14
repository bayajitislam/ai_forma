import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';

enum DialogType { info, warning }

class AppDialog extends StatelessWidget {
  final String? title;
  final String message;
  final DialogType type;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  final String confirmText;
  final String cancelText;

  const AppDialog({
    super.key,
    this.title,
    required this.message,
    this.type = DialogType.info,
    this.onCancel,
    this.onConfirm,
    this.confirmText = "OK",
    this.cancelText = "Cancel",
  });

  @override
  Widget build(BuildContext context) {
    // Get colors based on type
    final Color iconColor = type == DialogType.warning
        ? AppColors.insightWarning
        : AppColors.accent;

    return Dialog(
      backgroundColor: AppColors.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Icon
            Icon(
              type == DialogType.warning
                  ? Icons.warning_amber_rounded
                  : Icons.info_outline_rounded,
              color: iconColor,
              size: 48,
            ),
            const SizedBox(height: 16),

            // 2. Title
            Text(
              title ?? (type == DialogType.warning ? "Warning" : "Coming Soon"),
              style: AppTextStyles.requirementLabel,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // 3. Message
            Text(
              message,
              style: AppTextStyles.successTitle,
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
                        side: BorderSide(color: AppColors.accent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(33),
                        ),
                      ),
                      onPressed: onCancel ?? () => Navigator.pop(context),
                      child: Text(
                        cancelText,
                        style: AppTextStyles.authSectionTitle,
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
