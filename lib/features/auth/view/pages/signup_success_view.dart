import 'package:ai_forma/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/auth/constants/auth_strings.dart';
import 'package:ai_forma/features/auth/view/widgets/auth_brand_title.dart';
import 'package:ai_forma/features/auth/view/widgets/auth_flow_header.dart';
import 'package:get/route_manager.dart';

class SignupSuccessView extends StatelessWidget {
  const SignupSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const AuthFlowHeader(currentStep: 3),
              const Spacer(),
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  color: AppColors.iconBackground,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
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
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const AuthWelcomeTitle(),
              const SizedBox(height: 16),
              const Text(
                AuthStrings.successSubtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.authBody,
              ),
              const Spacer(),
              PrimaryButton(
                onPressed: () => Get.offAndToNamed(RoutesName.login),
                label: AuthStrings.beginAssessmentButton,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
