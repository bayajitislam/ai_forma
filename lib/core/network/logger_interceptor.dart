import 'package:dio/dio.dart';
import 'package:flutter_devlog/flutter_devlog.dart';

/// This interceptor is used to show request and response logs
class LoggerInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    DevLog.error(
      'STATUSCODE: ${err.response?.statusCode} \n'
      'STATUSMESSAGE: ${err.response?.statusMessage} \n'
      'METHOD: ${err.requestOptions.method} \n'
      'URL: ${err.requestOptions.uri} \n'
      'Error type: ${err.error} \n'
      'Error message: ${err.message} \n'
      'REQUEST BODY: ${_formatRequestBody(err.requestOptions.data)} \n'
      'RESPONSE DATA: ${err.response?.data}',
    ); //Debug log
    if (err.response?.data != null) {
      try {
        DevLog.json(err.response?.data);
      } catch (_) {}
    }
    handler.next(err); //Continue with the Error
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requestPath = '${options.baseUrl}${options.path}';
    DevLog.api('${options.method} request ==> $requestPath'); //Info log
    if (options.data != null) {
      DevLog.info('REQUEST BODY (${options.method}):');
      _logData(options.data);
    }
    handler.next(options); // continue with the Request
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    DevLog.success(
      'STATUSCODE: ${response.statusCode} \n '
      'STATUSMESSAGE: ${response.statusMessage} \n',
      // 'HEADERS: ${response.headers} \n'
    ); // Debug log
    if (response.data != null) {
      try {
        DevLog.json(response.data);
      } catch (_) {
        DevLog.info('RESPONSE: ${response.data}');
      }
    }
    handler.next(response); // continue with the Response
  }

  void _logData(dynamic data) {
    if (data is FormData) {
      final fields = data.fields.map((f) => '${f.key}: ${f.value}').join(', ');
      final files = data.files.map((f) => '${f.key}: ${f.value.filename}').join(', ');
      DevLog.info('FormData -> Fields: [$fields] | Files: [$files]');
    } else if (data is Map || data is List) {
      try {
        DevLog.json(data);
      } catch (_) {
        DevLog.info(data.toString());
      }
    } else {
      DevLog.info(data.toString());
    }
  }

  String _formatRequestBody(dynamic data) {
    if (data == null) return 'null';
    if (data is FormData) {
      final fields = data.fields.map((f) => '${f.key}: ${f.value}').join(', ');
      final files = data.files.map((f) => '${f.key}: ${f.value.filename}').join(', ');
      return 'FormData(Fields: [$fields], Files: [$files])';
    }
    return data.toString();
  }
}
