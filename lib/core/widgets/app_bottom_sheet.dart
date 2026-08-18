import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class AppBottomSheet extends StatelessWidget {
  final String title;
  final List<String> bulletPoints;
  final String closeButtonLabel;
  final VoidCallback? onClose;

  const AppBottomSheet({
    super.key,
    required this.title,
    required this.bulletPoints,
    this.closeButtonLabel = 'Close',
    this.onClose,
  });

  /// Helper static method to show the bottom sheet anywhere in the app
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required List<String> bulletPoints,
    String closeButtonLabel = 'Close',
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (ctx) => AppBottomSheet(
        title: title,
        bulletPoints: bulletPoints,
        closeButtonLabel: closeButtonLabel,
        onClose: () => Navigator.of(ctx).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.onboardingBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24.0),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag indicator handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.inputBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Header Title + X Close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.authSectionTitle,
                  ),
                ),
                IconButton(
                  onPressed: onClose ?? () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textPrimary,
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Bullet Points Content List
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: bulletPoints.map((point) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6, right: 12),
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.brandTeal,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              point,
                              style: AppTextStyles.authBody.copyWith(
                                color: AppColors.textPrimary,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Bottom Close Button
            PrimaryButton(
              onPressed: onClose ?? () => Navigator.of(context).pop(),
              label: closeButtonLabel,
            ),
          ],
        ),
      ),
    );
  }
}
