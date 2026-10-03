import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/profile/constants/profile_strings.dart';
import 'package:ai_forma/features/profile/controllers/bug_report_controller.dart';
import 'package:ai_forma/features/profile/repositories/bug_report_repository.dart';
import 'package:ai_forma/features/profile/view/widgets/bug_report_screenshot_picker.dart';
import 'package:ai_forma/features/profile/view/widgets/profile_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportBugView extends StatelessWidget {
  const ReportBugView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<BugReportController>()
        ? Get.find<BugReportController>()
        : Get.put(
            BugReportController(
              repository: Get.isRegistered<BugReportRepository>()
                  ? Get.find<BugReportRepository>()
                  : BugReportRepository(
                      Get.isRegistered<DioClient>()
                          ? Get.find<DioClient>()
                          : DioClient(),
                    ),
            ),
          );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          ProfileStrings.reportBugTitle,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: const [SizedBox(width: 48)],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        ProfileStrings.reportBugSubtitle,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ProfileTextFormField(
                        label: ProfileStrings.describeIssueLabel,
                        controller: controller.issueController,
                        hintText: ProfileStrings.describeIssueHint,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 20),
                      ProfileTextFormField(
                        label: ProfileStrings.activityLabel,
                        controller: controller.activityController,
                        hintText: ProfileStrings.activityHint,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        ProfileStrings.attachScreenshotLabel,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Attachment card / Preview
                      Obx(() {
                        final selectedImage = controller.selectedImage.value;
                        return BugReportScreenshotPicker(
                          selectedImage: selectedImage,
                          onPickImage: controller.pickImage,
                          onRemoveImage: controller.removeImage,
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Obx(() {
                final isSubmitting = controller.isSubmitting.value;
                return PrimaryButton(
                  onPressed: isSubmitting ? () {} : controller.submitReport,
                  label: isSubmitting
                      ? ProfileStrings.sendingReportButton
                      : ProfileStrings.sendReportButton,
                );
              }),
              const SizedBox(height: 16),
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    ProfileStrings.thankYouFeedback,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
