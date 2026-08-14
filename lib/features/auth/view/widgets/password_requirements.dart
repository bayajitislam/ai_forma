import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/features/auth/constants/auth_strings.dart';
import 'package:ai_forma/features/auth/controllers/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordRequirements extends GetView<SignupController> {
  const PasswordRequirements({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AuthStrings.passwordRequirementsTitle,
            style: AppTextStyles.requirementTitle,
          ),
          const SizedBox(height: 8),
          _RequirementItem(
            label: AuthStrings.requirementMinLength,
            met: controller.hasMinLength.value,
          ),
          const SizedBox(height: 6),
          _RequirementItem(
            label: AuthStrings.requirementNumber,
            met: controller.hasNumber.value,
          ),
          const SizedBox(height: 6),
          _RequirementItem(
            label: AuthStrings.requirementUppercase,
            met: controller.hasUppercase.value,
          ),
          const SizedBox(height: 6),
          _RequirementItem(
            label: AuthStrings.requirementSpecial,
            met: controller.hasSpecial.value,
          ),
        ],
      ),
    );
  }
}

class _RequirementItem extends StatelessWidget {
  const _RequirementItem({required this.label, required this.met});

  final String label;
  final bool met;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Row(
        key: ValueKey(met),
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: met ? AppColors.brandTeal : Colors.transparent,
              border: Border.all(
                color: met ? AppColors.brandTeal : AppColors.inputBorder,
                width: 1.5,
              ),
            ),
            child: met
                ? const Icon(Icons.check, color: Colors.white, size: 11)
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.requirementLabel.copyWith(
              color: met ? AppColors.brandTeal : AppColors.textSecondary,
              fontWeight: met ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
