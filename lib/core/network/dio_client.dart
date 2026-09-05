import 'package:ai_forma/core/constants/api_endpoint.dart';
import 'package:ai_forma/core/network/auth_interceptor.dart';
import 'package:ai_forma/core/network/logger_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioClient {
  // Standard timeouts for normal API calls.
  static const Duration _kConnectTimeout = Duration(seconds: 30);
  static const Duration _kReceiveTimeout = Duration(seconds: 30);
  static const Duration _kSendTimeout = Duration(seconds: 30);

  // Extended timeouts for heavy multipart scan uploads and AI processing.
  static const Duration _kUploadSendTimeout = Duration(seconds: 120);
  static const Duration _kUploadReceiveTimeout = Duration(seconds: 120);

  /// Returns [Options] to pass to [post]/[put]/[patch] for multipart uploads.
  static Options uploadOptions({Map<String, dynamic>? headers}) {
    return Options(
      sendTimeout: _kUploadSendTimeout,
      receiveTimeout: _kUploadReceiveTimeout,
      headers: headers,
    );
  }

  DioClient() {
    // Dio Configuration
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoint.baseUrl,
        headers: {'Content-Type': 'application/json'},
        responseType: ResponseType.json,
        connectTimeout: _kConnectTimeout,
        receiveTimeout: _kReceiveTimeout,
        sendTimeout: _kSendTimeout,
      ),
    );
    _dio.interceptors.addAll([
      AuthInterceptor(),
      LoggerInterceptor(),
    ]);
  }

  late final Dio _dio;

  /// Exposed for unit tests that install a mock [HttpClientAdapter].
  @visibleForTesting
  Dio get dio => _dio;

  //Method
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException {
      rethrow;
    }
  }

  Future<Response> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException {
      rethrow;
    }
  }

  Future<Response> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException {
      rethrow;
    }
  }

  Future<Response> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException {
      rethrow;
    }
  }

  Future<Response> patch(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.patch(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException {
      rethrow;
    }
  }
}
