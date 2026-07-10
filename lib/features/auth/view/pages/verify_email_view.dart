import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/auth/constants/auth_strings.dart';
import 'package:ai_forma/features/auth/view/pages/signup_success_view.dart';
import 'package:ai_forma/features/auth/view/widgets/auth_flow_header.dart';
import 'package:ai_forma/features/auth/view/widgets/auth_footer_link.dart';
import 'package:ai_forma/features/auth/view/widgets/verification_code_input.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const AuthFlowHeader(currentStep: 2),
              const SizedBox(height: 40),
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: AppColors.iconBackground,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: AppIcon(icon: AppIcons.mail, size: 32),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                AuthStrings.verifyEmailTitle,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 12),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: AuthStrings.verifyEmailSubtitlePrefix,
                      style: AppTextStyles.authBody,
                    ),
                    TextSpan(
                      text: AuthStrings.emailHint,
                      style: AppTextStyles.authBody.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              const VerificationCodeInput(),
              const Spacer(),
              PrimaryButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const SignupSuccessView(),
                    ),
                  );
                },
                label: AuthStrings.verifyEmailButton,
              ),
              const SizedBox(height: 16),
              AuthFooterLink(
                prefix: AuthStrings.didNotReceive,
                linkText: AuthStrings.resendCode,
                onLinkTap: () {},
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
