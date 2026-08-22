import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_images.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';

class InsightPostureComparison extends StatelessWidget {
  const InsightPostureComparison({
    super.key,
    required this.beforeLabel,
    required this.afterLabel,
    this.beforeImageUrl,
    this.beforeThumbUrl,
    this.afterImageUrl,
    this.afterThumbUrl,
    this.onRefreshRequested,
  });

  final String beforeLabel;
  final String afterLabel;
  final String? beforeImageUrl;
  final String? beforeThumbUrl;
  final String? afterImageUrl;
  final String? afterThumbUrl;
  final VoidCallback? onRefreshRequested;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ComparisonCard(
            label: beforeLabel,
            imageUrl: beforeImageUrl,
            thumbUrl: beforeThumbUrl,
            onRefreshRequested: onRefreshRequested,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: AppIcon(
            icon: AppIcons.arrowUpRight,
            size: 20,
            color: AppColors.brandTealDark,
          ),
        ),
        Expanded(
          child: _ComparisonCard(
            label: afterLabel,
            imageUrl: afterImageUrl,
            thumbUrl: afterThumbUrl,
            onRefreshRequested: onRefreshRequested,
          ),
        ),
      ],
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard({
    required this.label,
    this.imageUrl,
    this.thumbUrl,
    this.onRefreshRequested,
  });

  final String label;
  final String? imageUrl;
  final String? thumbUrl;
  final VoidCallback? onRefreshRequested;

  @override
  Widget build(BuildContext context) {
    // Prefer imageUrl for full posture detail display, fallback to thumbUrl
    final primaryUrl = (imageUrl?.isNotEmpty ?? false)
        ? imageUrl
        : ((thumbUrl?.isNotEmpty ?? false) ? thumbUrl : null);

    final fallbackUrl =
        (imageUrl?.isNotEmpty ?? false) && (thumbUrl?.isNotEmpty ?? false)
        ? thumbUrl
        : null;

    return Column(
      children: [
        GestureDetector(
          onTap: primaryUrl != null ? onRefreshRequested : null,
          child: Container(
            height: 180,
            width: 96,
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
                  ? Image.network(
                      primaryUrl,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.brandTeal,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint('S3 Image load error ($primaryUrl): $error');
                        if (fallbackUrl != null) {
                          return Image.network(
                            fallbackUrl,
                            fit: BoxFit.contain,
                            width: double.infinity,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.brandTeal,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              debugPrint(
                                'S3 Fallback Image error ($fallbackUrl): $error',
                              );
                              return _buildFallbackImage();
                            },
                          );
                        }
                        return _buildFallbackImage();
                      },
                    )
                  : _buildFallbackImage(),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: AppFonts.family,
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildFallbackImage() {
    return Image.asset(
      AppImages.frontView,
      fit: BoxFit.contain,
      width: double.infinity,
    );
  }
}

enum InsightStatusTone { positive, warning, neutral }

class InsightStatusList extends StatelessWidget {
  const InsightStatusList({super.key, required this.items});

  final List<InsightStatusItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: AppColors.cardBorder),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      items[i].label,
                      style: AppTextStyles.featureTitle.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    items[i].status,
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _toneColor(items[i].tone),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _toneColor(InsightStatusTone tone) => switch (tone) {
    InsightStatusTone.positive => AppColors.brandTealDark,
    InsightStatusTone.warning => AppColors.insightWarning,
    InsightStatusTone.neutral => AppColors.textSecondary,
  };
}

class InsightStatusItem {
  const InsightStatusItem({
    required this.label,
    required this.status,
    required this.tone,
  });

  final String label;
  final String status;
  final InsightStatusTone tone;
}
