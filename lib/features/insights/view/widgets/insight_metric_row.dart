import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:remixicon/remixicon.dart';

enum InsightStatusType { positive, warning }

class InsightMetricRow extends StatelessWidget {
  const InsightMetricRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.statusType,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String status;
  final InsightStatusType statusType;
  final VoidCallback? onTap;

  /// Derives color from the status string first, then falls back to statusType.
  Color get _accentColor {
    final s = status.toLowerCase();
    if (s.contains('attention') ||
        s.contains('warning') ||
        s.contains('negative') ||
        s.contains('imbalance')) {
      return AppColors.insightWarning;
    }
    if (s.contains('good') ||
        s.contains('excellent') ||
        s.contains('on track') ||
        s.contains('positive') ||
        s.contains('balanced')) {
      return AppColors.brandTeal;
    }
    return statusType == InsightStatusType.warning
        ? AppColors.insightWarning
        : AppColors.brandTeal;
  }

  /// Uses passed icon by default, but switches to alert icon when status is warning/needs attention.
  IconData get _resolvedIcon {
    final s = status.toLowerCase();
    if (s.contains('attention') ||
        s.contains('warning') ||
        s.contains('imbalance') ||
        statusType == InsightStatusType.warning) {
      return Remix.alert_line;
    }
    return icon;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            AppIcon(icon: _resolvedIcon, size: 22, color: _accentColor),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.featureTitle.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppTextStyles.featureDescription),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              status,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
