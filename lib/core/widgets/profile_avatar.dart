import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/widgets/app_cached_image.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    this.avatarUrl,
    required this.initialLetter,
    this.size = 40,
    this.onTap,
  });

  final String? avatarUrl;
  final String initialLetter;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget avatarWidget;

    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      avatarWidget = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
          image: DecorationImage(
            image: AppCachedNetworkImage.provider(avatarUrl!),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      avatarWidget = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.brandTeal,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            initialLetter,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: size * 0.42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: avatarWidget,
      );
    }

    return avatarWidget;
  }
}
