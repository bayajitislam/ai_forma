import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/features/auth/controllers/user_controller.dart';
import 'package:ai_forma/features/check_in/controllers/check_in_controller.dart';
import 'package:ai_forma/features/check_in/view/pages/camera_position_view.dart';
import 'package:ai_forma/features/check_in/view/pages/check_in_intro_view.dart';
import 'package:ai_forma/features/dashboard/controllers/home_controller.dart';
import 'package:ai_forma/features/dashboard/models/home_response_model.dart';
import 'package:ai_forma/features/dashboard/view/widgets/weight_entry_bottom_sheet.dart';

import 'package:ai_forma/core/common/app_dialog.dart';
import 'package:ai_forma/features/profile/view/pages/subscription_view.dart';

class WeeklyScanCard extends StatelessWidget {
  const WeeklyScanCard({
    super.key,
    this.weeklyScanData,
    this.forceVisible = false,
    this.onPaywallTap,
  });

  final HomeWeeklyScanModel? weeklyScanData;
  final bool forceVisible;
  final VoidCallback? onPaywallTap;

  bool _isPremiumUser() {
    final user = Get.isRegistered<UserController>()
        ? Get.find<UserController>().currentUser.value
        : null;

    if (user?.isPaid == true) return true;
    if (user?.membershipStatus?.toLowerCase() == 'premium') return true;

    // If weeklyScanData explicitly marks paywallRequired == true, definitely free
    if (weeklyScanData?.paywallRequired == true) {
      return false;
    }

    return false;
  }

  void _beginScan(BuildContext context) {
    if (!_isPremiumUser()) {
      if (onPaywallTap != null) {
        onPaywallTap!();
      } else {
        _showPremiumDialog(context);
      }
      return;
    }

    final homeData = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>().homeData.value
        : null;

    final dailyBrief = homeData?.dailyBrief;
    final bool isAnswered = dailyBrief?.alreadyAnswered ?? true;
    final bool briefVisible = dailyBrief?.visible ?? false;

    // If daily brief / weight has not been answered yet, prompt via AppDialog first!
    if (briefVisible && !isAnswered) {
      _showWeightPromptDialog(context, homeData, dailyBrief);
      return;
    }

    _proceedToScan(context);
  }

  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AppDialog(
        icon: Icons.workspace_premium_rounded,
        title: 'AiFORMA Premium',
        message:
            'Weekly body scans and AI physique analysis are available exclusively for Premium members. Upgrade now to track your transformation.',
        confirmText: 'Buy Premium',
        cancelText: 'Cancel',
        onConfirm: () {
          Navigator.pop(ctx);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const SubscriptionView(),
            ),
          );
        },
        onCancel: () => Navigator.pop(ctx),
      ),
    );
  }

  void _showWeightPromptDialog(
    BuildContext context,
    HomeResponseModel? homeData,
    HomeDailyBriefModel? dailyBrief,
  ) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AppDialog(
        icon: Icons.scale_rounded,
        title: 'Log Weight Before Scan',
        message:
            'Logging your weight before scanning helps AiFORMA calculate more accurate body composition changes. Would you like to log your weight now, or skip to scan?',
        confirmText: 'Log Weight',
        cancelText: 'Skip',
        onConfirm: () {
          Navigator.pop(dialogCtx);
          final prefill =
              dailyBrief?.weightKgPrefill ?? homeData?.weight?.currentKg;
          final initialWeight =
              prefill != null ? double.tryParse(prefill) : null;

          WeightEntryBottomSheet.show(
            context,
            initialWeightKg: initialWeight,
            onWeightSaved: (savedWeight) async {
              if (Get.isRegistered<HomeController>()) {
                final controller = Get.find<HomeController>();
                if (dailyBrief?.step != null) {
                  await controller.submitDailyBriefAnswer(
                    questionKey: dailyBrief?.questionKey ?? 'weight',
                    selectedOption: dailyBrief?.selectedOption ?? '',
                    weightKg: savedWeight,
                    alreadyAnswered: false,
                  );
                } else {
                  await controller.submitScanDayWeight(weightKg: savedWeight);
                }
              }

              if (context.mounted) {
                _proceedToScan(context);
              }
            },
          );
        },
        onCancel: () {
          Navigator.pop(dialogCtx);
          // User chose to skip! Proceed directly to scan
          _proceedToScan(context);
        },
      ),
    );
  }

  void _proceedToScan(BuildContext context) {
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
    if (!forceVisible && (weeklyScanData == null || !weeklyScanData!.visible)) {
      return const SizedBox.shrink();
    }

    return _buildScanReadyCard(context);
  }

  Widget _buildScanReadyCard(BuildContext context) {
    final cardTitle = weeklyScanData?.title ?? '';
    final cardSubtitle = weeklyScanData?.subtitle ?? '';
    final ctaText = weeklyScanData?.ctaLabel ??
        (weeklyScanData?.paywallRequired == true ? 'Subscribe' : '');
    final attachedLabel = weeklyScanData?.attachedBriefsLabel;

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
            children: const [
              Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: AppColors.brandTeal,
              ),
              SizedBox(width: 6),
              Text(
                'WEEKLY SCAN',
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        height: 1.25,
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
              // Right Graphic
              Container(
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
                      color: AppColors.brandTeal,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.crop_free,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (ctaText.isNotEmpty) ...[
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _beginScan(context),
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
          ],
          if (attachedLabel != null && attachedLabel.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.lock_outline,
                  size: 13,
                  color: AppColors.brandTeal,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    attachedLabel,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 9,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
