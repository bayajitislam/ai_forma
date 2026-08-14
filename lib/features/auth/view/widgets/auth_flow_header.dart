import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/app_brand_text.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/core/widgets/app_progress_bar.dart';
import 'package:get/get.dart';

class AuthFlowHeader extends StatelessWidget {
  const AuthFlowHeader({
    super.key,
    required this.currentStep,
    this.showBackButton = true,
  });

  final bool showBackButton;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    // Only show back button if explicitly requested AND Navigator stack actually can pop
    final canGoBack = showBackButton && Navigator.canPop(context);

    return Column(
      children: [
        SizedBox(
          height: 32,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Center(
                child: AppBrandText(height: 22, width: 150),
              ),
              if (canGoBack)
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: const AppIcon(
                      icon: AppIcons.back,
                      size: 28,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
            ],
          ),
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
