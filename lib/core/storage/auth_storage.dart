import 'dart:convert';
import 'package:ai_forma/features/auth/models/login_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(resetOnError: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserData = 'user_data';
  static const String _keyFirstCheckInCompleted = 'first_check_in_completed';
  static const String _keyHasRunBefore = 'app_has_run_before';

  /// Ensure secure storage is cleared if the app was freshly installed.
  /// On iOS, the Keychain persists across app deletions and reinstalls, whereas
  /// SharedPreferences is deleted. By tracking an install marker in SharedPreferences,
  /// we detect a re-install and purge any orphaned Keychain credentials so the user
  /// starts fresh with onboarding and login.
  static Future<void> ensureCleanInstall() async {
    final prefs = await SharedPreferences.getInstance();
    final hasRunBefore = prefs.getBool(_keyHasRunBefore) ?? false;
    if (!hasRunBefore) {
      try {
        await _secureStorage.deleteAll();
      } catch (_) {}
      await prefs.setBool(_keyHasRunBefore, true);
    }
  }

  /// Save tokens to secure storage and user info to SharedPreferences
  static Future<void> saveAuthData({
    required TokenModel tokens,
    required UserModel user,
  }) async {
    await _secureStorage.write(key: _keyAccessToken, value: tokens.access);
    await _secureStorage.write(key: _keyRefreshToken, value: tokens.refresh);

    final prefs = await SharedPreferences.getInstance();
    // Remove any legacy tokens from SharedPreferences
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRefreshToken);
    await prefs.setString(_keyUserData, jsonEncode(user.toJson()));
  }

  /// Save or update only user profile in SharedPreferences
  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserData, jsonEncode(user.toJson()));
  }

  /// Update saved access token and optional refresh token in secure storage
  static Future<void> updateTokens({
    required String access,
    String? refresh,
  }) async {
    await _secureStorage.write(key: _keyAccessToken, value: access);
    if (refresh != null && refresh.isNotEmpty) {
      await _secureStorage.write(key: _keyRefreshToken, value: refresh);
    }
    // Clean up legacy tokens from SharedPreferences if any
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
    if (refresh != null && refresh.isNotEmpty) {
      await prefs.remove(_keyRefreshToken);
    }
  }

  static const String _keyNotificationsEnabled = 'notifications_enabled';

  /// Save first check-in completion status
  static Future<void> setFirstCheckInCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyFirstCheckInCompleted, completed);
  }

  /// Check if user has completed their 1st check-in
  static Future<bool> isFirstCheckInCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyFirstCheckInCompleted) ?? false;
  }

  /// Save user notifications preference
  static Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotificationsEnabled, enabled);
  }

  /// Check user notifications preference (defaults to true)
  static Future<bool> isNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyNotificationsEnabled) ?? true;
  }

  /// Get saved access token from secure storage (with automatic migration from SharedPreferences)
  static Future<String?> getAccessToken() async {
    try {
      final token = await _secureStorage.read(key: _keyAccessToken);
      if (token != null && token.isNotEmpty) {
        return token;
      }
    } catch (_) {}

    // Fallback & seamless migration from legacy SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      final legacyToken = prefs.getString(_keyAccessToken);
      if (legacyToken != null && legacyToken.isNotEmpty) {
        await _secureStorage.write(key: _keyAccessToken, value: legacyToken);
        await prefs.remove(_keyAccessToken);
        return legacyToken;
      }
    } catch (_) {}

    return null;
  }

  /// Get saved refresh token from secure storage (with automatic migration from SharedPreferences)
  static Future<String?> getRefreshToken() async {
    try {
      final token = await _secureStorage.read(key: _keyRefreshToken);
      if (token != null && token.isNotEmpty) {
        return token;
      }
    } catch (_) {}

    // Fallback & seamless migration from legacy SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      final legacyToken = prefs.getString(_keyRefreshToken);
      if (legacyToken != null && legacyToken.isNotEmpty) {
        await _secureStorage.write(key: _keyRefreshToken, value: legacyToken);
        await prefs.remove(_keyRefreshToken);
        return legacyToken;
      }
    } catch (_) {}

    return null;
  }

  /// Get saved user profile
  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyUserData);
    if (jsonStr == null) return null;
    try {
      final Map<String, dynamic> map = jsonDecode(jsonStr);
      return UserModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  /// Clear all saved auth session data from both secure storage and SharedPreferences
  static Future<void> clearSession() async {
    try {
      await _secureStorage.delete(key: _keyAccessToken);
      await _secureStorage.delete(key: _keyRefreshToken);
    } catch (_) {}

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRefreshToken);
    await prefs.remove(_keyUserData);
    await prefs.remove(_keyFirstCheckInCompleted);
  }
}
