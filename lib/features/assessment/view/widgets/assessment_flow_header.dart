import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/app_brand_text.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/core/widgets/app_progress_bar.dart';
import 'package:ai_forma/features/assessment/constants/assessment_strings.dart';

class AssessmentFlowHeader extends StatelessWidget {
  const AssessmentFlowHeader({
    super.key,
    required this.currentStep,
    this.showBackButton = true,
  });

  final int currentStep;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (showBackButton)
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: const AppIcon(
                      icon: AppIcons.back,
                      size: 28,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              const AppBrandText(height: 22, width: 150),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: AppProgressBar(
            currentStep: currentStep,
            totalSteps: AssessmentStrings.totalSteps,
          ),
        ),
      ],
    );
  }
}
