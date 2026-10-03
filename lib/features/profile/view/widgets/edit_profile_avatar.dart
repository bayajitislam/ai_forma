import 'dart:io';

import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/app_cached_image.dart';
import 'package:flutter/material.dart';

class EditProfileAvatar extends StatelessWidget {
  final File? pickedImage;
  final String? imageUrl;
  final bool isUploadingImage;
  final VoidCallback? onTap;

  const EditProfileAvatar({
    super.key,
    this.pickedImage,
    this.imageUrl,
    this.isUploadingImage = false,
    this.onTap,
  });

  DecorationImage? _getImageDecoration() {
    if (pickedImage != null) {
      return DecorationImage(
        image: FileImage(pickedImage!),
        fit: BoxFit.cover,
      );
    }
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return DecorationImage(
        image: AppCachedNetworkImage.provider(imageUrl!),
        fit: BoxFit.cover,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final imageDecoration = _getImageDecoration();

    return Center(
      child: GestureDetector(
        onTap: isUploadingImage ? null : onTap,
        child: SizedBox(
          width: 100,
          height: 100,
          child: Stack(
            children: [
              // Avatar circle
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.dashboardBackground,
                  border: Border.all(
                    color: AppColors.cardBorder.withValues(alpha: 0.5),
                    width: 2,
                  ),
                  image: imageDecoration,
                ),
                child: imageDecoration == null
                    ? const Icon(
                        Icons.person,
                        size: 44,
                        color: AppColors.textSecondary,
                      )
                    : null,
              ),
              // Upload loading overlay
              if (isUploadingImage)
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: 0.4),
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    ),
                  ),
                ),
              // Edit camera icon
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.brandTeal,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
