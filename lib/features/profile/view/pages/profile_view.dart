import 'package:ai_forma/core/storage/auth_storage.dart';
import 'package:ai_forma/core/widgets/app_cached_image.dart';
import 'package:ai_forma/features/profile/view/pages/edit_personal_details_view.dart';
import 'package:ai_forma/features/profile/view/pages/report_bug_view.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/features/auth/controllers/user_controller.dart';
import 'package:ai_forma/features/dashboard/controllers/home_controller.dart';
import 'package:ai_forma/features/dashboard/models/home_response_model.dart';
import 'package:ai_forma/features/profile/view/pages/personal_details_view.dart';
import 'package:ai_forma/features/profile/view/pages/subscription_view.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    if (Get.isRegistered<UserController>()) {
      await Get.find<UserController>().logout();
    } else {
      await AuthStorage.clearSession();
    }
    Get.offAllNamed(RoutesName.login);
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Delete Account',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        content: const Text(
          'This action is permanent and cannot be undone. All your data including scans, check-ins, weight logs, and subscription records will be permanently deleted.',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'CANCEL',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _executeDeleteAccount(context);
            },
            child: const Text(
              'DELETE',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _executeDeleteAccount(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColors.brandTeal),
      ),
    );

    final userController = Get.isRegistered<UserController>()
        ? Get.find<UserController>()
        : null;

    if (userController == null) {
      Navigator.pop(context);
      Get.snackbar(
        'Error',
        'Unable to process request. Please try again.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    final result = await userController.deleteAccount();

    if (context.mounted) {
      Navigator.pop(context);
    }

    result.fold(
      (failure) {
        Get.snackbar(
          'Error',
          failure.message,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      },
      (successMessage) {
        Get.snackbar(
          'Account Deleted',
          successMessage,
          backgroundColor: AppColors.brandTeal,
          colorText: Colors.white,
        );
        Get.offAllNamed(RoutesName.login);
      },
    );
  }

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
                // Avatar image
                Builder(builder: (context) {
                  final userCtrl = Get.isRegistered<UserController>()
                      ? Get.find<UserController>()
                      : null;
                  if (userCtrl != null) {
                    return Obx(() {
                      final imageUrl = userCtrl.currentUser.value?.profileImageUrl
                          ?? userCtrl.currentUser.value?.profile?.profileImageUrl;
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
                    });
                  }
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
                }),
                const SizedBox(width: 16),
                // User metadata
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Builder(builder: (context) {
                        final userController = Get.isRegistered<UserController>()
                            ? Get.find<UserController>()
                            : null;
                        if (userController != null) {
                          return Obx(() {
                            final name = userController.currentUser.value?.fullName;
                            return Text(
                              name != null && name.isNotEmpty ? name : 'User',
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
                          'User',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        );
                      }),
                      const SizedBox(height: 4),
                      Builder(builder: (context) {
                        final userCtrl = Get.isRegistered<UserController>()
                            ? Get.find<UserController>()
                            : null;
                        if (userCtrl != null) {
                          return Obx(() {
                            final user = userCtrl.currentUser.value;
                            final isPaid = user?.isPaid ?? false;
                            final label = isPaid ? 'Premium Member' : 'Free Member';
                            return Text(
                              label,
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isPaid ? AppColors.brandTeal : AppColors.textSecondary,
                              ),
                            );
                          });
                        }
                        return const Text(
                          'Free Member',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        );
                      }),
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
          Builder(builder: (context) {
            final homeController = Get.isRegistered<HomeController>()
                ? Get.find<HomeController>()
                : null;

            Widget buildCardContent(HomeMomentumModel? momentum) {
              final score = momentum?.displayedScore ?? 0;
              final maxScore = momentum?.max ?? 100;
              final progressValue =
                  (maxScore > 0) ? (score / maxScore).clamp(0.0, 1.0) : 0.0;
              final stateTitle = (momentum?.stateLabel.isNotEmpty ?? false)
                  ? momentum!.stateLabel
                  : 'Excellent Momentum';
              final insightText = (momentum?.insight.isNotEmpty ?? false)
                  ? momentum!.insight
                  : 'Your progress is trending in the right direction. Keep building.';

              return Container(
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
                                  color: AppColors.brandTeal.withValues(alpha: 0.15),
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
                              color: AppColors.darkCardText.withValues(alpha: 0.15),
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                          // Fill progress
                          SizedBox(
                            width: 68,
                            height: 68,
                            child: CircularProgressIndicator(
                              value: progressValue,
                              strokeWidth: 5,
                              backgroundColor: Colors.transparent,
                              color: AppColors.brandTeal,
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                          // Value Text
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$score',
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.0,
                                ),
                              ),
                              Text(
                                '/$maxScore',
                                style: const TextStyle(
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
                        children: [
                          Text(
                            stateTitle,
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            insightText,
                            style: const TextStyle(
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
              );
            }

            if (homeController != null) {
              return Obx(() {
                final momentum = homeController.homeData.value?.momentum;
                return buildCardContent(momentum);
              });
            }

            return buildCardContent(null);
          }),
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
            icon: Icons.bug_report_outlined,
            title: 'Report an Issue',
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

          const SizedBox(height: 32),

          // Logout Button
          PrimaryButton(
            onPressed: () => _handleLogout(context),
            label: 'LOGOUT',
          ),
          const SizedBox(height: 16),

          // Delete Account
          GestureDetector(
            onTap: () => _showDeleteAccountDialog(context),
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
          const SizedBox(height: 24),
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
        color: AppColors.textPrimary.withValues(alpha: 0.7),
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
      color: AppColors.cardBorder.withValues(alpha: 0.4),
      height: 1,
      thickness: 1,
    );
  }
}
