import 'dart:async';
import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/features/auth/controllers/user_controller.dart';
import 'package:ai_forma/routes/app_routes.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_theme.dart';
import 'package:get/get.dart';

import 'package:flutter_devlog/flutter_devlog.dart';
import 'package:ai_forma/core/services/push_notification_service.dart';
import 'package:ai_forma/core/storage/auth_storage.dart';
import 'package:ai_forma/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Ensure fresh install clears lingering iOS Keychain credentials
    await AuthStorage.ensureCleanInstall();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Pass all uncaught synchronous Flutter framework errors to Crashlytics
    FlutterError.onError = (FlutterErrorDetails details) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      DevLog.error(
        'Flutter Framework Error: ${details.exceptionAsString()}',
        tag: 'FlutterError',
        error: details.exception,
        stackTrace: details.stack,
      );
    };

    // Pass all uncaught asynchronous platform errors to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      DevLog.error(
        'Platform Async Error: $error',
        tag: 'PlatformDispatcher',
        error: error,
        stackTrace: stack,
      );
      return true; // Return true to prevent crashing/terminating the application
    };

    // 3. Prevent red/grey screen of death in UI by rendering readable on-screen banner
    ErrorWidget.builder = (FlutterErrorDetails details) {
      if (kReleaseMode) {
        return Material(
          color: Colors.white,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
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
                      'Something went wrong',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'An unexpected error occurred. Please restart the app or try again.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
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
                  const Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'UI Render Error Detected',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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
    };

    Get.put(DioClient(), permanent: true);
    Get.put(UserController(Get.find<DioClient>()), permanent: true);

    // Initialize Firebase Push Notifications & FCM Token Registration
    PushNotificationService.instance.initialize();

    runApp(const AiFormaApp());
  }, (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    DevLog.error(
      'Zoned Root Exception: $error',
      tag: 'RootZone',
      error: error,
      stackTrace: stack,
    );
  });
}

class AiFormaApp extends StatelessWidget {
  const AiFormaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: RoutesName.splash,
      getPages: AppRoutes.pages,
    );
  }
}
