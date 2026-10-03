import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/profile/constants/profile_strings.dart';
import 'package:ai_forma/features/profile/controllers/profile_controller.dart';
import 'package:ai_forma/features/profile/view/widgets/profile_option_tile.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpSupportView extends StatelessWidget {
  const HelpSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          ProfileStrings.helpSupportTitle,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: const [SizedBox(width: 48)],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 12),
                    ProfileOptionTile(
                      icon: Icons.bug_report_outlined,
                      title: ProfileStrings.reportAnIssueOption,
                      subtitle: ProfileStrings.reportIssueSubtitle,
                      onTap: () => Get.toNamed(RoutesName.reportBug),
                    ),
                    _buildDivider(),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                onPressed: controller.handleLogout,
                label: ProfileStrings.logoutButton,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: controller.showDeleteAccountDialog,
                child: const Text(
                  ProfileStrings.deleteAccountButton,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: AppColors.cardBorder.withValues(alpha: 0.4),
      height: 1,
      thickness: 1,
    );
  }
}
