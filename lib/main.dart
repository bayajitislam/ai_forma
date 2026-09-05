import 'dart:async';
import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/features/auth/controllers/user_controller.dart';
import 'package:ai_forma/routes/app_routes.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/theme/app_theme.dart';
import 'package:get/get.dart';

import 'package:ai_forma/core/services/push_notification_service.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // 1. Catch synchronous Flutter framework errors (widget build, layout, render)
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('══════════════ [FLUTTER CRASH / ERROR] ══════════════');
      debugPrint('Exception: ${details.exception}');
      debugPrint('Library: ${details.library}');
      debugPrint('Context: ${details.context}');
      debugPrint('Stack: ${details.stack}');
      debugPrint('══════════════════════════════════════════════════════');
    };

    // 2. Catch asynchronous platform errors (unhandled Future rejections)
    PlatformDispatcher.instance.onError = (error, stack) {
      debugPrint('══════════════ [PLATFORM ASYNC ERROR] ══════════════');
      debugPrint('Error: $error');
      debugPrint('Stack: $stack');
      debugPrint('════════════════════════════════════════════════════');
      return true; // Return true to prevent crashing/terminating the application
    };

    // 3. Prevent red/grey screen of death in UI by rendering readable on-screen banner
    ErrorWidget.builder = (FlutterErrorDetails details) {
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
    debugPrint('══════════════ [ZONED ROOT EXCEPTION] ══════════════');
    debugPrint('Error: $error');
    debugPrint('Stack: $stack');
    debugPrint('════════════════════════════════════════════════════');
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
