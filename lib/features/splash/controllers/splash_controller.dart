import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/core/services/push_notification_service.dart';
import 'package:ai_forma/core/storage/auth_storage.dart';
import 'package:ai_forma/features/auth/controllers/user_controller.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkAuthAndNavigate();
  }

  Future<void> checkAuthAndNavigate() async {
    isError.value = false;
    errorMessage.value = '';

    final token = await AuthStorage.getAccessToken();

    // 1. Not logged in -> Navigate directly to Onboarding
    if (token == null || token.isEmpty) {
      await Future<void>.delayed(const Duration(seconds: 1));
      Get.offAllNamed(RoutesName.onboarding);
      return;
    }

    // 2. Logged in -> Call GET /api/auth/me/ to get fresh remote user data
    final UserController userController = Get.isRegistered<UserController>()
        ? Get.find<UserController>()
        : Get.put(
            UserController(Get.find<DioClient>()),
            permanent: true,
          );

    final res = await userController.fetchProfile();

    res.fold(
      (failure) async {
        final msg = failure.message.toLowerCase();
        // 401 Unauthorized / Token Expired -> Clear session & go to Onboarding
        if (msg.contains('unauthorized') ||
            msg.contains('unauthenticated') ||
            msg.contains('401') ||
            msg.contains('token')) {
          await AuthStorage.clearSession();
          Get.offAllNamed(RoutesName.onboarding);
          return;
        }

        // Network or Server Error -> Show AppNetworkErrorWidget with "Try Again" button
        isError.value = true;
        errorMessage.value = failure.message.isNotEmpty
            ? failure.message
            : 'Unable to connect to server. Please check your internet connection.';
      },
      (remoteUser) {
        // 3. Remote GET /api/auth/me/ succeeded -> Navigate strictly based on remote server data!
        if (!remoteUser.onboardingCompleted) {
          Get.offAllNamed(RoutesName.gender);
        } else if (!remoteUser.initialScanCompleted) {
          Get.offAllNamed(RoutesName.checkInIntro);
        } else {
          if (PushNotificationService.instance.hasPendingNotification) {
            PushNotificationService.instance.consumePendingNotification();
          } else {
            Get.offAllNamed(RoutesName.appShell);
          }
        }
      },
    );
  }
}
