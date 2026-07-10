import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({
    super.key,
    required this.icon,
    this.size = 24,
    this.color = AppColors.brandTeal,
  });

  final IconData icon;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size,
      color: color,
    );
  }
}
