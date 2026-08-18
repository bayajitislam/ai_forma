import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_images.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/check_in/constants/check_in_strings.dart';
import 'package:ai_forma/features/check_in/view/pages/step_into_frame_view.dart';
import 'package:ai_forma/features/check_in/view/widgets/camera_guide_frame.dart';
import 'package:ai_forma/features/check_in/view/widgets/check_in_header.dart';

class CameraPositionView extends StatelessWidget {
  const CameraPositionView({super.key});

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
              const CheckInHeader(title: CheckInStrings.cameraPosition,),
              const SizedBox(height: 24),
              const Text(
                CheckInStrings.positionCameraTitle,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 12),
              const Text(
                CheckInStrings.positionCameraBody,
                style: AppTextStyles.authBody,
              ),
              const Spacer(),
              const CameraGuideFrame(imagePath: AppImages.frontView),
              const Spacer(),
              PrimaryButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const StepIntoFrameView(),
                    ),
                  );
                },
                label: CheckInStrings.imReady,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
