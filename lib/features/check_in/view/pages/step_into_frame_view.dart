import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_images.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/check_in/constants/check_in_strings.dart';
import 'package:ai_forma/features/check_in/view/pages/camera_capture_view.dart';
import 'package:ai_forma/features/check_in/view/widgets/camera_guide_frame.dart';
import 'package:ai_forma/features/check_in/view/widgets/check_in_header.dart';

class StepIntoFrameView extends StatelessWidget {
  const StepIntoFrameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CheckInHeader(title: CheckInStrings.stepIntoFrame,),
              const SizedBox(height: 24),
              const Text(
                CheckInStrings.stepIntoFrameTitle,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 12),
              const Text(
                CheckInStrings.stepIntoFrameBody,
                style: AppTextStyles.authBody,
              ),
              const Spacer(),
              const CameraGuideFrame(imagePath: AppImages.sideView),
              const Spacer(),
              PrimaryButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const CameraCaptureView(
                        angle: ScanAngle.front,
                      ),
                    ),
                  );
                },
                label: CheckInStrings.continueButton,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
