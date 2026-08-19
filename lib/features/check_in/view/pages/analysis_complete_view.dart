import 'package:flutter/material.dart';
import 'package:ai_forma/core/storage/auth_storage.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_navbar.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/check_in/constants/check_in_strings.dart';
import 'package:ai_forma/features/check_in/controllers/check_in_controller.dart';
import 'package:ai_forma/features/check_in/view/widgets/check_in_header.dart';
import 'package:ai_forma/features/shell/view/pages/app_shell_view.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class AnalysisCompleteView extends StatefulWidget {
  const AnalysisCompleteView({super.key});

  @override
  State<AnalysisCompleteView> createState() => _AnalysisCompleteViewState();
}

class _AnalysisCompleteViewState extends State<AnalysisCompleteView> {
  @override
  void initState() {
    super.initState();
    // Dispose CheckInController and release memory/camera resources when reaching this view
    if (Get.isRegistered<CheckInController>()) {
      Get.delete<CheckInController>();
    }
  }

  Future<void> _navigateToAppShell() async {
    // Mark 1st Check-In as completed locally
    await AuthStorage.setFirstCheckInCompleted(true);
    // Navigate to AppShell with Insights tab active
    Get.offAll(() => const AppShellView(initialTab: AppNavItem.insights));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _navigateToAppShell();
      },
      child: Scaffold(
        backgroundColor: AppColors.onboardingBackground,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const CheckInHeader(isTitle: true, title: CheckInStrings.result),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          // Lottie Success Animation
                          SizedBox(
                            width: 300,
                            height: 300,
                            child: Lottie.asset(
                              'assets/lottie/Security.json',
                              width: 300,
                              height: 300,
                              repeat: true,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Title & Subtitle Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 28,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.cardBorder),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.brandTealLight.withValues(
                                    alpha: 0.05,
                                  ),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  CheckInStrings.completeTitle,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.authSectionTitle.copyWith(
                                    fontSize: 24,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                const Text(
                                  CheckInStrings.completeSubtitle,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.authBody,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                PrimaryButton(
                  onPressed: _navigateToAppShell,
                  label: CheckInStrings.viewResults,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
