import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/profile/view/pages/community_chat_view.dart';
import 'package:ai_forma/features/profile/view/pages/report_bug_view.dart';

class HelpSupportView extends StatelessWidget {
  const HelpSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Help & Support',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: const [
          SizedBox(width: 48),
        ],
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
                    _buildOptionTile(
                      context,
                      icon: Icons.people_outline,
                      title: 'AiFORMA Community',
                      subtitle: 'Share progress, ask questions and stay motivated.',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const CommunityChatView(),
                          ),
                        );
                      },
                    ),
                    _buildDivider(),
                    _buildOptionTile(
                      context,
                      icon: Icons.bug_report_outlined,
                      title: 'Report an Issue',
                      subtitle: 'Help us improve AiFORMA.',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ReportBugView(),
                          ),
                        );
                      },
                    ),
                    _buildDivider(),
                    _buildOptionTile(
                      context,
                      icon: Icons.help_outline,
                      title: 'Knowledge Base',
                      subtitle: 'Find answers to common questions.',
                      onTap: () {},
                    ),
                    _buildDivider(),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                label: 'LOGOUT',
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'DELETE ACCOUNT',
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

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      leading: Icon(
        icon,
        color: AppColors.textPrimary.withValues(alpha: 0.7),
        size: 24,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          subtitle,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
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
