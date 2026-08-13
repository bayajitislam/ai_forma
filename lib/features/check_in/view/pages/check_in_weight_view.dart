import 'package:ai_forma/features/check_in/view/pages/analysing_view.dart';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/assessment/constants/assessment_strings.dart';
import 'package:ai_forma/features/assessment/view/widgets/weight_selector.dart';
import 'package:ai_forma/features/check_in/constants/check_in_strings.dart';
import 'package:ai_forma/features/check_in/view/widgets/check_in_header.dart';

class CheckInWeightView extends StatefulWidget {
  const CheckInWeightView({super.key});

  @override
  State<CheckInWeightView> createState() => _CheckInWeightViewState();
}

class _CheckInWeightViewState extends State<CheckInWeightView> {
  double _selectedWeightKg = AssessmentStrings.defaultWeightKg.toDouble();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CheckInHeader(),
              const SizedBox(height: 24),
              const Text(
                CheckInStrings.weightTitle,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 12),
              const Text(
                CheckInStrings.weightSubtitle,
                style: AppTextStyles.authBody,
              ),
              const Spacer(),
              Center(
                child: WeightSelector(
                  initialWeightKg: _selectedWeightKg,
                  onChanged: (v) => _selectedWeightKg = v,
                ),
              ),
              const Spacer(),
              PrimaryButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const AnalysingView(),
                    ),
                  );
                },
                label: AppStrings.nextButton,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
