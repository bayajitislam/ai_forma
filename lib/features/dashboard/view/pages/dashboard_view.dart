import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/features/dashboard/constants/dashboard_strings.dart';
import 'package:ai_forma/features/dashboard/controllers/home_controller.dart';
import 'package:ai_forma/features/dashboard/controllers/weight_controller.dart';
import 'package:ai_forma/features/dashboard/repositories/dashboard_repository.dart';
import 'package:ai_forma/features/dashboard/view/widgets/ai_daily_brief_card.dart';
import 'package:ai_forma/features/dashboard/view/widgets/ai_insight_card.dart';
import 'package:ai_forma/features/dashboard/view/widgets/dashboard_header.dart';
import 'package:ai_forma/features/dashboard/view/widgets/latest_check_in_card.dart';
import 'package:ai_forma/features/dashboard/view/widgets/metric_card.dart';
import 'package:ai_forma/features/dashboard/view/widgets/momentum_card.dart';
import 'package:ai_forma/features/dashboard/view/widgets/sparkline_chart.dart';
import 'package:ai_forma/features/dashboard/view/widgets/weekly_scan_card.dart';
import 'package:ai_forma/features/dashboard/view/pages/weight_trends_view.dart';
import 'package:ai_forma/features/dashboard/view/pages/weekly_progress_view.dart';

class DashboardView extends StatelessWidget {
  final void Function()? goInsight;
  const DashboardView({super.key, required this.goInsight});

  String _formatWeightChange(String? changeKg) {
    if (changeKg == null || changeKg.isEmpty) return '-';
    final numVal = double.tryParse(changeKg);
    if (numVal != null && numVal > 0 && !changeKg.startsWith('+')) {
      return '+$changeKg kg';
    }
    return '$changeKg kg';
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

      return RefreshIndicator(
        onRefresh: () => homeController.fetchHomeData(force: true),
        color: AppColors.brandTeal,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardHeader(headerData: homeData?.header),
              const SizedBox(height: 16),
              MomentumCard(momentumData: homeData?.momentum),
              const SizedBox(height: 16),

              // Today's Priority / AI Daily Brief Widget
              AIDailyBriefCard(
                priorityData: homeData?.todayPriority,
                dailyBriefData: homeData?.dailyBrief,
                onScanCompleteTap: goInsight,
              ),
              const SizedBox(height: 16),

              // Weekly Scan Widget
              WeeklyScanCard(weeklyScanData: homeData?.weeklyScan),
              if (homeData?.weeklyScan?.visible == true)
                const SizedBox(height: 16),

              // Current Weight & Weekly Change Row
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
                        child: const SparklineChart(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LatestCheckInCard(analysisData: homeData?.latestAnalysis),
              const SizedBox(height: 16),
              AiInsightCard(
                goInsightPage: goInsight,
                aiInsightData: homeData?.aiInsight,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      );
    });
  }
}
