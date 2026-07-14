import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/app_navbar.dart';
import 'package:ai_forma/features/dashboard/view/pages/dashboard_view.dart';
import 'package:ai_forma/features/check_in/view/pages/check_in_home_view.dart';
import 'package:ai_forma/features/insights/view/pages/insights_view.dart';
import 'package:ai_forma/features/shell/view/widgets/app_shell_header.dart';

import 'package:ai_forma/features/timeline/view/pages/timeline_view.dart';

import 'package:ai_forma/features/profile/view/pages/profile_view.dart';

class AppShellView extends StatefulWidget {
  const AppShellView({super.key});

  @override
  State<AppShellView> createState() => _AppShellViewState();
}

class _AppShellViewState extends State<AppShellView> {
  AppNavItem _selectedItem = AppNavItem.home;

  //create a method that will navigate to the insights tab
  void navigateToInsights() {
    setState(() {
      _selectedItem = AppNavItem.insights;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onBackground,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: AppShellHeader(),
            ),
            Expanded(
              child: IndexedStack(
                index: _selectedItem.index,
                children: [
                  DashboardView(goInsight: navigateToInsights),
                  CheckInHomeView(goInsightPage: navigateToInsights),
                  const InsightsView(),
                  const TimelineView(),
                  const ProfileView(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: AppNavbar(
            selectedItem: _selectedItem,
            onItemSelected: (item) => setState(() => _selectedItem = item),
          ),
        ),
      ),
    );
  }
}
