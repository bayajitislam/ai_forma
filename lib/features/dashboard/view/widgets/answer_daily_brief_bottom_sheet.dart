import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/dashboard/models/home_response_model.dart';

class AnswerDailyBriefBottomSheet extends StatefulWidget {
  final HomeDailyBriefModel? dailyBriefData;
  final Function(String questionKey, String selectedValue) onSavedOption;

  const AnswerDailyBriefBottomSheet({
    super.key,
    this.dailyBriefData,
    required this.onSavedOption,
  });

  static Future<void> show(
    BuildContext context, {
    HomeDailyBriefModel? dailyBriefData,
    required Function(String questionKey, String selectedValue) onSavedOption,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AnswerDailyBriefBottomSheet(
        dailyBriefData: dailyBriefData,
        onSavedOption: onSavedOption,
      ),
    );
  }

  @override
  State<AnswerDailyBriefBottomSheet> createState() =>
      _AnswerDailyBriefBottomSheetState();
}

class _AnswerDailyBriefBottomSheetState
    extends State<AnswerDailyBriefBottomSheet> {
  String? _selectedOptionValue;

  @override
  void initState() {
    super.initState();
    final prefilled = widget.dailyBriefData?.previousWeekOption;
    final options = _getStepOptions();
    if (prefilled != null && prefilled.isNotEmpty) {
      _selectedOptionValue = prefilled;
    } else if (options.isNotEmpty) {
      _selectedOptionValue = options.first['value']?.toString();
    }
  }

  List<Map<String, dynamic>> _getStepOptions() {
    final step = widget.dailyBriefData?.step;
    if (step != null && step['options'] is List) {
      return (step['options'] as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    }

    // Default sleep options fallback
    return const [
      {
        'value': 'excellent',
        'label': 'Excellent',
        'description': '8+ hours,\nvery restful',
        'icon': 'excellent',
      },
      {
        'value': 'good',
        'label': 'Good',
        'description': '6–8 hours,\nrested',
        'icon': 'good',
      },
      {
        'value': 'average',
        'label': 'Average',
        'description': '5–6 hours,\nokay',
        'icon': 'average',
      },
      {
        'value': 'poor',
        'label': 'Poor',
        'description': 'Less than 5\nhours',
        'icon': 'poor',
      },
    ];
  }

  IconData _getIconData(String? iconStr, int index) {
    if (iconStr != null) {
      final lower = iconStr.toLowerCase();
      if (lower.contains('excellent')) return Icons.sentiment_very_satisfied;
      if (lower.contains('good')) return Icons.sentiment_satisfied_alt;
      if (lower.contains('average')) return Icons.sentiment_neutral;
      if (lower.contains('poor') || lower.contains('low')) {
        return Icons.sentiment_dissatisfied;
      }
    }
    switch (index) {
      case 0:
        return Icons.sentiment_very_satisfied;
      case 1:
        return Icons.sentiment_satisfied_alt;
      case 2:
        return Icons.sentiment_neutral;
      default:
        return Icons.sentiment_dissatisfied;
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.dailyBriefData?.step;
    final headingText = step?['heading']?.toString() ??
        widget.dailyBriefData?.heading ??
        'AI DAILY BRIEF';

    final titleText = step?['title']?.toString() ??
        widget.dailyBriefData?.title ??
        'How did you sleep most nights this week?';

    final subtitleText = step?['subtitle']?.toString() ??
        widget.dailyBriefData?.subtitle ??
        'This helps AiFORMA understand your recovery and overall performance.';

    final ctaLabelText = step?['cta_label']?.toString() ??
        widget.dailyBriefData?.ctaLabel ??
        'Save response';

    final privacyNoteText = step?['privacy_note']?.toString() ??
        'Your response is private and used only to improve your next scan analysis.';

    final options = _getStepOptions();
    final questionKey = widget.dailyBriefData?.questionKey ??
        step?['key']?.toString() ??
        'sleep';

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle & Close button row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 32),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Sub-header badge
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                size: 14,
                color: AppColors.brandTeal,
              ),
              const SizedBox(width: 6),
              Text(
                headingText,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: AppColors.brandTeal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Title
          Text(
            titleText,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 6),

          // Subtitle
          Text(
            subtitleText,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 24),

          // Dynamic Option Cards Grid/Row
          Row(
            children: List.generate(options.length, (index) {
              final opt = options[index];
              final value = opt['value']?.toString() ?? '';
              final label = opt['label']?.toString() ?? '';
              final desc = opt['description']?.toString() ?? '';
              final iconStr = opt['icon']?.toString();
              final isLast = index == options.length - 1;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: isLast ? 0 : 8),
                  child: _buildOptionCard(
                    value: value,
                    label: label,
                    description: desc,
                    icon: _getIconData(iconStr, index),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 28),

          // Save Button
          PrimaryButton(
            onPressed: () {
              if (_selectedOptionValue != null) {
                widget.onSavedOption(questionKey, _selectedOptionValue!);
              }
              Navigator.pop(context);
            },
            label: ctaLabelText,
          ),
          const SizedBox(height: 16),

          // Footer Lock Info
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_outline,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  privacyNoteText,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required String value,
    required String label,
    required String description,
    required IconData icon,
  }) {
    final isSelected = _selectedOptionValue == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOptionValue = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEBF7F6) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.brandTeal : AppColors.cardBorder,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.brandTeal.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected ? AppColors.brandTeal : AppColors.textSecondary,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 10,
                color: isSelected ? AppColors.brandTeal : AppColors.textSecondary,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
