import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/utils/app_date_formatter.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/auth/controllers/user_controller.dart';
import 'package:ai_forma/features/profile/constants/profile_strings.dart';
import 'package:ai_forma/features/profile/view/widgets/profile_detail_item_row.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonalDetailsView extends StatelessWidget {
  const PersonalDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();

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
          ProfileStrings.personalDetailsTitle,
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
          child: Obx(() {
            final user = userController.currentUser.value;

            final rawDob = user?.profile?.dateOfBirth;
            final dobFormatted = AppDateFormatter.toDayMonthYear(
              rawDob,
              fallback: ProfileStrings.notAvailable,
            );

            final details = [
              ProfileDetailItem(
                icon: Icons.person_outline,
                label: ProfileStrings.fullNameLabel,
                value: user?.fullName.isNotEmpty == true
                    ? user!.fullName
                    : ProfileStrings.notAvailable,
              ),
              ProfileDetailItem(
                icon: Icons.notifications_none,
                label: ProfileStrings.emailLabel,
                value: user?.email.isNotEmpty == true
                    ? user!.email
                    : ProfileStrings.notAvailable,
              ),
              ProfileDetailItem(
                icon: Icons.calendar_today_outlined,
                label: ProfileStrings.dateOfBirthLabel,
                value: dobFormatted,
              ),
              ProfileDetailItem(
                icon: Icons.person_outline,
                label: ProfileStrings.genderLabel,
                value: user?.gender != null && user!.gender!.isNotEmpty
                    ? user.gender![0].toUpperCase() + user.gender!.substring(1)
                    : ProfileStrings.notAvailable,
              ),
              ProfileDetailItem(
                icon: Icons.track_changes_outlined,
                label: ProfileStrings.heightLabel,
                value: user?.profile?.heightCm != null
                    ? '${user!.profile!.heightCm} cm'
                    : ProfileStrings.notAvailable,
              ),
              ProfileDetailItem(
                icon: Icons.track_changes_outlined,
                label: ProfileStrings.weightLabel,
                value: user?.profile?.weightKg != null
                    ? '${user!.profile!.weightKg} kg'
                    : ProfileStrings.notAvailable,
              ),
            ];

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: details.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return ProfileDetailItemRow(item: details[index]);
                    },
                  ),
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  onPressed: () => Get.toNamed(RoutesName.editPersonalDetails),
                  label: ProfileStrings.editProfileButton,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
