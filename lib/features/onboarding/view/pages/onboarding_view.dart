import 'dart:io';

import 'package:ai_forma/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_brand_text.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/onboarding/constants/onboarding_strings.dart';
import 'package:ai_forma/features/onboarding/view/widgets/onboarding_feature_item.dart';
import 'package:ai_forma/features/onboarding/view/widgets/onboarding_header.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const OnboardingHeader(showBackButton: false),
              const SizedBox(height: 32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    OnboardingStrings.meetPrefix,
                    style: AppTextStyles.onboardingTitle,
                  ),
                  const AppBrandText(height: 32, width: 150),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                OnboardingStrings.subtitle,
                style: AppTextStyles.onboardingSubtitle,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: const [
                      OnboardingFeatureItem(
                        icon: AppIcons.heartPulse,
                        title: OnboardingStrings.featureAiBodyAnalysisTitle,
                        description:
                            OnboardingStrings.featureAiBodyAnalysisDescription,
                      ),
                      SizedBox(height: 28),
                      OnboardingFeatureItem(
                        icon: AppIcons.focusTarget,
                        title: OnboardingStrings.featureWeeklyProgressTitle,
                        description:
                            OnboardingStrings.featureWeeklyProgressDescription,
                      ),
                      SizedBox(height: 28),
                      OnboardingFeatureItem(
                        icon: AppIcons.flash,
                        title:
                            OnboardingStrings.featurePersonalisedInsightsTitle,
                        description: OnboardingStrings
                            .featurePersonalisedInsightsDescription,
                      ),
                      SizedBox(height: 28),
                      OnboardingFeatureItem(
                        icon: AppIcons.shield,
                        title: OnboardingStrings.featureBuiltForPrivacyTitle,
                        description:
                            OnboardingStrings.featureBuiltForPrivacyDescription,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                onPressed: () => Get.toNamed(RoutesName.privacyOnboarding),
                label: AppStrings.continueButton,
              ),
              Platform.isAndroid
                  ? const SizedBox(height: 26)
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
