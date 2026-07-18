import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/core/widgets/app_text_field.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/auth/constants/auth_strings.dart';
import 'package:ai_forma/features/assessment/view/pages/gender_view.dart';
import 'package:ai_forma/features/auth/view/pages/forgot_password_view.dart';
import 'package:ai_forma/features/auth/view/pages/signup_view.dart';
import 'package:ai_forma/features/auth/view/widgets/auth_footer_link.dart';
import 'package:ai_forma/features/auth/view/widgets/auth_header.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _obscurePassword = true;

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
              const AuthHeader(),
              const SizedBox(height: 32),
              const Text(
                AuthStrings.loginTitle,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 8),
              const Text(
                AuthStrings.loginSubtitle,
                style: AppTextStyles.authBody,
              ),
              const SizedBox(height: 32),
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
                    icon: _obscurePassword ? AppIcons.eye : AppIcons.eyeOff,
                    size: 22,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const ForgotPasswordView(),
                      ),
                    );
                  },
                  child: const Text(
                    AuthStrings.forgotPassword,
                    style: AppTextStyles.authLink,
                  ),
                ),
              ),
              const Spacer(),
              PrimaryButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (_) => const GenderView(),
                    ),
                  );
                },
                label: AuthStrings.loginButton,
              ),
              const SizedBox(height: 16),
              AuthFooterLink(
                prefix: AuthStrings.noAccount,
                linkText: AuthStrings.signUp,
                onLinkTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const SignupView(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
