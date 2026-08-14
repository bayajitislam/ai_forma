import 'dart:io';

import 'package:ai_forma/features/onboarding_assessment/controllers/assessment_controller.dart';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/onboarding_assessment/constants/assessment_strings.dart';
import 'package:ai_forma/features/onboarding_assessment/view/pages/objective_view.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/assessment_flow_header.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/weight_selector.dart';
import 'package:get/get.dart';

class WeightView extends StatefulWidget {
  const WeightView({super.key});

  @override
  State<WeightView> createState() => _WeightViewState();
}

class _WeightViewState extends State<WeightView> {
  double _selectedWeightKg = AssessmentStrings.defaultWeightKg.toDouble();

  @override
  void initState() {
    super.initState();
    _saveToController();
  }

  void _saveToController() {
    if (Get.isRegistered<AssessmentController>()) {
      Get.find<AssessmentController>().setUnitAnswer(
        'weight',
        _selectedWeightKg,
        'kg',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              const AssessmentFlowHeader(currentStep: 4),
              const SizedBox(height: 32),
              const Text(
                AssessmentStrings.weightTitle,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 12),
              const Text(
                AssessmentStrings.weightSubtitle,
                style: AppTextStyles.authBody,
              ),
              const Spacer(),
              Center(
                child: WeightSelector(
                  initialWeightKg: _selectedWeightKg,
                  onChanged: (val) {
                    _selectedWeightKg = val;
                    _saveToController();
                  },
                ),
              ),
              const Spacer(),
              PrimaryButton(
                onPressed: () {
                  _saveToController();
                  if (Get.isRegistered<AssessmentController>()) {
                    Get.find<AssessmentController>().nextStep();
                  }
                  Get.to(() => const ObjectiveView());
                },
                label: AppStrings.nextButton,
              ),
              Platform.isAndroid
                  ? const SizedBox(height: 26)
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
