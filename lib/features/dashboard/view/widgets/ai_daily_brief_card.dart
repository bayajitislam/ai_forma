import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/features/dashboard/controllers/daily_brief_controller.dart';
import 'package:ai_forma/features/dashboard/controllers/home_controller.dart';
import 'package:ai_forma/features/dashboard/models/home_response_model.dart';
import 'package:ai_forma/features/dashboard/view/widgets/answer_daily_brief_bottom_sheet.dart';

class AIDailyBriefCard extends StatelessWidget {
  const AIDailyBriefCard({super.key, this.priorityData, this.dailyBriefData});

  final HomeTodayPriorityModel? priorityData;
  final HomeDailyBriefModel? dailyBriefData;

  @override
  Widget build(BuildContext context) {
    // If backend specifies visible == false, hide the card completely
    if (dailyBriefData != null && !dailyBriefData!.visible) {
      return const SizedBox.shrink();
    }

    final controller = DailyBriefController.to;

    return Obx(() {
      final daysLeft = controller.daysUntilScan.value;
      final headingText = dailyBriefData?.heading ?? 'AI DAILY BRIEF';
      final badgeNum = dailyBriefData?.badge ?? daysLeft;
      final cardTitle = dailyBriefData?.title ??
          priorityData?.text ??
          'How did you sleep most nights this week?';
      final cardSubtitle = dailyBriefData?.subtitle ??
          'Your answers help AiFORMA build a more accurate understanding of your recovery before your next scan.';
      final ctaLabelText = dailyBriefData?.ctaLabel ?? priorityData?.ctaLabel ?? "Answer today's question";

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
            // Top Header Row
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.brandTeal.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Text(
                    '$badgeNum days until your scan',
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
            const SizedBox(height: 12),

            // Content Area
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
                _buildRightGraphic(),
              ],
            ),
            if (ctaLabelText.isNotEmpty) ...[
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  AnswerDailyBriefBottomSheet.show(
                    context,
                    dailyBriefData: dailyBriefData,
                    onSavedOption: (questionKey, selectedValue) {
                      if (Get.isRegistered<HomeController>()) {
                        final prefill = dailyBriefData?.weightKgPrefill;
                        final weight = prefill != null ? double.tryParse(prefill) : null;
                        Get.find<HomeController>().submitDailyBriefAnswer(
                          questionKey: questionKey,
                          selectedOption: selectedValue,
                          weightKg: weight,
                        );
                      }
                    },
                  );
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
                        ctaLabelText,
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

  Widget _buildRightGraphic() {
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
          child: const Center(
            child: Icon(
              Icons.person_outline,
              size: 24,
              color: AppColors.brandTeal,
            ),
          ),
        ),
      ),
    );
  }
}
