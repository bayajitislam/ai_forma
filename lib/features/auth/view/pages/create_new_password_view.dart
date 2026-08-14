import 'dart:io';

import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/core/widgets/app_text_field.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/auth/constants/auth_strings.dart';
import 'package:ai_forma/features/auth/controllers/forgot_password_controller.dart';
import 'package:ai_forma/features/auth/view/widgets/auth_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateNewPasswordView extends GetView<ForgotPasswordController> {
  const CreateNewPasswordView({super.key});

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
                AuthStrings.createNewPasswordTitle,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 8),
              const Text(
                AuthStrings.createNewPasswordSubtitle,
                style: AppTextStyles.authBody,
              ),
              const SizedBox(height: 32),
              Obx(
                () => AppTextField(
                  controller: controller.newPasswordController,
                  label: AuthStrings.passwordLabel,
                  hint: AuthStrings.passwordHint,
                  obscureText: controller.isPasswordObsecure.value,
                  errorText: controller.passwordError.value,
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
              Obx(
                () => AppTextField(
                  controller: controller.confirmPasswordController,
                  label: AuthStrings.confirmPasswordLabel,
                  hint: AuthStrings.confirmPasswordHint,
                  obscureText: controller.isConfirmObsecure.value,
                  suffixIcon: IconButton(
                    onPressed: () {
                      controller.isConfirmObsecure.value =
                          !controller.isConfirmObsecure.value;
                    },
                    icon: AppIcon(
                      icon: controller.isConfirmObsecure.value
                          ? AppIcons.eye
                          : AppIcons.eyeOff,
                      size: 22,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // API Error Banner
              Obx(() {
                final err = controller.errorMessage.value;
                if (err.isEmpty) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 14,
                        color: Colors.red.shade400,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          err,
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
              const Spacer(),
              Obx(
                () => PrimaryButton(
                  isLoading: controller.isLoading.value,
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.submitNewPassword(),
                  label: AuthStrings.resetPasswordButton,
                ),
              ),
              const SizedBox(height: 16),
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
