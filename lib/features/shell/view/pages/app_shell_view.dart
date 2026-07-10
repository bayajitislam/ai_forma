import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/app_navbar.dart';
import 'package:ai_forma/features/dashboard/view/pages/dashboard_view.dart';
import 'package:ai_forma/features/shell/constants/shell_strings.dart';
import 'package:ai_forma/features/check_in/view/pages/check_in_home_view.dart';
import 'package:ai_forma/features/shell/view/widgets/app_shell_header.dart';
import 'package:ai_forma/features/shell/view/pages/placeholder_tab_view.dart';

class AppShellView extends StatefulWidget {
  const AppShellView({super.key});

  @override
  State<AppShellView> createState() => _AppShellViewState();
}

class _AppShellViewState extends State<AppShellView> {
  AppNavItem _selectedItem = AppNavItem.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dashboardBackground,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: AppShellHeader(),
            ),
            Expanded(
              child: IndexedStack(
                index: _selectedItem.index,
                children: const [
                  DashboardView(),
                  CheckInHomeView(),
                  PlaceholderTabView(title: ShellStrings.navAnalysis),
                  PlaceholderTabView(title: ShellStrings.navTimeline),
                  PlaceholderTabView(title: ShellStrings.navProfile),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: AppNavbar(
            selectedItem: _selectedItem,
            onItemSelected: (item) => setState(() => _selectedItem = item),
          ),
        ),
      ),
    );
  }
}
