import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/app_brand_text.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/core/widgets/app_progress_bar.dart';
import 'package:ai_forma/features/onboarding_assessment/constants/assessment_strings.dart';

class AssessmentFlowHeader extends StatelessWidget {
  const AssessmentFlowHeader({
    super.key,
    required this.currentStep,
    this.totalSteps,
    this.showBackButton = true,
    this.onBackTap,
  });

  final int currentStep;
  final int? totalSteps;
  final bool showBackButton;
  final VoidCallback? onBackTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            if (showBackButton)
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    if (onBackTap != null) {
                      onBackTap!();
                    } else {
                      Navigator.maybePop(context);
                    }
                  },
                  child: const AppIcon(
                    icon: AppIcons.back,
                    size: 28,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            const AppBrandText(height: 22, width: 150),
          ],
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: AppProgressBar(
            currentStep: currentStep,
            totalSteps: totalSteps ?? AssessmentStrings.totalSteps,
          ),
        ),
      ],
    );
  }
}
