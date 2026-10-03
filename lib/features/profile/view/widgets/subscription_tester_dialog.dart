import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/app_snackbar.dart';
import 'package:ai_forma/features/profile/constants/profile_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SubscriptionTesterDialog extends StatelessWidget {
  final bool isPremium;

  const SubscriptionTesterDialog({super.key, required this.isPremium});

  static void show(BuildContext context, {required bool isPremium}) {
    showDialog(
      context: context,
      builder: (ctx) => SubscriptionTesterDialog(isPremium: isPremium),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Badge Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: isPremium
                    ? AppColors.brandTealLight.withValues(alpha: 0.35)
                    : AppColors.accent.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPremium
                    ? Icons.verified_rounded
                    : Icons.card_membership_rounded,
                color: isPremium ? AppColors.brandTeal : AppColors.accent,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),

            // Dialog Title
            Text(
              isPremium
                  ? ProfileStrings.testerDialogTitlePremium
                  : ProfileStrings.testerDialogTitleFree,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Dialog Description
            Text(
              isPremium
                  ? ProfileStrings.testerDialogDescPremium
                  : ProfileStrings.testerDialogDescFree,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                height: 1.45,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            // Contact Email Box for Free / Tester users
            if (!isPremium) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.cardBorder.withValues(alpha: 0.7),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      size: 20,
                      color: AppColors.brandTeal,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: SelectionArea(
                        child: Text(
                          ProfileStrings.testerContactEmail,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(
                          const ClipboardData(
                            text: ProfileStrings.testerContactEmail,
                          ),
                        );
                        AppSnackbar.showSuccess(
                          '${ProfileStrings.emailCopiedToastPrefix}${ProfileStrings.testerContactEmail}',
                          duration: const Duration(seconds: 2),
                        );
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.brandTeal.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.copy_rounded,
                              size: 14,
                              color: AppColors.brandTeal,
                            ),
                            SizedBox(width: 4),
                            Text(
                              ProfileStrings.copy,
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.brandTeal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // OK Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandTeal,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  ProfileStrings.ok,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
