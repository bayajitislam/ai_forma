import 'package:ai_forma/core/constants/api_endpoint.dart';
import 'package:ai_forma/core/storage/auth_storage.dart';
import 'package:ai_forma/features/auth/controllers/user_controller.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:dio/dio.dart';
import 'package:flutter_devlog/flutter_devlog.dart';
import 'package:get/get.dart' hide Response;

class AuthInterceptor extends Interceptor {
  /// Shared Future for any in-progress token refresh.
  /// All concurrent 401s await this same Future so only one refresh
  /// network call is made and none of them race to logout incorrectly.
  Future<String?>? _refreshFuture;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await AuthStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    final data = err.response?.data;

    bool isTokenExpired = false;

    if (statusCode == 401) {
      isTokenExpired = true;
    } else if (data is Map<String, dynamic>) {
      final code = data['code']?.toString();
      final detail = data['detail']?.toString();
      if (code == 'token_not_valid' ||
          (detail != null && detail.contains('token_not_valid')) ||
          (detail != null && detail.contains('Given token not valid'))) {
        isTokenExpired = true;
      }
    }

    final requestPath = err.requestOptions.path;
    final isRefreshEndpoint =
        requestPath.contains('token/refresh') || requestPath.contains('refresh');
    final isLoginEndpoint = requestPath.contains('login');

    if (isTokenExpired && !isRefreshEndpoint && !isLoginEndpoint) {
      final refreshToken = await AuthStorage.getRefreshToken();

      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          // Queue: if a refresh is already in-flight, await that same Future.
          // This means 5 concurrent 401s produce exactly 1 network refresh call.
          _refreshFuture ??= _doRefresh(refreshToken).whenComplete(() {
            _refreshFuture = null;
          });

          final newAccessToken = await _refreshFuture;

          if (newAccessToken != null) {
            // Retry original request with the fresh token
            final opts = err.requestOptions;
            opts.headers['Authorization'] = 'Bearer $newAccessToken';

            final retryDio = Dio(
              BaseOptions(
                baseUrl: ApiEndpoint.baseUrl,
                headers: {'Content-Type': 'application/json'},
              ),
            );
            final retryResponse = await retryDio.fetch(opts);
            return handler.resolve(retryResponse);
          }
        } catch (e) {
          DevLog.error('Token refresh failed during retry: $e');
        }
      }

      // Refresh token missing, expired, or refresh call failed — logout
      await _handleLogout();
    }

    super.onError(err, handler);
  }

  /// Performs the actual refresh network call and persists the new tokens.
  /// Returns the new access token on success, or throws on failure.
  Future<String?> _doRefresh(String refreshToken) async {
    DevLog.api('Access token expired. Refreshing token...');

    final refreshDio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoint.baseUrl,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    Response? response;
    try {
      response = await refreshDio.post(
        ApiEndpoint.tokenRefresh,
        data: {'refresh': refreshToken},
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Fallback endpoint
        response = await refreshDio.post(
          '/api/token/refresh/',
          data: {'refresh': refreshToken},
        );
      } else {
        rethrow;
      }
    }

    if (response.statusCode == 200 && response.data != null) {
      final newAccess = response.data['access']?.toString();
      final newRefresh = response.data['refresh']?.toString();

      if (newAccess != null && newAccess.isNotEmpty) {
        DevLog.success('Token refreshed successfully!');
        await AuthStorage.updateTokens(access: newAccess, refresh: newRefresh);
        return newAccess;
      }
    }

    return null;
  }

  Future<void> _handleLogout() async {
    DevLog.error('Session expired or invalid token. Logging out...');
    await AuthStorage.clearSession();
    if (Get.isRegistered<UserController>()) {
      Get.find<UserController>().currentUser.value = null;
    }
    Get.offAllNamed(RoutesName.login);
  }
}
