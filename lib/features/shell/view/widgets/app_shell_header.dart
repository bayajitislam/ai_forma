import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_forma/core/widgets/app_brand_text.dart';
import 'package:ai_forma/core/widgets/profile_avatar.dart';
import 'package:ai_forma/features/auth/controllers/user_controller.dart';
import 'package:ai_forma/features/dashboard/controllers/home_controller.dart';

class AppShellHeader extends StatelessWidget {
  final bool showProfileOption;
  final VoidCallback? onProfileTap;

  const AppShellHeader({
    super.key,
    this.showProfileOption = true,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    const avatarSize = 38.0;

    return Row(
      children: [
        // Left spacer to balance profile avatar on the right for true centering
        const SizedBox(width: avatarSize),
        const Expanded(
          child: Center(
            child: AppBrandText(height: 22, width: 140),
          ),
        ),
        if (showProfileOption)
          Obx(() {
            String? avatarUrl;
            String initialLetter = 'U';

            final user = Get.isRegistered<UserController>()
                ? Get.find<UserController>().currentUser.value
                : null;

            if (Get.isRegistered<HomeController>()) {
              final header = Get.find<HomeController>().homeData.value?.header;
              avatarUrl = header?.avatarUrl;
              final firstName = header?.firstName ?? '';
              if (firstName.isNotEmpty) {
                initialLetter = firstName[0].toUpperCase();
              }
            }

            // Fallback avatarUrl from UserController if home header is null or empty
            avatarUrl ??= user?.profileImageUrl ?? user?.profile?.profileImageUrl;

            if (initialLetter == 'U' && user != null && user.fullName.isNotEmpty) {
              initialLetter =
                  user.fullName.trim().split(' ').first[0].toUpperCase();
            }

            return GestureDetector(
              onTap: onProfileTap,
              child: ProfileAvatar(
                avatarUrl: avatarUrl,
                initialLetter: initialLetter,
                size: avatarSize,
              ),
            );
          })
        else
          const SizedBox(width: avatarSize),
      ],
    );
  }
}
