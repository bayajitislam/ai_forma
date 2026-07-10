import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/features/check_in/constants/check_in_strings.dart';
import 'package:ai_forma/features/check_in/view/pages/analysis_complete_view.dart';
import 'package:ai_forma/features/check_in/view/widgets/check_in_header.dart';
import 'package:ai_forma/features/check_in/view/widgets/check_in_widgets.dart';

class AnalysingView extends StatefulWidget {
  const AnalysingView({super.key});

  @override
  State<AnalysingView> createState() => _AnalysingViewState();
}

class _AnalysingViewState extends State<AnalysingView> {
  int _completedSteps = 2;

  @override
  void initState() {
    super.initState();
    _simulateProgress();
  }

  Future<void> _simulateProgress() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _completedSteps = 5);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const AnalysisCompleteView()),
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
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const CheckInHeader(),
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
                return AnalysisStepItem(
                  label: steps[index],
                  isComplete: index < _completedSteps,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
