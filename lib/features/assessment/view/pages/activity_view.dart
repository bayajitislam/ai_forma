import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/assessment/constants/assessment_strings.dart';
import 'package:ai_forma/features/assessment/view/pages/medical_view.dart';
import 'package:ai_forma/features/assessment/view/widgets/assessment_flow_header.dart';
import 'package:ai_forma/features/assessment/view/widgets/assessment_radio_tile.dart';

enum ActivityOption { sedentary, lightlyActive, moderatelyActive, veryActive }

class ActivityView extends StatefulWidget {
  const ActivityView({super.key});

  @override
  State<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> {
  ActivityOption _selected = ActivityOption.moderatelyActive;

  void _goToNext() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const MedicalView()));
  }

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
              const AssessmentFlowHeader(currentStep: 8),
              const SizedBox(height: 32),
              const Text(
                AssessmentStrings.activityTitle,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 12),
              const Text(
                AssessmentStrings.activitySubtitle,
                style: AppTextStyles.authBody,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    AssessmentRadioTile(
                      icon: AppIcons.user,
                      title: AssessmentStrings.activitySedentary,
                      subtitle: AssessmentStrings.activitySedentarySubtitle,
                      isSelected: _selected == ActivityOption.sedentary,
                      onTap: () =>
                          setState(() => _selected = ActivityOption.sedentary),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      icon: AppIcons.heartPulse,
                      title: AssessmentStrings.activityLightlyActive,
                      subtitle: AssessmentStrings.activityLightlyActiveSubtitle,
                      isSelected: _selected == ActivityOption.lightlyActive,
                      onTap: () => setState(
                        () => _selected = ActivityOption.lightlyActive,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      icon: AppIcons.flash,
                      title: AssessmentStrings.activityModeratelyActive,
                      subtitle:
                          AssessmentStrings.activityModeratelyActiveSubtitle,
                      isSelected: _selected == ActivityOption.moderatelyActive,
                      onTap: () => setState(
                        () => _selected = ActivityOption.moderatelyActive,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      icon: AppIcons.run,
                      title: AssessmentStrings.activityVeryActive,
                      subtitle: AssessmentStrings.activityVeryActiveSubtitle,
                      isSelected: _selected == ActivityOption.veryActive,
                      onTap: () =>
                          setState(() => _selected = ActivityOption.veryActive),
                    ),
                  ],
                ),
              ),
              PrimaryButton(onPressed: _goToNext, label: AppStrings.nextButton),
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
