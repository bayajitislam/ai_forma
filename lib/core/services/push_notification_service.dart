import 'dart:io';
import 'package:ai_forma/core/constants/api_endpoint.dart';
import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/core/storage/auth_storage.dart';
import 'package:ai_forma/core/widgets/app_navbar.dart';
import 'package:ai_forma/firebase_options.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_devlog/flutter_devlog.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

enum NotificationToggleResult {
  enabled,
  disabled,
  permanentlyDenied,
  permissionDenied,
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  DevLog.info(
    'Handling background message: ${message.messageId}',
    tag: 'PushNotification',
  );
}

class PushNotificationService {
  static final PushNotificationService instance = PushNotificationService._internal();
  PushNotificationService._internal();

  FirebaseMessaging get _messaging => FirebaseMessaging.instance;

  Map<String, dynamic>? _pendingNotificationData;

  /// True if the app was launched by tapping a push notification from terminated state.
  bool get hasPendingNotification => _pendingNotificationData != null;

  /// Get pending notification payload received from cold start.
  Map<String, dynamic>? get pendingNotificationData => _pendingNotificationData;

  /// Consumes the pending notification payload and routes user to target view.
  void consumePendingNotification() {
    final data = _pendingNotificationData;
    _pendingNotificationData = null;
    if (data != null) {
      handleNotificationTap(data);
    }
  }

