import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_images.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_secondary_button.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/check_in/constants/check_in_strings.dart';
import 'package:ai_forma/features/check_in/view/pages/check_in_weight_view.dart';
import 'package:ai_forma/features/check_in/view/widgets/check_in_header.dart';
import 'package:ai_forma/features/check_in/view/widgets/check_in_widgets.dart';

class ScanReviewView extends StatelessWidget {
  const ScanReviewView({super.key});

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
                CheckInStrings.scanReadyTitle,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 12),
              const Text(
                CheckInStrings.scanReadySubtitle,
                style: AppTextStyles.authBody,
              ),
              const SizedBox(height: 24),
              const ScanReviewTile(
                label: CheckInStrings.angleFront,
                imagePath: AppImages.frontView,
              ),
              const SizedBox(height: 12),
              const ScanReviewTile(
                label: CheckInStrings.angleSide,
                imagePath: AppImages.sideView,
              ),
              const SizedBox(height: 12),
              const ScanReviewTile(
                label: CheckInStrings.angleBack,
                imagePath: AppImages.backView,
              ),
              const Spacer(),
              PrimaryButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const CheckInWeightView(),
                    ),
                  );
                },
                label: CheckInStrings.looksGood,
              ),
              const SizedBox(height: 12),
              AppSecondaryButton(
                onPressed: () => Navigator.maybePop(context),
                label: CheckInStrings.retakePhotos,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
