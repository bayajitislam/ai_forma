import 'dart:io';

import 'package:ai_forma/features/onboarding_assessment/controllers/assessment_controller.dart';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/onboarding_assessment/constants/assessment_strings.dart';
import 'package:ai_forma/features/onboarding_assessment/view/pages/height_view.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/age_wheel_picker.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/assessment_flow_header.dart';
import 'package:get/get.dart';

class AgeView extends StatefulWidget {
  const AgeView({super.key});

  @override
  State<AgeView> createState() => _AgeViewState();
}

class _AgeViewState extends State<AgeView> {
  int _selectedAge = AssessmentStrings.defaultAge;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<AssessmentController>()) {
      Get.find<AssessmentController>().setAnswer('age', _selectedAge);
    }
  }

  void _onAgeChanged(int val) {
    _selectedAge = val;
    if (Get.isRegistered<AssessmentController>()) {
      Get.find<AssessmentController>().setAnswer('age', val);
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const AssessmentFlowHeader(currentStep: 2),
              const SizedBox(height: 32),
              const Text(
                AssessmentStrings.ageTitle,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 12),
              const Text(
                AssessmentStrings.ageSubtitle,
                style: AppTextStyles.authBody,
              ),
              const Spacer(),
              Center(
                child: AgeWheelPicker(
                  minAge: AssessmentStrings.minAge,
                  maxAge: AssessmentStrings.maxAge,
                  initialAge: AssessmentStrings.defaultAge,
                  onChanged: _onAgeChanged,
                ),
              ),
              const Spacer(),
              PrimaryButton(
                onPressed: () {
                  if (Get.isRegistered<AssessmentController>()) {
                    Get.find<AssessmentController>().nextStep();
                  }
                  Get.to(() => const HeightView());
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
