import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:flutter/material.dart';

/// Reusable circular badge icon used in auth verification, email confirmation, and success screens.
class AuthCircleIcon extends StatelessWidget {
  const AuthCircleIcon({
    super.key,
    required this.icon,
    this.size = 72,
    this.iconSize = 32,
    this.iconColor = AppColors.brandTeal,
    this.backgroundColor = AppColors.iconBackground,
  }) : child = null;

  const AuthCircleIcon.custom({
    super.key,
    required this.child,
    this.size = 96,
    this.backgroundColor = AppColors.iconBackground,
  })  : icon = null,
        iconSize = 0,
        iconColor = AppColors.brandTeal;

  const AuthCircleIcon.successCheck({
    super.key,
    this.size = 96,
    this.backgroundColor = AppColors.iconBackground,
  })  : icon = null,
        iconSize = 0,
        iconColor = AppColors.brandTeal,
        child = const _SuccessCheckBadge();

  final dynamic icon;
  final double size;
  final double iconSize;
  final Color iconColor;
  final Color backgroundColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: child ??
            (icon != null
                ? AppIcon(
                    icon: icon,
                    size: iconSize,
                    color: iconColor,
                  )
                : const SizedBox.shrink()),
      ),
    );
  }
}

class _SuccessCheckBadge extends StatelessWidget {
  const _SuccessCheckBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.brandTealDark,
          width: 4,
        ),
      ),
      child: const AppIcon(
        icon: AppIcons.check,
        size: 33,
        color: AppColors.brandTealDark,
      ),
    );
  }
}
