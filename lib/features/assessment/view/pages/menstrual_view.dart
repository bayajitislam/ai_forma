import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/assessment/constants/assessment_strings.dart';
import 'package:ai_forma/features/assessment/view/pages/supplements_view.dart';
import 'package:ai_forma/features/assessment/view/widgets/assessment_flow_header.dart';
import 'package:ai_forma/features/assessment/view/widgets/assessment_radio_tile.dart';
import 'package:ai_forma/features/assessment/view/widgets/assessment_skip_link.dart';

enum MenstrualOption {
  menstrual,
  follicular,
  ovulation,
  luteal,
  notSure,
  preferNotToSay,
}

class MenstrualView extends StatefulWidget {
  const MenstrualView({super.key});

  @override
  State<MenstrualView> createState() => _MenstrualViewState();
}

class _MenstrualViewState extends State<MenstrualView> {
  MenstrualOption _selected = MenstrualOption.menstrual;

  void _goToNext() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const SupplementsView()),
    );
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
              const AssessmentFlowHeader(currentStep: 10),
              const SizedBox(height: 32),
              const Text(
                AssessmentStrings.menstrualTitle,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 12),
              const Text(
                AssessmentStrings.menstrualSubtitle,
                style: AppTextStyles.authBody,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    AssessmentRadioTile(
                      title: AssessmentStrings.menstrualPhase,
                      isSelected: _selected == MenstrualOption.menstrual,
                      onTap: () => setState(
                        () => _selected = MenstrualOption.menstrual,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      title: AssessmentStrings.menstrualFollicular,
                      isSelected: _selected == MenstrualOption.follicular,
                      onTap: () => setState(
                        () => _selected = MenstrualOption.follicular,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      title: AssessmentStrings.menstrualOvulation,
                      isSelected: _selected == MenstrualOption.ovulation,
                      onTap: () => setState(
                        () => _selected = MenstrualOption.ovulation,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      title: AssessmentStrings.menstrualLuteal,
                      isSelected: _selected == MenstrualOption.luteal,
                      onTap: () => setState(
                        () => _selected = MenstrualOption.luteal,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      title: AssessmentStrings.menstrualNotSure,
                      isSelected: _selected == MenstrualOption.notSure,
                      onTap: () => setState(
                        () => _selected = MenstrualOption.notSure,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      title: AssessmentStrings.menstrualPreferNotToSay,
                      isSelected: _selected == MenstrualOption.preferNotToSay,
                      onTap: () => setState(
                        () => _selected = MenstrualOption.preferNotToSay,
                      ),
                    ),
                  ],
                ),
              ),
              AssessmentSkipLink(onTap: _goToNext),
              const SizedBox(height: 16),
              PrimaryButton(
                onPressed: _goToNext,
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
