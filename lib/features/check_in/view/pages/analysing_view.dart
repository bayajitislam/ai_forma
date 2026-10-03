import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/features/check_in/constants/check_in_strings.dart';
import 'package:ai_forma/features/check_in/controllers/check_in_controller.dart';
import 'package:ai_forma/features/check_in/view/widgets/analysis_error_dialog.dart';
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
        // All steps completed
        setState(() => _completedSteps = 5);
        await Future<void>.delayed(const Duration(milliseconds: 600));

        // Dispose CheckInController and free camera/images memory
        Get.delete<CheckInController>(force: true);

        if (!mounted) return;
        Get.offNamed(RoutesName.analysisComplete);
      } else {
        _showErrorDialog(controller.errorMessage.value);
      }
    } else {
      // CheckInController is missing — cannot submit scan.
      // Show an error rather than silently navigating to a false success screen.
      if (!mounted) return;
      _showErrorDialog('Unable to submit scan. Please return and try again.');
    }
  }

  void _showErrorDialog(String message) {
    AnalysisErrorDialog.show(
      context: context,
      message: message,
      onReturnToDashboard: () {
        _stepTimer?.cancel();
        if (Get.isRegistered<CheckInController>()) {
          Get.delete<CheckInController>(force: true);
        }
        Navigator.of(context, rootNavigator: true).pop();
        Get.offAllNamed(RoutesName.appShell);
      },
      onBackToReview: () {
        _stepTimer?.cancel();
        Navigator.of(context, rootNavigator: true).pop();
        Get.offNamed(RoutesName.scanReview);
      },
      onTryAgain: () {
        Navigator.of(context, rootNavigator: true).pop();
        _startAnalysisProcess();
      },
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
