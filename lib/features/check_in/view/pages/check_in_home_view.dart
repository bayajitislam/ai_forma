import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/check_in/constants/check_in_strings.dart';
import 'package:ai_forma/features/check_in/controllers/check_in_controller.dart';
import 'package:ai_forma/features/check_in/repositories/check_in_repository.dart';
import 'package:ai_forma/features/check_in/view/widgets/check_in_streak_card.dart';
import 'package:ai_forma/features/auth/controllers/user_controller.dart';
import 'package:ai_forma/features/check_in/view/widgets/choose_check_in_day_bottom_sheet.dart';
import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/features/dashboard/controllers/home_controller.dart';
import 'package:ai_forma/features/dashboard/view/widgets/weight_entry_bottom_sheet.dart';
import 'package:ai_forma/routes/routes_name.dart';

class CheckInHomeView extends StatelessWidget {
  final void Function()? goInsightPage;
  const CheckInHomeView({super.key, required this.goInsightPage});

  String _getFullDayName(String day) {
    final clean = day.trim().toLowerCase();
    switch (clean) {
      case 'mon':
      case 'monday':
        return 'Monday';
      case 'tue':
      case 'tues':
      case 'tuesday':
        return 'Tuesday';
      case 'wed':
      case 'wednesday':
        return 'Wednesday';
      case 'thu':
      case 'thur':
      case 'thursday':
        return 'Thursday';
      case 'fri':
      case 'friday':
        return 'Friday';
      case 'sat':
      case 'saturday':
        return 'Saturday';
      case 'sun':
      case 'sunday':
        return 'Sunday';
      default:
        if (day.isEmpty) return 'Sunday';
        return day[0].toUpperCase() + day.substring(1);
    }
  }

  void _beginScan(BuildContext context) {
    final controller = Get.isRegistered<CheckInController>()
        ? Get.find<CheckInController>()
        : null;

    final user = Get.isRegistered<UserController>()
        ? Get.find<UserController>().currentUser.value
        : null;

    final isInitialScanCompleted = user?.initialScanCompleted ?? false;
    final status = controller?.statusData.value;

    if (isInitialScanCompleted &&
        status != null &&
        status.today?.weeklyCheckinAvailable == false) {
      _showNextScanInfoBottomSheet(
        context,
        status.checkDay.isNotEmpty
            ? status.checkDay
            : CheckInStrings.checkDayValue,
      );
      return;
    }

    final homeData = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>().homeData.value
        : null;

    final dailyBrief = homeData?.dailyBrief;
    final bool isAnswered = dailyBrief?.alreadyAnswered ?? true;
    final bool briefVisible = dailyBrief?.visible ?? false;

    // If daily brief / weight has not been answered yet, prompt weight bottom sheet first!
    if (briefVisible && !isAnswered) {
      final prefill = dailyBrief?.weightKgPrefill ?? homeData?.weight?.currentKg;
      final initialWeight = prefill != null ? double.tryParse(prefill) : null;

      WeightEntryBottomSheet.show(
        context,
        initialWeightKg: initialWeight,
        onWeightSaved: (savedWeight) async {
          if (Get.isRegistered<HomeController>()) {
            final hController = Get.find<HomeController>();
            if (dailyBrief?.step != null) {
              await hController.submitDailyBriefAnswer(
                questionKey: dailyBrief?.questionKey ?? 'weight',
                selectedOption: dailyBrief?.selectedOption ?? '',
                weightKg: savedWeight,
                alreadyAnswered: false,
              );
            } else {
              await hController.submitScanDayWeight(weightKg: savedWeight);
            }
          }

          if (context.mounted) {
            _proceedToScan(controller, isInitialScanCompleted);
          }
        },
      );
      return;
    }

    _proceedToScan(controller, isInitialScanCompleted);
  }

  void _proceedToScan(
    CheckInController? controller,
    bool isInitialScanCompleted,
  ) {
    if (isInitialScanCompleted) {
      controller?.isWeeklyCheckIn(true);
      Get.toNamed(RoutesName.cameraPosition);
    } else {
      controller?.isWeeklyCheckIn(false);
      Get.toNamed(RoutesName.checkInIntro);
    }
  }

