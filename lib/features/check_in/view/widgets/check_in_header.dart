import 'package:ai_forma/core/widgets/app_brand_text.dart';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';

class CheckInHeader extends StatelessWidget {
  final String? title;
  final bool isTitle;
  const CheckInHeader({super.key, this.title, this.isTitle = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: const AppIcon(
              icon: AppIcons.back,
              size: 28,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        isTitle
            ? Text(
                title ?? '',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              )
            : const AppBrandText(height: 22, width: 150),
      ],
    );
  }
}
