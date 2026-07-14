import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/assessment/constants/assessment_strings.dart';
import 'package:ai_forma/features/assessment/view/pages/menstrual_view.dart';
import 'package:ai_forma/features/assessment/view/widgets/assessment_flow_header.dart';
import 'package:ai_forma/features/assessment/view/widgets/assessment_radio_tile.dart';
import 'package:ai_forma/features/assessment/view/widgets/assessment_skip_link.dart';

enum MedicalOption { no, currentInjury, medicalCondition, preferNotToAnswer }

class MedicalView extends StatefulWidget {
  const MedicalView({super.key});

  @override
  State<MedicalView> createState() => _MedicalViewState();
}

class _MedicalViewState extends State<MedicalView> {
  MedicalOption _selected = MedicalOption.no;

  void _goToNext() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const MenstrualView()));
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
              const AssessmentFlowHeader(currentStep: 9),
              const SizedBox(height: 32),
              const Text(
                AssessmentStrings.medicalTitle,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 12),
              const Text(
                AssessmentStrings.medicalSubtitle,
                style: AppTextStyles.authBody,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    AssessmentRadioTile(
                      title: AssessmentStrings.medicalNo,
                      isSelected: _selected == MedicalOption.no,
                      onTap: () => setState(() => _selected = MedicalOption.no),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      title: AssessmentStrings.medicalCurrentInjury,
                      isSelected: _selected == MedicalOption.currentInjury,
                      onTap: () => setState(
                        () => _selected = MedicalOption.currentInjury,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      title: AssessmentStrings.medicalCondition,
                      isSelected: _selected == MedicalOption.medicalCondition,
                      onTap: () => setState(
                        () => _selected = MedicalOption.medicalCondition,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      title: AssessmentStrings.medicalPreferNotToAnswer,
                      isSelected: _selected == MedicalOption.preferNotToAnswer,
                      onTap: () => setState(
                        () => _selected = MedicalOption.preferNotToAnswer,
                      ),
                    ),
                  ],
                ),
              ),
              AssessmentSkipLink(onTap: _goToNext),
              const SizedBox(height: 16),
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
