import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/features/dashboard/controllers/home_controller.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_devlog/flutter_devlog.dart';
import 'package:get/get.dart';

/// Global fallback error widget that replaces Flutter's default red/grey screen of death.
///
/// In release mode, displays a friendly recovery card with restart/reload instructions.
/// In debug mode, displays an expandable developer error banner with the active stack trace.
class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    required this.details,
  });

  final FlutterErrorDetails details;

  void _handleRecovery() {
    try {
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().fetchHomeData(force: true);
      }
      Get.offAllNamed(RoutesName.appShell);
    } catch (_) {
      // In case navigation fails, attempt a simple pop
      Get.key.currentState?.popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    DevLog.error(
      'UI Render Exception trapped by AppErrorWidget: ${details.exception}',
      tag: 'AppErrorWidget',
      error: details.exception,
      stackTrace: details.stack,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isCompact = constraints.maxHeight < 160 || constraints.maxWidth < 220;

        if (isCompact) {
          return Material(
            color: AppColors.surface,
            child: InkWell(
              onTap: _handleRecovery,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.refresh_rounded,
                          color: AppColors.brandTeal,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          AppStrings.somethingWentWrong,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        if (kReleaseMode) {
          return Material(
            color: Colors.white,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 32.0,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.cardBorder.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.refresh_rounded,
                          color: AppColors.brandTeal,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        AppStrings.somethingWentWrong,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        AppStrings.unexpectedErrorOccurred,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _handleRecovery,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brandTeal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'Try Again',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        // In debug mode, show detailed stack trace for developer inspection
        return Material(
          color: Colors.white,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 20,
                        ),
                        const Text(
                          AppStrings.uiRenderErrorDetected,
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: _handleRecovery,
                          child: const Text(
                            'Try Again',
                            style: TextStyle(color: AppColors.brandTeal),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${details.exception}',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${details.stack}',
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
