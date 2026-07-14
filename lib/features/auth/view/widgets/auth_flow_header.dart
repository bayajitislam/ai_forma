import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/app_brand_text.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/core/widgets/app_progress_bar.dart';

class AuthFlowHeader extends StatelessWidget {
  final bool showBackButton;
  const AuthFlowHeader({
    super.key,
    required this.currentStep,
    this.showBackButton = true,
  });

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            showBackButton
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.maybePop(context),
                      child: const AppIcon(
                        icon: AppIcons.back,
                        size: 28,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            Align(
              alignment: Alignment.center,
              child: const AppBrandText(height: 22, width: 150),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: AppProgressBar(currentStep: currentStep),
        ),
      ],
    );
  }
}
