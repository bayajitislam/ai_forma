import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_forma/core/widgets/app_brand_text.dart';
import 'package:ai_forma/core/widgets/profile_avatar.dart';
import 'package:ai_forma/features/auth/controllers/user_controller.dart';
import 'package:ai_forma/features/dashboard/controllers/home_controller.dart';

class AppShellHeader extends StatelessWidget {
  final bool showProfileOption;

  const AppShellHeader({
    super.key,
    this.showProfileOption = true,
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

            if (Get.isRegistered<HomeController>()) {
              final header = Get.find<HomeController>().homeData.value?.header;
              avatarUrl = header?.avatarUrl;
              final firstName = header?.firstName ?? '';
              if (firstName.isNotEmpty) {
                initialLetter = firstName[0].toUpperCase();
              }
            }

            if (initialLetter == 'U' && Get.isRegistered<UserController>()) {
              final user = Get.find<UserController>().currentUser.value;
              if (user != null && user.fullName.isNotEmpty) {
                initialLetter =
                    user.fullName.trim().split(' ').first[0].toUpperCase();
              }
            }

            return ProfileAvatar(
              avatarUrl: avatarUrl,
              initialLetter: initialLetter,
              size: avatarSize,
            );
          })
        else
          const SizedBox(width: avatarSize),
      ],
    );
  }
}
