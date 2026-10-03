import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_secondary_button.dart';
import 'package:ai_forma/features/auth/constants/auth_strings.dart';
import 'package:ai_forma/features/auth/view/widgets/auth_circle_icon.dart';
import 'package:ai_forma/features/auth/view/widgets/auth_header.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordSuccessView extends StatelessWidget {
  const ResetPasswordSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const AuthHeader(),
              const Spacer(),
              const AuthCircleIcon(
                icon: AppIcons.sendPlane,
                size: 96,
                iconSize: 40,
              ),
              const SizedBox(height: 32),
              const Text(
                AuthStrings.resetSuccessTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 16),
              const Text(
                AuthStrings.resetSuccessSubtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.authBody,
              ),
              const Spacer(),
              AppSecondaryButton(
                onPressed: () => Get.toNamed(RoutesName.login),
                label: AuthStrings.backToLogIn,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
