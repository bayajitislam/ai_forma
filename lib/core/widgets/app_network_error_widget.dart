import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';

class AppNetworkErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;
  final String? title;
  final String? message;
  final bool isCompact;

  const AppNetworkErrorWidget({
    super.key,
    required this.onRetry,
    this.title,
    this.message,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final String displayTitle = title ?? 'Connection Error';
    final String displayMessage = (message != null && message!.isNotEmpty)
        ? message!
        : 'Unable to connect to server. Please check your internet connection.';

    if (isCompact) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.redAccent.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.wifi_off_rounded,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    displayTitle,
                    style: const TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              displayMessage,
              style: const TextStyle(
                fontFamily: AppFonts.family,
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: PrimaryButton(
                onPressed: onRetry,
                label: 'Try Again',
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.redAccent.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: const Icon(
            Icons.wifi_off_rounded,
            color: Colors.redAccent,
            size: 36,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          displayTitle,
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
          displayMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: AppFonts.family,
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 28),
        PrimaryButton(
          onPressed: onRetry,
          label: 'Try Again',
        ),
      ],
    );
  }
}
