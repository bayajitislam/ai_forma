import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_forma/core/theme/app_colors.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({
    super.key,
    required this.icon,
    this.size = 24,
    this.color = AppColors.brandTeal,
  });

  final dynamic icon;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (icon is IconData) {
      return Icon(icon as IconData, size: size, color: color);
    }

    if (icon is String) {
      return SvgPicture.asset(
        icon as String,
        width: size,
        height: size,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    }

    return const SizedBox.shrink();
  }
}
