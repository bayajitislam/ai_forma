import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';

class InsightCategoryCard extends StatelessWidget {
  const InsightCategoryCard({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.iconColor,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 105,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [AppColors.brandTealLight, AppColors.brandTealDark],
                  )
                : null,
            color: isSelected ? null : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: isSelected ? null : Border.all(color: AppColors.cardBorder),
            boxShadow: isSelected
                ? null
                : const [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppIcon(
                icon: icon,
                size: 28,
                color: isSelected
                    ? AppColors.onPrimary
                    : (iconColor ?? AppColors.brandTeal),
              ),
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? AppColors.onPrimary
                      : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
