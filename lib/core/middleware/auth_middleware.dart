import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_forma/features/auth/controllers/user_controller.dart';
import 'package:ai_forma/routes/routes_name.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (Get.isRegistered<UserController>()) {
      final user = Get.find<UserController>().currentUser.value;
      if (user == null) {
        return const RouteSettings(name: RoutesName.login);
      }
    }
    return null;
  }
}
