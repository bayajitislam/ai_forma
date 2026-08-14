import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.label = AppStrings.continueButton,
    this.borderRadius = 12.0,
  });

  final VoidCallback? onPressed;
  final bool isLoading;
  final String label;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isDisabled ? 0.45 : 1.0,
      child: SizedBox(
        width: double.infinity,
        height: 46,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: isDisabled
                ? const LinearGradient(
                    colors: [Color(0xFFBDBDBD), Color(0xFFBDBDBD)],
                  )
                : AppColors.primaryButtonGradient,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onPressed,
                    borderRadius: BorderRadius.circular(12),
                    child: Center(
                      child: Text(label, style: AppTextStyles.primaryButton),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
