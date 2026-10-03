import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Reusable banner widget for rendering reactive error and success messages across auth screens.
class AuthMessageBanner extends StatelessWidget {
  const AuthMessageBanner({
    super.key,
    required this.errorMessage,
    this.successMessage,
    this.padding = const EdgeInsets.only(bottom: 8),
  });

  final RxString errorMessage;
  final RxString? successMessage;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final error = errorMessage.value;
      if (error.isNotEmpty) {
        return Padding(
          padding: padding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 14,
                color: Colors.red.shade400,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  error,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.red.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      }

      final success = successMessage?.value ?? '';
      if (success.isNotEmpty) {
        return Padding(
          padding: padding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                size: 14,
                color: AppColors.brandTealDark,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  success,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.brandTealDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      }

      return const SizedBox.shrink();
    });
  }
}
