import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/features/dashboard/controllers/daily_brief_controller.dart';
import 'package:ai_forma/features/dashboard/controllers/home_controller.dart';
import 'package:ai_forma/features/dashboard/models/home_response_model.dart';
import 'package:ai_forma/features/dashboard/view/widgets/answer_daily_brief_bottom_sheet.dart';
import 'package:ai_forma/features/dashboard/view/widgets/weight_entry_bottom_sheet.dart';

class AIDailyBriefCard extends StatefulWidget {
  const AIDailyBriefCard({
    super.key,
    this.priorityData,
    this.dailyBriefData,
    this.forceScanDay = false,
    this.onScanCompleteTap,
  });

  final HomeTodayPriorityModel? priorityData;
  final HomeDailyBriefModel? dailyBriefData;
  final bool forceScanDay;
  final VoidCallback? onScanCompleteTap;

  @override
  State<AIDailyBriefCard> createState() => _AIDailyBriefCardState();
}

class _AIDailyBriefCardState extends State<AIDailyBriefCard> {
  double? _savedScanWeightKg;

  @override
  void initState() {
    super.initState();
    _initWeightPrefill();
  }

  void _initWeightPrefill() {
    final prefill = widget.dailyBriefData?.weightKgPrefill;
    if (prefill != null && prefill.trim().isNotEmpty) {
      final parsed = double.tryParse(prefill);
      if (parsed != null && parsed > 0) {
        _savedScanWeightKg = parsed;
        return;
      }
    }

    if (Get.isRegistered<HomeController>()) {
      final homeData = Get.find<HomeController>().homeData.value;
      if (homeData?.weeklyScan?.cycleWeightKg != null &&
          homeData!.weeklyScan!.cycleWeightKg!.trim().isNotEmpty) {
        final parsed = double.tryParse(homeData.weeklyScan!.cycleWeightKg!);
        if (parsed != null && parsed > 0) {
          _savedScanWeightKg = parsed;
          return;
        }
      }
      if (homeData?.weeklyScan?.weightLogged == true &&
          homeData?.weight?.currentKg != null) {
        final parsed = double.tryParse(homeData!.weight!.currentKg!);
        if (parsed != null && parsed > 0) {
          _savedScanWeightKg = parsed;
          return;
        }
      }
    }
  }