  void _showNextScanInfoBottomSheet(BuildContext context, String checkDay) {
    final fullDay = _getFullDayName(checkDay);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.iconBackground,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: AppIcon(
                  icon: AppIcons.calendar,
                  size: 32,
                  color: AppColors.brandTeal,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Next Weekly Scan Schedule',
              style: AppTextStyles.authSectionTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Your check-in for this week is completed! Your next scan will be available on $fullDay.',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.onboardingBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.event_available_rounded,
                    color: AppColors.brandTeal,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Next Check-In Day',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          fullDay,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              onPressed: () => Navigator.of(ctx).pop(),
              label: 'GOT IT',
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<CheckInController>()
        ? Get.find<CheckInController>()
        : Get.put(
            CheckInController(
              repository: CheckInRepository(
                Get.isRegistered<DioClient>()
                    ? Get.find<DioClient>()
                    : Get.put(DioClient(), permanent: true),
              ),
            ),
          );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: RefreshIndicator(
          onRefresh: () => controller.fetchStatusData(force: true),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              // Heading
              const Text('Check-In', style: AppTextStyles.authSectionTitle),
              const SizedBox(height: 4),
              // Supporting text
              const Text(
                'Track your progress with a new body scan.',
                style: AppTextStyles.authBody,
              ),
              const SizedBox(height: 20),

              Expanded(
                child: Obx(() {
                  final status = controller.statusData.value;
                  final streakWeeks = status?.streakWeeks ?? 12;
                  final personalBest = status?.personalBestWeeks ?? 12;
                  final totalCheckins = status?.totalCheckins ?? 12;
                  final onTimePercent = status?.onTimePercent ?? 92;
                  final rawDay = status?.checkDay.isNotEmpty == true
                      ? status!.checkDay
                      : controller.selectedCheckDay.value;
                  final currentDay = _getFullDayName(rawDay);

                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Streak Card
                        CheckInStreakCard(
                          streakWeeks: streakWeeks,
                          personalBest: personalBest,
                          streakHistory: status?.streakHistory,
                        ),
                        const SizedBox(height: 16),

                        // Statistic Cards Row (Tappable Check Day)
                        Row(
                          children: [
                            // 1. Check Day Card (Tappable to change weekly scan day)
                            CheckInStatCard(
                              icon: AppIcons.calendar,
                              value: currentDay,
                              label: CheckInStrings.statCheckDay,
                              showChevron: true,
                              onTap: () {
                                ChooseCheckInDayBottomSheet.show(
                                  context,
                                  currentDay: currentDay,
                                  onSaved: (selectedDay) {
                                    controller.updateCheckInDay(
                                      selectedDay,
                                      context: context,
                                    );
                                  },
                                );
                              },
                            ),
                            const SizedBox(width: 10),
                            // 2. On-Time
                            CheckInStatCard(
                              icon: AppIcons.time,
                              value: '$onTimePercent%',
                              label: CheckInStrings.statOnTime,
                            ),
                            const SizedBox(width: 10),
                            // 3. Total
                            CheckInStatCard(
                              icon: AppIcons.checkCircle,
                              value: '$totalCheckins',
                              label: CheckInStrings.statTotal,
                            ),
                          ],
                        ),

                        // Pending Scan Day Notification Badge
                        if (status?.pendingScanDay != null &&
                            status!.pendingScanDay!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.onboardingBackground,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.schedule_rounded,
                                  color: AppColors.brandTeal,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Pending change to ${_getFullDayName(status.pendingScanDay!)} (takes effect next cycle)',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        // Bridge Day / Transition Card (today.kind == 'none')
                        if (status?.today?.kind == 'none') ...[
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.iconBackground,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.brandTeal.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.info_outline_rounded,
                                  color: AppColors.brandTeal,
                                  size: 22,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Transition Schedule Active',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Your new scan schedule is set. Your next weekly scan is scheduled for $currentDay. Your Daily Brief will begin 6 days before your scan.',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: AppColors.textSecondary,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }),
              ),

              // Update Weight & Weekly Check-In CTA Buttons
              Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 12),
                child: Obx(() {
                  final status = controller.statusData.value;
                  final isAvailable =
                      status?.today?.weeklyCheckinAvailable ?? true;
                  final ctaLabel = CheckInStrings.beginNewScan;
                  final rawCheckDay =
                      status?.checkDay ?? CheckInStrings.checkDayValue;
                  final checkDay = _getFullDayName(rawCheckDay);

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // PrimaryButton(
                      //   onPressed: () => _openWeightEntryBottomSheet(context),
                      //   label: 'UPDATE WEIGHT',
                      // ),
                      // const SizedBox(height: 12),
                      PrimaryButton(
                        onPressed: () {
                          if (isAvailable) {
                            _beginScan(context);
                          } else {
                            _showNextScanInfoBottomSheet(context, checkDay);
                          }
                        },
                        label: ctaLabel,
                      ),
                      if (!isAvailable) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Next Weekly check-in available on $checkDay',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
