import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/features/auth/constants/auth_strings.dart';

class PasswordRequirements extends StatelessWidget {
  const PasswordRequirements({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AuthStrings.passwordRequirementsTitle,
          style: AppTextStyles.requirementTitle,
        ),
        const SizedBox(height: 8),
        const _RequirementItem(label: AuthStrings.requirementMinLength),
        const SizedBox(height: 6),
        const _RequirementItem(label: AuthStrings.requirementNumber),
        const SizedBox(height: 6),
        const _RequirementItem(label: AuthStrings.requirementUppercase),
        const SizedBox(height: 6),
        const _RequirementItem(label: AuthStrings.requirementSpecial),
      ],
    );
  }
}

class _RequirementItem extends StatelessWidget {
  const _RequirementItem({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const AppIcon(icon: AppIcons.checkCircle, size: 18),
        const SizedBox(width: 8),
        Text(label, style: AppTextStyles.requirementLabel),
      ],
    );
  }
}
