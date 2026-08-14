import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';

class AppLoader extends StatelessWidget {
  final Color color;
  const AppLoader({super.key, this.color = AppColors.brandTealDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator.adaptive(
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
