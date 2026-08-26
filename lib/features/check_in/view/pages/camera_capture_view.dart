import 'dart:io';

import 'package:ai_forma/core/common/app_loader.dart';
import 'package:ai_forma/features/check_in/controllers/check_in_controller.dart';
import 'package:ai_forma/features/check_in/repositories/check_in_repository.dart';
import 'package:ai_forma/features/check_in/view/pages/scan_review_view.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/features/check_in/constants/check_in_strings.dart';
import 'package:ai_forma/features/check_in/view/widgets/camera_guide_frame.dart';
import 'package:get/get.dart';

enum ScanAngle { front, side, back }

class CameraCaptureView extends StatefulWidget {
  const CameraCaptureView({super.key, this.angle = ScanAngle.front});

  final ScanAngle angle;

  @override
  State<CameraCaptureView> createState() => _CameraCaptureViewState();
}

class _CameraCaptureViewState extends State<CameraCaptureView>
    with SingleTickerProviderStateMixin {
  late ScanAngle _activeAngle;

  // Captured photo preview file state
  final Rx<File?> _previewFile = Rx<File?>(null);

  late final AnimationController _galleryAnimController;
  late final Animation<Offset> _gallerySlideAnim;
  late final Animation<double> _galleryFadeAnim;

  String get _title => switch (_activeAngle) {
    ScanAngle.front => CheckInStrings.angleFront,
    ScanAngle.side => CheckInStrings.angleSide,
    ScanAngle.back => CheckInStrings.angleBack,
  };

  String get _instruction => switch (_activeAngle) {
    ScanAngle.front => CheckInStrings.frontInstruction,
    ScanAngle.side => CheckInStrings.sideInstruction,
    ScanAngle.back => CheckInStrings.backInstruction,
  };

  ScanAngle? get _nextAngle {
    if (!Get.isRegistered<CheckInController>()) return null;
    final controller = Get.find<CheckInController>();
    final res = controller.validationResult.value;

    bool needsCapture(ScanAngle angle) {
      switch (angle) {
        case ScanAngle.front:
          if (controller.frontImage.value == null) return true;
          if (res != null && res.frontCheck?.isValid == false) return true;
          return false;
        case ScanAngle.side:
          if (controller.sideImage.value == null) return true;
          if (res != null && res.sideCheck?.isValid == false) return true;
          return false;
        case ScanAngle.back:
          if (controller.backImage.value == null) return true;
          if (res != null && res.backCheck?.isValid == false) return true;
          return false;
      }
    }

    if (_activeAngle == ScanAngle.front) {
      if (needsCapture(ScanAngle.side)) return ScanAngle.side;
      if (needsCapture(ScanAngle.back)) return ScanAngle.back;
    } else if (_activeAngle == ScanAngle.side) {
      if (needsCapture(ScanAngle.back)) return ScanAngle.back;
      if (needsCapture(ScanAngle.front)) return ScanAngle.front;
    } else if (_activeAngle == ScanAngle.back) {
      if (needsCapture(ScanAngle.front)) return ScanAngle.front;
      if (needsCapture(ScanAngle.side)) return ScanAngle.side;
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    _activeAngle = widget.angle;
    _previewFile.value = null;

    _galleryAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _gallerySlideAnim =
        Tween<Offset>(begin: const Offset(-0.8, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _galleryAnimController,
            curve: Curves.easeOutCubic,
          ),
        );

    _galleryFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _galleryAnimController, curve: Curves.easeIn),
    );

    _galleryAnimController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<CheckInController>()) {
        final c = Get.find<CheckInController>();
        c.currentAngle.value = _title;
        c.initCamera();
      }
    });
  }

  @override
  void dispose() {
    _galleryAnimController.dispose();
    if (Get.isRegistered<CheckInController>()) {
      final c = Get.find<CheckInController>();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        c.disposeCamera();
      });
    }
    super.dispose();
  }

  /// Shutter tapped -> Snap photo and show inline preview on same screen
  Future<void> _onTakeSnap(CheckInController controller) async {
    controller.currentAngle.value = _title;
    final photo = await controller.capturePhoto();
    if (photo != null) {
      _previewFile.value = photo;
      if (_activeAngle == ScanAngle.front) controller.frontImage.value = photo;
      if (_activeAngle == ScanAngle.side) controller.sideImage.value = photo;
      if (_activeAngle == ScanAngle.back) controller.backImage.value = photo;
    }
  }

  /// User taps Retake -> Discard inline preview & resume live camera
  void _onRetakePhoto(CheckInController controller) {
    _previewFile.value = null;
    if (_activeAngle == ScanAngle.front) controller.frontImage.value = null;
    if (_activeAngle == ScanAngle.side) controller.sideImage.value = null;
    if (_activeAngle == ScanAngle.back) controller.backImage.value = null;
    _galleryAnimController.forward(from: 0);
  }

  /// User accepts photo -> Proceed to next pose or Review screen INSTANTLY without page destruction or camera dispose!
  void _onAcceptPhoto() {
    final next = _nextAngle;
    if (next != null) {
      setState(() {
        _activeAngle = next;
        _previewFile.value = null;
      });
      if (Get.isRegistered<CheckInController>()) {
        final c = Get.find<CheckInController>();
        c.currentAngle.value = _title;
      }
      _galleryAnimController.forward(from: 0);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const ScanReviewView()),
      );
    }
  }

  /// Pick photo from gallery for dev/testing
  Future<void> _onPickFromGallery(CheckInController controller) async {
    controller.currentAngle.value = _title;
    final photo = await controller.pickFromGallery();
    if (photo != null) {
      _previewFile.value = photo;
      if (_activeAngle == ScanAngle.front) controller.frontImage.value = photo;
      if (_activeAngle == ScanAngle.side) controller.sideImage.value = photo;
      if (_activeAngle == ScanAngle.back) controller.backImage.value = photo;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<CheckInController>()
        ? Get.find<CheckInController>()
        : Get.put(CheckInController(repository: CheckInRepository(Get.find())));

    return Scaffold(
      backgroundColor: AppColors.cameraBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      final c = Get.isRegistered<CheckInController>()
                          ? Get.find<CheckInController>()
                          : null;
                      if (c != null &&
                          (c.frontImage.value != null ||
                              c.sideImage.value != null ||
                              c.backImage.value != null)) {
                        Get.off(() => const ScanReviewView());
                      } else {
                        Get.back();
                      }
                    },
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
                  // Top Right Tips Icon (ⓘ)
                  IconButton(
                    onPressed: () => controller.showPhotoTips(context),
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
            const SizedBox(height: 12),

            // Viewfinder: Shows Live Camera OR Captured Image Preview
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    alignment: Alignment.center,
                    fit: StackFit.expand,
                    children: [
                      Obx(() {
                        final preview = _previewFile.value;

                        // 1. If photo was captured or picked -> Display Full Captured Photo Preview
                        if (preview != null) {
                          return Center(
                            child: Image.file(preview, fit: BoxFit.contain),
                          );
                        }

                        // 2. Otherwise -> Display Live Camera Stream Preview
                        if (!controller.isCameraInitialized.value ||
                            controller.cameraController == null) {
                          return const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppLoader(color: Colors.white),
                                SizedBox(height: 12),
                                Text(
                                  "Starting camera...",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            return ClipRect(
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: SizedBox(
                                  width: constraints.maxWidth,
                                  height:
                                      constraints.maxWidth *
                                      controller
                                          .cameraController!
                                          .value
                                          .aspectRatio,
                                  child: CameraPreview(
                                    controller.cameraController!,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }),

                      // Viewfinder overlay frame (only in live camera mode)
                      Obx(() {
                        if (_previewFile.value != null) {
                          return const SizedBox.shrink();
                        }
                        return const IgnorePointer(
                          child: CameraViewfinderOverlay(),
                        );
                      }),

                      // Animated Floating Gallery Button (Bottom-Left overlay on camera view)
                      Obx(() {
                        if (_previewFile.value != null) {
                          return const SizedBox.shrink();
                        }

                        return Positioned(
                          left: 14,
                          bottom: 14,
                          child: SlideTransition(
                            position: _gallerySlideAnim,
                            child: FadeTransition(
                              opacity: _galleryFadeAnim,
                              child: GestureDetector(
                                onTap: () => _onPickFromGallery(controller),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.35,
                                      ),
                                      width: 1.2,
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.photo_library_rounded,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Gallery',
                                        style: TextStyle(
                                          fontFamily: AppFonts.family,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Bottom Control Bar (Differs between Live Capture mode & Preview Confirm mode)
            Obx(() {
              final isPreviewMode = _previewFile.value != null;

              if (isPreviewMode) {
                // Inline Preview Mode -> Retake or Accept Buttons
                return Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.cardBorder),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () => _onRetakePhoto(controller),
                          icon: const AppIcon(
                            icon: AppIcons.refresh,
                            size: 20,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Retake',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brandTeal,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: _onAcceptPhoto,
                          icon: const Icon(
                            Icons.check_rounded,
                            size: 22,
                            color: AppColors.onPrimary,
                          ),
                          label: const Text(
                            'Use Photo',
                            style: TextStyle(
                              color: AppColors.onPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Live Capture Mode -> Switch, Shutter & Guide Buttons
              return Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CameraActionButton(
                      icon: AppIcons.refresh,
                      label: 'Switch',
                      onTap: () => controller.toggleCamera(),
                    ),
                    Obx(
                      () => CameraShutterButton(
                        onTap: controller.isCapturing.value
                            ? null
                            : () => _onTakeSnap(controller),
                      ),
                    ),
                    CameraActionButton(
                      icon: AppIcons.info,
                      label: CheckInStrings.guide,
                      onTap: () => controller.showPoseGuide(context),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
