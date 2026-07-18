import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/profile/view/pages/edit_personal_details_view.dart';

class PersonalDetailsView extends StatelessWidget {
  const PersonalDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final details = [
      _DetailRowItem(icon: Icons.person_outline, label: 'Full Name', value: 'Josh Bowden'),
      _DetailRowItem(icon: Icons.notifications_none, label: 'Email', value: 'josh.bowden@email.com'),
      _DetailRowItem(icon: Icons.calendar_today_outlined, label: 'Date of Birth', value: 'May 10, 1981'),
      _DetailRowItem(icon: Icons.person_outline, label: 'Gender', value: 'Male'),
      _DetailRowItem(icon: Icons.track_changes_outlined, label: 'Height', value: '175 cm'),
      _DetailRowItem(icon: Icons.track_changes_outlined, label: 'Weight', value: '87.4 kg'),
      _DetailRowItem(icon: Icons.track_changes_outlined, label: 'Country', value: 'Australia'),
    ];

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
          'Personal Details',
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: details.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = details[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Icon(
                            item.icon,
                            color: AppColors.textSecondary.withValues(alpha: 0.8),
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            item.label,
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            item.value,
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              // Reusing primary button component
              PrimaryButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const EditPersonalDetailsView(),
                    ),
                  );
                },
                label: 'EDIT PROFILE',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRowItem {
  final IconData icon;
  final String label;
  final String value;

  _DetailRowItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}
