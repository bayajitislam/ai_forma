import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? hintText;
  final int maxLines;

  const ProfileTextFormField({
    super.key,
    required this.label,
    required this.controller,
    this.suffixIcon,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.hintText,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: maxLines,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: maxLines > 1 ? 14 : 15,
            fontWeight: maxLines > 1 ? FontWeight.normal : FontWeight.bold,
            color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: AppColors.textSecondary.withValues(alpha: 0.6),
            ),
            filled: !enabled,
            fillColor: !enabled ? AppColors.dashboardBackground : Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            suffixIcon: suffixIcon,
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.cardBorder.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.cardBorder.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.brandTeal,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
