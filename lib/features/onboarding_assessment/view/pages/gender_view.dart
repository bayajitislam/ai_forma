import 'dart:io';

import 'package:ai_forma/core/common/app_loader.dart';
import 'package:ai_forma/features/onboarding_assessment/controllers/assessment_controller.dart';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/onboarding_assessment/constants/assessment_strings.dart';
import 'package:ai_forma/features/onboarding_assessment/view/pages/age_view.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/assessment_flow_header.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/assessment_option_card.dart';
import 'package:get/get.dart';

class GenderView extends StatefulWidget {
  const GenderView({super.key});

  @override
  State<GenderView> createState() => _GenderViewState();
}

class _GenderViewState extends State<GenderView> {
  String _selectedGenderValue = 'female';

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<AssessmentController>()) {
      Get.find<AssessmentController>().setAnswer('gender', 'female');
    }
  }

  void _onGenderSelected(String value) {
    setState(() {
      _selectedGenderValue = value;
    });
    if (Get.isRegistered<AssessmentController>()) {
      Get.find<AssessmentController>().setAnswer('gender', value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<AssessmentController>()
        ? Get.find<AssessmentController>()
        : null;

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: controller == null
              ? _buildContent(null)
              : Obx(() {
                  if (controller.isLoadingSchema.value) {
                    return _buildSchemaLoadingView();
                  }
                  return _buildContent(controller);
                }),
        ),
      ),
    );
  }

  /// Shown while GET /api/onboarding/schema/ is loading
  Widget _buildSchemaLoadingView() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppLoader(color: AppColors.brandTeal),
            const SizedBox(height: 20),
            const Text(
              "We are getting everything ready for you...",
              style: AppTextStyles.authSectionTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "Loading your body intelligence assessment profile...",
              style: AppTextStyles.authBody,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(AssessmentController? controller) {
    // Dynamic step data from API schema
    final genderStep = controller?.getStep('gender');
    final title = genderStep?.title ?? AssessmentStrings.genderTitle;
    final subtitle = genderStep?.subtitle ?? AssessmentStrings.genderSubtitle;

    // Dynamic options from API schema (e.g. Male/Female)
    final options = genderStep?.options ?? [];
    final option1Label = options.isNotEmpty ? options[0].label : AssessmentStrings.genderMale;
    final option1Value = options.isNotEmpty ? options[0].value : 'male';

    final option2Label = options.length > 1 ? options[1].label : AssessmentStrings.genderFemale;
    final option2Value = options.length > 1 ? options[1].value : 'female';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const AssessmentFlowHeader(currentStep: 1),
        const SizedBox(height: 32),
        Text(
          title,
          style: AppTextStyles.authSectionTitle,
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          style: AppTextStyles.authBody,
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: AssessmentOptionCard(
                icon: AppIcons.user,
                label: option1Label,
                isSelected: _selectedGenderValue == option1Value,
                onTap: () => _onGenderSelected(option1Value),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AssessmentOptionCard(
                icon: AppIcons.user,
                label: option2Label,
                isSelected: _selectedGenderValue == option2Value,
                onTap: () => _onGenderSelected(option2Value),
              ),
            ),
          ],
        ),
        const Spacer(),
        PrimaryButton(
          onPressed: () {
            if (controller != null) {
              controller.nextStep();
            }
            Get.to(() => const AgeView());
          },
          label: AppStrings.nextButton,
        ),
        Platform.isAndroid
            ? const SizedBox(height: 26)
            : const SizedBox.shrink(),
      ],
    );
  }
}
