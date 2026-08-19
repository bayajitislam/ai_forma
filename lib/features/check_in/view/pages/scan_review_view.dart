import 'dart:io';

import 'package:ai_forma/core/common/app_loader.dart';
import 'package:ai_forma/features/check_in/controllers/check_in_controller.dart';
import 'package:ai_forma/features/check_in/models/scan_validation_model.dart';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_secondary_button.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/check_in/constants/check_in_strings.dart';
import 'package:ai_forma/features/check_in/view/pages/camera_capture_view.dart';
import 'package:ai_forma/features/check_in/view/pages/check_in_weight_view.dart';
import 'package:ai_forma/features/check_in/view/widgets/check_in_header.dart';
import 'package:ai_forma/features/check_in/view/widgets/check_in_widgets.dart';
import 'package:get/get.dart';

import 'package:ai_forma/features/check_in/view/pages/analysing_view.dart';

class ScanReviewView extends StatefulWidget {
  const ScanReviewView({super.key});

  @override
  State<ScanReviewView> createState() => _ScanReviewViewState();
}

class _ScanReviewViewState extends State<ScanReviewView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<CheckInController>()) {
        final controller = Get.find<CheckInController>();
        if (controller.frontImage.value != null &&
            controller.sideImage.value != null &&
            controller.backImage.value != null &&
            controller.validationResult.value == null &&
            !controller.isValidating.value) {
          controller.validateImages();
        }
      }
    });
  }

  void _onLooksGood(CheckInController controller) {
    if (controller.validationResult.value?.allValid == true) {
      Get.off(() => const AnalysingView());
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<CheckInController>()
        ? Get.find<CheckInController>()
        : null;

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CheckInHeader(),
              const SizedBox(height: 24),
              Obx(() {
                final isValidating = controller?.isValidating.value ?? false;
                final result = controller?.validationResult.value;

                String title = 'Review Your Scan';
                String subtitle = CheckInStrings.scanReadySubtitle;

                if (isValidating) {
                  title = 'Checking Photo Quality...';
                  subtitle = 'Please wait while AI verifies your scan images.';
                } else if (result != null) {
                  if (result.allValid) {
                    title = CheckInStrings.scanReadyTitle;
                    subtitle = 'All photos validated successfully! Tap Looks Good to proceed.';
                  } else {
                    title = 'Scan Quality Issues';
                    subtitle = 'Some photos failed quality checks. Please retake.';
                  }
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.authSectionTitle,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: AppTextStyles.authBody,
                    ),
                  ],
                );
              }),
              const SizedBox(height: 20),

              if (controller != null)
                Expanded(
                  child: Obx(() {
                    final isValidating = controller.isValidating.value;
                    final result = controller.validationResult.value;
                    final errorMessage = controller.errorMessage.value;

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildReviewTile(
                            label: CheckInStrings.angleFront,
                            angle: ScanAngle.front,
                            file: controller.frontImage.value,
                            checkDetail: result?.frontCheck,
                            isValidating: isValidating,
                            controller: controller,
                          ),
                          _buildReviewTile(
                            label: CheckInStrings.angleSide,
                            angle: ScanAngle.side,
                            file: controller.sideImage.value,
                            checkDetail: result?.sideCheck,
                            isValidating: isValidating,
                            controller: controller,
                          ),
                          _buildReviewTile(
                            label: CheckInStrings.angleBack,
                            angle: ScanAngle.back,
                            file: controller.backImage.value,
                            checkDetail: result?.backCheck,
                            isValidating: isValidating,
                            controller: controller,
                          ),
                          const SizedBox(height: 12),

                          // Global Status/Error Banners
                          if (isValidating)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.cardBorder),
                              ),
                              child: const Row(
                                children: [
                                  AppLoader(
                                    color: AppColors.brandTeal,
                                    size: 18,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Validating scan images with AI...',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else if (result != null)
                            if (result.allValid)
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.brandTeal.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.brandTeal),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.check_circle,
                                        color: AppColors.brandTeal, size: 20),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'All photos validated successfully!',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.brandTeal,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5)),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.error_outline,
                                        color: Colors.redAccent, size: 20),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Validation failed. Please retake failed photos.',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                          if (errorMessage.isNotEmpty && result == null && !isValidating)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                errorMessage,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.red.shade400,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                )
              else
                const Expanded(
                  child: Column(
                    children: [
                      ScanReviewTile(
                        label: CheckInStrings.angleFront,
                        imagePath: '',
                      ),
                      SizedBox(height: 12),
                      ScanReviewTile(
                        label: CheckInStrings.angleSide,
                        imagePath: '',
                      ),
                      SizedBox(height: 12),
                      ScanReviewTile(
                        label: CheckInStrings.angleBack,
                        imagePath: '',
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),
              if (controller != null)
                Obx(() {
                  final isValidating = controller.isValidating.value;
                  final allValid = controller.validationResult.value?.allValid ?? false;

                  final bool canProceed = !isValidating && allValid;

                  return PrimaryButton(
                    isLoading: false,
                    onPressed: canProceed ? () => _onLooksGood(controller) : null,
                    label: CheckInStrings.looksGood,
                  );
                })
              else
                PrimaryButton(
                  onPressed: () => Get.to(() => const CheckInWeightView()),
                  label: CheckInStrings.looksGood,
                ),
              const SizedBox(height: 12),
              AppSecondaryButton(
                onPressed: () {
                  if (controller != null) {
                    controller.clearFailedImages();

                    ScanAngle startAngle = ScanAngle.front;
                    if (controller.frontImage.value == null) {
                      startAngle = ScanAngle.front;
                    } else if (controller.sideImage.value == null) {
                      startAngle = ScanAngle.side;
                    } else if (controller.backImage.value == null) {
                      startAngle = ScanAngle.back;
                    } else {
                      controller.resetScan();
                      startAngle = ScanAngle.front;
                    }

                    Get.off(() => CameraCaptureView(angle: startAngle));
                  }
                },
                label: CheckInStrings.retakePhotos,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewTile({
    required String label,
    required ScanAngle angle,
    required File? file,
    required ViewCheckDetail? checkDetail,
    required bool isValidating,
    required CheckInController controller,
  }) {
    final bool hasResult = checkDetail != null && !isValidating;
    final bool isValid = hasResult && checkDetail.isValid;
    final bool hasError = hasResult && !checkDetail.isValid;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasError ? Colors.redAccent.withValues(alpha: 0.5) : AppColors.cardBorder,
          width: hasError ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: file != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(file, fit: BoxFit.contain),
                      )
                    : const Icon(Icons.image, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (isValidating)
                      const Text(
                        'Checking image quality...',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              if (isValidating)
                const AppLoader(
                  color: AppColors.brandTeal,
                  size: 20,
                )
              else if (isValid)
                const Icon(Icons.check_circle_rounded, color: AppColors.brandTeal, size: 24)
              else if (hasError)
                const Icon(Icons.cancel_rounded, color: Colors.redAccent, size: 24)
              else
                const Icon(Icons.check_circle_outline, color: AppColors.textSecondary, size: 24),
            ],
          ),
          // if (hasError) ...[
          //   const SizedBox(height: 8),
          //   Container(
          //     width: double.infinity,
          //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          //     decoration: BoxDecoration(
          //       color: Colors.red.withValues(alpha: 0.1),
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //     child: Row(
          //       children: [
          //         const Icon(Icons.info_outline, size: 14, color: Colors.redAccent),
          //         const SizedBox(width: 6),
          //         Expanded(
          //           child: Text(
          //             checkDetail.displayReason,
          //             style: const TextStyle(
          //               fontSize: 12,
          //               color: Colors.redAccent,
          //               fontWeight: FontWeight.w500,
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ],
        ],
      ),
    );
  }
}
