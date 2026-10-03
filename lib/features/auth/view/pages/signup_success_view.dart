import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/auth/constants/auth_strings.dart';
import 'package:ai_forma/features/auth/controllers/user_controller.dart';
import 'package:ai_forma/features/auth/view/widgets/auth_brand_title.dart';
import 'package:ai_forma/features/auth/view/widgets/auth_circle_icon.dart';
import 'package:ai_forma/features/auth/view/widgets/auth_flow_header.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
              const AuthCircleIcon.successCheck(),
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
                onPressed: () {
                  final user = Get.isRegistered<UserController>()
                      ? Get.find<UserController>().currentUser.value
                      : null;
                  if (user != null && user.onboardingCompleted) {
                    if (!user.initialScanCompleted) {
                      Get.offAllNamed(RoutesName.checkInIntro);
                    } else {
                      Get.offAllNamed(RoutesName.appShell);
                    }
                  } else {
                    Get.offAllNamed(RoutesName.gender);
                  }
                },
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
