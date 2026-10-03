import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:ai_forma/core/storage/auth_storage.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_navbar.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/check_in/constants/check_in_strings.dart';
import 'package:ai_forma/features/check_in/controllers/check_in_controller.dart';
import 'package:ai_forma/features/check_in/view/widgets/body_scan_animation.dart';
import 'package:ai_forma/features/check_in/view/widgets/check_in_header.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:get/get.dart';

class AnalysisCompleteView extends StatefulWidget {
  const AnalysisCompleteView({super.key});

  @override
  State<AnalysisCompleteView> createState() => _AnalysisCompleteViewState();
}

class _AnalysisCompleteViewState extends State<AnalysisCompleteView> {
  bool _isFirstScan = false;

  @override
  void initState() {
    super.initState();
    // Dispose CheckInController and release memory/camera resources when reaching this view
    if (Get.isRegistered<CheckInController>()) {
      Get.delete<CheckInController>(force: true);
    }
    _loadScanContext();
  }

  Future<void> _loadScanContext() async {
    // If isFirstCheckInCompleted() returns false -> this IS the first scan.
    final alreadyCompleted = await AuthStorage.isFirstCheckInCompleted();
    if (mounted) {
      setState(() => _isFirstScan = !alreadyCompleted);
    }
  }

  Future<void> _navigateToAppShell() async {
    await AuthStorage.setFirstCheckInCompleted(true);
    Get.offAllNamed(RoutesName.appShell, arguments: AppNavItem.insights);
  }

  String get _subtitle => _isFirstScan
      ? CheckInStrings.completeSubtitleFirstScan
      : CheckInStrings.completeSubtitleRepeatScan;

  @override
  Widget build(BuildContext context) {
    // Responsive tokens
    final mq = MediaQuery.of(context);
    final screenH = mq.size.height;
    final screenW = mq.size.width;

    // Scale factor relative to a 390px-wide reference phone
    final wScale = (screenW / 390).clamp(0.75, 1.5);
    // Scale factor relative to a 844px-tall reference phone (iPhone 14)
    final hScale = (screenH / 844).clamp(0.65, 1.4);

    // Responsive spacing
    final gapSm = (8.0 * hScale).clamp(4.0, 14.0);
    final gapMd = (12.0 * hScale).clamp(6.0, 18.0);
    final hPad = (16.0 * wScale).clamp(12.0, 28.0);

    // Responsive card text
    final titleSize = (22.0 * wScale).clamp(17.0, 28.0);
    final subtitleSize = (14.0 * wScale).clamp(12.0, 17.0);
    final cardPadV = (16.0 * hScale).clamp(12.0, 24.0);
    final cardPadH = (20.0 * wScale).clamp(14.0, 28.0);

    // On tablets / large screens centre + constrain max width
    final maxW = math.min(screenW, 560.0);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _navigateToAppShell();
      },
      child: Scaffold(
        backgroundColor: AppColors.onboardingBackground,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxW),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: Column(
                  children: [
                    // Header
                    const CheckInHeader(
                      isTitle: true,
                      title: CheckInStrings.result,
                    ),
                    SizedBox(height: gapSm),

                    // Body scan animation - fills remaining vertical space
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: hPad * 0.75,
                          vertical: (14.0 * hScale).clamp(10.0, 20.0),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.cardBorder),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.brandTealLight
                                  .withValues(alpha: 0.06),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const BodyScanAnimation(),
                      ),
                    ),

                    SizedBox(height: gapMd),

                    // Info card - always pinned at bottom
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: cardPadH,
                        vertical: cardPadV,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.cardBorder),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.brandTealLight
                                .withValues(alpha: 0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            CheckInStrings.analysisCompleteBadge,
                            style: AppTextStyles.dashboardSectionLabel,
                          ),
                          SizedBox(height: gapSm * 0.6),
                          Text(
                            CheckInStrings.completeTitle,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.authSectionTitle
                                .copyWith(fontSize: titleSize),
                          ),
                          SizedBox(height: gapSm * 0.75),
                          Text(
                            _subtitle,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.authBody
                                .copyWith(fontSize: subtitleSize),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: gapMd),

                    // CTA
                    PrimaryButton(
                      onPressed: _navigateToAppShell,
                      label: CheckInStrings.viewResults,
                    ),
                    SizedBox(height: gapMd),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
