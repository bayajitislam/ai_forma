import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/assessment/constants/assessment_strings.dart';
import 'package:ai_forma/features/assessment/view/widgets/assessment_checkbox_tile.dart';
import 'package:ai_forma/features/assessment/view/widgets/assessment_flow_header.dart';
import 'package:ai_forma/features/assessment/view/widgets/assessment_skip_link.dart';
import 'package:ai_forma/features/shell/view/utils/shell_navigation.dart';

enum SupplementOption {
  protein,
  creatine,
  preWorkout,
  vitamins,
  omega3,
  other,
}

class SupplementsView extends StatefulWidget {
  const SupplementsView({super.key});

  @override
  State<SupplementsView> createState() => _SupplementsViewState();
}

class _SupplementsViewState extends State<SupplementsView> {
  final Set<SupplementOption> _selected = {
    SupplementOption.protein,
    SupplementOption.creatine,
  };

  void _toggle(SupplementOption option) {
    setState(() {
      if (_selected.contains(option)) {
        _selected.remove(option);
      } else {
        _selected.add(option);
      }
    });
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
              const AssessmentFlowHeader(currentStep: 11),
              const SizedBox(height: 32),
              const Text(
                AssessmentStrings.supplementsTitle,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 12),
              const Text(
                AssessmentStrings.supplementsSubtitle,
                style: AppTextStyles.authBody,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  children: [
                    AssessmentCheckboxTile(
                      label: AssessmentStrings.supplementProtein,
                      isSelected: _selected.contains(SupplementOption.protein),
                      onTap: () => _toggle(SupplementOption.protein),
                    ),
                    AssessmentCheckboxTile(
                      label: AssessmentStrings.supplementCreatine,
                      isSelected: _selected.contains(SupplementOption.creatine),
                      onTap: () => _toggle(SupplementOption.creatine),
                    ),
                    AssessmentCheckboxTile(
                      label: AssessmentStrings.supplementPreWorkout,
                      isSelected:
                          _selected.contains(SupplementOption.preWorkout),
                      onTap: () => _toggle(SupplementOption.preWorkout),
                    ),
                    AssessmentCheckboxTile(
                      label: AssessmentStrings.supplementVitamins,
                      isSelected: _selected.contains(SupplementOption.vitamins),
                      onTap: () => _toggle(SupplementOption.vitamins),
                    ),
                    AssessmentCheckboxTile(
                      label: AssessmentStrings.supplementOmega3,
                      isSelected: _selected.contains(SupplementOption.omega3),
                      onTap: () => _toggle(SupplementOption.omega3),
                    ),
                    AssessmentCheckboxTile(
                      label: AssessmentStrings.supplementOther,
                      isSelected: _selected.contains(SupplementOption.other),
                      onTap: () => _toggle(SupplementOption.other),
                    ),
                  ],
                ),
              ),
              AssessmentSkipLink(onTap: () => navigateToAppShell(context)),
              const SizedBox(height: 16),
              PrimaryButton(
                onPressed: () => navigateToAppShell(context),
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
