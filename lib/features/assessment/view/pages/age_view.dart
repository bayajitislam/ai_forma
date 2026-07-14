import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/assessment/constants/assessment_strings.dart';
import 'package:ai_forma/features/assessment/view/pages/height_view.dart';
import 'package:ai_forma/features/assessment/view/widgets/age_wheel_picker.dart';
import 'package:ai_forma/features/assessment/view/widgets/assessment_flow_header.dart';

class AgeView extends StatelessWidget {
  const AgeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
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
                  onChanged: (_) {},
                ),
              ),
              const Spacer(),
              PrimaryButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const HeightView()),
                  );
                },
                label: AppStrings.nextButton,
              ),
              Platform.isAndroid
                  ? const SizedBox(height: 26)
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
