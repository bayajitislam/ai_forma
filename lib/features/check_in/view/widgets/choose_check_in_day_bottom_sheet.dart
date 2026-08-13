import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';

class ChooseCheckInDayBottomSheet extends StatefulWidget {
  final String currentDay;
  final ValueChanged<String> onSaved;

  const ChooseCheckInDayBottomSheet({
    super.key,
    required this.currentDay,
    required this.onSaved,
  });

  static Future<void> show(
    BuildContext context, {
    required String currentDay,
    required ValueChanged<String> onSaved,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => ChooseCheckInDayBottomSheet(
        currentDay: currentDay,
        onSaved: onSaved,
      ),
    );
  }

  @override
  State<ChooseCheckInDayBottomSheet> createState() =>
      _ChooseCheckInDayBottomSheetState();
}

class _ChooseCheckInDayBottomSheetState
    extends State<ChooseCheckInDayBottomSheet> {
  late String _selectedDay;

  final List<String> _days = const [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.currentDay;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Choose your check-in day',
            style: AppTextStyles.authSectionTitle,
          ),
          const SizedBox(height: 6),
          const Text(
            'Select the day you prefer to complete your weekly body scan.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 20),

          // Days List
          ..._days.map((day) {
            final isSelected = _selectedDay.toLowerCase() == day.toLowerCase();
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedDay = day;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFE8F7F6)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            isSelected ? AppColors.brandTeal : AppColors.border,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          day,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected
                                ? AppColors.brandTeal
                                : AppColors.textPrimary,
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.brandTeal,
                            size: 20,
                          )
                        else
                          const Icon(
                            Icons.circle_outlined,
                            color: AppColors.border,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 16),

          PrimaryButton(
            onPressed: () {
              widget.onSaved(_selectedDay);
              Navigator.of(context).pop();
            },
            label: 'SAVE',
          ),
        ],
      ),
    );
  }
}
