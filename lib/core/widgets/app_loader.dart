import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({
    super.key,
    this.size = 32,
    this.strokeWidth = 2.5,
    this.color = AppColors.accent,
  });

  final double size;
  final double strokeWidth;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        color: color,
      ),
    );
  }
}
