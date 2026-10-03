import 'dart:io';

import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/features/profile/constants/profile_strings.dart';
import 'package:flutter/material.dart';

class BugReportScreenshotPicker extends StatelessWidget {
  final File? selectedImage;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;

  const BugReportScreenshotPicker({
    super.key,
    required this.selectedImage,
    required this.onPickImage,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedImage != null) {
      return Stack(
        children: [
          Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: FileImage(selectedImage!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onRemoveImage,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: onPickImage,
      child: Container(
        width: double.infinity,
        height: 96,
        decoration: BoxDecoration(
          color: AppColors.insightConsistencyIncompleteBg.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.cardBorder.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.attachment,
              color: AppColors.textSecondary,
              size: 22,
            ),
            SizedBox(height: 6),
            Text(
              ProfileStrings.chooseImageButton,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
