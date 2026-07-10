import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/features/check_in/constants/check_in_strings.dart';
import 'package:ai_forma/features/check_in/view/pages/scan_review_view.dart';
import 'package:ai_forma/features/check_in/view/widgets/camera_guide_frame.dart';

enum ScanAngle { front, side, back }

class CameraCaptureView extends StatelessWidget {
  const CameraCaptureView({
    super.key,
    required this.angle,
  });

  final ScanAngle angle;

  String get _title => switch (angle) {
        ScanAngle.front => CheckInStrings.angleFront,
        ScanAngle.side => CheckInStrings.angleSide,
        ScanAngle.back => CheckInStrings.angleBack,
      };

  String get _instruction => switch (angle) {
        ScanAngle.front => CheckInStrings.frontInstruction,
        ScanAngle.side => CheckInStrings.sideInstruction,
        ScanAngle.back => CheckInStrings.backInstruction,
      };

  ScanAngle? get _nextAngle => switch (angle) {
        ScanAngle.front => ScanAngle.side,
        ScanAngle.side => ScanAngle.back,
        ScanAngle.back => null,
      };

  void _onCapture(BuildContext context) {
    final next = _nextAngle;
    if (next != null) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => CameraCaptureView(angle: next),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const ScanReviewView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cameraBackground,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: const AppIcon(
                      icon: AppIcons.back,
                      size: 28,
                      color: AppColors.onPrimary,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const AppIcon(
                      icon: AppIcons.info,
                      size: 22,
                      color: AppColors.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                _instruction,
                textAlign: TextAlign.center,
                style: AppTextStyles.authBody.copyWith(
                  color: AppColors.onPrimary.withValues(alpha: 0.8),
                ),
              ),
            ),
            const Spacer(),
            const CameraViewfinderOverlay(),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CameraActionButton(
                    icon: AppIcons.refresh,
                    label: CheckInStrings.retake,
                  ),
                  CameraShutterButton(onTap: () => _onCapture(context)),
                  CameraActionButton(
                    icon: AppIcons.info,
                    label: angle == ScanAngle.side
                        ? CheckInStrings.tips
                        : CheckInStrings.guide,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