  /// Initialize Firebase Push Notifications and register FCM device token with backend
  Future<void> initialize() async {
    try {
      if (Firebase.apps.isEmpty) {
        DevLog.warn(
          'Firebase not initialized, skipping PushNotificationService.',
          tag: 'PushNotification',
        );
        return;
      }

      // Set background message handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Check if user has disabled notifications via in-app preference
      final prefEnabled = await AuthStorage.isNotificationsEnabled();

      // Handle notification tap when app is launched from terminated state (cold boot)
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        DevLog.info(
          'App opened from terminated state with payload: ${initialMessage.data}',
          tag: 'PushNotification',
        );
        _pendingNotificationData = initialMessage.data;
      }

      // Handle notification tap when app is opened from background state
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        DevLog.info(
          'Notification opened app from background: ${message.data}',
          tag: 'PushNotification',
        );
        handleNotificationTap(message.data);
      });

      // Foreground notification listener
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        DevLog.info(
          'Received foreground notification: ${message.notification?.title}',
          tag: 'PushNotification',
        );
      });

      // Request notification permissions (required for iOS and Android 13+)
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      DevLog.info(
        'Push notification permission status: ${settings.authorizationStatus.name}',
        tag: 'PushNotification',
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        DevLog.success(
          'User granted push notification permission.',
          tag: 'PushNotification',
        );

        // Wire up the token refresh listener
        _messaging.onTokenRefresh.listen((newToken) {
          DevLog.info(
            'FCM token refreshed, registering with backend.',
            tag: 'PushNotification',
          );
          registerTokenWithBackend(newToken);
        });

        // Register token if user preference allows notifications
        if (prefEnabled) {
          _tryRegisterFcmToken();
        }
      } else {
        DevLog.warn(
          'Notification permission is not granted (${settings.authorizationStatus.name}). User can enable it from Profile Settings.',
          tag: 'PushNotification',
        );
      }
    } catch (e, s) {
      DevLog.error(
        'PushNotificationService initialization error: $e',
        tag: 'PushNotification',
        error: e,
        stackTrace: s,
      );
    }
  }

  /// Check whether OS-level notification permission is granted
  Future<bool> isSystemPermissionGranted() async {
    if (kIsWeb) return false;
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  /// Returns true only if both device OS permissions are granted AND user has not toggled notifications off in-app.
  Future<bool> getEffectiveNotificationStatus() async {
    if (kIsWeb) return false;
    final isSystemGranted = await isSystemPermissionGranted();
    final isPrefEnabled = await AuthStorage.isNotificationsEnabled();
    return isSystemGranted && isPrefEnabled;
  }

  /// Toggles notifications on or off, coordinating OS permissions and backend token registration.
  Future<NotificationToggleResult> toggleNotifications(bool enable) async {
    if (enable) {
      final status = await Permission.notification.status;
      if (status.isGranted) {
        await AuthStorage.setNotificationsEnabled(true);
        await registerCurrentToken();
        return NotificationToggleResult.enabled;
      } else if (status.isPermanentlyDenied) {
        return NotificationToggleResult.permanentlyDenied;
      } else {
        final requestStatus = await Permission.notification.request();
        if (requestStatus.isGranted) {
          await AuthStorage.setNotificationsEnabled(true);
          await registerCurrentToken();
          return NotificationToggleResult.enabled;
        } else if (requestStatus.isPermanentlyDenied) {
          return NotificationToggleResult.permanentlyDenied;
        } else {
          return NotificationToggleResult.permissionDenied;
        }
      }
    } else {
      await AuthStorage.setNotificationsEnabled(false);
      await unregisterTokenFromBackend();
      return NotificationToggleResult.disabled;
    }
  }

  /// Non-blocking attempt to get and register the FCM token.
  Future<void> _tryRegisterFcmToken({
    Duration retryDelay = const Duration(seconds: 5),
    bool isRetry = false,
  }) async {
    try {
      final token = await _messaging.getToken();
      if (token != null && token.isNotEmpty) {
        DevLog.info(
          'FCM token obtained${isRetry ? ' (on retry)' : ''}, registering with backend.',
          tag: 'PushNotification',
        );
        await registerTokenWithBackend(token);
      }
    } catch (e) {
      if (isRetry) {
        DevLog.warn(
          'FCM token unavailable — APNs may not be configured for this build: $e',
          tag: 'PushNotification',
        );
        return;
      }
      DevLog.info(
        'FCM token not ready, will retry in ${retryDelay.inSeconds}s.',
        tag: 'PushNotification',
      );
      Future.delayed(retryDelay, () => _tryRegisterFcmToken(isRetry: true));
    }
  }

  /// Register FCM token with backend: POST /api/devices/push-token/register/
  Future<bool> registerTokenWithBackend(String token) async {
    try {
      final isPrefEnabled = await AuthStorage.isNotificationsEnabled();
      if (!isPrefEnabled) {
        DevLog.info(
          'Notifications disabled in user settings, skipping registration.',
          tag: 'PushNotification',
        );
        return false;
      }

      final authToken = await AuthStorage.getAccessToken();
      if (authToken == null || authToken.isEmpty) {
        DevLog.info(
          'User not logged in yet. Skipping FCM token backend registration.',
          tag: 'PushNotification',
        );
        return false;
      }

      if (!Get.isRegistered<DioClient>()) return false;
      final dio = Get.find<DioClient>();

      final platformStr = Platform.isIOS ? 'ios' : (Platform.isAndroid ? 'android' : 'web');

      final response = await dio.post(
        ApiEndpoint.registerPushToken,
        data: {
          'token': token,
          'platform': platformStr,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        DevLog.success(
          'FCM Token registered with backend successfully: $token',
          tag: 'PushNotification',
        );
        return true;
      }
      return false;
    } catch (e, s) {
      DevLog.error(
        'Failed to register FCM token with backend: $e',
        tag: 'PushNotification',
        error: e,
        stackTrace: s,
      );
      return false;
    }
  }

  /// Call this on user login / signup success
  Future<void> registerCurrentToken() async {
    try {
      if (Firebase.apps.isEmpty) return;
      final isPrefEnabled = await AuthStorage.isNotificationsEnabled();
      if (!isPrefEnabled) return;

      final token = await _messaging.getToken();
      if (token != null && token.isNotEmpty) {
        await registerTokenWithBackend(token);
      }
    } catch (e) {
      DevLog.warn(
        'FCM token unavailable at login (APNs not ready): $e',
        tag: 'PushNotification',
      );
    }
  }

  /// Unregister FCM token on logout / notification toggle off: POST /api/devices/push-token/unregister/
  Future<bool> unregisterTokenFromBackend() async {
    try {
      if (Firebase.apps.isEmpty) return false;
      final token = await _messaging.getToken();
      if (token == null || token.isEmpty) return false;

      if (!Get.isRegistered<DioClient>()) return false;
      final dio = Get.find<DioClient>();

      final response = await dio.post(
        ApiEndpoint.unregisterPushToken,
        data: {
          'token': token,
        },
      );

      return response.statusCode == 200;
    } catch (e, s) {
      DevLog.error(
        'Failed to unregister FCM token: $e',
        tag: 'PushNotification',
        error: e,
        stackTrace: s,
      );
      return false;
    }
  }

  /// Handles user tapping on a notification either from background or cold start.
  void handleNotificationTap(Map<String, dynamic> data) {
    DevLog.info(
      'Handling notification tap with payload: $data',
      tag: 'PushNotification',
    );

    final type = data['type']?.toString().toLowerCase().trim();
    final customRoute = data['route']?.toString() ??
        data['screen']?.toString() ??
        data['page']?.toString();

    // 1. Direct route if specified in payload
    if (customRoute != null && customRoute.isNotEmpty) {
      if (customRoute == RoutesName.appShell || customRoute == 'home' || customRoute == '/home') {
        Get.offAllNamed(RoutesName.appShell, arguments: AppNavItem.home);
      } else if (customRoute == 'insights' || customRoute == '/insights') {
        Get.offAllNamed(RoutesName.appShell, arguments: AppNavItem.insights);
      } else if (customRoute == 'timeline' || customRoute == '/timeline') {
        Get.offAllNamed(RoutesName.appShell, arguments: AppNavItem.timeline);
      } else if (customRoute == 'check_in' || customRoute == 'checkin' || customRoute == '/check_in') {
        Get.offAllNamed(RoutesName.appShell, arguments: AppNavItem.checkIn);
      } else if (customRoute == 'profile' || customRoute == '/profile') {
        Get.offAllNamed(RoutesName.appShell, arguments: AppNavItem.profile);
      } else {
        Get.offAllNamed(RoutesName.appShell);
        Get.toNamed(customRoute);
      }
      return;
    }

    // 2. Event type dispatch
    if (type == 'checkin_open' || type == 'check_in' || type == 'checkin') {
      Get.offAllNamed(RoutesName.appShell, arguments: AppNavItem.checkIn);
      Get.toNamed(RoutesName.checkInIntro);
    } else if (type == 'scan_complete' || type == 'analysis_complete' || type == 'insights') {
      Get.offAllNamed(RoutesName.appShell, arguments: AppNavItem.insights);
    } else if (type == 'timeline' || type == 'new_scan' || type == 'scan_history') {
      Get.offAllNamed(RoutesName.appShell, arguments: AppNavItem.timeline);
    } else if (type == 'profile' || type == 'subscription') {
      Get.offAllNamed(RoutesName.appShell, arguments: AppNavItem.profile);
    } else if (type == 'daily_question' || type == 'reminder' || type == 'weight_log') {
      Get.offAllNamed(RoutesName.appShell, arguments: AppNavItem.home);
    } else {
      Get.offAllNamed(RoutesName.appShell, arguments: AppNavItem.home);
    }
  }
}
