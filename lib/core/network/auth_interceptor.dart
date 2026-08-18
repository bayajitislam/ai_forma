import 'package:ai_forma/core/constants/api_endpoint.dart';
import 'package:ai_forma/core/storage/auth_storage.dart';
import 'package:ai_forma/features/auth/controllers/user_controller.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:dio/dio.dart';
import 'package:flutter_devlog/flutter_devlog.dart';
import 'package:get/get.dart' hide Response;

class AuthInterceptor extends Interceptor {
  bool _isRefreshing = false;

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
    final isRefreshEndpoint = requestPath.contains('token/refresh') ||
        requestPath.contains('refresh');
    final isLoginEndpoint = requestPath.contains('login');

    if (isTokenExpired && !isRefreshEndpoint && !isLoginEndpoint) {
      final refreshToken = await AuthStorage.getRefreshToken();

      if (refreshToken != null && refreshToken.isNotEmpty && !_isRefreshing) {
        _isRefreshing = true;
        try {
          DevLog.api('Access token expired. Refreshing token...');

          final refreshDio = Dio(
            BaseOptions(
              baseUrl: ApiEndpoint.baseUrl,
              headers: {'Content-Type': 'application/json'},
            ),
          );

          Response? refreshResponse;
          try {
            refreshResponse = await refreshDio.post(
              ApiEndpoint.tokenRefresh,
              data: {'refresh': refreshToken},
            );
          } on DioException catch (e) {
            if (e.response?.statusCode == 404) {
              // Fallback to /api/token/refresh/ if /api/auth/token/refresh/ returns 404
              refreshResponse = await refreshDio.post(
                '/api/token/refresh/',
                data: {'refresh': refreshToken},
              );
            } else {
              rethrow;
            }
          }

          if (refreshResponse.statusCode == 200 &&
              refreshResponse.data != null) {
            final newAccessToken = refreshResponse.data['access']?.toString();
            final newRefreshToken = refreshResponse.data['refresh']?.toString();

            if (newAccessToken != null && newAccessToken.isNotEmpty) {
              DevLog.success('Token refreshed successfully!');

              await AuthStorage.updateTokens(
                access: newAccessToken,
                refresh: newRefreshToken,
              );

              _isRefreshing = false;

              // Retry original request with new token
              final opts = err.requestOptions;
              opts.headers['Authorization'] = 'Bearer $newAccessToken';

              final retryResponse = await refreshDio.fetch(opts);
              return handler.resolve(retryResponse);
            }
          }
        } catch (refreshErr) {
          DevLog.error('Failed to refresh token: $refreshErr');
        } finally {
          _isRefreshing = false;
        }
      }

      // If refresh token is missing, expired, or failed -> perform Logout & Navigate to LoginView
      await _handleLogout();
    }

    super.onError(err, handler);
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
