import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/check_in/constants/check_in_strings.dart';
import 'package:ai_forma/features/check_in/view/pages/check_in_intro_view.dart';
import 'package:ai_forma/features/check_in/view/widgets/check_in_streak_card.dart';
import 'package:ai_forma/features/dashboard/view/widgets/metric_card.dart';

class CheckInHomeView extends StatelessWidget {
  const CheckInHomeView({super.key});

  void _beginScan(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const CheckInIntroView()));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CheckInStreakCard(),
          const SizedBox(height: 16),
          Row(
            children: const [
              CheckInStatCard(
                icon: AppIcons.checkCircle,
                value: '12',
                label: CheckInStrings.statTotal,
              ),
              SizedBox(width: 10),
              CheckInStatCard(
                icon: AppIcons.time,
                value: '92%',
                label: CheckInStrings.statOnTime,
              ),
              SizedBox(width: 10),
              CheckInStatCard(
                icon: AppIcons.calendar,
                value: CheckInStrings.checkDayValue,
                label: CheckInStrings.statCheckDay,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: MetricCard(
                  height: 118,
                  label: CheckInStrings.currentWeight,
                  value: CheckInStrings.currentWeightValue,
                  trendText: CheckInStrings.weightChange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: _LatestScanCard()),
            ],
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            onPressed: () => _beginScan(context),
            label: CheckInStrings.beginNewScan,
          ),
          const SizedBox(height: 16),
          const _CheckInInsightCard(),
        ],
      ),
    );
  }
}

class _LatestScanCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 118,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            CheckInStrings.latestScan,
            style: AppTextStyles.dashboardMetricLabel,
          ),
          const SizedBox(height: 6),
          Text(
            CheckInStrings.latestScanDate,
            style: AppTextStyles.dashboardMetricValue.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Icon(
                    AppIcons.user,
                    size: 28,
                    color: AppColors.darkCardText,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Icon(
                    AppIcons.user,
                    size: 28,
                    color: AppColors.darkCardText,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CheckInInsightCard extends StatelessWidget {
  const _CheckInInsightCard();

  static const Color _cardBackground = Color(0xFF081012);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const RadialGradient(
          center: Alignment(1.15, 1.25),
          radius: 0.75,
          colors: [Color(0xFF0F3D3A), _cardBackground],
          stops: [0.0, 0.7],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  CheckInStrings.latestInsight,
                  style: AppTextStyles.dashboardSectionLabel.copyWith(
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  CheckInStrings.latestInsightBody,
                  style: const TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColors.onPrimary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      CheckInStrings.viewInsight,
                      style: const TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const AppIcon(
                      icon: AppIcons.arrowRight,
                      size: 16,
                      color: AppColors.onPrimary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          AppIcon(
            icon: AppIcons.user,
            size: 72,
            color: AppColors.brandTeal.withValues(alpha: 0.35),
          ),
        ],
      ),
    );
  }
}
