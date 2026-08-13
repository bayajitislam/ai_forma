import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/features/dashboard/controllers/daily_brief_controller.dart';
import 'package:ai_forma/features/dashboard/view/widgets/answer_daily_brief_bottom_sheet.dart';

class AIDailyBriefCard extends StatelessWidget {
  const AIDailyBriefCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DailyBriefController.to;

    return Obx(() {
      final isAnswered = controller.isAnswered.value;
      final daysLeft = controller.daysUntilScan.value;

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
                  children: const [
                    Icon(
                      Icons.auto_awesome,
                      size: 14,
                      color: AppColors.brandTeal,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'AI DAILY BRIEF',
                      style: TextStyle(
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
                    '$daysLeft days until your scan',
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
                  child: isAnswered
                      ? _buildAnsweredContent(context, controller)
                      : _buildUnansweredContent(),
                ),
                const SizedBox(width: 12),
                _buildRightGraphic(),
              ],
            ),
            const SizedBox(height: 16),

            // Button / Link Area
            if (!isAnswered)
              GestureDetector(
                onTap: () {
                  AnswerDailyBriefBottomSheet.show(
                    context,
                    initialSelection: controller.selectedSleep.value,
                    onSaved: (quality) {
                      controller.saveResponse(quality);
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
                    children: const [
                      Text(
                        "Answer today's question",
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.chevron_right,
                        size: 18,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              )
            else
              GestureDetector(
                onTap: () {
                  AnswerDailyBriefBottomSheet.show(
                    context,
                    initialSelection: controller.selectedSleep.value,
                    onSaved: (quality) {
                      controller.saveResponse(quality);
                    },
                  );
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.edit_outlined,
                      size: 16,
                      color: AppColors.brandTeal,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "Change today's answer",
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.brandTeal,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildUnansweredContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'How did you sleep most nights this week?',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            height: 1.25,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Your answers help AiFORMA build a more accurate understanding of your recovery before your next scan.',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 12,
            color: AppColors.textSecondary,
            height: 1.35,
          ),
        ),
      ],
    );
  }

  Widget _buildAnsweredContent(
      BuildContext context, DailyBriefController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                color: Color(0xFF0C191B),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                size: 14,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Great sleep this week.',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          "Excellent sleep supports recovery, muscle repair and hormone balance. We'll factor this into your upcoming body scan analysis.",
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 12,
            color: AppColors.textSecondary,
            height: 1.35,
          ),
        ),
      ],
    );
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
