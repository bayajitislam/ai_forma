import 'package:dio/dio.dart';
import 'package:flutter_devlog/flutter_devlog.dart';

/// This interceptor is used to show request and response logs
class LoggerInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    DevLog.error(
      'STATUSCODE: ${err.response?.statusCode} \n'
      'STATUSMESSAGE: ${err.response?.statusMessage} \n'
      'Error type: ${err.error} \n '
      'Error message: ${err.message}',
    ); //Debug log
    handler.next(err); //Continue with the Error
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requestPath = '${options.baseUrl}${options.path}';
    DevLog.api('${options.method} request ==> $requestPath'); //Info log
    handler.next(options); // continue with the Request
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    DevLog.success(
      'STATUSCODE: ${response.statusCode} \n '
      'STATUSMESSAGE: ${response.statusMessage} \n',
      // 'HEADERS: ${response.headers} \n'
    ); // Debug log
    DevLog.json(response.data);
    handler.next(response); // continue with the Response
  }
}
