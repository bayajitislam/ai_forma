import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/assessment/constants/assessment_strings.dart';
import 'package:ai_forma/features/assessment/view/pages/age_view.dart';
import 'package:ai_forma/features/assessment/view/widgets/assessment_flow_header.dart';
import 'package:ai_forma/features/assessment/view/widgets/assessment_option_card.dart';

enum GenderOption { male, female }

class GenderView extends StatefulWidget {
  const GenderView({super.key});

  @override
  State<GenderView> createState() => _GenderViewState();
}

class _GenderViewState extends State<GenderView> {
  GenderOption _selectedGender = GenderOption.female;

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
              const AssessmentFlowHeader(currentStep: 1),
              const SizedBox(height: 32),
              const Text(
                AssessmentStrings.genderTitle,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 12),
              const Text(
                AssessmentStrings.genderSubtitle,
                style: AppTextStyles.authBody,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: AssessmentOptionCard(
                      icon: AppIcons.user,
                      label: AssessmentStrings.genderMale,
                      isSelected: _selectedGender == GenderOption.male,
                      onTap: () {
                        setState(() {
                          _selectedGender = GenderOption.male;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AssessmentOptionCard(
                      icon: AppIcons.user,
                      label: AssessmentStrings.genderFemale,
                      isSelected: _selectedGender == GenderOption.female,
                      onTap: () {
                        setState(() {
                          _selectedGender = GenderOption.female;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const Spacer(),
              PrimaryButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const AgeView(),
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
