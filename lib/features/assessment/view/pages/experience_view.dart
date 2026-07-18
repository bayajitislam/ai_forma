import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/assessment/constants/assessment_strings.dart';
import 'package:ai_forma/features/assessment/view/pages/sleep_view.dart';
import 'package:ai_forma/features/assessment/view/widgets/assessment_flow_header.dart';
import 'package:ai_forma/features/assessment/view/widgets/assessment_radio_tile.dart';

enum ExperienceOption { beginner, intermediate, advanced }

class ExperienceView extends StatefulWidget {
  const ExperienceView({super.key});

  @override
  State<ExperienceView> createState() => _ExperienceViewState();
}

class _ExperienceViewState extends State<ExperienceView> {
  ExperienceOption _selected = ExperienceOption.intermediate;

  void _goToNext() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const SleepView()));
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
              const AssessmentFlowHeader(currentStep: 6),
              const SizedBox(height: 32),
              const Text(
                AssessmentStrings.experienceTitle,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 12),
              const Text(
                AssessmentStrings.experienceSubtitle,
                style: AppTextStyles.authBody,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    AssessmentRadioTile(
                      icon: AppIcons.user,
                      title: AssessmentStrings.experienceBeginner,
                      subtitle: AssessmentStrings.experienceBeginnerSubtitle,
                      isSelected: _selected == ExperienceOption.beginner,
                      onTap: () =>
                          setState(() => _selected = ExperienceOption.beginner),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      icon: AppIcons.brain,
                      title: AssessmentStrings.experienceIntermediate,
                      subtitle:
                          AssessmentStrings.experienceIntermediateSubtitle,
                      isSelected: _selected == ExperienceOption.intermediate,
                      onTap: () => setState(
                        () => _selected = ExperienceOption.intermediate,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      icon: AppIcons.flash,
                      title: AssessmentStrings.experienceAdvanced,
                      subtitle: AssessmentStrings.experienceAdvancedSubtitle,
                      isSelected: _selected == ExperienceOption.advanced,
                      onTap: () =>
                          setState(() => _selected = ExperienceOption.advanced),
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
