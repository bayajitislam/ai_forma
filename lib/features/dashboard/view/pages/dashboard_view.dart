import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_forma/core/common/app_dialog.dart';
import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/features/auth/controllers/user_controller.dart';
import 'package:ai_forma/features/check_in/controllers/check_in_controller.dart';
import 'package:ai_forma/features/check_in/view/pages/camera_position_view.dart';
import 'package:ai_forma/features/check_in/view/pages/check_in_intro_view.dart';
import 'package:ai_forma/features/dashboard/constants/dashboard_strings.dart';
import 'package:ai_forma/features/dashboard/controllers/home_controller.dart';
import 'package:ai_forma/features/dashboard/controllers/weight_controller.dart';
import 'package:ai_forma/features/dashboard/models/home_response_model.dart';
import 'package:ai_forma/features/dashboard/repositories/dashboard_repository.dart';
import 'package:ai_forma/features/dashboard/view/widgets/ai_daily_brief_card.dart';
import 'package:ai_forma/features/dashboard/view/widgets/ai_insight_card.dart';
import 'package:ai_forma/features/dashboard/view/widgets/answer_daily_brief_bottom_sheet.dart';
import 'package:ai_forma/features/dashboard/view/widgets/dashboard_header.dart';
import 'package:ai_forma/features/dashboard/view/widgets/latest_check_in_card.dart';
import 'package:ai_forma/features/dashboard/view/widgets/metric_card.dart';
import 'package:ai_forma/features/dashboard/view/widgets/momentum_card.dart';
import 'package:ai_forma/features/dashboard/view/widgets/sparkline_chart.dart';
import 'package:ai_forma/features/dashboard/view/widgets/todays_priority_card.dart';
import 'package:ai_forma/features/dashboard/view/widgets/weekly_scan_card.dart';
import 'package:ai_forma/features/dashboard/view/widgets/weight_entry_bottom_sheet.dart';
import 'package:ai_forma/features/dashboard/view/pages/weight_trends_view.dart';
import 'package:ai_forma/features/dashboard/view/pages/weekly_progress_view.dart';
import 'package:ai_forma/features/profile/view/pages/subscription_view.dart';
import 'package:ai_forma/features/timeline/view/pages/scan_detail_view.dart';

class DashboardView extends StatelessWidget {
  final void Function({String? scanId})? goInsight;
  const DashboardView({super.key, required this.goInsight});

  String _formatWeightChange(String? changeKg) {
    if (changeKg == null || changeKg.isEmpty) return '-';
    final numVal = double.tryParse(changeKg);
    if (numVal != null && numVal > 0 && !changeKg.startsWith('+')) {
      return '+$changeKg kg';
    }
    return '$changeKg kg';
  }

