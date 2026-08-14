import 'dart:io';

import 'package:ai_forma/features/onboarding_assessment/controllers/assessment_controller.dart';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/onboarding_assessment/constants/assessment_strings.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/assessment_checkbox_tile.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/assessment_flow_header.dart';
import 'package:get/get.dart';

enum SupplementOption { protein, creatine, preWorkout, fatBurner, vitamins, omega3, other }

class SupplementsView extends StatefulWidget {
  const SupplementsView({super.key});

  @override
  State<SupplementsView> createState() => _SupplementsViewState();
}

class _SupplementsViewState extends State<SupplementsView> {
  final Set<SupplementOption> _selected = {SupplementOption.protein, SupplementOption.creatine};

  @override
  void initState() {
    super.initState();
    _saveToController();
  }

  void _saveToController() {
    if (Get.isRegistered<AssessmentController>()) {
      final List<String> list = [];
      for (final option in _selected) {
        switch (option) {
          case SupplementOption.protein:
            list.add('protein_powder');
            break;
          case SupplementOption.creatine:
            list.add('creatine');
            break;
          case SupplementOption.preWorkout:
            list.add('pre_workout');
            break;
          case SupplementOption.fatBurner:
            list.add('fat_burner');
            break;
          case SupplementOption.vitamins:
            list.add('vitamins_minerals');
            break;
          case SupplementOption.omega3:
            list.add('omega_3');
            break;
          case SupplementOption.other:
            list.add('other');
            break;
        }
      }
      Get.find<AssessmentController>().setAnswer('supplements', list);
    }
  }

  void _toggle(SupplementOption option) {
    setState(() {
      if (_selected.contains(option)) {
        _selected.remove(option);
      } else {
        _selected.add(option);
      }
    });
    _saveToController();
  }

  Future<void> _onSubmit() async {
    _saveToController();
    if (Get.isRegistered<AssessmentController>()) {
      await Get.find<AssessmentController>().submitOnboarding();
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
                      isSelected: _selected.contains(
                        SupplementOption.preWorkout,
                      ),
                      onTap: () => _toggle(SupplementOption.preWorkout),
                    ),
                    AssessmentCheckboxTile(
                      label: AssessmentStrings.supplementFatBurner,
                      isSelected: _selected.contains(
                        SupplementOption.fatBurner,
                      ),
                      onTap: () => _toggle(SupplementOption.fatBurner),
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
              Obx(() {
                final isSubmitting = Get.isRegistered<AssessmentController>()
                    ? Get.find<AssessmentController>().isSubmitting.value
                    : false;
                return PrimaryButton(
                  isLoading: isSubmitting,
                  onPressed: isSubmitting ? null : _onSubmit,
                  label: AppStrings.nextButton,
                );
              }),
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
