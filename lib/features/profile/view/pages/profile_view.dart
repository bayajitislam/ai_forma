import 'package:ai_forma/core/constants/api_endpoint.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/profile/constants/profile_strings.dart';
import 'package:ai_forma/features/profile/controllers/profile_controller.dart';
import 'package:ai_forma/features/profile/view/widgets/profile_momentum_card.dart';
import 'package:ai_forma/features/profile/view/widgets/profile_notification_tile.dart';
import 'package:ai_forma/features/profile/view/widgets/profile_option_tile.dart';
import 'package:ai_forma/features/profile/view/widgets/profile_user_card.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());

    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 120),
      child: Column(
        children: [
          const SizedBox(height: 8),

          // Profile User Info Card
          const ProfileUserCard(),
          const SizedBox(height: 16),

          // Custom Momentum Card
          const ProfileMomentumCard(),
          const SizedBox(height: 24),

          // Settings Options list
          ProfileOptionTile(
            icon: Icons.person_outline,
            title: ProfileStrings.personalDetailsOption,
            onTap: () => Get.toNamed(RoutesName.personalDetails),
          ),
          _buildDivider(),
          ProfileOptionTile(
            icon: Icons.credit_card_outlined,
            title: ProfileStrings.subscriptionOption,
            onTap: () => Get.toNamed(RoutesName.subscription),
          ),
          _buildDivider(),
          ProfileNotificationTile(controller: controller),
          _buildDivider(),
          ProfileOptionTile(
            icon: Icons.bug_report_outlined,
            title: ProfileStrings.reportAnIssueOption,
            onTap: () => Get.toNamed(RoutesName.reportBug),
          ),
          _buildDivider(),
          ProfileOptionTile(
            icon: Icons.security_outlined,
            title: ProfileStrings.privacyPolicyOption,
            onTap: () => controller.launchExternalUrl(ApiEndpoint.privacyPolicy),
          ),
          _buildDivider(),
          ProfileOptionTile(
            icon: Icons.description_outlined,
            title: ProfileStrings.termsOfServiceOption,
            onTap: () => controller.launchExternalUrl(ApiEndpoint.termsOfService),
          ),

          const SizedBox(height: 32),

          // Logout Button
          PrimaryButton(
            onPressed: controller.handleLogout,
            label: ProfileStrings.logoutButton,
          ),
          const SizedBox(height: 16),

          // Delete Account
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
          const SizedBox(height: 24),
        ],
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
