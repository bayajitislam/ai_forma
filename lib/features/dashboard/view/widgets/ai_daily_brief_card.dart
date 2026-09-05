import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/features/dashboard/controllers/home_controller.dart';
import 'package:ai_forma/features/dashboard/models/home_response_model.dart';
import 'package:ai_forma/features/dashboard/view/widgets/answer_daily_brief_bottom_sheet.dart';
import 'package:ai_forma/features/dashboard/view/widgets/weight_entry_bottom_sheet.dart';

class AIDailyBriefCard extends StatelessWidget {
  const AIDailyBriefCard({
    super.key,
    this.priorityData,
    this.dailyBriefData,
    this.forceScanDay = false,
    this.onScanCompleteTap,
    this.goInsightPage,
  });

  final HomeTodayPriorityModel? priorityData;
  final HomeDailyBriefModel? dailyBriefData;
  final bool forceScanDay;
  final VoidCallback? onScanCompleteTap;
  final VoidCallback? goInsightPage;

  void _handleViewAnalysis() {
    if (goInsightPage != null) {
      goInsightPage!();
    } else if (onScanCompleteTap != null) {
      onScanCompleteTap!();
    }
  }

  void _openWeightBottomSheet(BuildContext context) {
    if (dailyBriefData == null) return;

    final prefill = dailyBriefData?.weightKgPrefill;
    final initialWeight = prefill != null ? double.tryParse(prefill) : null;

    WeightEntryBottomSheet.show(
      context,
      initialWeightKg: initialWeight,
      onWeightSaved: (savedWeight) async {
        if (!Get.isRegistered<HomeController>()) return;
        final controller = Get.find<HomeController>();

        if (dailyBriefData?.step != null) {
          final result = await controller.submitDailyBriefAnswer(
            questionKey: dailyBriefData?.questionKey ?? 'weight',
            selectedOption: dailyBriefData?.selectedOption ?? '',
            weightKg: savedWeight,
            alreadyAnswered: dailyBriefData?.alreadyAnswered ?? false,
          );
          if (result.success) {
            Get.snackbar(
              'Success',
              'Weight recorded successfully',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.brandTeal,
              colorText: Colors.white,
              margin: const EdgeInsets.all(16),
            );
          }
        } else {
          final result = await controller.submitScanDayWeight(
            weightKg: savedWeight,
          );
          if (result.success) {
            Get.snackbar(
              'Success',
              'Weight recorded successfully',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.brandTeal,
              colorText: Colors.white,
              margin: const EdgeInsets.all(16),
            );
          }
        }
      },
    );
  }

