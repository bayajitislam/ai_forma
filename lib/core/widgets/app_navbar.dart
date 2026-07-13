import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/features/shell/constants/shell_strings.dart';

enum AppNavItem { home, checkIn, insights, timeline, profile }

class AppNavbar extends StatelessWidget {
  const AppNavbar({
    super.key,
    required this.selectedItem,
    required this.onItemSelected,
  });

  final AppNavItem selectedItem;
  final ValueChanged<AppNavItem> onItemSelected;

  static const List<({AppNavItem item, IconData icon, String label})> _items = [
    (item: AppNavItem.home, icon: AppIcons.home, label: ShellStrings.navHome),
    (
      item: AppNavItem.checkIn,
      icon: AppIcons.camera,
      label: ShellStrings.navCheckIn,
    ),
    (
      item: AppNavItem.insights,
      icon: AppIcons.barChart,
      label: ShellStrings.navInsights,
    ),
    (
      item: AppNavItem.timeline,
      icon: AppIcons.calendar,
      label: ShellStrings.navTimeline,
    ),
    (
      item: AppNavItem.profile,
      icon: AppIcons.user,
      label: ShellStrings.navProfile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _items.map((entry) {
          final isSelected = entry.item == selectedItem;

          return Expanded(
            child: GestureDetector(
              onTap: () => onItemSelected(entry.item),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppIcon(
                    icon: entry.icon,
                    size: 22,
                    color: isSelected
                        ? AppColors.brandTeal
                        : AppColors.navInactive,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.label,
                    style: AppTextStyles.navLabel.copyWith(
                      color: isSelected
                          ? AppColors.brandTeal
                          : AppColors.navInactive,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
