import 'dart:io';

import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/auth/constants/auth_strings.dart';
import 'package:ai_forma/features/auth/controllers/verify_email_controller.dart';
import 'package:ai_forma/features/auth/view/widgets/auth_circle_icon.dart';
import 'package:ai_forma/features/auth/view/widgets/auth_email_subtitle.dart';
import 'package:ai_forma/features/auth/view/widgets/auth_flow_header.dart';
import 'package:ai_forma/features/auth/view/widgets/auth_message_banner.dart';
import 'package:ai_forma/features/auth/view/widgets/auth_resend_footer.dart';
import 'package:ai_forma/features/auth/view/widgets/verification_code_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyEmailView extends GetView<VerifyEmailController> {
  const VerifyEmailView({super.key});

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
                        const AuthFlowHeader(currentStep: 2),
                        const SizedBox(height: 40),
                        const AuthCircleIcon(
                          icon: AppIcons.mail,
                          size: 72,
                          iconSize: 32,
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          AuthStrings.verifyEmailTitle,
                          style: AppTextStyles.authSectionTitle,
                        ),
                        const SizedBox(height: 12),
                        AuthEmailSubtitle(
                          prefix: AuthStrings.verifyEmailSubtitlePrefix,
                          email: controller.email,
                        ),
                        const SizedBox(height: 32),
                        VerificationCodeInput(
                          onChanged: controller.onCodeChanged,
                        ),
                        const SizedBox(height: 16),
                        AuthMessageBanner(
                          errorMessage: controller.errorMessage,
                          successMessage: controller.successMessage,
                          padding: const EdgeInsets.only(bottom: 4),
                        ),
                        const Spacer(),
                        Obx(
                          () => PrimaryButton(
                            isLoading: controller.isLoading.value,
                            onPressed: controller.isLoading.value
                                ? null
                                : () => controller.verifyEmail(),
                            label: AuthStrings.verifyEmailButton,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Obx(
                          () => AuthResendFooter(
                            canResend: controller.canResend,
                            isResending: controller.isResendLoading.value,
                            timerString: controller.timerString,
                            onResend: () => controller.resendCode(),
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
