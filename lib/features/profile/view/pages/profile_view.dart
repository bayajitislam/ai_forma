import 'package:ai_forma/features/profile/view/pages/edit_personal_details_view.dart';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/features/profile/view/pages/personal_details_view.dart';
import 'package:ai_forma/features/profile/view/pages/subscription_view.dart';
import 'package:ai_forma/features/profile/view/pages/help_support_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 120),
      child: Column(
        children: [
          const SizedBox(height: 8),
          // Profile User Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.cardBorder.withValues(alpha: 0.5),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Avatar image placeholder
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150&h=150&q=80',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // User metadata
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Josh Bowden',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Premium Member',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.brandTeal,
                        ),
                      ),
                    ],
                  ),
                ),
                // Edit action icon
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const EditPersonalDetailsView(),
                      ),
                    );
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.dashboardBackground,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Custom Momentum Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Circular progress ring
                SizedBox(
                  width: 68,
                  height: 68,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glow background
                      Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.brandTeal.withOpacity(0.15),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      // Track
                      SizedBox(
                        width: 68,
                        height: 68,
                        child: CircularProgressIndicator(
                          value: 1.0,
                          strokeWidth: 5,
                          backgroundColor: Colors.transparent,
                          color: AppColors.darkCardText.withOpacity(0.15),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      // Fill progress
                      SizedBox(
                        width: 68,
                        height: 68,
                        child: CircularProgressIndicator(
                          value: 0.82,
                          strokeWidth: 5,
                          backgroundColor: Colors.transparent,
                          color: AppColors.brandTeal,
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      // Value Text
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            '82',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.0,
                            ),
                          ),
                          Text(
                            '/100',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              color: AppColors.darkCardText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Text details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Excellent Momentum',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Your progress is trending in the right direction. Keep building.',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 12,
                          color: AppColors.darkCardText,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Settings Options list
          _buildOptionTile(
            context,
            icon: Icons.person_outline,
            title: 'Personal Details',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PersonalDetailsView(),
                ),
              );
            },
          ),
          // _buildDivider(),
          // _buildOptionTile(
          //   context,
          //   icon: Icons.track_changes_outlined,
          //   title: 'Physique Targets',
          //   onTap: () {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (context) => const PhysiqueTargetsView(),
          //       ),
          //     );
          //   },
          // ),
          _buildDivider(),
          _buildOptionTile(
            context,
            icon: Icons.credit_card_outlined,
            title: 'Subscription',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SubscriptionView(),
                ),
              );
            },
          ),
          _buildDivider(),
          _buildOptionTile(
            context,
            icon: Icons.security_outlined,
            title: 'Privacy Policy',
            onTap: () {},
          ),
          _buildDivider(),
          _buildOptionTile(
            context,
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            onTap: () {},
          ),
          _buildDivider(),
          _buildOptionTile(
            context,
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const HelpSupportView(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      leading: Icon(
        icon,
        color: AppColors.textPrimary.withOpacity(0.7),
        size: 22,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.cardBorder,
        size: 20,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: AppColors.cardBorder.withOpacity(0.4),
      height: 1,
      thickness: 1,
    );
  }
}
