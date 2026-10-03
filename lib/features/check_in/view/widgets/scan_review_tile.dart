import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/app_loader.dart';
import 'package:ai_forma/features/check_in/constants/check_in_strings.dart';
import 'package:ai_forma/features/check_in/models/scan_validation_model.dart';
import 'package:ai_forma/features/check_in/view/pages/camera_capture_view.dart';

class ScanReviewTile extends StatelessWidget {
  const ScanReviewTile({
    super.key,
    required this.label,
    this.angle,
    this.file,
    this.imagePath,
    this.checkDetail,
    this.isValidating = false,
  });

  final String label;
  final ScanAngle? angle;
  final File? file;
  final String? imagePath;
  final ViewCheckDetail? checkDetail;
  final bool isValidating;

  @override
  Widget build(BuildContext context) {
    final bool hasResult = checkDetail != null && !isValidating;
    final bool isValid = hasResult && checkDetail!.isValid;
    final bool hasError = hasResult && !checkDetail!.isValid;

    Widget imageContent;
    if (file != null) {
      imageContent = ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(file!, fit: BoxFit.contain),
      );
    } else if (imagePath != null && imagePath!.isNotEmpty) {
      imageContent = ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(imagePath!, fit: BoxFit.cover),
      );
    } else {
      imageContent = const Icon(Icons.image, color: AppColors.textSecondary);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasError
              ? Colors.redAccent.withValues(alpha: 0.5)
              : AppColors.cardBorder,
          width: hasError ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: imageContent,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (isValidating)
                      const Text(
                        CheckInStrings.checkingImageQuality,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              if (isValidating)
                const AppLoader(
                  color: AppColors.brandTeal,
                  size: 20,
                )
              else if (isValid)
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.brandTeal,
                  size: 24,
                )
              else if (hasError)
                const Icon(
                  Icons.cancel_rounded,
                  color: Colors.redAccent,
                  size: 24,
                )
              else
                const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.textSecondary,
                  size: 24,
                ),
            ],
          ),
          if (hasError && checkDetail != null) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 14,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      checkDetail!.displayReason,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
