import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:flutter_svg/svg.dart';

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.label,
    this.value,
    this.trendText,
    this.caption,
    this.child,
    this.height = 144,
  });

  final String label;
  final String? value;
  final String? trendText;
  final String? caption;
  final Widget? child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.dashboardMetricLabel),
          if (value != null) ...[
            const SizedBox(height: 8),
            Text(value!, style: AppTextStyles.dashboardMetricValue),
          ],
          if (trendText != null) ...[
            SizedBox(height: value != null ? 8 : 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppIcons.downTrendSvg,
                  width: 9,
                  height: 9,
                  colorFilter: const ColorFilter.mode(
                    AppColors.brandTeal,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    trendText!,
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0,
                      color: AppColors.brandTeal,
                    ),
                  ),
                ),
              ],
            ),
          ],

          if (child != null) ...[const SizedBox(height: 12), child!],

          if (caption != null) ...[
            const SizedBox(height: 4),
            Text(
              caption!,
              style: const TextStyle(
                fontFamily: AppFonts.family,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
