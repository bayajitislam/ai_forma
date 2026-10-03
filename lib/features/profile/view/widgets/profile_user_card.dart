import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/app_cached_image.dart';
import 'package:ai_forma/features/auth/controllers/user_controller.dart';
import 'package:ai_forma/features/profile/constants/profile_strings.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileUserCard extends StatelessWidget {
  final VoidCallback? onEditTap;

  const ProfileUserCard({super.key, this.onEditTap});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Avatar image
          Builder(
            builder: (context) {
              final userCtrl = Get.isRegistered<UserController>()
                  ? Get.find<UserController>()
                  : null;
              if (userCtrl != null) {
                return Obx(() {
                  final imageUrl =
                      userCtrl.currentUser.value?.profileImageUrl ??
                      userCtrl.currentUser.value?.profile?.profileImageUrl;
                  if (imageUrl != null && imageUrl.isNotEmpty) {
                    return Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AppCachedNetworkImage.provider(imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }
                  return _buildDefaultAvatar();
                });
              }
              return _buildDefaultAvatar();
            },
          ),
          const SizedBox(width: 16),
          // User metadata
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Builder(
                  builder: (context) {
                    final userCtrl = Get.isRegistered<UserController>()
                        ? Get.find<UserController>()
                        : null;
                    if (userCtrl != null) {
                      return Obx(() {
                        final name = userCtrl.currentUser.value?.fullName;
                        return Text(
                          name != null && name.isNotEmpty
                              ? name
                              : ProfileStrings.userDefault,
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        );
                      });
                    }
                    return const Text(
                      ProfileStrings.userDefault,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 4),
                Builder(
                  builder: (context) {
                    final userCtrl = Get.isRegistered<UserController>()
                        ? Get.find<UserController>()
                        : null;
                    if (userCtrl != null) {
                      return Obx(() {
                        final user = userCtrl.currentUser.value;
                        final isPaid = user?.isPaid ?? false;
                        final label = isPaid
                            ? ProfileStrings.premiumMember
                            : ProfileStrings.freeMember;
                        return Text(
                          label,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isPaid
                                ? AppColors.brandTeal
                                : AppColors.textSecondary,
                          ),
                        );
                      });
                    }
                    return const Text(
                      ProfileStrings.freeMember,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // Edit action icon
          GestureDetector(
            onTap: onEditTap ?? () => Get.toNamed(RoutesName.editPersonalDetails),
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
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
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.dashboardBackground,
      ),
      child: const Icon(
        Icons.person,
        size: 28,
        color: AppColors.textSecondary,
      ),
    );
  }
}