  Color _getStatusToneColor(String? tone) {
    switch (tone?.toLowerCase()) {
      case 'positive':
        return AppColors.brandTeal;
      case 'warning':
        return const Color(0xFFF57C00);
      case 'neutral':
      default:
        return AppColors.textSecondary;
    }
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

  void _handleTodayPriorityTap(
    BuildContext context,
    HomeResponseModel? homeData,
  ) {
    final priority = homeData?.todayPriority;
    if (priority == null) return;

    switch (priority.kind) {
      case 'weekly_initial':
        if (Get.isRegistered<CheckInController>()) {
          Get.find<CheckInController>().isWeeklyCheckIn(false);
        }
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const CheckInIntroView()),
        );
        break;

      case 'weekly':
        final user = Get.isRegistered<UserController>()
            ? Get.find<UserController>().currentUser.value
            : null;
        final isPaid = user?.isPaid ?? false;
        final paywallRequired = homeData?.weeklyScan?.paywallRequired ?? false;
        final isPremium = isPaid && !paywallRequired;

        if (!isPremium) {
          _showPremiumDialog(context);
          return;
        }

        final dailyBrief = homeData?.dailyBrief;
        final bool isAnswered = dailyBrief?.alreadyAnswered ?? true;
        final bool briefVisible = dailyBrief?.visible ?? false;

        if (briefVisible && !isAnswered) {
          showDialog(
            context: context,
            builder: (dialogCtx) => AppDialog(
              icon: Icons.scale_rounded,
              title: 'Log Weight Before Scan',
              message:
                  'Track your weight for more accurate scan analysis, or skip to proceed.',
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
                        await controller.submitScanDayWeight(
                          weightKg: savedWeight,
                        );
                      }
                    }
                    if (context.mounted) {
                      if (Get.isRegistered<CheckInController>()) {
                        Get.find<CheckInController>().isWeeklyCheckIn(true);
                      }
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const CameraPositionView(),
                        ),
                      );
                    }
                  },
                );
              },
              onCancel: () {
                Navigator.pop(dialogCtx);
                // User chose to skip! Proceed directly to scan
                if (Get.isRegistered<CheckInController>()) {
                  Get.find<CheckInController>().isWeeklyCheckIn(true);
                }
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const CameraPositionView(),
                  ),
                );
              },
            ),
          );
          return;
        }

        if (Get.isRegistered<CheckInController>()) {
          Get.find<CheckInController>().isWeeklyCheckIn(true);
        }
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const CameraPositionView()),
        );
        break;

      case 'daily':
        if (homeData?.dailyBrief?.step != null) {
          AnswerDailyBriefBottomSheet.show(
            context,
            dailyBriefData: homeData!.dailyBrief,
            onSavedOption: (questionKey, selectedValue) async {
              if (!Get.isRegistered<HomeController>()) return;
              final controller = Get.find<HomeController>();
              final prefill = homeData.dailyBrief?.weightKgPrefill;
              final weight = prefill != null ? double.tryParse(prefill) : null;
              final result = await controller.submitDailyBriefAnswer(
                questionKey: questionKey,
                selectedOption: selectedValue,
                weightKg: weight,
                alreadyAnswered: homeData.dailyBrief?.alreadyAnswered ?? false,
              );
              if (context.mounted) {
                Navigator.of(context).pop();
              }
              if (result.success) {
                Get.snackbar(
                  'Success',
                  'Response saved successfully',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.brandTeal,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                );
              }
            },
          );
        }
        break;

      case 'analysis_locked':
      case 'paywall_required':
        _showPremiumDialog(context);
        break;

      case 'analysis':
      case 'analysis_ready':
      case 'new_analysis':
      case 'view_analysis':
      case 'insights':
      case 'latest_analysis':
        final scanId =
            homeData?.aiInsight?.scanId ?? homeData?.latestAnalysis?.scanId;
        goInsight?.call(scanId: scanId);
        break;

      default:
        final label = priority.ctaLabel?.toLowerCase() ?? '';
        final kind = priority.kind.toLowerCase();
        if (label.contains('weight') || kind.contains('weight')) {
          final prefill =
              homeData?.dailyBrief?.weightKgPrefill ?? homeData?.weight?.currentKg;
          final initialWeight = prefill != null ? double.tryParse(prefill) : null;

          WeightEntryBottomSheet.show(
            context,
            initialWeightKg: initialWeight,
            onWeightSaved: (savedWeight) async {
              if (Get.isRegistered<HomeController>()) {
                final controller = Get.find<HomeController>();
                if (homeData?.dailyBrief?.step != null) {
                  await controller.submitDailyBriefAnswer(
                    questionKey: homeData?.dailyBrief?.questionKey ?? 'weight',
                    selectedOption: homeData?.dailyBrief?.selectedOption ?? '',
                    weightKg: savedWeight,
                    alreadyAnswered:
                        homeData?.dailyBrief?.alreadyAnswered ?? false,
                  );
                } else {
                  await controller.submitScanDayWeight(weightKg: savedWeight);
                }
              }
            },
          );
          return;
        }

        if (label.contains('analysis') ||
            label.contains('insight') ||
            kind.contains('analysis') ||
            kind.contains('insight')) {
          final scanId =
              homeData?.aiInsight?.scanId ?? homeData?.latestAnalysis?.scanId;
          goInsight?.call(scanId: scanId);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final weightController = Get.isRegistered<WeightController>()
        ? Get.find<WeightController>()
        : Get.put(WeightController());

    final homeController = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(
            HomeController(
              repository: DashboardRepository(
                Get.isRegistered<DioClient>()
                    ? Get.find<DioClient>()
                    : DioClient(),
              ),
            ),
          );

    return Obx(() {
      final isLoading = homeController.isLoading.value;
      final homeData = homeController.homeData.value;
      final weightData = homeData?.weight;

      if (isLoading && homeData == null) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.brandTeal),
        );
      }

      final currentWeightStr = weightData?.currentKg != null
          ? '${weightData!.currentKg} kg'
          : (weightController.currentWeight != null
                ? '${weightController.currentWeight!.weightKg.toStringAsFixed(1)} kg'
                : '-');

      final weightChangeStr = weightData?.changeKg != null
          ? _formatWeightChange(weightData!.changeKg)
          : weightController.weightChangeSinceLastString;

      final statusLabelStr = (weightData?.statusLabel.isNotEmpty ?? false)
          ? weightData!.statusLabel
          : weightController.weeklyProgressStatus;

      final statusToneColor = _getStatusToneColor(weightData?.statusTone);

      final isDailyBriefVisible = homeData?.dailyBrief?.visible == true;
      final isWeeklyScanVisible = homeData?.weeklyScan?.visible == true;
      final isLatestAnalysisVisible = homeData?.latestAnalysis != null;
      final isAiInsightVisible =
          homeData?.aiInsight != null &&
          (homeData?.aiInsight?.text?.trim().isNotEmpty ?? false);

      return RefreshIndicator(
        onRefresh: () => homeController.fetchHomeData(force: true),
        color: AppColors.brandTeal,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header (Greeting, Status Message, Date, Avatar)
              DashboardHeader(headerData: homeData?.header),
              const SizedBox(height: 16),

              // 2. Momentum Card
              MomentumCard(momentumData: homeData?.momentum),
              const SizedBox(height: 16),

              // 3. Today's Priority (One-line CTA directly above weight cards)
              if (homeData?.todayPriority != null) ...[
                TodaysPriorityCard(
                  priorityData: homeData!.todayPriority,
                  onActionTap: () => _handleTodayPriorityTap(context, homeData),
                ),
                const SizedBox(height: 16),
              ],
              // 4. AI Daily Brief Widget (only when daily_brief.visible == true)
              if (isDailyBriefVisible) ...[
                AIDailyBriefCard(
                  priorityData: homeData?.todayPriority,
                  dailyBriefData: homeData?.dailyBrief,
                  onScanCompleteTap: () {
                    final scanId =
                        homeData?.aiInsight?.scanId ??
                        homeData?.latestAnalysis?.scanId;
                    goInsight?.call(scanId: scanId);
                  },
                  goInsightPage: () {
                    final scanId =
                        homeData?.aiInsight?.scanId ??
                        homeData?.latestAnalysis?.scanId;
                    goInsight?.call(scanId: scanId);
                  },
                ),
                const SizedBox(height: 16),
              ],

              // 5. Weekly Scan Widget (only when weekly_scan.visible == true)
              if (isWeeklyScanVisible) ...[
                WeeklyScanCard(
                  weeklyScanData: homeData?.weeklyScan,
                  onPaywallTap: () => _showPremiumDialog(context),
                ),
                const SizedBox(height: 16),
              ],

              // 6. Current Weight & Weekly Change Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const WeightTrendsView(),
                          ),
                        );
                      },
                      child: MetricCard(
                        label: DashboardStrings.currentWeight,
                        value: currentWeightStr,
                        trendText: weightChangeStr,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const WeeklyProgressView(),
                          ),
                        );
                      },
                      child: MetricCard(
                        label: DashboardStrings.weeklyChange,
                        value: weightChangeStr,
                        caption: statusLabelStr,
                        captionColor: statusToneColor,
                        child: const SparklineChart(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 7. Latest Analysis (only when latest_analysis != null)
              if (isLatestAnalysisVisible) ...[
                LatestCheckInCard(
                  analysisData: homeData?.latestAnalysis,
                  onTap: () {
                    final scanId = homeData?.latestAnalysis?.scanId;
                    if (scanId != null && scanId.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => ScanDetailView(scanId: scanId),
                        ),
                      );
                    } else {
                      goInsight?.call();
                    }
                  },
                ),
                const SizedBox(height: 16),
              ],

              // 8. AI Insight (only when ai_insight != null)
              if (isAiInsightVisible) ...[
                AiInsightCard(
                  goInsightPage: () =>
                      goInsight?.call(scanId: homeData?.aiInsight?.scanId),
                  aiInsightData: homeData?.aiInsight,
                ),
                const SizedBox(height: 16),
              ],

              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    });
  }
}
