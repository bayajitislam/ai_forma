import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/check_in/constants/check_in_strings.dart';
import 'package:ai_forma/features/check_in/controllers/check_in_controller.dart';
import 'package:ai_forma/features/check_in/repositories/check_in_repository.dart';
import 'package:ai_forma/features/check_in/view/pages/check_in_intro_view.dart';
import 'package:ai_forma/features/check_in/view/widgets/check_in_streak_card.dart';

import 'package:ai_forma/features/auth/controllers/user_controller.dart';
import 'package:ai_forma/features/check_in/view/pages/camera_position_view.dart';

class CheckInHomeView extends StatelessWidget {
  final void Function()? goInsightPage;
  const CheckInHomeView({super.key, required this.goInsightPage});

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
      Get.snackbar(
        'Check-In Completed',
        'Your weekly check-in for this cycle is complete.',
        backgroundColor: AppColors.brandTeal,
        colorText: Colors.white,
      );
      return;
    }

    if (isInitialScanCompleted) {
      controller?.isWeeklyCheckIn(true);
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const CameraPositionView()),
      );
    } else {
      controller?.isWeeklyCheckIn(false);
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const CheckInIntroView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<CheckInController>()
        ? Get.find<CheckInController>()
        : Get.put(CheckInController(repository: CheckInRepository(Get.find())));

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
              const Text(
                'Check-In',
                style: AppTextStyles.authSectionTitle,
              ),
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
                  final currentDay = status?.checkDay.isNotEmpty == true
                      ? status!.checkDay
                      : controller.selectedCheckDay.value;

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

                        // Statistic Cards Row (Non-tappable Check Day)
                        Row(
                          children: [
                            // 1. Check Day Card
                            CheckInStatCard(
                              icon: AppIcons.calendar,
                              value: currentDay,
                              label: CheckInStrings.statCheckDay,
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
                      ],
                    ),
                  );
                }),
              ),

              // Begin New Scan CTA Button (Disabled if weekly_checkin_available is false)
              Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 12),
                child: Obx(() {
                  final status = controller.statusData.value;
                  final isAvailable = status?.today?.weeklyCheckinAvailable ?? true;
                  final ctaLabel = status?.cta?.label ?? CheckInStrings.beginNewScan;

                  return PrimaryButton(
                    onPressed: isAvailable ? () => _beginScan(context) : null,
                    label: ctaLabel,
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
