import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/check_in/constants/check_in_strings.dart';
import 'package:ai_forma/features/check_in/controllers/check_in_controller.dart';
import 'package:ai_forma/features/check_in/repositories/check_in_repository.dart';
import 'package:ai_forma/features/check_in/view/pages/check_in_intro_view.dart';
import 'package:ai_forma/features/check_in/view/widgets/check_in_streak_card.dart';
import 'package:ai_forma/features/check_in/view/widgets/choose_check_in_day_bottom_sheet.dart';

import 'package:ai_forma/features/auth/controllers/user_controller.dart';
import 'package:ai_forma/features/check_in/view/pages/camera_position_view.dart';

class CheckInHomeView extends StatelessWidget {
  final void Function()? goInsightPage;
  const CheckInHomeView({super.key, required this.goInsightPage});

  void _beginScan(BuildContext context) {
    final user = Get.isRegistered<UserController>()
        ? Get.find<UserController>().currentUser.value
        : null;

    final isInitialScanCompleted = user?.initialScanCompleted ?? false;

    if (isInitialScanCompleted) {
      if (Get.isRegistered<CheckInController>()) {
        Get.find<CheckInController>().isWeeklyCheckIn(true);
      }
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const CameraPositionView()),
      );
    } else {
      if (Get.isRegistered<CheckInController>()) {
        Get.find<CheckInController>().isWeeklyCheckIn(false);
      }
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Streak Card
                    const CheckInStreakCard(),
                    const SizedBox(height: 16),

                    // Statistic Cards Row (Reordered: Check Day, On-Time, Total)
                    Obx(() {
                      final currentDay = controller.selectedCheckDay.value;
                      return Row(
                        children: [
                          // 1. Check Day Card (Interactive)
                          CheckInStatCard(
                            icon: AppIcons.calendar,
                            value: currentDay,
                            label: CheckInStrings.statCheckDay,
                            showChevron: true,
                            onTap: () {
                              ChooseCheckInDayBottomSheet.show(
                                context,
                                currentDay: currentDay,
                                onSaved: (newDay) {
                                  controller.setCheckDay(newDay);
                                },
                              );
                            },
                          ),
                          const SizedBox(width: 10),
                          // 2. On-Time
                          const CheckInStatCard(
                            icon: AppIcons.time,
                            value: '92%',
                            label: CheckInStrings.statOnTime,
                          ),
                          const SizedBox(width: 10),
                          // 3. Total
                          const CheckInStatCard(
                            icon: AppIcons.checkCircle,
                            value: '12',
                            label: CheckInStrings.statTotal,
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Begin New Scan CTA Button (Bottom of screen)
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 12),
              child: PrimaryButton(
                onPressed: () => _beginScan(context),
                label: CheckInStrings.beginNewScan,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
