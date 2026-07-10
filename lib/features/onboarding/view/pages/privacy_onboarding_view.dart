import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/onboarding/constants/privacy_strings.dart';
import 'package:ai_forma/features/auth/view/pages/signup_view.dart';
import 'package:ai_forma/features/onboarding/view/widgets/onboarding_header.dart';
import 'package:ai_forma/features/onboarding/view/widgets/privacy_card.dart';

class PrivacyOnboardingView extends StatelessWidget {
  const PrivacyOnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const OnboardingHeader(),
              const SizedBox(height: 32),
              const Text(
                PrivacyStrings.title,
                style: AppTextStyles.onboardingTitle,
              ),
              const SizedBox(height: 12),
              const Text(
                PrivacyStrings.subtitle,
                style: AppTextStyles.onboardingSubtitle,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: const [
                      PrivacyCard(
                        icon: AppIcons.user,
                        label: PrivacyStrings.youOwnYourData,
                      ),
                      SizedBox(height: 12),
                      PrivacyCard(
                        icon: AppIcons.shield,
                        label: PrivacyStrings.weNeverShare,
                      ),
                      SizedBox(height: 12),
                      PrivacyCard(
                        icon: AppIcons.lock,
                        label: PrivacyStrings.endToEndEncryption,
                      ),
                      SizedBox(height: 12),
                      PrivacyCard(
                        icon: AppIcons.cloud,
                        label: PrivacyStrings.protectedCloudStorage,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const SignupView(),
                    ),
                  );
                },
                label: AppStrings.continueButton,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