  @override
  void didUpdateWidget(covariant AIDailyBriefCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dailyBriefData?.weightKgPrefill !=
            oldWidget.dailyBriefData?.weightKgPrefill ||
        widget.dailyBriefData?.alreadyAnswered !=
            oldWidget.dailyBriefData?.alreadyAnswered) {
      _initWeightPrefill();
    }
  }

  void _openWeightPicker(BuildContext context) {
    final initialVal = _savedScanWeightKg ??
        (Get.isRegistered<HomeController>()
            ? double.tryParse(
                Get.find<HomeController>().homeData.value?.weight?.currentKg ??
                    '',
              )
            : null);

    WeightEntryBottomSheet.show(
      context,
      initialWeightKg: initialVal,
      onWeightSaved: (weight) async {
        setState(() {
          _savedScanWeightKg = weight;
        });

        if (Get.isRegistered<HomeController>()) {
          final homeController = Get.find<HomeController>();
          final result = await homeController.submitScanDayWeight(weightKg: weight);
          if (result.success) {
            Get.snackbar(
              'Success',
              'Scan day weight saved',
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

  @override
  Widget build(BuildContext context) {
    final controller = DailyBriefController.to;

    return Obx(() {
      final daysLeft = controller.daysUntilScan.value;
      final homeData = Get.isRegistered<HomeController>()
          ? Get.find<HomeController>().homeData.value
          : null;

      final isAnswered = widget.dailyBriefData?.alreadyAnswered ??
          (widget.priorityData?.alreadyAnswered ?? false);

      final badgeNum = widget.dailyBriefData?.badge ?? daysLeft;

      final ctaLabelText = widget.dailyBriefData?.ctaLabel ??
          widget.priorityData?.ctaLabel;

      final kindStr = widget.dailyBriefData?.kind ?? widget.priorityData?.kind;

      final lowerHeading = widget.dailyBriefData?.heading?.toLowerCase() ?? '';
      final titleText = widget.dailyBriefData?.title?.toLowerCase() ?? '';

      final todayDate = homeData?.header?.today;
      final scanDate = homeData?.latestAnalysis?.scanDate;
      final isScanDateToday = (todayDate != null &&
          scanDate != null &&
          todayDate.isNotEmpty &&
          todayDate == scanDate);

      final isPriorityNone = widget.priorityData?.kind == 'none';
      final isBriefHidden = widget.dailyBriefData?.visible == false;

      final isScanComplete = isScanDateToday ||
          kindStr == 'scan_complete' ||
          (isBriefHidden && isPriorityNone) ||
          lowerHeading.contains('scan complete') ||
          titleText.contains('analysis is ready');

      if (isScanComplete) {
        return _buildScanCompleteCard(context);
      }

      final isScanDay = widget.forceScanDay ||
          kindStr == 'scan_day' ||
          badgeNum == 0 ||
          lowerHeading == 'scan day';

      final hasLoggedWeightToday = _savedScanWeightKg != null ||
          (widget.dailyBriefData?.weightKgPrefill != null &&
              widget.dailyBriefData!.weightKgPrefill!.isNotEmpty) ||
          (homeData?.weeklyScan?.weightLogged == true) ||
          (homeData?.weeklyScan?.cycleWeightKg != null);

      final displayWeight = _savedScanWeightKg ??
          (widget.dailyBriefData?.weightKgPrefill != null
              ? double.tryParse(widget.dailyBriefData!.weightKgPrefill!)
              : (homeData?.weeklyScan?.cycleWeightKg != null
                  ? double.tryParse(homeData!.weeklyScan!.cycleWeightKg!)
                  : (homeData?.weight?.currentKg != null
                      ? double.tryParse(homeData!.weight!.currentKg!)
                      : null)));

      if (isScanDay) {
        if (hasLoggedWeightToday && displayWeight != null) {
          return _buildScanDayWeightUpdatedCard(context, displayWeight);
        } else {
          return _buildScanDayWeightPendingCard(context);
        }
      }

      final aiTitle = widget.dailyBriefData?.aiFeedback?.title ??
          homeData?.todayAiFeedback?.title;
      final aiDescription = widget.dailyBriefData?.aiFeedback?.description ??
          homeData?.todayAiFeedback?.description;

      final headingDisplay = widget.dailyBriefData?.heading ?? 'AI DAILY BRIEF';

      final cardTitle = isAnswered && aiTitle != null && aiTitle.isNotEmpty
          ? aiTitle
          : (widget.dailyBriefData?.title ??
              widget.priorityData?.text ??
              'How did you sleep most nights this week?');

      final cardSubtitle = isAnswered &&
              aiDescription != null &&
              aiDescription.isNotEmpty
          ? aiDescription
          : (widget.dailyBriefData?.subtitle ??
              'Your answers help AiFORMA build a more accurate understanding of your recovery before your next scan.');

      final ctaButtonLabel = (ctaLabelText != null && ctaLabelText.isNotEmpty)
          ? ctaLabelText
          : "Answer today's question";

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
                _buildBadgeChip('$badgeNum days until your scan'),
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
                  ),
                ),
                const SizedBox(width: 12),
                _buildRightGraphic(Icons.person_outline),
              ],
            ),
            if (isAnswered) ...[
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => _openAnswerSheet(context),
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
                onTap: () => _openAnswerSheet(context),
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
    });
  }

  // Scan Day State 1: Weight Needed
  Widget _buildScanDayWeightPendingCard(BuildContext context) {
    final data = widget.dailyBriefData;
    final headingText = (data?.heading?.trim().isNotEmpty == true)
        ? data!.heading!
        : 'AI DAILY BRIEF';
    final cardTitle = (data?.title?.trim().isNotEmpty == true)
        ? data!.title!
        : 'One final step today.';
    final cardSubtitle = (data?.subtitle?.trim().isNotEmpty == true)
        ? data!.subtitle!
        : "Add today's weight before your scan so AiFORMA can compare it with your previous check-in and understand your progress in context.";
    final ctaText = (data?.ctaLabel?.trim().isNotEmpty == true)
        ? data!.ctaLabel!
        : 'Update Weight';
    final badgeText = (data?.kind?.trim().isNotEmpty == true &&
            data!.kind != 'none')
        ? data.kind!.replaceAll('_', ' ').toUpperCase()
        : 'SCAN DAY';

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    headingText,
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
              _buildBadgeChip(badgeText),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                ),
              ),
              const SizedBox(width: 12),
              _buildRightGraphic(Icons.monitor_weight_outlined),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _openWeightPicker(context),
            child: Container(
              width: double.infinity,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.brandTeal,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Center(
                child: Text(
                  ctaText,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildHelperPill(
            icon: Icons.info_outline,
            text: "Weight needed to complete today's scan",
          ),
        ],
      ),
    );
  }

  // Scan Day State 2: Weight Updated
  Widget _buildScanDayWeightUpdatedCard(BuildContext context, [double? displayWeight]) {
    final data = widget.dailyBriefData;
    final headingText = (data?.heading?.trim().isNotEmpty == true)
        ? data!.heading!
        : 'AI DAILY BRIEF';
    final cardTitle = (data?.title?.trim().isNotEmpty == true)
        ? data!.title!
        : "You're ready for today's scan.";
    final cardSubtitle = (data?.subtitle?.trim().isNotEmpty == true)
        ? data!.subtitle!
        : "Your weight and Daily Brief responses are ready to be considered alongside today's physique scan.";
    final badgeText = (data?.kind?.trim().isNotEmpty == true &&
            data!.kind != 'none')
        ? data.kind!.replaceAll('_', ' ').toUpperCase()
        : 'SCAN DAY';
    final weightVal = displayWeight ?? _savedScanWeightKg ?? 0.0;

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    headingText,
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
              _buildBadgeChip(badgeText),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                ),
              ),
              const SizedBox(width: 12),
              _buildRightGraphic(Icons.camera_alt_outlined),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _openWeightPicker(context),
            child: Container(
              width: double.infinity,
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppColors.brandTeal.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 18,
                    color: AppColors.brandTeal,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Weight updated',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.brandTeal,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${weightVal.toStringAsFixed(1)} kg',
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.edit_outlined,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildHelperPill(
            icon: Icons.lock_outline,
            text: 'Proceed to your scan to see your new analysis.',
          ),
        ],
      ),
    );
  }

  // Scan Complete State
  Widget _buildScanCompleteCard(BuildContext context) {
    final headingText = (widget.dailyBriefData?.heading?.trim().isNotEmpty == true)
        ? widget.dailyBriefData!.heading!
        : 'AI DAILY BRIEF';
    final cardTitle = (widget.dailyBriefData?.title?.trim().isNotEmpty == true)
        ? widget.dailyBriefData!.title!
        : 'Your new analysis is ready.';
    final priorityText = widget.priorityData?.text;
    final cardSubtitle = (widget.dailyBriefData?.subtitle?.trim().isNotEmpty == true)
        ? widget.dailyBriefData!.subtitle!
        : ((priorityText != null && priorityText.trim().isNotEmpty)
            ? priorityText
            : 'Nice work completing your scan. Your latest insights are in and ready for you to review.');

    final ctaText = (widget.dailyBriefData?.ctaLabel?.trim().isNotEmpty == true)
        ? widget.dailyBriefData!.ctaLabel!
        : 'View Your New Analysis';

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    headingText,
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
              _buildBadgeChip('SCAN COMPLETE'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                ),
              ),
              const SizedBox(width: 12),
              _buildRightGraphic(Icons.bar_chart_rounded),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              if (widget.onScanCompleteTap != null) {
                widget.onScanCompleteTap!();
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
                    ctaText,
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
          const SizedBox(height: 12),
          _buildHelperPill(
            icon: Icons.check_circle_outline,
            text: widget.priorityData?.text ?? 'Scan completed for today',
          ),
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

  Widget _buildHelperPill({required IconData icon, required String text}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.brandTeal.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.brandTeal),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.brandTeal,
              ),
            ),
          ),
        ],
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

  void _openAnswerSheet(BuildContext context) {
    AnswerDailyBriefBottomSheet.show(
      context,
      dailyBriefData: widget.dailyBriefData,
      onSavedOption: (questionKey, selectedValue) async {
        if (!Get.isRegistered<HomeController>()) return;

        final controller = Get.find<HomeController>();
        final prefill = widget.dailyBriefData?.weightKgPrefill;
        final weight = prefill != null ? double.tryParse(prefill) : null;

        final result = await controller.submitDailyBriefAnswer(
          questionKey: questionKey,
          selectedOption: selectedValue,
          weightKg: weight,
          alreadyAnswered: widget.dailyBriefData?.alreadyAnswered ?? false,
        );

        if (context.mounted) {
          Navigator.of(context).pop();
        }

        if (result.success) {
          Get.snackbar(
            'Success',
            'Response updated successfully',
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
}
