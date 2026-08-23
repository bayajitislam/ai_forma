import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/app_loader.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/dashboard/models/home_response_model.dart';

class AnswerDailyBriefBottomSheet extends StatefulWidget {
  final HomeDailyBriefModel? dailyBriefData;
  final Future<void> Function(String questionKey, String selectedValue) onSavedOption;

  const AnswerDailyBriefBottomSheet({
    super.key,
    this.dailyBriefData,
    required this.onSavedOption,
  });

  static Future<void> show(
    BuildContext context, {
    HomeDailyBriefModel? dailyBriefData,
    required Future<void> Function(String questionKey, String selectedValue) onSavedOption,
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
  bool _isSubmitting = false;

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

    return const [];
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

  Future<void> _handleSave() async {
    final questionKey = widget.dailyBriefData?.questionKey ??
        widget.dailyBriefData?.step?['key']?.toString();

    if (questionKey == null || _selectedOptionValue == null || _isSubmitting) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await widget.onSavedOption(questionKey, _selectedOptionValue!);
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.dailyBriefData?.step;
    final headingText = step?['heading']?.toString() ??
        widget.dailyBriefData?.heading ??
        '';

    final titleText = step?['title']?.toString() ??
        widget.dailyBriefData?.title ??
        '';

    final subtitleText = step?['subtitle']?.toString() ??
        widget.dailyBriefData?.subtitle ??
        '';

    final ctaLabelText = step?['cta_label']?.toString() ??
        widget.dailyBriefData?.ctaLabel ??
        'Save response';

    final privacyNoteText = step?['privacy_note']?.toString() ?? '';

    final options = _getStepOptions();

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
                onTap: _isSubmitting ? null : () => Navigator.pop(context),
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
          if (headingText.isNotEmpty) ...[
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
          ],

          // Title
          if (titleText.isNotEmpty) ...[
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
          ],

          // Subtitle
          if (subtitleText.isNotEmpty) ...[
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
          ],

          // Dynamic Option Cards Grid/Row
          if (options.isNotEmpty)
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

          // Save Button with Loading State
          _isSubmitting
              ? Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.brandTeal.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: const Center(
                    child: AppLoader(
                      size: 24,
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  ),
                )
              : PrimaryButton(
                  onPressed: _selectedOptionValue != null ? _handleSave : null,
                  label: ctaLabelText,
                ),
          const SizedBox(height: 16),

          // Footer Lock Info
          if (privacyNoteText.isNotEmpty) ...[
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
      onTap: _isSubmitting
          ? null
          : () {
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
            if (description.isNotEmpty) ...[
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
          ],
        ),
      ),
    );
  }
}
