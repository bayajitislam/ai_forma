import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/profile/constants/profile_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GenderSelectionSheet extends StatefulWidget {
  final String? initialGender;
  final ValueChanged<String> onGenderSelected;

  const GenderSelectionSheet({
    super.key,
    this.initialGender,
    required this.onGenderSelected,
  });

  static void show(
    BuildContext context, {
    required String? initialGender,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => GenderSelectionSheet(
        initialGender: initialGender,
        onGenderSelected: onSelected,
      ),
    );
  }

  @override
  State<GenderSelectionSheet> createState() => _GenderSelectionSheetState();
}

class _GenderSelectionSheetState extends State<GenderSelectionSheet> {
  late String _tempGender;

  @override
  void initState() {
    super.initState();
    _tempGender = widget.initialGender ?? 'male';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            ProfileStrings.selectGenderTitle,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text(
              ProfileStrings.genderMale,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: _tempGender == 'male'
                ? const Icon(Icons.check_circle, color: AppColors.brandTeal)
                : null,
            onTap: () => setState(() => _tempGender = 'male'),
          ),
          ListTile(
            title: const Text(
              ProfileStrings.genderFemale,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: _tempGender == 'female'
                ? const Icon(Icons.check_circle, color: AppColors.brandTeal)
                : null,
            onTap: () => setState(() => _tempGender = 'female'),
          ),
          ListTile(
            title: const Text(
              ProfileStrings.genderPreferNotToSay,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: _tempGender == 'prefer_not_to_say'
                ? const Icon(Icons.check_circle, color: AppColors.brandTeal)
                : null,
            onTap: () => setState(() => _tempGender = 'prefer_not_to_say'),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            onPressed: () {
              widget.onGenderSelected(_tempGender);
              Get.back();
            },
            label: ProfileStrings.save,
          ),
        ],
      ),
    );
  }
}
