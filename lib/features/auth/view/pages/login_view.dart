import 'package:ai_forma/routes/routes_name.dart';
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
import 'package:ai_forma/features/auth/view/widgets/auth_footer_link.dart';
import 'package:ai_forma/features/auth/view/widgets/auth_header.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _obscurePassword = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
              AppTextField(
                controller: _emailController,
                label: AuthStrings.emailLabel,
                hint: AuthStrings.emailHint,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _passwordController,
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
                    MaterialPageRoute<void>(builder: (_) => const GenderView()),
                  );
                },
                label: AuthStrings.loginButton,
              ),
              const SizedBox(height: 16),
              AuthFooterLink(
                prefix: AuthStrings.noAccount,
                linkText: AuthStrings.signUp,
                onLinkTap: () => Get.toNamed(RoutesName.signup),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
