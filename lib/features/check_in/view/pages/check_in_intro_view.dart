import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/check_in/constants/check_in_strings.dart';
import 'package:ai_forma/features/check_in/view/widgets/check_in_header.dart';
import 'package:ai_forma/features/onboarding/view/widgets/onboarding_feature_item.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:get/get.dart';

class CheckInIntroView extends StatelessWidget {
  const CheckInIntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CheckInHeader(showLogout: true),
              const SizedBox(height: 24),
              const Text(
                CheckInStrings.introTitle,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 12),
              const Text(
                CheckInStrings.introSubtitle,
                style: AppTextStyles.authBody,
              ),
              const SizedBox(height: 28),
              const OnboardingFeatureItem(
                icon: AppIcons.flash,
                title: CheckInStrings.introFeature1Title,
                description: CheckInStrings.introFeature1Body,
              ),
              const SizedBox(height: 20),
              const OnboardingFeatureItem(
                icon: AppIcons.star,
                title: CheckInStrings.introFeature2Title,
                description: CheckInStrings.introFeature2Body,
              ),
              const SizedBox(height: 20),
              const OnboardingFeatureItem(
                icon: AppIcons.info,
                title: CheckInStrings.introFeature3Title,
                description: CheckInStrings.introFeature3Body,
              ),
              const Spacer(),
              PrimaryButton(
                onPressed: () {
                  Get.toNamed(RoutesName.cameraPosition);
                },
                label: CheckInStrings.beginFirstCheckIn,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
