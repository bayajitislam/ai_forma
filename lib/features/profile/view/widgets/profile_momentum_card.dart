import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/features/dashboard/controllers/home_controller.dart';
import 'package:ai_forma/features/dashboard/models/home_response_model.dart';
import 'package:ai_forma/features/profile/constants/profile_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileMomentumCard extends StatelessWidget {
  const ProfileMomentumCard({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : null;

    if (homeController != null) {
      return Obx(() {
        final momentum = homeController.homeData.value?.momentum;
        return _buildCardContent(momentum);
      });
    }

    return _buildCardContent(null);
  }

  Widget _buildCardContent(HomeMomentumModel? momentum) {
    final score = momentum?.displayedScore ?? 0;
    final maxScore = momentum?.max ?? 100;
    final progressValue =
        (maxScore > 0) ? (score / maxScore).clamp(0.0, 1.0) : 0.0;
    final stateTitle = (momentum?.stateLabel.isNotEmpty ?? false)
        ? momentum!.stateLabel
        : ProfileStrings.momentumStateDefault;
    final insightText = (momentum?.insight.isNotEmpty ?? false)
        ? momentum!.insight
        : ProfileStrings.momentumInsightDefault;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Circular progress ring
          SizedBox(
            width: 68,
            height: 68,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Glow background
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.brandTeal.withValues(alpha: 0.15),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                // Track
                SizedBox(
                  width: 68,
                  height: 68,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 5,
                    backgroundColor: Colors.transparent,
                    color: AppColors.darkCardText.withValues(alpha: 0.15),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                // Fill progress
                SizedBox(
                  width: 68,
                  height: 68,
                  child: CircularProgressIndicator(
                    value: progressValue,
                    strokeWidth: 5,
                    backgroundColor: Colors.transparent,
                    color: AppColors.brandTeal,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                // Value Text
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$score',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                    Text(
                      '/$maxScore',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkCardText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Text details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stateTitle,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  insightText,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    color: AppColors.darkCardText,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
