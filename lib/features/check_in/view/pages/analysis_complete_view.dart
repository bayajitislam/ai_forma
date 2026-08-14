import 'package:ai_forma/core/storage/auth_storage.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_images.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/check_in/constants/check_in_strings.dart';
import 'package:ai_forma/features/check_in/view/widgets/check_in_header.dart';
import 'package:get/get.dart';

class AnalysisCompleteView extends StatelessWidget {
  const AnalysisCompleteView({super.key});

  Future<void> _onViewResults() async {
    // Mark 1st Check-In as completed locally
    await AuthStorage.setFirstCheckInCompleted(true);
    // Navigate to AppShell and clear check-in flow from stack
    Get.offAllNamed(RoutesName.appShell);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const CheckInHeader(isTitle: true, title: CheckInStrings.result),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        width: 202,
                        height: 336,
                        decoration: BoxDecoration(
                          color: AppColors.insightChartBackground,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            AppImages.frontView,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 24,
                        ),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.brandTealLight.withValues(
                                alpha: 0.07,
                              ),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Text(
                              CheckInStrings.completeTitle,
                              style: AppTextStyles.authSectionTitle.copyWith(
                                fontSize: 26,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              CheckInStrings.completeSubtitle,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.authBody,
                            ),
                            const SizedBox(height: 36),
                            const Row(
                              children: [
                                Expanded(
                                  child: _StatColumn(
                                    label: CheckInStrings.checkInLabel,
                                    value: CheckInStrings.checkInNumber,
                                  ),
                                ),
                                Expanded(
                                  child: _StatColumn(
                                    label: CheckInStrings.currentStreakLabel,
                                    value: CheckInStrings.streakNumber,
                                    suffix: CheckInStrings.streakUnit,
                                  ),
                                ),
                                Expanded(
                                  child: _StatColumn(
                                    label: CheckInStrings.momentumLabel,
                                    value: CheckInStrings.momentumValue,
                                    suffix: CheckInStrings.momentumSuffix,
                                    highlight: true,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              PrimaryButton(
                onPressed: _onViewResults,
                label: CheckInStrings.viewResults,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
    required this.label,
    required this.value,
    this.suffix,
    this.highlight = false,
  });

  final String label;
  final String value;
  final String? suffix;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.dashboardMetricLabel,
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: highlight ? AppColors.brandTeal : AppColors.textPrimary,
              ),
            ),
            if (suffix != null)
              Text(
                suffix!,
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: highlight
                      ? AppColors.textSecondary
                      : AppColors.textPrimary,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
