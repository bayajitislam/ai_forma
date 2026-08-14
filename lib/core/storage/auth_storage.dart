import 'dart:convert';
import 'package:ai_forma/features/auth/models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserData = 'user_data';
  static const String _keyFirstCheckInCompleted = 'first_check_in_completed';

  /// Save tokens and user info to SharedPreferences
  static Future<void> saveAuthData({
    required TokenModel tokens,
    required UserModel user,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, tokens.access);
    await prefs.setString(_keyRefreshToken, tokens.refresh);
    await prefs.setString(_keyUserData, jsonEncode(user.toJson()));
  }

  /// Save or update only user profile in SharedPreferences
  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserData, jsonEncode(user.toJson()));
  }

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

  /// Get saved access token
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccessToken);
  }

  /// Get saved refresh token
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRefreshToken);
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

  /// Clear all saved auth session data
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRefreshToken);
    await prefs.remove(_keyUserData);
    await prefs.remove(_keyFirstCheckInCompleted);
  }
}
