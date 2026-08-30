import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_secondary_button.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/check_in/constants/check_in_strings.dart';
import 'package:ai_forma/features/check_in/controllers/check_in_controller.dart';
import 'package:ai_forma/features/check_in/view/widgets/check_in_header.dart';
import 'package:ai_forma/features/check_in/view/widgets/check_in_widgets.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:get/get.dart';

class AnalysingView extends StatefulWidget {
  const AnalysingView({super.key});

  @override
  State<AnalysingView> createState() => _AnalysingViewState();
}

class _AnalysingViewState extends State<AnalysingView> {
  int _completedSteps = 0;
  Timer? _stepTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _startAnalysisProcess();
      }
    });
  }

  @override
  void dispose() {
    _stepTimer?.cancel();
    super.dispose();
  }

  Future<void> _startAnalysisProcess() async {
    // Reset step counter
    setState(() => _completedSteps = 0);

    // 1. Step animation timer: advance steps over ~15-20 seconds
    _stepTimer?.cancel();
    _stepTimer = Timer.periodic(const Duration(milliseconds: 3500), (timer) {
      if (!mounted) return;
      if (_completedSteps < 4) {
        setState(() => _completedSteps++);
      } else {
        timer.cancel();
      }
    });

    // 2. Execute real API call POST /api/scans/
    if (Get.isRegistered<CheckInController>()) {
      final controller = Get.find<CheckInController>();
      final success = await controller.submitScan();

      _stepTimer?.cancel();

      if (!mounted) return;

      if (success) {
        // All steps completed!
        setState(() => _completedSteps = 5);
        await Future<void>.delayed(const Duration(milliseconds: 600));

        // Dispose CheckInController and free camera/images memory
        Get.delete<CheckInController>(force: true);

        if (!mounted) return;
        Get.offNamed(RoutesName.analysisComplete);
      } else {
        _showRedesignedErrorDialog(controller.errorMessage.value);
      }
    } else {
      // Fallback delay if controller is missing
      await Future<void>.delayed(const Duration(seconds: 4));
      if (!mounted) return;
      Get.offNamed(RoutesName.analysisComplete);
    }
  }

  void _showRedesignedErrorDialog(String message) {
    final lowerMsg = message.toLowerCase();
    final bool isWindowClosed =
        lowerMsg.contains('window') ||
        lowerMsg.contains('closed') ||
        lowerMsg.contains('not available') ||
        lowerMsg.contains('schedule') ||
        lowerMsg.contains('subscription') ||
        lowerMsg.contains('paywall');

    final String dialogTitle = isWindowClosed
        ? 'Check-In Window Closed'
        : 'Analysis Failed';
    final IconData dialogIcon = isWindowClosed
        ? Icons.event_busy_rounded
        : Icons.warning_amber_rounded;
    final Color dialogAccentColor = isWindowClosed
        ? AppColors.brandTeal
        : Colors.redAccent;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: dialogAccentColor.withValues(alpha: 0.3),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: dialogAccentColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(dialogIcon, color: dialogAccentColor, size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                dialogTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message.isNotEmpty
                    ? message
                    : 'Failed to process body scan analysis. Please try again.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              if (isWindowClosed) ...[
                PrimaryButton(
                  onPressed: () {
                    _stepTimer?.cancel();
                    if (Get.isRegistered<CheckInController>()) {
                      Get.delete<CheckInController>(force: true);
                    }
                    Navigator.of(context, rootNavigator: true).pop();
                    Get.offAllNamed(RoutesName.appShell);
                  },
                  label: 'Return to Dashboard',
                ),
                const SizedBox(height: 10),
                AppSecondaryButton(
                  onPressed: () {
                    _stepTimer?.cancel();
                    Navigator.of(context, rootNavigator: true).pop();
                    Get.offNamed(RoutesName.scanReview);
                  },
                  label: 'Back to Review',
                ),
              ] else ...[
                PrimaryButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    _startAnalysisProcess();
                  },
                  label: 'Try Again',
                ),
                const SizedBox(height: 10),
                AppSecondaryButton(
                  onPressed: () {
                    _stepTimer?.cancel();
                    Navigator.of(context, rootNavigator: true).pop();
                    Get.offNamed(RoutesName.scanReview);
                  },
                  label: 'Back to Review',
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    _stepTimer?.cancel();
                    if (Get.isRegistered<CheckInController>()) {
                      Get.delete<CheckInController>(force: true);
                    }
                    Navigator.of(context, rootNavigator: true).pop();
                    Get.offAllNamed(RoutesName.appShell);
                  },
                  child: const Text(
                    'Return to Dashboard',
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    const steps = [
      CheckInStrings.stepMapping,
      CheckInStrings.stepMuscle,
      CheckInStrings.stepSymmetry,
      CheckInStrings.stepInsights,
      CheckInStrings.stepProfile,
    ];

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const CheckInHeader(title: CheckInStrings.analysing),
              const SizedBox(height: 48),
              const Text(
                CheckInStrings.analysingTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 12),
              const Text(
                CheckInStrings.analysingSubtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.authBody,
              ),
              const SizedBox(height: 40),
              ...List.generate(steps.length, (index) {
                StepStatus stepStatus;
                if (index < _completedSteps) {
                  stepStatus = StepStatus.complete;
                } else if (index == _completedSteps) {
                  stepStatus = StepStatus.loading;
                } else {
                  stepStatus = StepStatus.pending;
                }

                return AnalysisStepItem(
                  label: steps[index],
                  status: stepStatus,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