  void _openAnswerSheet(BuildContext context) {
    if (dailyBriefData == null) return;

    AnswerDailyBriefBottomSheet.show(
      context,
      dailyBriefData: dailyBriefData,
      onSavedOption: (questionKey, selectedValue) async {
        if (!Get.isRegistered<HomeController>()) return;

        final controller = Get.find<HomeController>();
        final prefill = dailyBriefData?.weightKgPrefill;
        final weight = prefill != null ? double.tryParse(prefill) : null;

        final result = await controller.submitDailyBriefAnswer(
          questionKey: questionKey,
          selectedOption: selectedValue,
          weightKg: weight,
          alreadyAnswered: dailyBriefData?.alreadyAnswered ?? false,
        );

        if (context.mounted) {
          Navigator.of(context).pop();
        }

        if (result.success) {
          Get.snackbar(
            'Success',
            result.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.brandTeal,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
          );
        } else {
          Get.snackbar(
            'Error',
            result.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (dailyBriefData == null || !dailyBriefData!.visible) {
      return const SizedBox.shrink();
    }

    final data = dailyBriefData!;
    if (data.kind == 'transition') {
      return _buildTransitionCard(context, data);
    }

    final homeData = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>().homeData.value
        : null;

    final isAnswered = data.alreadyAnswered;
    final badgeNum = data.badge;

    final aiTitle = data.aiFeedback?.title ?? homeData?.todayAiFeedback?.title;
    final aiDescription = data.aiFeedback?.description ?? homeData?.todayAiFeedback?.description;

    final headingDisplay = data.heading ?? '';

    final cardTitle = isAnswered && aiTitle != null && aiTitle.trim().isNotEmpty
        ? aiTitle
        : (data.title ?? priorityData?.text ?? '');

    final cardSubtitle = isAnswered &&
            aiDescription != null &&
            aiDescription.trim().isNotEmpty
        ? aiDescription
        : (data.subtitle ?? '');

    final ctaButtonLabel = data.ctaLabel ?? priorityData?.ctaLabel ?? '';

    final rawTitle = cardTitle.toLowerCase();
    final rawDataTitle = (data.title ?? '').toLowerCase();
    final rawHeading = headingDisplay.toLowerCase();
    final rawCta = ctaButtonLabel.toLowerCase();
    final rawPriorityKind = (priorityData?.kind ?? '').toLowerCase();

    final bool isWeightCta = rawCta.contains('weight') ||
        rawTitle.contains('update weight') ||
        rawDataTitle.contains('update weight') ||
        data.questionKey == 'weight';

    final bool isAnalysisReady = !isWeightCta &&
        (rawTitle.contains('analysis is ready') ||
            rawTitle.contains('new analysis') ||
            rawTitle.contains('analysis ready') ||
            rawDataTitle.contains('analysis is ready') ||
            rawDataTitle.contains('new analysis') ||
            rawDataTitle.contains('analysis ready') ||
            (rawHeading.contains('complete') &&
                !rawHeading.contains('brief') &&
                !isWeightCta) ||
            (rawCta.contains('analysis') && !rawCta.contains('answer')) ||
            rawPriorityKind.contains('analysis'));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF9F8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.brandTeal.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isAnalysisReady ? Icons.check_circle_outline : Icons.auto_awesome,
                    size: 14,
                    color: AppColors.brandTeal,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    headingDisplay,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: AppColors.brandTeal,
                    ),
                  ),
                ],
              ),
              if (isAnalysisReady && rawHeading.contains('complete'))
                _buildBadgeChip('SCAN COMPLETE')
              else if (badgeNum != null)
                _buildBadgeChip(
                  badgeNum == 1
                      ? '1 day until your scan'
                      : (badgeNum == 0
                          ? 'Scan day'
                          : '$badgeNum days until your scan'),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Content Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (cardTitle.isNotEmpty)
                      Text(
                        cardTitle,
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          height: 1.3,
                        ),
                      ),
                    if (cardSubtitle.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        cardSubtitle,
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _buildRightGraphic(
                isAnalysisReady
                    ? Icons.bar_chart_rounded
                    : Icons.person_outline,
              ),
            ],
          ),
          if (isAnalysisReady) ...[
            const SizedBox(height: 16),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _handleViewAnalysis,
              child: Container(
                width: double.infinity,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.brandTeal,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ctaButtonLabel.isNotEmpty && ctaButtonLabel.toLowerCase().contains('analysis')
                          ? ctaButtonLabel
                          : 'View Your Analysis',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ] else if (isAnswered && data.step != null) ...[
            const SizedBox(height: 16),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (isWeightCta || data.questionKey == 'weight') {
                  _openWeightBottomSheet(context);
                } else {
                  _openAnswerSheet(context);
                }
              },
              child: Container(
                width: double.infinity,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.brandTeal.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: AppColors.brandTeal.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 18,
                      color: AppColors.brandTeal,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Completed for Today • Tap to change',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.brandTeal,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.edit_outlined,
                      size: 14,
                      color: AppColors.brandTeal,
                    ),
                  ],
                ),
              ),
            ),
          ] else if (ctaButtonLabel.isNotEmpty) ...[
            const SizedBox(height: 16),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (isWeightCta || data.questionKey == 'weight') {
                  _openWeightBottomSheet(context);
                } else if (data.step != null) {
                  _openAnswerSheet(context);
                } else {
                  _handleViewAnalysis();
                }
              },
              child: Container(
                width: double.infinity,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.brandTeal,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ctaButtonLabel,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTransitionCard(BuildContext context, HomeDailyBriefModel data) {
    final headingDisplay = data.heading ?? '';
    final cardTitle = data.title ?? '';
    final cardSubtitle = data.subtitle ?? '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF9F8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.brandTeal.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                size: 14,
                color: AppColors.brandTeal,
              ),
              const SizedBox(width: 6),
              Text(
                headingDisplay,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: AppColors.brandTeal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (cardTitle.isNotEmpty)
            Text(
              cardTitle,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                height: 1.3,
              ),
            ),
          if (cardSubtitle.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              cardSubtitle,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBadgeChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.brandTeal.withValues(alpha: 0.15),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.brandTeal,
        ),
      ),
    );
  }

  Widget _buildRightGraphic(IconData iconData) {
    return Container(
      width: 64,
      height: 64,
      decoration: const BoxDecoration(
        color: Color(0xFFD4EFEF),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: Color(0xFF0C191B),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              iconData,
              size: 24,
              color: AppColors.brandTeal,
            ),
          ),
        ),
      ),
    );
  }
}
