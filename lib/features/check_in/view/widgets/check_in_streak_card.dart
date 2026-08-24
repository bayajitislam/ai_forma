import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/features/check_in/constants/check_in_strings.dart';

import 'package:ai_forma/features/check_in/models/checkin_status_model.dart';
import 'package:ai_forma/features/insights/view/pages/consistency_view.dart';

class CheckInStreakCard extends StatefulWidget {
  final VoidCallback? onTap;
  final int streakWeeks;
  final int personalBest;
  final List<StreakCycleModel>? streakHistory;

  const CheckInStreakCard({
    super.key,
    this.onTap,
    this.streakWeeks = 12,
    this.personalBest = 12,
    this.streakHistory,
  });

  static const Color _cardBackground = Color(0xFF081012);
  static const Color _tileBackground = Color(0xFF0F1A1C);
  static const Color _mutedText = Color(0xFF6B7F7F);

  @override
  State<CheckInStreakCard> createState() => _CheckInStreakCardState();
}

class _CheckInStreakCardState extends State<CheckInStreakCard> {
  bool _isPressed = false;

  void _handleTap() {
    if (widget.onTap != null) {
      widget.onTap!();
    } else {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const ConsistencyView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: _handleTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: AnimatedOpacity(
          opacity: _isPressed ? 0.9 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const RadialGradient(
                center: Alignment(0.9, -0.6),
                radius: 1.1,
                colors: [
                  Color(0xFF0F2E2C),
                  CheckInStreakCard._cardBackground,
                ],
                stops: [0.0, 0.65],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: CheckInStreakCard._tileBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: AppIcon(
                          icon: AppIcons.fire,
                          size: 22,
                          color: AppColors.brandTeal,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.streakWeeks}',
                          style: const TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onPrimary,
                            height: 1.1,
                          ),
                        ),
                        Text(
                          CheckInStrings.weekStreak,
                          style: AppTextStyles.authBody.copyWith(
                            fontSize: 13,
                            color: CheckInStreakCard._mutedText,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          CheckInStrings.personalBest,
                          style: AppTextStyles.authBody.copyWith(
                            fontSize: 11,
                            color: CheckInStreakCard._mutedText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              CheckInStrings.keepItUp,
                              style: AppTextStyles.featureTitle.copyWith(
                                color: AppColors.onPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.chevron_right,
                              size: 18,
                              color: AppColors.brandTeal,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(
                      widget.streakHistory != null && widget.streakHistory!.isNotEmpty
                          ? widget.streakHistory!.length
                          : 12,
                      (index) {
                        final isComp = widget.streakHistory != null && index < widget.streakHistory!.length
                            ? widget.streakHistory![index].isCompleted
                            : true;

                        return Container(
                          width: 34,
                          height: 38,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: isComp
                                ? AppColors.brandTeal.withValues(alpha: 0.1)
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: isComp
                                ? Container(
                                    width: 18,
                                    height: 18,
                                    decoration: const BoxDecoration(
                                      color: AppColors.brandTeal,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const AppIcon(
                                      icon: AppIcons.check,
                                      size: 11,
                                      color: AppColors.onPrimary,
                                    ),
                                  )
                                : const Icon(
                                    Icons.circle_outlined,
                                    size: 14,
                                    color: AppColors.textSecondary,
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CheckInStatCard extends StatelessWidget {
  const CheckInStatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.onTap,
    this.showChevron = false,
  });

  final IconData icon;
  final String value;
  final String label;
  final VoidCallback? onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final cardWidget = Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIcon(icon: icon, size: 18, color: AppColors.brandTeal),
              if (showChevron) ...[
                const SizedBox(width: 2),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 14,
                  color: AppColors.brandTeal,
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.dashboardMetricValue.copyWith(fontSize: 16),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.dashboardMetricLabel.copyWith(fontSize: 11),
          ),
        ],
      ),
    );

    return Expanded(
      child: onTap != null
          ? Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(12),
                child: cardWidget,
              ),
            )
          : cardWidget,
    );
  }
}
