import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_text_field.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/auth/constants/auth_strings.dart';
import 'package:ai_forma/features/auth/controllers/forgot_password_controller.dart';
import 'package:ai_forma/features/auth/view/widgets/auth_header.dart';
import 'package:ai_forma/features/auth/view/widgets/auth_message_banner.dart';
import 'package:get/get.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        Obx(
                          () => AppTextField(
                            controller: controller.emailController,
                            label: AuthStrings.emailLabel,
                            hint: AuthStrings.emailHint,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) {
                              if (!controller.isLoading.value) {
                                controller.sendResetCode();
                              }
                            },
                            errorText: controller.emailError.value,
                          ),
                        ),
                        AuthMessageBanner(errorMessage: controller.errorMessage),
                        const Spacer(),
                        Obx(
                          () => PrimaryButton(
                            isLoading: controller.isLoading.value,
                            onPressed: controller.isLoading.value
                                ? null
                                : () => controller.sendResetCode(),
                            label: AuthStrings.sendResetCodeButton,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: GestureDetector(
                            onTap: () => Get.back(),
                            child: const Text(
                              AuthStrings.backToLogIn,
                              style: AppTextStyles.authBody,
                            ),
                          ),
                        ),
                        Platform.isAndroid
                            ? const SizedBox(height: 26)
                            : const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
