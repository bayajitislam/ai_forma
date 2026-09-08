import 'dart:io';
import 'package:ai_forma/core/constants/api_endpoint.dart';
import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/core/storage/auth_storage.dart';
import 'package:ai_forma/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kDebugMode) {
    print('Handling a background message: ${message.messageId}');
  }
}

class PushNotificationService {
  static final PushNotificationService instance = PushNotificationService._internal();
  PushNotificationService._internal();

  FirebaseMessaging get _messaging => FirebaseMessaging.instance;

  /// Initialize Firebase Push Notifications and register FCM device token with backend
  Future<void> initialize() async {
    try {
      // Firebase is already initialized in main() — no need to call initializeApp again.
      // Guard against edge case where apps list could be empty.
      if (Firebase.apps.isEmpty) {
        if (kDebugMode) print('PushNotificationService: Firebase not initialized, skipping.');
        return;
      }

      // Set background message handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Request notification permissions (required for iOS)
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        if (kDebugMode) print('User granted push notification permission.');

        // Wire up the refresh listener first — this fires reliably once the
        // APNs token arrives (even on first launch), so we never miss it.
        _messaging.onTokenRefresh.listen((newToken) {
          if (kDebugMode) print('FCM token refreshed, registering with backend.');
          registerTokenWithBackend(newToken);
        });

        // Attempt to get the FCM token immediately in the background.
        // On first iOS launch the APNs token may not be ready yet — that's fine;
        // onTokenRefresh above will fire as soon as it becomes available.
        _tryRegisterFcmToken();

        // Foreground notification handler
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          if (kDebugMode) {
            print('Received foreground notification: ${message.notification?.title}');
          }
        });

        // App opened from notification handler
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          if (kDebugMode) {
            print('Notification opened app: ${message.data}');
          }
          _handleNotificationTap(message.data);
        });
      }
    } catch (e) {
      if (kDebugMode) print('PushNotificationService initialization error: $e');
    }
  }


  /// Non-blocking attempt to get and register the FCM token.
  /// Tries immediately, then once more after [retryDelay] if APNs isn't ready.
  Future<void> _tryRegisterFcmToken({
    Duration retryDelay = const Duration(seconds: 5),
    bool isRetry = false,
  }) async {
    try {
      final token = await _messaging.getToken();
      if (token != null && token.isNotEmpty) {
        if (kDebugMode) print('FCM token obtained${isRetry ? ' (on retry)' : ''}, registering with backend.');
        await registerTokenWithBackend(token);
      }
    } catch (e) {
      if (isRetry) {
        // Second attempt also failed — APNs is not available in this session
        // (likely a provisioning/entitlement issue). onTokenRefresh will cover future sessions.
        if (kDebugMode) print('FCM token unavailable — APNs may not be configured for this build: $e');
        return;
      }
      // First attempt failed — schedule one silent retry after a short delay
      // to give iOS time to complete the APNs handshake.
      if (kDebugMode) print('FCM token not ready, will retry in ${retryDelay.inSeconds}s.');
      Future.delayed(retryDelay, () => _tryRegisterFcmToken(isRetry: true));
    }
  }

  /// Register FCM token with backend: POST /api/devices/push-token/register/

  Future<bool> registerTokenWithBackend(String token) async {
    try {
      final authToken = await AuthStorage.getAccessToken();
      if (authToken == null || authToken.isEmpty) {
        if (kDebugMode) {
          print('User not logged in yet. Skipping FCM token backend registration.');
        }
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
        if (kDebugMode) {
          print('FCM Token registered with backend successfully: $token');
        }
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to register FCM token with backend: $e');
      }
      return false;
    }
  }

  /// Call this on user login / signup success
  Future<void> registerCurrentToken() async {
    try {
      if (Firebase.apps.isEmpty) return;
      final token = await _messaging.getToken();
      if (token != null && token.isNotEmpty) {
        await registerTokenWithBackend(token);
      }
    } catch (e) {
      if (kDebugMode) print('FCM token unavailable at login (APNs not ready): $e');
    }
  }

  /// Unregister FCM token on logout: POST /api/devices/push-token/unregister/
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
    } catch (e) {
      if (kDebugMode) {
        print('Failed to unregister FCM token: $e');
      }
      return false;
    }
  }

  void _handleNotificationTap(Map<String, dynamic> data) {
    final type = data['type']?.toString();
    if (type == 'checkin_open' || type == 'daily_question') {
      // Navigation handling if needed
    }
  }
}
