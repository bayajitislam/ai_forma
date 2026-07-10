import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/check_in/constants/check_in_strings.dart';
import 'package:ai_forma/features/check_in/view/pages/analysing_view.dart';
import 'package:ai_forma/features/check_in/view/widgets/check_in_header.dart';
import 'package:ai_forma/features/check_in/view/widgets/check_in_widgets.dart';

class BodyMeasurementsView extends StatelessWidget {
  const BodyMeasurementsView({super.key});

  void _goNext(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const AnalysingView()),
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
              const CheckInHeader(),
              const SizedBox(height: 24),
              const Text(
                CheckInStrings.measurementsTitle,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 12),
              const Text(
                CheckInStrings.measurementsSubtitle,
                style: AppTextStyles.authBody,
              ),
              const SizedBox(height: 20),
              MeasurementRow(
                label: CheckInStrings.waist,
                initialValue: 81.4,
                onChanged: (_) {},
              ),
              const SizedBox(height: 12),
              MeasurementRow(
                label: CheckInStrings.chest,
                initialValue: 93.5,
                onChanged: (_) {},
              ),
              const SizedBox(height: 12),
              MeasurementRow(
                label: CheckInStrings.arms,
                initialValue: 21.3,
                onChanged: (_) {},
              ),
              const SizedBox(height: 12),
              MeasurementRow(
                label: CheckInStrings.hips,
                initialValue: 29.5,
                onChanged: (_) {},
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _goNext(context),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(46),
                        side: const BorderSide(color: AppColors.brandTeal),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        CheckInStrings.skip,
                        style: AppTextStyles.primaryButton.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: PrimaryButton(
                      onPressed: () => _goNext(context),
                      label: CheckInStrings.next,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
