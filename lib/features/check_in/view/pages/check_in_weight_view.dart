import 'package:ai_forma/features/check_in/view/pages/analysing_view.dart';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/assessment/constants/assessment_strings.dart';
import 'package:ai_forma/features/assessment/view/widgets/assessment_unit_toggle.dart';
import 'package:ai_forma/features/assessment/view/widgets/measurement_wheel_picker.dart';
import 'package:ai_forma/features/check_in/constants/check_in_strings.dart';
import 'package:ai_forma/features/check_in/view/widgets/check_in_header.dart';

class CheckInWeightView extends StatefulWidget {
  const CheckInWeightView({super.key});

  @override
  State<CheckInWeightView> createState() => _CheckInWeightViewState();
}

class _CheckInWeightViewState extends State<CheckInWeightView> {
  int _unitIndex = 0;
  int _weightKg = AssessmentStrings.defaultWeightKg;
  int _weightLb = AssessmentStrings.defaultWeightLb;

  bool get _isKg => _unitIndex == 0;

  void _onUnitChanged(int index) {
    if (index == _unitIndex) return;
    setState(() {
      if (index == 0) {
        _weightKg = _lbToKg(_weightLb);
      } else {
        _weightLb = _kgToLb(_weightKg);
      }
      _unitIndex = index;
    });
  }

  int _kgToLb(int kg) => (kg * 2.20462).round().clamp(
    AssessmentStrings.minWeightLb,
    AssessmentStrings.maxWeightLb,
  );

  int _lbToKg(int lb) => (lb / 2.20462).round().clamp(
    AssessmentStrings.minWeightKg,
    AssessmentStrings.maxWeightKg,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CheckInHeader(),
              const SizedBox(height: 24),
              const Text(
                CheckInStrings.weightTitle,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 12),
              const Text(
                CheckInStrings.weightSubtitle,
                style: AppTextStyles.authBody,
              ),
              const SizedBox(height: 24),
              AssessmentUnitToggle(
                options: const [
                  AssessmentStrings.weightUnitKg,
                  AssessmentStrings.weightUnitLb,
                ],
                selectedIndex: _unitIndex,
                onChanged: _onUnitChanged,
              ),
              const Spacer(),
              Center(
                child: _isKg
                    ? MeasurementWheelPicker(
                        key: const ValueKey('checkin-weight-kg'),
                        minValue: AssessmentStrings.minWeightKg,
                        maxValue: AssessmentStrings.maxWeightKg,
                        initialValue: _weightKg,
                        unit: 'kg',
                        onChanged: (v) => _weightKg = v,
                      )
                    : MeasurementWheelPicker(
                        key: const ValueKey('checkin-weight-lb'),
                        minValue: AssessmentStrings.minWeightLb,
                        maxValue: AssessmentStrings.maxWeightLb,
                        initialValue: _weightLb,
                        unit: 'lb',
                        onChanged: (v) => _weightLb = v,
                      ),
              ),
              const Spacer(),
              PrimaryButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const AnalysingView(),
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
