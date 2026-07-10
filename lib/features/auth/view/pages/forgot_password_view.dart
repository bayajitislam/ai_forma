import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_text_field.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/auth/constants/auth_strings.dart';
import 'package:ai_forma/features/auth/view/pages/reset_code_view.dart';
import 'package:ai_forma/features/auth/view/widgets/auth_header.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

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
              const AuthHeader(),
              const SizedBox(height: 32),
              const Text(
                AuthStrings.forgotPasswordTitle,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 12),
              const Text(
                AuthStrings.forgotPasswordSubtitle,
                style: AppTextStyles.authBody,
              ),
              const SizedBox(height: 32),
              const AppTextField(
                label: AuthStrings.emailLabel,
                hint: AuthStrings.emailHint,
              ),
              const Spacer(),
              PrimaryButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const ResetCodeView(),
                    ),
                  );
                },
                label: AuthStrings.sendResetCodeButton,
              ),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: const Text(
                    AuthStrings.backToLogIn,
                    style: AppTextStyles.authBody,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
