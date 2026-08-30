import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/features/auth/controllers/user_controller.dart';
import 'package:ai_forma/routes/app_routes.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/theme/app_theme.dart';
import 'package:get/get.dart';

import 'package:ai_forma/core/services/push_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(DioClient());
  Get.put(UserController(Get.find<DioClient>()), permanent: true);

  // Initialize Firebase Push Notifications & FCM Token Registration
  PushNotificationService.instance.initialize();

  runApp(const AiFormaApp());
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
