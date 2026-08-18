import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/core/widgets/app_text_field.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/auth/constants/auth_strings.dart';
import 'package:ai_forma/features/auth/controllers/login_controller.dart';
import 'package:ai_forma/features/auth/view/widgets/auth_footer_link.dart';
import 'package:ai_forma/features/auth/view/widgets/auth_header.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

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
                          AuthStrings.loginTitle,
                          style: AppTextStyles.authSectionTitle,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          AuthStrings.loginSubtitle,
                          style: AppTextStyles.authBody,
                        ),
                        const SizedBox(height: 32),
                        Obx(
                          () => AppTextField(
                            controller: controller.emailController,
                            label: AuthStrings.emailLabel,
                            hint: AuthStrings.emailHint,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            errorText: controller.emailError.value,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Obx(
                          () => AppTextField(
                            controller: controller.passwordController,
                            label: AuthStrings.passwordLabel,
                            hint: AuthStrings.passwordHint,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) {
                              if (!controller.isLoading.value) {
                                controller.login();
                              }
                            },
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
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(RoutesName.forgotPassword);
                            },
                            child: const Text(
                              AuthStrings.forgotPassword,
                              style: AppTextStyles.authLink,
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
                        }),
                        const Spacer(),
                        Obx(
                          () => PrimaryButton(
                            isLoading: controller.isLoading.value,
                            onPressed: controller.isLoading.value
                                ? null
                                : () => controller.login(),
                            label: AuthStrings.loginButton,
                          ),
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
              ),
            );
          },
        ),
      ),
    );
  }
}
