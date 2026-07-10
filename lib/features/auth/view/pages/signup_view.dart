import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/core/widgets/app_text_field.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/auth/constants/auth_strings.dart';
import 'package:ai_forma/features/auth/view/utils/auth_navigation.dart';
import 'package:ai_forma/features/auth/view/pages/verify_email_view.dart';
import 'package:ai_forma/features/auth/view/widgets/auth_brand_title.dart';
import 'package:ai_forma/features/auth/view/widgets/auth_flow_header.dart';
import 'package:ai_forma/features/auth/view/widgets/auth_footer_link.dart';
import 'package:ai_forma/features/auth/view/widgets/password_requirements.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  bool _obscurePassword = true;

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
              const AuthFlowHeader(currentStep: 1),
              const SizedBox(height: 24),
              const AuthBrandTitle(
                prefix: AuthStrings.signupTitlePrefix,
                suffix: AuthStrings.signupTitleSuffix,
              ),
              const SizedBox(height: 8),
              const Text(
                AuthStrings.signupSubtitle,
                style: AppTextStyles.authBody,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const AppTextField(
                        label: AuthStrings.fullNameLabel,
                        hint: AuthStrings.fullNameHint,
                      ),
                      const SizedBox(height: 16),
                      const AppTextField(
                        label: AuthStrings.emailLabel,
                        hint: AuthStrings.emailHint,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: AuthStrings.passwordLabel,
                        hint: AuthStrings.passwordHint,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: AppIcon(
                            icon: _obscurePassword
                                ? AppIcons.eye
                                : AppIcons.eyeOff,
                            size: 22,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const PasswordRequirements(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const VerifyEmailView(),
                    ),
                  );
                },
                label: AuthStrings.createAccountButton,
              ),
              const SizedBox(height: 16),
              AuthFooterLink(
                prefix: AuthStrings.alreadyHaveAccount,
                linkText: AuthStrings.logIn,
                onLinkTap: () => navigateToLogin(context),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
