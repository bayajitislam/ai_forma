import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/dashboard/controllers/daily_brief_controller.dart';

class AnswerDailyBriefBottomSheet extends StatefulWidget {
  final SleepQuality? initialSelection;
  final ValueChanged<SleepQuality> onSaved;

  const AnswerDailyBriefBottomSheet({
    super.key,
    this.initialSelection,
    required this.onSaved,
  });

  static Future<void> show(
    BuildContext context, {
    SleepQuality? initialSelection,
    required ValueChanged<SleepQuality> onSaved,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AnswerDailyBriefBottomSheet(
        initialSelection: initialSelection,
        onSaved: onSaved,
      ),
    );
  }

  @override
  State<AnswerDailyBriefBottomSheet> createState() =>
      _AnswerDailyBriefBottomSheetState();
}

class _AnswerDailyBriefBottomSheetState
    extends State<AnswerDailyBriefBottomSheet> {
  SleepQuality? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSelection ?? SleepQuality.good;
  }

  @override
  Widget build(BuildContext context) {
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
            children: const [
              Icon(
                Icons.auto_awesome,
                size: 14,
                color: AppColors.brandTeal,
              ),
              SizedBox(width: 6),
              Text(
                'AI DAILY BRIEF',
                style: TextStyle(
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
          const Text(
            'How did you sleep most nights this week?',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 6),

          // Subtitle
          const Text(
            'This helps AiFORMA understand your recovery and overall performance.',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 24),

          // Option Cards Grid/Row
          Row(
            children: [
              _buildOptionCard(
                quality: SleepQuality.excellent,
                icon: Icons.nightlight_round_outlined,
                title: 'Excellent',
                subtitle: '8+ hours,\nvery restful',
              ),
              const SizedBox(width: 8),
              _buildOptionCard(
                quality: SleepQuality.good,
                icon: Icons.sentiment_satisfied_alt,
                title: 'Good',
                subtitle: '6–8 hours,\nrested',
              ),
              const SizedBox(width: 8),
              _buildOptionCard(
                quality: SleepQuality.average,
                icon: Icons.sentiment_neutral,
                title: 'Average',
                subtitle: '5–6 hours,\nokay',
              ),
              const SizedBox(width: 8),
              _buildOptionCard(
                quality: SleepQuality.poor,
                icon: Icons.sentiment_dissatisfied,
                title: 'Poor',
                subtitle: 'Less than 5\nhours',
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Save Button
          PrimaryButton(
            onPressed: () {
              if (_selected != null) {
                widget.onSaved(_selected!);
              }
              Navigator.pop(context);
            },
            label: 'Save response',
          ),
          const SizedBox(height: 16),

          // Footer Lock Info
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.lock_outline,
                size: 14,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Your response is private and used only to improve your next scan analysis.',
                  style: TextStyle(
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
    required SleepQuality quality,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selected == quality;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selected = quality;
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
                title,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColors.textPrimary : AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
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
      ),
    );
  }
}
