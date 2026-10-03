import 'dart:async';

import 'package:ai_forma/core/bindings/initial_binding.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/services/push_notification_service.dart';
import 'package:ai_forma/core/storage/auth_storage.dart';
import 'package:ai_forma/core/theme/app_theme.dart';
import 'package:ai_forma/core/widgets/app_error_widget.dart';
import 'package:ai_forma/core/widgets/app_snackbar.dart';
import 'package:ai_forma/firebase_options.dart';
import 'package:ai_forma/routes/app_routes.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_devlog/flutter_devlog.dart';
import 'package:get/get.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Ensure fresh install clears lingering iOS Keychain credentials
    await AuthStorage.ensureCleanInstall();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    _setupErrorHandlers();

    // Initialize core persistent dependencies
    InitialBinding.init();

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

/// Configure global Flutter and platform error handlers
void _setupErrorHandlers() {
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

  // Prevent red/grey screen of death in UI by rendering readable on-screen banner
  ErrorWidget.builder = (details) => AppErrorWidget(details: details);
}

class AiFormaApp extends StatelessWidget {
  const AiFormaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scaffoldMessengerKey: AppSnackbar.messengerKey,
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialBinding: InitialBinding(),
      initialRoute: RoutesName.splash,
      getPages: AppRoutes.pages,
    );
  }
}
