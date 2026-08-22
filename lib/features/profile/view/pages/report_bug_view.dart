import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/profile/repositories/bug_report_repository.dart';

class ReportBugView extends StatefulWidget {
  const ReportBugView({super.key});

  @override
  State<ReportBugView> createState() => _ReportBugViewState();
}

class _ReportBugViewState extends State<ReportBugView> {
  final TextEditingController _issueController = TextEditingController();
  final TextEditingController _activityController = TextEditingController();

  File? _selectedImage;
  bool _isSubmitting = false;

  late final BugReportRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = BugReportRepository(
      Get.isRegistered<DioClient>() ? Get.find<DioClient>() : DioClient(),
    );
  }

  @override
  void dispose() {
    _issueController.dispose();
    _activityController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not select image. Please try again.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  Future<void> _submitReport() async {
    final titleText = _issueController.text.trim();
    final activityText = _activityController.text.trim();

    if (titleText.isEmpty) {
      Get.snackbar(
        'Required',
        'Please describe the issue before submitting.',
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white,
      );
      return;
    }

    final fullDescription = activityText.isNotEmpty
        ? '$titleText\n\nActivity Details: $activityText'
        : titleText;

    setState(() {
      _isSubmitting = true;
    });

    final result = await _repository.submitBugReport(
      title: titleText,
      description: fullDescription,
      imagePath: _selectedImage?.path,
    );

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    result.fold(
      (failure) {
        Get.snackbar(
          'Error',
          failure.message,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      },
      (successData) {
        Get.snackbar(
          'Success',
          'Bug report submitted successfully! Thank you.',
          backgroundColor: AppColors.brandTeal,
          colorText: Colors.white,
        );
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Report a Bug',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: const [
          SizedBox(width: 48),
        ],
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
                        'Found something that isn\'t working? Let us know and we\'ll investigate it as quickly as possible.',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildFormField(
                        label: 'Describe the issue',
                        controller: _issueController,
                        hintText: 'Briefly explain what happened.',
                        maxLines: 4,
                      ),
                      const SizedBox(height: 20),
                      _buildFormField(
                        label: 'What were you doing when it happened?',
                        controller: _activityController,
                        hintText: 'Uploading my weekly body scan.',
                        maxLines: 3,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Attach a Screenshot',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Attachment card / Preview
                      if (_selectedImage != null)
                        Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 160,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(_selectedImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: _removeImage,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: double.infinity,
                            height: 96,
                            decoration: BoxDecoration(
                              color: AppColors.insightConsistencyIncompleteBg
                                  .withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.cardBorder.withValues(alpha: 0.5),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.attachment,
                                  color: AppColors.textSecondary,
                                  size: 22,
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Choose Image',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                onPressed: _isSubmitting ? () {} : _submitReport,
                label: _isSubmitting ? 'SENDING...' : 'SEND REPORT',
              ),
              const SizedBox(height: 16),
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Thanks for helping us improve AiFORMA. Every report helps us build a better experience for everyone.',
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

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required int maxLines,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            contentPadding: const EdgeInsets.all(16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.cardBorder.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.brandTeal,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
