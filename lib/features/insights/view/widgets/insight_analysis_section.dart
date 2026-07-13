import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/features/insights/constants/insights_strings.dart';

class InsightAnalysisSection extends StatelessWidget {
  const InsightAnalysisSection({
    super.key,
    required this.detected,
    required this.why,
    required this.nextSteps,
  });

  final String detected;
  final String why;
  final String nextSteps;

  static const double _headerIconSize = 24;
  static const double _headerIconInner = 14;
  static const double _headerTitleSize = 17;
  static const double _headerGap = 8;
  static const double _headerToCardGap = 14;
  static const double _cardRadius = 16;
  static const double _cardPadding = 20;
  static const double _dividerSpacing = 16;
  static const double _titleBodyGap = 6;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: _headerIconSize,
              height: _headerIconSize,
              decoration: const BoxDecoration(
                color: AppColors.insightAnalysisIconBg,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: AppIcon(
                  icon: AppIcons.pulse,
                  size: _headerIconInner,
                  color: AppColors.surface,
                ),
              ),
            ),
            const SizedBox(width: _headerGap),
            Text(
              InsightsStrings.aiFormaAnalysis,
              style: const TextStyle(
                fontFamily: AppFonts.family,
                fontSize: _headerTitleSize,
                fontWeight: FontWeight.w700,
                color: AppColors.insightAnalysisTitle,
                height: 1.2,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: _headerToCardGap),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(_cardPadding),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(_cardRadius),
            border: Border.all(color: AppColors.insightAnalysisCardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AnalysisBlock(
                title: InsightsStrings.whatAiFormaDetected,
                body: detected,
                titleBodyGap: _titleBodyGap,
              ),
              const _SectionDivider(spacing: _dividerSpacing),
              _AnalysisBlock(
                title: InsightsStrings.whyYoureSeeingThis,
                body: why,
                titleBodyGap: _titleBodyGap,
              ),
              const _SectionDivider(spacing: _dividerSpacing),
              _AnalysisBlock(
                title: InsightsStrings.recommendedNextSteps,
                body: nextSteps,
                titleBodyGap: _titleBodyGap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider({required this.spacing});

  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing),
      child: const Divider(
        height: 1,
        thickness: 1,
        color: AppColors.insightAnalysisDivider,
      ),
    );
  }
}

class _AnalysisBlock extends StatelessWidget {
  const _AnalysisBlock({
    required this.title,
    required this.body,
    required this.titleBodyGap,
  });

  final String title;
  final String body;
  final double titleBodyGap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: AppFonts.family,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.brandTealDark,
            height: 1.3,
          ),
        ),
        SizedBox(height: titleBodyGap),
        Text(
          body,
          style: const TextStyle(
            fontFamily: AppFonts.family,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.insightAnalysisBody,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class InsightPrioritiesCard extends StatelessWidget {
  const InsightPrioritiesCard({
    super.key,
    required this.priorities,
  });

  final List<String> priorities;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.insightPrioritiesBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            InsightsStrings.thisWeeksPriorities,
            style: const TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.brandTealDark,
            ),
          ),
          const SizedBox(height: 14),
          for (var i = 0; i < priorities.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            _PriorityItem(text: priorities[i]),
          ],
        ],
      ),
    );
  }
}

class _PriorityItem extends StatelessWidget {
  const _PriorityItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppIcon(
          icon: AppIcons.checkCircle,
          size: 18,
          color: AppColors.brandTealDark,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.featureDescription.copyWith(height: 1.4),
          ),
        ),
      ],
    );
  }
}
