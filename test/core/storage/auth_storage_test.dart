import 'package:ai_forma/core/storage/auth_storage.dart';
import 'package:ai_forma/features/auth/models/login_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    SharedPreferences.setMockInitialValues({});
  });

  group('AuthStorage Tests', () {
    final testTokens = TokenModel(
      access: 'mock_access_token_123',
      refresh: 'mock_refresh_token_456',
    );

    final testUser = UserModel(
      id: 1,
      email: 'test@example.com',
      fullName: 'Test User',
      gender: 'male',
      isEmailVerified: true,
      onboardingCompleted: true,
      initialScanCompleted: true,
    );

    test('saveAuthData stores tokens in secure storage and user in SharedPreferences', () async {
      await AuthStorage.saveAuthData(tokens: testTokens, user: testUser);

      final accessToken = await AuthStorage.getAccessToken();
      final refreshToken = await AuthStorage.getRefreshToken();
      final user = await AuthStorage.getUser();

      expect(accessToken, equals('mock_access_token_123'));
      expect(refreshToken, equals('mock_refresh_token_456'));
      expect(user?.email, equals('test@example.com'));
      expect(user?.fullName, equals('Test User'));

      // Ensure tokens are NOT stored in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('access_token'), isNull);
      expect(prefs.getString('refresh_token'), isNull);
    });

    test('updateTokens updates tokens in secure storage', () async {
      await AuthStorage.saveAuthData(tokens: testTokens, user: testUser);
      await AuthStorage.updateTokens(
        access: 'updated_access_token_789',
        refresh: 'updated_refresh_token_999',
      );

      final accessToken = await AuthStorage.getAccessToken();
      final refreshToken = await AuthStorage.getRefreshToken();

      expect(accessToken, equals('updated_access_token_789'));
      expect(refreshToken, equals('updated_refresh_token_999'));
    });

    test('seamless migration: migrates legacy tokens from SharedPreferences to secure storage', () async {
      // Simulate legacy user session in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', 'legacy_access_token');
      await prefs.setString('refresh_token', 'legacy_refresh_token');

      // First read should detect legacy tokens, migrate them to secure storage, and clean SharedPreferences
      final accessToken = await AuthStorage.getAccessToken();
      final refreshToken = await AuthStorage.getRefreshToken();

      expect(accessToken, equals('legacy_access_token'));
      expect(refreshToken, equals('legacy_refresh_token'));

      // Verify that tokens were removed from SharedPreferences after migration
      expect(prefs.getString('access_token'), isNull);
      expect(prefs.getString('refresh_token'), isNull);
    });

    test('clearSession removes tokens from secure storage and session from SharedPreferences', () async {
      await AuthStorage.saveAuthData(tokens: testTokens, user: testUser);
      await AuthStorage.setFirstCheckInCompleted(true);

      await AuthStorage.clearSession();

      final accessToken = await AuthStorage.getAccessToken();
      final refreshToken = await AuthStorage.getRefreshToken();
      final user = await AuthStorage.getUser();
      final firstCheckIn = await AuthStorage.isFirstCheckInCompleted();

      expect(accessToken, isNull);
      expect(refreshToken, isNull);
      expect(user, isNull);
      expect(firstCheckIn, isFalse);
    });

    test('ensureCleanInstall purges secure storage on fresh install, but preserves it on subsequent launches', () async {
      // Simulate leftover keychain tokens from a previous install
      await AuthStorage.saveAuthData(tokens: testTokens, user: testUser);

      // Simulate app uninstall (SharedPreferences cleared, but secure storage remains)
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Fresh launch: ensureCleanInstall should detect app_has_run_before is missing and purge secure storage
      await AuthStorage.ensureCleanInstall();

      expect(await AuthStorage.getAccessToken(), isNull);
      expect(await AuthStorage.getRefreshToken(), isNull);
      expect(prefs.getBool('app_has_run_before'), isTrue);

      // Subsequent login and normal restart
      await AuthStorage.saveAuthData(tokens: testTokens, user: testUser);
      await AuthStorage.ensureCleanInstall(); // app_has_run_before is true, so no-op

      expect(await AuthStorage.getAccessToken(), equals('mock_access_token_123'));
    });
  });
}
