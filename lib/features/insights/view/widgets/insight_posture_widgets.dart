import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/constants/app_images.dart';
import 'package:ai_forma/core/widgets/app_cached_image.dart';
import 'package:ai_forma/features/insights/models/posture_detail_model.dart';

class InsightPostureSummaryCard extends StatelessWidget {
  const InsightPostureSummaryCard({
    super.key,
    required this.score,
    required this.status,
    required this.statusTone,
    required this.summaryText,
  });

  final int score;
  final String status;
  final String statusTone;
  final String summaryText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.insightAnalysisBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.insightAnalysisCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Posture Rating',
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    status.isNotEmpty ? status : 'Good Alignment',
                    style: const TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.insightAnalysisTitle,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.insightBadgePositiveBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$score / 100',
                  style: const TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.brandTealDark,
                  ),
                ),
              ),
            ],
          ),
          if (summaryText.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(color: AppColors.insightAnalysisDivider, height: 1),
            const SizedBox(height: 12),
            Text(
              summaryText,
              style: const TextStyle(
                fontFamily: AppFonts.family,
                fontSize: 13,
                height: 1.4,
                color: AppColors.insightAnalysisBody,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class InsightPostureComparison extends StatelessWidget {
  const InsightPostureComparison({
    super.key,
    this.comparison,
    this.onRefreshRequested,
  });

  final PostureComparisonModel? comparison;
  final VoidCallback? onRefreshRequested;

  @override
  Widget build(BuildContext context) {
    final beforeScan = comparison?.before;
    final afterScan = comparison?.after;

    if (beforeScan == null && afterScan != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ComparisonCard(
            title: 'Current Scan',
            date: afterScan.scanDate,
            imageUrl: afterScan.imageUrl,
            thumbUrl: afterScan.thumbUrl,
            onTap: onRefreshRequested,
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.brandTeal.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.brandTeal.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.brandTeal,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Baseline Captured. Comparative before & after posture analysis will unlock after your 2nd check-in.',
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary.withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: _ComparisonCard(
            title: 'Before',
            date: beforeScan?.scanDate ?? 'Scan 1',
            imageUrl: beforeScan?.imageUrl,
            thumbUrl: beforeScan?.thumbUrl,
            onTap: onRefreshRequested,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ComparisonCard(
            title: 'After',
            date: afterScan?.scanDate ?? 'Scan 2',
            imageUrl: afterScan?.imageUrl,
            thumbUrl: afterScan?.thumbUrl,
            onTap: onRefreshRequested,
          ),
        ),
      ],
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard({
    required this.title,
    required this.date,
    this.imageUrl,
    this.thumbUrl,
    this.onTap,
  });

  final String title;
  final String date;
  final String? imageUrl;
  final String? thumbUrl;
  final VoidCallback? onTap;

  Widget _buildFallbackImage() {
    return Image.asset(
      AppImages.sideView,
      fit: BoxFit.cover,
      width: double.infinity,
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryUrl = (imageUrl?.isNotEmpty ?? false)
        ? imageUrl
        : ((thumbUrl?.isNotEmpty ?? false) ? thumbUrl : null);

    return GestureDetector(
      onTap: primaryUrl != null ? onTap : null,
      child: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.insightChartBackground,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cardBorder),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: primaryUrl != null
                  ? AppCachedNetworkImage(
                      imageUrl: primaryUrl,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      errorWidget: _buildFallbackImage(),
                    )
                  : _buildFallbackImage(),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.insightAnalysisTitle,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            date,
            style: const TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class InsightPostureMetricsList extends StatelessWidget {
  const InsightPostureMetricsList({
    super.key,
    this.alignment,
  });

  final PostureAlignmentModel? alignment;

  @override
  Widget build(BuildContext context) {
    final items = [
      _MetricItem(
        label: 'Head Position',
        value: alignment?.headPosition?.label ?? 'Neutral',
      ),
      _MetricItem(
        label: 'Shoulder Balance',
        value: alignment?.shoulderPosition?.label ?? 'Balanced',
      ),
      _MetricItem(
        label: 'Spinal Alignment',
        value: alignment?.spinalPosition?.label ?? 'Normal Curve',
      ),
      _MetricItem(
        label: 'Pelvic Tilt',
        value: alignment?.pelvicTilt?.label ?? 'Neutral',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Alignment Key Metrics',
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.insightAnalysisTitle,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => _buildRow(item.label, item.value)),
      ],
    );
  }

  Widget _buildRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.cardBorder.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.insightAnalysisTitle,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricItem {
  final String label;
  final String value;

  _MetricItem({required this.label, required this.value});
}
