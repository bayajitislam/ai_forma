import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';

class AppLoader extends StatelessWidget {
  final Color color;
  final double size;
  const AppLoader({
    super.key,
    this.color = AppColors.brandTealDark,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator.adaptive(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );
  }
}
