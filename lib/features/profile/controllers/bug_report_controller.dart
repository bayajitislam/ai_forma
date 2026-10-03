import 'dart:io';

import 'package:ai_forma/core/widgets/app_snackbar.dart';
import 'package:ai_forma/features/profile/constants/profile_strings.dart';
import 'package:ai_forma/features/profile/repositories/bug_report_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class BugReportController extends GetxController {
  final BugReportRepository repository;
  BugReportController({required this.repository});

  final TextEditingController issueController = TextEditingController();
  final TextEditingController activityController = TextEditingController();

  final Rxn<File> selectedImage = Rxn<File>();
  final RxBool isSubmitting = false.obs;

  @override
  void onClose() {
    issueController.dispose();
    activityController.dispose();
    super.onClose();
  }

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
      }
    } catch (_) {
      AppSnackbar.showError(
        'Could not select image. Please try again.',
        title: ProfileStrings.error,
      );
    }
  }

  void removeImage() {
    selectedImage.value = null;
  }

  Future<void> submitReport() async {
    final titleText = issueController.text.trim();
    final activityText = activityController.text.trim();

    if (titleText.isEmpty) {
      AppSnackbar.showWarning(
        'Please describe the issue before submitting.',
        title: ProfileStrings.required,
      );
      return;
    }

    final fullDescription = activityText.isNotEmpty
        ? '$titleText\n\nActivity Details: $activityText'
        : titleText;

    isSubmitting.value = true;

    final result = await repository.submitBugReport(
      title: titleText,
      description: fullDescription,
      imagePath: selectedImage.value?.path,
    );

    isSubmitting.value = false;

    result.fold(
      (failure) {
        AppSnackbar.showError(
          failure.message,
          title: ProfileStrings.error,
        );
      },
      (successData) {
        AppSnackbar.showSuccess(
          'Bug report submitted successfully! Thank you.',
          title: ProfileStrings.success,
        );
        Get.back();
      },
    );
  }
}
