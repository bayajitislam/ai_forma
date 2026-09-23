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
    this.analysis,
    this.analysisHeadings,
  });

  final String? analysis;
  final List<String>? analysisHeadings;

  static const double _headerIconSize = 24;
  static const double _headerIconInner = 14;
  static const double _headerTitleSize = 17;
  static const double _headerGap = 8;
  static const double _headerToCardGap = 14;
  static const double _cardRadius = 16;
  static const double _cardPadding = 20;
  static const double _paragraphGap = 12;

  @override
  Widget build(BuildContext context) {
    final hasAnalysis = analysis != null && analysis!.trim().isNotEmpty;
    final headings = analysisHeadings ?? const <String>[];
    final hasHeadings = headings.isNotEmpty;

    if (!hasAnalysis && !hasHeadings) {
      return const SizedBox.shrink();
    }

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
          child: hasAnalysis
              ? _NarrativeContent(
                  text: analysis!.trim(),
                  gap: _paragraphGap,
                )
              : _LockedHeadingsPreview(headings: headings),
        ),
      ],
    );
  }
}

class _NarrativeContent extends StatelessWidget {
  const _NarrativeContent({
    required this.text,
    required this.gap,
  });

  final String text;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final paragraphs = text
        .split(RegExp(r'\n\s*\n'))
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    if (paragraphs.isEmpty) {
      return Text(
        text,
        style: const TextStyle(
          fontFamily: AppFonts.family,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.insightAnalysisBody,
          height: 1.55,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < paragraphs.length; i++) ...[
          if (i > 0) SizedBox(height: gap),
          Text(
            paragraphs[i],
            style: const TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.insightAnalysisBody,
              height: 1.55,
            ),
          ),
        ],
      ],
    );
  }
}

class _LockedHeadingsPreview extends StatelessWidget {
  const _LockedHeadingsPreview({required this.headings});

  final List<String> headings;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final heading in headings) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2.0, right: 8.0),
                  child: AppIcon(
                    icon: AppIcons.lock,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                Expanded(
                  child: Text(
                    heading,
                    style: const TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 8),
        Text(
          InsightsStrings.analysisPreviewLocked,
          style: const TextStyle(
            fontFamily: AppFonts.family,
            fontSize: 12,
            fontStyle: FontStyle.italic,
            color: AppColors.textSecondary,
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
