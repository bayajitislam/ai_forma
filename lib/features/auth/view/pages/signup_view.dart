import 'dart:io';
import 'package:ai_forma/features/auth/controllers/signup_controller.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/core/widgets/app_text_field.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/auth/constants/auth_strings.dart';
import 'package:ai_forma/features/auth/view/widgets/auth_brand_title.dart';
import 'package:ai_forma/features/auth/view/widgets/auth_flow_header.dart';
import 'package:ai_forma/features/auth/view/widgets/auth_footer_link.dart';
import 'package:ai_forma/features/auth/view/widgets/password_requirements.dart';
import 'package:get/get.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

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
                      Obx(
                        () => AppTextField(
                          controller: controller.fullNameController,
                          label: AuthStrings.fullNameLabel,
                          hint: AuthStrings.fullNameHint,
                          errorText: controller.nameError.value,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Obx(
                        () => AppTextField(
                          controller: controller.emailController,
                          label: AuthStrings.emailLabel,
                          hint: AuthStrings.emailHint,
                          errorText: controller.emailError.value,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Obx(
                        () => AppTextField(
                          controller: controller.passwordController,
                          label: AuthStrings.passwordLabel,
                          hint: AuthStrings.passwordHint,
                          obscureText: controller.isPasswordObsecure.value,
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.isPasswordObsecure.value =
                                  !controller.isPasswordObsecure.value;
                            },
                            icon: AppIcon(
                              icon: controller.isPasswordObsecure.value
                                  ? AppIcons.eye
                                  : AppIcons.eyeOff,
                              size: 22,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      //API / general error banner above password requirements
                      Obx(() {
                        final msg = controller.errorMessage.value;
                        if (msg.isEmpty) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.error_outline_rounded,
                                  size: 15, color: Colors.red.shade400),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  msg,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.red.shade400,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const PasswordRequirements(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => PrimaryButton(
                  isLoading: controller.isLoading.value,
                  onPressed: controller.isPasswordValid
                      ? () => controller.signUp()
                      : null,
                  label: AuthStrings.createAccountButton,
                ),
              ),
              const SizedBox(height: 16),
              AuthFooterLink(
                prefix: AuthStrings.alreadyHaveAccount,
                linkText: AuthStrings.logIn,
                onLinkTap: () => Get.toNamed(RoutesName.login),
              ),
              Platform.isAndroid
                  ? const SizedBox(height: 26)
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
