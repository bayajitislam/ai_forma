import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 80,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return AppIcon(
      icon: AppIcons.heartPulse,
      size: size,
    );
  }
}
