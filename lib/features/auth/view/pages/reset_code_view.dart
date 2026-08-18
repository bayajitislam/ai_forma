import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/auth/constants/auth_strings.dart';
import 'package:ai_forma/features/auth/controllers/forgot_password_controller.dart';
import 'package:ai_forma/features/auth/view/widgets/auth_footer_link.dart';
import 'package:ai_forma/features/auth/view/widgets/auth_header.dart';
import 'package:ai_forma/features/auth/view/widgets/verification_code_input.dart';
import 'package:get/get.dart';

class ResetCodeView extends GetView<ForgotPasswordController> {
  const ResetCodeView({super.key});

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
                      children: [
                        const AuthHeader(),
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
                          AuthStrings.resetCodeTitle,
                          style: AppTextStyles.authSectionTitle,
                        ),
                        const SizedBox(height: 12),
                        Obx(
                          () => Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: AuthStrings.resetCodeSubtitlePrefix,
                                  style: AppTextStyles.authBody,
                                ),
                                TextSpan(
                                  text: controller.email.value,
                                  style: AppTextStyles.authBody.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 32),
                        VerificationCodeInput(
                          onChanged: controller.onCodeChanged,
                        ),
                        const SizedBox(height: 16),
                        // API Error or Success Message
                        Obx(() {
                          final err = controller.errorMessage.value;
                          if (err.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  Icon(Icons.error_outline_rounded,
                                      size: 14, color: Colors.red.shade400),
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
                          }

                          final succ = controller.successMessage.value;
                          if (succ.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  const Icon(Icons.check_circle_outline_rounded,
                                      size: 14, color: AppColors.brandTealDark),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      succ,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.brandTealDark,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return const SizedBox.shrink();
                        }),
                        const Spacer(),
                        Obx(
                          () => PrimaryButton(
                            isLoading: controller.isLoading.value,
                            onPressed: controller.isLoading.value
                                ? null
                                : () => controller.verifyCode(),
                            label: AuthStrings.verifyCodeButton,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Obx(() {
                          final canResend = controller.canResend;
                          final isResending = controller.isResendLoading.value;
                          final timerText = controller.timerString;

                          String linkLabel;
                          if (isResending) {
                            linkLabel = 'Resending...';
                          } else if (!canResend) {
                            linkLabel = '${AuthStrings.resendCode} ($timerText)';
                          } else {
                            linkLabel = AuthStrings.resendCode;
                          }

                          return AuthFooterLink(
                            prefix: AuthStrings.didNotReceive,
                            linkText: linkLabel,
                            onLinkTap: canResend ? () => controller.resendCode() : null,
                          );
                        }),
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
