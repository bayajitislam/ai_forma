import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/app_brand_text.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Navigator.canPop(context)
                ? const AppIcon(
                    icon: AppIcons.back,
                    size: 28,
                    color: AppColors.textPrimary,
                  )
                : const SizedBox.shrink(),
          ),
        ),
        const AppBrandText(height: 22, width: 150),
      ],
    );
  }
}
